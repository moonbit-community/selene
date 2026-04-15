///|
fn sort_unique_paths(values : Array[String]) -> Array[String] {
  let seen : Map[String, Bool] = {}
  let ordered : Array[String] = []
  for value in values {
    if seen.contains(value) {
      continue
    }
    seen.set(value, true)
    ordered.push(value)
  }
  ordered.sort_by(fn(left, right) { left.compare(right) })
  ordered
}

///|
pub async fn EditorService::watch_loop(self : EditorService) -> Unit {
  for ;; {
    if self.current_project is Some(project) {
      let next_snapshot = snapshot_project_files(project.root, project.manifest) catch {
        _ => {
          @async.sleep(1000)
          continue
        }
      }
      let changed : Array[String] = []
      for path, stamp in next_snapshot {
        if !project.snapshot.contains(path) || project.snapshot[path] != stamp {
          changed.push(path)
        }
      }
      for path, _ in project.snapshot {
        if !next_snapshot.contains(path) {
          changed.push(path)
        }
      }
      if !changed.is_empty() {
        project.snapshot = next_snapshot
        let unique_changed = sort_unique_paths(changed)
        let mut workspace_changed = false
        let mut manifest_changed = false
        let scene_paths : Array[String] = []
        let asset_paths : Array[String] = []
        for path in unique_changed {
          if path.has_prefix(".selene-editor/") {
            workspace_changed = true
          } else if path == "selene.project.json" ||
            path.has_suffix(".project.json") {
            manifest_changed = true
          } else if path.has_prefix("scenes/") && path.has_suffix(".scene.json") {
            scene_paths.push(path)
          } else if path.has_prefix("assets/") {
            asset_paths.push(path)
          }
        }
        if workspace_changed {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_workspace_changed(),
              ),
            ),
          )
        }
        if manifest_changed {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_manifest_changed(),
              ),
            ),
          )
        }
        for path in sort_unique_paths(scene_paths) {
          let state = scene_disk_state(project.root, path) catch {
            _ => { hash: "", revision: 0 }
          }
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_scene_file_changed(
                  path,
                  state.hash,
                  state.revision,
                ),
              ),
            ),
          )
        }
        for path in sort_unique_paths(asset_paths) {
          self.broadcast(
            @shared.event_envelope(
              @shared.editor_event_project_delta(
                @shared.project_delta_asset_file_changed(path),
              ),
            ),
          )
        }
      }
    }
    @async.sleep(1000)
  }
}
