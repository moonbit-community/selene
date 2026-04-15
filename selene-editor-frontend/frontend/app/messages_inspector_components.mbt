///|
pub fn msg_open_add_component_panel() -> Msg {
  OpenAddComponentPanel
}

///|
pub fn msg_close_add_component_panel() -> Msg {
  CloseAddComponentPanel
}

///|
pub fn msg_set_component_search_query(value : String) -> Msg {
  SetComponentSearchQuery(value)
}

///|
pub fn msg_toggle_component_collapsed(kind : String) -> Msg {
  ToggleComponentCollapsed(kind)
}

///|
pub fn msg_toggle_component_menu(kind : String?) -> Msg {
  ToggleComponentMenu(kind)
}

///|
pub fn msg_add_builtin_component(
  kind : @editor_bridge.BuiltinComponentKind,
) -> Msg {
  AddBuiltinComponent(kind)
}

///|
pub fn msg_remove_component(kind : String) -> Msg {
  RemoveComponent(kind)
}

///|
pub fn msg_update_add_custom_component_kind(value : String) -> Msg {
  UpdateAddCustomComponentKind(value)
}

///|
pub fn msg_add_custom_component(kind : String) -> Msg {
  AddCustomComponent(kind)
}

///|
pub fn msg_update_custom_component_json(kind : String, value : String) -> Msg {
  UpdateCustomComponentJson(kind, value)
}

///|
pub fn msg_commit_custom_component_json(kind : String) -> Msg {
  CommitCustomComponentJson(kind)
}

///|
pub fn msg_update_selected_prefab_name(value : String) -> Msg {
  UpdateSelectedPrefabName(value)
}

///|
pub fn msg_save_selected_prefab() -> Msg {
  SaveSelectedPrefab
}

///|
pub fn msg_update_selected_atlas_name(value : String) -> Msg {
  UpdateSelectedAtlasName(value)
}

///|
pub fn msg_update_selected_atlas_tile_width(value : String) -> Msg {
  UpdateSelectedAtlasTileWidth(value)
}

///|
pub fn msg_update_selected_atlas_tile_height(value : String) -> Msg {
  UpdateSelectedAtlasTileHeight(value)
}

///|
pub fn msg_update_selected_atlas_columns(value : String) -> Msg {
  UpdateSelectedAtlasColumns(value)
}

///|
pub fn msg_update_selected_atlas_rows(value : String) -> Msg {
  UpdateSelectedAtlasRows(value)
}

///|
pub fn msg_update_selected_atlas_spacing_x(value : String) -> Msg {
  UpdateSelectedAtlasSpacingX(value)
}

///|
pub fn msg_update_selected_atlas_spacing_y(value : String) -> Msg {
  UpdateSelectedAtlasSpacingY(value)
}

///|
pub fn msg_update_selected_atlas_margin_x(value : String) -> Msg {
  UpdateSelectedAtlasMarginX(value)
}

///|
pub fn msg_update_selected_atlas_margin_y(value : String) -> Msg {
  UpdateSelectedAtlasMarginY(value)
}

///|
pub fn msg_update_selected_atlas_anchor_x(value : String) -> Msg {
  UpdateSelectedAtlasAnchorX(value)
}

///|
pub fn msg_update_selected_atlas_anchor_y(value : String) -> Msg {
  UpdateSelectedAtlasAnchorY(value)
}

///|
pub fn msg_save_selected_atlas() -> Msg {
  SaveSelectedAtlas
}

///|
pub fn msg_rename_selected(value : String) -> Msg {
  RenameSelected(value)
}

///|
pub fn msg_update_selected_translate_x(value : String) -> Msg {
  UpdateSelectedTranslateX(value)
}

///|
pub fn msg_update_selected_translate_y(value : String) -> Msg {
  UpdateSelectedTranslateY(value)
}

///|
pub fn msg_update_selected_rotation(value : String) -> Msg {
  UpdateSelectedRotation(value)
}

///|
pub fn msg_update_selected_text(value : String) -> Msg {
  UpdateSelectedText(value)
}

///|
pub fn msg_toggle_selected_visibility() -> Msg {
  ToggleSelectedVisibility
}

///|
pub fn msg_update_selected_autotile_atlas_path(value : String) -> Msg {
  UpdateSelectedAutoTileAtlasPath(value)
}

///|
pub fn msg_update_selected_autotile_tile_width(value : String) -> Msg {
  UpdateSelectedAutoTileTileWidth(value)
}

///|
pub fn msg_update_selected_autotile_tile_height(value : String) -> Msg {
  UpdateSelectedAutoTileTileHeight(value)
}

///|
pub fn msg_update_selected_autotile_origin_x(value : String) -> Msg {
  UpdateSelectedAutoTileOriginX(value)
}

///|
pub fn msg_update_selected_autotile_origin_y(value : String) -> Msg {
  UpdateSelectedAutoTileOriginY(value)
}

///|
pub fn msg_update_selected_autotile_rule_set(value : String) -> Msg {
  UpdateSelectedAutoTileRuleSet(value)
}

///|
pub fn msg_update_selected_autotile_palette_json(value : String) -> Msg {
  UpdateSelectedAutoTilePaletteJson(value)
}

///|
pub fn msg_commit_selected_autotile_palette_json() -> Msg {
  CommitSelectedAutoTilePaletteJson
}

///|
pub fn msg_update_autotile_brush_terrain(value : String) -> Msg {
  UpdateAutoTileBrushTerrain(value)
}
