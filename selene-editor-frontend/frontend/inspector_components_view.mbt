///|
fn labeled_input(
  label : String,
  value : String,
  on_change : (String) -> @rabbita.Cmd,
) -> @rabbita.Html {
  @html.label(class="field", [
    @html.span(class="field-label", label),
    @html.input(value~, class="field-input", on_input=on_change, @html.nothing),
  ])
}

///|
fn labeled_input_with_commit(
  label : String,
  value : String,
  on_change : (String) -> @rabbita.Cmd,
  on_commit : () -> @rabbita.Cmd,
) -> @rabbita.Html {
  let attrs = @html.Attrs::build()
    .on_change(fn(_event) { on_commit() })
    .on_keydown(fn(event) {
      if keyboard_event_is_enter_key(event) {
        keyboard_event_blur_target(event)
        return on_commit()
      }
      @cmd.none
    })
  @html.label(class="field", [
    @html.span(class="field-label", label),
    @html.input(
      value~,
      class="field-input",
      on_input=on_change,
      attrs~,
      @html.nothing,
    ),
  ])
}

///|
fn transform_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  transform : @editor_bridge.Transform2dComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "X",
      transform.translation.x.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_translate_x(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Y",
      transform.translation.y.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_translate_y(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Rotation",
      transform.rotation.to_string(),
      fn(value) { dispatch(@app.msg_update_selected_rotation(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn text_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  text_component : @editor_bridge.Text2dComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Content",
      text_component.content,
      fn(value) { dispatch(@app.msg_update_selected_text(value)) },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn sprite_component_body(
  sprite_component : @editor_bridge.SpriteComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    @html.div(class="kv", [
      @html.span(class="kv-key", "Image"),
      @html.span(
        class="kv-value",
        sprite_component.image_path.unwrap_or("(none)"),
      ),
    ]),
    @html.div(class="kv", [
      @html.span(class="kv-key", "Mode"),
      @html.span(class="kv-value", sprite_component.image_mode),
    ]),
  ])
}

///|
fn visibility_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  visibility_component : @editor_bridge.VisibilityComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    @html.button(
      class="small-button",
      on_click=dispatch(@app.msg_toggle_selected_visibility()),
      if visibility_component.visible {
        "Visible"
      } else {
        "Hidden"
      },
    ),
  ])
}

///|
fn animation_player_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  player : @editor_bridge.AnimationPlayerComponent,
) -> @rabbita.Html {
  let repeat_mode = player.repeat_mode_doc()
  let is_forever = match repeat_mode {
    @editor_bridge.Forever => true
    _ => false
  }
  let is_never = match repeat_mode {
    @editor_bridge.Never => true
    _ => false
  }
  let is_count = match repeat_mode {
    @editor_bridge.Count(_) => true
    _ => false
  }
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Graph Asset Path",
      player.graph_asset_path.unwrap_or(""),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_graph_path(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    labeled_input_with_commit(
      "Start Node",
      player.start_node.unwrap_or(""),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_start_node(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    @html.div(class="kv", [
      @html.span(class="kv-key", "Repeat Mode"),
      @html.span(
        class="kv-value",
        match repeat_mode {
          @editor_bridge.Never => "Never"
          @editor_bridge.Forever => "Forever"
          @editor_bridge.Count(count) => "Count (\{count})"
        },
      ),
    ]),
    @html.div(class="inspector-actions", [
      @html.button(
        class=if is_forever { "small-button active" } else { "small-button" },
        on_click=dispatch(
          @app.msg_update_selected_animation_player_repeat_mode("forever"),
        ),
        "Forever",
      ),
      @html.button(
        class=if is_never { "small-button active" } else { "small-button" },
        on_click=dispatch(
          @app.msg_update_selected_animation_player_repeat_mode("never"),
        ),
        "Never",
      ),
      @html.button(
        class=if is_count { "small-button active" } else { "small-button" },
        on_click=dispatch(
          @app.msg_update_selected_animation_player_repeat_mode("count"),
        ),
        "Count",
      ),
    ]),
    match repeat_mode {
      @editor_bridge.Count(count) =>
        labeled_input_with_commit(
          "Repeat Count",
          count.to_string(),
          fn(value) {
            dispatch(
              @app.msg_update_selected_animation_player_repeat_mode(
                "count:" + value,
              ),
            )
          },
          fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
        )
      _ => @html.nothing
    },
    labeled_input_with_commit(
      "Speed",
      player.speed.to_string(),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_player_speed(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
    @html.button(
      class="small-button",
      on_click=dispatch(@app.msg_toggle_selected_animation_player_autoplay()),
      if player.autoplay {
        "Autoplay: Enabled"
      } else {
        "Autoplay: Disabled"
      },
    ),
  ])
}

///|
fn animation_transitions_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  transitions : @editor_bridge.AnimationTransitionsComponent,
) -> @rabbita.Html {
  @html.div(class="inspector-block", [
    labeled_input_with_commit(
      "Duration",
      transitions.duration.to_string(),
      fn(value) {
        dispatch(@app.msg_update_selected_animation_transitions_duration(value))
      },
      fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
    ),
  ])
}

///|
fn animation_graph_node_kind_label(
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> String {
  match kind {
    @editor_bridge.Clip(..) => "Clip"
    @editor_bridge.Blend => "Blend"
    @editor_bridge.AdditiveBlend => "AdditiveBlend"
  }
}

///|
fn animation_graph_node_clip_path(
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> String? {
  match kind {
    @editor_bridge.Clip(clip_asset_path~) => Some(clip_asset_path)
    _ => None
  }
}

///|
fn animation_graph_axis_bounds(values : Array[Double]) -> (Double, Double) {
  if values.is_empty() {
    return (0.0, 1.0)
  }
  let mut min_value = values[0]
  let mut max_value = values[0]
  for value in values[1:] {
    if value < min_value {
      min_value = value
    }
    if value > max_value {
      max_value = value
    }
  }
  if max_value - min_value < 0.001 {
    (min_value - 1.0, max_value + 1.0)
  } else {
    (min_value, max_value)
  }
}

///|
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn animation_graph_canvas_project(
  value : Double,
  min_value : Double,
  max_value : Double,
) -> Double {
  clamp01((value - min_value) / (max_value - min_value))
}

///|
fn graph_node_drag_attrs(
  node_id : String,
  dispatch : @rabbita.Dispatch[@app.Msg],
  graph_edge_connect_source_node : String?,
) -> @html.Attrs {
  @html.Attrs::build()
  .draggable("true")
  .on_dragstart(fn(event) {
    match event.to_drag_event() {
      Some(drag_event) => drag_event_set_graph_node_payload(drag_event, node_id)
      None => ()
    }
    @cmd.none
  })
  .on_click(fn(event) {
    if mouse_event_alt_key(event) {
      event.prevent_default()
      let connect_msg = match graph_edge_connect_source_node {
        Some(source_node_id) =>
          if source_node_id == node_id {
            @app.msg_cancel_selected_animation_graph_edge_connect()
          } else {
            @app.msg_complete_selected_animation_graph_edge_connect(node_id)
          }
        None => @app.msg_begin_selected_animation_graph_edge_connect(node_id)
      }
      dispatch(connect_msg)
    } else {
      dispatch(@app.msg_update_selected_animation_graph_default_node(node_id))
    }
  })
}

///|
fn graph_canvas_drop_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @html.Attrs {
  @html.Attrs::build()
  .on_dragover(fn(event) {
    event.prevent_default()
    match event.to_drag_event() {
      Some(drag_event) =>
        if drag_event_get_graph_node_payload(drag_event) != "" {
          drag_event_set_drop_move(drag_event)
        }
      None => ()
    }
    @cmd.none
  })
  .on_drop(fn(event) {
    event.prevent_default()
    match event.to_drag_event() {
      Some(drag_event) => {
        let node_id = drag_event_get_graph_node_payload(drag_event)
        if node_id != "" {
          let metrics = drag_event_canvas_metrics(drag_event)
          if metrics.length() >= 4 && metrics[2] > 0.0 && metrics[3] > 0.0 {
            let normalized_x = metrics[0] / metrics[2]
            let normalized_y = metrics[1] / metrics[3]
            return dispatch(
              @app.msg_move_selected_animation_graph_node(
                node_id, normalized_x, normalized_y,
              ),
            )
          }
        }
      }
      None => ()
    }
    @cmd.none
  })
}

///|
fn animation_graph_canvas_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  graph : @editor_bridge.AnimationGraphAssetDocument,
  graph_edge_connect_source_node : String?,
) -> @rabbita.Html {
  if graph.nodes.is_empty() {
    return @html.div(class="graph-canvas-empty", "No nodes yet")
  }
  let x_values = graph.nodes.map(fn(node) { node.position.x })
  let y_values = graph.nodes.map(fn(node) { node.position.y })
  let (min_x, max_x) = animation_graph_axis_bounds(x_values)
  let (min_y, max_y) = animation_graph_axis_bounds(y_values)
  let node_items : Array[@rabbita.Html] = []
  for node in graph.nodes {
    let left = animation_graph_canvas_project(node.position.x, min_x, max_x)
    let top = animation_graph_canvas_project(node.position.y, min_y, max_y)
    let is_default = graph.default_node == Some(node.id)
    let is_connect_source = graph_edge_connect_source_node == Some(node.id)
    node_items.push(
      @html.button(
        class=if is_default && is_connect_source {
          "graph-canvas-node default edge-source"
        } else if is_default {
          "graph-canvas-node default"
        } else if is_connect_source {
          "graph-canvas-node edge-source"
        } else {
          "graph-canvas-node"
        },
        style=[
          "left: \{(left * 100.0).to_string()}%",
          "top: \{(top * 100.0).to_string()}%",
        ],
        attrs=graph_node_drag_attrs(
          node.id,
          dispatch,
          graph_edge_connect_source_node,
        ),
        [
          @html.span(class="graph-canvas-node-id", node.id),
          @html.span(
            class="graph-canvas-node-kind",
            animation_graph_node_kind_label(node.kind),
          ),
        ],
      ),
    )
  }
  let edge_rows : Array[@rabbita.Html] = []
  for node in graph.nodes {
    for edge in node.edges {
      edge_rows.push(
        @html.div(
          class="graph-canvas-edge-row",
          node.id + " -> " + edge.to + "  (w=" + edge.weight.to_string() + ")",
        ),
      )
    }
  }
  @html.div(class="graph-canvas-shell", [
    @html.div(
      class="graph-canvas",
      attrs=graph_canvas_drop_attrs(dispatch),
      node_items,
    ),
    if edge_rows.is_empty() {
      @html.div(class="graph-canvas-edge-empty", "No edges yet")
    } else {
      @html.div(class="graph-canvas-edge-list", edge_rows)
    },
  ])
}

///|
fn animation_graph_edge_editor(
  dispatch : @rabbita.Dispatch[@app.Msg],
  node_id : String,
  edge_index : Int,
  edge : @editor_bridge.AnimationGraphEdgeDocument,
) -> @rabbita.Html {
  @html.div(class="graph-edge-row", [
    labeled_input("Target", edge.to, fn(value) {
      dispatch(
        @app.msg_update_selected_animation_graph_edge_target(
          node_id, edge_index, value,
        ),
      )
    }),
    labeled_input("Weight", edge.weight.to_string(), fn(value) {
      dispatch(
        @app.msg_update_selected_animation_graph_edge_weight(
          node_id, edge_index, value,
        ),
      )
    }),
    @html.button(
      class="small-button graph-edge-remove",
      on_click=dispatch(
        @app.msg_remove_selected_animation_graph_edge(node_id, edge_index),
      ),
      "Remove Edge",
    ),
  ])
}

///|
fn animation_graph_node_card(
  dispatch : @rabbita.Dispatch[@app.Msg],
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node : @editor_bridge.AnimationGraphNodeDocument,
) -> @rabbita.Html {
  let is_default = graph.default_node == Some(node.id)
  let edge_editors : Array[@rabbita.Html] = []
  for edge_index = 0
      edge_index < node.edges.length()
      edge_index = edge_index + 1 {
    edge_editors.push(
      animation_graph_edge_editor(
        dispatch,
        node.id,
        edge_index,
        node.edges[edge_index],
      ),
    )
  }
  @html.div(class="component-card", [
    @html.div(class="component-card-header", [
      @html.span(
        class="component-card-title",
        node.id + " • " + animation_graph_node_kind_label(node.kind),
      ),
      @html.button(
        class="component-card-menu-toggle",
        on_click=dispatch(
          @app.msg_remove_selected_animation_graph_node(node.id),
        ),
        "✕",
      ),
    ]),
    @html.div(class="component-card-body", [
      @html.div(class="inspector-block", [
        @html.div(class="kv", [
          @html.span(class="kv-key", "Position"),
          @html.span(
            class="kv-value",
            "\{node.position.x.to_string()}, \{node.position.y.to_string()}",
          ),
        ]),
        @html.div(class="kv", [
          @html.span(class="kv-key", "Edges"),
          @html.span(class="kv-value", node.edges.length().to_string()),
        ]),
        @html.button(
          class="small-button",
          on_click=dispatch(@app.msg_add_selected_animation_graph_edge(node.id)),
          "Add Edge",
        ),
        if edge_editors.is_empty() {
          @html.div(class="kv-value", "No edges yet")
        } else {
          @html.div(class="graph-edge-list", edge_editors)
        },
        match animation_graph_node_clip_path(node.kind) {
          Some(clip_path) =>
            labeled_input("Clip Asset Path", clip_path, fn(value) {
              dispatch(
                @app.msg_update_selected_animation_graph_node_clip_path(
                  node.id,
                  value,
                ),
              )
            })
          None => @html.nothing
        },
        @html.div(class="inspector-actions", [
          @html.button(
            class=if is_default {
              "small-button disabled"
            } else {
              "small-button"
            },
            on_click=if is_default {
              @cmd.none
            } else {
              dispatch(
                @app.msg_update_selected_animation_graph_default_node(node.id),
              )
            },
            if is_default {
              "Default Node"
            } else {
              "Set Default Node"
            },
          ),
        ]),
      ]),
    ]),
  ])
}

///|
fn custom_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let draft = model.custom_component_json_draft(
    entity.id,
    component.kind,
    component.data,
  )
  let error = model.custom_component_json_error(entity.id, component.kind)
  @html.div(class="inspector-block", [
    @html.div(class="kv", [
      @html.span(class="kv-key", "Kind"),
      @html.span(class="kv-value", component.kind),
    ]),
    @html.textarea(
      class="field-input custom-json-editor",
      value=draft,
      placeholder="{\"hp\": 10}",
      on_input=fn(value) {
        dispatch(@app.msg_update_custom_component_json(component.kind, value))
      },
      @html.nothing,
    ),
    match error {
      Some(message) => @html.div(class="component-error", message)
      None => @html.nothing
    },
    @html.div(class="inspector-actions", [
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_commit_custom_component_json(component.kind)),
        "Apply JSON",
      ),
    ]),
  ])
}

///|
fn autotile_rule_set_label(
  rule_set : @editor_bridge.AutoTileRuleSetDocument,
) -> String {
  match rule_set {
    @editor_bridge.Bitmask4 => "Bitmask4"
    @editor_bridge.Bitmask8 => "Bitmask8"
    @editor_bridge.Wang => "Wang"
  }
}

///|
fn autotile_component_body(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  layer : @editor_bridge.AutoTileLayer2dComponent,
) -> @rabbita.Html {
  let palette_draft = if model.autotile_palette_json_draft.trim() == "" {
    layer.palette.to_json().stringify(indent=2)
  } else {
    model.autotile_palette_json_draft
  }
  let palette_lines = layer.palette.map(fn(entry) {
    "terrain \{entry.terrain}: " + entry.fallback_region_name
  })
  @html.div(class="inspector-block", [
    labeled_input("Atlas Asset Path", layer.atlas_asset_path, fn(value) {
      dispatch(@app.msg_update_selected_autotile_atlas_path(value))
    }),
    labeled_input("Tile Width", layer.tile_size.x.to_string(), fn(value) {
      dispatch(@app.msg_update_selected_autotile_tile_width(value))
    }),
    labeled_input("Tile Height", layer.tile_size.y.to_string(), fn(value) {
      dispatch(@app.msg_update_selected_autotile_tile_height(value))
    }),
    labeled_input("Origin X", layer.origin.x.to_string(), fn(value) {
      dispatch(@app.msg_update_selected_autotile_origin_x(value))
    }),
    labeled_input("Origin Y", layer.origin.y.to_string(), fn(value) {
      dispatch(@app.msg_update_selected_autotile_origin_y(value))
    }),
    labeled_input("Rule Set", autotile_rule_set_label(layer.rule_set), fn(
      value,
    ) {
      dispatch(@app.msg_update_selected_autotile_rule_set(value))
    }),
    @html.label(class="field-label", "Palette Rules (JSON)"),
    @html.textarea(
      class="field-input custom-json-editor",
      value=palette_draft,
      placeholder="[{\"terrain\":1,\"fallback_region_name\":\"terrain_0\",\"fallback_atlas_index\":0,\"bitmask4_rules\":[],\"bitmask8_rules\":[],\"wang_rules\":[]}]",
      on_input=fn(value) {
        dispatch(@app.msg_update_selected_autotile_palette_json(value))
      },
      @html.nothing,
    ),
    match model.autotile_palette_json_error {
      Some(message) => @html.div(class="component-error", message)
      None => @html.nothing
    },
    @html.div(class="inspector-actions", [
      @html.button(
        class="small-button",
        on_click=dispatch(@app.msg_commit_selected_autotile_palette_json()),
        "Apply Palette JSON",
      ),
    ]),
    labeled_input("Brush Terrain", model.autotile_brush_terrain.to_string(), fn(
      value,
    ) {
      dispatch(@app.msg_update_autotile_brush_terrain(value))
    }),
    @html.div(class="kv", [
      @html.span(class="kv-key", "Cells"),
      @html.span(class="kv-value", layer.cells.length().to_string()),
    ]),
    @html.div(class="kv", [
      @html.span(class="kv-key", "Palette"),
      @html.span(class="kv-value", layer.palette.length().to_string()),
    ]),
    if palette_lines.is_empty() {
      @html.div(class="kv-value", "No palette entries")
    } else {
      @html.div(class="kv-value", palette_lines.join(" | "))
    },
    @html.div(
      class="kv-value",
      "Use AutoTile Paint / Erase / Fill tools in viewport to edit cells.",
    ),
  ])
}
