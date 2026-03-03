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
/// Component that controls whether an entity participates in world collisions.
pub(all) struct Collider {
  mut active : Bool
  filter : CollisionFilter
}

///|
pub fn Collider::new(filter : CollisionFilter) -> Collider {
  { active: true, filter }
}

///|
/// World collider components.
pub let colliders : Map[@entity.Entity, Collider] = Map::new()

///|
/// Contact event emitted by the fixed-step physics system.
pub struct ContactEvent {
  entity : @entity.Entity
  other : @entity.Entity
  started : Bool
  direction : @math.Vec2D
}

///|
/// Frame-local contact events generated during the latest fixed step.
let frame_contact_events : Array[ContactEvent] = []

///|
/// Effective post-solve velocities from the latest fixed step.
pub let resolved_velocities : Map[@entity.Entity, @velocity.Velocity] = Map::new()

///|
/// Entities grounded in the latest fixed step.
pub let grounded_entities : Set[@entity.Entity] = Set::new()

///|
fn clear_contact_events() -> Unit {
  frame_contact_events.clear()
}

///|
fn push_contact_event(event : ContactEvent) -> Unit {
  frame_contact_events.push(event)
}

///|
pub fn contact_events() -> Array[ContactEvent] {
  frame_contact_events
}

///|
pub fn is_grounded(entity : @entity.Entity) -> Bool {
  grounded_entities.contains(entity)
}

///|
fn set_grounded(entity : @entity.Entity, grounded : Bool) -> Unit {
  if grounded {
    grounded_entities.add(entity)
  } else {
    grounded_entities.remove(entity)
  }
}
