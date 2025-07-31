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
enum PlayerState {
  Idle
  Jump
  Fall
  Die
}

///|
let player_state : Ref[PlayerState] = { val: PlayerState::Idle }

///|
// fn player_state_system() -> Unit {
  // guard @velocity.velocities.get(player) is Some(velocity)
  // if player_state.val is PlayerState::Die {
  //   return
  // }
  // let mut new_velocity_x = velocity.x
  // let mut new_velocity_y = velocity.y
  // if @system.is_pressed(ArrowLeft) {
  //   new_velocity_x = -5.0
  // } else if @system.is_pressed(ArrowRight) {
  //   new_velocity_x = 5.0
  // } else {
  //   new_velocity_x = 0.0
  // }
  // match player_state.val {
  //   Idle => ...
  //   Fall => ...
  //   Jump => ...
  //   Die => ...
  // }
  // if @system.is_pressed(ArrowUp) {
  //   new_velocity_y = -5.0
  // } else if @system.is_pressed(ArrowDown) {
  //   new_velocity_y = 5.0
  // } else {
  //   new_velocity_y = 0.0
  // }
//   @velocity.velocities.set(
//     player,
//     @math.Vec2D::new(new_velocity_x, new_velocity_y),
//   )
// }
