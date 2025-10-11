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
priv struct Child {
  parent : Entity
  mut offset : @math.Vec2D
}

///|
priv struct Parent {
  children : Array[Entity]
  is_root : Bool
}

///|
let parents : Map[Entity, Parent] = Map::new()

///|
let children : Map[Entity, Child] = Map::new()

///|
pub fn Entity::spawn_child(parent : Entity, offset? : @math.Vec2D) -> Entity {
  let child_entity = Entity::new()
  let p = parents.get_or_init(parent, () => {
    children: [],
    is_root: !children.contains(parent),
  })
  p.children.push(child_entity)
  children.set(child_entity, { parent, offset: offset.unwrap_or_default() })
  child_entity
}

///|
pub fn Entity::get_children(parent : Entity) -> Array[Entity] {
  parents.get(parent).map_or([], p => p.children)
}

///|
pub fn Entity::is_child(entity : Entity) -> Bool {
  children.contains(entity)
}

///|
pub fn Entity::get_parent(child : Entity) -> Entity? {
  children.get(child).map(c => c.parent)
}

///|
pub fn Entity::set_offset(child : Entity, offset : @math.Vec2D) -> Unit {
  children.get(child).unwrap().offset = offset
}

///|
pub fn get_roots() -> Iter[Entity] {
  parents.iter().filter(ep => ep.1.is_root).map(ep => ep.0)
}

///|
pub fn Entity::get_offset(entity : Entity) -> @math.Vec2D {
  children.get(entity).unwrap().offset
}
