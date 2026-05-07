///|
fn read_component_int(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
) -> Int? {
  match component_type {
    5121 =>
      if offset < 0 || offset >= bytes.length() {
        None
      } else {
        Some(bytes.unsafe_get(offset).to_int())
      }
    5123 => read_u16_le(bytes, offset)
    5125 => read_u32_le(bytes, offset)
    _ => None
  }
}

///|
fn read_component_double(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
  normalized : Bool,
) -> Double? {
  match component_type {
    5126 => read_f32_le(bytes, offset)
    5120 =>
      match read_i8(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(@cmp.maximum(-1.0, value.to_double() / 127.0))
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5121 =>
      if offset < 0 || offset >= bytes.length() {
        None
      } else {
        let value = bytes.unsafe_get(offset).to_int()
        if normalized {
          Some(value.to_double() / 255.0)
        } else {
          Some(value.to_double())
        }
      }
    5122 =>
      match read_i16_le(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(@cmp.maximum(-1.0, value.to_double() / 32767.0))
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5123 =>
      match read_u16_le(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(value.to_double() / 65535.0)
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5125 =>
      match read_u32_le(bytes, offset) {
        Some(value) => Some(value.to_double())
        None => None
      }
    _ => None
  }
}

///|
fn read_component_color_factor(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
) -> Double? {
  match component_type {
    5126 => read_f32_le(bytes, offset).map(fn(value) { clamp01(value) })
    _ =>
      read_component_double(bytes, offset, component_type, true).map(fn(value) {
        clamp01(value)
      })
  }
}

///|
fn default_mesh_indices(vertex_count : Int) -> Array[Int] {
  let indices : Array[Int] = []
  for index in 0..<vertex_count {
    indices.push(index)
  }
  indices
}

///|
fn triangle_topology_from_gltf_mode(
  mode : Int,
) -> @render3d.TriangleTopology3D? {
  match mode {
    4 => Some(TriangleList)
    5 => Some(TriangleStrip)
    6 => Some(TriangleFan)
    _ => None
  }
}

///|
fn indices_in_bounds(indices : Array[Int], vertex_count : Int) -> Bool {
  if indices.length() == 0 {
    return false
  }
  for index in indices {
    if index < 0 || index >= vertex_count {
      return false
    }
  }
  true
}

///|
fn triangulate_triangle_indices(
  indices : Array[Int],
  topology : @render3d.TriangleTopology3D,
) -> Array[Int] {
  let triangle_indices : Array[Int] = []
  let push_index = fn(index : Int) { triangle_indices.push(index) }
  match topology {
    TriangleList => {
      let tri_count = indices.length() / 3
      for tri in 0..<tri_count {
        let base = tri * 3
        push_index(indices[base])
        push_index(indices[base + 1])
        push_index(indices[base + 2])
      }
    }
    TriangleStrip =>
      if indices.length() >= 3 {
        for i in 0..<(indices.length() - 2) {
          if i % 2 == 0 {
            push_index(indices[i])
            push_index(indices[i + 1])
            push_index(indices[i + 2])
          } else {
            push_index(indices[i + 1])
            push_index(indices[i])
            push_index(indices[i + 2])
          }
        }
      }
    TriangleFan =>
      if indices.length() >= 3 {
        let head = indices[0]
        for i in 1..<(indices.length() - 1) {
          push_index(head)
          push_index(indices[i])
          push_index(indices[i + 1])
        }
      }
  }
  triangle_indices
}

///|
fn compute_vertex_normals(
  positions : Array[@math.Vec3],
  indices : Array[Int],
  topology : @render3d.TriangleTopology3D,
) -> Array[@math.Vec3] {
  let normals : Array[@math.Vec3] = []
  for _ in 0..<positions.length() {
    normals.push(@math.Vec3::zero())
  }
  let triangle_indices = triangulate_triangle_indices(indices, topology)
  let triangle_count = triangle_indices.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let ia = triangle_indices[base]
    let ib = triangle_indices[base + 1]
    let ic = triangle_indices[base + 2]
    if ia < 0 ||
      ia >= positions.length() ||
      ib < 0 ||
      ib >= positions.length() ||
      ic < 0 ||
      ic >= positions.length() {
      continue
    }
    let a = positions[ia]
    let b = positions[ib]
    let c = positions[ic]
    let mut face_normal = (b - a).cross(c - a)
    if face_normal.length_squared() <= 0.0000001 {
      face_normal = @math.Vec3(0.0, 1.0, 0.0)
    }
    normals[ia] = normals[ia] + face_normal
    normals[ib] = normals[ib] + face_normal
    normals[ic] = normals[ic] + face_normal
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    normals[index] = if normal.length_squared() <= 0.0000001 {
      @math.Vec3(0.0, 1.0, 0.0)
    } else {
      normal.normalize()
    }
  }
  normals
}

///|
fn parse_camera_templates(
  root_object : Map[String, Json],
) -> Array[@camera3d.Camera3DComponent?] {
  guard root_object.get("cameras") is Some(cameras_json) else { return [] }
  guard json_array(cameras_json) is Some(cameras) else { return [] }
  let output : Array[@camera3d.Camera3DComponent?] = []
  for camera_json in cameras {
    output.push(
      json_object(camera_json).bind(fn(camera_object) {
        parse_camera_component(camera_object)
      }),
    )
  }
  output
}

///|
fn parse_camera_component(
  camera_object : Map[String, Json],
) -> @camera3d.Camera3DComponent? {
  let defaults = @camera3d.Camera3DComponent::default()
  match
    field_string(camera_object, "type").map_or("", fn(value) {
      value.to_lower()
    }) {
    "orthographic" =>
      field_object(camera_object, "orthographic").map(fn(orthographic) {
        let xmag = field_number(orthographic, "xmag").unwrap_or(1.0)
        let ymag = field_number(orthographic, "ymag").unwrap_or(1.0)
        {
          ..defaults,
          projection: Orthographic,
          orthographic_size: Some(@math.Vec2(2.0 * xmag, 2.0 * ymag)),
          near: field_number(orthographic, "znear").unwrap_or(defaults.near),
          far: field_number(orthographic, "zfar").unwrap_or(defaults.far),
        }
      })
    "perspective" =>
      field_object(camera_object, "perspective").map(fn(perspective) {
        {
          ..defaults,
          projection: Perspective,
          fov_y: field_number(perspective, "yfov").unwrap_or(defaults.fov_y) *
          180.0 /
          3.141592653589793,
          near: field_number(perspective, "znear").unwrap_or(defaults.near),
          far: field_number(perspective, "zfar").unwrap_or(1000000.0),
        }
      })
    _ => None
  }
}

///|
fn parse_light_templates(
  root_object : Map[String, Json],
) -> Array[ParsedLightTemplate?] {
  guard field_object(root_object, "extensions") is Some(extensions_object) else {
    return []
  }
  guard field_object(extensions_object, "KHR_lights_punctual")
    is Some(lights_extension) else {
    return []
  }
  guard field_array(lights_extension, "lights") is Some(lights_json) else {
    return []
  }
  let output : Array[ParsedLightTemplate?] = []
  for light_json in lights_json {
    output.push(json_object(light_json).bind(parse_light_template))
  }
  output
}

///|
fn parse_light_template(
  light_object : Map[String, Json],
) -> ParsedLightTemplate? {
  let color = match field_array(light_object, "color") {
    Some(values) if values.length() >= 3 =>
      color_from_factor4([
        json_number(values[0]).unwrap_or(1.0),
        json_number(values[1]).unwrap_or(1.0),
        json_number(values[2]).unwrap_or(1.0),
        1.0,
      ])
    _ => color_from_factor4([1.0, 1.0, 1.0, 1.0])
  }
  let intensity = field_number(light_object, "intensity").unwrap_or(1.0)
  let range = field_number(light_object, "range").unwrap_or(0.0)
  match
    field_string(light_object, "type").map_or("", fn(value) { value.to_lower() }) {
    "directional" =>
      Some({
        directional: Some({
          ..@render3d.default_directional_light3d(),
          color,
          intensity,
        }),
        point: None,
        spot: None,
      })
    "point" =>
      Some({
        directional: None,
        point: Some({
          ..@render3d.default_point_light3d(),
          color,
          intensity,
          range,
        }),
        spot: None,
      })
    "spot" => {
      let spot_object = field_object(light_object, "spot").unwrap_or(Map::of([]))
      Some({
        directional: None,
        point: None,
        spot: Some({
          ..@render3d.default_spot_light3d(),
          color,
          intensity,
          range,
          inner_angle: field_number(spot_object, "innerConeAngle").unwrap_or(
            0.0,
          ),
          outer_angle: field_number(spot_object, "outerConeAngle").unwrap_or(
            0.7853981633974483,
          ),
        }),
      })
    }
    _ => None
  }
}

///|
fn parse_node_light(
  node_object : Map[String, Json],
  light_templates : Array[ParsedLightTemplate?],
) -> ParsedLightTemplate? {
  guard field_object(node_object, "extensions") is Some(extensions_object) else {
    return None
  }
  guard field_object(extensions_object, "KHR_lights_punctual")
    is Some(light_extension) else {
    return None
  }
  guard field_int(light_extension, "light") is Some(light_index) else {
    return None
  }
  light_templates.get(light_index).unwrap_or(None)
}

///|
fn parse_node_templates(
  root_object : Map[String, Json],
  mesh_templates : Array[MeshSceneTemplate?],
  camera_templates : Array[@camera3d.Camera3DComponent?],
  light_templates : Array[ParsedLightTemplate?],
) -> Array[SceneNodeTemplate] {
  guard root_object.get("nodes") is Some(nodes_json) else { return [] }
  guard json_array(nodes_json) is Some(nodes) else { return [] }
  let templates : Array[SceneNodeTemplate] = []
  for node_json in nodes {
    guard json_object(node_json) is Some(node_object) else {
      templates.push(default_scene_node_template())
      continue
    }
    let transform = parse_node_transform(node_object)
    let children = parse_node_children(node_object)
    let name = field_string(node_object, "name")
    let skin_index = field_int(node_object, "skin")
    let mut morph_weights : Array[Double] = []
    let camera = match field_int(node_object, "camera") {
      Some(camera_index) => camera_templates.get(camera_index).unwrap_or(None)
      None => None
    }
    let light = parse_node_light(node_object, light_templates)
    let renderers = match field_int(node_object, "mesh") {
      Some(mesh_index) =>
        match mesh_templates.get(mesh_index) {
          Some(Some(mesh_template)) => {
            morph_weights = match field_array(node_object, "weights") {
              Some(weights_json) =>
                resolve_morph_weights(
                  mesh_template.morph_target_count,
                  parse_morph_weight_values(Some(weights_json)),
                )
              None => mesh_template.morph_weights.copy()
            }
            mesh_template.renderers.copy()
          }
          _ => []
        }
      None => []
    }
    templates.push({
      name,
      transform,
      renderers,
      skin_index,
      morph_weights,
      camera,
      directional_light: light.bind(fn(template) { template.directional }),
      point_light: light.bind(fn(template) { template.point }),
      spot_light: light.bind(fn(template) { template.spot }),
      children,
    })
  }
  templates
}
