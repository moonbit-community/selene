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
/// Configuration for sprite animations with frame sequences and playback
/// settings.
///
/// The `Animation` struct is abstract - users cannot directly construct or
/// access its fields. Instead, use the provided constructor functions and
/// methods to create and manipulate animations.
///
/// Example:
///
/// ```moonbit
/// // Create frames from a sprite atlas
/// let frames = @sprite.frames_from_atlas(
///   "player_walk.png",
///   8,
///   width=32.0,
///   height=32.0
/// )
///
/// // Create an animation with looping enabled
/// let walk_animation = @sprite.Animation::new(
///   frames,
///   loop_=true,
///   fps=12.0,
///   transform=@math.Transform::new()
/// )
/// ignore(walk_animation)
///
/// // Create a single-frame static sprite
/// let static_sprite = @sprite.Animation::single_frame(
///   "ui/button.png",
///   @math.Vec2D(100.0, 50.0)
/// )
/// ignore(static_sprite)
/// ```
///
pub struct Animation {
  frames : Array[AnimationFrame]
  transform : @math.Transform
  loop_ : Bool
  fps : Double
  id : Int
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
/// ```moonbit
/// let frame = @sprite.AnimationFrame::{
///   sprite_path: "characters/player.png",
///   size: @math.Vec2D(32.0, 32.0),
///   offset: @math.Vec2D(64.0, 0.0)
/// }
/// inspect(frame.sprite_path, content="characters/player.png")
/// inspect(frame.size[X], content="32")
/// inspect(frame.offset[X], content="64")
/// ```
///
pub(all) struct AnimationFrame {
  sprite_path : String
  size : @math.Vec2D
  offset : @math.Vec2D
}

///|
/// Creates a new animation with the specified frames and playback settings.
///
/// Parameters:
///
/// * `frames` : An array of animation frames that define the sprite sequence.
///   Each frame contains sprite sheet coordinates and dimensions.
/// * `loop_` : Whether the animation should loop continuously when it reaches
///   the end (default: `false`).
/// * `fps` : The playback speed in frames per second, controlling how fast the
///   animation advances (default: `1.0`).
/// * `transform` : The transformation matrix for position, rotation, and scale
///   applied to the entire animation (default: identity transform).
///
/// Returns a new `Animation` instance with a unique identifier.
///
/// Panics if the `frames` array is empty.
///
/// Example:
///
/// ```moonbit
/// // Create frames from a sprite atlas
/// let frames = @sprite.frames_from_atlas(
///   "player_walk.png",
///   8,
///   width=32.0,
///   height=32.0
/// )
///
/// // Create a looping walk animation at 12 FPS
/// let walk_animation = @sprite.Animation::new(
///   frames,
///   loop_=true,
///   fps=12.0,
///   transform=@math.Transform::new()
/// )
/// ignore(walk_animation)
/// ```
///
pub fn Animation::new(
  frames : Array[AnimationFrame],
  loop_? : Bool = false,
  fps? : Double = 1.0,
  transform? : @math.Transform = @math.Transform::new(),
) -> Animation {
  let max_frame = frames.length().reinterpret_as_uint()
  if max_frame == 0 {
    abort("Animation must have at least one frame")
  }
  { frames, transform, loop_, fps, id: generate_animation() }
}

///|
let animation_generator : Ref[Int] = Ref::new(0)

///|
fn generate_animation() -> Int {
  let id = animation_generator.val
  animation_generator.val += 1
  id
}

///|
/// Creates a single-frame animation from a static sprite image.
///
/// Parameters:
///
/// * `sprite_path` : The file path to the sprite image.
/// * `size` : The width and height of the sprite in pixels.
/// * `transform` : The transformation matrix for position, rotation, and scale
///   applied to the sprite (default: identity transform).
/// * `offset` : The pixel offset within the sprite image where the frame is
///   located (default: `@math.Vec2D(0, 0)`).
///
/// Returns a new `Animation` instance configured as a static sprite with no
/// frame advancement.
///
/// Example:
///
/// ```moonbit
/// // Create a static button sprite
/// let button = @sprite.Animation::single_frame(
///   "ui/button.png",
///   @math.Vec2D(100.0, 50.0)
/// )
/// ignore(button)
///
/// // Create a static sprite with custom positioning
/// let icon = @sprite.Animation::single_frame(
///   "icons/health.png", 
///   @math.Vec2D(32.0, 32.0),
///   transform=@math.Transform::from_translation(10.0, 20.0),
///   offset=@math.Vec2D(16.0, 16.0)
/// )
/// ignore(icon)
/// ```
///
pub fn Animation::single_frame(
  sprite_path : String,
  size : @math.Vec2D,
  transform? : @math.Transform = @math.Transform::new(),
  offset? : @math.Vec2D = @math.Vec2D(0, 0),
) -> Animation {
  Animation::new(
    [{ sprite_path, size, offset }],
    transform~,
    loop_=false,
    fps=0.0,
  )
}

///|
/// Creates an array of animation frames from a sprite atlas by dividing it into
/// equally-sized rectangular frames arranged horizontally.
///
/// Parameters:
///
/// * `sprite_path` : The file path to the sprite sheet image containing all
///   animation frames.
/// * `frame_count` : The total number of frames to extract from the sprite
///   atlas.
/// * `width` : The width of each individual frame in pixels.
/// * `height` : The height of each individual frame in pixels.
/// * `offset` : The starting position within the sprite sheet where frame
///   extraction begins (default: `@math.Vec2D(0, 0)`).
/// * `space_x` : The horizontal spacing between frames in pixels, useful for
///   sprite sheets with padding between frames (default: `0.0`).
///
/// Returns an array of `AnimationFrame` objects, each containing the sprite
/// path, frame dimensions, and calculated offset position within the sprite
/// sheet.
///
/// Example:
///
/// ```moonbit
/// // Extract 8 frames from a player walk animation sprite sheet
/// let walk_frames = @sprite.frames_from_atlas(
///   "characters/player_walk.png",
///   8,
///   width=32.0,
///   height=32.0
/// )
/// ignore(walk_frames)
///
/// // Extract frames with custom starting offset and spacing
/// let ui_frames = @sprite.frames_from_atlas(
///   "ui/buttons.png", 
///   4,
///   width=64.0,
///   height=24.0,
///   offset=@math.Vec2D(10.0, 5.0),
///   space_x=2.0
/// )
/// ignore(ui_frames)
/// ```
///
pub fn frames_from_atlas(
  sprite_path : String,
  frame_count : Int,
  width~ : Double,
  height~ : Double,
  offset? : @math.Vec2D = @math.Vec2D(0, 0),
  space_x? : Double = 0.0,
) -> Array[AnimationFrame] {
  let frames = []
  for i in 0..<frame_count {
    let x = offset[X] + i.to_double() * (width + space_x)
    frames.push({
      sprite_path,
      size: @math.Vec2D(width, height),
      offset: offset.update(X, x),
    })
  }
  frames
}

///|
/// Starts or updates an animation for the specified entity with customizable
/// playback settings.
///
/// Parameters:
///
/// * `entity` : The entity to attach the animation to.
/// * `animation` : The animation configuration containing frames, timing, and
///   transform data.
/// * `from_start` : Whether to restart the animation from the first frame, even
///   if the same animation is already playing (default: `false`).
/// * `loop_` : Whether the animation should loop continuously. If not
///   specified, uses the animation's default loop setting.
/// * `rate` : The playback speed in frames per second. If not specified, uses
///   the animation's default FPS.
/// * `transform` : The transformation matrix for position, rotation, and scale.
///   If not specified, uses the animation's default transform.
///
/// Panics if the entity does not have an existing sprite component with an
/// animation.
///
/// Example:
///
/// ```moonbit skip
/// let entity = @entity.Entity::new()
/// defer entity.destroy()
/// // Create an animation
/// let frames = @sprite.frames_from_atlas(
///   "player_walk.png",
///   8,
///   width=32.0,
///   height=32.0
/// )
/// let walk_animation = @sprite.Animation::new(
///   frames,
///   loop_=true,
///   fps=12.0
/// )
///
/// // Play the animation on an entity
/// @sprite.play_animation(entity, walk_animation)
///
/// // Play with custom settings
/// @sprite.play_animation(
///   entity,
///   walk_animation,
///   from_start=true,
///   rate=24.0,
///   transform=@math.Transform::from_translation(100.0, 200.0)
/// )
/// ```
///
pub fn play_animation(
  entity : @entity.Entity,
  animation : Animation,
  from_start? : Bool = false,
  loop_? : Bool,
  rate? : Double,
  transform? : @math.Transform,
  // backward~ : Bool = false,
) -> Unit {
  guard sprites.get(entity)
    is Some(
      {
        sprite_type: Animation(current_anime, frame=current_frame),
        zindex,
        visible,
        offset,
      }
    )
  let loop_ = loop_.unwrap_or(animation.loop_)
  let rate = rate.unwrap_or(animation.fps)
  let transform = transform.unwrap_or(animation.transform)
  let frame = if !from_start && animation.id == current_anime.id {
    current_frame
  } else {
    0.0
  }
  let new_anime = {
    frames: animation.frames,
    transform,
    loop_,
    fps: rate,
    id: animation.id,
  }
  sprites.set(entity, {
    sprite_type: SpriteType::Animation(new_anime, frame~),
    zindex,
    visible,
    offset,
  })
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
  animation : Animation,
  current_frame : Double,
  pos : @math.Vec2D,
  visible : Bool,
  delta : Double,
) -> Double {
  let frame = animation.frames[current_frame.to_int()]
  if visible {
    @backend.draw_sprite(
      sprite_path=frame.sprite_path,
      x=pos[X],
      y=pos[Y],
      offset_x=frame.offset[X],
      offset_y=frame.offset[Y],
      width=frame.size[X],
      height=frame.size[Y],
      transform=animation.transform,
    )
  }
  let mut new_frame = current_frame + animation.fps * delta
  if new_frame.to_int() >= animation.frames.length() {
    if animation.loop_ {
      new_frame = 0
    } else {
      new_frame = animation.frames.length().to_double() - 0.01
    }
  }
  new_frame
}

///|
/// Checks whether an animation for the specified entity has finished playing.
///
/// Parameters:
///
/// * `entity` : The entity to check for animation completion status.
///
/// Returns `true` if the entity has no animation component, or if the animation
/// is non-looping and has reached its final frame. Returns `false` if the
/// animation is still playing or if it's a looping animation.
///
/// Example:
///
/// ```moonbit skip
/// let entity = @entity.Entity::new()
/// defer entity.destroy()
/// // Create a non-looping animation
/// let frames = @sprite.frames_from_atlas(
///   "explosion.png",
///   6,
///   width=64.0,
///   height=64.0
/// )
/// let explosion_animation = @sprite.Animation::new(
///   frames,
///   loop_=false,
///   fps=12.0
/// )
///
/// // Play the animation on an entity
/// @sprite.play_animation(entity, explosion_animation)
///
/// // Check if the explosion animation has finished
/// inspect(@sprite.is_animation_finished(entity)) 
/// ```
///
pub fn is_animation_finished(entity : @entity.Entity) -> Bool {
  guard sprites.get(entity)
    is Some({ sprite_type: Animation(anime, frame~), .. }) else {
    true
  }
  if anime.loop_ {
    return false
  }
  frame >= anime.frames.length().to_double() - 0.01
}
