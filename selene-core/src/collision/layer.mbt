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
/// A collision group identifier.
///
/// Groups are used by `CollisionFilter` to decide which entities can interact.
pub struct CollisionGroup {
  value : UInt
} derive(Eq)

///|
/// A collision filter used by colliders and trigger areas.
///
/// `group` defines which group the owner belongs to.
/// `mask` defines which groups this owner can interact with.
pub struct CollisionFilter {
  group : CollisionGroup
  mask : Array[CollisionGroup]
  match_all : Bool
} derive(Eq)

///|
let collision_group_generator : Ref[UInt] = { val: 0 }

///|
/// Creates a new collision group with a unique identifier.
pub fn CollisionGroup::new() -> CollisionGroup {
  let group = collision_group_generator.val
  collision_group_generator.val += 1
  { value: group }
}

///|
/// Creates a collision filter that belongs to `group` and can interact with
/// all groups listed in `mask`.
pub fn CollisionFilter::new(
  group : CollisionGroup,
  mask : Array[CollisionGroup],
) -> CollisionFilter {
  { group, mask, match_all: false }
}

///|
/// Creates a collision filter that cannot interact with any group.
pub fn CollisionFilter::empty(group : CollisionGroup) -> CollisionFilter {
  { group, mask: [], match_all: false }
}

///|
/// Creates a collision filter that can interact with every group.
pub fn CollisionFilter::all(group : CollisionGroup) -> CollisionFilter {
  { group, mask: [], match_all: true }
}

///|
fn CollisionFilter::matches_group(
  self : CollisionFilter,
  group : CollisionGroup,
) -> Bool {
  self.match_all || self.mask.contains(group)
}
