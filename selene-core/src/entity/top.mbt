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
  world_id : UInt32
  value : UInt32
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
  mut entity_generator : UInt32
  mut alive_count : Int32
  all_entities : @set.Set[Entity]
  lifecycle_states : Map[Entity, EntityLifecycleState]
  pending_state_changes : @set.Set[Entity]
}

///|
let entity_store_key : @ecs.WorldKey[EntityWorldStore] = WorldKey(() => {
  entity_generator: 0U,
  alive_count: 0,
  all_entities: Set([]),
  lifecycle_states: Map([]),
  pending_state_changes: Set([]),
})

///|
fn entity_store() -> EntityWorldStore {
  @ecs.require_current_world().get_or_init(entity_store_key)
}

///|
pub fn iter_entities() -> Iter[Entity] {
  entity_store().all_entities.iter()
}

///|
pub fn alive_entity_count() -> Int32 {
  entity_store().alive_count
}

///|
pub fn Entity::is_alive(e : Entity) -> Bool {
  let world = @ecs.require_current_world()
  guard e.belongs_to(world) else { false }
  world.get_or_init(entity_store_key).is_alive(e)
}

///|
fn EntityWorldStore::is_alive(self : EntityWorldStore, entity : Entity) -> Bool {
  match self.lifecycle_states.get(entity).unwrap_or(Destroyed) {
    Alive | PendingRespawn => true
    PendingSpawn | PendingDespawn | Destroyed => false
  }
}

///|
/// Binds a live-state check to a World for repeated use during a traversal.
pub fn alive_in_world(world : @ecs.World) -> (Entity) -> Bool {
  let store = world.get_or_init(entity_store_key)
  let world_id = world.id()
  entity => entity.world_id == world_id && store.is_alive(entity)
}

///|
pub fn Entity::Entity() -> Entity {
  let world = @ecs.require_current_world()
  let store = world.get_or_init(entity_store_key)
  let entity = { world_id: world.id(), value: store.entity_generator, }
  store.entity_generator += 1U
  store.all_entities.add(entity)
  store.alive_count += 1
  store.lifecycle_states.set(entity, Alive)
  entity
}

///|
pub fn Entity::id(self : Entity) -> UInt32 {
  self.value
}

///|
/// Checks ownership independently of the entity's lifecycle state.
pub fn Entity::belongs_to(self : Entity, world : @ecs.World) -> Bool {
  self.world_id == world.id()
}

///|
/// Reserves an entity id that becomes alive on the next flush.
/// This matches deferred-spawn semantics used by commands.
pub fn Entity::reserve_spawn() -> Entity {
  Entity::reserve_spawn_in(@ecs.require_current_world())
}

///|
/// Reserves an entity in the specified World, independently of the active World.
pub fn Entity::reserve_spawn_in(world : @ecs.World) -> Entity {
  let store = world.get_or_init(entity_store_key)
  let entity = { world_id: world.id(), value: store.entity_generator, }
  store.entity_generator += 1U
  store.lifecycle_states.set(entity, PendingSpawn)
  store.pending_state_changes.add(entity)
  entity
}

///|
pub fn Entity::destroy(e : Entity) -> Unit {
  guard e.belongs_to(@ecs.require_current_world()) else { return }
  let store = entity_store()
  match store.lifecycle_states.get(e).unwrap_or(Destroyed) {
    Destroyed | PendingDespawn => ()
    PendingSpawn => {
      store.lifecycle_states.set(e, PendingDespawn)
      store.pending_state_changes.add(e)
    }
    Alive | PendingRespawn => {
      if store.all_entities.contains(e) {
        if store.alive_count > 0 {
          store.alive_count -= 1
        }
      }
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
  guard e.belongs_to(@ecs.require_current_world()) else { return }
  let store = entity_store()
  match store.lifecycle_states.get(e).unwrap_or(Destroyed) {
    Alive | PendingRespawn => ()
    Destroyed | PendingDespawn | PendingSpawn => {
      if store.lifecycle_states.get(e) is Some(PendingDespawn) &&
        store.all_entities.contains(e) {
        store.alive_count += 1
      }
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
        if !store.all_entities.contains(entity) {
          store.all_entities.add(entity)
          store.alive_count += 1
        }
        store.lifecycle_states.set(entity, Alive)
      }
      PendingDespawn => {
        if store.all_entities.contains(entity) {
          store.all_entities.remove(entity)
        }
        store.lifecycle_states.set(entity, Destroyed)
      }
      PendingRespawn => {
        if !store.all_entities.contains(entity) {
          store.all_entities.add(entity)
          store.alive_count += 1
        }
        store.lifecycle_states.set(entity, Alive)
      }
      Alive | Destroyed => ()
    }
    store.pending_state_changes.remove(entity)
  }
}
