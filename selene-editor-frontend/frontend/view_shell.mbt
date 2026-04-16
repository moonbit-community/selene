///|
fn viewport_drop_attrs(dispatch : @rabbita.Dispatch[@app.Msg]) -> @html.Attrs {
  @html.Attrs::build()
  .handler("dragover", fn(event, _scheduler) {
    event.prevent_default()
    match event.to_drag_event() {
      Some(drag_event) => drag_event_set_drop_copy(drag_event)
      None => ()
    }
  })
  .handler("drop", fn(event, scheduler) {
    event.prevent_default()
    let cmd = match current_dragged_asset() {
      Some(asset_path) =>
        match event.to_drag_event() {
          Some(drag_event) =>
            match drag_drop_translation(drag_event) {
              Some(translation) =>
                dispatch(
                  @app.msg_add_sprite_from_asset_at(asset_path, translation),
                )
              None => @cmd.none
            }
          None => @cmd.none
        }
      None =>
        match event.to_drag_event() {
          Some(drag_event) => {
            let asset_path = drag_event_get_asset_payload(drag_event)
            if asset_path == "" {
              @cmd.none
            } else {
              match drag_drop_translation(drag_event) {
                Some(translation) =>
                  dispatch(
                    @app.msg_add_sprite_from_asset_at(asset_path, translation),
                  )
                None => @cmd.none
              }
            }
          }
          None => @cmd.none
        }
    }
    clear_dragged_asset()
    schedule_cmd(scheduler, cmd)
  })
}

///|
fn toolbar_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  current : @shared.PreviewTool,
  tool : @shared.PreviewTool,
  label : String,
  icon : String,
) -> @rabbita.Html {
  @html.button(
    class=if current == tool {
      "small-button icon-button active"
    } else {
      "small-button icon-button"
    },
    on_click=dispatch(@app.msg_set_tool(tool)),
    attrs=hint_attrs(dispatch, label),
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn action_button(
  dispatch : @rabbita.Dispatch[@app.Msg],
  label : String,
  icon : String,
  msg : @app.Msg,
  enabled? : Bool = true,
  primary? : Bool = false,
) -> @rabbita.Html {
  let class = if primary {
    if enabled {
      "small-button icon-button primary-button"
    } else {
      "small-button icon-button primary-button disabled"
    }
  } else if enabled {
    "small-button icon-button"
  } else {
    "small-button icon-button disabled"
  }
  @html.button(
    class~,
    on_click=if enabled { dispatch(msg) } else { @cmd.none },
    attrs=if enabled {
      hint_attrs(dispatch, label)
    } else {
      @html.Attrs::build()
    },
    @html.span(class="icon-glyph", icon),
  )
}

///|
fn info_message(model : @app.ViewState) -> String {
  let move_snap = if model.move_snap_enabled {
    "on (" + model.move_snap_step.to_string() + ")"
  } else {
    "off"
  }
  model.hover_hint.unwrap_or(
    "Tool: " +
    @app.tool_label(model.active_tool) +
    " | Move snap: " +
    move_snap +
    " | " +
    model.status,
  )
}

///|
fn entry_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  @html.div(class="editor-root entry-root", [
    @html.div(class="welcome", [
      @html.div(class="welcome-logo", [
        @html.div(class="welcome-logo-mark", "S"),
        @html.div(class="welcome-logo-text", [
          @html.h1(class="welcome-title", "Selene Editor"),
          @html.p(
            class="welcome-tagline",
            "Build Selene-native 2D scenes, atlases, animations, and prefabs",
          ),
        ]),
      ]),
      @html.p(
        class="welcome-copy",
        "Open a local Selene project directory to start editing scenes and resources.",
      ),
      @html.button(
        class="small-button primary-button",
        on_click=dispatch(@app.msg_open_project()),
        "Open Project",
      ),
      @html.div(class="welcome-status", model.status),
    ]),
  ])
}

///|
fn scene_migration_dialog_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  preview : @editor_bridge.SceneMigrationPreview,
) -> @rabbita.Html {
  let items = preview.changes.map(fn(change) {
    @html.li(class="migration-change-item", [
      @html.div(class="migration-change-path", change.path),
      @html.div(class="migration-change-reason", change.reason),
      @html.div(class="migration-change-value", "Use: " + change.migrated_value),
    ])
  })
  @html.div(class="modal-backdrop", [
    @html.div(class="modal-card", [
      @html.h2(class="modal-title", "Scene Format Migration Required"),
      @html.p(
        class="modal-copy",
        "This scene is not SNF v1 yet. Review the planned migration before loading it.",
      ),
      @html.div(class="migration-summary", [
        @html.div(class="migration-label", "File"),
        @html.div(class="migration-value", preview.path),
      ]),
      @html.ul(class="migration-change-list", items),
      @html.div(class="modal-actions", [
        @html.button(
          class="small-button",
          on_click=dispatch(@app.msg_cancel_scene_migration()),
          "Cancel",
        ),
        @html.button(
          class="small-button primary-button",
          on_click=dispatch(@app.msg_confirm_scene_migration()),
          "Migrate and Load",
        ),
      ]),
    ]),
  ])
}

///|
fn animation_migration_dialog_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  let items = model.pending_animation_migration_paths.map(fn(path) {
    @html.li(class="migration-change-item", [
      @html.div(class="migration-change-path", path),
      @html.div(class="migration-change-reason", "Legacy animation asset"),
      @html.div(class="migration-change-value", "Will generate clip + graph"),
    ])
  })
  let progress = if model.animation_migration_total <= 0 {
    "0/0"
  } else {
    "\{model.animation_migration_completed}/\{model.animation_migration_total}"
  }
  let running = model.animation_migration_in_progress
  @html.div(class="modal-backdrop", [
    @html.div(class="modal-card", [
      @html.h2(class="modal-title", "Legacy Animation Migration"),
      @html.p(
        class="modal-copy",
        "Legacy .anim.json assets were found. Migrate them to Selene v3 clip/graph assets.",
      ),
      @html.div(class="migration-summary", [
        @html.div(class="migration-label", "Progress"),
        @html.div(class="migration-value", progress),
      ]),
      @html.div(class="migration-summary", [
        @html.div(class="migration-label", "Scene"),
        @html.div(
          class="migration-value",
          model.pending_animation_migration_scene_path.unwrap_or(
            current_scene_path(model),
          ),
        ),
      ]),
      @html.ul(class="migration-change-list", items),
      @html.div(class="modal-actions", [
        @html.button(
          class=if running { "small-button disabled" } else { "small-button" },
          on_click=if running {
            @cmd.none
          } else {
            dispatch(@app.msg_cancel_animation_migration())
          },
          "Cancel",
        ),
        @html.button(
          class=if running {
            "small-button primary-button disabled"
          } else {
            "small-button primary-button"
          },
          on_click=if running {
            @cmd.none
          } else {
            dispatch(@app.msg_confirm_animation_migration())
          },
          if running {
            "Migrating..."
          } else {
            "Migrate"
          },
        ),
      ]),
    ]),
  ])
}

///|
fn conflict_copy_path(path : String) -> String {
  if path.has_suffix(".scene.json") {
    let stem = path[:path.length() - ".scene.json".length()].to_string()
    stem + ".conflict.scene.json"
  } else {
    path + ".conflict.scene.json"
  }
}

///|
fn scene_conflict_bar_view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.ViewState,
) -> @rabbita.Html {
  match model.scene_session {
    Some(session) =>
      match session.conflict_state {
        @app.NoConflict => @html.nothing
        @app.ExternalSceneChanged(path~, disk_hash~, disk_revision~) =>
          @html.div(class="scene-conflict-bar", [
            @html.div(class="scene-conflict-copy", [
              @html.div(
                class="scene-conflict-title",
                "Scene changed on disk while local edits are unsaved",
              ),
              @html.div(
                class="scene-conflict-meta",
                "Path: \{path} · Disk hash: \{disk_hash} · Revision: \{disk_revision.to_string()}",
              ),
            ]),
            @html.div(class="scene-conflict-actions", [
              @html.button(
                class="small-button",
                on_click=dispatch(@app.msg_resolve_scene_conflict_keep_mine()),
                "Keep Mine",
              ),
              @html.button(
                class="small-button",
                on_click=dispatch(@app.msg_resolve_scene_conflict_reload_disk()),
                "Reload Disk",
              ),
              @html.button(
                class="small-button",
                on_click=@cmd.raw_effect(fn(scheduler) {
                  let default_path = conflict_copy_path(path)
                  let next_path = prompt_text(
                    "Save conflict copy as", default_path,
                  )
                  if next_path.trim() != "" {
                    schedule_cmd(
                      scheduler,
                      dispatch(
                        @app.msg_resolve_scene_conflict_save_as(next_path),
                      ),
                    )
                  }
                }),
                "Save As",
              ),
            ]),
          ])
        @app.SaveConflict(
          path~,
          base_hash~,
          current_hash~,
          base_revision~,
          current_revision~
        ) =>
          @html.div(class="scene-conflict-bar", [
            @html.div(class="scene-conflict-copy", [
              @html.div(
                class="scene-conflict-title",
                "Scene save conflict detected",
              ),
              @html.div(
                class="scene-conflict-meta",
                "Path: \{path} · Local \{base_hash}@\{base_revision.to_string()} · Disk \{current_hash}@\{current_revision.to_string()}",
              ),
            ]),
            @html.div(class="scene-conflict-actions", [
              @html.button(
                class="small-button",
                on_click=dispatch(@app.msg_resolve_scene_conflict_keep_mine()),
                "Keep Mine",
              ),
              @html.button(
                class="small-button",
                on_click=dispatch(@app.msg_resolve_scene_conflict_reload_disk()),
                "Reload Disk",
              ),
              @html.button(
                class="small-button",
                on_click=@cmd.raw_effect(fn(scheduler) {
                  let default_path = conflict_copy_path(path)
                  let next_path = prompt_text(
                    "Save conflict copy as", default_path,
                  )
                  if next_path.trim() != "" {
                    schedule_cmd(
                      scheduler,
                      dispatch(
                        @app.msg_resolve_scene_conflict_save_as(next_path),
                      ),
                    )
                  }
                }),
                "Save As",
              ),
            ]),
          ])
      }
    None => @html.nothing
  }
}

///|
fn view(
  dispatch : @rabbita.Dispatch[@app.Msg],
  model : @app.Model,
) -> @rabbita.Html {
  let model = @app.view_state(model)
  if model.current_root is None {
    return entry_view(dispatch, model)
  }
  let selected_entity_ids = if model.selected_entity_ids.length() > 0 {
    model.selected_entity_ids
  } else {
    match model.selected_entity_id {
      Some(id) => [id]
      None => []
    }
  }
  let scene_tree = match current_scene(model) {
    Some(scene) => tree_view(dispatch, scene, None, selected_entity_ids, 0)
    None => [@html.div(class="empty", "No scene loaded")]
  }
  let inspector = match model.selected_entity() {
    Some(entity) => {
      let component_cards = entity.components.map(fn(component) {
        component_card(dispatch, model, entity, component)
      })
      @html.div(class="panel-body", [
        if selected_entity_ids.length() > 1 {
          @html.div(
            class="inspector-selection-note",
            "Editing \{selected_entity_ids.length().to_string()} selected entities (Transform2d and Visibility apply to all)",
          )
        } else {
          @html.nothing
        },
        labeled_input_with_commit(
          "Name",
          entity.name,
          fn(value) { dispatch(@app.msg_rename_selected(value)) },
          fn() { dispatch(@app.msg_commit_scene_edit_transaction()) },
        ),
        @html.div(class="inspector-actions", [
          @html.button(
            class="small-button",
            on_click=dispatch(@app.msg_save_selected_as_prefab()),
            "Save As Prefab",
          ),
          @html.button(
            class="small-button",
            on_click=dispatch(@app.msg_open_add_component_panel()),
            "Add Component (C)",
          ),
        ]),
        if model.add_component_panel_open {
          add_component_panel(dispatch, model, entity)
        } else {
          @html.nothing
        },
        @html.div(class="component-stack", component_cards),
      ])
    }
    None => selected_asset_view(dispatch, model)
  }
  let body = @html.div(class="editor-root", [
    @html.div(class="topbar", [
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Project"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Open Project",
            "O",
            @app.msg_open_project(),
            enabled=true,
            primary=true,
          ),
          action_button(
            dispatch,
            "Save Scene (Cmd/Ctrl+S)",
            "S",
            @app.msg_save_scene(),
            enabled=current_scene(model) is Some(_),
          ),
        ]),
      ]),
      @html.div(class="topbar-section", [
        @html.div(class="topbar-section-label", "Scene"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            "Undo (Cmd/Ctrl+Z)",
            "U",
            @app.msg_undo_scene(),
            enabled=model.can_undo(),
          ),
          action_button(
            dispatch,
            "Redo (Shift+Cmd/Ctrl+Z)",
            "R",
            @app.msg_redo_scene(),
            enabled=model.can_redo(),
          ),
          action_button(
            dispatch,
            "Add Sprite",
            "+",
            @app.msg_add_sprite_entity(),
            enabled=current_scene(model) is Some(_),
          ),
          action_button(
            dispatch,
            "Add Text",
            "T",
            @app.msg_add_text_entity(),
            enabled=current_scene(model) is Some(_),
          ),
          action_button(
            dispatch,
            "Delete Selected (Delete)",
            "⌫",
            @app.msg_delete_selected(),
            enabled=model.has_entity_selection(),
          ),
          action_button(
            dispatch,
            "Frame Selection (F)",
            "⛶",
            @app.msg_frame_selection(),
            enabled=model.has_entity_selection(),
          ),
        ]),
      ]),
      @html.div(class="topbar-section topbar-tools", [
        @html.div(class="topbar-section-label", "Tools"),
        @html.div(class="topbar-group", [
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_select(),
            "Select (V)",
            "↖",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_drag_canvas(),
            "Drag Canvas (H)",
            "H",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_translate(),
            "Move (W, hold Shift for temporary snap)",
            "✥",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_rotate(),
            "Rotate (E, Hold Shift for 15° snap)",
            "⟳",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_scale(),
            "Scale (R)",
            "⬚",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_autotile_paint(),
            "AutoTile Paint",
            "P",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_autotile_erase(),
            "AutoTile Erase",
            "E",
          ),
          toolbar_button(
            dispatch,
            model.active_tool,
            @shared.preview_tool_autotile_fill(),
            "AutoTile Fill",
            "F",
          ),
        ]),
      ]),
      @html.div(class="topbar-section topbar-options", [
        @html.div(class="topbar-section-label", "Options"),
        @html.div(class="topbar-group", [
          action_button(
            dispatch,
            if model.move_snap_enabled {
              "Disable Move Snap"
            } else {
              "Enable Move Snap"
            },
            "⌗",
            @app.msg_toggle_move_snap(),
            enabled=true,
            primary=model.move_snap_enabled,
          ),
          action_button(
            dispatch,
            "Decrease Move Snap Step (-)",
            "−",
            @app.msg_adjust_move_snap_step(-1),
            enabled=true,
          ),
          @html.span(
            class="topbar-option-readout",
            "Step \{model.move_snap_step.to_string()}",
          ),
          action_button(
            dispatch,
            "Increase Move Snap Step (+)",
            "+",
            @app.msg_adjust_move_snap_step(1),
            enabled=true,
          ),
        ]),
      ]),
    ]),
    scene_conflict_bar_view(dispatch, model),
    @html.div(class="content", [
      @html.div(
        class="sidebar-column",
        style=sidebar_column_style(model),
        attrs=sidebar_column_attrs(model),
        [
          @html.div(class="panel scene-browser-panel", [
            @html.h2("Scenes"),
            scene_browser_view(dispatch, model),
          ]),
          sidebar_splitter("scene-assets"),
          @html.div(class="panel assets-panel", [
            @html.h2("Assets"),
            asset_panel_view(dispatch, model),
          ]),
          sidebar_splitter("assets-tree"),
          @html.div(class="panel tree-panel", [
            @html.h2("Scene Tree"),
            @html.div(class="panel-body scene-tree-panel-body", [
              @html.div(class="scene-tree-scroll", scene_tree),
            ]),
          ]),
        ],
      ),
      @html.div(class="panel viewport-panel", [
        @html.h2("Viewport"),
        @html.div(class="viewport-frame", [
          @html.canvas(
            id="canvas",
            class="viewport-canvas",
            attrs=viewport_drop_attrs(dispatch),
            @html.nothing,
          ),
        ]),
      ]),
      @html.div(class="panel inspector-panel", [
        @html.h2("Inspector"),
        inspector,
      ]),
    ]),
    @html.div(class="info-bar", info_message(model)),
  ])
  let overlay = match model.pending_scene_migration {
    Some(preview) => scene_migration_dialog_view(dispatch, preview)
    None =>
      if model.pending_animation_migration_paths.is_empty() {
        @html.nothing
      } else {
        animation_migration_dialog_view(dispatch, model)
      }
  }
  @html.div(class="editor-shell", [body, overlay])
}

///|
#warnings("-alert_unstable")
pub fn start() -> Unit {
  let (dispatch, root) = @rabbita.cell_with_dispatch(
    model=@app.new_model(),
    update~,
    view~,
  )
  let app = @rabbita.new(root)
  app.with_init(dispatch(@app.msg_initialize()))
  app.mount("app")
}
