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
/// Returns the current position of the global camera.
///
/// Returns a `@math.Vec2D` representing the camera's current position
/// coordinates.
///
/// Example:
///
/// ```notest
/// let current_pos = @camera.get_position()
/// println("Camera is at: (\{current_pos[X]}, \{current_pos[Y]})")
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
/// ```notest
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
/// Attaches an entity to the camera for automatic following.
///
/// Parameters:
///
/// * `entity` : The entity that the camera should follow.
///
/// Example:
///
/// ```notest
/// // Attach a player entity to the camera
/// @camera.attach_entity(player_entity)
///
/// // Configure camera following behavior
/// @camera.set_follow_x(true)
/// @camera.set_follow_y(true)
///
/// // Set offset to center camera on entity
/// @camera.set_offset(@math.Vec2D(16.0, 16.0))
/// ```
///
pub fn attach_entity(entity : @system.Entity) -> Unit {
  camera.attached_entity = Some(entity)
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
/// ```notest
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
/// ```notest
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
/// Sets the camera's offset relative to the attached entity.
///
/// Parameters:
///
/// * `offset` : A 2D vector representing the offset distance from the attached
///   entity's position. This offset is applied when calculating the camera's
///   target position during following behavior.
///
/// Example:
///
/// ```notest
/// // Set offset to center camera on a 32x32 pixel entity
/// @camera.set_offset(@math.Vec2D(16.0, 16.0))
///
/// // Set offset to position camera slightly above and to the right of entity
/// @camera.set_offset(@math.Vec2D(10.0, -20.0))
///
/// // Reset offset to zero (no offset from entity position)
/// @camera.set_offset(@math.Vec2D::zero())
/// ```
///
pub fn set_offset(offset : @math.Vec2D) -> Unit {
  camera.offset = offset
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
/// Updates the global camera position based on the attached entity and applies
/// movement constraints.
///
/// This system function should be called every frame to automatically update
/// the camera position. It follows an attached entity (if set) while respecting
/// the configured axis constraints and boundary limits. The camera position
/// represents the top-left corner of the viewport.
///
/// Parameters:
///
/// * `backend` : The system backend that provides canvas size information for
///   viewport calculations.
///
/// Example:
///
/// ```notest
/// // Add the camera system to your game loop
/// app.add_system(@camera.camera_system)
///
/// // Attach an entity for the camera to follow
/// camera.attached_entity = Some(player_entity)
///
/// // Set movement limits
/// camera.limit_top = Some(0.0)
/// camera.limit_bottom = Some(500.0)
/// camera.limit_left = Some(0.0)
/// camera.limit_right = Some(650.0)
///
/// // Configure following behavior
/// camera.follow_x = true
/// camera.follow_y = true
///
/// // Set offset to center camera on entity
/// camera.offset = @math.Vec2D(32.0, 32.0)  // Half of entity size
/// ```
///
pub fn camera_system(backend : &@system.Backend) -> Unit {
  guard camera.attached_entity is Some(e) else { return }
  guard @position.positions.get(e) is Some(pos) else { return }
  let zoom = backend.get_zoom()
  let viewport_size = backend.get_canvas_size() * Vec2D(1 / zoom, 1 / zoom)
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
