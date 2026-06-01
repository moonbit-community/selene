///|
priv struct DirectionalShadowBound3D {
  near_bound : Double
  far_bound : Double
}

///|
priv struct DirectionalShadowCascade3D {
  light_index : Int
  cascade_index : Int
  light_view_projection : Array[Double]
  atlas_offset_x : Double
  atlas_offset_y : Double
  atlas_scale_x : Double
  atlas_scale_y : Double
  near_bound : Double
  far_bound : Double
}

///|
priv struct CameraBasis3D {
  forward : @smath.Vec3
  right : @smath.Vec3
  up : @smath.Vec3
}

///|
fn pack_directional_shadow_cascade_data(
  frame : @render3d_types.RenderFrame3D,
  aspect : Double,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let values : Array[Double] = []
  match frame.camera {
    None => values
    Some(camera) => {
      let tile_size = frame.directional_shadow_map_size.to_double().max(1.0)
      let count = min_int(
        frame.directional_lights.length(),
        max_directional_lights_for_mode(mode),
      )
      for light_index in 0..<count {
        let light = frame.directional_lights[light_index]
        if light.shadows {
          let cascades = directional_shadow_cascades3d(
            light, light_index, camera, aspect, tile_size,
          )
          for cascade in cascades {
            append_directional_shadow_cascade3d(values, cascade)
          }
        }
      }
      values
    }
  }
}

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
    values.push(index.to_double())
    append_matrix3d(values, spot_shadow_view_projection3d(light))
    append_spot_shadow_atlas_rect3d(values, index)
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
      values.push((light_index * 6 + face_index).to_double())
      append_matrix3d(
        values,
        point_shadow_face_view_projection3d(light, face_index),
      )
      append_point_shadow_atlas_rect3d(values, light_index, face_index)
    }
  }
  values
}

///|
fn directional_shadow_cascades3d(
  light : @render3d_types.DirectionalLight3D,
  light_index : Int,
  camera : @render3d_types.FrameCamera3D,
  aspect : Double,
  tile_size : Double,
) -> Array[DirectionalShadowCascade3D] {
  let bounds = directional_shadow_bounds3d(light, camera)
  let cascades : Array[DirectionalShadowCascade3D] = []
  if bounds.length() == 0 {
    return cascades
  }
  let direction = normalize_or3d(light.direction, @smath.Vec3(0.0, -1.0, 0.0))
  let light_view = mat4_look_at3d(
    @smath.Vec3(0.0, 0.0, 0.0),
    direction,
    choose_shadow_up3d(direction),
  )
  let (atlas_columns, atlas_rows) = directional_shadow_atlas_layout3d(
    bounds.length(),
  )
  let atlas_width = tile_size * atlas_columns.to_double()
  let atlas_height = tile_size * atlas_rows.to_double()
  for cascade_index in 0..<bounds.length() {
    let bound = bounds[cascade_index]
    let corners = camera_frustum_slice_corners3d(
      camera,
      aspect,
      bound.near_bound,
      bound.far_bound,
    )
    if corners.length() >= 8 {
      let mut min_corner = transform_point3d(light_view, corners[0])
      let mut max_corner = min_corner
      for index in 1..<corners.length() {
        let point = transform_point3d(light_view, corners[index])
        min_corner = vec3_min3d(min_corner, point)
        max_corner = vec3_max3d(max_corner, point)
      }
      let body_diagonal = (corners[0] - corners[6]).length_squared()
      let far_plane_diagonal = (corners[4] - corners[6]).length_squared()
      let diameter = body_diagonal
        .max(far_plane_diagonal)
        .sqrt()
        .ceil()
        .max(1.0)
      let texel_size = diameter / tile_size.max(1.0)
      let center_x = ((min_corner.x + max_corner.x) * 0.5 / texel_size).floor() *
        texel_size
      let center_y = ((min_corner.y + max_corner.y) * 0.5 / texel_size).floor() *
        texel_size
      let half_extent = diameter * 0.5
      let near_plane = 0.01
      let far_plane = (max_corner.z - min_corner.z + near_plane).max(
        near_plane + 1.0,
      )
      let cascade_view = mat4_multiply3d(
        light_view,
        mat4_translation3d(-center_x, -center_y, -(max_corner.z + near_plane)),
      )
      let cascade_projection = mat4_orthographic3d(
        half_extent * 2.0,
        half_extent * 2.0,
        near_plane,
        far_plane,
      )
      let (offset_x, offset_y, scale_x, scale_y) = shadow_atlas_rect3d(
        cascade_index, atlas_columns, tile_size, atlas_width, atlas_height,
      )
      cascades.push({
        light_index,
        cascade_index,
        light_view_projection: mat4_multiply3d(cascade_projection, cascade_view),
        atlas_offset_x: offset_x,
        atlas_offset_y: offset_y,
        atlas_scale_x: scale_x,
        atlas_scale_y: scale_y,
        near_bound: bound.near_bound,
        far_bound: bound.far_bound,
      })
    }
  }
  cascades
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
fn directional_shadow_bounds3d(
  light : @render3d_types.DirectionalLight3D,
  camera : @render3d_types.FrameCamera3D,
) -> Array[DirectionalShadowBound3D] {
  let bounds : Array[DirectionalShadowBound3D] = []
  let config = light.cascade_shadow_config
  let camera_near = if camera.near == 0.0 { 0.1 } else { camera.near }
  let minimum_distance = camera_near
    .max(0.0)
    .max(config.minimum_distance.max(0.0))
  let far = if camera.far == 0.0 {
    minimum_distance + 200.0
  } else {
    camera.far
  }
  if far <= minimum_distance {
    return bounds
  }
  let overlap = config.overlap_proportion.max(0.0).min(1.0)
  let authored_bounds = config.bounds
  let cascade_count = if authored_bounds.length() < 1 {
    1
  } else {
    min_int(4, authored_bounds.length()).max(1)
  }
  let mut previous_far = minimum_distance
  for index in 0..<cascade_count {
    let authored_far = if index < authored_bounds.length() &&
      authored_bounds[index] != 0.0 {
      authored_bounds[index]
    } else {
      far
    }
    let far_bound = far.min(authored_far)
    let near_bound = if index == 0 {
      minimum_distance
    } else {
      minimum_distance.max(previous_far * (1.0 - overlap))
    }
    previous_far = far_bound
    if far_bound > near_bound {
      bounds.push({ near_bound, far_bound })
      if far_bound >= far {
        return bounds
      }
    }
  }
  bounds
}

///|
fn camera_frustum_slice_corners3d(
  camera : @render3d_types.FrameCamera3D,
  aspect : Double,
  near_bound : Double,
  far_bound : Double,
) -> Array[@smath.Vec3] {
  let basis = camera_basis3d(camera)
  let corners : Array[@smath.Vec3] = []
  if camera.projection == Orthographic {
    let half_width = camera.orthographic_size
      .map_or(20.0, fn(size) {
        if size[X].abs() > 0.0001 {
          size[X]
        } else {
          20.0
        }
      })
      .abs()
      .max(0.0001) *
      0.5
    let half_height = camera.orthographic_size
      .map_or(20.0, fn(size) {
        if size[Y].abs() > 0.0001 {
          size[Y]
        } else {
          20.0
        }
      })
      .abs()
      .max(0.0001) *
      0.5
    let near_center = camera.position + basis.forward.scalar_mul(near_bound)
    let far_center = camera.position + basis.forward.scalar_mul(far_bound)
    push_frustum_plane_corners3d(
      corners,
      near_center,
      basis.right,
      basis.up,
      half_width,
      half_height,
    )
    push_frustum_plane_corners3d(
      corners,
      far_center,
      basis.right,
      basis.up,
      half_width,
      half_height,
    )
  } else {
    let fov_y = camera.fov_y.max(0.0001) * @math.PI / 180.0
    let tan_half_y = @math.tan(fov_y * 0.5)
    let safe_aspect = if aspect.abs() > 0.0001 { aspect } else { 1.0 }
    let near_height = near_bound * tan_half_y
    let near_width = near_height * safe_aspect
    let far_height = far_bound * tan_half_y
    let far_width = far_height * safe_aspect
    let near_center = camera.position + basis.forward.scalar_mul(near_bound)
    let far_center = camera.position + basis.forward.scalar_mul(far_bound)
    push_frustum_plane_corners3d(
      corners,
      near_center,
      basis.right,
      basis.up,
      near_width,
      near_height,
    )
    push_frustum_plane_corners3d(
      corners,
      far_center,
      basis.right,
      basis.up,
      far_width,
      far_height,
    )
  }
  corners
}

///|
fn push_frustum_plane_corners3d(
  corners : Array[@smath.Vec3],
  center : @smath.Vec3,
  right : @smath.Vec3,
  up : @smath.Vec3,
  half_width : Double,
  half_height : Double,
) -> Unit {
  corners.push(
    center - right.scalar_mul(half_width) - up.scalar_mul(half_height),
  )
  corners.push(
    center + right.scalar_mul(half_width) - up.scalar_mul(half_height),
  )
  corners.push(
    center + right.scalar_mul(half_width) + up.scalar_mul(half_height),
  )
  corners.push(
    center - right.scalar_mul(half_width) + up.scalar_mul(half_height),
  )
}

///|
fn camera_basis3d(camera : @render3d_types.FrameCamera3D) -> CameraBasis3D {
  let forward = normalize_or3d(
    camera.target - camera.position,
    @smath.Vec3(0.0, 0.0, -1.0),
  )
  let up = normalize_or3d(camera.up, @smath.Vec3(0.0, 1.0, 0.0))
  let right = normalize_or3d(forward.cross(up), @smath.Vec3(1.0, 0.0, 0.0))
  let corrected_up = normalize_or3d(
    right.cross(forward),
    @smath.Vec3(0.0, 1.0, 0.0),
  )
  { forward, right, up: corrected_up }
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
fn directional_shadow_atlas_layout3d(cascade_count : Int) -> (Int, Int) {
  if cascade_count <= 1 {
    (1, 1)
  } else if cascade_count == 2 {
    (2, 1)
  } else {
    (2, 2)
  }
}

///|
fn shadow_atlas_rect3d(
  slot : Int,
  columns : Int,
  tile_size : Double,
  atlas_width : Double,
  atlas_height : Double,
) -> (Double, Double, Double, Double) {
  let safe_columns = columns.max(1)
  let column = slot % safe_columns
  let row = slot / safe_columns
  let tile_width = tile_size / atlas_width.max(1.0)
  let tile_height = tile_size / atlas_height.max(1.0)
  (
    column.to_double() * tile_width,
    row.to_double() * tile_height,
    tile_width,
    tile_height,
  )
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
fn mat4_translation3d(x : Double, y : Double, z : Double) -> Array[Double] {
  [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, x, y, z, 1.0]
}

///|
fn transform_point3d(
  matrix : Array[Double],
  point : @smath.Vec3,
) -> @smath.Vec3 {
  if matrix.length() < 16 {
    point
  } else {
    @smath.Vec3(
      matrix[0] * point.x +
      matrix[4] * point.y +
      matrix[8] * point.z +
      matrix[12],
      matrix[1] * point.x +
      matrix[5] * point.y +
      matrix[9] * point.z +
      matrix[13],
      matrix[2] * point.x +
      matrix[6] * point.y +
      matrix[10] * point.z +
      matrix[14],
    )
  }
}

///|
fn vec3_min3d(lhs : @smath.Vec3, rhs : @smath.Vec3) -> @smath.Vec3 {
  @smath.Vec3(lhs.x.min(rhs.x), lhs.y.min(rhs.y), lhs.z.min(rhs.z))
}

///|
fn vec3_max3d(lhs : @smath.Vec3, rhs : @smath.Vec3) -> @smath.Vec3 {
  @smath.Vec3(lhs.x.max(rhs.x), lhs.y.max(rhs.y), lhs.z.max(rhs.z))
}

///|
fn append_directional_shadow_cascade3d(
  values : Array[Double],
  cascade : DirectionalShadowCascade3D,
) -> Unit {
  values.push(cascade.light_index.to_double())
  values.push(cascade.cascade_index.to_double())
  append_matrix3d(values, cascade.light_view_projection)
  values.push(cascade.atlas_offset_x)
  values.push(cascade.atlas_offset_y)
  values.push(cascade.atlas_scale_x)
  values.push(cascade.atlas_scale_y)
  values.push(cascade.near_bound)
  values.push(cascade.far_bound)
}

///|
fn append_spot_shadow_atlas_rect3d(
  values : Array[Double],
  light_index : Int,
) -> Unit {
  let (offset_x, offset_y, scale_x, scale_y) = shadow_atlas_rect3d(
    light_index, 2, 1.0, 2.0, 2.0,
  )
  values.push(offset_x)
  values.push(offset_y)
  values.push(scale_x)
  values.push(scale_y)
}

///|
fn append_point_shadow_atlas_rect3d(
  values : Array[Double],
  light_index : Int,
  face_index : Int,
) -> Unit {
  let (offset_x, offset_y, scale_x, scale_y) = shadow_atlas_rect3d(
    light_index * 6 + face_index,
    8,
    1.0,
    8.0,
    6.0,
  )
  values.push(offset_x)
  values.push(offset_y)
  values.push(scale_x)
  values.push(scale_y)
}

///|
fn append_matrix3d(values : Array[Double], matrix : Array[Double]) -> Unit {
  for value in matrix {
    values.push(value)
  }
}
