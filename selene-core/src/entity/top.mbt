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
struct Entity {
  value : UInt
} derive(Eq, Debug, Hash)

///|
enum EntityLifecycleState {
  Alive
  PendingSpawn
  PendingDespawn
  PendingRespawn
  Destroyed
} derive(Eq, Debug)

///|
priv struct EntityWorldStore {
  mut entity_generator : UInt
  all_entities : @set.Set[Entity]
  lifecycle_states : Map[Entity, EntityLifecycleState]
  pending_state_changes : @set.Set[Entity]
}

///|
let entity_world_stores : Map[UInt, EntityWorldStore] = Map::of([])

///|
fn entity_store() -> EntityWorldStore {
  let world = @ecs.require_current_world()
  entity_world_stores.get_or_init(world.id(), () => {
    entity_generator: 0U,
    all_entities: @set.Set::from_iter(Iter::empty()),
    lifecycle_states: Map::of([]),
    pending_state_changes: @set.Set::from_iter(Iter::empty()),
  })
}

///|
pub fn iter_entities() -> Iter[Entity] {
  entity_store().all_entities.iter()
}

///|
pub fn Entity::is_alive(e : Entity) -> Bool {
  match
    entity_store().lifecycle_states
    .get(e)
    .unwrap_or(EntityLifecycleState::Destroyed) {
    Alive | PendingRespawn => true
    PendingSpawn | PendingDespawn | Destroyed => false
  }
}

///|
pub fn Entity::Entity() -> Entity {
  let store = entity_store()
  let entity = { value: store.entity_generator }
  store.entity_generator += 1U
  store.all_entities.add(entity)
  store.lifecycle_states.set(entity, Alive)
  entity
}

///|
pub fn Entity::id(self : Entity) -> UInt {
  self.value
}

///|
/// Reserves an entity id that becomes alive on the next flush.
/// This matches deferred-spawn semantics used by commands.
pub fn Entity::reserve_spawn() -> Entity {
  let store = entity_store()
  let entity = { value: store.entity_generator }
  store.entity_generator += 1U
  store.lifecycle_states.set(entity, PendingSpawn)
  store.pending_state_changes.add(entity)
  entity
}

///|
pub fn Entity::destroy(e : Entity) -> Unit {
  let store = entity_store()
  match
    store.lifecycle_states.get(e).unwrap_or(EntityLifecycleState::Destroyed) {
    Destroyed | PendingDespawn => ()
    Alive | PendingRespawn | PendingSpawn => {
      store.lifecycle_states.set(e, PendingDespawn)
      store.pending_state_changes.add(e)
      if hierarchy_parents().get(e) is Some(p) {
        for c in p.children {
          c.destroy()
        }
      }
    }
  }
}

///|
pub fn Entity::respawn(e : Entity) -> Unit {
  let store = entity_store()
  match
    store.lifecycle_states.get(e).unwrap_or(EntityLifecycleState::Destroyed) {
    Alive | PendingRespawn => ()
    Destroyed | PendingDespawn | PendingSpawn => {
      store.lifecycle_states.set(e, PendingRespawn)
      store.pending_state_changes.add(e)
      if hierarchy_parents().get(e) is Some(p) {
        for c in p.children {
          c.respawn()
        }
      }
    }
  }
}

///|
pub fn entity_flush_system(_delta : Double) -> Unit {
  let store = entity_store()
  for entity in store.pending_state_changes.to_array() {
    match store.lifecycle_states.get(entity).unwrap_or(Destroyed) {
      PendingSpawn => {
        store.all_entities.add(entity)
        store.lifecycle_states.set(entity, Alive)
      }
      PendingDespawn => {
        store.all_entities.remove(entity)
        store.lifecycle_states.set(entity, Destroyed)
      }
      PendingRespawn => {
        store.all_entities.add(entity)
        store.lifecycle_states.set(entity, Alive)
      }
      Alive | Destroyed => ()
    }
    store.pending_state_changes.remove(entity)
  }
}
