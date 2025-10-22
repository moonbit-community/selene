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
struct Style {
  size_plan : SizePlan // The plan to calculate the size of this entity in the UI world
  flex : Flex // The flexing direction for its child entities
  h_padding : Double // The flexing paddings
  v_padding : Double
  h_offset : Double // The offset of this entity respective to its parent
  v_offset : Double
}

///|
pub fn Style::new(
  size_plan? : SizePlan = SizePlan::FromSprite,
  flex? : Flex = Flex::Overlap,
  h_padding? : Double = 0.0,
  v_padding? : Double = 0.0,
  h_offset? : Double = 0.0,
  v_offset? : Double = 0.0,
) -> Style {
  { size_plan, flex, h_padding, v_padding, h_offset, v_offset }
}

///|
pub let styles : Map[@entity.Entity, Style] = Map::new()

///|
pub fn style_system(_delta : Double) -> Unit {
  for e in @entity.get_roots() {
    guard e.is_alive() else { continue }
    arrange(e, @math.Vec2D::zero()) |> ignore
  }
}

///|
/// Return current size
fn arrange(entity : @entity.Entity, offset : @math.Vec2D) -> @math.Vec2D {
  guard styles.get(entity) is Some(style) else { return @math.Vec2D::zero() }
  if entity.is_child() {
    entity.set_offset(offset + Vec2D(style.h_offset, style.v_offset))
  }
  let children = entity.get_children()
  let mut cursor = @math.Vec2D(style.h_padding, style.v_padding)
  let mut max_width = 0.0
  let mut max_height = 0.0
  for c in children {
    let size = arrange(c, cursor)
    cursor = match style.flex {
      Horizontal => cursor.update(X, cursor[X] + size[X] + style.h_padding)
      Overlap => cursor
      Vertical => cursor.update(Y, cursor[Y] + size[Y] + style.v_padding)
    }
    max_width = @cmp.maximum(max_width, size[X])
    max_height = @cmp.maximum(max_height, size[Y])
  }
  match style.size_plan {
    FromSprite => {
      guard @sprite.sprites.get(entity) is Some(sprite)
      match sprite.sprite_type {
        Picture(picture) => picture.transform.apply_to_vec2d(picture.size)
        Text(_text) => default_text_size()
        Animation(anime, ..) =>
          anime.transform.apply_to_vec2d(anime.frames[0].size)
        ColorRect(rect) => rect.size
      }
    }
    Sized(s) => s
    FromChildren => Vec2D(max_width, max_height)
    FromShape => {
      guard @collision.shapes.get(entity) is Some(shape)
      match shape {
        Rect(size~, ..) => size
      }
    }
  }
}

///|
/// FIXME: calculate size of textboxes 
fn default_text_size() -> @math.Vec2D {
  Vec2D(48, 24)
}
