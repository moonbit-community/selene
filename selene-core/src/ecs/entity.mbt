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
#derive(Eq, Debug, Hash)
struct Entity {
  world_id : UInt32
  value : UInt32
  slot : Int32
  generation : UInt32
}

///|
pub extend Entity with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Entity with Eq::{not_equal, equal}

///|
pub extend Entity with Hash::{hash, hash_combine}

///|
priv enum EntityLifecycleState {
  Alive
  PendingSpawn
  PendingDespawn
  PendingRespawn
  Destroyed
}

///|
priv struct EntitySlot {
  mut generation : UInt32
  mut state : EntityLifecycleState?
  mut materialized : Bool
  mut location : (Int32, Int32)?
  mut parent : Entity?
  mut children : Array[Entity]?
}

///|
priv struct EntityWorldStore {
  mut entity_generator : UInt32
  mut alive_count : Int32
  all_entities : @set.Set[Entity]
  archetypes : ArchetypeWorld
  free_slots : Array[Int32]
  pending_state_changes : @set.Set[Entity]
}

///|
let entity_store_key : ResourceKey[EntityWorldStore] = ResourceKey()

///|
fn EntityWorldStore::EntityWorldStore() -> EntityWorldStore {
  {
    entity_generator: 0U,
    alive_count: 0,
    all_entities: Set([]),
    archetypes: ArchetypeWorld([]),
    free_slots: [],
    pending_state_changes: Set([]),
  }
}

///|
fn entity_store(world~ : World = require_current_world()) -> EntityWorldStore {
  entity_store_key.get_or_insert_with(world, _ => EntityWorldStore())
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
  let world = require_current_world()
  guard e.belongs_to(world) else { false }
  entity_store(world~).is_alive(e)
}

///|
fn EntityWorldStore::is_alive(self : EntityWorldStore, entity : Entity) -> Bool {
  guard self.archetypes.slot(entity) is Some(slot) else { false }
  slot.materialized &&
  (slot.state is Some(Alive) || slot.state is Some(PendingRespawn))
}

///|
fn EntityWorldStore::accepts_deferred_child(
  self : EntityWorldStore,
  parent : Entity,
) -> Bool {
  guard self.archetypes.slot(parent) is Some(slot) && slot.materialized else {
    false
  }
  match slot.state {
    Some(Alive | PendingSpawn | PendingRespawn) => true
    _ => false
  }
}

///|
/// Binds a live-state check to a World for repeated use during a traversal.
pub fn alive_in_world(world : World) -> (Entity) -> Bool {
  let store = entity_store(world~)
  let world_id = world.id()
  entity => entity.world_id == world_id && store.is_alive(entity)
}

///|
/// Checks whether this handle still owns its slot in the specified World.
pub fn Entity::is_valid_in(self : Entity, world : World) -> Bool {
  self.belongs_to(world) &&
  entity_store(world~).archetypes.slot(self) is Some(_)
}

///|
fn EntityWorldStore::allocate(
  self : EntityWorldStore,
  world_id : UInt32,
  state : EntityLifecycleState,
) -> Entity {
  let value = self.entity_generator
  guard value != 0xffffffffU else {
    abort("entity IDs exhausted for this world")
  }
  self.entity_generator += 1U
  let slots = self.archetypes.slots
  let slot = match self.free_slots.pop() {
    Some(index) => {
      slots[index].state = Some(state)
      index
    }
    None => {
      let index = slots.length()
      slots.push({
        generation: 0U,
        state: Some(state),
        materialized: false,
        location: None,
        parent: None,
        children: None,
      })
      index
    }
  }
  { world_id, value, slot, generation: slots[slot].generation, }
}

///|
/// A stable World-local ID. The ID stays unique when a storage slot is reused.
pub fn Entity::id(self : Entity) -> UInt32 {
  self.value
}

///|
/// The reusable slot index, suitable for World-local traversal scratch space.
pub fn Entity::slot_index(self : Entity) -> Int32 {
  self.slot
}

///|
/// Checks ownership independently of the entity's lifecycle state.
pub fn Entity::belongs_to(self : Entity, world : World) -> Bool {
  self.world_id == world.id()
}

///|
fn EntityWorldStore::release_slot(
  self : EntityWorldStore,
  entity : Entity,
  slot : EntitySlot,
) -> Unit {
  self.pending_state_changes.remove(entity)
  slot.state = None
  slot.materialized = false
  slot.parent = None
  slot.children = None
  if slot.generation != 0xffffffffU {
    slot.generation += 1U
    self.free_slots.push(entity.slot)
  }
}

///|
fn queue_entity_spawn(
  world : World,
  parent : Entity?,
  initialize : (Entity) -> Unit,
) -> Entity {
  if parent is Some(parent) && !parent.belongs_to(world) {
    abort("parent belongs to another World")
  }
  let store = entity_store(world~)
  let entity = store.allocate(world.id(), PendingSpawn)
  enqueue(world, _ => {
    guard store.archetypes.slot(entity) is Some(slot) else { return }
    if parent is Some(parent) && !store.accepts_deferred_child(parent) {
      store.release_slot(entity, slot)
      return
    }
    initialize(entity)
    store.link_child(entity, parent)
    slot.materialized = true
    store.pending_state_changes.add(entity)
  })
  entity
}

///|
/// Despawns this entity while retaining its slot and components for respawn.
fn Entity::destroy(e : Entity) -> Unit {
  let world = require_current_world()
  guard e.belongs_to(world) else { return }
  let store = entity_store(world~)
  guard store.archetypes.slot(e) is Some(slot) else { return }
  match slot.state.unwrap() {
    Destroyed | PendingDespawn => ()
    PendingSpawn | Alive | PendingRespawn => {
      if store.all_entities.contains(e) && store.alive_count > 0 {
        store.alive_count -= 1
      }
      slot.state = Some(PendingDespawn)
      store.pending_state_changes.add(e)
      if slot.children is Some(children) {
        for c in children {
          c.destroy()
        }
      }
    }
  }
}

///|
fn Entity::respawn(e : Entity) -> Unit {
  let world = require_current_world()
  guard e.belongs_to(world) else { return }
  let store = entity_store(world~)
  guard store.archetypes.slot(e) is Some(slot) else { return }
  if slot.parent is Some(parent) && !store.accepts_deferred_child(parent) {
    return
  }
  match slot.state.unwrap() {
    Alive | PendingRespawn => ()
    Destroyed | PendingDespawn | PendingSpawn => {
      if slot.state is Some(PendingDespawn) && store.all_entities.contains(e) {
        store.alive_count += 1
      }
      slot.state = Some(PendingRespawn)
      store.pending_state_changes.add(e)
      if slot.children is Some(children) {
        for c in children {
          c.respawn()
        }
      }
    }
  }
}

///|
fn flush_entity_lifecycle(world : World) -> Unit {
  let store = entity_store(world~)
  for entity in store.pending_state_changes.to_array() {
    store.pending_state_changes.remove(entity)
    guard store.archetypes.slot(entity) is Some(slot) else { continue }
    match slot.state.unwrap() {
      PendingSpawn | PendingRespawn => {
        guard slot.materialized else { continue }
        if !store.all_entities.contains(entity) {
          store.all_entities.add(entity)
          store.alive_count += 1
        }
        slot.state = Some(Alive)
      }
      PendingDespawn => {
        store.all_entities.remove(entity)
        slot.state = Some(Destroyed)
      }
      Alive | Destroyed => ()
    }
  }
}

///|
/// Tests live state in this World without consulting the active schedule.
pub fn World::is_alive(self : World, entity : Entity) -> Bool {
  entity.belongs_to(self) && entity_store(world=self).is_alive(entity)
}

///|
/// Visits the entities tracked by this World without consulting the active schedule.
pub fn World::iter_entities(self : World) -> Iter[Entity] {
  entity_store(world=self).all_entities.iter()
}
