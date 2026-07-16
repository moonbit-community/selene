///|
/// Selects the camera-space reference used to calculate parallax displacement.
/// `ViewCenter` stores the world-space point that should align with the center
/// of each camera view.
pub enum Parallax2dReference {
  ViewOrigin
  ViewCenter(@math.Vec2)
} derive(Eq, Debug)

///|
/// Creates a reference measured from each camera view center.
pub fn Parallax2dReference::view_center(
  reference_origin : @math.Vec2,
) -> Parallax2dReference {
  ViewCenter(reference_origin)
}

///|
pub(all) struct Parallax2d {
  base_offset : @math.Vec2
  factor : @math.Vec2
  reference : Parallax2dReference
} derive(Eq, Debug)

///|
priv struct Parallax2dWorldStore {
  parallax2ds : Map[@entity.Entity, Parallax2d]
}

///|
let parallax2d_world_stores : Map[UInt, Parallax2dWorldStore] = Map([])

///|
fn parallax2d_world_store() -> Parallax2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  parallax2d_world_stores.get_or_init(world_id, fn() {
    { parallax2ds: Map([]) }
  })
}

///|
fn clamped_parallax_factor(factor : @math.Vec2) -> @math.Vec2 {
  Vec2(
    if factor[X] < 0.0 {
      0.0
    } else {
      factor[X]
    },
    if factor[Y] < 0.0 {
      0.0
    } else {
      factor[Y]
    },
  )
}

///|
pub fn Parallax2d::Parallax2d(
  base_offset? : @math.Vec2 = @math.Vec2::zero(),
  factor? : @math.Vec2 = Vec2(1.0, 1.0),
  reference? : Parallax2dReference = ViewOrigin,
) -> Parallax2d {
  { base_offset, factor: clamped_parallax_factor(factor), reference }
}

///|
pub fn parallax2ds() -> Map[@entity.Entity, Parallax2d] {
  parallax2d_world_store().parallax2ds
}

///|
pub fn inherited_parallax2d(entity : @entity.Entity) -> Parallax2d? {
  let mut current = Some(entity)
  while current is Some(current_entity) {
    if parallax2ds().get(current_entity) is Some(parallax) {
      return Some(parallax)
    }
    current = current_entity.get_parent()
  }
  None
}

///|
pub fn parallax_world_position(
  base_position : @math.Vec2,
  parallax : Parallax2d?,
  camera_view : @camera.Camera2dView?,
) -> @math.Vec2 {
  let shifted = base_position +
    parallax.map_or(@math.Vec2::zero(), fn(parallax) { parallax.base_offset })
  match (parallax, camera_view) {
    (Some(parallax), Some(camera_view)) => {
      let reference_offset = match parallax.reference {
        ViewOrigin => camera_view.world_origin()
        ViewCenter(reference_origin) => {
          let view_center = camera_view.viewport_to_world_2d(
            camera_view.viewport.position +
            camera_view.viewport.size.scalar_mul(0.5),
          )
          view_center - reference_origin
        }
      }
      shifted +
      Vec2(
        reference_offset[X] * (1.0 - parallax.factor[X]),
        reference_offset[Y] * (1.0 - parallax.factor[Y]),
      )
    }
    _ => shifted
  }
}

///|
pub fn parallax_depends_on_camera(parallax : Parallax2d?) -> Bool {
  match parallax {
    Some(parallax) =>
      (parallax.factor[X] - 1.0).abs() > 0.000001 ||
      (parallax.factor[Y] - 1.0).abs() > 0.000001
    None => false
  }
}
