///|
fn parse_node_transform(
  node_object : Map[String, Json],
) -> @transform.Transform {
  if field_array(node_object, "matrix") is Some(matrix_json) {
    if parse_matrix_transform(matrix_json) is Some(matrix_transform) {
      return matrix_transform
    }
  }
  {
    translation: parse_vec3(node_object.get("translation"), @math.Vec3::zero()),
    rotation: parse_quat(node_object.get("rotation"), @math.Quat::identity()),
    scale: parse_vec3(node_object.get("scale"), @math.Vec3::one()),
  }
}

///|
fn parse_matrix_transform(values : Array[Json]) -> @transform.Transform? {
  if values.length() < 16 {
    return None
  }
  let numbers : Array[Double] = []
  for index in 0..<16 {
    guard json_number(values[index]) is Some(value) else { return None }
    numbers.push(value)
  }
  let m00 = numbers[0]
  let m01 = numbers[4]
  let m02 = numbers[8]
  let m10 = numbers[1]
  let m11 = numbers[5]
  let m12 = numbers[9]
  let m20 = numbers[2]
  let m21 = numbers[6]
  let m22 = numbers[10]
  let translation = @math.Vec3::new(numbers[12], numbers[13], numbers[14])

  let mut scale_x = @math.Vec3::new(m00, m10, m20).length()
  let mut scale_y = @math.Vec3::new(m01, m11, m21).length()
  let mut scale_z = @math.Vec3::new(m02, m12, m22).length()
  if scale_x <= 0.0000001 {
    scale_x = 1.0
  }
  if scale_y <= 0.0000001 {
    scale_y = 1.0
  }
  if scale_z <= 0.0000001 {
    scale_z = 1.0
  }
  let r00 = m00 / scale_x
  let r01 = m01 / scale_y
  let r02 = m02 / scale_z
  let r10 = m10 / scale_x
  let r11 = m11 / scale_y
  let r12 = m12 / scale_z
  let r20 = m20 / scale_x
  let r21 = m21 / scale_y
  let r22 = m22 / scale_z
  let rotation = quat_from_matrix3(r00, r01, r02, r10, r11, r12, r20, r21, r22)
  Some({
    translation,
    rotation,
    scale: @math.Vec3::new(scale_x, scale_y, scale_z),
  })
}

///|
fn quat_from_matrix3(
  m00 : Double,
  m01 : Double,
  m02 : Double,
  m10 : Double,
  m11 : Double,
  m12 : Double,
  m20 : Double,
  m21 : Double,
  m22 : Double,
) -> @math.Quat {
  let trace = m00 + m11 + m22
  if trace > 0.0 {
    let s = (trace + 1.0).sqrt() * 2.0
    @math.Quat::new((m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, 0.25 * s).normalize()
  } else if m00 > m11 && m00 > m22 {
    let s = (1.0 + m00 - m11 - m22).sqrt() * 2.0
    @math.Quat::new(0.25 * s, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s).normalize()
  } else if m11 > m22 {
    let s = (1.0 + m11 - m00 - m22).sqrt() * 2.0
    @math.Quat::new((m01 + m10) / s, 0.25 * s, (m12 + m21) / s, (m02 - m20) / s).normalize()
  } else {
    let s = (1.0 + m22 - m00 - m11).sqrt() * 2.0
    @math.Quat::new((m02 + m20) / s, (m12 + m21) / s, 0.25 * s, (m10 - m01) / s).normalize()
  }
}

///|
fn parse_node_children(node_object : Map[String, Json]) -> Array[Int] {
  guard node_object.get("children") is Some(children_json) else { return [] }
  guard json_array(children_json) is Some(children) else { return [] }
  let indexes : Array[Int] = []
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
  max_nodes : Int,
) -> Array[Int] {
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
  let indexes : Array[Int] = []
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
fn fallback_root_nodes(max_nodes : Int) -> Array[Int] {
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
  @math.Vec3::new(x, y, z)
}

///|
fn parse_quat(value : Json?, fallback : @math.Quat) -> @math.Quat {
  guard value is Some(actual) else { return fallback }
  guard json_array(actual) is Some(values) else { return fallback }
  if values.length() < 4 {
    return fallback
  }
  let x = json_number(values[0]).unwrap_or(fallback.x)
  let y = json_number(values[1]).unwrap_or(fallback.y)
  let z = json_number(values[2]).unwrap_or(fallback.z)
  let w = json_number(values[3]).unwrap_or(fallback.w)
  @math.Quat::new(x, y, z, w).normalize()
}

///|
fn color_from_factor4(values : Array[Double]) -> @render.Color {
  let r = factor_to_u8(values.get(0).unwrap_or(1.0))
  let g = factor_to_u8(values.get(1).unwrap_or(1.0))
  let b = factor_to_u8(values.get(2).unwrap_or(1.0))
  let a = clamp01(values.get(3).unwrap_or(1.0))
  { r, g, b, a }
}

///|
fn factor_to_u8(value : Double) -> UInt {
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
  target_count : Int,
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
) -> Int {
  let mut max_index = -1
  for pair in attributes_object.to_array() {
    let key = pair.0
    if !key.has_prefix(prefix) {
      continue
    }
    let suffix = key.unsafe_substring(start=prefix.length(), end=key.length())
    let parsed = try? @string.parse_int(suffix.view())
    guard parsed is Ok(index) else { continue }
    if index > max_index {
      max_index = index
    }
  }
  max_index
}
