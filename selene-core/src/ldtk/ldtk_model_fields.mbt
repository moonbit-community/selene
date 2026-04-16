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
