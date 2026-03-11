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
/// Visual element that can be rendered to the screen with depth ordering and
/// positioning.
///
/// Fields:
///
/// * `sprite_type` : The visual content of the sprite (picture, animation, or
///   text).
/// * `zindex` : Rendering order priority, where higher values render on top of
///   lower values.
/// * `visible` : Whether the sprite should be rendered to the screen.
/// * `offset` : Position offset applied relative to the entity's position.
///
/// Examples:
///
/// ```notest
/// // Create an animation sprite
/// let animation = @sprite.Animation::new([frame1, frame2])
/// let sprite = @sprite.Sprite::new_animation(animation, zindex=10)
/// sprite.visible = false // Hide the sprite
///
/// // Create a picture sprite with offset
/// let picture = @sprite.Picture::new(size, "path/to/image.png")
/// let sprite = @sprite.Sprite::new_picture(picture, zindex=5, offset=@math.Vec2D(10.0, 20.0))
/// inspect(sprite.zindex, content="5")
///
/// // Create a text sprite
/// let text = @sprite.Text::new("Hello World", color="red")
/// let sprite = @sprite.Sprite::new_text(text, zindex=1)
/// inspect(sprite.offset.x, content="0.0") // Default offset is zero
/// ```
///
pub(all) struct Sprite {
  sprite_type : SpriteType
  zindex : Int
  mut visible : Bool
  offset : @math.Vec2D
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
/// Make an animation sprite with default animation and zindex.
pub fn Sprite::from_animation(
  animation : Animation,
  zindex : Int,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  {
    sprite_type: SpriteType::Animation(animation, frame=0),
    zindex,
    offset,
    visible: true,
  }
}

///|
/// Creates a sprite from a picture with specified rendering priority and
/// position offset.
///
/// Parameters:
///
/// * `picture` : The `Picture` object containing the image data and dimensions
///   to be rendered.
/// * `zindex` : Rendering order priority, where higher values render on top of
///   lower values.
/// * `offset` : Optional position offset applied relative to the entity's
///   position. Defaults to zero vector if not specified.
///
/// Returns a new `Sprite` with the picture as its visual content, initially set
/// to visible.
///
pub fn Sprite::from_picture(
  picture : Picture,
  zindex : Int,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  { sprite_type: SpriteType::Picture(picture), zindex, offset, visible: true }
}

///|
/// Creates a sprite from text content.
///
/// Parameters:
///
/// * `text` : The `Text` object containing the text content, styling, and
///   formatting information.
/// * `zindex` : Rendering order priority. Higher values render on top of lower
///   values.
/// * `offset` : Optional position offset relative to the entity's position.
///   Defaults to zero vector if not specified.
///
/// Returns a new `Sprite` with the text as its visual content, initially
/// visible.
///
/// Example:
///
/// ```moonbit nocheck
/// let text = @sprite.Text::new("Hello World", color="red")
/// let sprite = @sprite.Sprite::from_text(text, 1)
/// inspect(sprite.zindex, content="1")
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_text(
  text : Text,
  zindex : Int,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  { sprite_type: SpriteType::Text(text), zindex, offset, visible: true }
}

///|
/// Creates a sprite from a color rectangle.
///
/// Parameters:
///
/// * `color_rect` : The `ColorRect` to use as the sprite content.
/// * `zindex` : Rendering order priority. Higher values render on top of lower
///   values.
/// * `offset` : Optional position offset relative to the entity's position.
///   Defaults to zero vector if not specified.
///
/// Returns a new `Sprite` with the color rectangle as its visual content.
///
/// Example:
///
/// ```moonbit nocheck
/// let rect = @sprite.ColorRect::new(Vec2D(100.0, 50.0), "blue")
/// let sprite = @sprite.Sprite::from_color_rect(rect, 3)
/// inspect(sprite.zindex, content="3")
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_color_rect(
  color_rect : ColorRect,
  zindex : Int,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  {
    sprite_type: SpriteType::ColorRect(color_rect),
    zindex,
    offset,
    visible: true,
  }
}

///|
/// Creates a sprite from a color circle.
///
/// Parameters:
///
/// * `color_circle` : The `ColorCircle` to use as the sprite content.
/// * `zindex` : Rendering order priority. Higher values render on top.
/// * `offset` : Optional position offset relative to the entity's position.
///   Defaults to zero vector if not specified.
///
/// Returns a new `Sprite` with the color circle as its visual content.
///
/// Example:
///
/// ```moonbit nocheck
/// let circle = @sprite.ColorCircle::new(20.0, "green")
/// let sprite = @sprite.Sprite::from_color_circle(circle, 5)
/// inspect(sprite.zindex, content="5")
/// inspect(sprite.visible, content="true")
/// ```
///
pub fn Sprite::from_color_circle(
  color_circle : ColorCircle,
  zindex : Int,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  {
    sprite_type: SpriteType::ColorCircle(color_circle),
    zindex,
    offset,
    visible: true,
  }
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
  let camera_pos = @camera.sample_position(@system.get_render_alpha())
  sprite_entries.sort_by(fn(sprite1, sprite2) {
    if sprite1.1.zindex < sprite2.1.zindex {
      -1
    } else if sprite1.1.zindex > sprite2.1.zindex {
      1
    } else {
      guard @transform.positions().get(sprite1.0) is Some(pos1) else {
        return 0
      }
      guard @transform.positions().get(sprite2.0) is Some(pos2) else {
        return 0
      }
      if pos1.0[Y] < pos2.0[Y] {
        -1
      } else if pos1.0[Y] > pos2.0[Y] {
        1
      } else {
        0
      }
    }
  })
  for sprite in sprite_entries {
    let e = sprite.0
    let sprite = sprite.1
    guard @transform.positions().contains(e) else { continue }
    let raw_pos = @transform.sample_position(e, @system.get_render_alpha()) +
      sprite.offset
    let screen_pos = @system.world_to_screen(raw_pos, camera_pos)
    match sprite.sprite_type {
      SpriteType::Picture(picture) if sprite.visible =>
        render_picture(picture, screen_pos, true)
      SpriteType::Animation(anime, frame~) as animation_sprite => {
        let new_frame = render_animation(
          anime,
          frame,
          screen_pos,
          true,
          sprite.visible,
          delta,
        )
        animation_sprite.frame = new_frame
      }
      SpriteType::Text(text) if sprite.visible =>
        render_text(text, screen_pos, true)
      SpriteType::ColorRect(color_rect) if sprite.visible =>
        render_color_rect(color_rect, screen_pos, true)
      SpriteType::ColorCircle(color_circle) if sprite.visible =>
        render_color_circle(color_circle, screen_pos, true)
      _ => ()
    }
  }
}
