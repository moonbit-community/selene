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
    SetProjectRootInput(value) => ([], { ..model, project_root_input: value })
    SetProjectNameInput(value) => ([], { ..model, project_name_input: value })
    PickProjectRoot =>
      (
        [
          rpc_effect(
            ProjectRootPicked,
            @shared.rpc_request_project_pick_directory(
              "Choose a project folder",
            ),
          ),
        ],
        { ..model, status: "Choosing project folder..." },
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
    ProjectRootPicked(result) =>
      match result {
        Ok(response) =>
          match response.path {
            Some(path) => {
              let root = normalized_project_root(path)
              (
                [
                  rpc_effect(
                    ProjectLoaded,
                    @shared.rpc_request_project_open(root),
                  ),
                ],
                {
                  ..model,
                  project_root_input: root,
                  status: "Opening project...",
                },
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
    ProjectLoaded(result) =>
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
                model.scene_path,
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
                scene_path,
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
                undo_stack: [],
                redo_stack: [],
                active_scene_edit_transaction: None,
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
    SceneLoaded(result) =>
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
          let next = {
            ..model,
            scene_path: response.path,
            scene: Some(response.scene),
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
            undo_stack: [],
            redo_stack: [],
            active_scene_edit_transaction: None,
            status,
          }
          (sync_preview_effects_with_scene(next), next)
        }
        Ok(@shared.MigrationRequired(preview)) => {
          let next = {
            ..model,
            scene_path: preview.path,
            scene: None,
            selected_entity_id: None,
            selected_entity_ids: [],
            pending_scene_migration: Some(preview),
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
            undo_stack: [],
            redo_stack: [],
            active_scene_edit_transaction: None,
            status: "Scene format migration required (SNF v1)",
          }
          let cleared = next.workspace
            .with_last_scene(Some(preview.path))
            .with_selected_entity_id(None)
          (
            [Preview(@bridge.preview_command_clear_scene())],
            { ..next, workspace: cleared },
          )
        }
        Err(message) => {
          ignore(message)
          let next = push_log(model, scene_load_failed_message())
          ([], { ..next, status: scene_load_failed_message() })
        }
      }
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
          scene: None,
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
          undo_stack: [],
          redo_stack: [],
          active_scene_edit_transaction: None,
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
          model.scene_path,
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
            model.scene_path,
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
              model.scene_path,
            ) {
            model.scene_path
          } else {
            preferred_scene_path(
              manifest,
              response.scenes,
              model.workspace,
              model.scene_path,
            )
          }
          let next = {
            ..model,
            manifest,
            scene_refs: response.scenes,
            scene_path: next_scene_path,
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
    SceneSaved(result) =>
      match result {
        Ok(_) => ([], { ..model, status: save_success_status(model) })
        Err(message) => {
          let next = push_log(model, "Save failed: " + message)
          ([], { ..next, status: "Save failed: " + message })
        }
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
    ServiceEvent(result) =>
      match result {
        Ok(event) =>
          match event {
            @shared.Ready => ([], model)
            @shared.Log(label~, message~) =>
              ([], push_log(model, "[\{label}] \{message}"))
            @shared.FilesChanged(_)
            | @shared.SceneSaved(_)
            | @shared.AnimationClipSaved(_)
            | @shared.AnimationGraphSaved(_)
            | @shared.AnimationMigrated(..)
            | @shared.AssetImported(_) =>
              (
                [
                  rpc_effect(
                    ProjectLoaded,
                    @shared.rpc_request_project_current(),
                  ),
                ],
                model,
              )
            @shared.ProjectOpened(..)
            | @shared.SceneCreated(..)
            | @shared.SceneDeleted(..) => ([], model)
          }
        Err(message) => {
          let next = push_log(model, "SSE error: " + message)
          ([], { ..next, status: "SSE error" })
        }
      }
    PreviewEvent(event) =>
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
          let next = with_started_scene_edit_transaction(
            {
              ..with_single_entity_selection(model, Some(id)),
              selected_resource: None,
            },
            "Transform",
          )
          ([], next)
        }
        @bridge.TransformChanged(id~, translation~, rotation~, scale~) =>
          match model.scene {
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
              let selected_next = with_single_entity_selection(next, Some(id))
              apply_scene_change_without_history_or_preview(model, {
                ..selected_next,
                selected_resource: None,
              })
            }
            _ => ([], model)
          }
        @bridge.TransformGestureFinished(id~) => {
          let committed = with_committed_scene_edit_transaction(model)
          let status = match model.active_scene_edit_transaction {
            Some(transaction) => transaction.label + " applied"
            None => "Transform applied"
          }
          let next = {
            ..with_single_entity_selection(committed, Some(id)),
            status,
          }
          (sync_preview_effects(next), next)
        }
        @bridge.AutoTileLayerChanged(id~, component~) =>
          match model.scene {
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
}
