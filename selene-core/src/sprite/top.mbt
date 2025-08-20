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
/// let sprite = @sprite.Sprite::new_picture(picture, zindex=5, offset=@math.Vec2D::new(10.0, 20.0))
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
/// Colored rectangle sprite for rendering solid color rectangles.
///
/// Fields:
///
/// * `size` : Dimensions of the rectangle as width and height.
/// * `color` : CSS color string (e.g., "red", "#ff0000", "rgb(255,0,0)").
///
/// Example:
///
/// ```notest
/// let color_rect = @sprite.ColorRect::new(@math.Vec2D::new(50.0, 30.0), "blue")
/// let sprite = @sprite.Sprite::new_color_rect(color_rect, zindex=5)
/// ```
///
pub(all) struct ColorRect {
  size : @math.Vec2D
  color : String
}

///|
pub let sprites : Map[@system.Entity, Sprite] = Map::new()

///|
pub enum SpriteType {
  Picture(Picture)
  Animation(Animation, mut frame~ : Double)
  Text(Text)
  ColorRect(ColorRect)
}

///| Make an animation sprite with default animation and zindex.
pub fn Sprite::new_animation(
  animation : Animation,
  zindex : Int,
  offset~ : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  {
    sprite_type: SpriteType::Animation(animation, frame=0),
    zindex,
    offset,
    visible: true,
  }
}

///|
pub fn Sprite::new_picture(
  picture : Picture,
  zindex : Int,
  offset~ : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  { sprite_type: SpriteType::Picture(picture), zindex, offset, visible: true }
}

///|
pub fn Sprite::new_text(
  text : Text,
  zindex : Int,
  offset~ : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  { sprite_type: SpriteType::Text(text), zindex, offset, visible: true }
}

///|
pub fn Sprite::new_color_rect(
  color_rect : ColorRect,
  zindex : Int,
  offset~ : @math.Vec2D = @math.Vec2D::zero(),
) -> Sprite {
  {
    sprite_type: SpriteType::ColorRect(color_rect),
    zindex,
    offset,
    visible: true,
  }
}

///| Creates a new ColorRect with the specified size and color.
pub fn ColorRect::new(size : @math.Vec2D, color : String) -> ColorRect {
  { size, color }
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
pub fn render_sprite_system(backend : &@system.Backend) -> Unit {
  let sprites = sprites
    .to_array()
    .filter(fn(pair) { @system.all_entities.contains(pair.0) })
  sprites.sort_by_key(fn(pair) { pair.1.zindex })
  for sprite in sprites {
    let e = sprite.0
    let sprite = sprite.1
    guard @position.positions.get(e) is Some(pos) else { continue }
    let pos = if @ui.uis.get(e) is None {
      pos.0 - @camera.camera.position
    } else {
      pos.0
    }
    if sprite.visible {
      match sprite.sprite_type {
        SpriteType::Picture(picture) =>
          render_picture(backend, picture, pos + sprite.offset)
        SpriteType::Animation(anime, frame~) as animation_sprite => {
          let new_frame = render_animation(
            backend,
            anime,
            frame,
            pos + sprite.offset,
          )
          animation_sprite.frame = new_frame
        }
        SpriteType::Text(text) =>
          render_text(backend, text, pos + sprite.offset)
        SpriteType::ColorRect(color_rect) =>
          render_color_rect(backend, color_rect, pos + sprite.offset)
      }
    }
  }
}

///| Renders a color rectangle sprite to the screen at the specified position.
fn render_color_rect(
  backend : &@system.Backend,
  color_rect : ColorRect,
  pos : @math.Vec2D,
) -> Unit {
  backend.draw_color_rect(
    x=pos[X],
    y=pos[Y],
    width=color_rect.size[X],
    height=color_rect.size[Y],
    color=color_rect.color,
  )
}
