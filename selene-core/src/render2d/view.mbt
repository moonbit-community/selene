///|
/// Camera, visibility, sorting, and hierarchy inputs for 2D rendering.
struct RenderView2D {
  cameras : @culling2d.CameraExtract2dContext
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
  visibility : @visibility.VisibilityState
  layers : @ecs.Query[@ecs.Single[@visibility.RenderLayers]]
  parallaxes : @ecs.Query[@ecs.Single[@parallax2d.Parallax2d]]
  sorting : @ecs.Query[@ecs.Single[Sorting2d]]
  display : @window.Display
}

///|
pub impl @ecs.SystemParam for RenderView2D with fn prepare(world) {
  let entities = @ecs.Entities(world)
  let hierarchy = @ecs.Hierarchy(world)
  let visibility = @visibility.VisibilityState(world)
  let layers : @ecs.Query[@ecs.Single[@visibility.RenderLayers]] = world.query()
  let parallaxes : @ecs.Query[@ecs.Single[@parallax2d.Parallax2d]] = world.query()
  let sorting : @ecs.Query[@ecs.Single[Sorting2d]] = world.query()
  let display = @window.Display(world)
  world => {
    cameras: CameraExtract2dContext(@camera.active_camera2d_views(world~)),
    entities,
    hierarchy,
    visibility,
    layers,
    parallaxes,
    sorting,
    display,
  }
}

///|
pub extend RenderView2D with @ecs.SystemParam::{prepare}

///|
pub fn RenderView2D::RenderView2D(world : @ecs.World) -> RenderView2D {
  let fetch : (@ecs.World) -> RenderView2D = @ecs.SystemParam::prepare(world)
  fetch(world)
}

///|
pub fn RenderView2D::camera_views(
  self : RenderView2D,
) -> ArrayView[@camera.Camera2dView] {
  self.cameras.camera_views[:]
}

///|
pub fn RenderView2D::is_alive(
  self : RenderView2D,
  entity : @ecs.Entity,
) -> Bool {
  self.entities.is_alive(entity)
}

///|
pub fn RenderView2D::is_visible(
  self : RenderView2D,
  entity : @ecs.Entity,
) -> Bool {
  self.visibility.is_visible(entity)
}

///|
pub fn RenderView2D::sorting_for(
  self : RenderView2D,
  entity : @ecs.Entity,
) -> Sorting2d {
  self.sorting.get(entity).map_or(Sorting2d(), value => value.0)
}

///|
pub fn RenderView2D::layers_for(
  self : RenderView2D,
  entity : @ecs.Entity,
) -> @visibility.RenderLayers {
  self.layers.get(entity).map_or(RenderLayers(), value => value.0)
}

///|
pub fn RenderView2D::parallax_for(
  self : RenderView2D,
  entity : @ecs.Entity,
) -> @parallax2d.Parallax2d? {
  let mut current = Some(entity)
  while current is Some(current_entity) {
    if self.parallaxes.get(current_entity) is Some(Single(parallax)) {
      return Some(parallax)
    }
    current = self.hierarchy.parent(current_entity)
  }
  None
}

///|
pub fn RenderView2D::camera_views_for_bounds(
  self : RenderView2D,
  bounds : @math.Rect,
  layers : @visibility.RenderLayers,
  parallax_depends_on_camera : Bool,
) -> Array[@camera.Camera2dView] {
  self.cameras.camera_views_for_bounds(
    self.layers,
    bounds,
    layers,
    parallax_depends_on_camera,
  )
}

///|
pub fn RenderView2D::scale_position(
  self : RenderView2D,
  position : @math.Vec2,
) -> @math.Vec2 {
  position.scalar_mul(self.display.zoom())
}

///|
pub fn RenderView2D::screen_transform(
  self : RenderView2D,
  global : @transform.GlobalTransform,
  camera : @camera.Camera2dView?,
) -> @math.Affine2 {
  match camera {
    Some(camera) => @camera.camera_screen_transform(global, Some(camera))
    None =>
      @math.Affine2::from_scale(Vec2(self.display.zoom(), self.display.zoom())) *
      @camera.world_transform_2d(global)
  }
}
