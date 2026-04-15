///|
fn update_project_runtime(
  msg : ProjectRuntimeMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
    Initialize =>
      (
        [
          SubscribeServiceEvents,
          SubscribePreviewEvents,
          SubscribeKeyboardShortcuts,
          rpc_effect(ProjectLoaded, @shared.rpc_request_project_current()),
        ],
        model,
      )
    OpenProject =>
      (
        [
          rpc_effect(
            ProjectRootPicked,
            @shared.rpc_request_project_pick_directory("Open a Selene project"),
          ),
        ],
        { ..model, status: "Choose a project folder..." },
      )
    ProjectRootPicked(result) => handle_project_root_picked(result, model)
    ProjectLoaded(result) => handle_project_loaded(result, model)
    SceneLoaded(result) => handle_scene_loaded(result, model)
    ConfirmSceneMigration =>
      match model.pending_scene_migration {
        Some(preview) =>
          (
            [
              rpc_effect(
                SceneLoaded,
                @shared.rpc_request_scene_migrate(preview.path),
              ),
            ],
            { ..model, status: "Migrating " + preview.path + "..." },
          )
        None => ([], model)
      }
    CancelSceneMigration => {
      let workspace = model.workspace.with_selected_entity_id(None)
      (
        [Preview(@bridge.preview_command_clear_scene())],
        {
          ..model,
          scene_session: None,
          selected_entity_id: None,
          selected_entity_ids: [],
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
          workspace,
          status: "Scene migration cancelled",
        },
      )
    }
    ConfirmAnimationMigration =>
      if model.animation_migration_in_progress {
        ([], model)
      } else if model.pending_animation_migration_paths.is_empty() {
        ([], { ..model, status: "No legacy animation files to migrate" })
      } else {
        let scene_path = model.pending_animation_migration_scene_path.unwrap_or(
          model_scene_path(model),
        )
        let first_path = model.pending_animation_migration_paths[0]
        (
          [
            rpc_effect(
              AnimationMigrationSaved,
              @shared.rpc_request_animation_migrate(first_path, scene_path),
            ),
          ],
          {
            ..model,
            animation_migration_in_progress: true,
            animation_migration_total: model.pending_animation_migration_paths.length(),
            animation_migration_completed: 0,
            animation_migration_failed: 0,
            animation_migration_prompt_dismissed: false,
            status: "Migrating legacy animations (0/\{model.pending_animation_migration_paths.length()})...",
          },
        )
      }
    CancelAnimationMigration =>
      if model.animation_migration_in_progress {
        (
          [],
          {
            ..model,
            status: "Animation migration is running. Wait for completion.",
          },
        )
      } else {
        (
          [],
          {
            ..model,
            pending_animation_migration_paths: [],
            pending_animation_migration_scene_path: None,
            animation_migration_in_progress: false,
            animation_migration_total: 0,
            animation_migration_completed: 0,
            animation_migration_failed: 0,
            animation_migration_prompt_dismissed: true,
            status: "Animation migration cancelled",
          },
        )
      }
    AnimationMigrationSaved(result) =>
      if !model.animation_migration_in_progress ||
        model.pending_animation_migration_paths.is_empty() {
        ([], model)
      } else {
        let current_index = model.animation_migration_completed
        let total = model.animation_migration_total
        let current_path = if current_index <
          model.pending_animation_migration_paths.length() {
          model.pending_animation_migration_paths[current_index]
        } else {
          "(unknown)"
        }
        let failed = match result {
          Ok(_) => model.animation_migration_failed
          Err(_) => model.animation_migration_failed + 1
        }
        let completed = model.animation_migration_completed + 1
        let with_log = match result {
          Ok(_) => model
          Err(message) =>
            push_log(
              model,
              "Animation migration failed for \{current_path}: \{message}",
            )
        }
        let in_progress = completed < total
        if in_progress {
          let scene_path = model.pending_animation_migration_scene_path.unwrap_or(
            model_scene_path(model),
          )
          let next_path = model.pending_animation_migration_paths[completed]
          (
            [
              rpc_effect(
                AnimationMigrationSaved,
                @shared.rpc_request_animation_migrate(next_path, scene_path),
              ),
            ],
            {
              ..with_log,
              animation_migration_failed: failed,
              animation_migration_completed: completed,
              status: "Migrating legacy animations (\{completed}/\{total})...",
            },
          )
        } else {
          let next = {
            ..with_log,
            pending_animation_migration_paths: [],
            pending_animation_migration_scene_path: None,
            animation_migration_in_progress: false,
            animation_migration_total: 0,
            animation_migration_completed: 0,
            animation_migration_failed: 0,
            animation_migration_prompt_dismissed: false,
            status: if failed == 0 {
              "Legacy animation migration complete"
            } else {
              "Legacy animation migration finished with \{failed} failures"
            },
          }
          let effects = if failed == 0 {
            refresh_project_effects(next)
          } else {
            []
          }
          (effects, next)
        }
      }
    SceneListLoaded(result) =>
      match result {
        Ok(response) => {
          let manifest = model.manifest.map(fn(value) {
            value.with_startup_scene(response.startup_scene)
          })
          let next_scene_path = if scene_path_exists(
              response.scenes,
              model_scene_path(model),
            ) {
            model_scene_path(model)
          } else {
            preferred_scene_path(
              manifest,
              response.scenes,
              model.workspace,
              model_scene_path(model),
            )
          }
          let next = {
            ..model,
            manifest,
            scene_refs: response.scenes,
            scene_session: model.scene_session.map(fn(session) {
              { ..session, path: next_scene_path }
            }),
          }
          ([], next)
        }
        Err(message) => {
          let next = push_log(model, "Scene list failed: " + message)
          ([], { ..next, status: "Scene list failed: " + message })
        }
      }
    AssetsLoaded(result) =>
      match result {
        Ok(response) => {
          let selected_resource = match model.selected_resource {
            Some(selection) if resource_exists(
                { ..model, assets: response.assets },
                selection,
              ) => Some(selection)
            _ => None
          }
          (
            [],
            {
              ..model,
              assets: response.assets,
              selected_resource,
              asset_tree_expanded: with_asset_tree_expanded_for_selection(
                model.asset_tree_expanded,
                selected_resource,
              ),
            },
          )
        }
        Err(message) => {
          let next = push_log(model, "Assets load failed: " + message)
          ([], { ..next, status: "Assets load failed: " + message })
        }
      }
    PrefabLoaded(result) =>
      match result {
        Ok(response) => {
          let prefab_documents = model.prefab_documents
          prefab_documents.set(response.path, response.prefab)
          ([], { ..model, prefab_documents, })
        }
        Err(message) => {
          let next = push_log(model, "Prefab load failed: " + message)
          ([], { ..next, status: "Prefab load failed: " + message })
        }
      }
    AtlasLoaded(result) =>
      match result {
        Ok(response) => {
          let atlas_documents = model.atlas_documents
          atlas_documents.set(response.path, response.atlas)
          let next = { ..model, atlas_documents, }
          (sync_preview_effects_with_scene(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Atlas load failed: " + message)
          ([], { ..next, status: "Atlas load failed: " + message })
        }
      }
    AnimationClipLoaded(result) =>
      match result {
        Ok(response) => {
          let animation_clip_documents = model.animation_clip_documents
          animation_clip_documents.set(response.path, response.clip)
          let next = { ..model, animation_clip_documents, }
          (sync_preview_effects_with_scene(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Animation clip load failed: " + message)
          ([], { ..next, status: "Animation clip load failed: " + message })
        }
      }
    AnimationGraphLoaded(result) =>
      match result {
        Ok(response) => {
          let animation_graph_documents = model.animation_graph_documents
          animation_graph_documents.set(response.path, response.graph)
          let next = { ..model, animation_graph_documents, }
          (sync_preview_effects_with_scene(next), next)
        }
        Err(message) => {
          let next = push_log(model, "Animation graph load failed: " + message)
          ([], { ..next, status: "Animation graph load failed: " + message })
        }
      }
    AssetSizeResolved(path, width, height) =>
      if width > 0.0 && height > 0.0 {
        let asset_sizes = model.asset_sizes
        asset_sizes.set(path, @editor_bridge.vec2_doc(width, height))
        let failed_image_assets = model.failed_image_assets
        failed_image_assets.remove(path) |> ignore
        ([], { ..model, asset_sizes, failed_image_assets })
      } else {
        ([], model)
      }
    AssetImageLoadFailed(path) => {
      let failed_image_assets = model.failed_image_assets
      failed_image_assets.set(path, true)
      ([], { ..model, failed_image_assets, })
    }
    SetAssetQuery(value) => {
      let trimmed = value.trim().to_string()
      let next_selected_resource = match model.selected_resource {
        Some(selection) => {
          let preview_model = { ..model, asset_query: value }
          let visible = visible_resources_in_order(preview_model)
          if resource_index(visible, selection) is Some(_) {
            Some(selection)
          } else {
            None
          }
        }
        None => None
      }
      (
        [],
        {
          ..model,
          asset_query: value,
          selected_resource: next_selected_resource,
          status: if trimmed == "" {
            "Asset filter cleared"
          } else if model.selected_resource is Some(_) &&
            next_selected_resource is None {
            "Filtering assets: " + trimmed + " (selection cleared)"
          } else {
            "Filtering assets: " + trimmed
          },
        },
      )
    }
    SceneSaved(result) => handle_scene_saved(result, model)
    ResolveSceneConflictKeepMine =>
      match model.scene_session {
        Some(session) =>
          (
            [],
            {
              ..model,
              scene_session: Some({
                ..session,
                conflict_state: SceneConflictState::NoConflict,
              }),
              status: "Keeping local scene edits",
            },
          )
        None => ([], model)
      }
    ResolveSceneConflictReloadDisk =>
      match model.scene_session {
        Some(session) =>
          (
            [
              rpc_effect(
                SceneLoaded,
                @shared.rpc_request_scene_load(session.path),
              ),
            ],
            {
              ..model,
              scene_session: Some({
                ..session,
                conflict_state: SceneConflictState::NoConflict,
              }),
              status: "Reloading scene from disk...",
            },
          )
        None => ([], model)
      }
    ResolveSceneConflictSaveAs(path) =>
      match model.scene_session {
        Some(session) => {
          let trimmed = path.trim().to_string()
          if trimmed == "" {
            let next = push_log(model, "Save As path is required")
            ([], { ..next, status: "Save As path is required" })
          } else {
            let save_path = if trimmed.has_suffix(".scene.json") {
              trimmed
            } else {
              trimmed + ".scene.json"
            }
            let next = {
              ..model,
              scene_session: Some({
                ..session,
                path: save_path,
                conflict_state: SceneConflictState::NoConflict,
              }),
              status: "Saving conflict copy...",
            }
            (
              [
                rpc_effect(
                  SceneSaved,
                  @shared.rpc_request_scene_save(
                    save_path,
                    session.scene,
                    "",
                    0,
                  ),
                ),
                rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
              ],
              next,
            )
          }
        }
        None => ([], model)
      }
    WorkspaceSaved(result) =>
      match result {
        Ok(_) => ([], model)
        Err(message) => {
          let next = push_log(model, "Workspace save failed: " + message)
          (
            [],
            {
              ..next,
              status: "Workspace save failed. Check browser console for details.",
            },
          )
        }
      }
    ServiceEvent(result) => handle_service_event(result, model)
    PreviewEvent(event) => handle_preview_event(event, model)
  }
}
