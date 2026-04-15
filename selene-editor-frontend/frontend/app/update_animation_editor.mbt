///|
fn update_animation_editor(
  msg : AnimationEditorMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
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
      let speed = parse_positive_double_or(model.animation_preview_speed, value)
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
        {
          ..model,
          animation_preview_seek_seconds: clamped,
          animation_preview_seek_serial: model.animation_preview_seek_serial + 1,
          status: "Animation preview seek: \{clamped.to_string()}s",
        },
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
  }
}
