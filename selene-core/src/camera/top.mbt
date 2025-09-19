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
priv struct Camera {
  mut position : @math.Vec2D
  mut limit_top : Double?
  mut limit_bottom : Double?
  mut limit_left : Double?
  mut limit_right : Double?
  mut attached_entity : @system.Entity?
  mut offset : @math.Vec2D
  mut follow_x : Bool
  mut follow_y : Bool
}

///|
/// Retrieves the current position of the camera in the 2D coordinate system.
///
/// Returns the current camera position as a 2D vector.
///
/// Example:
///
/// ```moonbit
/// let current_pos = @camera.get_position()
/// inspect(current_pos, content="Vec2D(0, 0)")
/// ```
///
pub fn get_position() -> @math.Vec2D {
  camera.position
}

///|
/// Sets the camera's movement boundaries to constrain its position within
/// specified limits.
///
/// Parameters:
///
/// * `top` : The topmost Y coordinate the camera can reach. If `None`, no top
///   limit is applied.
/// * `bottom` : The bottommost Y coordinate the camera can reach. If `None`, no
///   bottom limit is applied.
/// * `left` : The leftmost X coordinate the camera can reach. If `None`, no
///   left limit is applied.
/// * `right` : The rightmost X coordinate the camera can reach. If `None`, no
///   right limit is applied.
///
/// Example:
///
/// ```moonbit
/// // Set boundaries to keep camera within a level area
/// @camera.set_limits(top=0.0, bottom=500.0, left=0.0, right=800.0)
///
/// // Set only horizontal limits, allowing unlimited vertical movement
/// @camera.set_limits(left=0.0, right=1000.0)
///
/// // Remove all limits
/// @camera.set_limits()
/// ```
///
pub fn set_limits(
  top? : Double,
  bottom? : Double,
  left? : Double,
  right? : Double,
) -> Unit {
  camera.limit_top = top
  camera.limit_bottom = bottom
  camera.limit_left = left
  camera.limit_right = right
}

///|
/// Attaches an entity to the camera for automatic following with a specified
/// offset.
///
/// Parameters:
///
/// * `entity` : The entity that the camera should follow.
/// * `offset` : The positional offset from the entity's position where the
///   camera should be positioned.
///
/// Example:
///
/// ```moonbit
/// let player_entity = @system.Entity::new()
/// @camera.attach_entity(player_entity, @math.Vec2D(32.0, 32.0))
/// ```
///
pub fn attach_entity(entity : @system.Entity, offset : @math.Vec2D) -> Unit {
  camera.attached_entity = Some(entity)
  camera.offset = offset
}

///|
/// Configures whether the camera should follow the attached entity along the
/// X-axis.
///
/// Parameters:
///
/// * `follow` : Whether to enable X-axis following. When `true`, the camera
///   will automatically update its X position to follow the attached entity
///   horizontally. When `false`, the camera's X position remains fixed
///   regardless of the entity's horizontal movement.
///
/// Example:
///
/// ```moonbit
/// // Enable horizontal following
/// @camera.set_follow_x(true)
///
/// // Disable horizontal following while keeping vertical following
/// @camera.set_follow_x(false)
/// @camera.set_follow_y(true)
/// ```
///
pub fn set_follow_x(follow : Bool) -> Unit {
  camera.follow_x = follow
}

///|
/// Configures whether the camera should follow the attached entity along the
/// Y-axis.
///
/// Parameters:
///
/// * `follow` : Whether to enable Y-axis following. When `true`, the camera
///   will automatically update its Y position to follow the attached entity
///   vertically. When `false`, the camera's Y position remains fixed regardless
///   of the entity's vertical movement.
///
/// Example:
///
/// ```moonbit
/// // Enable vertical following
/// @camera.set_follow_y(true)
///
/// // Disable vertical following while keeping horizontal following
/// @camera.set_follow_y(false)
/// @camera.set_follow_x(true)
/// ```
///
pub fn set_follow_y(follow : Bool) -> Unit {
  camera.follow_y = follow
}

///|
let camera : Camera = {
  position: @math.Vec2D::zero(),
  limit_bottom: None,
  limit_left: None,
  limit_top: None,
  limit_right: None,
  attached_entity: None,
  offset: @math.Vec2D::zero(),
  follow_x: true,
  follow_y: true,
}

///|
/// Updates the camera position to follow an attached entity while respecting
/// movement boundaries and axis constraints.
///
/// Parameters:
///
/// * `delta` : The time elapsed since the last frame update (currently unused
///   but typically used for frame-rate independent updates).
///
/// Example:
///
/// ```moonbit
/// // This function is typically called automatically by the game engine's update loop
/// // Set up camera to follow a player entity
/// let player = @system.Entity::new()
/// @camera.attach_entity(player, @math.Vec2D(0.0, 0.0))
/// @camera.set_limits(top=0.0, bottom=1000.0, left=0.0, right=1200.0)
///
/// // The camera system will automatically update the camera position each frame
/// @camera.camera_system(0.016) // Called with delta time
/// ```
///
pub fn camera_system(_delta : Double) -> Unit {
  guard camera.attached_entity is Some(e) else { return }
  guard @position.positions.get(e) is Some(pos) else { return }
  let zoom = @backend.get_zoom()
  let viewport_size = @backend.get_canvas_size() * Vec2D(1 / zoom, 1 / zoom)
  let target_position = pos.0 -
    viewport_size * @math.Vec2D(0.5, 0.5) +
    camera.offset

  // Apply axis constraints for following
  let new_x = if camera.follow_x {
    target_position[X]
  } else {
    camera.position[X]
  }
  let new_y = if camera.follow_y {
    target_position[Y]
  } else {
    camera.position[Y]
  }
  camera.position = @math.Vec2D(new_x, new_y)
  if camera.limit_top is Some(top) && camera.position[Y] < top {
    camera.position = @math.Vec2D(camera.position[X], top)
  }
  if camera.limit_bottom is Some(bottom) &&
    camera.position[Y] > bottom - viewport_size[Y] {
    camera.position = @math.Vec2D(camera.position[X], bottom - viewport_size[Y])
  }
  if camera.limit_left is Some(left) && camera.position[X] < left {
    camera.position = @math.Vec2D(left, camera.position[Y])
  }
  if camera.limit_right is Some(right) &&
    camera.position[X] > right - viewport_size[X] {
    camera.position = @math.Vec2D(right - viewport_size[X], camera.position[Y])
  }
}
