///|
fn subscribe_preview_events_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @rabbita.Cmd {
  @cmd.custom_cmd(fn(scheduler : @cmd.Scheduler) {
    @preview.set_event_sink(
      Some(fn(event) {
        schedule_cmd(scheduler, dispatch(@app.msg_preview_event(event)))
      }),
    )
  })
}

///|
fn subscribe_shortcuts_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @rabbita.Cmd {
  @cmd.custom_cmd(fn(scheduler : @cmd.Scheduler) {
    subscribe_shortcuts_forever(
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_undo_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_redo_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_save_scene())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_delete_selected())) },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_frame_selection())) },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_select())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_drag_canvas())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_translate())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_rotate())),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_set_tool(@shared.preview_tool_scale())),
        )
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_expand_all_asset_folders()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_collapse_all_asset_folders()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_insert_selected_resource()))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(-1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(1)))
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_move_selected_resource(-1000000)),
        )
      },
      fn() {
        schedule_cmd(
          scheduler,
          dispatch(@app.msg_move_selected_resource(1000000)),
        )
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(-10)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_move_selected_resource(10)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_adjust_move_snap_step(-1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_adjust_move_snap_step(1)))
      },
      fn() {
        schedule_cmd(scheduler, dispatch(@app.msg_open_add_component_panel()))
      },
      fn() { schedule_cmd(scheduler, dispatch(@app.msg_clear_selection())) },
    )
  })
}

///|
fn run_preview_command(command : @bridge.PreviewCommand) -> Unit {
  match command {
    @bridge.PreviewCommand::Bootstrap => @preview.bootstrap()
    @bridge.PreviewCommand::ClearScene => @preview.clear_scene()
    @bridge.PreviewCommand::LoadScene(scene) => @preview.load_scene(scene)
    @bridge.PreviewCommand::SetSelection(primary~, ids~) =>
      @preview.set_selection(primary, ids)
    @bridge.PreviewCommand::SetTool(tool) => @preview.set_tool(tool)
    @bridge.PreviewCommand::SetMoveSnap(enabled~, step~) =>
      @preview.set_move_snap(enabled, step)
    @bridge.PreviewCommand::SetAutoTileBrushTerrain(terrain) =>
      @preview.set_autotile_brush_terrain(terrain)
    @bridge.PreviewCommand::SetAnimationPreviewPaused(paused) =>
      @preview.set_animation_preview_paused(paused)
    @bridge.PreviewCommand::SetAnimationPreviewSpeed(speed) =>
      @preview.set_animation_preview_speed(speed)
    @bridge.PreviewCommand::SeekAnimationPreview(seconds) =>
      @preview.seek_animation_preview(seconds)
    @bridge.PreviewCommand::FrameSelection => @preview.frame_selection()
  }
}

///|
fn preview_cmd(command : @bridge.PreviewCommand) -> @rabbita.Cmd {
  @cmd.custom_cmd(
    fn(_scheduler) { run_preview_command(command) },
    kind=@cmd.after_render,
  )
}

///|
fn rpc_effect_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  target : @app.RpcTarget,
  request : @shared.RpcRequestEnvelope,
) -> @rabbita.Cmd {
  rpc_cmd(request, fn(response) { rpc_msg_from_response(target, response) }, fn(
    result,
  ) {
    log_rpc_result_error(rpc_scope(target), result)
    match result {
      Ok(msg) => dispatch(msg)
      Err(message) => dispatch(rpc_transport_error_msg(target, message))
    }
  })
}

///|
fn effect_to_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  effect : @app.Effect,
) -> @rabbita.Cmd {
  match effect {
    @app.Rpc(target~, request~) => rpc_effect_cmd(dispatch, target, request)
    @app.SubscribeServiceEvents => subscribe_events_cmd(dispatch)
    @app.SubscribePreviewEvents => subscribe_preview_events_cmd(dispatch)
    @app.SubscribeKeyboardShortcuts => subscribe_shortcuts_cmd(dispatch)
    @app.SubscribeSidebarLayout => subscribe_sidebar_layout_cmd(dispatch)
    @app.Preview(command) => preview_cmd(command)
  }
}

///|
fn effects_to_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
  effects : Array[@app.Effect],
) -> @rabbita.Cmd {
  @cmd.batch(effects.map(fn(effect) { effect_to_cmd(dispatch, effect) }))
}

///|
fn ensure_selected_asset_visible_cmd() -> @rabbita.Cmd {
  @cmd.custom_cmd(
    fn(_scheduler) { scroll_selected_asset_row_into_view() },
    kind=@cmd.after_render,
  )
}

///|
fn focus_component_search_cmd() -> @rabbita.Cmd {
  @cmd.custom_cmd(
    fn(_scheduler) { focus_component_search_input() },
    kind=@cmd.after_render,
  )
}

///|
fn subscribe_sidebar_layout_cmd(
  dispatch : @rabbita.Dispatch[@app.Msg],
) -> @rabbita.Cmd {
  @cmd.custom_cmd(fn(scheduler : @cmd.Scheduler) {
    subscribe_sidebar_layout_forever(fn(scene_ratio, assets_ratio) {
      schedule_cmd(
        scheduler,
        dispatch(@app.msg_set_sidebar_layout(scene_ratio, assets_ratio)),
      )
    })
  })
}

///|
fn sync_asset_tree_sticky_overlay_cmd() -> @rabbita.Cmd {
  @cmd.custom_cmd(
    fn(_scheduler) { sync_asset_tree_sticky_overlay() },
    kind=@cmd.after_render,
  )
}

///|
fn sync_resource_previews_cmd() -> @rabbita.Cmd {
  @cmd.custom_cmd(
    fn(_scheduler) { sync_resource_previews() },
    kind=@cmd.after_render,
  )
}
///|
fn scene_browser_action_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  hint : String,
  on_click : @rabbita.Cmd,
  label : String,
) -> @rabbita.Html {
  @html.button(
    class="small-button compact-icon-button",
    attrs=hint_attrs(dispatch, hint),
    on_click~,
    label,
  )
}

///|
fn scene_browser_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  let items : Array[@rabbita.Html] = []
  let scene_path = current_scene_path(model)
  let scene = current_scene(model)
  let scene_name = match scene {
    Some(scene) => scene.name
    None => "(none)"
  }
  let scene_prompt_name = match scene {
    Some(scene) => scene.name
    None => "scene"
  }
  for scene_ref in model.scene_refs {
    let is_selected = scene_path == scene_ref.path
    let is_startup = match model.manifest {
      Some(manifest) => manifest.startup_scene == scene_ref.path
      None => false
    }
    items.push(
      @html.div(
        class=if is_selected {
          "tree-item scene-browser-item selected"
        } else {
          "tree-item scene-browser-item"
        },
        on_click=dispatch(@app.msg_open_scene(scene_ref.path)),
        [
          @html.span(class="scene-browser-path", scene_ref.path),
          if is_startup {
            @html.span(class="scene-pill", "startup")
          } else {
            @html.nothing
          },
        ],
      ),
    )
  }
  @html.div(class="panel-body scene-browser-body", [
    @html.div(class="scene-browser-head", [
      @html.div(class="scene-browser-current", [
        @html.div(class="scene-browser-meta-row", [
          @html.span(class="scene-browser-meta-label", "Name"),
          @html.span(class="scene-browser-meta-value", scene_name),
        ]),
        @html.div(
          class="scene-browser-meta-row",
          attrs=hint_attrs(dispatch, scene_path),
          [
            @html.span(class="scene-browser-meta-label", "Path"),
            @html.span(
              class="scene-browser-meta-value scene-browser-meta-path",
              scene_path,
            ),
          ],
        ),
      ]),
      @html.div(class="scene-browser-toolbar", [
        scene_browser_action_button(
          dispatch,
          "Create Scene",
          @cmd.custom_cmd(fn(scheduler) {
            let name = prompt_text("Scene name", "scene")
            if name.trim() != "" {
              schedule_cmd(scheduler, dispatch(@app.msg_create_scene(name)))
            }
          }),
          "+",
        ),
        scene_browser_action_button(
          dispatch,
          "Rename Current Scene",
          @cmd.custom_cmd(fn(scheduler) {
            let name = prompt_text("Scene name", scene_prompt_name)
            if name.trim() != "" {
              schedule_cmd(
                scheduler,
                dispatch(@app.msg_rename_current_scene(name)),
              )
            }
          }),
          "✎",
        ),
        scene_browser_action_button(
          dispatch,
          "Delete Current Scene",
          dispatch(@app.msg_delete_current_scene()),
          "−",
        ),
        scene_browser_action_button(
          dispatch,
          "Set Current As Startup",
          dispatch(@app.msg_set_current_scene_as_startup()),
          "★",
        ),
      ]),
    ]),
    if items.is_empty() {
      @html.div(class="empty", "No scenes in this project")
    } else {
      @html.div(class="scene-browser-list", [
        @html.div(class="scene-browser-list-header", [
          @html.span("All Scenes"),
          @html.span(
            class="scene-browser-list-count",
            items.length().to_string(),
          ),
        ]),
        @html.div(class="scene-browser-list-body", items),
      ])
    },
  ])
}
