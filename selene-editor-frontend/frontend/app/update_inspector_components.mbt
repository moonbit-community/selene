///|
fn autotile_rule_set_from_string(
  value : String,
) -> Result[@editor_bridge.AutoTileRuleSetDocument, String] {
  match value.trim().to_lower() {
    "bitmask4" | "4" => Ok(@editor_bridge.autotile_rule_set_bitmask4())
    "bitmask8" | "8" => Ok(@editor_bridge.autotile_rule_set_bitmask8())
    "wang" => Ok(@editor_bridge.autotile_rule_set_wang())
    _ => Err("AutoTile rule set must be Bitmask4, Bitmask8, or Wang")
  }
}

///|
fn selected_autotile_layer_component(
  model : Model,
) -> (@editor_bridge.EntityDocument, @editor_bridge.AutoTileLayer2dComponent)? {
  guard model.selected_entity() is Some(entity) else { return None }
  let component : @editor_bridge.AutoTileLayer2dComponent? = component_of(
    entity, "AutoTileLayer2d",
  )
  component.map(fn(value) { (entity, value) })
}

///|
fn update_selected_autotile_layer_component(
  model : Model,
  updater : (@editor_bridge.AutoTileLayer2dComponent) -> @editor_bridge.ComponentDocument,
) -> Model {
  match selected_autotile_layer_component(model) {
    Some((_, layer)) => update_selected_component(model, updater(layer))
    None => model
  }
}

///|
fn parse_autotile_palette_json(
  draft : String,
) -> Result[Array[@editor_bridge.AutoTilePaletteEntryDocument], String] {
  let source = if draft.trim() == "" { "[]" } else { draft }
  let json = @json.parse(source) catch {
    err => return Err("Invalid AutoTile palette JSON: " + err.to_string())
  }
  let decoded : Result[
    Array[@editor_bridge.AutoTilePaletteEntryDocument],
    Error,
  ] = try? @json.from_json(json)
  match decoded {
    Ok(palette) => Ok(palette)
    Err(err) =>
      Err(
        "AutoTile palette must be an array of palette entries: " +
        err.to_string(),
      )
  }
}

///|
fn update_inspector_components(
  msg : InspectorComponentsMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
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
                let default_data = @editor_bridge.custom_component_default_data_for(
                  kind,
                ).unwrap_or_else(fn() {
                  @editor_bridge.default_custom_component_data()
                })
                let next = update_selected_component(
                  model,
                  @editor_bridge.component_document(kind, default_data),
                )
                let key = component_state_key(entity.id, kind)
                let custom_component_json_drafts = next.custom_component_json_drafts
                custom_component_json_drafts.set(
                  key,
                  default_data.stringify(indent=2),
                )
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
            [rpc_effect(RpcPrefabSave(path, prefab))],
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
            [rpc_effect(RpcAtlasSave(path, atlas))],
            { ..model, status: "Saving atlas..." },
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
    UpdateSelectedAutoTileAtlasPath(value) => {
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size,
          origin=layer.origin,
          atlas_asset_path=value.trim().to_owned(),
          rule_set=layer.rule_set,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTileTileWidth(value) => {
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size.with_x(
            parse_positive_double_or(layer.tile_size.x, value),
          ),
          origin=layer.origin,
          atlas_asset_path=layer.atlas_asset_path,
          rule_set=layer.rule_set,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTileTileHeight(value) => {
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size.with_y(
            parse_positive_double_or(layer.tile_size.y, value),
          ),
          origin=layer.origin,
          atlas_asset_path=layer.atlas_asset_path,
          rule_set=layer.rule_set,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTileOriginX(value) => {
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size,
          origin=layer.origin.with_x(parse_double_or(layer.origin.x, value)),
          atlas_asset_path=layer.atlas_asset_path,
          rule_set=layer.rule_set,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTileOriginY(value) => {
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size,
          origin=layer.origin.with_y(parse_double_or(layer.origin.y, value)),
          atlas_asset_path=layer.atlas_asset_path,
          rule_set=layer.rule_set,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTileRuleSet(value) => {
      let rule_set = match autotile_rule_set_from_string(value) {
        Ok(rule_set) => rule_set
        Err(message) => {
          let next = push_log(model, message)
          return ([], { ..next, status: message })
        }
      }
      let staged = with_started_scene_edit_transaction(
        model, "Edit AutoTile Layer",
      )
      let next = update_selected_autotile_layer_component(staged, fn(layer) {
        @editor_bridge.autotile_layer2d_component(
          tile_size=layer.tile_size,
          origin=layer.origin,
          atlas_asset_path=layer.atlas_asset_path,
          rule_set~,
          palette=layer.palette,
          cells=layer.cells,
        )
      })
      apply_scene_change_without_history(staged, next)
    }
    UpdateSelectedAutoTilePaletteJson(value) =>
      (
        [],
        {
          ..model,
          autotile_palette_json_draft: value,
          autotile_palette_json_error: None,
        },
      )
    CommitSelectedAutoTilePaletteJson =>
      match selected_autotile_layer_component(model) {
        Some((_, layer)) => {
          let draft = if model.autotile_palette_json_draft.trim() == "" {
            layer.palette.to_json().stringify(indent=2)
          } else {
            model.autotile_palette_json_draft
          }
          match parse_autotile_palette_json(draft) {
            Ok(palette) => {
              let staged = with_started_scene_edit_transaction(
                model, "Edit AutoTile Layer Palette",
              )
              let next = update_selected_autotile_layer_component(staged, fn(
                layer,
              ) {
                @editor_bridge.autotile_layer2d_component(
                  tile_size=layer.tile_size,
                  origin=layer.origin,
                  atlas_asset_path=layer.atlas_asset_path,
                  rule_set=layer.rule_set,
                  palette~,
                  cells=layer.cells,
                )
              })
              apply_scene_change(staged, {
                ..next,
                autotile_palette_json_draft: palette
                .to_json()
                .stringify(indent=2),
                autotile_palette_json_error: None,
                status: "Updated AutoTile palette",
              })
            }
            Err(message) => {
              let next = push_log(model, message)
              (
                [],
                {
                  ..next,
                  status: message,
                  autotile_palette_json_error: Some(message),
                },
              )
            }
          }
        }
        None => ([], model)
      }
    UpdateAutoTileBrushTerrain(value) => {
      let terrain = parse_positive_int_or(model.autotile_brush_terrain, value)
      let next = {
        ..model,
        autotile_brush_terrain: terrain,
        status: "AutoTile brush terrain: " + terrain.to_string(),
      }
      (sync_preview_effects(next), next)
    }
  }
}
