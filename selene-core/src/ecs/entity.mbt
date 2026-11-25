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
  Disabled
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
  }
}

///|
fn entity_store(world~ : World = require_current_world()) -> EntityWorldStore {
  entity_store_key.get_or_insert_with(world, _ => EntityWorldStore())
}

///|
pub fn iter_entities() -> Iter[Entity] {
  let store = entity_store()
  store.all_entities.iter().filter(entity => store.is_alive(entity))
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
  slot.materialized && slot.state is Some(Alive)
}

///|
fn EntityWorldStore::accepts_deferred_child(
  self : EntityWorldStore,
  parent : Entity,
) -> Bool {
  self.archetypes.slot(parent).map_or(false, slot => slot.materialized)
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
    store.all_entities.add(entity)
    if parent is None || (parent is Some(parent) && store.is_alive(parent)) {
      slot.state = Some(Alive)
      store.archetypes.set_active(entity, true)
      store.alive_count += 1
    } else {
      slot.state = Some(Disabled)
    }
  })
  entity
}

///|
fn Entity::disable(self : Entity) -> Unit {
  let world = require_current_world()
  guard self.belongs_to(world) else { return }
  let store = entity_store(world~)
  guard store.archetypes.slot(self) is Some(slot) && slot.materialized else {
    return
  }
  store.archetypes.require_no_query()
  if slot.state is Some(Alive) {
    store.archetypes.set_active(self, false)
    store.alive_count -= 1
    slot.state = Some(Disabled)
  }
  if slot.children is Some(children) {
    for child in children {
      child.disable()
    }
  }
}

///|
fn Entity::enable(self : Entity) -> Unit {
  let world = require_current_world()
  guard self.belongs_to(world) else { return }
  let store = entity_store(world~)
  guard store.archetypes.slot(self) is Some(slot) && slot.materialized else {
    return
  }
  store.archetypes.require_no_query()
  if slot.parent is Some(parent) && !store.is_alive(parent) {
    return
  }
  if slot.state is Some(Disabled) {
    store.archetypes.set_active(self, true)
    store.alive_count += 1
    slot.state = Some(Alive)
  }
  if slot.children is Some(children) {
    for child in children {
      child.enable()
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
  let store = entity_store(world=self)
  store.all_entities.iter().filter(entity => store.is_alive(entity))
}
