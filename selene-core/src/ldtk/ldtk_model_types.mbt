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
