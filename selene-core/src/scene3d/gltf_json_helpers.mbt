///|
fn resolve_relative_asset_path(scene_path : String, uri : String) -> String {
  if uri.has_prefix("/") ||
    uri.contains("://") ||
    uri.to_lower().has_prefix("data:") {
    return uri
  }
  let slash_idx = scene_path.rev_find("/")
  let backslash_idx = scene_path.rev_find("\\")
  let last_sep = match (slash_idx, backslash_idx) {
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
fn json_object(value : Json) -> Map[String, Json]? {
  match value {
    Object(object) => Some(object)
    _ => None
  }
}

///|
fn json_array(value : Json) -> Array[Json]? {
  match value {
    Array(array) => Some(array)
    _ => None
  }
}

///|
fn json_string(value : Json) -> String? {
  match value {
    String(text) => Some(text)
    _ => None
  }
}

///|
fn json_number(value : Json) -> Double? {
  match value {
    Number(number, ..) => Some(number)
    _ => None
  }
}

///|
fn json_int(value : Json) -> Int? {
  if json_number(value) is Some(number) {
    Some(number.to_int())
  } else {
    None
  }
}

///|
fn json_bool(value : Json) -> Bool? {
  match value {
    True => Some(true)
    False => Some(false)
    _ => None
  }
}

///|
fn field_json(object : Map[String, Json], key : String) -> Json? {
  object.get(key)
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
fn field_array(object : Map[String, Json], key : String) -> Array[Json]? {
  if field_json(object, key) is Some(value) {
    json_array(value)
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
fn field_number(object : Map[String, Json], key : String) -> Double? {
  if field_json(object, key) is Some(value) {
    json_number(value)
  } else {
    None
  }
}

///|
fn field_int(object : Map[String, Json], key : String) -> Int? {
  if field_json(object, key) is Some(value) {
    json_int(value)
  } else {
    None
  }
}

///|
fn field_bool(object : Map[String, Json], key : String) -> Bool? {
  if field_json(object, key) is Some(value) {
    json_bool(value)
  } else {
    None
  }
}
