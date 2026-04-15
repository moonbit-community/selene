///|
pub(all) struct Camera2dView {
  entity : @entity.Entity
  camera : Camera
  global_transform : @transform.GlobalTransform
  projection : OrthographicProjection
  viewport : @math.Rect
}

///|
fn compare_camera2d_views(lhs : Camera2dView, rhs : Camera2dView) -> Int {
  if lhs.camera.order != rhs.camera.order {
    lhs.camera.order - rhs.camera.order
  } else {
    lhs.entity.hash().compare(rhs.entity.hash())
  }
}

///|
fn camera2d_view(entity : @entity.Entity) -> Camera2dView? {
  guard entity.is_alive() else { return None }
  guard cameras().get(entity) is Some(camera) else { return None }
  guard camera2ds().contains(entity) else { return None }
  guard @transform.global_transforms().get(entity) is Some(global_transform) else {
    return None
  }
  let projection = orthographic_projections().get(entity).unwrap_or_default()
  Some({
    entity,
    camera,
    global_transform,
    projection,
    viewport: camera.viewport_rect(),
  })
}

///|
pub fn active_camera2d_views() -> Array[Camera2dView] {
  let views : Array[Camera2dView] = []
  for entity, camera in cameras() {
    guard camera.is_active else { continue }
    guard camera2d_view(entity) is Some(view) else { continue }
    views.push(view)
  }
  views.sort_by(compare_camera2d_views)
  views
}

///|
pub fn primary_camera2d_view() -> Camera2dView? {
  let views = active_camera2d_views()
  if views.is_empty() {
    None
  } else {
    Some(views[views.length() - 1])
  }
}

///|
pub fn camera2d_view_for_screen_point(point : @math.Vec2) -> Camera2dView? {
  let views = active_camera2d_views()
  let mut index = views.length() - 1
  while index >= 0 {
    let view = views[index]
    if view.camera.contains_screen_point(point) {
      return Some(view)
    }
    index -= 1
  }
  None
}

///|
pub fn Camera2dView::world_to_viewport(
  self : Camera2dView,
  world_position : @math.Vec2,
) -> @math.Vec2 {
  self.camera.world_to_viewport(
    self.global_transform,
    self.projection,
    world_position,
  )
}

///|
pub fn Camera2dView::viewport_to_world_2d(
  self : Camera2dView,
  viewport_position : @math.Vec2,
) -> @math.Vec2 {
  self.camera.viewport_to_world_2d(
    self.global_transform,
    self.projection,
    viewport_position,
  )
}

///|
pub fn screen_space_transform(
  transform : @transform.Transform,
) -> @transform.Transform {
  transform.with_scale(
    @math.Vec3::new(
      transform.scale.x * @system.get_zoom(),
      transform.scale.y * @system.get_zoom(),
      transform.scale.z,
    ),
  )
}

///|
pub fn camera_relative_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : Camera2dView,
) -> @transform.Transform {
  let relative_global = match camera_view.global_transform.affine.inverse() {
    Some(inverse_camera) =>
      @transform.GlobalTransform::{
        affine: inverse_camera * global_transform.affine,
      }
    None => global_transform
  }
  let relative = relative_global.compute_transform()
  let projection_scale = if camera_view.projection.scale <= 0.0 {
    1.0
  } else {
    camera_view.projection.scale
  }
  let pixels_per_world_unit = @system.get_zoom() / projection_scale
  relative.with_scale(
    @math.Vec3::new(
      relative.scale.x * pixels_per_world_unit,
      relative.scale.y * pixels_per_world_unit,
      relative.scale.z,
    ),
  )
}

///|
pub fn camera_screen_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : Camera2dView?,
) -> @math.Transform {
  let transform = match camera_view {
    Some(camera_view) =>
      camera_relative_transform(global_transform, camera_view)
    None => screen_space_transform(global_transform.compute_transform())
  }
  let x_axis = transform.rotation.rotate_vec3(
    @math.Vec3::x_axis().scalar_mul(transform.scale.x),
  )
  let y_axis = transform.rotation.rotate_vec3(
    @math.Vec3::y_axis().scalar_mul(transform.scale.y),
  )
  @math.Transform::new(a=x_axis.x, b=x_axis.y, c=y_axis.x, d=y_axis.y)
}

///|
pub fn pixel_snapped_position(position : @math.Vec2) -> @math.Vec2 {
  @math.Vec2(position[X].round(), position[Y].round())
}
