// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
pub struct LdtkLevelIndices {
  world : Int?
  level : Int
}

///|
pub fn LdtkLevelIndices::in_world(
  world_index : Int,
  level_index : Int,
) -> LdtkLevelIndices {
  { world: Some(world_index), level: level_index }
}

///|
pub fn LdtkLevelIndices::in_root(index : Int) -> LdtkLevelIndices {
  { world: None, level: index }
}

///|
pub fn LdtkLevelIndices::equals(
  self : LdtkLevelIndices,
  other : LdtkLevelIndices,
) -> Bool {
  self.world == other.world && self.level == other.level
}

///|
pub enum LdtkLevelSelection {
  Identifier(String)
  Indices(LdtkLevelIndices)
  Iid(String)
  Uid(Int)
}

///|
pub fn default_ldtk_level_selection() -> LdtkLevelSelection {
  Indices(LdtkLevelIndices::in_root(0))
}

///|
pub fn ldtk_level_selection_iid(iid : String) -> LdtkLevelSelection {
  Iid(iid)
}

///|
pub fn ldtk_level_selection_identifier(
  identifier : String,
) -> LdtkLevelSelection {
  Identifier(identifier)
}

///|
pub fn ldtk_level_selection_index(level_index : Int) -> LdtkLevelSelection {
  Indices(LdtkLevelIndices::in_root(level_index))
}

///|
pub fn ldtk_level_selection_indices(
  world_index : Int,
  level_index : Int,
) -> LdtkLevelSelection {
  Indices(LdtkLevelIndices::in_world(world_index, level_index))
}

///|
pub fn ldtk_level_selection_uid(uid : Int) -> LdtkLevelSelection {
  Uid(uid)
}

///|
pub enum LdtkLevelSpawnBehavior {
  UseZeroTranslation
  UseWorldTranslation(Bool)
}

///|
pub enum LdtkIntGridRendering {
  Colorful
  Invisible
} derive(Eq, Debug)

///|
pub struct LdtkSpawnExclusions {
  layer_identifiers : Array[String]
}

///|
pub fn default_ldtk_spawn_exclusions() -> LdtkSpawnExclusions {
  { layer_identifiers: [] }
}

///|
pub fn LdtkSpawnExclusions::excludes_layer(
  self : LdtkSpawnExclusions,
  identifier : String,
) -> Bool {
  self.layer_identifiers.contains(identifier)
}

///|
pub struct LdtkIntGridPhysicsSettings {
  enabled : Bool
  layer_identifiers : Array[String]
  values : Array[Int]
  as_sensor : Bool
  collision_filter : @physics2d.CollisionFilter
  sensor_filter : @physics2d.CollisionFilter
}

///|
pub fn default_ldtk_int_grid_physics_settings() -> LdtkIntGridPhysicsSettings {
  let group = @physics2d.CollisionGroup::new()
  {
    enabled: false,
    layer_identifiers: [],
    values: [],
    as_sensor: false,
    collision_filter: @physics2d.CollisionFilter::all(group),
    sensor_filter: @physics2d.CollisionFilter::all(group),
  }
}

///|
pub fn LdtkIntGridPhysicsSettings::matches(
  self : LdtkIntGridPhysicsSettings,
  layer_identifier : String,
  value : Int,
) -> Bool {
  if !self.enabled {
    return false
  }
  if self.layer_identifiers.length() > 0 &&
    !self.layer_identifiers.contains(layer_identifier) {
    return false
  }
  if self.values.length() > 0 && !self.values.contains(value) {
    return false
  }
  true
}

///|
pub struct LdtkSettings {
  level_spawn_behavior : LdtkLevelSpawnBehavior
  int_grid_rendering : LdtkIntGridRendering
  spawn_exclusions : LdtkSpawnExclusions
}

///|
pub fn default_ldtk_settings() -> LdtkSettings {
  {
    level_spawn_behavior: UseZeroTranslation,
    int_grid_rendering: Colorful,
    spawn_exclusions: default_ldtk_spawn_exclusions(),
  }
}

///|
pub fn ldtk_level_spawn_behavior_world_translation(
  load_level_neighbors : Bool,
) -> LdtkLevelSpawnBehavior {
  UseWorldTranslation(load_level_neighbors)
}

///|
pub let ldtk_settings : Ref[LdtkSettings] = { val: default_ldtk_settings() }

///|
pub let ldtk_int_grid_physics_settings : Ref[LdtkIntGridPhysicsSettings] = {
  val: default_ldtk_int_grid_physics_settings(),
}

///|
pub let ldtk_level_selection : Ref[LdtkLevelSelection] = {
  val: default_ldtk_level_selection(),
}

///|
pub fn set_ldtk_settings(settings : LdtkSettings) -> Unit {
  ldtk_settings.val = settings
}

///|
pub fn set_ldtk_int_grid_physics_settings(
  settings : LdtkIntGridPhysicsSettings,
) -> Unit {
  ldtk_int_grid_physics_settings.val = settings
}

///|
pub fn set_ldtk_level_selection(selection : LdtkLevelSelection) -> Unit {
  ldtk_level_selection.val = selection
}

///|
pub struct LdtkLevelSet {
  iids : Array[String]
}

///|
pub fn empty_ldtk_level_set() -> LdtkLevelSet {
  { iids: [] }
}

///|
pub fn ldtk_level_set_from_iids(iids : Array[String]) -> LdtkLevelSet {
  { iids: unique_ldtk_iids(iids) }
}

///|
pub fn LdtkLevelSet::contains(self : LdtkLevelSet, iid : String) -> Bool {
  self.iids.contains(iid)
}

///|
pub fn LdtkLevelSet::to_array(self : LdtkLevelSet) -> Array[String] {
  self.iids
}

///|
pub fn ldtk_field_instance(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> LdtkFieldInstance? {
  for field_instance in field_instances {
    if field_instance.identifier == identifier {
      return Some(field_instance)
    }
  }
  None
}

///|
pub fn ldtk_field_bool(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Bool? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.bool_value()
  })
}

///|
pub fn ldtk_field_int(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Int? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.int_value()
  })
}

///|
pub fn ldtk_field_string(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> String? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.string_value()
  })
}

///|
pub fn ldtk_field_color(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> String? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.color_value()
  })
}

///|
pub fn ldtk_field_file_path(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> String? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.file_path_value()
  })
}

///|
pub fn ldtk_field_enum(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> String? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.enum_value()
  })
}

///|
pub fn ldtk_field_number(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Double? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.number_value()
  })
}

///|
pub fn ldtk_field_vec2(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> @math.Vec2? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.vec2_value()
  })
}

///|
pub fn ldtk_field_int_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[Int]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.int_array_value()
  })
}

///|
pub fn ldtk_field_number_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[Double]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.number_array_value()
  })
}

///|
pub fn ldtk_field_string_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[String]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.string_array_value()
  })
}

///|
pub fn ldtk_field_bool_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[Bool]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.bool_array_value()
  })
}

///|
pub fn ldtk_field_vec2_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[@math.Vec2]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.vec2_array_value()
  })
}

///|
pub fn ldtk_field_color_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[String]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.color_array_value()
  })
}

///|
pub fn ldtk_field_file_path_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[String]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.file_path_array_value()
  })
}

///|
pub fn ldtk_field_enum_array(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[String]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.enum_array_value()
  })
}

///|
pub fn ldtk_field_entity_iid(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> String? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.entity_iid_value()
  })
}

///|
pub fn ldtk_field_entity_iids(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[String]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.entity_iids_value()
  })
}

///|
pub fn ldtk_field_entity_ref(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> LdtkEntityReference? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.entity_ref_value()
  })
}

///|
pub fn ldtk_field_entity_refs(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[LdtkEntityReference]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.entity_refs_value()
  })
}

///|
pub fn ldtk_field_tile(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> LdtkTilesetRect? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.tile_value()
  })
}

///|
pub fn ldtk_field_tiles(
  field_instances : Array[LdtkFieldInstance],
  identifier : String,
) -> Array[LdtkTilesetRect]? {
  ldtk_field_instance(field_instances, identifier).bind(field_instance => {
    field_instance.tile_array_value()
  })
}

///|
pub fn ldtk_level_set_equals(left : LdtkLevelSet, right : LdtkLevelSet) -> Bool {
  if left.iids.length() != right.iids.length() {
    return false
  }
  for iid in left.iids {
    if !right.iids.contains(iid) {
      return false
    }
  }
  true
}

///|
pub struct LdtkNeighbour {
  level_iid : String
  dir : String?
}

///|
pub struct LdtkEntityReference {
  entity_iid : String?
  level_iid : String?
  world_iid : String?
  layer_iid : String?
}

///|
pub fn empty_ldtk_entity_reference() -> LdtkEntityReference {
  { entity_iid: None, level_iid: None, world_iid: None, layer_iid: None }
}

///|
pub struct LdtkTilesetRect {
  tileset_uid : Int?
  x : Int
  y : Int
  w : Int
  h : Int
}

///|
pub fn empty_ldtk_tileset_rect() -> LdtkTilesetRect {
  { tileset_uid: None, x: 0, y: 0, w: 0, h: 0 }
}

///|
pub struct LdtkFieldInstance {
  identifier : String
  value_type : String
  value : Json?
  def_uid : Int?
}

///|
pub fn LdtkFieldInstance::bool_value(self : LdtkFieldInstance) -> Bool? {
  match self.value {
    Some(json_value) => {
      if json_bool(json_value) is Some(bool_value) {
        return Some(bool_value)
      }
      if json_string(json_value) is Some(string_value) {
        let lowered = string_value.to_lower()
        if lowered == "true" {
          return Some(true)
        }
        if lowered == "false" {
          return Some(false)
        }
      }
      if json_number(json_value) is Some(number_value) {
        return Some(number_value != 0.0)
      }
      None
    }
    None => None
  }
}

///|
pub fn LdtkFieldInstance::int_value(self : LdtkFieldInstance) -> Int? {
  match self.value {
    Some(json_value) => {
      if json_int(json_value) is Some(int_value) {
        return Some(int_value)
      }
      if json_number(json_value) is Some(number_value) {
        return Some(number_value.to_int())
      }
      None
    }
    None => None
  }
}

///|
pub fn LdtkFieldInstance::string_value(self : LdtkFieldInstance) -> String? {
  match self.value {
    Some(json_value) => json_string(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::color_value(self : LdtkFieldInstance) -> String? {
  self.string_value()
}

///|
pub fn LdtkFieldInstance::file_path_value(self : LdtkFieldInstance) -> String? {
  self.string_value()
}

///|
pub fn LdtkFieldInstance::enum_value(self : LdtkFieldInstance) -> String? {
  self.string_value()
}

///|
pub fn LdtkFieldInstance::number_value(self : LdtkFieldInstance) -> Double? {
  match self.value {
    Some(json_value) => {
      if json_number(json_value) is Some(number_value) {
        return Some(number_value)
      }
      if json_int(json_value) is Some(int_value) {
        return Some(int_value.to_double())
      }
      None
    }
    None => None
  }
}

///|
pub fn LdtkFieldInstance::vec2_value(self : LdtkFieldInstance) -> @math.Vec2? {
  match self.value {
    Some(json_value) => json_vec2(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::int_array_value(
  self : LdtkFieldInstance,
) -> Array[Int]? {
  match self.value {
    Some(json_value) => json_int_array(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::number_array_value(
  self : LdtkFieldInstance,
) -> Array[Double]? {
  match self.value {
    Some(json_value) => json_number_array(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::string_array_value(
  self : LdtkFieldInstance,
) -> Array[String]? {
  match self.value {
    Some(json_value) => json_string_array(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::bool_array_value(
  self : LdtkFieldInstance,
) -> Array[Bool]? {
  match self.value {
    Some(json_value) => json_bool_array(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::vec2_array_value(
  self : LdtkFieldInstance,
) -> Array[@math.Vec2]? {
  match self.value {
    Some(json_value) => json_vec2_array(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::color_array_value(
  self : LdtkFieldInstance,
) -> Array[String]? {
  self.string_array_value()
}

///|
pub fn LdtkFieldInstance::file_path_array_value(
  self : LdtkFieldInstance,
) -> Array[String]? {
  self.string_array_value()
}

///|
pub fn LdtkFieldInstance::enum_array_value(
  self : LdtkFieldInstance,
) -> Array[String]? {
  self.string_array_value()
}

///|
pub fn LdtkFieldInstance::entity_iid_value(self : LdtkFieldInstance) -> String? {
  self.entity_ref_value().bind(reference => reference.entity_iid)
}

///|
pub fn LdtkFieldInstance::entity_iids_value(
  self : LdtkFieldInstance,
) -> Array[String]? {
  match self.entity_refs_value() {
    Some(references) => {
      let iids : Array[String] = []
      for reference in references {
        if reference.entity_iid is Some(iid) {
          iids.push(iid)
        }
      }
      Some(iids)
    }
    None => None
  }
}

///|
pub fn LdtkFieldInstance::entity_ref_value(
  self : LdtkFieldInstance,
) -> LdtkEntityReference? {
  match self.value {
    Some(json_value) => json_entity_reference(json_value)
    None => None
  }
}

///|
pub fn LdtkFieldInstance::entity_refs_value(
  self : LdtkFieldInstance,
) -> Array[LdtkEntityReference]? {
  match self.value {
    Some(json_value) => {
      if json_array(json_value) is Some(items) {
        let references : Array[LdtkEntityReference] = []
        for item in items {
          if json_entity_reference(item) is Some(reference) {
            references.push(reference)
          }
        }
        return Some(references)
      }
      json_entity_reference(json_value).map(reference => [reference])
    }
    None => None
  }
}

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

///|
fn parse_ldtk_tile_instances(instances_json : Json?) -> Array[LdtkTileInstance] {
  let instances : Array[LdtkTileInstance] = []
  for object in json_object_array(instances_json) {
    let flags = field_int(object, "f").unwrap_or(0)
    instances.push({
      tile_id: field_int(object, "t").unwrap_or(0),
      src: json_vec2_from_int_array(field_json(object, "src")),
      px: json_vec2_from_int_array(field_json(object, "px")),
      flip_x: (flags & 1) != 0,
      flip_y: (flags & 2) != 0,
      alpha: field_number(object, "a").unwrap_or(1.0),
      data: parse_ldtk_int_array(field_json(object, "d")),
    })
  }
  instances
}

///|
fn parse_ldtk_entity_instances(
  instances_json : Json?,
) -> Array[LdtkEntityInstance] {
  let instances : Array[LdtkEntityInstance] = []
  for object in json_object_array(instances_json) {
    instances.push({
      iid: field_string(object, "iid").unwrap_or(""),
      identifier: field_string_any(object, ["__identifier", "identifier"]).unwrap_or(
        "",
      ),
      def_uid: field_int_any(object, ["defUid", "__defUid"]).unwrap_or(0),
      width: field_int_any(object, ["width", "__width"]).unwrap_or(0),
      height: field_int_any(object, ["height", "__height"]).unwrap_or(0),
      px: json_vec2_from_int_array(field_json(object, "px")),
      grid: json_vec2_from_int_array(field_json(object, "__grid")),
      pivot: json_vec2_from_number_array(field_json(object, "__pivot")),
      smart_color: field_string_any(object, ["__smartColor", "smartColor"]),
      tile: match field_json(object, "__tile") {
        Some(value) => json_tileset_rect(value)
        None => None
      },
      tags: parse_ldtk_string_array(field_json_any(object, ["__tags", "tags"])),
      field_instances: parse_ldtk_field_instances(
        field_json(object, "fieldInstances"),
      ),
    })
  }
  instances
}

///|
fn resolve_external_ldtk_levels(project : LdtkProject) -> LdtkProject {
  if !project.external_levels {
    return project
  }
  if project.source_path is None {
    return project
  }
  let cache : Map[String, LdtkLevel] = Map::new()
  let resolved_levels : Array[LdtkLevel] = []
  for level in project.levels {
    resolved_levels.push(resolve_external_ldtk_level(project, level, cache))
  }
  let resolved_worlds : Array[LdtkWorld] = []
  for world in project.worlds {
    let resolved_world_levels : Array[LdtkLevel] = []
    for level in world.levels {
      resolved_world_levels.push(
        resolve_external_ldtk_level(project, level, cache),
      )
    }
    resolved_worlds.push({ ..world, levels: resolved_world_levels })
  }
  { ..project, levels: resolved_levels, worlds: resolved_worlds }
}

///|
fn resolve_external_ldtk_level(
  project : LdtkProject,
  level : LdtkLevel,
  cache : Map[String, LdtkLevel],
) -> LdtkLevel {
  guard level.external_rel_path is Some(rel_path) else { return level }
  let resolved_path = project.resolve_path(rel_path)
  if cache.get(resolved_path) is Some(external_level) {
    return merge_ldtk_level(level, external_level)
  }
  guard load_ldtk_text_document(resolved_path) is Some(source) else {
    return level
  }
  guard parse_ldtk_level_source(source) is Some(external_level) else {
    return level
  }
  cache.set(resolved_path, external_level)
  merge_ldtk_level(level, external_level)
}

///|
fn parse_ldtk_level_source(source : String) -> LdtkLevel? {
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  guard parsed is Ok(root_json) else { return None }
  guard json_object(root_json) is Some(root_object) else { return None }
  Some(parse_ldtk_level(root_object))
}

///|
fn merge_ldtk_level(base : LdtkLevel, external : LdtkLevel) -> LdtkLevel {
  {
    identifier: prefer_non_empty_string(external.identifier, base.identifier),
    iid: prefer_non_empty_string(external.iid, base.iid),
    uid: external.uid,
    world_x: external.world_x,
    world_y: external.world_y,
    px_wid: external.px_wid,
    px_hei: external.px_hei,
    bg_color: option_or(external.bg_color, base.bg_color),
    bg_pos: option_or(external.bg_pos, base.bg_pos),
    bg_rel_path: option_or(external.bg_rel_path, base.bg_rel_path),
    external_rel_path: base.external_rel_path,
    neighbours: if external.neighbours.length() > 0 {
      external.neighbours
    } else {
      base.neighbours
    },
    field_instances: if external.field_instances.length() > 0 {
      external.field_instances
    } else {
      base.field_instances
    },
    layer_instances: if external.layer_instances.length() > 0 {
      external.layer_instances
    } else {
      base.layer_instances
    },
  }
}

///|
fn prefer_non_empty_string(candidate : String, fallback : String) -> String {
  if candidate.length() == 0 {
    fallback
  } else {
    candidate
  }
}

///|
fn[T] option_or(value : T?, fallback : T?) -> T? {
  match value {
    Some(_) => value
    None => fallback
  }
}

///|
fn json_vec2_from_int_array(value : Json?) -> @math.Vec2 {
  guard value is Some(value_json) else { return @math.Vec2::zero() }
  guard json_array(value_json) is Some(items) else { return @math.Vec2::zero() }
  if items.length() < 2 {
    return @math.Vec2::zero()
  }
  let x = json_number(items[0]).unwrap_or(0.0)
  let y = json_number(items[1]).unwrap_or(0.0)
  @math.Vec2(x, y)
}

///|
fn json_vec2_from_number_array(value : Json?) -> @math.Vec2 {
  json_vec2_from_int_array(value)
}

///|
fn json_vec2(value : Json) -> @math.Vec2? {
  if json_array(value) is Some(items) {
    if items.length() < 2 {
      return None
    }
    guard ldtk_json_number(items[0]) is Some(x) else { return None }
    guard ldtk_json_number(items[1]) is Some(y) else { return None }
    return Some(@math.Vec2(x, y))
  }
  guard json_object(value) is Some(object) else { return None }
  let x = option_or(
    field_number_any(object, ["x", "cx"]),
    field_int_any(object, ["x", "cx"]).map(value => value.to_double()),
  )
  let y = option_or(
    field_number_any(object, ["y", "cy"]),
    field_int_any(object, ["y", "cy"]).map(value => value.to_double()),
  )
  guard x is Some(x) else { return None }
  guard y is Some(y) else { return None }
  Some(@math.Vec2(x, y))
}

///|
fn json_int_array(value : Json) -> Array[Int]? {
  guard json_array(value) is Some(items) else { return None }
  let values : Array[Int] = []
  for item in items {
    if json_int(item) is Some(int_value) {
      values.push(int_value)
    } else if json_number(item) is Some(number_value) {
      values.push(number_value.to_int())
    }
  }
  Some(values)
}

///|
fn json_number_array(value : Json) -> Array[Double]? {
  guard json_array(value) is Some(items) else { return None }
  let values : Array[Double] = []
  for item in items {
    if ldtk_json_number(item) is Some(number_value) {
      values.push(number_value)
    }
  }
  Some(values)
}

///|
fn json_string_array(value : Json) -> Array[String]? {
  guard json_array(value) is Some(items) else { return None }
  let values : Array[String] = []
  for item in items {
    if json_string(item) is Some(string_value) {
      values.push(string_value)
    }
  }
  Some(values)
}

///|
fn json_vec2_array(value : Json) -> Array[@math.Vec2]? {
  guard json_array(value) is Some(items) else { return None }
  let values : Array[@math.Vec2] = []
  for item in items {
    if json_vec2(item) is Some(vec2_value) {
      values.push(vec2_value)
    }
  }
  Some(values)
}

///|
fn json_entity_reference(value : Json) -> LdtkEntityReference? {
  if json_string(value) is Some(iid) {
    if iid.length() == 0 {
      return None
    }
    return Some({ ..empty_ldtk_entity_reference(), entity_iid: Some(iid) })
  }
  guard json_object(value) is Some(object) else { return None }
  Some({
    entity_iid: field_string_any(object, ["entityIid", "__entityIid", "iid"]),
    level_iid: field_string_any(object, ["levelIid", "__levelIid"]),
    world_iid: field_string_any(object, ["worldIid", "__worldIid"]),
    layer_iid: field_string_any(object, ["layerIid", "__layerIid"]),
  })
}

///|
fn json_tileset_rect(value : Json) -> LdtkTilesetRect? {
  guard json_object(value) is Some(object) else { return None }
  Some({
    tileset_uid: field_int_any(object, ["tilesetUid", "__tilesetUid"]),
    x: field_int(object, "x").unwrap_or(0),
    y: field_int(object, "y").unwrap_or(0),
    w: field_int(object, "w").unwrap_or(0),
    h: field_int(object, "h").unwrap_or(0),
  })
}

///|
fn json_bool_array(value : Json) -> Array[Bool]? {
  guard json_array(value) is Some(items) else { return None }
  let values : Array[Bool] = []
  for item in items {
    if ldtk_json_bool(item) is Some(bool_value) {
      values.push(bool_value)
    }
  }
  Some(values)
}

///|
fn ldtk_json_number(value : Json) -> Double? {
  if json_number(value) is Some(number_value) {
    return Some(number_value)
  }
  if json_int(value) is Some(int_value) {
    return Some(int_value.to_double())
  }
  None
}

///|
fn ldtk_json_bool(value : Json) -> Bool? {
  if json_bool(value) is Some(bool_value) {
    return Some(bool_value)
  }
  if json_string(value) is Some(string_value) {
    let lowered = string_value.to_lower()
    if lowered == "true" {
      return Some(true)
    }
    if lowered == "false" {
      return Some(false)
    }
    return None
  }
  json_number(value).map(number_value => number_value != 0.0)
}

///|
fn is_absolute_path(path : String) -> Bool {
  if path.contains(":\\") {
    return true
  }
  if path.has_prefix("/") {
    return true
  }
  path.has_prefix("\\\\")
}

///|
fn resolve_relative_asset_path(scene_path : String, uri : String) -> String {
  if uri.length() == 0 {
    return uri
  }
  if is_absolute_path(uri) {
    return uri
  }
  let last_slash = scene_path.rev_find("/")
  let last_backslash = scene_path.rev_find("\\")
  let last_sep = match (last_slash, last_backslash) {
    (Some(slash), Some(backslash)) =>
      if slash > backslash {
        slash
      } else {
        backslash
      }
    (Some(slash), None) => slash
    (None, Some(backslash)) => backslash
    (None, None) => -1
  }
  if last_sep < 0 {
    uri
  } else {
    scene_path.unsafe_substring(start=0, end=last_sep + 1) + uri
  }
}

///|
fn json_object_array(value : Json?) -> Array[Map[String, Json]] {
  guard value is Some(value_json) else { return [] }
  guard json_array(value_json) is Some(items) else { return [] }
  let objects : Array[Map[String, Json]] = []
  for item in items {
    if json_object(item) is Some(object) {
      objects.push(object)
    }
  }
  objects
}

///|
fn json_object(value : Json) -> Map[String, Json]? {
  json_decode(value)
}

///|
fn json_array(value : Json) -> Array[Json]? {
  json_decode(value)
}

///|
fn json_string(value : Json) -> String? {
  json_decode(value)
}

///|
fn json_number(value : Json) -> Double? {
  json_decode(value)
}

///|
fn json_int(value : Json) -> Int? {
  json_decode(value)
}

///|
fn json_bool(value : Json) -> Bool? {
  json_decode(value)
}

///|
fn[T : @json.FromJson] json_decode(value : Json) -> T? {
  let parsed : Result[T, @json.JsonDecodeError] = try? @json.from_json(value)
  match parsed {
    Ok(output) => Some(output)
    Err(_) => None
  }
}

///|
fn field_json(object : Map[String, Json], key : String) -> Json? {
  object.get(key)
}

///|
fn field_json_any(object : Map[String, Json], keys : Array[String]) -> Json? {
  for key in keys {
    if object.get(key) is Some(value) {
      return Some(value)
    }
  }
  None
}

///|
fn field_object(object : Map[String, Json], key : String) -> Map[String, Json]? {
  if field_json(object, key) is Some(value) {
    json_object(value)
  } else {
    None
  }
}

///|
fn field_string(object : Map[String, Json], key : String) -> String? {
  if field_json(object, key) is Some(value) {
    json_string(value)
  } else {
    None
  }
}

///|
fn field_string_any(
  object : Map[String, Json],
  keys : Array[String],
) -> String? {
  for key in keys {
    if field_string(object, key) is Some(value) {
      return Some(value)
    }
  }
  None
}

///|
fn field_number(object : Map[String, Json], key : String) -> Double? {
  if field_json(object, key) is Some(value) {
    json_number(value)
  } else {
    None
  }
}

///|
fn field_number_any(
  object : Map[String, Json],
  keys : Array[String],
) -> Double? {
  for key in keys {
    if field_number(object, key) is Some(value) {
      return Some(value)
    }
  }
  None
}

///|
fn field_int(object : Map[String, Json], key : String) -> Int? {
  if field_json(object, key) is Some(value) {
    if json_int(value) is Some(int_value) {
      return Some(int_value)
    }
    json_number(value).map(number_value => number_value.to_int())
  } else {
    None
  }
}

///|
fn field_int_any(object : Map[String, Json], keys : Array[String]) -> Int? {
  for key in keys {
    if field_int(object, key) is Some(value) {
      return Some(value)
    }
  }
  None
}

///|
fn field_bool_any(object : Map[String, Json], keys : Array[String]) -> Bool? {
  for key in keys {
    if field_bool(object, key) is Some(value) {
      return Some(value)
    }
  }
  None
}

///|
fn field_bool(object : Map[String, Json], key : String) -> Bool? {
  if field_json(object, key) is Some(value) {
    json_bool(value)
  } else {
    None
  }
}
