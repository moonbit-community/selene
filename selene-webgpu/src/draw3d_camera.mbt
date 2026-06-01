///|
fn webgpu_canvas_aspect_ratio() -> Double {
  let size = webgpu_canvas_size()
  if size.length() < 2 || size[1] <= 0.0 {
    1.0
  } else {
    size[0] / size[1]
  }
}

///|
fn pack_camera_view_projection3d(
  camera : @render3d_types.FrameCamera3D,
  aspect : Double,
) -> Array[Double] {
  let near = if camera.near > 0.0 { camera.near } else { 0.1 }
  let far = if camera.far > near { camera.far } else { near + 200.0 }
  let projection = if camera.projection == Orthographic {
    let width = camera.orthographic_size.map_or(20.0, fn(size) {
      if size[X].abs() > 0.0001 {
        size[X]
      } else {
        20.0
      }
    })
    let height = camera.orthographic_size.map_or(20.0, fn(size) {
      if size[Y].abs() > 0.0001 {
        size[Y]
      } else {
        20.0
      }
    })
    mat4_orthographic3d(width, height, near, far)
  } else {
    mat4_perspective3d(camera.fov_y, aspect, near, far)
  }
  mat4_multiply3d(
    projection,
    mat4_look_at3d(camera.position, camera.target, camera.up),
  )
}

///|
fn mat4_multiply3d(lhs : Array[Double], rhs : Array[Double]) -> Array[Double] {
  let out : Array[Double] = []
  for _ in 0..<16 {
    out.push(0.0)
  }
  for column in 0..<4 {
    for row in 0..<4 {
      out[column * 4 + row] = lhs[0 * 4 + row] * rhs[column * 4 + 0] +
        lhs[1 * 4 + row] * rhs[column * 4 + 1] +
        lhs[2 * 4 + row] * rhs[column * 4 + 2] +
        lhs[3 * 4 + row] * rhs[column * 4 + 3]
    }
  }
  out
}

///|
fn mat4_look_at3d(
  eye : @smath.Vec3,
  target : @smath.Vec3,
  up : @smath.Vec3,
) -> Array[Double] {
  let z_axis = normalize_or3d(eye - target, @smath.Vec3(0.0, 0.0, 1.0))
  let x_axis = normalize_or3d(up.cross(z_axis), @smath.Vec3(1.0, 0.0, 0.0))
  let y_axis = z_axis.cross(x_axis)
  [
    x_axis.x,
    y_axis.x,
    z_axis.x,
    0.0,
    x_axis.y,
    y_axis.y,
    z_axis.y,
    0.0,
    x_axis.z,
    y_axis.z,
    z_axis.z,
    0.0,
    -x_axis.dot(eye),
    -y_axis.dot(eye),
    -z_axis.dot(eye),
    1.0,
  ]
}

///|
fn mat4_perspective3d(
  fov_y_degrees : Double,
  aspect : Double,
  near : Double,
  far : Double,
) -> Array[Double] {
  let safe_aspect = if aspect.abs() > 0.0001 { aspect } else { 1.0 }
  let fov_y = fov_y_degrees * @math.PI / 180.0
  let f = 1.0 / @math.tan(fov_y / 2.0)
  [
    f / safe_aspect,
    0.0,
    0.0,
    0.0,
    0.0,
    f,
    0.0,
    0.0,
    0.0,
    0.0,
    far / (near - far),
    -1.0,
    0.0,
    0.0,
    near * far / (near - far),
    0.0,
  ]
}

///|
fn mat4_orthographic3d(
  width : Double,
  height : Double,
  near : Double,
  far : Double,
) -> Array[Double] {
  let half_width = width.abs().max(0.0001) / 2.0
  let half_height = height.abs().max(0.0001) / 2.0
  let left = -half_width
  let right = half_width
  let bottom = -half_height
  let top = half_height
  [
    2.0 / (right - left),
    0.0,
    0.0,
    0.0,
    0.0,
    2.0 / (top - bottom),
    0.0,
    0.0,
    0.0,
    0.0,
    1.0 / (near - far),
    0.0,
    -(right + left) / (right - left),
    -(top + bottom) / (top - bottom),
    near / (near - far),
    1.0,
  ]
}

///|
fn normalize_or3d(value : @smath.Vec3, fallback : @smath.Vec3) -> @smath.Vec3 {
  if value.length_squared() <= 0.0000001 {
    fallback
  } else {
    value.normalize()
  }
}
