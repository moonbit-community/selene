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
  mut transform : @math.Transform
  mut loop_ : Bool
  mut rate : Double
  mut frame : Double
  priv id : UInt
}

///| Play a new animation; if the animation is already playing, it will 
/// reset to the start frame; switch to the default animation when the
/// animation ends.
pub fn play_animation(
  entity : @system.Entity,
  animation : Animation,
  from_start~ : Bool = false,
  loop_~ : Bool? = None,
  rate~ : Double? = None,
  transform~ : @math.Transform? = None,
  // backward~ : Bool = false,
) -> Unit {
  guard sprites.get(entity)
    is Some({ sprite_type: Animation(default, current~) as anime, .. })
  if loop_ is Some(loop_) {
    animation.loop_ = loop_
  }
  if rate is Some(rate) {
    animation.rate = rate
  }
  if transform is Some(transform) {
    animation.transform = transform
  }
  if current.id == animation.id {
    if from_start {
      anime.current.frame = 0
    }
    return // Already playing this animation
  }
  if default.id == animation.id {
    anime.current = default
    if from_start {
      anime.current.frame = 0
    }
    return // Already playing the default animation
  }
  anime.current = animation
  anime.current.frame = 0
}

///|
pub fn Animation::new(
  sprite_path : String,
  max_frame~ : UInt,
  height~ : Double,
  width~ : Double,
  transform~ : @math.Transform = @math.Transform::new(),
  loop_~ : Bool = false,
  rate~ : Double = 0.2,
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
    frame: start_frame.to_double(),
    id,
    loop_,
    rate,
    transform,
  }
}

///| Returns true if the animation is ending.
fn render_animation(
  backend : &@system.Backend,
  animation : Animation,
  pos : @math.Vec2D,
) -> Bool {
  backend.draw_sprite(
    animation.sprite_path,
    x=pos.x,
    y=pos.y,
    offset_x=animation.offset.x +
      animation.width * animation.frame.to_uint().to_double(),
    offset_y=animation.offset.y,
    width=animation.width,
    height=animation.height,
    transform=animation.transform,
  )
  animation.frame += animation.rate
  if animation.frame.to_uint() >= animation.max_frame {
    if animation.loop_ {
      animation.frame = 0
      return false
    } else {
      return true
    }
  }
  false
}
