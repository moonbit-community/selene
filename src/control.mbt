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
pub(all) struct Control {}

///|
pub let controls : Map[Entity, Control] = Map::new()

///|
pub fn control_system(_backend : &Backend) -> Unit {
  for entity, _control in controls {
    guard velocities.get(entity) is Some(velocity) else { continue }
    let mut new_velocity_x = velocity.x
    let mut new_velocity_y = velocity.y
    if is_pressed(ArrowLeft) {
      new_velocity_x = -5.0
    } else if is_pressed(ArrowRight) {
      new_velocity_x = 5.0
    } else {
      new_velocity_x = 0.0
    }
    if is_pressed(ArrowUp) {
      new_velocity_y = -5.0
    } else if is_pressed(ArrowDown) {
      new_velocity_y = 5.0
    } else {
      new_velocity_y = 0.0
    }
    velocities.set(entity, Vec2D::new(new_velocity_x, new_velocity_y))
  }
}
