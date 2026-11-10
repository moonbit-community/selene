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
fn EntityWorldStore::link_child(
  self : EntityWorldStore,
  child : Entity,
  parent : Entity?,
) -> Unit {
  guard parent is Some(parent) else { return }
  let child_slot = self.archetypes.slot(child).unwrap()
  let parent_slot = self.archetypes.slot(parent).unwrap()
  child_slot.parent = Some(parent)
  match parent_slot.children {
    Some(children) => children.push(child)
    None => parent_slot.children = Some([child])
  }
}

///|
fn EntityWorldStore::unlink_child(
  self : EntityWorldStore,
  child : EntitySlot,
  entity : Entity,
) -> Unit {
  guard child.parent is Some(parent) else { return }
  guard self.archetypes.slot(parent) is Some(slot) else { return }
  guard slot.children is Some(children) else { return }
  if children.search(entity) is Some(index) {
    ignore(children.remove(index))
    if children.is_empty() {
      slot.children = None
    }
  }
}

///|
/// Returns the children in the order they were spawned.
pub fn Entity::get_children(parent : Entity) -> Array[Entity] {
  let world = require_current_world()
  guard parent.belongs_to(world) else { [] }
  guard entity_store(world~).archetypes.slot(parent) is Some(slot) else { [] }
  slot.children.map_or([], children => children.copy())
}

///|
pub fn Entity::get_parent(child : Entity) -> Entity? {
  let world = require_current_world()
  guard child.belongs_to(world) else { None }
  guard entity_store(world~).archetypes.slot(child) is Some(slot) else { None }
  slot.parent
}

///|
pub fn Entity::is_child(entity : Entity) -> Bool {
  entity.get_parent() is Some(_)
}

///|
/// Visits all live root entities.
pub fn get_roots() -> Iter[Entity] {
  let store = entity_store()
  store.all_entities
  .iter()
  .filter(entity => {
    guard store.is_alive(entity) else { false }
    let slot = store.archetypes.slot(entity).unwrap()
    slot.parent is None
  })
}
