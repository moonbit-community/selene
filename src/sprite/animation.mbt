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
let animation_id_generator : Ref[UInt] = Ref::new(0)

///|
pub struct Animation {
  sprite_path : String
  max_frame : UInt
  height : Double
  width : Double
  offset : @math.Vec2D
  loop_ : Bool
  mut frame : UInt
  priv id : UInt
}

///|
pub fn play_animation(
  animation : Animation,
  start_frame~ : UInt = 0,
  // rate~ : Double = 1.0
  // backward~ : Bool = false,
) -> Unit {
  ...
}

///|
pub fn Animation::new(
  sprite_path : String,
  max_frame~ : UInt,
  height~ : Double,
  width~ : Double,
  loop_~ : Bool = false,
  offset~ : @math.Vec2D = @math.Vec2D::new(0, 0),
  start_frame~ : UInt = 0,
) -> Animation {
  let id = animation_id_generator.val
  animation_id_generator.val += 1
  {
    sprite_path,
    max_frame,
    height,
    width,
    offset,
    frame: start_frame,
    id,
    loop_,
  }
}

///| Returns true if the animation is ending
fn render_animation(
  backend : &@system.Backend,
  animation : Animation,
  pos : @math.Vec2D,
) -> Bool {
  backend.draw_sprite(
    animation.sprite_path,
    x=pos.x,
    y=pos.y,
    offset_x=animation.offset.x + animation.width * animation.frame.to_double(),
    offset_y=animation.offset.y,
    width=animation.width,
    height=animation.height,
  )
  animation.frame += 1
  if animation.frame >= animation.max_frame {
    if animation.loop_ {
      animation.frame = 0
      return false
    } else {
      return true
    }
  }
  false
}
