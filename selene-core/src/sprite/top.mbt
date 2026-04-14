///|
pub(all) enum SpriteImageMode {
  Auto
  Tiled(@math.RepeatMode)
}

///|
pub(all) struct Sprite {
  image : @asset.ImageHandle?
  mut texture_atlas : TextureAtlas?
  mut rect : @math.Rect?
  mut color : @render.Color
  mut custom_size : @math.Vec2?
  mut anchor : Anchor
  mut flip_x : Bool
  mut flip_y : Bool
  mut image_mode : SpriteImageMode

  fn new(
    image? : @asset.ImageHandle?,
    texture_atlas? : TextureAtlas?,
    rect? : @math.Rect?,
    color? : @render.Color,
    custom_size? : @math.Vec2?,
    anchor? : Anchor,
    flip_x? : Bool,
    flip_y? : Bool,
    image_mode? : SpriteImageMode,
  ) -> Sprite
}

///|
priv struct SpriteWorldStore {
  sprites : Map[@entity.Entity, Sprite]
}

///|
let sprite_world_stores : Map[UInt, SpriteWorldStore] = Map::new()

///|
fn sprite_world_store() -> SpriteWorldStore {
  let world_id = @ecs.require_current_world().id()
  sprite_world_stores.get_or_init(world_id, fn() { { sprites: Map::new() } })
}

///|
pub fn sprites() -> Map[@entity.Entity, Sprite] {
  sprite_world_store().sprites
}

///|
fn white_sprite_color() -> @render.Color {
  color_from_css("white")
}

///|
pub fn Sprite::new(
  image? : @asset.ImageHandle? = None,
  texture_atlas? : TextureAtlas? = None,
  rect? : @math.Rect? = None,
  color? : @render.Color = white_sprite_color(),
  custom_size? : @math.Vec2? = None,
  anchor? : Anchor = default_anchor(),
  flip_x? : Bool = false,
  flip_y? : Bool = false,
  image_mode? : SpriteImageMode = Auto,
) -> Sprite {
  {
    image,
    texture_atlas,
    rect,
    color,
    custom_size,
    anchor,
    flip_x,
    flip_y,
    image_mode,
  }
}

///|
pub fn Sprite::from_image(
  image : @asset.ImageHandle,
  custom_size? : @math.Vec2? = None,
) -> Sprite {
  Sprite::new(image=Some(image), custom_size~)
}

///|
pub fn Sprite::from_atlas_image(
  image : @asset.ImageHandle,
  texture_atlas : TextureAtlas,
) -> Sprite {
  let custom_size = texture_atlas_rect(texture_atlas).map(fn(rect) { rect.size })
  Sprite::new(
    image=Some(image),
    texture_atlas=Some(texture_atlas),
    custom_size~,
  )
}

///|
pub fn Sprite::from_color(
  color : @render.Color,
  custom_size : @math.Vec2,
) -> Sprite {
  Sprite::new(color~, custom_size=Some(custom_size))
}

///|
pub fn render_sprite_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_view = active_camera2d_view()
  for entity, sprite in sprites() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    let depth = global_transform.translation().z
    let transform = global_transform.compute_transform()
    let raw_pos = @math.Vec2(transform.translation.x, transform.translation.y)
    let screen_pos = match camera_view {
      Some((camera, camera_global, projection)) =>
        camera.world_to_viewport(camera_global, projection, raw_pos)
      None => @system.scale_vec2(raw_pos)
    }
    let sprite_transform = sprite_screen_transform(
      global_transform, camera_view,
    )
    guard sprite_size(sprite) is Some(size) else { continue }
    let local_transform = sprite_local_transform(sprite, size)
    let external_transform = sprite_transform * local_transform
    let snapped_pos = pixel_snapped_position(screen_pos)
    match sprite.image {
      Some(image) => {
        let command : @render2d_types.ImageDrawCommand2D = {
          image,
          destination: { position: snapped_pos, size },
          source: sprite_image_region(sprite),
          transform: external_transform,
          repeat: sprite_repeat_mode(sprite),
          color: sprite.color,
        }
        @render2d.push_image_with_depth_for_entity(
          depth,
          Some(entity.id()),
          command,
        )
      }
      None => {
        let command : @render2d_types.RectDrawCommand2D = {
          rect: { position: snapped_pos, size },
          transform: external_transform,
          fill_color: sprite.color,
          stroke_color: None,
        }
        @render2d.push_rect_with_depth_for_entity(
          depth,
          Some(entity.id()),
          command,
        )
      }
    }
  }
}

///|
fn sprite_repeat_mode(sprite : Sprite) -> @math.RepeatMode {
  match sprite.image_mode {
    Auto => NoRepeat
    Tiled(repeat) => repeat
  }
}

///|
fn sprite_image_region(sprite : Sprite) -> @render2d_types.ImageRegion2D? {
  match sprite.texture_atlas {
    Some(texture_atlas) =>
      texture_atlas_rect(texture_atlas).map(fn(rect) {
        { position: rect.position, size: rect.size }
      })
    None =>
      sprite.rect.map(fn(rect) { { position: rect.position, size: rect.size } })
  }
}

///|
fn sprite_source_size(sprite : Sprite) -> @math.Vec2? {
  sprite_image_region(sprite).map(fn(region) { region.size })
}

///|
fn sprite_size(sprite : Sprite) -> @math.Vec2? {
  match sprite.custom_size {
    Some(size) => Some(size)
    None =>
      match sprite.image {
        Some(_) => sprite_source_size(sprite)
        None => sprite.rect.map(fn(rect) { rect.size })
      }
  }
}

///|
fn sprite_local_transform(
  sprite : Sprite,
  size : @math.Vec2,
) -> @math.Transform {
  let anchor_offset = anchor_translation(sprite.anchor, size)
  let anchor_transform = @math.Transform::from_translation(
    anchor_offset[X],
    anchor_offset[Y],
  )
  let flip_transform = @math.Transform::from_translation(
      if sprite.flip_x {
        size[X]
      } else {
        0.0
      },
      if sprite.flip_y {
        size[Y]
      } else {
        0.0
      },
    ) *
    @math.Transform::from_scale(
      if sprite.flip_x {
        -1.0
      } else {
        1.0
      },
      if sprite.flip_y {
        -1.0
      } else {
        1.0
      },
    )
  anchor_transform * flip_transform
}

///|
fn pixel_snapped_position(position : @math.Vec2) -> @math.Vec2 {
  @math.Vec2(position[X].round(), position[Y].round())
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
fn sprite_screen_transform(
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
