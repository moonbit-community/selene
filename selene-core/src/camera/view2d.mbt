///|
pub struct Camera2dView {
  entity : @ecs.Entity
  camera : Camera
  priv viewport_to_world : @math.Affine2
  priv world_to_viewport : @math.Affine2
  projection : OrthographicProjection
  viewport : @math.Rect
}

///|
fn compare_camera2d_views(lhs : Camera2dView, rhs : Camera2dView) -> Int32 {
  if lhs.camera.order != rhs.camera.order {
    lhs.camera.order - rhs.camera.order
  } else {
    lhs.entity.hash().compare(rhs.entity.hash())
  }
}

///|
fn camera2d_view(entity : @ecs.Entity) -> Camera2dView? {
  guard entity.is_alive() else { return None }
  guard cameras().get(entity) is Some(camera) else { return None }
  guard camera2ds().contains(entity) else { return None }
  guard @transform.global_transform(entity) is Some(global_transform) else {
    return None
  }
  let projection = orthographic_projections().get(entity).unwrap_or_default()
  let viewport = camera.viewport_rect()
  let viewport_to_world = viewport_to_world_affine(
    global_transform, projection, viewport,
  )
  guard viewport_to_world.inverse() is Some(world_to_viewport) else { None }
  Some({
    entity,
    camera,
    viewport_to_world,
    world_to_viewport,
    projection,
    viewport,
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
  self.world_to_viewport.transform_point(world_position)
}

///|
pub fn Camera2dView::viewport_to_world_2d(
  self : Camera2dView,
  viewport_position : @math.Vec2,
) -> @math.Vec2 {
  self.viewport_to_world.transform_point(viewport_position)
}

///|
pub fn Camera2dView::world_origin(self : Camera2dView) -> @math.Vec2 {
  self.viewport_to_world_2d(self.viewport.position)
}

///|
fn rect_from_points(points : Array[@math.Vec2]) -> @math.Rect {
  if points.is_empty() {
    return { position: @math.Vec2::zero(), size: @math.Vec2::zero(), }
  }
  let mut min_x = points[0].x
  let mut min_y = points[0].y
  let mut max_x = points[0].x
  let mut max_y = points[0].y
  for point in points {
    min_x = @cmp.minimum(min_x, point.x)
    min_y = @cmp.minimum(min_y, point.y)
    max_x = @cmp.maximum(max_x, point.x)
    max_y = @cmp.maximum(max_y, point.y)
  }
  { position: Vec2(min_x, min_y), size: Vec2(max_x - min_x, max_y - min_y), }
}

///|
pub fn Camera2dView::world_bounds(self : Camera2dView) -> @math.Rect {
  let viewport = self.viewport
  rect_from_points([
    self.viewport_to_world_2d(viewport.position),
    self.viewport_to_world_2d(
      Vec2(viewport.position.x + viewport.size.x, viewport.position.y),
    ),
    self.viewport_to_world_2d(
      Vec2(viewport.position.x, viewport.position.y + viewport.size.y),
    ),
    self.viewport_to_world_2d(viewport.position + viewport.size),
  ])
}

///|
pub fn transformed_rect_bounds(
  origin : @math.Vec2,
  local_rect : @math.Rect,
  transform : @math.Affine2,
) -> @math.Rect {
  let x0 = local_rect.position.x
  let y0 = local_rect.position.y
  let x1 = x0 + local_rect.size.x
  let y1 = y0 + local_rect.size.y
  let points = [
    transform.transform_point(Vec2(x0, y0)) + origin,
    transform.transform_point(Vec2(x1, y0)) + origin,
    transform.transform_point(Vec2(x1, y1)) + origin,
    transform.transform_point(Vec2(x0, y1)) + origin,
  ]
  rect_from_points(points)
}

///|
pub fn Camera2dView::intersects_screen_rect(
  self : Camera2dView,
  rect : @math.Rect,
) -> Bool {
  if rect.size.x <= 0.0 || rect.size.y <= 0.0 {
    return false
  }
  self.viewport.intersects(rect)
}

///|
/// Returns the screen-space linear map. Callers place the sprite origin separately.
pub fn camera_screen_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : Camera2dView?,
) -> @math.Affine2 {
  let world = world_transform_2d(global_transform)
  let view = match camera_view {
    Some(view) => view.world_to_viewport.with_translation(Vec2(0.0, 0.0))
    None =>
      @math.Affine2::from_scale(Vec2(@window.get_zoom(), @window.get_zoom()))
  }
  view * world
}

///|
/// Returns the world-space linear map. Callers supply the origin separately.
pub fn world_transform_2d(
  global_transform : @transform.GlobalTransform,
) -> @math.Affine2 {
  global_transform.affine.project_xy().with_translation(Vec2(0.0, 0.0))
}

///|
pub fn pixel_snapped_position(position : @math.Vec2) -> @math.Vec2 {
  Vec2(position.x.round(), position.y.round())
}
