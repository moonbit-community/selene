///|
pub fn msg_open_scene(path : String) -> Msg {
  OpenScene(path)
}

///|
pub fn msg_create_scene(name : String) -> Msg {
  CreateScene(name)
}

///|
pub fn msg_delete_current_scene() -> Msg {
  DeleteCurrentScene
}

///|
pub fn msg_set_current_scene_as_startup() -> Msg {
  SetCurrentSceneAsStartup
}

///|
pub fn msg_rename_current_scene(value : String) -> Msg {
  RenameCurrentScene(value)
}

///|
pub fn msg_save_scene() -> Msg {
  SaveScene
}

///|
pub fn msg_add_sprite_entity() -> Msg {
  AddSpriteEntity
}

///|
pub fn msg_add_sprite_from_asset_at(
  path : String,
  translation : @editor_bridge.Vec2Doc,
) -> Msg {
  AddSpriteFromAssetAt(path, translation)
}

///|
pub fn msg_add_text_entity() -> Msg {
  AddTextEntity
}

///|
pub fn msg_delete_selected() -> Msg {
  DeleteSelected
}
