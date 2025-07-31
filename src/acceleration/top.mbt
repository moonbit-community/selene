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

pub(all) type Acceleration @math.Vec2D

pub let accelerations : Map[@system.Entity, Acceleration] = Map::new()

pub fn gravity_system(_backend : &@system.Backend) -> Unit {
  for e, a in accelerations {
    guard @velocity.velocities.get(e) is Some(velocity) else { continue }
    let new_velocity = @math.Vec2D::new(
      velocity.x + a.x,
      velocity.y + a.y,
    )
    @velocity.velocities.set(e, new_velocity)
  }
}