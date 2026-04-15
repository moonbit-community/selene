///|
async fn EditorService::open_project(
  self : EditorService,
  root : String,
) -> @shared.ProjectStateResponse {
  let loaded_manifest = load_project_manifest(root) catch {
    MissingProjectManifest(_) => {
      ensure_project_layout(root)
      let created = @editor_bridge.ProjectManifest::default(
        inferred_project_name(root),
      )
      ignore(
        save_scene_document(
          root,
          created.startup_scene,
          @editor_bridge.SceneDocument::default_main(),
        ),
      )
      save_project_manifest(root, created)
      created
    }
    err => raise err
  }
  let scenes = list_scene_documents(root)
  let prefabs = list_prefab_documents(root)
  let atlases = list_atlas_asset_documents(root)
  let animation_clips = list_animation_clip_asset_documents(root)
  let animation_graphs = list_animation_graph_asset_documents(root)
  let manifest = loaded_manifest.with_indexes(
    scenes, prefabs, atlases, animation_clips, animation_graphs,
  )
  if manifest != loaded_manifest {
    save_project_manifest(root, manifest)
  }
  let snapshot = snapshot_project_files(root, manifest)
  let workspace = load_workspace_document(root)
  self.current_project = Some({ root, manifest, snapshot })
  self.add_recent_project(root)
  self.broadcast(
    @shared.event_envelope(@shared.editor_event_project_opened(root, manifest)),
  )
  @shared.project_state_response(
    Some(root),
    Some(manifest),
    scenes,
    prefabs,
    atlases,
    animation_clips,
    animation_graphs,
    Some(workspace),
    self.recent_projects,
  )
}
