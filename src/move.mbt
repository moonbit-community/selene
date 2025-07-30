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
pub(all) type Velocity Vec2D

///|
pub let velocities : Map[Entity, Velocity] = Map::new()


///|
pub fn move_system(_backend : &Backend) -> Unit {
  for entity, velocity in velocities {
    guard positions.get(entity) is Some(pos) else { continue }
    let new_pos = Vec2D::new(pos.x + velocity.x, pos.y + velocity.y)
    positions.set(entity, new_pos)
  }
}
