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
pub struct CollisionLayer(UInt) derive(Eq)

///| FIXME: Use `UInt` and bitwise operations can obtain higher performance.
pub struct CollisionMask(Array[CollisionLayer])

///|
let collision_layer_generator : Ref[UInt] = { val: 0 }

///|
pub fn CollisionLayer::new() -> CollisionLayer {
  let layer = collision_layer_generator.val
  collision_layer_generator.val += 1
  layer
}

///|
pub fn CollisionMask::new(layers : Array[CollisionLayer]) -> CollisionMask {
  layers
}

///|
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
