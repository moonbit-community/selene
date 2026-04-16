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
