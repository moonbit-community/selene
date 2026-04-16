///|
fn handle_project_root_picked(
  result : Result[@shared.DirectoryPickResult, String],
  model : Model,
) -> (Array[Effect], Model) {
  match result {
    Ok(response) =>
      match response.path {
        Some(path) => {
          let root = normalized_project_root(path)
          (
            [rpc_effect(ProjectLoaded, @shared.rpc_request_project_open(root))],
            { ..model, project_root_input: root, status: "Opening project..." },
          )
        }
        None => ([], { ..model, status: "Open a project to begin" })
      }
    Err(message) => {
      ignore(message)
      let next = push_log(model, folder_picker_failed_message())
      ([], { ..next, status: folder_picker_failed_message() })
    }
  }
}

///|
fn handle_project_loaded(
  result : Result[@shared.ProjectStateResponse, String],
  model : Model,
) -> (Array[Effect], Model) {
  match result {
    Ok(response) =>
      match response.workspace {
        Some(loaded_workspace) => {
          let scene_refs = response.scenes
          let prefab_refs = response.prefabs
          let atlas_refs = response.atlases
          let animation_clip_refs = response.animation_clips
          let animation_graph_refs = response.animation_graphs
          let move_snap_enabled = loaded_workspace.move_snap_enabled_or_default()
          let move_snap_step = nearest_move_snap_step(
            loaded_workspace.move_snap_step_or_default(),
          )
          let workspace = loaded_workspace
            .with_move_snap_enabled(move_snap_enabled)
            .with_move_snap_step(move_snap_step)
          let scene_path = preferred_scene_path(
            response.manifest,
            scene_refs,
            workspace,
            model_scene_path(model),
          )
          let status = match response.root {
            Some(root) => "Project: " + root
            None => "Choose a project folder to begin"
          }
          let project_root_input = response.root.unwrap_or(
            model.project_root_input,
          )
          let next = {
            ..model,
            current_root: response.root,
            manifest: response.manifest,
            scene_refs,
            prefab_refs,
            atlas_refs,
            animation_clip_refs,
            animation_graph_refs,
            workspace,
            recent_projects: response.recent_projects,
            project_root_input,
            pending_scene_migration: None,
            pending_animation_migration_paths: [],
            pending_animation_migration_scene_path: None,
            animation_migration_in_progress: false,
            animation_migration_total: 0,
            animation_migration_completed: 0,
            animation_migration_failed: 0,
            animation_migration_prompt_dismissed: false,
            add_component_panel_open: false,
            component_search_query: "",
            open_component_menu_kind: None,
            scene_session: model.scene_session.map(fn(session) {
              { ..session, path: scene_path }
            }),
            status,
            move_snap_enabled,
            move_snap_step,
            selected_entity_id: None,
            selected_entity_ids: [],
          }
          (refresh_project_effects(next), next)
        }
        None => {
          let next = push_log(
            model, "Project response is missing workspace state.",
          )
          ([], { ..next, status: project_open_failed_message() })
        }
      }
    Err(message) => {
      ignore(message)
      let next = push_log(model, project_open_failed_message())
      ([], { ..next, status: project_open_failed_message() })
    }
  }
}

///|
fn handle_scene_loaded(
  result : Result[@shared.SceneLoadOutcome, String],
  model : Model,
) -> (Array[Effect], Model) {
  match result {
    Ok(@shared.Loaded(response)) => {
      let atlas_documents = model.atlas_documents
      let atlas_refs = model.atlas_refs
      for entry in response.atlas_assets {
        atlas_documents.set(entry.path, entry.atlas)
        if !asset_ref_exists(atlas_refs, entry.path) {
          atlas_refs.push(@editor_bridge.asset_ref(entry.path))
        }
      }
      let animation_clip_documents = model.animation_clip_documents
      let animation_clip_refs = model.animation_clip_refs
      for entry in response.animation_clip_assets {
        animation_clip_documents.set(entry.path, entry.clip)
        if !asset_ref_exists(animation_clip_refs, entry.path) {
          animation_clip_refs.push(@editor_bridge.asset_ref(entry.path))
        }
      }
      let animation_graph_documents = model.animation_graph_documents
      let animation_graph_refs = model.animation_graph_refs
      for entry in response.animation_graph_assets {
        animation_graph_documents.set(entry.path, entry.graph)
        if !asset_ref_exists(animation_graph_refs, entry.path) {
          animation_graph_refs.push(@editor_bridge.asset_ref(entry.path))
        }
      }
      let loaded_workspace = model.workspace.with_last_scene(
        Some(response.path),
      )
      let (selected_entity_id, selected_entity_ids) = restored_entity_selection_for_scene(
        response.scene,
        loaded_workspace.selected_entity_id,
        model.selected_entity_ids,
      )
      let workspace = loaded_workspace.with_selected_entity_id(
        selected_entity_id,
      )
      let legacy_animation_paths = legacy_animation_paths_in_scene(
        response.scene,
      )
      let pending_animation_migration_paths = if model.animation_migration_prompt_dismissed {
        []
      } else {
        let merged = model.pending_animation_migration_paths
        for path in legacy_animation_paths {
          if !merged.contains(path) {
            merged.push(path)
          }
        }
        merged
      }
      let pending_animation_migration_scene_path = if pending_animation_migration_paths.is_empty() {
        None
      } else {
        Some(response.path)
      }
      let status = if pending_animation_migration_paths.is_empty() {
        "Loaded " + response.path
      } else {
        "Legacy animations detected. Migration required before use."
      }
      let loaded = with_loaded_scene_session(
        model,
        response.path,
        response.scene,
        response.disk_hash,
        response.disk_revision,
      )
      let next = {
        ..loaded,
        workspace,
        atlas_documents,
        atlas_refs,
        animation_clip_documents,
        animation_graph_documents,
        animation_clip_refs,
        animation_graph_refs,
        selected_entity_id,
        selected_entity_ids,
        pending_scene_migration: None,
        pending_animation_migration_paths,
        pending_animation_migration_scene_path,
        animation_migration_in_progress: false,
        animation_migration_total: pending_animation_migration_paths.length(),
        animation_migration_completed: 0,
        animation_migration_failed: 0,
        add_component_panel_open: false,
        component_search_query: "",
        open_component_menu_kind: None,
        status,
      }
      (sync_preview_effects_with_scene(next), next)
    }
    Err(message) => {
      ignore(message)
      let next = push_log(model, scene_load_failed_message())
      ([], { ..next, status: scene_load_failed_message() })
    }
  }
}

///|
fn handle_scene_saved(
  result : Result[SceneSaveOutcome, String],
  model : Model,
) -> (Array[Effect], Model) {
  match result {
    Ok(Saved(save)) => {
      let next = match model.scene_session {
        Some(session) =>
          {
            ..model,
            scene_session: Some({
              ..session,
              dirty: false,
              base_hash: save.disk_hash,
              base_revision: save.disk_revision,
              last_saved_at: save.disk_revision,
              conflict_state: SceneConflictState::NoConflict,
            }),
          }
        None => model
      }
      ([], { ..next, status: save_success_status(next) })
    }
    Ok(Conflict(conflict)) => {
      let next = match model.scene_session {
        Some(session) if session.path == conflict.path =>
          {
            ..model,
            scene_session: Some({
              ..session,
              conflict_state: SaveConflict(
                path=conflict.path,
                base_hash=conflict.base_hash,
                current_hash=conflict.current_hash,
                base_revision=conflict.base_revision,
                current_revision=conflict.current_revision,
              ),
            }),
          }
        _ => model
      }
      (
        [],
        {
          ..push_log(
            next,
            "Save conflict on " +
            conflict.path +
            ". Reload or keep local edits.",
          ),
          status: "Save conflict detected for " + conflict.path,
        },
      )
    }
    Err(message) => {
      let next = push_log(model, "Save failed: " + message)
      ([], { ..next, status: "Save failed: " + message })
    }
  }
}

///|
fn handle_service_event(
  result : Result[@shared.EditorEvent, String],
  model : Model,
) -> (Array[Effect], Model) {
  match result {
    Ok(event) =>
      match event {
        @shared.Ready => ([], model)
        @shared.Log(label~, message~) =>
          ([], push_log(model, "[\{label}] \{message}"))
        @shared.ProjectDelta(delta~) =>
          match delta {
            @shared.WorkspaceChanged =>
              ([], { ..model, status: "Workspace settings updated" })
            @shared.ManifestChanged =>
              (
                [rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list())],
                { ..model, status: "Project manifest changed" },
              )
            @shared.AssetFileChanged(_) =>
              (
                [rpc_effect(AssetsLoaded, @shared.rpc_request_assets_list())],
                model,
              )
            @shared.SceneFileChanged(path~, disk_hash~, disk_revision~) =>
              match model.scene_session {
                Some(session) if session.path == path && session.dirty => {
                  let next = {
                    ..model,
                    scene_session: Some({
                      ..session,
                      conflict_state: ExternalSceneChanged(
                        path~,
                        disk_hash~,
                        disk_revision~,
                      ),
                    }),
                    status: "Scene changed on disk while local edits are unsaved",
                  }
                  ([], next)
                }
                Some(session) if session.path == path =>
                  (
                    [
                      rpc_effect(
                        SceneLoaded,
                        @shared.rpc_request_scene_load(path),
                      ),
                    ],
                    { ..model, status: "Reloading changed scene..." },
                  )
                _ =>
                  (
                    [
                      rpc_effect(
                        SceneListLoaded,
                        @shared.rpc_request_scene_list(),
                      ),
                    ],
                    model,
                  )
              }
          }
        @shared.SceneSaved(_)
        | @shared.AnimationClipSaved(_)
        | @shared.AnimationGraphSaved(_)
        | @shared.AnimationMigrated(..)
        | @shared.AssetImported(_) => ([], model)
        @shared.ProjectOpened(..)
        | @shared.SceneCreated(..)
        | @shared.SceneDeleted(..) => ([], model)
      }
    Err(message) => {
      let next = push_log(model, "SSE error: " + message)
      ([], { ..next, status: "SSE error" })
    }
  }
}

///|
fn handle_preview_event(
  event : @bridge.PreviewEvent,
  model : Model,
) -> (Array[Effect], Model) {
  match event {
    @bridge.SelectionChanged(primary~, ids~) => {
      let selected = with_entity_selection(model, primary, ids)
      let next = {
        ..selected,
        selected_resource: if selected.has_entity_selection() {
          None
        } else {
          model.selected_resource
        },
        autotile_palette_json_draft: "",
        autotile_palette_json_error: None,
      }
      ([], next)
    }
    @bridge.HoverChanged(_) => ([], model)
    @bridge.TransformGestureStarted(id~) => {
      let next_selection = if model.selected_entity_ids.contains(id) {
        with_entity_selection(model, Some(id), model.selected_entity_ids)
      } else {
        with_single_entity_selection(model, Some(id))
      }
      let next = with_started_scene_edit_transaction(
        { ..next_selection, selected_resource: None },
        "Transform",
      )
      ([], next)
    }
    @bridge.TransformChanged(id~, translation~, rotation~, scale~) =>
      match model_scene(model) {
        Some(_) => {
          let next = update_entity_component(
            model,
            id,
            @editor_bridge.transform2d_component(
              translation~,
              rotation~,
              scale~,
            ),
          )
          let selected_next = if model.selected_entity_ids.contains(id) {
            with_entity_selection(
              next,
              model.selected_entity_id,
              model.selected_entity_ids,
            )
          } else {
            with_single_entity_selection(next, Some(id))
          }
          apply_scene_change_without_history_or_preview(model, {
            ..selected_next,
            selected_resource: None,
          })
        }
        _ => ([], model)
      }
    @bridge.TransformGestureFinished(id~) => {
      let committed = with_committed_scene_edit_transaction(model)
      let status = match model.scene_session {
        Some(session) =>
          match session.active_scene_edit_transaction {
            Some(transaction) => transaction.label + " applied"
            None => "Transform applied"
          }
        None => "Transform applied"
      }
      let next = if model.selected_entity_ids.contains(id) {
        {
          ..with_entity_selection(
            committed,
            model.selected_entity_id,
            model.selected_entity_ids,
          ),
          status,
        }
      } else {
        { ..with_single_entity_selection(committed, Some(id)), status, }
      }
      (sync_preview_effects(next), next)
    }
    @bridge.AutoTileLayerChanged(id~, component~) =>
      match model_scene(model) {
        Some(_) => {
          let staged = with_started_scene_edit_transaction(
            model, "Edit AutoTile Layer",
          )
          let next = update_entity_component(
            staged,
            id,
            @editor_bridge.component_document(
              "AutoTileLayer2d",
              component.to_json(),
            ),
          )
          let selected_next = with_single_entity_selection(next, Some(id))
          apply_scene_change_without_history_or_preview(model, {
            ..selected_next,
            selected_resource: None,
            status: "AutoTile layer updated",
          })
        }
        None => ([], model)
      }
  }
}
