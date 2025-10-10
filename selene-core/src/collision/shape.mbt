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
/// The `CollisionShape` enum represents different shapes that can be used for collision detection.
/// It currently supports rectangular shapes defined by their size and offset.
/// 
pub(all) enum CollisionShape {
  Rect(size~ : @math.Vec2D, offset~ : @math.Vec2D)
}

///|
/// Stores the collision shapes for all entities in the game world.
///
/// This is a global registry that maps each entity to its associated collision
/// shape. The map allows for efficient lookup and management of collision
/// shapes during collision detection and physics calculations. Each entity can
/// have at most one collision shape associated with it.
///
/// Example:
///
/// ```moonbit
/// // Register a rectangular collision shape for an entity
/// let entity = @entity.Entity::new()
/// @collision.shapes[entity] = @collision.CollisionShape::Rect(
///   size=@math.Vec2D(50.0, 30.0),
///   offset=@math.Vec2D(0.0, 0.0)
/// )
/// ```
///
pub let shapes : Map[@entity.Entity, CollisionShape] = Map::new()
