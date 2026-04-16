///|
fn parse_triangle_uv_sets(
  attributes_object : Map[String, Json],
  vertex_count : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Array[@math.Vec2]] {
  let max_set = max_attribute_set_index(attributes_object, "TEXCOORD_")
  if max_set < 0 {
    return []
  }
  let uv_sets : Array[Array[@math.Vec2]] = []
  for set_index in 0..<(max_set + 1) {
    let resolved_uvs = match
      field_int(attributes_object, "TEXCOORD_\{set_index}") {
      Some(accessor_index) =>
        read_accessor_vec2(accessor_index, buffers, buffer_views, accessors)
        .filter(fn(values) { values.length() == vertex_count })
        .unwrap_or([])
      None => []
    }
    uv_sets.push(resolved_uvs)
  }
  uv_sets
}

///|
fn parse_triangle_colors(
  attributes_object : Map[String, Json],
  vertex_count : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render.Color]? {
  guard field_int(attributes_object, "COLOR_0") is Some(accessor_index) else {
    return None
  }
  read_accessor_color(accessor_index, buffers, buffer_views, accessors).filter(fn(
    values,
  ) {
    values.length() == vertex_count
  })
}

///|
fn parse_triangle_tangents(
  attributes_object : Map[String, Json],
  vertex_count : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render3d.Tangent3D]? {
  guard field_int(attributes_object, "TANGENT") is Some(accessor_index) else {
    return None
  }
  read_accessor_tangent(accessor_index, buffers, buffer_views, accessors).filter(fn(
      values,
    ) {
      values.length() == vertex_count
    },
  )
}

///|
fn parse_triangle_influences(
  attributes_object : Map[String, Json],
  vertex_count : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@animation.SkinVertexInfluence3D]? {
  guard field_int(attributes_object, "JOINTS_0") is Some(joints0_accessor) else {
    return None
  }
  guard field_int(attributes_object, "WEIGHTS_0") is Some(weights0_accessor) else {
    return None
  }
  guard read_accessor_joint4(joints0_accessor, buffers, buffer_views, accessors)
    is Some(joints0) else {
    return None
  }
  guard read_accessor_weight4(
      weights0_accessor, buffers, buffer_views, accessors,
    )
    is Some(weights0) else {
    return None
  }
  if joints0.length() != vertex_count || weights0.length() != vertex_count {
    return None
  }
  let triangle_joints1 = match field_int(attributes_object, "JOINTS_1") {
    Some(joints1_accessor) =>
      read_accessor_joint4(joints1_accessor, buffers, buffer_views, accessors).filter(fn(
          values,
        ) {
          values.length() == vertex_count
        },
      )
    None => None
  }
  let triangle_weights1 = match field_int(attributes_object, "WEIGHTS_1") {
    Some(weights1_accessor) =>
      read_accessor_weight4(weights1_accessor, buffers, buffer_views, accessors).filter(fn(
          values,
        ) {
          values.length() == vertex_count
        },
      )
    None => None
  }
  let output : Array[@animation.SkinVertexInfluence3D] = []
  for index in 0..<vertex_count {
    let joints4 = joints0[index]
    let weights4 = weights0[index]
    let extra_joints = triangle_joints1.bind(fn(values) { values.get(index) })
    let extra_weights = triangle_weights1.bind(fn(values) { values.get(index) })
    output.push(
      select_skin_influences(joints4, weights4, extra_joints, extra_weights),
    )
  }
  Some(output)
}

///|
fn select_skin_influences(
  joints0 : (Int, Int, Int, Int),
  weights0 : (Double, Double, Double, Double),
  joints1 : (Int, Int, Int, Int)?,
  weights1 : (Double, Double, Double, Double)?,
) -> @animation.SkinVertexInfluence3D {
  let best_joints : Array[Int] = [-1, -1, -1, -1]
  let best_weights : Array[Double] = [0.0, 0.0, 0.0, 0.0]
  let insert_candidate : (Int, Double) -> Unit = fn(
    joint : Int,
    weight : Double,
  ) {
    if weight <= 0.0 {
      return
    }
    for slot in 0..<4 {
      if weight > best_weights[slot] {
        let mut shift_index = 3
        while shift_index > slot {
          best_weights[shift_index] = best_weights[shift_index - 1]
          best_joints[shift_index] = best_joints[shift_index - 1]
          shift_index -= 1
        }
        best_weights[slot] = weight
        best_joints[slot] = joint
        return
      }
    }
  }
  insert_candidate(joints0.0, weights0.0)
  insert_candidate(joints0.1, weights0.1)
  insert_candidate(joints0.2, weights0.2)
  insert_candidate(joints0.3, weights0.3)
  if joints1 is Some(extra_joints) && weights1 is Some(extra_weights) {
    insert_candidate(extra_joints.0, extra_weights.0)
    insert_candidate(extra_joints.1, extra_weights.1)
    insert_candidate(extra_joints.2, extra_weights.2)
    insert_candidate(extra_joints.3, extra_weights.3)
  }
  let weight_sum = best_weights[0] +
    best_weights[1] +
    best_weights[2] +
    best_weights[3]
  let normalized : Array[Double] = if weight_sum > 0.000001 {
    [
      best_weights[0] / weight_sum,
      best_weights[1] / weight_sum,
      best_weights[2] / weight_sum,
      best_weights[3] / weight_sum,
    ]
  } else {
    best_weights
  }
  {
    joint0: best_joints[0],
    joint1: best_joints[1],
    joint2: best_joints[2],
    joint3: best_joints[3],
    weight0: normalized[0],
    weight1: normalized[1],
    weight2: normalized[2],
    weight3: normalized[3],
  }
}

///|
fn parse_triangle_morph_targets(
  primitive_object : Map[String, Json],
  vertex_count : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[MorphTargetTemplate] {
  guard field_array(primitive_object, "targets") is Some(targets_json) else {
    return []
  }
  let output : Array[MorphTargetTemplate] = []
  for target_json in targets_json {
    guard json_object(target_json) is Some(target_object) else {
      output.push({ position_deltas: None, normal_deltas: None })
      continue
    }
    let position_deltas = match field_int(target_object, "POSITION") {
      Some(accessor_index) =>
        read_accessor_vec3(accessor_index, buffers, buffer_views, accessors).filter(fn(
            values,
          ) {
            values.length() == vertex_count
          },
        )
      None => None
    }
    let normal_deltas = match field_int(target_object, "NORMAL") {
      Some(accessor_index) =>
        read_accessor_vec3(accessor_index, buffers, buffer_views, accessors).filter(fn(
            values,
          ) {
            values.length() == vertex_count
          },
        )
      None => None
    }
    output.push({ position_deltas, normal_deltas })
  }
  output
}
