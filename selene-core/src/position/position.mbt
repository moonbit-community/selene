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
/// 2D position in space.
///
pub(all) struct Position(@math.Vec2D) derive(Eq, Show)

///|
/// Global mutable map that stores position components for entities in the ECS
/// system.
///
/// This map associates each entity with its position in 2D space. The map is
/// shared across the entire position system and is used to track which entities
/// have position components and their current locations.
///
/// Example:
///
/// ```moonbit
/// let entity = @entity.Entity::new()
/// let pos = @math.Vec2D(10.0, 20.0)
/// @position.positions[entity] = pos
/// ```
///
pub let positions : Map[@entity.Entity, Position] = Map::new()
