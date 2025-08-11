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
#deprecated("Will be removed in 0.11")
pub(all) struct KeyInput {}

///|
#deprecated("Will be removed in 0.11")
pub let controls : Map[@system.Entity, KeyInput] = Map::new()

///|
#deprecated("Will be removed in 0.11")
pub fn simple_input_system(_backend : &@system.Backend) -> Unit {
  for e in @system.all_entities {
    guard controls.get(e) is Some(_) else { continue }
    let new_velocity_x = if @system.is_pressed(ArrowLeft) {
      -5.0
    } else if @system.is_pressed(ArrowRight) {
      5.0
    } else {
      0.0
    }
    let new_velocity_y = if @system.is_pressed(ArrowUp) {
      -5.0
    } else if @system.is_pressed(ArrowDown) {
      5.0
    } else {
      0.0
    }
    @velocity.velocities.set(
      e,
      @math.Vec2D(new_velocity_x, new_velocity_y),
    )
  }
}
