///|
fn component_body_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  match component.kind {
    "Transform2d" => {
      let transform : @editor_bridge.Transform2dComponent? = @app.component_of(
        entity, "Transform2d",
      )
      match transform {
        Some(transform) => transform_component_body(dispatch, transform)
        None => @html.div(class="component-error", "Invalid Transform2d data")
      }
    }
    "Visibility" => {
      let visibility_component : @editor_bridge.VisibilityComponent? = @app.component_of(
        entity, "Visibility",
      )
      match visibility_component {
        Some(visibility_component) =>
          visibility_component_body(dispatch, visibility_component)
        None => @html.div(class="component-error", "Invalid Visibility data")
      }
    }
    "Sprite" => {
      let sprite_component : @editor_bridge.SpriteComponent? = @app.component_of(
        entity, "Sprite",
      )
      match sprite_component {
        Some(sprite_component) => sprite_component_body(sprite_component)
        None => @html.div(class="component-error", "Invalid Sprite data")
      }
    }
    "Text2d" => {
      let text_component : @editor_bridge.Text2dComponent? = @app.component_of(
        entity, "Text2d",
      )
      match text_component {
        Some(text_component) => text_component_body(dispatch, text_component)
        None => @html.div(class="component-error", "Invalid Text2d data")
      }
    }
    "AnimationPlayer" => {
      let player : @editor_bridge.AnimationPlayerComponent? = @app.component_of(
        entity, "AnimationPlayer",
      )
      match player {
        Some(player) => animation_player_component_body(dispatch, player)
        None =>
          @html.div(class="component-error", "Invalid AnimationPlayer data")
      }
    }
    "AnimationTransitions" => {
      let transitions : @editor_bridge.AnimationTransitionsComponent? = @app.component_of(
        entity, "AnimationTransitions",
      )
      match transitions {
        Some(transitions) =>
          animation_transitions_component_body(dispatch, transitions)
        None =>
          @html.div(
            class="component-error",
            "Invalid AnimationTransitions data",
          )
      }
    }
    "AutoTileLayer2d" => {
      let layer : @editor_bridge.AutoTileLayer2dComponent? = @app.component_of(
        entity, "AutoTileLayer2d",
      )
      match layer {
        Some(layer) => autotile_component_body(dispatch, model, layer)
        None =>
          @html.div(class="component-error", "Invalid AutoTileLayer2d data")
      }
    }
    _ =>
      match @editor_bridge.builtin_component_kind_from_string(component.kind) {
        Some(_) =>
          @html.div(class="kv-value", component.data.stringify(indent=2))
        None => custom_component_body(dispatch, model, entity, component)
      }
  }
}

///|
fn remove_component_menu_item(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let reason = model.selected_component_remove_block_reason(component.kind)
  @html.button(
    class=if reason is Some(_) {
      "small-button component-menu-item disabled"
    } else {
      "small-button component-menu-item"
    },
    on_click=if reason is Some(_) {
      @cmd.none
    } else {
      dispatch(@app.msg_remove_component(component.kind))
    },
    attrs=if reason is Some(reason) {
      hint_attrs(dispatch, reason)
    } else {
      hint_attrs(dispatch, "Remove Component")
    },
    "Remove Component",
  )
}

///|
fn component_card(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  entity : @editor_bridge.EntityDocument,
  component : @editor_bridge.ComponentDocument,
) -> @rabbita.Html {
  let collapsed = model.component_card_collapsed(entity.id, component.kind)
  let menu_open = model.component_menu_is_open(component.kind)
  @html.div(class="component-card", [
    @html.div(class="component-card-header", [
      @html.button(
        class="component-card-toggle",
        on_click=dispatch(@app.msg_toggle_component_collapsed(component.kind)),
        if collapsed {
          "▸"
        } else {
          "▾"
        },
      ),
      @html.span(class="component-card-title", component.kind),
      @html.button(
        class="component-card-menu-toggle",
        on_click=dispatch(@app.msg_toggle_component_menu(Some(component.kind))),
        "⋮",
      ),
    ]),
    if menu_open {
      @html.div(class="component-card-menu", [
        remove_component_menu_item(dispatch, model, component),
      ])
    } else {
      @html.nothing
    },
    if collapsed {
      @html.nothing
    } else {
      @html.div(class="component-card-body", [
        component_body_view(dispatch, model, entity, component),
      ])
    },
  ])
}

///|
fn add_component_group(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  entity : @editor_bridge.EntityDocument,
  title : String,
  kinds : Array[@editor_bridge.BuiltinComponentKind],
) -> @rabbita.Html {
  let buttons : Array[@rabbita.Html] = []
  for kind in kinds {
    if @editor_bridge.builtin_component_category(kind) != title {
      continue
    }
    if !model.builtin_component_matches_query(kind) {
      continue
    }
    let kind_name = @editor_bridge.builtin_component_kind_to_string(kind)
    let exists = entity.component(kind_name) is Some(_)
    buttons.push(
      @html.button(
        class=if exists {
          "small-button component-add-item existing disabled"
        } else {
          "small-button component-add-item"
        },
        attrs=if exists {
          hint_attrs(dispatch, kind_name + " is already on this entity")
        } else {
          hint_attrs(dispatch, "Add " + kind_name + " component")
        },
        on_click=if exists {
          @cmd.none
        } else {
          dispatch(@app.msg_add_builtin_component(kind))
        },
        if exists {
          kind_name + " (Existing)"
        } else {
          kind_name
        },
      ),
    )
  }
  if buttons.is_empty() {
    @html.nothing
  } else {
    @html.div(class="component-add-group", [
      @html.div(class="component-add-group-title", title),
      @html.div(class="component-add-list", buttons),
    ])
  }
}

///|
fn matching_builtin_component_count(model : @app.ViewState) -> Int {
  let matched : Array[@editor_bridge.BuiltinComponentKind] = []
  for kind in @editor_bridge.builtin_component_kinds() {
    if model.builtin_component_matches_query(kind) {
      matched.push(kind)
    }
  }
  matched.length()
}

///|
fn close_add_component_panel_on_escape_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @html.Attrs {
  @html.Attrs::build().on_keydown(fn(event) {
    if keyboard_event_is_escape_key(event) {
      event.prevent_default()
      keyboard_event_blur_target(event)
      return dispatch(@app.msg_close_add_component_panel())
    }
    @cmd.none
  })
}

///|
fn custom_component_kind_input_attrs(
  dispatch : @rabbita.Dispatch[@app.Msg],
  value : String,
) -> @html.Attrs {
  @html.Attrs::build().on_keydown(fn(event) {
    if keyboard_event_is_escape_key(event) {
      event.prevent_default()
      keyboard_event_blur_target(event)
      return dispatch(@app.msg_close_add_component_panel())
    }
    if keyboard_event_is_enter_key(event) {
      event.prevent_default()
      return dispatch(@app.msg_add_custom_component(value))
    }
    @cmd.none
  })
}

///|
fn add_component_panel(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
  entity : @editor_bridge.EntityDocument,
) -> @rabbita.Html {
  let matches_count = matching_builtin_component_count(model)
  let has_query = model.component_search_query_normalized() != ""
  let groups = [
    add_component_group(
      dispatch,
      model,
      entity,
      "Common",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Rendering",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Physics2D",
      @editor_bridge.builtin_component_kinds(),
    ),
    add_component_group(
      dispatch,
      model,
      entity,
      "Animation",
      @editor_bridge.builtin_component_kinds(),
    ),
  ]
  @html.div(class="component-add-panel", [
    @html.div(class="component-add-header", [
      @html.span(class="component-add-title", "Add Component"),
      @html.button(
        class="small-button component-add-close",
        on_click=dispatch(@app.msg_close_add_component_panel()),
        "×",
      ),
    ]),
    @html.input(
      class="field-input component-search-input",
      value=model.component_search_query,
      placeholder="Search components...",
      on_input=fn(value) {
        dispatch(@app.msg_set_component_search_query(value))
      },
      attrs=close_add_component_panel_on_escape_attrs(dispatch),
      @html.nothing,
    ),
    @html.div(
      class="component-add-search-meta",
      if has_query {
        "\{matches_count} matching built-in components"
      } else {
        "Browse by category or type to filter"
      },
    ),
    if has_query && matches_count == 0 {
      @html.div(
        class="component-add-empty",
        "No built-in components match this search",
      )
    } else {
      @html.nothing
    },
    @html.div(class="component-add-groups", groups),
    @html.div(class="component-add-group custom", [
      @html.div(class="component-add-group-title", "Custom"),
      @html.input(
        class="field-input",
        value=model.add_custom_component_kind,
        placeholder="Custom component kind",
        on_input=fn(value) {
          dispatch(@app.msg_update_add_custom_component_kind(value))
        },
        attrs=custom_component_kind_input_attrs(
          dispatch,
          model.add_custom_component_kind,
        ),
        @html.nothing,
      ),
      @html.button(
        class="small-button component-add-item",
        on_click=dispatch(
          @app.msg_add_custom_component(model.add_custom_component_kind),
        ),
        "New Custom JSON Component",
      ),
    ]),
  ])
}
