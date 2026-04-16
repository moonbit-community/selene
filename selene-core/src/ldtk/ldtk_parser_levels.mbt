///|
pub fn LdtkProject::level_set_for_selection(
  self : LdtkProject,
  selection : LdtkLevelSelection,
  behavior : LdtkLevelSpawnBehavior,
) -> LdtkLevelSet {
  guard self.find_level_by_selection(selection) is Some(selected) else {
    return empty_ldtk_level_set()
  }
  let iids : Array[String] = [selected.level.iid]
  match behavior {
    UseZeroTranslation => ()
    UseWorldTranslation(load_level_neighbors) =>
      if load_level_neighbors {
        for neighbour in selected.level.neighbours {
          if self.level_by_iid(neighbour.level_iid) is Some(_) {
            iids.push(neighbour.level_iid)
          }
        }
      }
  }
  ldtk_level_set_from_iids(iids)
}

///|
pub fn LdtkProject::raw_level_set_for_selection(
  self : LdtkProject,
  selection : LdtkLevelSelection,
  behavior : LdtkLevelSpawnBehavior,
) -> LdtkLevelSet {
  ldtk_project_raw_view(self).level_set_for_selection(selection, behavior)
}

///|
pub fn LdtkProject::tileset_by_uid(
  self : LdtkProject,
  uid : Int,
) -> LdtkTilesetDefinition? {
  for tileset in self.defs.tilesets {
    if tileset.uid == uid {
      return Some(tileset)
    }
  }
  None
}

///|
pub fn LdtkTilesetDefinition::tile_custom_data(
  self : LdtkTilesetDefinition,
  tile_id : Int,
) -> String? {
  for custom_data in self.custom_data {
    if custom_data.tile_id == tile_id {
      return Some(custom_data.data)
    }
  }
  None
}

///|
pub fn LdtkTilesetDefinition::tile_enum_tags(
  self : LdtkTilesetDefinition,
  tile_id : Int,
) -> Array[String] {
  let tags : Array[String] = []
  for enum_tag in self.enum_tags {
    for tagged_tile_id in enum_tag.tile_ids {
      if tagged_tile_id == tile_id {
        tags.push(enum_tag.enum_value_id)
        break
      }
    }
  }
  tags
}

///|
pub fn LdtkProject::tileset_tile_custom_data(
  self : LdtkProject,
  tileset_uid : Int,
  tile_id : Int,
) -> String? {
  guard self.tileset_by_uid(tileset_uid) is Some(tileset) else { return None }
  tileset.tile_custom_data(tile_id)
}

///|
pub fn LdtkProject::tileset_tile_enum_tags(
  self : LdtkProject,
  tileset_uid : Int,
  tile_id : Int,
) -> Array[String] {
  guard self.tileset_by_uid(tileset_uid) is Some(tileset) else { return [] }
  tileset.tile_enum_tags(tile_id)
}

///|
pub fn LdtkProject::layer_definition_by_identifier(
  self : LdtkProject,
  identifier : String,
) -> LdtkLayerDefinition? {
  for layer_definition in self.defs.layers {
    if layer_definition.identifier == identifier {
      return Some(layer_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::entity_definition_by_identifier(
  self : LdtkProject,
  identifier : String,
) -> LdtkEntityDefinition? {
  for entity_definition in self.defs.entities {
    if entity_definition.identifier == identifier {
      return Some(entity_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::entity_definition_by_uid(
  self : LdtkProject,
  uid : Int,
) -> LdtkEntityDefinition? {
  for entity_definition in self.defs.entities {
    if entity_definition.uid == uid {
      return Some(entity_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::enum_definition_by_identifier(
  self : LdtkProject,
  identifier : String,
) -> LdtkEnumDefinition? {
  for enum_definition in self.defs.enums {
    if enum_definition.identifier == identifier {
      return Some(enum_definition)
    }
  }
  for enum_definition in self.defs.external_enums {
    if enum_definition.identifier == identifier {
      return Some(enum_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::enum_definition_by_uid(
  self : LdtkProject,
  uid : Int,
) -> LdtkEnumDefinition? {
  for enum_definition in self.defs.enums {
    if enum_definition.uid == uid {
      return Some(enum_definition)
    }
  }
  for enum_definition in self.defs.external_enums {
    if enum_definition.uid == uid {
      return Some(enum_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::external_enum_definition_by_identifier(
  self : LdtkProject,
  identifier : String,
) -> LdtkEnumDefinition? {
  for enum_definition in self.defs.external_enums {
    if enum_definition.identifier == identifier {
      return Some(enum_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::external_enum_definition_by_uid(
  self : LdtkProject,
  uid : Int,
) -> LdtkEnumDefinition? {
  for enum_definition in self.defs.external_enums {
    if enum_definition.uid == uid {
      return Some(enum_definition)
    }
  }
  None
}

///|
pub fn LdtkProject::int_grid_color(
  self : LdtkProject,
  layer_identifier : String,
  value : Int,
) -> String? {
  guard self.layer_definition_by_identifier(layer_identifier)
    is Some(layer_definition) else {
    return None
  }
  for int_grid_value in layer_definition.int_grid_values {
    if int_grid_value.value == value {
      return int_grid_value.color
    }
  }
  None
}

///|
pub fn LdtkLevelSelection::is_match(
  self : LdtkLevelSelection,
  indices : LdtkLevelIndices,
  level : LdtkLevel,
) -> Bool {
  match self {
    Identifier(identifier) => identifier == level.identifier
    Indices(other_indices) => indices.equals(other_indices)
    Iid(iid) => iid == level.iid
    Uid(uid) => uid == level.uid
  }
}

///|
fn ldtk_project_raw_view(project : LdtkProject) -> LdtkProject {
  match project.source_path {
    Some(source_path) => {
      guard load_ldtk_text_document(source_path) is Some(source) else {
        return project
      }
      { ..parse_ldtk_project_source(source), source_path: Some(source_path) }
    }
    None => project
  }
}

///|
fn unique_ldtk_iids(iids : Array[String]) -> Array[String] {
  let unique : Array[String] = []
  for iid in iids {
    if iid.length() == 0 {
      continue
    }
    if !unique.contains(iid) {
      unique.push(iid)
    }
  }
  unique
}

///|
fn load_ldtk_text_document(path : String) -> String? {
  if @asset.read_bytes(path) is Some(bytes) {
    return Some(bytes.to_unchecked_string())
  }
  @asset.read_bytes(path).map(bytes => bytes.to_unchecked_string())
}

///|
fn parse_ldtk_project_source(source : String) -> LdtkProject {
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  guard parsed is Ok(root_json) else { return empty_ldtk_project() }
  LdtkProject::from_ldtk_json(root_json)
}

///|
fn parse_ldtk_project(root_object : Map[String, Json]) -> LdtkProject {
  {
    source_path: None,
    external_levels: field_bool(root_object, "externalLevels").unwrap_or(false),
    world_layout: field_string(root_object, "worldLayout"),
    bg_color: field_string(root_object, "bgColor"),
    default_level_width: field_int(root_object, "defaultLevelWidth"),
    default_level_height: field_int(root_object, "defaultLevelHeight"),
    defs: parse_ldtk_project_definitions(field_object(root_object, "defs")),
    levels: parse_ldtk_levels(field_json(root_object, "levels")),
    worlds: parse_ldtk_worlds(field_json(root_object, "worlds")),
  }
}

///|
fn parse_ldtk_project_definitions(
  defs_object : Map[String, Json]?,
) -> LdtkProjectDefinitions {
  guard defs_object is Some(object) else {
    return empty_ldtk_project_definitions()
  }
  {
    tilesets: parse_ldtk_tilesets(field_json(object, "tilesets")),
    layers: parse_ldtk_layer_definitions(field_json(object, "layers")),
    entities: parse_ldtk_entity_definitions(field_json(object, "entities")),
    enums: parse_ldtk_enum_definitions(field_json(object, "enums")),
    external_enums: parse_ldtk_enum_definitions(
      field_json(object, "externalEnums"),
    ),
  }
}

///|
fn parse_ldtk_tilesets(tilesets_json : Json?) -> Array[LdtkTilesetDefinition] {
  let tilesets : Array[LdtkTilesetDefinition] = []
  for object in json_object_array(tilesets_json) {
    tilesets.push({
      uid: field_int(object, "uid").unwrap_or(0),
      identifier: field_string(object, "identifier").unwrap_or(""),
      rel_path: field_string(object, "relPath"),
      tile_grid_size: field_int(object, "tileGridSize").unwrap_or(0),
      px_wid: field_int(object, "pxWid").unwrap_or(0),
      px_hei: field_int(object, "pxHei").unwrap_or(0),
      spacing: field_int(object, "spacing").unwrap_or(0),
      padding: field_int(object, "padding").unwrap_or(0),
      custom_data: parse_ldtk_tileset_custom_data(
        field_json(object, "customData"),
      ),
      enum_tags: parse_ldtk_tileset_enum_tags(field_json(object, "enumTags")),
      tags: parse_ldtk_string_array(field_json(object, "tags")),
      tags_source_enum_uid: field_int(object, "tagsSourceEnumUid"),
    })
  }
  tilesets
}

///|
fn parse_ldtk_tileset_custom_data(
  custom_data_json : Json?,
) -> Array[LdtkTilesetCustomData] {
  let custom_data : Array[LdtkTilesetCustomData] = []
  for object in json_object_array(custom_data_json) {
    custom_data.push({
      data: field_string(object, "data").unwrap_or(""),
      tile_id: field_int_any(object, ["tileId", "tileID"]).unwrap_or(0),
    })
  }
  custom_data
}

///|
fn parse_ldtk_tileset_enum_tags(
  enum_tags_json : Json?,
) -> Array[LdtkTilesetEnumTag] {
  let enum_tags : Array[LdtkTilesetEnumTag] = []
  for object in json_object_array(enum_tags_json) {
    enum_tags.push({
      enum_value_id: field_string_any(object, ["enumValueId", "enumValueID"]).unwrap_or(
        "",
      ),
      tile_ids: parse_ldtk_int_array(
        field_json_any(object, ["tileIds", "tileIDs"]),
      ),
    })
  }
  enum_tags
}

///|
fn parse_ldtk_worlds(worlds_json : Json?) -> Array[LdtkWorld] {
  let worlds : Array[LdtkWorld] = []
  for object in json_object_array(worlds_json) {
    worlds.push({
      iid: field_string(object, "iid").unwrap_or(""),
      identifier: field_string(object, "identifier").unwrap_or(""),
      world_layout: field_string(object, "worldLayout"),
      levels: parse_ldtk_levels(field_json(object, "levels")),
    })
  }
  worlds
}

///|
fn parse_ldtk_layer_definitions(
  layers_json : Json?,
) -> Array[LdtkLayerDefinition] {
  let layers : Array[LdtkLayerDefinition] = []
  for object in json_object_array(layers_json) {
    layers.push({
      uid: field_int(object, "uid").unwrap_or(0),
      identifier: field_string(object, "identifier").unwrap_or(""),
      layer_type: field_string(object, "type"),
      int_grid_values: parse_ldtk_int_grid_value_definitions(
        field_json(object, "intGridValues"),
      ),
    })
  }
  layers
}

///|
fn parse_ldtk_entity_definitions(
  entities_json : Json?,
) -> Array[LdtkEntityDefinition] {
  let entities : Array[LdtkEntityDefinition] = []
  for object in json_object_array(entities_json) {
    entities.push({
      uid: field_int(object, "uid").unwrap_or(0),
      identifier: field_string(object, "identifier").unwrap_or(""),
      width: field_int_any(object, ["width", "tileRectWidth"]).unwrap_or(0),
      height: field_int_any(object, ["height", "tileRectHeight"]).unwrap_or(0),
      color: field_string(object, "color"),
      tags: parse_ldtk_string_array(field_json(object, "tags")),
      field_definitions: parse_ldtk_field_definitions(
        field_json_any(object, ["fieldDefs", "fieldDefinitions"]),
      ),
    })
  }
  entities
}

///|
fn parse_ldtk_field_definitions(
  fields_json : Json?,
) -> Array[LdtkFieldDefinition] {
  let field_definitions : Array[LdtkFieldDefinition] = []
  for object in json_object_array(fields_json) {
    let type_name = field_string_any(object, ["type", "__type"]).unwrap_or("")
    let is_array = type_name.contains("Array") ||
      field_bool(object, "isArray").unwrap_or(false)
    field_definitions.push({
      uid: field_int(object, "uid").unwrap_or(0),
      identifier: field_string_any(object, ["identifier", "__identifier"]).unwrap_or(
        "",
      ),
      field_type: type_name,
      is_array,
      can_be_null: field_bool_any(object, ["canBeNull", "__canBeNull"]).unwrap_or(
        false,
      ),
      default_override: field_json_any(object, [
        "defaultOverride", "__defaultOverride",
      ]),
    })
  }
  field_definitions
}

///|
fn parse_ldtk_enum_definitions(enums_json : Json?) -> Array[LdtkEnumDefinition] {
  let enum_definitions : Array[LdtkEnumDefinition] = []
  for object in json_object_array(enums_json) {
    enum_definitions.push({
      uid: field_int(object, "uid").unwrap_or(0),
      identifier: field_string(object, "identifier").unwrap_or(""),
      external_rel_path: field_string(object, "externalRelPath"),
      tags: parse_ldtk_string_array(field_json(object, "tags")),
      values: parse_ldtk_enum_value_definitions(field_json(object, "values")),
    })
  }
  enum_definitions
}

///|
fn parse_ldtk_enum_value_definitions(
  values_json : Json?,
) -> Array[LdtkEnumValueDefinition] {
  let values : Array[LdtkEnumValueDefinition] = []
  for object in json_object_array(values_json) {
    values.push({
      id: field_string_any(object, ["id", "identifier"]).unwrap_or(""),
      color: field_string(object, "color"),
    })
  }
  values
}

///|
fn parse_ldtk_int_grid_value_definitions(
  values_json : Json?,
) -> Array[LdtkIntGridValueDefinition] {
  let values : Array[LdtkIntGridValueDefinition] = []
  for object in json_object_array(values_json) {
    values.push({
      value: field_int(object, "value").unwrap_or(0),
      color: field_string(object, "color"),
      identifier: field_string(object, "identifier"),
    })
  }
  values
}

///|
fn parse_ldtk_levels(levels_json : Json?) -> Array[LdtkLevel] {
  let levels : Array[LdtkLevel] = []
  for object in json_object_array(levels_json) {
    levels.push(parse_ldtk_level(object))
  }
  levels
}

///|
fn parse_ldtk_level(level_object : Map[String, Json]) -> LdtkLevel {
  {
    identifier: field_string_any(level_object, ["identifier", "__identifier"]).unwrap_or(
      "",
    ),
    iid: field_string(level_object, "iid").unwrap_or(""),
    uid: field_int(level_object, "uid").unwrap_or(0),
    world_x: field_int(level_object, "worldX").unwrap_or(0),
    world_y: field_int(level_object, "worldY").unwrap_or(0),
    px_wid: field_int(level_object, "pxWid").unwrap_or(0),
    px_hei: field_int(level_object, "pxHei").unwrap_or(0),
    bg_color: field_string_any(level_object, ["__bgColor", "bgColor"]),
    bg_pos: parse_ldtk_level_background_position(
      field_json_any(level_object, ["__bgPos", "bgPos"]),
    ),
    bg_rel_path: field_string(level_object, "bgRelPath"),
    external_rel_path: field_string(level_object, "externalRelPath"),
    neighbours: parse_ldtk_neighbours(
      field_json_any(level_object, ["__neighbours", "neighbours"]),
    ),
    field_instances: parse_ldtk_field_instances(
      field_json(level_object, "fieldInstances"),
    ),
    layer_instances: parse_ldtk_layer_instances(
      field_json(level_object, "layerInstances"),
    ),
  }
}

///|
fn parse_ldtk_neighbours(neighbours_json : Json?) -> Array[LdtkNeighbour] {
  let neighbours : Array[LdtkNeighbour] = []
  for object in json_object_array(neighbours_json) {
    neighbours.push({
      level_iid: field_string(object, "levelIid").unwrap_or(""),
      dir: field_string(object, "dir"),
    })
  }
  neighbours
}

///|
fn parse_ldtk_field_instances(
  instances_json : Json?,
) -> Array[LdtkFieldInstance] {
  let instances : Array[LdtkFieldInstance] = []
  for object in json_object_array(instances_json) {
    instances.push({
      identifier: field_string_any(object, ["__identifier", "identifier"]).unwrap_or(
        "",
      ),
      value_type: field_string_any(object, ["__type", "type"]).unwrap_or(""),
      value: field_json_any(object, ["__value", "value"]),
      def_uid: field_int_any(object, ["defUid", "__defUid"]),
    })
  }
  instances
}

///|
fn parse_ldtk_layer_instances(layers_json : Json?) -> Array[LdtkLayerInstance] {
  let layers : Array[LdtkLayerInstance] = []
  for object in json_object_array(layers_json) {
    layers.push({
      iid: field_string(object, "iid").unwrap_or(""),
      identifier: field_string_any(object, ["__identifier", "identifier"]).unwrap_or(
        "",
      ),
      layer_type: field_string_any(object, ["__type", "type"]).unwrap_or(""),
      level_id: field_int_any(object, ["levelId", "__levelId"]).unwrap_or(0),
      layer_def_uid: field_int_any(object, ["layerDefUid", "__layerDefUid"]).unwrap_or(
        0,
      ),
      c_wid: field_int_any(object, ["__cWid", "cWid"]).unwrap_or(0),
      c_hei: field_int_any(object, ["__cHei", "cHei"]).unwrap_or(0),
      grid_size: field_int_any(object, ["__gridSize", "gridSize"]).unwrap_or(0),
      opacity: field_number_any(object, ["__opacity", "opacity"]).unwrap_or(1.0),
      visible: field_bool(object, "visible").unwrap_or(true),
      optional_rules: parse_ldtk_int_array(
        field_json_any(object, ["optionalRules", "__optionalRules"]),
      ),
      override_tileset_uid: field_int_any(object, [
        "overrideTilesetUid", "__overrideTilesetUid",
      ]),
      px_offset_x: field_int_any(object, ["pxOffsetX", "__pxOffsetX"]).unwrap_or(
        0,
      ),
      px_offset_y: field_int_any(object, ["pxOffsetY", "__pxOffsetY"]).unwrap_or(
        0,
      ),
      px_total_offset_x: field_int_any(object, [
        "__pxTotalOffsetX", "pxTotalOffsetX",
      ]).unwrap_or(0),
      px_total_offset_y: field_int_any(object, [
        "__pxTotalOffsetY", "pxTotalOffsetY",
      ]).unwrap_or(0),
      seed: field_int(object, "seed").unwrap_or(0),
      tileset_def_uid: field_int_any(object, [
        "__tilesetDefUid", "tilesetDefUid",
      ]),
      tileset_rel_path: field_string_any(object, [
        "__tilesetRelPath", "tilesetRelPath",
      ]),
      int_grid_csv: parse_ldtk_int_array(
        field_json_any(object, ["intGridCsv", "int_grid_csv"]),
      ),
      auto_layer_tiles: parse_ldtk_tile_instances(
        field_json(object, "autoLayerTiles"),
      ),
      grid_tiles: parse_ldtk_tile_instances(field_json(object, "gridTiles")),
      entity_instances: parse_ldtk_entity_instances(
        field_json(object, "entityInstances"),
      ),
    })
  }
  layers
}

///|
fn parse_ldtk_int_array(value : Json?) -> Array[Int] {
  guard value is Some(value_json) else { return [] }
  guard json_array(value_json) is Some(items) else { return [] }
  let values : Array[Int] = []
  for item in items {
    if json_int(item) is Some(int_value) {
      values.push(int_value)
    } else if json_number(item) is Some(number_value) {
      values.push(number_value.to_int())
    }
  }
  values
}

///|
fn parse_ldtk_number_array(value : Json?) -> Array[Double] {
  guard value is Some(value_json) else { return [] }
  guard json_array(value_json) is Some(items) else { return [] }
  let values : Array[Double] = []
  for item in items {
    if ldtk_json_number(item) is Some(number_value) {
      values.push(number_value)
    }
  }
  values
}

///|
fn parse_ldtk_string_array(value : Json?) -> Array[String] {
  guard value is Some(value_json) else { return [] }
  guard json_array(value_json) is Some(items) else { return [] }
  let values : Array[String] = []
  for item in items {
    if json_string(item) is Some(string_value) {
      values.push(string_value)
    }
  }
  values
}

///|
fn parse_ldtk_level_background_position(
  bg_pos_json : Json?,
) -> LdtkLevelBackgroundPosition? {
  guard bg_pos_json is Some(value_json) else { return None }
  guard json_object(value_json) is Some(object) else { return None }
  let crop = parse_ldtk_number_array(field_json(object, "cropRect"))
  let scale = field_json(object, "scale")
    .bind(value => json_vec2(value))
    .unwrap_or(@math.Vec2(1.0, 1.0))
  let top_left = field_json(object, "topLeftPx")
    .bind(value => json_vec2(value))
    .unwrap_or(@math.Vec2::zero())
  Some({
    crop_x: crop.get(0).unwrap_or(0.0),
    crop_y: crop.get(1).unwrap_or(0.0),
    crop_width: crop.get(2).unwrap_or(0.0),
    crop_height: crop.get(3).unwrap_or(0.0),
    scale,
    top_left_px: top_left,
  })
}
