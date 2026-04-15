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
  let camera_views = @camera.active_camera2d_views()
  for entity, sprite in sprites() {
    guard entity.is_alive() else { continue }
    guard @visibility.is_visible(entity) else { continue }
    guard @transform.global_transforms().get(entity) is Some(global_transform) else {
      continue
    }
    guard sprite_size(sprite) is Some(size) else { continue }
    let depth = global_transform.translation().z
    let transform = global_transform.compute_transform()
    let raw_pos = @math.Vec2(transform.translation.x, transform.translation.y)
    let local_transform = sprite_local_transform(sprite, size)
    if camera_views.is_empty() {
      push_sprite_draw_command(
        entity,
        sprite,
        size,
        depth,
        @camera.pixel_snapped_position(@system.scale_vec2(raw_pos)),
        @camera.camera_screen_transform(global_transform, None) *
        local_transform,
        None,
      )
      continue
    }
    let entity_layers = @visibility.entity_render_layers(entity)
    for camera_view in camera_views {
      guard @visibility.matches(
        @visibility.entity_render_layers(camera_view.entity),
        entity_layers,
      ) else {
        continue
      }
      push_sprite_draw_command(
        entity,
        sprite,
        size,
        depth,
        @camera.pixel_snapped_position(camera_view.world_to_viewport(raw_pos)),
        @camera.camera_screen_transform(global_transform, Some(camera_view)) *
        local_transform,
        Some(camera_view.entity.id()),
      )
    }
  }
}

///|
fn push_sprite_draw_command(
  entity : @entity.Entity,
  sprite : Sprite,
  size : @math.Vec2,
  depth : Double,
  snapped_pos : @math.Vec2,
  transform : @math.Transform,
  camera_entity_id : UInt?,
) -> Unit {
  match sprite.image {
    Some(image) => {
      let command : @render2d_types.ImageDrawCommand2D = {
        image,
        destination: { position: snapped_pos, size },
        source: sprite_image_region(sprite),
        transform,
        repeat: sprite_repeat_mode(sprite),
        color: sprite.color,
      }
      match camera_entity_id {
        Some(camera_entity_id) =>
          @render2d.push_image_with_depth_to_camera(
            camera_entity_id,
            depth,
            command,
            entity_id=Some(entity.id()),
          )
        None =>
          @render2d.push_image_with_depth_for_entity(
            depth,
            Some(entity.id()),
            command,
          )
      }
    }
    None => {
      let command : @render2d_types.RectDrawCommand2D = {
        rect: { position: snapped_pos, size },
        transform,
        fill_color: sprite.color,
        stroke_color: None,
      }
      match camera_entity_id {
        Some(camera_entity_id) =>
          @render2d.push_rect_with_depth_to_camera(
            camera_entity_id,
            depth,
            command,
            entity_id=Some(entity.id()),
          )
        None =>
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
