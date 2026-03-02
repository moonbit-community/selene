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
/// The `CollisionLayer` struct represents a layer that defines the collision
/// properties of a collision object. It is used to categorize collision objects
/// into different layers, allowing for more granular control over collision detection.
///
pub struct CollisionLayer(UInt) derive(Eq)

///|
/// The `CollisionMask` struct represents a mask that defines which collision layers
/// a collision object can interact with. It is used to filter collisions based on
/// the layers of the objects involved in the collision.
/// 
pub struct CollisionMask(Array[CollisionLayer])

///|
let collision_layer_generator : Ref[UInt] = { val: 0 }

///|
/// Creates a new `CollisionLayer` with a unique identifier.
/// 
pub fn CollisionLayer::new() -> CollisionLayer {
  let layer = collision_layer_generator.val
  collision_layer_generator.val += 1
  layer
}

///|
/// Global registry that maps entities to their assigned collision layers.
///
/// This registry maintains the association between entities and their collision
/// layers, allowing the collision system to determine which layer each entity
/// belongs to for collision detection and filtering purposes. Entities can be
/// assigned to different collision layers to control how they interact with
/// other entities in the collision system.
///
/// Example:
///
/// ```moonbit nocheck
/// let player_entity = @entity.Entity::new()
/// defer player_entity.destroy()
/// let enemy_entity = @entity.Entity::new()
/// defer enemy_entity.destroy()
/// let player_layer = @collision.CollisionLayer::new()
/// let enemy_layer = @collision.CollisionLayer::new()
///
/// // Assign collision layers to entities
/// @collision.collision_layers[player_entity] = player_layer
/// @collision.collision_layers[enemy_entity] = enemy_layer
///
/// inspect(@collision.collision_layers.get(player_entity) is Some(_), content="true")
/// ```
///
pub let collision_layers : Map[@entity.Entity, CollisionLayer] = Map::new()

///|
/// Creates a new `CollisionMask` with the specified layers 
/// that the collision object can interact with.
/// 
pub fn CollisionMask::new(layers : Array[CollisionLayer]) -> CollisionMask {
  layers
}

///|
/// Creates an empty `CollisionMask` that does not interact with any layers.
/// 
pub fn CollisionMask::empty() -> CollisionMask {
  []
}

///|
fn CollisionMask::contains(
  self : CollisionMask,
  layer : CollisionLayer,
) -> Bool {
  self.0.contains(layer.0)
}
