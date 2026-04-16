///|
pub fn LdtkLevel::field_number_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[Double]? {
  ldtk_field_number_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_string_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[String]? {
  ldtk_field_string_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_bool_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[Bool]? {
  ldtk_field_bool_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_vec2_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[@math.Vec2]? {
  ldtk_field_vec2_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_color_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[String]? {
  ldtk_field_color_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_file_path_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[String]? {
  ldtk_field_file_path_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_enum_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[String]? {
  ldtk_field_enum_array(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_entity_iid(
  self : LdtkLevel,
  identifier : String,
) -> String? {
  ldtk_field_entity_iid(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_entity_iids(
  self : LdtkLevel,
  identifier : String,
) -> Array[String]? {
  ldtk_field_entity_iids(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_entity_ref(
  self : LdtkLevel,
  identifier : String,
) -> LdtkEntityReference? {
  ldtk_field_entity_ref(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_entity_refs(
  self : LdtkLevel,
  identifier : String,
) -> Array[LdtkEntityReference]? {
  ldtk_field_entity_refs(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_tile(
  self : LdtkLevel,
  identifier : String,
) -> LdtkTilesetRect? {
  ldtk_field_tile(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_tiles(
  self : LdtkLevel,
  identifier : String,
) -> Array[LdtkTilesetRect]? {
  ldtk_field_tiles(self.field_instances, identifier)
}

///|
pub struct LdtkWorld {
  iid : String
  identifier : String
  world_layout : String?
  levels : Array[LdtkLevel]
}

///|
pub struct LdtkTilesetCustomData {
  data : String
  tile_id : Int
}

///|
pub struct LdtkTilesetEnumTag {
  enum_value_id : String
  tile_ids : Array[Int]
}

///|
pub struct LdtkTilesetDefinition {
  uid : Int
  identifier : String
  rel_path : String?
  tile_grid_size : Int
  px_wid : Int
  px_hei : Int
  spacing : Int
  padding : Int
  custom_data : Array[LdtkTilesetCustomData]
  enum_tags : Array[LdtkTilesetEnumTag]
  tags : Array[String]
  tags_source_enum_uid : Int?
}

///|
pub struct LdtkIntGridValueDefinition {
  value : Int
  color : String?
  identifier : String?
}

///|
pub struct LdtkLayerDefinition {
  uid : Int
  identifier : String
  layer_type : String?
  int_grid_values : Array[LdtkIntGridValueDefinition]
}

///|
pub struct LdtkFieldDefinition {
  uid : Int
  identifier : String
  field_type : String
  is_array : Bool
  can_be_null : Bool
  default_override : Json?
}

///|
pub struct LdtkEntityDefinition {
  uid : Int
  identifier : String
  width : Int
  height : Int
  color : String?
  tags : Array[String]
  field_definitions : Array[LdtkFieldDefinition]
}

///|
pub struct LdtkEnumValueDefinition {
  id : String
  color : String?
}

///|
pub struct LdtkEnumDefinition {
  uid : Int
  identifier : String
  external_rel_path : String?
  tags : Array[String]
  values : Array[LdtkEnumValueDefinition]
}

///|
pub struct LdtkProjectDefinitions {
  tilesets : Array[LdtkTilesetDefinition]
  layers : Array[LdtkLayerDefinition]
  entities : Array[LdtkEntityDefinition]
  enums : Array[LdtkEnumDefinition]
  external_enums : Array[LdtkEnumDefinition]
}

///|
pub struct LdtkProject {
  source_path : String?
  external_levels : Bool
  world_layout : String?
  bg_color : String?
  default_level_width : Int?
  default_level_height : Int?
  defs : LdtkProjectDefinitions
  levels : Array[LdtkLevel]
  worlds : Array[LdtkWorld]
}

///|
pub struct LdtkIndexedLevel {
  indices : LdtkLevelIndices
  level : LdtkLevel
}

///|
pub fn empty_ldtk_project_definitions() -> LdtkProjectDefinitions {
  { tilesets: [], layers: [], entities: [], enums: [], external_enums: [] }
}

///|
pub fn empty_ldtk_level() -> LdtkLevel {
  {
    identifier: "",
    iid: "",
    uid: 0,
    world_x: 0,
    world_y: 0,
    px_wid: 0,
    px_hei: 0,
    bg_color: None,
    bg_pos: None,
    bg_rel_path: None,
    external_rel_path: None,
    neighbours: [],
    field_instances: [],
    layer_instances: [],
  }
}

///|
pub fn empty_ldtk_project() -> LdtkProject {
  {
    source_path: None,
    external_levels: false,
    world_layout: None,
    bg_color: None,
    default_level_width: None,
    default_level_height: None,
    defs: empty_ldtk_project_definitions(),
    levels: [],
    worlds: [],
  }
}

///|
pub fn load_ldtk_project(path : String) -> LdtkProject {
  let project = load_ldtk_project_raw(path)
  resolve_external_ldtk_levels(project)
}

///|
pub fn load_ldtk_project_raw(path : String) -> LdtkProject {
  guard load_ldtk_text_document(path) is Some(source) else {
    return empty_ldtk_project()
  }
  { ..parse_ldtk_project_source(source), source_path: Some(path) }
}

///|
pub fn LdtkProject::from_ldtk_json(json : Json) -> LdtkProject {
  guard json_object(json) is Some(root) else { return empty_ldtk_project() }
  parse_ldtk_project(root)
}

///|
pub fn LdtkProject::resolve_path(self : LdtkProject, path : String) -> String {
  if is_absolute_path(path) {
    return path
  }
  match self.source_path {
    Some(source_path) => resolve_relative_asset_path(source_path, path)
    None => path
  }
}

///|
pub fn LdtkProject::indexed_levels(
  self : LdtkProject,
) -> Array[LdtkIndexedLevel] {
  let indexed_levels : Array[LdtkIndexedLevel] = []
  for level_index, level in self.levels {
    indexed_levels.push({
      indices: LdtkLevelIndices::in_root(level_index),
      level,
    })
  }
  for world_index, world in self.worlds {
    for level_index, level in world.levels {
      indexed_levels.push({
        indices: LdtkLevelIndices::in_world(world_index, level_index),
        level,
      })
    }
  }
  indexed_levels
}

///|
pub fn LdtkProject::raw_indexed_levels(
  self : LdtkProject,
) -> Array[LdtkIndexedLevel] {
  ldtk_project_raw_view(self).indexed_levels()
}

///|
pub fn LdtkProject::level_at_indices(
  self : LdtkProject,
  indices : LdtkLevelIndices,
) -> LdtkLevel? {
  match indices.world {
    Some(world_index) => {
      if world_index < 0 || world_index >= self.worlds.length() {
        return None
      }
      let world = self.worlds[world_index]
      if indices.level < 0 || indices.level >= world.levels.length() {
        return None
      }
      Some(world.levels[indices.level])
    }
    None => {
      if indices.level < 0 || indices.level >= self.levels.length() {
        return None
      }
      Some(self.levels[indices.level])
    }
  }
}

///|
pub fn LdtkProject::raw_level_at_indices(
  self : LdtkProject,
  indices : LdtkLevelIndices,
) -> LdtkLevel? {
  ldtk_project_raw_view(self).level_at_indices(indices)
}

///|
pub fn LdtkProject::find_level_by_selection(
  self : LdtkProject,
  selection : LdtkLevelSelection,
) -> LdtkIndexedLevel? {
  for indexed in self.indexed_levels() {
    if selection.is_match(indexed.indices, indexed.level) {
      return Some(indexed)
    }
  }
  None
}

///|
pub fn LdtkProject::raw_find_level_by_selection(
  self : LdtkProject,
  selection : LdtkLevelSelection,
) -> LdtkIndexedLevel? {
  ldtk_project_raw_view(self).find_level_by_selection(selection)
}

///|
pub fn LdtkProject::level_by_iid(
  self : LdtkProject,
  iid : String,
) -> LdtkLevel? {
  for indexed in self.indexed_levels() {
    if indexed.level.iid == iid {
      return Some(indexed.level)
    }
  }
  None
}

///|
pub fn LdtkProject::raw_level_by_iid(
  self : LdtkProject,
  iid : String,
) -> LdtkLevel? {
  ldtk_project_raw_view(self).level_by_iid(iid)
}
