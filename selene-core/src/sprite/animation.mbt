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
/// Sprite animation configuration with frame-based playback control.
///
/// Fields:
///
/// * `sprite_path` : File path to the sprite sheet image containing animation
///   frames.
/// * `max_frame` : Total number of frames in the animation sequence.
/// * `height` : Height of each frame in pixels.
/// * `width` : Width of each frame in pixels.
/// * `offset` : Pixel offset within the sprite sheet where animation frames
///   start.
/// * `transform` : Transformation matrix applied to the animation (position,
///   rotation, scale).
/// * `loop_` : Whether the animation loops continuously when reaching the end.
/// * `rate` : Animation playback speed (frame advancement per update cycle).
/// * `frame` : Current frame position in the animation sequence.
///
/// Example:
///
/// ```notest
/// let animation = @sprite.Animation::new(
///   "characters/player.png",
///   max_frame=8,
///   height=32.0,
///   width=32.0,
///   rate=0.1,
///   loop_=true
/// )
/// animation.transform = @math.Transform::new().translate(100.0, 50.0)
/// animation.rate = 0.15
/// ```
///
pub(all) struct Animation {
  sprite_path : String
  max_frame : UInt
  height : Double
  width : Double
  offset : @math.Vec2D
  mut transform : @math.Transform
  mut loop_ : Bool
  mut rate : Double
  mut frame : Double
}

///|
/// Plays an animation on an entity, with options to control playback behavior.
///
/// Parameters:
///
/// * `entity` : The entity to attach the animation to.
/// * `animation` : The animation configuration to play.
/// * `from_start` : Whether to restart the animation from the beginning. If
///   `false` and the entity already has an animation playing, the current
///   animation will continue from its current frame (default: `false`).
/// * `loop_` : Optional override for the animation's loop behavior. If
///   provided, updates the animation's loop setting.
/// * `rate` : Optional override for the animation's playback rate. If provided,
///   updates the animation's frame advancement speed.
/// * `transform` : Optional override for the animation's transformation matrix.
///   If provided, updates the animation's position, rotation, and scale.
///
/// Panics if the entity does not already have an animation sprite attached to
/// it.
///
/// Example:
///
/// ```notest
/// let entity = @system.Entity::new()
/// let animation = @sprite.Animation::new(
///   "player.png",
///   max_frame=8,
///   height=32.0,
///   width=32.0
/// )
///
/// // Start a new animation from the beginning
/// @sprite.play_animation(entity, animation, from_start=true, loop_=true, rate=0.15)
///
/// // Continue current animation with modified settings
/// @sprite.play_animation(entity, animation, loop_=false, rate=0.1)
/// ```
///
pub fn play_animation(
  entity : @system.Entity,
  animation : Animation,
  from_start~ : Bool = false,
  loop_? : Bool,
  rate? : Double,
  transform? : @math.Transform,
  // backward~ : Bool = false,
) -> Unit {
  guard sprites.get(entity)
    is Some({ sprite_type: Animation(_current), zindex })
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
/// Creates a new animation with the specified sprite sheet and animation
/// parameters.
///
/// Parameters:
///
/// * `sprite_path` : The file path to the sprite sheet image containing all
///   animation frames.
/// * `max_frame` : The total number of frames in the animation sequence.
/// * `height` : The height of each frame in pixels.
/// * `width` : The width of each frame in pixels.
/// * `transform` : The transformation matrix to apply to the animation
///   (default: identity transform).
/// * `loop_` : Whether the animation should loop continuously when it reaches
///   the end (default: `false`).
/// * `rate` : The speed of animation playback, representing how much the frame
///   advances per update cycle (default: `0.2`).
/// * `offset` : The pixel offset within the sprite sheet where the animation
///   frames start (default: `(0, 0)`).
/// * `start_frame` : The initial frame number to start the animation from
///   (default: `0`).
///
/// Returns a new `Animation` instance configured with the specified parameters.
///
/// Example:
///
/// ```notest
/// let animation = @sprite.Animation::new(
///   "characters/player.png",
///   max_frame=8,
///   height=32.0,
///   width=32.0,
///   rate=0.1,
///   loop_=true
/// )
/// ```
///
pub fn Animation::new(
  sprite_path : String,
  max_frame~ : UInt,
  height~ : Double,
  width~ : Double,
  transform~ : @math.Transform = @math.Transform::new(),
  loop_~ : Bool = false,
  rate~ : Double = 0.2,
  offset~ : @math.Vec2D = @math.Vec2D(0, 0),
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
  }
}

///|
/// Renders an animation frame to the backend and advances the animation to the
/// next frame.
///
/// Parameters:
///
/// * `backend` : The rendering backend used to draw the sprite frame.
/// * `animation` : The animation configuration containing sprite sheet
///   information, current frame state, and playback settings.
/// * `pos` : The screen position where the animation should be rendered.
///
/// Panics if the animation's frame number exceeds the maximum frame count when
/// not looping.
///
fn render_animation(
  backend : &@system.Backend,
  animation : Animation,
  pos : @math.Vec2D,
) -> Unit {
  backend.draw_sprite(
    animation.sprite_path,
    x=pos[X],
    y=pos[Y],
    offset_x=animation.offset[X] +
      animation.width * animation.frame.to_uint().to_double(),
    offset_y=animation.offset[Y],
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
