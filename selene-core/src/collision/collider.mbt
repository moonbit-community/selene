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
  mut friction : Double
  mut restitution : Double

  fn new(filter : CollisionFilter) -> Collider
} derive(Eq)

///|
pub fn Collider::new(filter : CollisionFilter) -> Collider {
  { active: true, filter, friction: 0.5, restitution: 0.0 }
}

///|
pub fn Collider::with_material(
  filter : CollisionFilter,
  friction? : Double = 0.5,
  restitution? : Double = 0.0,
  active? : Bool = true,
) -> Collider {
  { active, filter, friction, restitution }
}

///|
priv struct ColliderWorldStore {
  colliders : Map[@entity.Entity, Collider]
  resolved_velocities : Map[@entity.Entity, @velocity.Velocity]
  grounded_entities : Set[@entity.Entity]
}

///|
let collider_world_stores : Map[UInt, ColliderWorldStore] = Map::new()

///|
fn collider_world_store() -> ColliderWorldStore {
  let world_id = @ecs.require_current_world().id()
  collider_world_stores.get_or_init(world_id, () => {
    colliders: Map::new(),
    resolved_velocities: Map::new(),
    grounded_entities: Set::new(),
  })
}

///|
/// World collider components.
pub fn colliders() -> Map[@entity.Entity, Collider] {
  collider_world_store().colliders
}

///|
/// Contact event emitted by the fixed-step physics system.
pub struct ContactEvent {
  entity : @entity.Entity
  other : @entity.Entity
  started : Bool
  direction : @math.Vec2
}

///|
/// Contact event bus.
pub let contact_event_bus : @event.Events[ContactEvent] = @event.Events::new()

///|
/// Effective post-solve velocities from the latest fixed step.
pub fn resolved_velocities() -> Map[@entity.Entity, @velocity.Velocity] {
  collider_world_store().resolved_velocities
}

///|
/// Entities grounded in the latest fixed step.
pub fn grounded_entities() -> Set[@entity.Entity] {
  collider_world_store().grounded_entities
}

///|
fn push_contact_event(event : ContactEvent) -> Unit {
  contact_event_bus.send(event)
}

///|
pub fn is_grounded(entity : @entity.Entity) -> Bool {
  grounded_entities().contains(entity)
}

///|
fn set_grounded(entity : @entity.Entity, grounded : Bool) -> Unit {
  let grounded_entities = grounded_entities()
  if grounded {
    grounded_entities.add(entity)
  } else {
    grounded_entities.remove(entity)
  }
}
