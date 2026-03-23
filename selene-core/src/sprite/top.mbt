// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Visual element that can be rendered to the screen.
///
/// Fields:
///
/// * `sprite_type` : The visual content of the sprite (picture, animation, or
///   text).
/// * `visible` : Whether the sprite should be rendered to the screen.
///
/// Examples:
///
/// ```notest
/// // Create an animation sprite
/// let animation = @sprite.Animation::new([frame1, frame2])
/// let sprite = @sprite.Sprite::from_animation(animation)
/// sprite.visible = false // Hide the sprite
///
/// // Create a picture sprite
/// let picture = @sprite.Picture::new(size, "path/to/image.png")
/// let sprite = @sprite.Sprite::from_picture(picture)
///
/// // Create a text sprite
/// let text = @sprite.Text::new("Hello World", color="red")
/// let sprite = @sprite.Sprite::from_text(text)
/// ```
///
pub(all) struct Sprite {
  sprite_type : SpriteType
  mut visible : Bool
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
  sprite_world_stores.get_or_init(world_id, () => { sprites: Map::new() })
}

///|
pub fn sprites() -> Map[@entity.Entity, Sprite] {
  sprite_world_store().sprites
}

///|
pub enum SpriteType {
  Picture(Picture)
  Animation(Animation, mut frame~ : Double)
  Text(Text)
  ColorRect(ColorRect)
  ColorCircle(ColorCircle)
}

///|
/// Make an animation sprite with default animation state.
pub fn Sprite::from_animation(animation : Animation) -> Sprite {
  { sprite_type: SpriteType::Animation(animation, frame=0), visible: true }
}

///|
/// Creates a sprite from a picture.
///
/// Parameters:
///
/// * `picture` : The `Picture` object containing the image data and dimensions
///   to be rendered.
/// Returns a new `Sprite` with the picture as its visual content, initially set
/// to visible.
///
pub fn Sprite::from_picture(picture : Picture) -> Sprite {
  { sprite_type: SpriteType::Picture(picture), visible: true }
}

///|
/// Creates a sprite from text content.
///
/// Parameters:
///
/// * `text` : The `Text` object containing the text content, styling, and
///   formatting information.
/// Returns a new `Sprite` with the text as its visual content, initially
/// visible.
///
/// Example:
///
/// ```moonbit nocheck
/// let text = @sprite.Text::new("Hello World", color="red")
/// let sprite = @sprite.Sprite::from_text(text)
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_text(text : Text) -> Sprite {
  { sprite_type: SpriteType::Text(text), visible: true }
}

///|
/// Creates a sprite from a color rectangle.
///
/// Parameters:
///
/// * `color_rect` : The `ColorRect` to use as the sprite content.
/// Returns a new `Sprite` with the color rectangle as its visual content.
///
/// Example:
///
/// ```moonbit nocheck
/// let rect = @sprite.ColorRect::new(Vec2D(100.0, 50.0), "blue")
/// let sprite = @sprite.Sprite::from_color_rect(rect)
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_color_rect(color_rect : ColorRect) -> Sprite {
  { sprite_type: SpriteType::ColorRect(color_rect), visible: true }
}

///|
/// Creates a sprite from a color circle.
///
/// Parameters:
///
/// * `color_circle` : The `ColorCircle` to use as the sprite content.
/// Returns a new `Sprite` with the color circle as its visual content.
///
/// Example:
///
/// ```moonbit nocheck
/// let circle = @sprite.ColorCircle::new(20.0, "green")
/// let sprite = @sprite.Sprite::from_color_circle(circle)
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_color_circle(color_circle : ColorCircle) -> Sprite {
  { sprite_type: SpriteType::ColorCircle(color_circle), visible: true }
}

///|
/// Renders all sprites in the game world through the provided backend, handling
/// world-space and UI-space positioning.
///
/// Parameters:
///
/// * `backend` : The rendering backend used to draw sprites to the screen.
///
/// Panics if an entity has a sprite but no position component.
///
pub fn render_sprite_system(delta : Double) -> Unit {
  let sprite_entries = sprites()
    .to_array()
    .filter(fn(pair) { pair.0.is_alive() && @visibility.is_visible(pair.0) })
  let render_alpha = @system.get_render_alpha()
  let camera_view = active_camera2d_view(render_alpha)
  sprite_entries.sort_by(fn(sprite1, sprite2) {
    let pos1 = @transform.sample_global_translation(sprite1.0, render_alpha)
    let pos2 = @transform.sample_global_translation(sprite2.0, render_alpha)
    if pos1.z < pos2.z {
      -1
    } else if pos1.z > pos2.z {
      1
    } else {
      0
    }
  })
  for sprite in sprite_entries {
    let e = sprite.0
    let sprite = sprite.1
    guard @transform.global_transforms().contains(e) ||
      @transform.transforms().contains(e) else {
      continue
    }
    let sampled_global = sampled_entity_global_transform(e, render_alpha)
    let sampled = sampled_global.compute_transform()
    let raw_pos = @math.Vec2D(sampled.translation.x, sampled.translation.y)
    let screen_pos = match camera_view {
      Some((camera, camera_global, projection)) =>
        camera.world_to_viewport(camera_global, projection, raw_pos)
      None => @system.scale_vec2(raw_pos)
    }
    let sprite_transform = sprite_screen_transform(sampled_global, camera_view)
    match sprite.sprite_type {
      SpriteType::Picture(picture) if sprite.visible =>
        render_picture(
          picture,
          screen_pos,
          false,
          external_transform=sprite_transform,
        )
      SpriteType::Animation(anime, frame~) as animation_sprite => {
        let new_frame = render_animation(
          anime,
          frame,
          screen_pos,
          false,
          sprite.visible,
          delta,
          external_transform=sprite_transform,
        )
        animation_sprite.frame = new_frame
      }
      SpriteType::Text(text) if sprite.visible =>
        render_text(
          text,
          screen_pos,
          false,
          external_transform=sprite_transform,
        )
      SpriteType::ColorRect(color_rect) if sprite.visible =>
        render_color_rect(
          color_rect,
          screen_pos,
          false,
          external_transform=sprite_transform,
        )
      SpriteType::ColorCircle(color_circle) if sprite.visible =>
        render_color_circle(
          color_circle,
          screen_pos,
          false,
          external_transform=sprite_transform,
        )
      _ => ()
    }
  }
}

///|
fn sampled_entity_global_transform(
  entity : @entity.Entity,
  alpha : Double,
) -> @transform.GlobalTransform {
  if @transform.global_transforms().contains(entity) ||
    @transform.previous_global_transforms().contains(entity) {
    @transform.sample_global_transform(entity, alpha)
  } else {
    @transform.GlobalTransform::from_transform(
      @transform.transforms().get(entity).unwrap_or_default(),
    )
  }
}

///|
fn active_camera2d_view(
  alpha : Double,
) -> (
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
    let global = sampled_entity_global_transform(entity, alpha)
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
