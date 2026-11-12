///|
fn parse_node_transform(
  node_object : Map[String, Json],
) -> @transform.Transform? {
  if node_object.get("matrix") is Some(matrix) {
    guard json_array(matrix) is Some(values) && values.length() == 16 else {
      return None
    }
    return parse_matrix_transform(values)
  }
  Some({
    translation: parse_vec3(node_object.get("translation"), @math.Vec3::zero()),
    rotation: parse_rotation(
      node_object.get("rotation"),
      @math.Rotation3::identity(),
    ),
    scale: parse_vec3(node_object.get("scale"), @math.Vec3::one()),
  })
}

///|
fn parse_matrix_transform(values : Array[Json]) -> @transform.Transform? {
  let numbers : Array[Double] = []
  for index in 0..<16 {
    guard json_number(values[index]) is Some(value) else { return None }
    numbers.push(value)
  }
  guard @math.Mat4::from_column_major(numbers[:]) is Some(matrix) &&
    matrix.try_to_affine() is Some(affine) else {
    None
  }
  // Exporters commonly serialize node matrices from Float32 transforms.
  @transform.GlobalTransform::{ affine, }.try_decompose_trs(tolerance=1.0e-6)
}

///|
fn parse_node_children(node_object : Map[String, Json]) -> Array[Int32] {
  guard node_object.get("children") is Some(children_json) else { return [] }
  guard json_array(children_json) is Some(children) else { return [] }
  let indexes : Array[Int32] = []
  for value in children {
    if json_number(value) is Some(number) {
      indexes.push(number.to_int())
    }
  }
  indexes
}

///|
fn parse_root_nodes(
  root_object : Map[String, Json],
  max_nodes : Int32,
) -> Array[Int32] {
  guard root_object.get("scenes") is Some(scenes_json) else {
    return fallback_root_nodes(max_nodes)
  }
  guard json_array(scenes_json) is Some(scenes) else {
    return fallback_root_nodes(max_nodes)
  }
  if scenes.length() == 0 {
    return fallback_root_nodes(max_nodes)
  }
  let mut scene_index = field_int(root_object, "scene").unwrap_or(0)
  if scene_index < 0 {
    scene_index = 0
  }
  if scene_index >= scenes.length() {
    scene_index = scenes.length() - 1
  }
  guard json_object(scenes[scene_index]) is Some(scene_object) else {
    return fallback_root_nodes(max_nodes)
  }
  guard scene_object.get("nodes") is Some(root_nodes_json) else {
    return fallback_root_nodes(max_nodes)
  }
  guard json_array(root_nodes_json) is Some(root_nodes) else {
    return fallback_root_nodes(max_nodes)
  }
  let indexes : Array[Int32] = []
  for value in root_nodes {
    if json_number(value) is Some(number) {
      let index = number.to_int()
      if index >= 0 && index < max_nodes {
        indexes.push(index)
      }
    }
  }
  if indexes.length() == 0 {
    fallback_root_nodes(max_nodes)
  } else {
    indexes
  }
}

///|
fn fallback_root_nodes(max_nodes : Int32) -> Array[Int32] {
  if max_nodes > 0 {
    [0]
  } else {
    []
  }
}

///|
fn parse_vec3(value : Json?, fallback : @math.Vec3) -> @math.Vec3 {
  guard value is Some(actual) else { return fallback }
  guard json_array(actual) is Some(values) else { return fallback }
  if values.length() < 3 {
    return fallback
  }
  let x = json_number(values[0]).unwrap_or(fallback.x)
  let y = json_number(values[1]).unwrap_or(fallback.y)
  let z = json_number(values[2]).unwrap_or(fallback.z)
  Vec3(x, y, z)
}

///|
fn parse_rotation(value : Json?, fallback : @math.Rotation3) -> @math.Rotation3 {
  guard value is Some(actual) else { return fallback }
  guard json_array(actual) is Some(values) else { return fallback }
  if values.length() < 4 {
    return fallback
  }
  let q = fallback.to_quat()
  let x = json_number(values[0]).unwrap_or(q.x)
  let y = json_number(values[1]).unwrap_or(q.y)
  let z = json_number(values[2]).unwrap_or(q.z)
  let w = json_number(values[3]).unwrap_or(q.w)
  @math.Rotation3::try_from_quat(Quat(x, y, z, w)).unwrap_or(fallback)
}

///|
fn color_from_factor4(values : Array[Double]) -> @render.Color {
  let r = factor_to_u8(values.get(0).unwrap_or(1.0))
  let g = factor_to_u8(values.get(1).unwrap_or(1.0))
  let b = factor_to_u8(values.get(2).unwrap_or(1.0))
  let a = clamp01(values.get(3).unwrap_or(1.0))
  { r, g, b, a, }
}

///|
fn factor_to_u8(value : Double) -> UInt32 {
  (clamp01(value) * 255.0).to_int().reinterpret_as_uint()
}

///|
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn parse_morph_weight_values(values : Array[Json]?) -> Array[Double] {
  let weights : Array[Double] = []
  guard values is Some(items) else { return weights }
  for value in items {
    if json_number(value) is Some(number) {
      weights.push(number)
    }
  }
  weights
}

///|
fn resolve_morph_weights(
  target_count : Int32,
  candidate_weights : Array[Double],
) -> Array[Double] {
  if target_count <= 0 {
    return []
  }
  let weights = candidate_weights.copy()
  while weights.length() < target_count {
    weights.push(0.0)
  }
  if weights.length() > target_count {
    let trimmed : Array[Double] = []
    for index in 0..<target_count {
      trimmed.push(weights[index])
    }
    trimmed
  } else {
    weights
  }
}

///|
fn max_attribute_set_index(
  attributes_object : Map[String, Json],
  prefix : String,
) -> Int32 {
  let mut max_index = -1
  for key in attributes_object.keys() {
    if !key.has_prefix(prefix) {
      continue
    }
    let suffix = key.unsafe_substring(start=prefix.length(), end=key.length())
    let index = @string.parse_int(suffix[:]) catch { _ => continue }
    if index > max_index {
      max_index = index
    }
  }
  max_index
}
