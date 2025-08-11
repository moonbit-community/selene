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
pub struct CollisionMask(Array[CollisionLayer]) // FIXME: Use `UInt` and bitwise operations can obtain higher performance.

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
  self.inner().contains(layer.inner())
}
