///|
pub(all) enum SpriteImageMode {
  Auto
  Tiled(@math.RepeatMode)
}

///|
#selene.component
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
  mut blend_mode : @render.BlendMode2D
}

///|
pub fn sprites() -> @ecs.ComponentStore[Sprite] {
  @ecs.components()
}

///|
fn white_sprite_color() -> @render.Color {
  color_from_css("white")
}

///|
pub fn Sprite::Sprite(
  image~ : @asset.ImageHandle? = None,
  texture_atlas~ : TextureAtlas? = None,
  rect~ : @math.Rect? = None,
  color~ : @render.Color = white_sprite_color(),
  custom_size~ : @math.Vec2? = None,
  anchor~ : Anchor = default_anchor(),
  flip_x~ : Bool = false,
  flip_y~ : Bool = false,
  image_mode~ : SpriteImageMode = Auto,
  blend_mode~ : @render.BlendMode2D = Alpha,
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
    blend_mode,
  }
}

///|
pub fn Sprite::from_image(
  image : @asset.ImageHandle,
  custom_size~ : @math.Vec2? = None,
) -> Sprite {
  Sprite(image=Some(image), custom_size~)
}

///|
pub fn Sprite::from_atlas_image(
  image : @asset.ImageHandle,
  texture_atlas : TextureAtlas,
) -> Sprite {
  let custom_size = texture_atlas_rect(texture_atlas).map(fn(rect) { rect.size })
  Sprite(image=Some(image), texture_atlas=Some(texture_atlas), custom_size~)
}

///|
pub fn Sprite::from_color(
  color : @render.Color,
  custom_size : @math.Vec2,
) -> Sprite {
  Sprite(color~, custom_size=Some(custom_size))
}

///|
let sprite_query : (@ecs.World) -> @ecs.Query2[
  Sprite,
  @transform.GlobalTransform,
] = @ecs.cache_query(world => {
  Query2(@ecs.components_in(world), @ecs.components_in(world))
})

///|
/// Visits Sprites with a GlobalTransform in contiguous archetype rows.
pub fn for_each_sprite_transform(
  visit : (@ecs.Entity, Sprite, @transform.GlobalTransform) -> Unit,
) -> Unit {
  sprite_query(@ecs.require_current_world()).for_each(visit)
}

///|
pub fn render_sprite_system(delta : Double) -> Unit {
  ignore(delta)
  let camera_views = @camera.active_camera2d_views()
  let camera_extract = @culling2d.build_camera_extract2d_context(camera_views)
  let is_alive = @ecs.alive_in_world(@ecs.require_current_world())
  let sprites = sprites()
  let sorting2ds = @render2d.sorting2ds()
  // Draw ties retain Sprite insertion order even when a row moves tables.
  let order_base = @render2d.reserve_world_command_order(sprites.order_span())
  for_each_sprite_transform((entity, sprite, global_transform) => {
    guard is_alive(entity) else { return }
    guard @visibility.is_visible(entity) else { return }
    guard sprite_size(sprite) is Some(size) else { return }
    let order = order_base + sprites.insertion_order(entity)
    let sorting = sorting2ds.get(entity).unwrap_or(Sorting2d())
    let depth = @render2d.sort_depth_for_transform(global_transform, sorting)
    let transform = global_transform.compute_transform()
    let base_pos = @math.Vec2(transform.translation.x, transform.translation.y)
    let parallax = @parallax2d.inherited_parallax2d(entity)
    let local_transform = sprite_local_transform(sprite, size)
    if camera_views.is_empty() {
      let screen_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        None,
      )
      push_sprite_draw_command(
        entity,
        sprite,
        size,
        depth,
        @camera.pixel_snapped_position(@system.scale_vec2(screen_pos)),
        @camera.camera_screen_transform(global_transform, None) *
        local_transform,
        None,
        sorting,
        order,
      )
      return
    }
    let world_pos = @parallax2d.parallax_world_position(
      base_pos,
      parallax,
      None,
    )
    let world_bounds = @camera.transformed_rect_bounds(
      world_pos,
      { position: @math.Vec2::zero(), size, },
      @camera.world_transform_2d(global_transform) * local_transform,
    )
    let camera_views_for_entity = camera_extract.camera_views_for_bounds(
      world_bounds,
      @visibility.entity_render_layers(entity),
      @parallax2d.parallax_depends_on_camera(parallax),
    )
    for camera_view in camera_views_for_entity {
      let raw_pos = @parallax2d.parallax_world_position(
        base_pos,
        parallax,
        Some(camera_view),
      )
      let screen_transform = @camera.camera_screen_transform(
          global_transform,
          Some(camera_view),
        ) *
        local_transform
      let screen_position = @camera.pixel_snapped_position(
        camera_view.world_to_viewport(raw_pos),
      )
      let bounds = @camera.transformed_rect_bounds(
        screen_position,
        { position: @math.Vec2::zero(), size, },
        screen_transform,
      )
      guard camera_view.intersects_screen_rect(bounds) else { continue }
      push_sprite_draw_command(
        entity,
        sprite,
        size,
        depth,
        screen_position,
        screen_transform,
        Some(camera_view.entity.id()),
        sorting,
        order,
      )
    }
  })
}

///|
fn push_sprite_draw_command(
  entity : @ecs.Entity,
  sprite : Sprite,
  size : @math.Vec2,
  depth : Double,
  snapped_pos : @math.Vec2,
  transform : @math.Transform,
  camera_entity_id : UInt32?,
  sorting : @render2d.Sorting2d,
  order : Int32,
) -> Unit {
  let command : @render2d_types.DrawCommand2D = match sprite.image {
    Some(image) =>
      Image({
        image,
        destination: { position: snapped_pos, size, },
        source: sprite_image_region(sprite),
        transform,
        uv_transform: @math.Transform::identity(),
        repeat: sprite_repeat_mode(sprite),
        alpha_mode: sprite_alpha_mode(sprite),
        blend_mode: sprite_blend_mode(sprite),
        color: sprite.color,
      })
    None =>
      Rect({
        rect: { position: snapped_pos, size, },
        transform,
        alpha_mode: sprite_alpha_mode(sprite),
        blend_mode: sprite_blend_mode(sprite),
        fill_color: sprite.color,
        stroke_color: None,
      })
  }
  @render2d.push_world_command(
    depth,
    Some(entity.id()),
    command,
    camera_entity_id~,
    sorting~,
    order=Some(order),
  )
}

///|
fn sprite_alpha_mode(sprite : Sprite) -> @render.AlphaMode2D {
  if sprite.image is Some(_) {
    Blend
  } else if sprite.color.a >= 0.999999 {
    Opaque
  } else {
    Blend
  }
}

///|
fn sprite_blend_mode(sprite : Sprite) -> @render.BlendMode2D {
  sprite.blend_mode
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
        { position: rect.position, size: rect.size, }
      })
    None =>
      sprite.rect.map(fn(rect) { { position: rect.position, size: rect.size, } })
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
