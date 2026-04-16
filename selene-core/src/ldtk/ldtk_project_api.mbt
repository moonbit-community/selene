///|
pub fn LdtkFieldInstance::tile_value(
  self : LdtkFieldInstance,
) -> LdtkTilesetRect? {
  match self.value {
    Some(json_value) => json_tileset_rect(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::tile_array_value(
  self : LdtkFieldInstance,
) -> Array[LdtkTilesetRect]? {
  match self.value {
    Some(json_value) => {
      if json_array(json_value) is Some(items) {
        let rects : Array[LdtkTilesetRect] = []
        for item in items {
          if json_tileset_rect(item) is Some(rect) {
            rects.push(rect)
          }
        }
        return Some(rects)
      }
      json_tileset_rect(json_value).map(rect => [rect])
    }
    None => None
  }
}

///|
pub struct LdtkTileInstance {
  tile_id : Int
  src : @math.Vec2
  px : @math.Vec2
  flip_x : Bool
  flip_y : Bool
  alpha : Double
  data : Array[Int]
}

///|
pub struct LdtkEntityInstance {
  iid : String
  identifier : String
  def_uid : Int
  width : Int
  height : Int
  px : @math.Vec2
  grid : @math.Vec2
  pivot : @math.Vec2
  smart_color : String?
  tile : LdtkTilesetRect?
  tags : Array[String]
  field_instances : Array[LdtkFieldInstance]
}

///|
pub fn LdtkEntityInstance::field(
  self : LdtkEntityInstance,
  identifier : String,
) -> LdtkFieldInstance? {
  ldtk_field_instance(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_bool(
  self : LdtkEntityInstance,
  identifier : String,
) -> Bool? {
  ldtk_field_bool(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_int(
  self : LdtkEntityInstance,
  identifier : String,
) -> Int? {
  ldtk_field_int(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_string(
  self : LdtkEntityInstance,
  identifier : String,
) -> String? {
  ldtk_field_string(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_color(
  self : LdtkEntityInstance,
  identifier : String,
) -> String? {
  ldtk_field_color(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_file_path(
  self : LdtkEntityInstance,
  identifier : String,
) -> String? {
  ldtk_field_file_path(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_enum(
  self : LdtkEntityInstance,
  identifier : String,
) -> String? {
  ldtk_field_enum(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_number(
  self : LdtkEntityInstance,
  identifier : String,
) -> Double? {
  ldtk_field_number(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_vec2(
  self : LdtkEntityInstance,
  identifier : String,
) -> @math.Vec2? {
  ldtk_field_vec2(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_int_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[Int]? {
  ldtk_field_int_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_number_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[Double]? {
  ldtk_field_number_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_string_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[String]? {
  ldtk_field_string_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_bool_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[Bool]? {
  ldtk_field_bool_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_vec2_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[@math.Vec2]? {
  ldtk_field_vec2_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_color_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[String]? {
  ldtk_field_color_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_file_path_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[String]? {
  ldtk_field_file_path_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_enum_array(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[String]? {
  ldtk_field_enum_array(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_entity_iid(
  self : LdtkEntityInstance,
  identifier : String,
) -> String? {
  ldtk_field_entity_iid(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_entity_iids(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[String]? {
  ldtk_field_entity_iids(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_entity_ref(
  self : LdtkEntityInstance,
  identifier : String,
) -> LdtkEntityReference? {
  ldtk_field_entity_ref(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_entity_refs(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[LdtkEntityReference]? {
  ldtk_field_entity_refs(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_tile(
  self : LdtkEntityInstance,
  identifier : String,
) -> LdtkTilesetRect? {
  ldtk_field_tile(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::field_tiles(
  self : LdtkEntityInstance,
  identifier : String,
) -> Array[LdtkTilesetRect]? {
  ldtk_field_tiles(self.field_instances, identifier)
}

///|
pub fn LdtkEntityInstance::has_tag(
  self : LdtkEntityInstance,
  tag : String,
) -> Bool {
  for entity_tag in self.tags {
    if entity_tag == tag {
      return true
    }
  }
  false
}

///|
pub struct LdtkLayerInstance {
  iid : String
  identifier : String
  layer_type : String
  level_id : Int
  layer_def_uid : Int
  c_wid : Int
  c_hei : Int
  grid_size : Int
  opacity : Double
  visible : Bool
  optional_rules : Array[Int]
  override_tileset_uid : Int?
  px_offset_x : Int
  px_offset_y : Int
  px_total_offset_x : Int
  px_total_offset_y : Int
  seed : Int
  tileset_def_uid : Int?
  tileset_rel_path : String?
  int_grid_csv : Array[Int]
  auto_layer_tiles : Array[LdtkTileInstance]
  grid_tiles : Array[LdtkTileInstance]
  entity_instances : Array[LdtkEntityInstance]
}

///|
pub struct LdtkLevelBackgroundPosition {
  crop_x : Double
  crop_y : Double
  crop_width : Double
  crop_height : Double
  scale : @math.Vec2
  top_left_px : @math.Vec2
}

///|
pub struct LdtkLevel {
  identifier : String
  iid : String
  uid : Int
  world_x : Int
  world_y : Int
  px_wid : Int
  px_hei : Int
  bg_color : String?
  bg_pos : LdtkLevelBackgroundPosition?
  bg_rel_path : String?
  external_rel_path : String?
  neighbours : Array[LdtkNeighbour]
  field_instances : Array[LdtkFieldInstance]
  layer_instances : Array[LdtkLayerInstance]
}

///|
pub fn LdtkLevel::field(
  self : LdtkLevel,
  identifier : String,
) -> LdtkFieldInstance? {
  ldtk_field_instance(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_bool(self : LdtkLevel, identifier : String) -> Bool? {
  ldtk_field_bool(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_int(self : LdtkLevel, identifier : String) -> Int? {
  ldtk_field_int(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_string(
  self : LdtkLevel,
  identifier : String,
) -> String? {
  ldtk_field_string(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_color(self : LdtkLevel, identifier : String) -> String? {
  ldtk_field_color(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_file_path(
  self : LdtkLevel,
  identifier : String,
) -> String? {
  ldtk_field_file_path(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_enum(self : LdtkLevel, identifier : String) -> String? {
  ldtk_field_enum(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_number(
  self : LdtkLevel,
  identifier : String,
) -> Double? {
  ldtk_field_number(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_vec2(
  self : LdtkLevel,
  identifier : String,
) -> @math.Vec2? {
  ldtk_field_vec2(self.field_instances, identifier)
}

///|
pub fn LdtkLevel::field_int_array(
  self : LdtkLevel,
  identifier : String,
) -> Array[Int]? {
  ldtk_field_int_array(self.field_instances, identifier)
}
