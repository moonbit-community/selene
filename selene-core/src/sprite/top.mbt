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
/// Visual element that can be rendered in the game world, containing either a
/// picture, animation, or text along with depth ordering information.
///
/// Fields:
///
/// * `sprite_type` : The visual content type (picture, animation, or text) that
///   this sprite represents.
/// * `zindex` : The depth layer for rendering order, where higher values are
///   drawn on top of lower values.
///
/// Example:
///
/// ```notest
/// // Create an animation sprite
/// let animation = @sprite.Animation::new("player_walk.png", max_frame=4, height=32.0, width=32.0)
/// let sprite = @sprite.Sprite::new_animation(animation, zindex=1)
///
/// // Create a picture sprite  
/// let picture = @sprite.Picture::new(@math.Vec2D::new(64.0, 64.0), "background.png")
/// let bg_sprite = @sprite.Sprite::new_picture(picture, zindex=0)
///
/// // Create a text sprite
/// let text = @sprite.Text::new("Hello World!")
/// let text_sprite = @sprite.Sprite::new_text(text, zindex=2)
///
/// // Access sprite properties
/// inspect(sprite.zindex, content="1")
/// match sprite.sprite_type {
///   Animation(anim) => println("Animation sprite")
///   Picture(pic) => println("Picture sprite") 
///   Text(txt) => println("Text sprite")
/// }
/// ```
///
pub(all) struct Sprite {
  sprite_type : SpriteType
  zindex : Int
}

///|
pub let sprites : Map[@system.Entity, Sprite] = Map::new()

///|
pub enum SpriteType {
  Picture(Picture)
  Animation(Animation)
  Text(Text)
}

///| Make an animation sprite with default animation and zindex.
pub fn Sprite::new_animation(animation : Animation, zindex : Int) -> Sprite {
  { sprite_type: SpriteType::Animation(animation), zindex }
}

///|
pub fn Sprite::new_picture(picture : Picture, zindex : Int) -> Sprite {
  { sprite_type: SpriteType::Picture(picture), zindex }
}

///|
pub fn Sprite::new_text(text : Text, zindex : Int) -> Sprite {
  { sprite_type: SpriteType::Text(text), zindex }
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
      pos.inner() - @camera.camera.position
    } else {
      pos.inner()
    }
    match sprite.sprite_type {
      SpriteType::Picture(picture) => render_picture(backend, picture, pos)
      SpriteType::Animation(anime) => render_animation(backend, anime, pos)
      SpriteType::Text(text) => render_text(backend, text, pos)
    }
  }
}
