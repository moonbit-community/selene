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
      if size.x.abs() > 0.0001 {
        size.x
      } else {
        20.0
      }
    })
    let height = camera.orthographic_size.map_or(20.0, fn(size) {
      if size.y.abs() > 0.0001 {
        size.y
      } else {
        20.0
      }
    })
    @smath.Mat4::orthographic_rh_zo(width.abs(), height.abs(), near, far)
  } else {
    @smath.Mat4::perspective_rh_zo(
      camera.fov_y * @math.PI / 180.0,
      if aspect.abs() > 0.0001 {
        aspect
      } else {
        1.0
      },
      near,
      far,
    )
  }
  (projection *
  @smath.Mat4::look_at_rh(camera.position, camera.target, camera.up)).to_column_major()
}

///|
fn normalize_or3d(value : @smath.Vec3, fallback : @smath.Vec3) -> @smath.Vec3 {
  value.try_normalize().unwrap_or(fallback)
}
