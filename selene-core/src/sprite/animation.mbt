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
pub struct Animation {
  sprite_path : String
  max_frame : UInt
  height : Double
  width : Double
  offset : @math.Vec2D
  priv id : Int
  mut transform : @math.Transform
  mut loop_ : Bool
  mut rate : Double
  mut frame : Double
}

///|
let animation_id_generator : Ref[Int] = Ref::new(0)

///|
fn animation_id_generate() -> Int {
  let id = animation_id_generator.val
  animation_id_generator.val = id + 1
  id
}

///|
fn Animation::clone(self : Animation) -> Animation {
  {
    sprite_path: self.sprite_path,
    max_frame: self.max_frame,
    height: self.height,
    width: self.width,
    offset: self.offset.clone(),
    transform: self.transform.clone(),
    loop_: self.loop_,
    rate: self.rate,
    frame: self.frame,
    id: self.id,
  }
}

///| Play a new animation; if the animation is already playing 
/// and `from_start` is false, the current animation will continue.
pub fn play_animation(
  entity : @system.Entity,
  animation : Animation,
  from_start~ : Bool = false,
  loop_~ : Bool? = None,
  rate~ : Double? = None,
  transform~ : @math.Transform? = None,
  // backward~ : Bool = false,
) -> Unit {
  guard sprites.get(entity) is Some({ sprite_type: Animation(current), zindex })
  let animation = animation.clone()
  if animation.id == current.id {
    animation.frame = current.frame
  }
  if loop_ is Some(loop_) {
    animation.loop_ = loop_
  }
  if rate is Some(rate) {
    animation.rate = rate
  }
  if transform is Some(transform) {
    animation.transform = transform
  }
  if from_start {
    animation.frame = 0
  }
  sprites.set(entity, Sprite::new_animation(animation, zindex))
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
  {
    sprite_path,
    max_frame,
    height,
    width,
    offset,
    frame: start_frame.to_double(),
    loop_,
    rate,
    transform,
    id: animation_id_generate(),
  }
}

///| Returns true if the animation is ending.
fn render_animation(
  backend : &@system.Backend,
  animation : Animation,
  pos : @math.Vec2D,
) -> Unit {
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
    } else {
      animation.frame -= animation.rate
    }
  }
}

///|
pub fn is_animation_finished(entity : @system.Entity) -> Bool {
  guard sprites.get(entity) is Some({ sprite_type: Animation(anime), .. }) else {
    true
  }
  if anime.loop_ {
    return false
  }
  anime.frame >= anime.max_frame.to_double() - anime.rate
}
