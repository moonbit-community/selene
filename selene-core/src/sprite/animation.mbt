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
/// Sprite animation containing a sequence of frames with playback
/// configuration.
///
/// Fields:
///
/// * `frames` : Array of animation frames defining the sprite sequence.
/// * `transform` : Transformation matrix for position, rotation, and scale.
/// * `loop_` : Whether the animation should loop continuously when reaching the
///   end.
/// * `rate` : Frame advancement speed, where higher values increase playback
///   speed.
/// * `frame` : Current frame position in the animation sequence (can be
///   fractional).
///
/// Example:
///
/// ```moonbit
/// let frames = @sprite.frames_from_altas(
///   "player.png", 
///   frame_count=8, 
///   width=32.0, 
///   height=32.0
/// )
/// let animation = @sprite.Animation::new(
///   frames,
///   loop_=true,
///   rate=0.2,
///   transform=@math.Transform::new()
/// )
/// inspect(animation.frames.length(), content="8")
/// inspect(animation.loop_, content="true")
/// inspect(animation.rate, content="0.2")
/// inspect(animation.frame, content="0.0")
/// ```
///
pub(all) struct Animation {
  frames : Array[AnimationFrame]
  mut transform : @math.Transform
  mut loop_ : Bool
  mut rate : Double
  mut frame : Double
}

///|
/// Single frame within an animation sequence, containing sprite sheet
/// coordinates and dimensions.
///
/// Fields:
///
/// * `sprite_path` : File path to the sprite sheet image containing this frame.
/// * `size` : Width and height of the frame in pixels.
/// * `offset` : Pixel offset within the sprite sheet where this frame is
///   located.
///
/// Example:
///
/// ```notest
/// let frame = @sprite.AnimationFrame::{
///   sprite_path: "characters/player.png",
///   size: @math.Vec2D(32.0, 32.0),
///   offset: @math.Vec2D(64.0, 0.0)
/// }
/// inspect(frame.sprite_path, content="characters/player.png")
/// inspect(frame.size[X], content="32.0")
/// inspect(frame.offset[X], content="64.0")
/// ```
///
pub(all) struct AnimationFrame {
  sprite_path : String
  size : @math.Vec2D
  offset : @math.Vec2D
}

///|
/// Creates a new animation from a sequence of frames with configurable playback
/// settings.
///
/// Parameters:
///
/// * `frames` : Array of animation frames that define the sprite sequence for
///   the animation.
/// * `loop_` : Whether the animation should loop continuously when it reaches
///   the end (default: `false`).
/// * `rate` : Frame advancement speed, where higher values increase playback
///   speed (default: `0.2`).
/// * `transform` : Transformation matrix for position, rotation, and scale
///   (default: identity transform).
/// * `start_frame` : Initial frame index to begin the animation from (default:
///   `0`).
///
/// Returns a new `Animation` instance configured with the specified parameters.
///
/// Panics if the `frames` array is empty.
///
/// Example:
///
/// ```notest
/// let frames = @sprite.frames_from_altas(
///   "player.png", 
///   frame_count=8, 
///   width=32.0, 
///   height=32.0
/// )
/// let animation = @sprite.Animation::new(
///   frames,
///   loop_=true,
///   rate=0.15,
///   transform=@math.Transform::new(),
///   start_frame=2
/// )
/// inspect(animation.frames.length(), content="8")
/// inspect(animation.loop_, content="true")
/// inspect(animation.rate, content="0.15")
/// inspect(animation.frame, content="2.0")
/// ```
///
pub fn Animation::new(
  frames : Array[AnimationFrame],
  loop_~ : Bool = false,
  rate~ : Double = 0.2,
  transform~ : @math.Transform = @math.Transform::new(),
  start_frame~ : UInt = 0,
) -> Animation {
  let max_frame = frames.length().reinterpret_as_uint()
  if max_frame == 0 {
    abort("Animation must have at least one frame")
  }
  { frames, transform, loop_, rate, frame: start_frame.to_double() }
}

///|
pub fn Animation::single_frame(
  sprite_path : String,
  size : @math.Vec2D,
  transform~ : @math.Transform = @math.Transform::new(),
  offset~ : @math.Vec2D = @math.Vec2D(0, 0),
) -> Animation {
  {
    frames: [{ sprite_path, size, offset }],
    transform,
    loop_: false,
    rate: 0.0,
    frame: 0.0,
  }
}

///|
/// Generates an array of animation frames from a sprite atlas arranged in a
/// horizontal strip.
///
/// Parameters:
///
/// * `sprite_path` : The file path to the sprite sheet image containing all
///   animation frames.
/// * `frame_count` : The total number of frames to extract from the sprite
///   atlas.
/// * `width` : The width of each individual frame in pixels.
/// * `height` : The height of each individual frame in pixels.
/// * `offset` : The starting offset position within the sprite sheet where
///   frame extraction begins (default: `@math.Vec2D(0, 0)`).
///
/// Returns an array of `AnimationFrame` objects, each representing a single
/// frame from the sprite atlas.
///
/// Example:
///
/// ```notest
/// let frames = @sprite.frames_from_altas(
///   "characters/player_walk.png",
///   frame_count=8,
///   width=32.0,
///   height=32.0,
///   offset=@math.Vec2D(16.0, 0.0)
/// )
/// inspect(frames.length(), content="8")
/// inspect(frames[0].sprite_path, content="characters/player_walk.png")
/// inspect(frames[0].size, content="Vec2D(32.0, 32.0)")
/// inspect(frames[0].offset, content="Vec2D(16.0, 0.0)")
/// inspect(frames[3].offset, content="Vec2D(112.0, 0.0)")
/// ```
///
pub fn frames_from_altas(
  sprite_path : String,
  frame_count : Int,
  width~ : Double,
  height~ : Double,
  offset~ : @math.Vec2D = @math.Vec2D(0, 0),
) -> Array[AnimationFrame] {
  let frames = []
  for i in 0..<frame_count {
    let x = i.to_double() * width
    frames.push({
      sprite_path,
      size: @math.Vec2D(width, height),
      offset: offset.update(X, x),
    })
  }
  frames
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
fn render_animation(
  backend : &@system.Backend,
  animation : Animation,
  pos : @math.Vec2D,
) -> Unit {
  let frame = animation.frames[animation.frame.to_int()]
  backend.draw_sprite(
    frame.sprite_path,
    x=pos[X],
    y=pos[Y],
    offset_x=frame.offset[X],
    offset_y=frame.offset[Y],
    width=frame.size[X],
    height=frame.size[Y],
    transform=animation.transform,
  )
  animation.frame += animation.rate
  if animation.frame.to_int() >= animation.frames.length() {
    if animation.loop_ {
      animation.frame = 0
    } else {
      animation.frame -= animation.rate
    }
  }
}
