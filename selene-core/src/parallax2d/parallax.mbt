///|
/// Selects the camera-space reference used to calculate parallax displacement.
/// `ViewCenter` stores the world-space point that should align with the center
/// of each camera view.
#derive(Eq, Debug)
pub enum Parallax2dReference {
  ViewOrigin
  ViewCenter(@math.Vec2)
}

///|
pub extend Parallax2dReference with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Parallax2dReference with Eq::{not_equal, equal}

///|
/// Creates a reference measured from each camera view center.
pub fn Parallax2dReference::view_center(
  reference_origin : @math.Vec2,
) -> Parallax2dReference {
  ViewCenter(reference_origin)
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Parallax2d {
  base_offset : @math.Vec2
  factor : @math.Vec2
  reference : Parallax2dReference
}

///|
pub extend Parallax2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Parallax2d with Eq::{not_equal, equal}

///|
fn clamped_parallax_factor(factor : @math.Vec2) -> @math.Vec2 {
  Vec2(
    if factor.x < 0.0 {
      0.0
    } else {
      factor.x
    },
    if factor.y < 0.0 {
      0.0
    } else {
      factor.y
    },
  )
}

///|
pub fn Parallax2d::Parallax2d(
  base_offset~ : @math.Vec2 = @math.Vec2::zero(),
  factor~ : @math.Vec2 = Vec2(1.0, 1.0),
  reference~ : Parallax2dReference = ViewOrigin,
) -> Parallax2d {
  { base_offset, factor: clamped_parallax_factor(factor), reference, }
}

///|
pub fn parallax2ds() -> @ecs.ComponentStore[Parallax2d] {
  @ecs.components()
}

///|
pub fn inherited_parallax2d(entity : @ecs.Entity) -> Parallax2d? {
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
        reference_offset.x * (1.0 - parallax.factor.x),
        reference_offset.y * (1.0 - parallax.factor.y),
      )
    }
    _ => shifted
  }
}

///|
pub fn parallax_depends_on_camera(parallax : Parallax2d?) -> Bool {
  match parallax {
    Some(parallax) =>
      (parallax.factor.x - 1.0).abs() > 0.000001 ||
      (parallax.factor.y - 1.0).abs() > 0.000001
    None => false
  }
}
