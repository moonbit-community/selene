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
pub(all) enum SpriteType {
  Picture(Picture)
  Animation(Animation)
}

///|
pub fn render_sprite_system(backend : &@system.Backend) -> Unit {
  let sprites = sprites.to_array()
  sprites.sort_by_key(fn(pair) { pair.1.zindex })
  for sprite in sprites {
    let e = sprite.0
    let sprite = sprite.1
    guard @position.positions.get(e) is Some(pos) else { continue }
    match sprite.sprite_type {
      SpriteType::Picture(picture) =>
        render_picture(backend, picture, pos.inner())
      SpriteType::Animation(animation) =>
        render_animation(backend, animation, pos.inner())
    }
  }
}
