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
struct Entity(UInt) derive(Eq, Show, Hash)

///|
enum EntityLifecycleState {
  Alive
  PendingDespawn
  PendingRespawn
  Destroyed
} derive(Eq, Show)

///|
let all_entities : @set.Set[Entity] = @set.Set::new()

///|
let lifecycle_states : Map[Entity, EntityLifecycleState] = Map::new()

///|
let pending_state_changes : @set.Set[Entity] = @set.Set::new()

///|
pub fn iter_entities() -> Iter[Entity] {
  all_entities.iter()
}

///|
pub fn Entity::is_alive(e : Entity) -> Bool {
  match lifecycle_states.get(e).unwrap_or(EntityLifecycleState::Destroyed) {
    Alive | PendingRespawn => true
    PendingDespawn | Destroyed => false
  }
}

///|
let entity_generator : Ref[UInt] = { val: 0 }

///|
pub fn Entity::new() -> Entity {
  let entity = entity_generator.val
  entity_generator.val += 1
  all_entities.add(entity)
  lifecycle_states.set(entity, Alive)
  entity
}

///|
pub fn Entity::destroy(e : Entity) -> Unit {
  match lifecycle_states.get(e).unwrap_or(EntityLifecycleState::Destroyed) {
    Destroyed | PendingDespawn => ()
    Alive | PendingRespawn => {
      lifecycle_states.set(e, PendingDespawn)
      pending_state_changes.add(e)
      if parents.get(e) is Some(p) {
        for c in p.children {
          c.destroy()
        }
      }
    }
  }
}

///|
pub fn Entity::respawn(e : Entity) -> Unit {
  match lifecycle_states.get(e).unwrap_or(EntityLifecycleState::Destroyed) {
    Alive | PendingRespawn => ()
    Destroyed | PendingDespawn => {
      lifecycle_states.set(e, PendingRespawn)
      pending_state_changes.add(e)
      if parents.get(e) is Some(p) {
        for c in p.children {
          c.respawn()
        }
      }
    }
  }
}

///|
pub fn entity_flush_system(_delta : Double) -> Unit {
  for entity in pending_state_changes.to_array() {
    match lifecycle_states.get(entity).unwrap_or(Destroyed) {
      PendingDespawn => {
        all_entities.remove(entity)
        lifecycle_states.set(entity, Destroyed)
      }
      PendingRespawn => {
        all_entities.add(entity)
        lifecycle_states.set(entity, Alive)
      }
      Alive | Destroyed => ()
    }
    pending_state_changes.remove(entity)
  }
}
