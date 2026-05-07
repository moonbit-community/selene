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
/// Velocity vector in 2D space.
///
/// Fields:
///
/// * `_` : The underlying 2D vector containing velocity components.
///
/// Example:
///
/// ```moonbit nocheck
/// let vel : Velocity = @math.Vec2(5.0, 3.0)
/// inspect(vel, content="Velocity(Vec2(5, 3))")
/// ```
///
pub(all) struct Velocity(@math.Vec2) derive(Eq, Debug)

///|
priv struct VelocityWorldStore {
  velocities : Map[@entity.Entity, Velocity]
}

///|
let velocity_world_stores : Map[UInt, VelocityWorldStore] = Map::of([])

///|
fn velocity_world_store() -> VelocityWorldStore {
  let world_id = @ecs.require_current_world().id()
  velocity_world_stores.get_or_init(world_id, () => { velocities: Map::of([]) })
}

///|
/// Returns the current world's velocity component store.
///
/// Example:
///
/// ```moonbit nocheck
/// // Set velocity for an entity
/// let entity = @entity.Entity()
/// defer entity.destroy()
///
/// @velocity.velocities().set(entity, @math.Vec2(10.0, 5.0))
///
/// // Get velocity for an entity
/// let entity_vel = @velocity.velocities().get(entity)
///
/// inspect(entity_vel, content="Some(Velocity(Vec2(10, 5)))")
/// ```
///
pub fn velocities() -> Map[@entity.Entity, Velocity] {
  velocity_world_store().velocities
}
