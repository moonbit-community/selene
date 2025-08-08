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
pub(all) struct Sprite {
  sprite_type : SpriteType
  zindex : Int
}

///|
pub let sprites : Map[@system.Entity, Sprite] = Map::new()

///|
pub enum SpriteType {
  Picture(Picture)
  Animation(Animation, mut current~ : Animation) // Default animation and current animation
  Text(Text)
}

///| Make an animation sprite with default animation and zindex.
pub fn Sprite::new_animation(animation : Animation, zindex : Int) -> Sprite {
  { sprite_type: SpriteType::Animation(animation, current=animation), zindex }
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
pub fn render_sprite_system(backend : &@system.Backend) -> Unit {
  let sprites = sprites
    .to_array()
    .filter(fn(pair) { @system.all_entities.contains(pair.0) })
  sprites.sort_by_key(fn(pair) { pair.1.zindex })
  for sprite in sprites {
    let e = sprite.0
    let sprite = sprite.1
    guard @position.positions.get(e) is Some(pos) else { continue }
    let pos = if @camera.uis.get(e) is None {
      pos.inner() - @camera.camera.position
    } else {
      pos.inner()
    }
    match sprite.sprite_type {
      SpriteType::Picture(picture) => render_picture(backend, picture, pos)
      SpriteType::Animation(default, current~) as anime =>
        if render_animation(backend, current, pos) {
          anime.current = default
          anime.current.frame = 0
        }
      SpriteType::Text(text) => render_text(backend, text, pos)
    }
  }
}
