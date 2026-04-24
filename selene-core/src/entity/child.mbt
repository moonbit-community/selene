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
/// Internal component that tracks a child entity's relationship to its parent.
///
/// Fields:
///
/// * `parent` : The parent entity that this child is attached to.
///
priv struct Child {
  parent : Entity
}

///|
/// Internal component that tracks a parent entity's children.
///
/// Fields:
///
/// * `children` : Array of all child entities attached to this parent.
/// * `is_root` : Whether this parent is a root entity (a parent that is not
///   itself a child of another entity). Root entities are the starting points
///   for hierarchical transform propagation in the unified
///   `@transform.transform_propagate_system`.
///
priv struct Parent {
  children : Array[Entity]
  is_root : Bool
}

///|
priv struct HierarchyWorldStore {
  parents : Map[Entity, Parent]
  children : Map[Entity, Child]
}

///|
let hierarchy_world_stores : Map[UInt, HierarchyWorldStore] = Map::new()

///|
fn hierarchy_store() -> HierarchyWorldStore {
  let world = @ecs.require_current_world()
  hierarchy_world_stores.get_or_init(world.id(), () => {
    parents: Map::new(),
    children: Map::new(),
  })
}

///|
fn hierarchy_parents() -> Map[Entity, Parent] {
  hierarchy_store().parents
}

///|
fn hierarchy_children() -> Map[Entity, Child] {
  hierarchy_store().children
}

///|
fn hierarchy_would_create_cycle(child : Entity, parent : Entity) -> Bool {
  let children = hierarchy_children()
  let mut current : Entity? = Some(parent)
  while current is Some(entity) {
    if entity == child {
      return true
    }
    current = children.get(entity).map(rel => rel.parent)
  }
  false
}

///|
fn detach_parent_link(child : Entity) -> Unit {
  let parents = hierarchy_parents()
  let children = hierarchy_children()
  match children.get(child) {
    Some(rel) => {
      children.remove(child)
      match parents.get(rel.parent) {
        Some(parent_record) => {
          let updated_children = parent_record.children.filter(fn(entity) {
            entity != child
          })
          if updated_children.length() == 0 {
            parents.remove(rel.parent)
          } else {
            parents.set(rel.parent, {
              ..parent_record,
              children: updated_children,
            })
          }
        }
        None => ()
      }
    }
    None => ()
  }
  match parents.get(child) {
    Some(parent_record) =>
      parents.set(child, { ..parent_record, is_root: true })
    None => ()
  }
}

///|
fn attach_parent_link(child : Entity, parent : Entity) -> Unit {
  let parents = hierarchy_parents()
  let children = hierarchy_children()
  let parent_record = parents.get_or_init(parent, () => {
    children: [],
    is_root: !children.contains(parent),
  })
  if !parent_record.children.contains(child) {
    let updated_children : Array[Entity] = []
    for entity in parent_record.children {
      updated_children.push(entity)
    }
    updated_children.push(child)
    parents.set(parent, { ..parent_record, children: updated_children })
  }
  children.set(child, { parent, })
  match parents.get(child) {
    Some(child_parent_record) =>
      parents.set(child, { ..child_parent_record, is_root: false })
    None => ()
  }
}

///|
/// Creates a new child entity attached to the specified parent entity.
///
/// The child entity is automatically registered in the entity system and linked
/// to its parent. The parent-child relationship enables hierarchical transforms
/// and cascading lifecycle operations (destroying a parent destroys all its
/// children, and respawning a parent respawns all its children).
///
/// Parameters:
///
/// * `parent` : The parent entity to attach the new child to.
/// Returns a new child `Entity` that is linked to the parent.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity()
/// @transform.transforms().set(parent, @transform.Transform::from_xyz(100.0, 100.0, 0.0))
///
/// let child = parent.spawn_child()
/// @transform.transforms().set(child, @transform.Transform::from_xyz(10.0, 5.0, 0.0))
///
/// inspect(parent.get_children().length(), content="1")
/// inspect(child.is_child(), content="true")
///
/// parent.destroy()
/// ```
///
pub fn Entity::spawn_child(parent : Entity) -> Entity {
  let child_entity = Entity()
  attach_parent_link(child_entity, parent)
  child_entity
}

///|
/// Retrieves all child entities attached to the specified parent entity.
///
/// Parameters:
///
/// * `parent` : The parent entity whose children to retrieve.
///
/// Returns an array of child entities. Returns an empty array if the entity has
/// no children.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity()
/// let child1 = parent.spawn_child()
/// let child2 = parent.spawn_child()
///
/// let children = parent.get_children()
/// inspect(children.length(), content="2")
/// inspect(child1 == children[0], content="true")
/// inspect(child2 == children[1], content="true")
///
/// parent.destroy()
/// ```
///
pub fn Entity::get_children(parent : Entity) -> Array[Entity] {
  let parents = hierarchy_parents()
  parents.get(parent).map_or([], p => p.children)
}

///|
/// Checks whether an entity is a child of another entity.
///
/// Parameters:
///
/// * `entity` : The entity to check.
///
/// Returns `true` if the entity is a child (has a parent), `false` otherwise.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity()
/// let child = parent.spawn_child()
/// let standalone = @entity.Entity()
///
/// inspect(child.is_child(), content="true")
/// inspect(standalone.is_child(), content="false")
///
/// parent.destroy()
/// standalone.destroy()
/// ```
///
pub fn Entity::is_child(entity : Entity) -> Bool {
  let children = hierarchy_children()
  children.contains(entity)
}

///|
/// Retrieves the parent entity of a child entity.
///
/// Parameters:
///
/// * `child` : The child entity whose parent to retrieve.
///
/// Returns `Some(parent_entity)` if the entity has a parent, or `None` if the
/// entity is not a child.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity()
/// let child = parent.spawn_child()
///
/// inspect(child.get_parent().unwrap() == parent, content="true")
/// inspect(parent.get_parent(), content="None")
///
/// parent.destroy()
/// ```
///
pub fn Entity::get_parent(child : Entity) -> Entity? {
  let children = hierarchy_children()
  children.get(child).map(c => c.parent)
}

///|
pub fn Entity::set_parent(child : Entity, parent : Entity) -> Unit {
  guard child != parent else { return }
  guard !hierarchy_would_create_cycle(child, parent) else { return }
  guard child.get_parent() != Some(parent) else { return }
  detach_parent_link(child)
  attach_parent_link(child, parent)
}

///|
pub fn Entity::remove_parent(child : Entity) -> Unit {
  detach_parent_link(child)
}

///|
/// Returns an iterator over all root entities in the hierarchy.
///
/// Root entities are parent entities (entities that have spawned children) that
/// are not themselves children of another entity. They serve as the starting
/// points for hierarchical transform propagation in the
/// `@transform.transform_propagate_system`.
///
/// **Important**: Only entities that have called `spawn_child()` at least once
/// can be root entities. Standalone entities created with `Entity()` that
/// have never spawned children are not considered roots and will not be returned
/// by this function.
///
/// Returns an `Iter[Entity]` that yields all root parent entities.
///
/// Example:
///
/// ```moonbit nocheck
/// @entity.entity_flush_system(0.0)
///
/// let root1 = @entity.Entity()
/// let root2 = @entity.Entity()
/// let child1 = root1.spawn_child()
/// let _grandchild = child1.spawn_child()
///
/// // root1 and root2 are roots (parents but not children)
/// // child1 is not a root (it's both a parent and a child)
/// let roots = @entity.get_roots().collect()
/// inspect(roots.length(), content="1")
///
/// root1.destroy()
/// root2.destroy()
/// ```
///
pub fn get_roots() -> Iter[Entity] {
  let parents = hierarchy_parents()
  parents.iter().filter(ep => ep.1.is_root && ep.0.is_alive()).map(ep => ep.0)
}

///|
