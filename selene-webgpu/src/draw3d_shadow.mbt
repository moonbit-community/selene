///|
fn pack_spot_shadow_view_projection_data(
  frame : @render3d_types.RenderFrame3D,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let values : Array[Double] = []
  let count = min_int(
    frame.spot_lights.length(),
    max_spot_lights_for_mode(mode),
  )
  for index in 0..<count {
    let light = frame.spot_lights[index]
    append_matrix3d(values, spot_shadow_view_projection3d(light))
  }
  values
}

///|
fn pack_point_shadow_view_projection_data(
  frame : @render3d_types.RenderFrame3D,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let values : Array[Double] = []
  let count = min_int(
    frame.point_lights.length(),
    max_point_lights_for_mode(mode),
  )
  for light_index in 0..<count {
    let light = frame.point_lights[light_index]
    for face_index in 0..<6 {
      append_matrix3d(
        values,
        point_shadow_face_view_projection3d(light, face_index),
      )
    }
  }
  values
}

///|
fn spot_shadow_view_projection3d(
  light : @render3d_types.FrameSpotLight3D,
) -> Array[Double] {
  let direction = normalize_or3d(light.direction, @smath.Vec3(0.0, -1.0, 0.0))
  let (near_plane, far_plane) = shadow_near_far3d(
    light.shadow_map_near_z,
    light.range,
  )
  let outer_angle = light.outer_angle.max(0.008726646259971648)
  mat4_multiply3d(
    mat4_perspective3d(
      outer_angle * 2.0 * 180.0 / @math.PI,
      1.0,
      near_plane,
      far_plane,
    ),
    mat4_look_at3d(
      light.position,
      light.position + direction,
      choose_shadow_up3d(direction),
    ),
  )
}

///|
fn point_shadow_face_view_projection3d(
  light : @render3d_types.FramePointLight3D,
  face_index : Int,
) -> Array[Double] {
  let (direction, up) = point_shadow_face3d(face_index)
  let (near_plane, far_plane) = shadow_near_far3d(
    light.shadow_map_near_z,
    light.range,
  )
  mat4_multiply3d(
    mat4_perspective3d(90.0, 1.0, near_plane, far_plane),
    mat4_look_at3d(light.position, light.position + direction, up),
  )
}

///|
fn choose_shadow_up3d(direction : @smath.Vec3) -> @smath.Vec3 {
  let normalized = normalize_or3d(direction, @smath.Vec3(0.0, -1.0, 0.0))
  let world_up = @smath.Vec3(0.0, 1.0, 0.0)
  if normalized.cross(world_up).length_squared() <= 0.0001 {
    @smath.Vec3(0.0, 0.0, 1.0)
  } else {
    world_up
  }
}

///|
fn point_shadow_face3d(face_index : Int) -> (@smath.Vec3, @smath.Vec3) {
  match face_index {
    0 => (@smath.Vec3(1.0, 0.0, 0.0), @smath.Vec3(0.0, -1.0, 0.0))
    1 => (@smath.Vec3(-1.0, 0.0, 0.0), @smath.Vec3(0.0, -1.0, 0.0))
    2 => (@smath.Vec3(0.0, 1.0, 0.0), @smath.Vec3(0.0, 0.0, 1.0))
    3 => (@smath.Vec3(0.0, -1.0, 0.0), @smath.Vec3(0.0, 0.0, -1.0))
    4 => (@smath.Vec3(0.0, 0.0, 1.0), @smath.Vec3(0.0, -1.0, 0.0))
    _ => (@smath.Vec3(0.0, 0.0, -1.0), @smath.Vec3(0.0, -1.0, 0.0))
  }
}

///|
fn shadow_near_far3d(near_z : Double, range : Double) -> (Double, Double) {
  let near_plane = near_z.max(0.01)
  let far_plane = range.max(near_plane + 1.0)
  (near_plane, far_plane)
}

///|
fn append_matrix3d(values : Array[Double], matrix : Array[Double]) -> Unit {
  for value in matrix {
    values.push(value)
  }
}
