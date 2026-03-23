///|
pub(all) struct Text2d {

  fn new() -> Text2d
} derive(Eq, Show)

///|
priv struct Text2dWorldStore {
  text2ds : Map[@entity.Entity, Text2d]
}

///|
let text2d_world_stores : Map[UInt, Text2dWorldStore] = Map::new()

///|
fn text2d_world_store() -> Text2dWorldStore {
  let world_id = @ecs.require_current_world().id()
  text2d_world_stores.get_or_init(world_id, fn() { { text2ds: Map::new() } })
}

///|
pub fn text2ds() -> Map[@entity.Entity, Text2d] {
  text2d_world_store().text2ds
}

///|
pub fn Text2d::new() -> Text2d {
  Text2d::{  }
}

///|
fn active_camera2d_view() -> (
  @camera.Camera,
  @transform.GlobalTransform,
  @camera.OrthographicProjection,
)? {
  let mut selected : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
    Int,
  )? = None
  for entity, camera in @camera.cameras() {
    guard entity.is_alive() else { continue }
    guard camera.is_active else { continue }
    guard @camera.camera2ds().contains(entity) else { continue }
    let projection = @camera.orthographic_projections()
      .get(entity)
      .unwrap_or_default()
    guard @transform.global_transforms().get(entity) is Some(global) else {
      continue
    }
    match selected {
      Some((_, _, _, order)) if order >= camera.order => ()
      _ => selected = Some((camera, global, projection, camera.order))
    }
  }
  match selected {
    Some((camera, global, projection, _)) => Some((camera, global, projection))
    None => None
  }
}

///|
fn screen_space_transform(
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
fn camera_relative_transform(
  global_transform : @transform.GlobalTransform,
  camera_transform : @transform.GlobalTransform,
  projection : @camera.OrthographicProjection,
) -> @transform.Transform {
  let relative_global = match camera_transform.affine.inverse() {
    Some(inverse_camera) =>
      @transform.GlobalTransform::{
        affine: inverse_camera * global_transform.affine,
      }
    None => global_transform
  }
  let relative = relative_global.compute_transform()
  let projection_scale = if projection.scale <= 0.0 {
    1.0
  } else {
    projection.scale
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
fn text_screen_transform(
  global_transform : @transform.GlobalTransform,
  camera_view : (
    @camera.Camera,
    @transform.GlobalTransform,
    @camera.OrthographicProjection,
  )?,
) -> @math.Transform {
  let transform = match camera_view {
    Some((_, camera_transform, projection)) =>
      camera_relative_transform(global_transform, camera_transform, projection)
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
pub fn render_text2d_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_view = active_camera2d_view()
  for entity, _ in text2ds() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    guard @ui.texts().get(entity) is Some(text) else { continue }
    guard @ui.text_style_for(entity) is Some(style) else { continue }
    let transform = global_transform.compute_transform()
    let raw_pos = @math.Vec2D(transform.translation.x, transform.translation.y)
    let screen_pos = match camera_view {
      Some((camera, camera_global, projection)) =>
        camera.world_to_viewport(camera_global, projection, raw_pos)
      None => @system.scale_vec2(raw_pos)
    }
    @render2d.push_text_with_depth(global_transform.translation().z, {
      text: text.content,
      position: screen_pos,
      transform: text_screen_transform(global_transform, camera_view),
      style,
    })
  }
}
