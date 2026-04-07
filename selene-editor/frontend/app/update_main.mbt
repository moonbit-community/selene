///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  let model = if is_scene_edit_continuation(msg) {
    model
  } else {
    with_committed_scene_edit_transaction(model)
  }
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
      }
    SetHoverHint(hint) => ([], { ..model, hover_hint: hint })
    ToggleAssetTreeFolder(key) => {
      let asset_tree_expanded = model.asset_tree_expanded
      let next_value = !model.asset_tree_folder_expanded(key)
      asset_tree_expanded.set(key, next_value)
      ([], { ..model, asset_tree_expanded, })
    }
    ExpandAllAssetFolders =>
      (
        [],
        {
          ..model,
          asset_tree_expanded: {},
          status: "Expanded all asset folders",
        },
      )
    CollapseAllAssetFolders => {
      let asset_tree_expanded : Map[String, Bool] = {}
      for key in all_asset_tree_folder_keys(model) {
        asset_tree_expanded.set(key, false)
      }
      (
        [],
        { ..model, asset_tree_expanded, status: "Collapsed all asset folders" },
      )
    }
    ToggleImagesSection =>
      ([], { ..model, images_section_expanded: !model.images_section_expanded })
    ToggleAtlasesSection =>
      (
        [],
        { ..model, atlases_section_expanded: !model.atlases_section_expanded },
      )
    ToggleAnimationClipsSection =>
      (
        [],
        {
          ..model,
          animation_clips_section_expanded: !model.animation_clips_section_expanded,
        },
      )
    ToggleAnimationGraphsSection =>
      (
        [],
        {
          ..model,
          animation_graphs_section_expanded: !model.animation_graphs_section_expanded,
        },
      )
    TogglePrefabsSection =>
      (
        [],
        { ..model, prefabs_section_expanded: !model.prefabs_section_expanded },
      )
    ToggleMoveSnap => {
      let enabled = !model.move_snap_enabled
      let workspace = model.workspace.with_move_snap_enabled(enabled)
      let next = {
        ..model,
        move_snap_enabled: enabled,
        workspace,
        status: move_snap_status(enabled, model.move_snap_step),
      }
      (sync_preview_effects(next) + save_workspace_effects(next), next)
    }
    AdjustMoveSnapStep(delta) => {
      let next_step = adjusted_move_snap_step(model.move_snap_step, delta)
      if next_step == model.move_snap_step {
        ([], model)
      } else {
        let workspace = model.workspace.with_move_snap_step(next_step)
        let next = {
          ..model,
          move_snap_step: next_step,
          workspace,
          status: move_snap_status(model.move_snap_enabled, next_step),
        }
        (sync_preview_effects(next) + save_workspace_effects(next), next)
      }
    }
    CommitSceneEditTransaction => {
      let committed = with_committed_scene_edit_transaction(model)
      ([], committed)
    }
    UndoScene =>
      match (model.scene, model.undo_stack.length()) {
        (Some(current), count) if count > 0 => {
          let previous_scene = model.undo_stack[count - 1]
          let undo_stack = model.undo_stack[:count - 1].to_array()
          let redo_stack = bounded_history(model.redo_stack + [current])
          let (selected_entity_id, selected_entity_ids) = restored_entity_selection_for_scene(
            previous_scene,
            model.selected_entity_id,
            model.selected_entity_ids,
          )
          let workspace = model.workspace.with_selected_entity_id(
            selected_entity_id,
          )
          let next = {
            ..model,
            scene: Some(previous_scene),
            selected_entity_id,
            selected_entity_ids,
            workspace,
            undo_stack,
            redo_stack,
            active_scene_edit_transaction: None,
            status: "Undid last change",
          }
          normalize_scene_after_change(next)
        }
        _ => {
          let next = push_log(model, "Nothing to undo")
          ([], { ..next, status: "Nothing to undo" })
        }
      }
    RedoScene =>
      match (model.scene, model.redo_stack.length()) {
        (Some(current), count) if count > 0 => {
          let next_scene = model.redo_stack[count - 1]
          let redo_stack = model.redo_stack[:count - 1].to_array()
          let undo_stack = bounded_history(model.undo_stack + [current])
          let (selected_entity_id, selected_entity_ids) = restored_entity_selection_for_scene(
            next_scene,
            model.selected_entity_id,
            model.selected_entity_ids,
          )
          let workspace = model.workspace.with_selected_entity_id(
            selected_entity_id,
          )
          let next = {
            ..model,
            scene: Some(next_scene),
            selected_entity_id,
            selected_entity_ids,
            workspace,
            undo_stack,
            redo_stack,
            active_scene_edit_transaction: None,
            status: "Redid last change",
          }
          normalize_scene_after_change(next)
        }
        _ => {
          let next = push_log(model, "Nothing to redo")
          ([], { ..next, status: "Nothing to redo" })
        }
      }
    ClearSelection =>
      if model.add_component_panel_open ||
        model.open_component_menu_kind is Some(_) {
        (
          [],
          {
            ..model,
            add_component_panel_open: false,
            component_search_query: "",
            open_component_menu_kind: None,
            add_custom_component_kind: "",
            status: "Inspector panel closed",
          },
        )
      } else if !model.has_entity_selection() &&
        model.selected_resource is None &&
        !model.add_component_panel_open &&
        model.open_component_menu_kind is None {
        ([], model)
      } else {
        let next = with_entity_selection(
          {
            ..model,
            selected_resource: None,
            graph_edge_connect_source_node: None,
            add_component_panel_open: false,
            component_search_query: "",
            open_component_menu_kind: None,
            status: "Selection cleared",
          },
          None,
          [],
        )
        (sync_preview_effects(next), next)
      }
    OpenScene(path) =>
      (
        [rpc_effect(SceneLoaded, @shared.rpc_request_scene_load(path))],
        {
          ..model,
          scene_path: path,
          add_component_panel_open: false,
          component_search_query: "",
          open_component_menu_kind: None,
          status: "Loading " + path + "...",
        },
      )
    SelectResource(resource) => {
      let status = match resource {
        Some(selection) =>
          "Selected resource: " + resource_selection_name(selection)
        None => "Selection cleared"
      }
      let next = with_expanded_section_for_selection(
        {
          ..with_entity_selection(model, None, []),
          selected_resource: resource,
          graph_edge_connect_source_node: None,
          asset_tree_expanded: with_asset_tree_expanded_for_selection(
            model.asset_tree_expanded,
            resource,
          ),
          add_component_panel_open: false,
          component_search_query: "",
          open_component_menu_kind: None,
          status,
        },
        resource,
      )
      ([], next)
    }
    SelectEntity(id) => {
      let status = match id {
        Some(entity_id) =>
          match model.scene {
            Some(scene) =>
              match scene.entity(entity_id) {
                Some(entity) => "Selected entity: " + entity.name
                None => "Selected entity: " + entity_id
              }
            None => "Selected entity: " + entity_id
          }
        None =>
          match model.selected_resource {
            Some(selection) =>
              "Selected resource: " + resource_selection_name(selection)
            None => "Entity selection cleared"
          }
      }
      let next = {
        ..with_single_entity_selection(model, id),
        graph_edge_connect_source_node: None,
        add_component_panel_open: if id is Some(_) {
          model.add_component_panel_open
        } else {
          false
        },
        component_search_query: if id is Some(_) {
          model.component_search_query
        } else {
          ""
        },
        open_component_menu_kind: None,
        selected_resource: if id is Some(_) {
          None
        } else {
          model.selected_resource
        },
        status,
      }
      (sync_preview_effects(next), next)
    }
    CreateScene(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        let next = push_log(model, "Scene name is required")
        ([], { ..next, status: "Scene name is required" })
      } else {
        (
          [
            rpc_effect(SceneLoaded, @shared.rpc_request_scene_create(trimmed)),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
          ],
          { ..model, status: "Creating scene..." },
        )
      }
    }
    DeleteCurrentScene =>
      if model.scene_refs.length() <= 1 {
        let next = push_log(model, "Cannot delete the last scene")
        ([], { ..next, status: "Cannot delete the last scene" })
      } else {
        let fallback = fallback_scene_path(model)
        let next_scene_path = if model.scene_path == fallback &&
          model.scene_refs.length() > 1 {
          model.scene_refs[1].path
        } else {
          fallback
        }
        (
          [
            rpc_effect(
              SceneSaved,
              @shared.rpc_request_scene_delete(model.scene_path),
            ),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
            rpc_effect(
              SceneLoaded,
              @shared.rpc_request_scene_load(next_scene_path),
            ),
          ],
          { ..model, scene_path: next_scene_path, status: "Deleting scene..." },
        )
      }
    SetCurrentSceneAsStartup =>
      (
        [
          rpc_effect(
            SceneSaved,
            @shared.rpc_request_project_set_startup_scene(model.scene_path),
          ),
          rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
        ],
        { ..model, status: "Updating startup scene..." },
      )
    RenameCurrentScene(value) =>
      match model.scene {
        Some(scene) => {
          let trimmed = value.trim().to_string()
          if trimmed == "" {
            let next = push_log(model, "Scene name is required")
            ([], { ..next, status: "Scene name is required" })
          } else {
            let next_scene = scene.with_name(trimmed)
            let next = {
              ..model,
              scene: Some(next_scene),
              status: "Renaming scene...",
            }
            let with_history = with_recorded_scene_change(model, next)
            (
              [
                rpc_effect(
                  SceneSaved,
                  @shared.rpc_request_scene_save(model.scene_path, next_scene),
                ),
              ] +
              sync_preview_effects_with_scene(with_history),
              with_history,
            )
          }
        }
        None => ([], model)
      }
    CreateAtlasFromSelectedImage =>
      match model.selected_image_asset() {
        Some(asset) => {
          let atlas = atlas_document_from_image(
            asset.path,
            model.asset_size(asset.path),
          )
          let path = "assets/atlases/" +
            @editor_bridge.atlas_asset_file_name(atlas.name)
          let atlas_documents = model.atlas_documents
          atlas_documents.set(path, atlas)
          let atlas_refs = model.atlas_refs
          if !asset_ref_exists(atlas_refs, path) {
            atlas_refs.push(@editor_bridge.asset_ref(path))
          }
          let next = {
            ..model,
            atlas_documents,
            atlas_refs,
            selected_resource: Some(resource_selection_atlas(path)),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_atlas(path)),
            ),
            status: "Created atlas " + atlas.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_atlas_save(path, atlas),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    CreateAnimationFromSelectedAtlas =>
      match model.selected_atlas_document() {
        Some((path, atlas)) => {
          let clip = animation_clip_document_from_atlas(path, atlas)
          let clip_path = "assets/animation_clips/" +
            @editor_bridge.animation_clip_asset_file_name(clip.name)
          let animation_clip_documents = model.animation_clip_documents
          animation_clip_documents.set(clip_path, clip)
          let animation_clip_refs = model.animation_clip_refs
          if !asset_ref_exists(animation_clip_refs, clip_path) {
            animation_clip_refs.push(@editor_bridge.asset_ref(clip_path))
          }
          let next = {
            ..model,
            animation_clip_documents,
            animation_clip_refs,
            selected_resource: Some(
              resource_selection_animation_clip(clip_path),
            ),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_animation_clip(clip_path)),
            ),
            status: "Created animation clip " + clip.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_clip_save(clip_path, clip),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    CreateAnimationGraphFromSelectedClip =>
      match model.selected_animation_clip_document() {
        Some((clip_path, clip)) => {
          let graph = animation_graph_document_for_clip(clip_path, clip)
          let graph_path = "assets/animation_graphs/" +
            @editor_bridge.animation_graph_asset_file_name(graph.name)
          let animation_graph_documents = model.animation_graph_documents
          animation_graph_documents.set(graph_path, graph)
          let animation_graph_refs = model.animation_graph_refs
          if !asset_ref_exists(animation_graph_refs, graph_path) {
            animation_graph_refs.push(@editor_bridge.asset_ref(graph_path))
          }
          let next = {
            ..model,
            animation_graph_documents,
            animation_graph_refs,
            selected_resource: Some(
              resource_selection_animation_graph(graph_path),
            ),
            asset_tree_expanded: with_asset_tree_expanded_for_selection(
              model.asset_tree_expanded,
              Some(resource_selection_animation_graph(graph_path)),
            ),
            status: "Created animation graph " + graph.name,
          }
          let next = with_expanded_section_for_selection(
            next,
            next.selected_resource,
          )
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_graph_save(graph_path, graph),
              ),
            ],
            next,
          )
        }
        None => ([], model)
      }
    SaveSelectedAsPrefab =>
      match (model.scene, model.selected_entity_id) {
        (Some(scene), Some(entity_id)) =>
          match prefab_from_scene_selection(scene, entity_id) {
            Some(prefab) => {
              let path = "prefabs/" +
                @editor_bridge.prefab_file_name(prefab.name)
              let prefab_documents = model.prefab_documents
              prefab_documents.set(path, prefab)
              let prefab_refs = model.prefab_refs
              if !prefab_ref_exists(prefab_refs, path) {
                prefab_refs.push(@editor_bridge.prefab_ref(path))
              }
              let next = {
                ..model,
                prefab_documents,
                prefab_refs,
                selected_resource: Some(resource_selection_prefab(path)),
                asset_tree_expanded: with_asset_tree_expanded_for_selection(
                  model.asset_tree_expanded,
                  Some(resource_selection_prefab(path)),
                ),
                status: "Saved prefab " + prefab.name,
              }
              let next = with_expanded_section_for_selection(
                next,
                next.selected_resource,
              )
              (
                [
                  rpc_effect(
                    SceneSaved,
                    @shared.rpc_request_prefab_save(path, prefab),
                  ),
                ],
                next,
              )
            }
            None => ([], model)
          }
        _ => ([], model)
      }
    InsertSelectedResource =>
      match (model.scene, model.selected_resource) {
        (Some(scene), Some(Image(path))) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            next_resource_entity_translation(),
          )
          let next = with_single_entity_selection(
            { ..model, scene: Some(next_scene) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        (Some(scene), Some(Atlas(path))) =>
          match model.atlas_documents.get(path) {
            Some(atlas) => {
              let (next_scene, id) = add_atlas_asset_to_scene(
                scene,
                path,
                atlas,
                next_resource_entity_translation(),
              )
              let next = {
                ..with_single_entity_selection(model, Some(id)),
                scene: Some(next_scene),
              }
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        (Some(scene), Some(AnimationClip(path))) =>
          match model.animation_clip_documents.get(path) {
            Some(clip) =>
              match model.atlas_documents.get(clip.atlas_asset_path) {
                Some(atlas) => {
                  let mut graph_pair : (
                    String,
                    @editor_bridge.AnimationGraphAssetDocument,
                  )? = None
                  for graph_path, graph in model.animation_graph_documents {
                    let selected_clip_path = animation_graph_default_clip_path(
                      graph,
                    ).unwrap_or("")
                    if selected_clip_path == path {
                      graph_pair = Some((graph_path, graph))
                      break
                    }
                  }
                  match graph_pair {
                    Some((graph_path, graph)) => {
                      let (next_scene, id) = add_animation_graph_asset_to_scene(
                        scene,
                        graph_path,
                        graph,
                        clip,
                        atlas,
                        next_resource_entity_translation(),
                      )
                      let next = {
                        ..with_single_entity_selection(model, Some(id)),
                        scene: Some(next_scene),
                      }
                      apply_scene_change(model, next)
                    }
                    None => {
                      let (next_scene, id) = add_atlas_asset_to_scene(
                        scene,
                        clip.atlas_asset_path,
                        atlas,
                        next_resource_entity_translation(),
                      )
                      let next = {
                        ..with_single_entity_selection(model, Some(id)),
                        scene: Some(next_scene),
                      }
                      apply_scene_change(model, next)
                    }
                  }
                }
                None => ([], model)
              }
            None => ([], model)
          }
        (Some(scene), Some(AnimationGraph(path))) =>
          match model.animation_graph_documents.get(path) {
            Some(graph) =>
              match animation_graph_default_clip_path(graph) {
                Some(clip_path) =>
                  match model.animation_clip_documents.get(clip_path) {
                    Some(clip) =>
                      match model.atlas_documents.get(clip.atlas_asset_path) {
                        Some(atlas) => {
                          let (next_scene, id) = add_animation_graph_asset_to_scene(
                            scene,
                            path,
                            graph,
                            clip,
                            atlas,
                            next_resource_entity_translation(),
                          )
                          let next = {
                            ..with_single_entity_selection(model, Some(id)),
                            scene: Some(next_scene),
                          }
                          apply_scene_change(model, next)
                        }
                        None => ([], model)
                      }
                    None => ([], model)
                  }
                None => ([], model)
              }
            None => ([], model)
          }
        (Some(scene), Some(Prefab(path))) =>
          match model.prefab_documents.get(path) {
            Some(prefab) => {
              let (next_scene, id) = instantiate_prefab_into_scene(
                scene,
                prefab,
                next_resource_entity_translation(),
              )
              let next = {
                ..with_single_entity_selection(model, id),
                scene: Some(next_scene),
              }
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        _ => ([], model)
      }
    MoveSelectedResource(delta) =>
      if delta == 0 {
        ([], model)
      } else {
        let resources = visible_resources_in_order(model)
        if resources.is_empty() {
          ([], model)
        } else {
          let target_index = match model.selected_resource {
            Some(current) =>
              match resource_index(resources, current) {
                Some(index) => {
                  let shifted = index + delta
                  if shifted < 0 {
                    0
                  } else if shifted >= resources.length() {
                    resources.length() - 1
                  } else {
                    shifted
                  }
                }
                None => if delta > 0 { 0 } else { resources.length() - 1 }
              }
            None => if delta > 0 { 0 } else { resources.length() - 1 }
          }
          let selected_resource = Some(resources[target_index])
          let next = with_expanded_section_for_selection(
            {
              ..with_entity_selection(model, None, []),
              selected_resource,
              asset_tree_expanded: with_asset_tree_expanded_for_selection(
                model.asset_tree_expanded,
                selected_resource,
              ),
              add_component_panel_open: false,
              component_search_query: "",
              open_component_menu_kind: None,
              status: "Selected resource \{target_index + 1}/\{resources.length()}: " +
              resource_selection_name(resources[target_index]),
            },
            selected_resource,
          )
          ([], next)
        }
      }
    OpenAddComponentPanel =>
      match model.selected_entity() {
        Some(_) =>
          (
            [],
            {
              ..model,
              add_component_panel_open: true,
              component_search_query: "",
              open_component_menu_kind: None,
              add_custom_component_kind: "",
            },
          )
        None => ([], model)
      }
    CloseAddComponentPanel =>
      (
        [],
        {
          ..model,
          add_component_panel_open: false,
          component_search_query: "",
          open_component_menu_kind: None,
          add_custom_component_kind: "",
        },
      )
    SetComponentSearchQuery(value) =>
      ([], { ..model, component_search_query: value })
    ToggleComponentCollapsed(kind) =>
      match model.selected_entity_id {
        Some(entity_id) =>
          ([], with_component_card_collapsed(model, entity_id, kind))
        None => ([], model)
      }
    ToggleComponentMenu(kind) => {
      let open_component_menu_kind = match
        (kind, model.open_component_menu_kind) {
        (Some(next), Some(current)) if next == current => None
        _ => kind
      }
      ([], { ..model, open_component_menu_kind, })
    }
    AddBuiltinComponent(kind) =>
      match model.selected_entity() {
        Some(_) => {
          let (next, added) = with_builtin_component_added(model, kind)
          if added.is_empty() {
            (
              [],
              {
                ..next,
                status: @editor_bridge.builtin_component_kind_to_string(kind) +
                " already exists on this entity",
              },
            )
          } else {
            let summary = if added.length() == 1 {
              "Added " + added[0]
            } else {
              "Added components: " + added.join(", ")
            }
            apply_scene_change(model, {
              ..next,
              open_component_menu_kind: None,
              status: summary,
            })
          }
        }
        None => ([], model)
      }
    RemoveComponent(kind) =>
      match with_component_removed(model, kind) {
        Ok(next) =>
          apply_scene_change(model, {
            ..next,
            open_component_menu_kind: None,
            status: "Removed " + kind,
          })
        Err(message) => {
          let next = push_log(model, message)
          ([], { ..next, status: message, open_component_menu_kind: None })
        }
      }
    UpdateAddCustomComponentKind(value) =>
      ([], { ..model, add_custom_component_kind: value })
    AddCustomComponent(raw_kind) =>
      match model.selected_entity() {
        Some(entity) =>
          match validated_custom_component_kind(raw_kind) {
            Ok(kind) =>
              if entity.component(kind) is Some(_) {
                (
                  [],
                  {
                    ..model,
                    status: kind + " already exists on this entity",
                    add_custom_component_kind: kind,
                  },
                )
              } else {
                let default_data = match parse_custom_component_json("{}") {
                  Ok(json) => json
                  Err(_) => Json::null()
                }
                let next = update_selected_component(
                  model,
                  @editor_bridge.component_document(kind, default_data),
                )
                let key = component_state_key(entity.id, kind)
                let custom_component_json_drafts = next.custom_component_json_drafts
                custom_component_json_drafts.set(key, "{}")
                let custom_component_json_errors = next.custom_component_json_errors
                custom_component_json_errors.remove(key) |> ignore
                apply_scene_change(model, {
                  ..next,
                  custom_component_json_drafts,
                  custom_component_json_errors,
                  add_component_panel_open: false,
                  component_search_query: "",
                  add_custom_component_kind: "",
                  open_component_menu_kind: None,
                  status: "Added " + kind,
                })
              }
            Err(message) => {
              let next = push_log(model, message)
              (
                [],
                { ..next, status: message, add_custom_component_kind: raw_kind },
              )
            }
          }
        None => ([], model)
      }
    UpdateCustomComponentJson(kind, value) =>
      match model.selected_entity_id {
        Some(entity_id) => {
          let key = component_state_key(entity_id, kind)
          let custom_component_json_drafts = model.custom_component_json_drafts
          custom_component_json_drafts.set(key, value)
          let custom_component_json_errors = model.custom_component_json_errors
          custom_component_json_errors.remove(key) |> ignore
          (
            [],
            {
              ..model,
              custom_component_json_drafts,
              custom_component_json_errors,
            },
          )
        }
        None => ([], model)
      }
    CommitCustomComponentJson(kind) =>
      match model.selected_entity() {
        Some(entity) =>
          match entity.component(kind) {
            Some(component) => {
              let key = component_state_key(entity.id, kind)
              let draft = model.custom_component_json_drafts
                .get(key)
                .unwrap_or(component.data.stringify(indent=2))
              match parse_custom_component_json(draft) {
                Ok(json) => {
                  let next = update_selected_component(
                    model,
                    @editor_bridge.component_document(kind, json),
                  )
                  let custom_component_json_errors = next.custom_component_json_errors
                  custom_component_json_errors.remove(key) |> ignore
                  let custom_component_json_drafts = next.custom_component_json_drafts
                  custom_component_json_drafts.set(
                    key,
                    json.stringify(indent=2),
                  )
                  apply_scene_change(model, {
                    ..next,
                    custom_component_json_errors,
                    custom_component_json_drafts,
                    status: "Updated " + kind,
                  })
                }
                Err(message) => {
                  let custom_component_json_errors = model.custom_component_json_errors
                  custom_component_json_errors.set(key, message)
                  (
                    [],
                    { ..model, custom_component_json_errors, status: message },
                  )
                }
              }
            }
            None => {
              let next = push_log(
                model,
                kind + " does not exist on this entity",
              )
              ([], { ..next, status: kind + " does not exist on this entity" })
            }
          }
        None => ([], model)
      }
    UpdateSelectedPrefabName(value) => {
      let next = update_selected_prefab_document(model, fn(prefab) {
        prefab.with_name(value)
      })
      ([], next)
    }
    SaveSelectedPrefab =>
      match model.selected_prefab_document() {
        Some((path, prefab)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_prefab_save(path, prefab),
              ),
            ],
            { ..model, status: "Saving prefab..." },
          )
        None => ([], model)
      }
    UpdateSelectedAtlasName(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasTileWidth(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_tile_size(
            atlas.tile_size.with_x(
              parse_positive_double_or(atlas.tile_size.x, value),
            ),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasTileHeight(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_tile_size(
            atlas.tile_size.with_y(
              parse_positive_double_or(atlas.tile_size.y, value),
            ),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasColumns(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_columns(parse_positive_int_or(atlas.columns, value)),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasRows(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_rows(parse_positive_int_or(atlas.rows, value)),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasSpacingX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_spacing(
            atlas.spacing.with_x(parse_double_or(atlas.spacing.x, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasSpacingY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_spacing(
            atlas.spacing.with_y(parse_double_or(atlas.spacing.y, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasMarginX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_margin(
            atlas.margin.with_x(parse_double_or(atlas.margin.x, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasMarginY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        with_rebuilt_regions(
          atlas.with_margin(
            atlas.margin.with_y(parse_double_or(atlas.margin.y, value)),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasAnchorX(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_default_anchor(
          atlas.default_anchor.with_x(
            parse_double_or(atlas.default_anchor.x, value),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAtlasAnchorY(value) => {
      let next = update_selected_atlas_document(model, fn(atlas) {
        atlas.with_default_anchor(
          atlas.default_anchor.with_y(
            parse_double_or(atlas.default_anchor.y, value),
          ),
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    SaveSelectedAtlas =>
      match model.selected_atlas_document() {
        Some((path, atlas)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_atlas_save(path, atlas),
              ),
            ],
            { ..model, status: "Saving atlas..." },
          )
        None => ([], model)
      }
    UpdateSelectedAnimationClipAssetName(value) => {
      let next = update_selected_animation_clip_document(model, fn(animation) {
        animation.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationGraphAssetName(value) => {
      let next = update_selected_animation_graph_document(model, fn(animation) {
        animation.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationGraphDefaultNode(value) => {
      let next = update_selected_animation_graph_document(model, fn(animation) {
        let default_node = value.trim().to_string()
        animation.with_default_node(
          if default_node == "" {
            None
          } else {
            Some(default_node)
          },
        )
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipName(value) => {
      let next = update_selected_animation_clip_document(model, fn(animation) {
        animation.with_name(value)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipFps(value) => {
      let next = update_selected_animation_clip_document(model, fn(animation) {
        animation.with_fps(parse_positive_double_or(animation.fps, value))
      })
      (sync_preview_effects_with_scene(next), next)
    }
    ToggleSelectedAnimationClipLooping => {
      let next = update_selected_animation_clip_document(model, fn(animation) {
        animation.with_looping(!animation.looping)
      })
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationClipFrames(value) => {
      let next = update_selected_animation_clip_document(model, fn(animation) {
        animation.with_frames(parse_clip_frames(animation.frames, value))
      })
      (sync_preview_effects_with_scene(next), next)
    }
    AddSelectedAnimationGraphClipNode =>
      match first_animation_clip_path(model) {
        Some(clip_path) => {
          let next = with_selected_animation_graph_node_added(
            model,
            @editor_bridge.animation_graph_node_kind_clip(clip_path),
          )
          (
            sync_preview_effects_with_scene(next),
            { ..next, status: "Added Clip node to animation graph" },
          )
        }
        None => {
          let next = { ..model, status: "Create an animation clip first" }
          (sync_preview_effects(next), next)
        }
      }
    AddSelectedAnimationGraphBlendNode => {
      let next = with_selected_animation_graph_node_added(
        model,
        @editor_bridge.animation_graph_node_kind_blend(),
      )
      (
        sync_preview_effects_with_scene(next),
        { ..next, status: "Added Blend node to animation graph" },
      )
    }
    AddSelectedAnimationGraphAdditiveBlendNode => {
      let next = with_selected_animation_graph_node_added(
        model,
        @editor_bridge.animation_graph_node_kind_additive_blend(),
      )
      (
        sync_preview_effects_with_scene(next),
        { ..next, status: "Added Additive Blend node to animation graph" },
      )
    }
    RemoveSelectedAnimationGraphNode(id) => {
      let next = with_selected_animation_graph_node_removed(model, id)
      let connect_source = if model.graph_edge_connect_source_node == Some(id) {
        None
      } else {
        model.graph_edge_connect_source_node
      }
      (
        sync_preview_effects_with_scene(next),
        {
          ..next,
          graph_edge_connect_source_node: connect_source,
          status: "Removed graph node: \{id}",
        },
      )
    }
    UpdateSelectedAnimationGraphNodeClipPath(id, path) => {
      let next = with_selected_animation_graph_clip_path_updated(
        model, id, path,
      )
      (sync_preview_effects_with_scene(next), next)
    }
    AddSelectedAnimationGraphEdge(node_id) => {
      let next = with_selected_animation_graph_edge_added(model, node_id)
      (
        sync_preview_effects_with_scene(next),
        { ..next, status: "Added edge for node: \{node_id}" },
      )
    }
    RemoveSelectedAnimationGraphEdge(node_id, edge_index) => {
      let next = with_selected_animation_graph_edge_removed(
        model, node_id, edge_index,
      )
      (
        sync_preview_effects_with_scene(next),
        {
          ..next,
          status: "Removed edge #\{edge_index.to_string()} from \{node_id}",
        },
      )
    }
    UpdateSelectedAnimationGraphEdgeTarget(node_id, edge_index, target) => {
      let next = with_selected_animation_graph_edge_target_updated(
        model, node_id, edge_index, target,
      )
      (sync_preview_effects_with_scene(next), next)
    }
    UpdateSelectedAnimationGraphEdgeWeight(node_id, edge_index, value) => {
      let next = with_selected_animation_graph_edge_weight_updated(
        model, node_id, edge_index, value,
      )
      (sync_preview_effects_with_scene(next), next)
    }
    BeginSelectedAnimationGraphEdgeConnect(source_node_id) =>
      (
        [],
        {
          ..model,
          graph_edge_connect_source_node: Some(source_node_id),
          status: "Connect edge from \{source_node_id}: Alt+click target node",
        },
      )
    CompleteSelectedAnimationGraphEdgeConnect(target_node_id) =>
      match model.graph_edge_connect_source_node {
        Some(source_node_id) => {
          let (changed_model, changed) = with_selected_animation_graph_edge_added_to_target(
            model, source_node_id, target_node_id,
          )
          let next = { ..changed_model, graph_edge_connect_source_node: None }
          let status = if source_node_id == target_node_id {
            "Edge connect canceled"
          } else if changed {
            "Connected graph edge: \{source_node_id} -> \{target_node_id}"
          } else {
            "Graph edge already exists: \{source_node_id} -> \{target_node_id}"
          }
          (sync_preview_effects_with_scene(next), { ..next, status, })
        }
        None => ([], model)
      }
    CancelSelectedAnimationGraphEdgeConnect =>
      (
        [],
        {
          ..model,
          graph_edge_connect_source_node: None,
          status: "Canceled graph edge connect",
        },
      )
    MoveSelectedAnimationGraphNode(node_id, normalized_x, normalized_y) =>
      match model.selected_animation_graph_document() {
        Some((_path, graph)) => {
          let (min_x, max_x) = animation_graph_axis_bounds(graph, fn(node) {
            node.position.x
          })
          let (min_y, max_y) = animation_graph_axis_bounds(graph, fn(node) {
            node.position.y
          })
          let moved_position = @editor_bridge.vec2_doc(
            animation_graph_axis_unproject(normalized_x, min_x, max_x),
            animation_graph_axis_unproject(normalized_y, min_y, max_y),
          )
          let next = update_selected_animation_graph_document(model, fn(doc) {
            let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
            for node in doc.nodes {
              if node.id == node_id {
                nodes.push(node.with_position(moved_position))
              } else {
                nodes.push(node)
              }
            }
            doc.with_nodes(nodes)
          })
          (
            sync_preview_effects_with_scene(next),
            { ..next, status: "Moved graph node: \{node_id}" },
          )
        }
        None => ([], model)
      }
    ToggleAnimationPreviewPaused => {
      let paused = !model.animation_preview_paused
      (
        [Preview(@bridge.preview_command_set_animation_preview_paused(paused))],
        {
          ..model,
          animation_preview_paused: paused,
          status: if paused {
            "Animation preview paused"
          } else {
            "Animation preview playing"
          },
        },
      )
    }
    UpdateAnimationPreviewSpeed(value) => {
      let speed = parse_double_or(model.animation_preview_speed, value)
      (
        [Preview(@bridge.preview_command_set_animation_preview_speed(speed))],
        {
          ..model,
          animation_preview_speed: speed,
          status: "Animation preview speed: \{speed.to_string()}",
        },
      )
    }
    UpdateAnimationPreviewSeekInput(value) =>
      ([], { ..model, animation_preview_seek_input: value })
    ApplyAnimationPreviewSeek => {
      let seek_seconds = parse_double_or(
        0.0,
        model.animation_preview_seek_input,
      )
      let clamped = if seek_seconds < 0.0 { 0.0 } else { seek_seconds }
      (
        [Preview(@bridge.preview_command_seek_animation_preview(clamped))],
        { ..model, status: "Animation preview seek: \{clamped.to_string()}s" },
      )
    }
    SaveSelectedAnimationClip =>
      match model.selected_animation_clip_document() {
        Some((path, clip)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_clip_save(path, clip),
              ),
            ],
            { ..model, status: "Saving animation clip..." },
          )
        None => ([], model)
      }
    SaveSelectedAnimationGraph =>
      match model.selected_animation_graph_document() {
        Some((path, graph)) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_animation_graph_save(path, graph),
              ),
            ],
            { ..model, status: "Saving animation graph..." },
          )
        None => ([], model)
      }
    RenameSelected(value) => {
      let staged = with_started_scene_edit_transaction(model, "Rename Entity")
      let next = update_selected_entity(staged, fn(entity) {
        entity.renamed(value)
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedTranslateX(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next_x = parse_double_or(transform.translation.x, value)
              let next = with_selected_entities_transform_updated(staged, fn(
                target_transform,
              ) {
                @editor_bridge.transform2d_value(
                  translation=target_transform.translation.with_x(next_x),
                  rotation=target_transform.rotation,
                  scale=target_transform.scale,
                )
              })
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedTranslateY(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next_y = parse_double_or(transform.translation.y, value)
              let next = with_selected_entities_transform_updated(staged, fn(
                target_transform,
              ) {
                @editor_bridge.transform2d_value(
                  translation=target_transform.translation.with_y(next_y),
                  rotation=target_transform.rotation,
                  scale=target_transform.scale,
                )
              })
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedRotation(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transform : @editor_bridge.Transform2dComponent? = component_of(
            entity, "Transform2d",
          )
          match transform {
            Some(transform) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Transform",
              )
              let next_rotation = parse_double_or(transform.rotation, value)
              let next = with_selected_entities_transform_updated(staged, fn(
                target_transform,
              ) {
                @editor_bridge.transform2d_value(
                  translation=target_transform.translation,
                  rotation=next_rotation,
                  scale=target_transform.scale,
                )
              })
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedText(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let text_component : @editor_bridge.Text2dComponent? = component_of(
            entity, "Text2d",
          )
          match text_component {
            Some(text_component) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Text",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.text2d_component(
                  value,
                  font_path=text_component.font_path,
                  font_size=text_component.font_size,
                  color=text_component.color,
                  bounds=text_component.bounds,
                  anchor=text_component.anchor,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    ToggleSelectedVisibility =>
      match model.selected_entity() {
        Some(entity) => {
          let visibility_component : @editor_bridge.VisibilityComponent? = component_of(
            entity, "Visibility",
          )
          match visibility_component {
            Some(visibility_component) => {
              let next_visible = !visibility_component.visible
              let next = with_selected_entities_visibility_set(
                model, next_visible,
              )
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedAnimationPlayerGraphPath(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let player : @editor_bridge.AnimationPlayerComponent? = component_of(
            entity, "AnimationPlayer",
          )
          match player {
            Some(player) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Animation Player",
              )
              let graph_asset_path = value.trim().to_string()
              let next = update_selected_component(
                staged,
                @editor_bridge.animation_player_component(
                  graph_asset_path=if graph_asset_path == "" {
                    None
                  } else {
                    Some(graph_asset_path)
                  },
                  start_node=player.start_node,
                  autoplay=player.autoplay,
                  repeat_mode=player.repeat_mode_doc(),
                  speed=player.speed,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedAnimationPlayerStartNode(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let player : @editor_bridge.AnimationPlayerComponent? = component_of(
            entity, "AnimationPlayer",
          )
          match player {
            Some(player) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Animation Player",
              )
              let start_node = value.trim().to_string()
              let next = update_selected_component(
                staged,
                @editor_bridge.animation_player_component(
                  graph_asset_path=player.graph_asset_path,
                  start_node=if start_node == "" {
                    None
                  } else {
                    Some(start_node)
                  },
                  autoplay=player.autoplay,
                  repeat_mode=player.repeat_mode_doc(),
                  speed=player.speed,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    ToggleSelectedAnimationPlayerAutoplay =>
      match model.selected_entity() {
        Some(entity) => {
          let player : @editor_bridge.AnimationPlayerComponent? = component_of(
            entity, "AnimationPlayer",
          )
          match player {
            Some(player) => {
              let next = update_selected_component(
                model,
                @editor_bridge.animation_player_component(
                  graph_asset_path=player.graph_asset_path,
                  start_node=player.start_node,
                  autoplay=!player.autoplay,
                  repeat_mode=player.repeat_mode_doc(),
                  speed=player.speed,
                ),
              )
              apply_scene_change(model, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedAnimationPlayerRepeatMode(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let player : @editor_bridge.AnimationPlayerComponent? = component_of(
            entity, "AnimationPlayer",
          )
          match player {
            Some(player) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Animation Player",
              )
              let repeat_mode = if value.trim() == "" {
                player.repeat_mode_doc()
              } else {
                @editor_bridge.animation_repeat_mode_doc_from_string(value)
              }
              let next = update_selected_component(
                staged,
                @editor_bridge.animation_player_component(
                  graph_asset_path=player.graph_asset_path,
                  start_node=player.start_node,
                  autoplay=player.autoplay,
                  repeat_mode~,
                  speed=player.speed,
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedAnimationPlayerSpeed(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let player : @editor_bridge.AnimationPlayerComponent? = component_of(
            entity, "AnimationPlayer",
          )
          match player {
            Some(player) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Animation Player",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.animation_player_component(
                  graph_asset_path=player.graph_asset_path,
                  start_node=player.start_node,
                  autoplay=player.autoplay,
                  repeat_mode=player.repeat_mode_doc(),
                  speed=parse_double_or(player.speed, value),
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    UpdateSelectedAnimationTransitionsDuration(value) =>
      match model.selected_entity() {
        Some(entity) => {
          let transitions : @editor_bridge.AnimationTransitionsComponent? = component_of(
            entity, "AnimationTransitions",
          )
          match transitions {
            Some(transitions) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit Animation Transitions",
              )
              let next = update_selected_component(
                staged,
                @editor_bridge.animation_transitions_component(
                  duration=parse_positive_double_or(transitions.duration, value),
                ),
              )
              apply_scene_change_without_history(staged, next)
            }
            None => ([], model)
          }
        }
        None => ([], model)
      }
    SaveScene =>
      match model.scene {
        Some(scene) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_scene_save(model.scene_path, scene),
              ),
            ],
            { ..model, status: "Saving scene..." },
          )
        None => ([], model)
      }
    ReloadScene =>
      (refresh_project_effects(model), { ..model, status: "Reloading..." })
    AddSpriteEntity =>
      match model.scene {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Sprite", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.sprite_component(
              custom_size=Some(@editor_bridge.vec2_doc(64.0, 64.0)),
            ),
          ])
          let next = with_single_entity_selection(
            { ..model, scene: Some(scene.with_entity(entity)) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddSpriteFromAsset(path) =>
      match model.scene {
        Some(scene) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            next_resource_entity_translation(),
          )
          let next = with_single_entity_selection(
            { ..model, scene: Some(next_scene) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddSpriteFromAssetAt(path, translation) =>
      match model.scene {
        Some(scene) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            translation,
          )
          let next = with_single_entity_selection(
            { ..model, scene: Some(next_scene) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddTextEntity =>
      match model.scene {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Text", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.text2d_component("Text"),
          ])
          let next = with_single_entity_selection(
            { ..model, scene: Some(scene.with_entity(entity)) },
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    DeleteSelected =>
      match model.scene {
        Some(scene) => {
          let selected_ids = selected_entity_ids_for_edit(model)
          if selected_ids.is_empty() {
            ([], model)
          } else {
            let mut next_scene = scene
            for id in selected_ids {
              next_scene = next_scene.without_entity(id)
            }
            let next = {
              ..with_entity_selection(model, None, []),
              scene: Some(next_scene),
              add_component_panel_open: false,
              component_search_query: "",
              open_component_menu_kind: None,
            }
            apply_scene_change(model, next)
          }
        }
        None => ([], model)
      }
    SetTool(tool) => {
      let next = {
        ..model,
        active_tool: tool,
        status: "Tool: " + tool_label(tool),
      }
      (sync_preview_effects(next), next)
    }
    FrameSelection =>
      ([Preview(@bridge.preview_command_frame_selection())], model)
  }
}
