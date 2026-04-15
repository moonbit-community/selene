///|
fn update_selection_history_tools(
  msg : SelectionHistoryToolsMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
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
            autotile_palette_json_draft: "",
            autotile_palette_json_error: None,
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
            autotile_palette_json_draft: "",
            autotile_palette_json_error: None,
            status: "Selection cleared",
          },
          None,
          [],
        )
        (sync_preview_effects(next), next)
      }
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
          autotile_palette_json_draft: "",
          autotile_palette_json_error: None,
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
        autotile_palette_json_draft: "",
        autotile_palette_json_error: None,
        status,
      }
      (sync_preview_effects(next), next)
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
