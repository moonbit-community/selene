///|
/// Queries and inputs shared by collision picking and visualization.
struct CollisionQueries {
  colliders : @ecs.Query[@ecs.Single[Collider]]
  areas : @ecs.Query[@ecs.Single[Area]]
  pickables : @ecs.Query[@ecs.Single[Pickable]]
  shapes : @ecs.Query[@ecs.Single[CollisionShape]]
  transforms : @transform.Transforms
  geometry : @ui.UiGeometryView
  display : @window.Display
  view : @render2d.RenderView2D
  events : @event.EventWriter[PointerEvent]
}

///|
pub impl @ecs.SystemParam for CollisionQueries with fn prepare(world) {
  let fetch : (@ecs.World) -> @render2d.RenderView2D = @ecs.SystemParam::prepare(
    world,
  )
  let colliders = world.query()
  let areas = world.query()
  let pickables = world.query()
  let shapes = world.query()
  let transforms = @transform.Transforms(world)
  let geometry = @ui.UiGeometryView(world)
  let display = @window.Display(world)
  let events = pointer_event_bus.writer(world~)
  world => {
    colliders,
    areas,
    pickables,
    shapes,
    transforms,
    geometry,
    display,
    events,
    view: fetch(world),
  }
}

///|
pub extend CollisionQueries with @ecs.SystemParam::{prepare}

///|
pub fn CollisionQueries::CollisionQueries(
  world : @ecs.World,
) -> CollisionQueries {
  let fetch : (@ecs.World) -> CollisionQueries = @ecs.SystemParam::prepare(
    world,
  )
  fetch(world)
}

///|
fn CollisionQueries::camera_at(
  self : CollisionQueries,
  point : @math.Vec2,
) -> @camera.Camera2dView? {
  let cameras = self.view.camera_views()
  for i in (cameras.length() - 1)>=..0 {
    let camera = cameras[i]
    if point_in_rect(point, camera.viewport.position, camera.viewport.size) {
      return Some(camera)
    }
  }
  None
}
