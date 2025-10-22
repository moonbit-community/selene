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
/// ```moonbit
/// let vel : Velocity = @math.Vec2D(5.0, 3.0)
/// inspect(vel, content="Velocity(Vec2D(5, 3))")
/// ```
///
pub(all) struct Velocity(@math.Vec2D) derive(Eq, Show)

///|
/// Stores velocity components for all entities in the game world.
///
/// This is a global map that associates each entity with its velocity vector.
/// The velocity determines how fast and in which direction an entity moves per
/// frame. Entities without an entry in this map are considered to have zero
/// velocity.
///
/// Example:
///
/// ```moonbit
/// // Set velocity for an entity
/// let entity = @entity.Entity::new()
/// 
/// @velocity.velocities[entity] = @math.Vec2D(10.0, 5.0)
///
/// // Get velocity for an entity
/// let entity_vel = @velocity.velocities.get(entity)
/// 
/// inspect(entity_vel, content="Some(Velocity(Vec2D(10, 5)))")
/// ```
///
pub let velocities : Map[@entity.Entity, Velocity] = Map::new()
