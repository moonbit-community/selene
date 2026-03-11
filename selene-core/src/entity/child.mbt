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
/// * `offset` : The positional offset from the parent's position. This offset
///   is added to the parent's position by the `@inherit.inherit_position_system`
///   to calculate the child's absolute position.
///
priv struct Child {
  parent : Entity
  mut offset : @math.Vec2D
}

///|
/// Internal component that tracks a parent entity's children.
///
/// Fields:
///
/// * `children` : Array of all child entities attached to this parent.
/// * `is_root` : Whether this parent is a root entity (a parent that is not
///   itself a child of another entity). Root entities are the starting points
///   for hierarchical position propagation in the `@inherit.inherit_position_system`.
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
/// * `offset` : Optional positional offset from the parent. When the
///   `@inherit.inherit_position_system` runs, the child's position will be set
///   to `parent_position + offset`. Defaults to `Vec2D::default()` (0, 0) if
///   not specified.
///
/// Returns a new child `Entity` that is linked to the parent.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity::new()
/// @position.positions().set(parent, @math.Vec2D(100.0, 100.0))
///
/// let child = parent.spawn_child(offset=@math.Vec2D(10.0, 5.0))
///
/// // After @inherit.inherit_position_system runs:
/// // child's position will be (110.0, 105.0)
///
/// inspect(parent.get_children().length(), content="1")
/// inspect(child.is_child(), content="true")
///
/// parent.destroy()
/// ```
///
pub fn Entity::spawn_child(parent : Entity, offset? : @math.Vec2D) -> Entity {
  let parents = hierarchy_parents()
  let children = hierarchy_children()
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
/// let parent = @entity.Entity::new()
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
/// let parent = @entity.Entity::new()
/// let child = parent.spawn_child()
/// let standalone = @entity.Entity::new()
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
/// let parent = @entity.Entity::new()
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
/// Updates the positional offset of a child entity relative to its parent.
///
/// The offset determines where the child will be positioned relative to its
/// parent when the `@inherit.inherit_position_system` runs. The child's
/// absolute position is calculated as `parent_position + offset`.
///
/// Parameters:
///
/// * `child` : The child entity whose offset to update.
/// * `offset` : The new positional offset vector.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity::new()
/// @position.positions().set(parent, @math.Vec2D(100.0, 100.0))
///
/// let child = parent.spawn_child(offset=@math.Vec2D(10.0, 5.0))
/// // Child will be at (110.0, 105.0) after inherit_position_system runs
///
/// child.set_offset(@math.Vec2D(20.0, 15.0))
/// // Child will now be at (120.0, 115.0) after inherit_position_system runs
///
/// parent.destroy()
/// ```
///
pub fn Entity::set_offset(child : Entity, offset : @math.Vec2D) -> Unit {
  let children = hierarchy_children()
  children.get(child).unwrap().offset = offset
}

///|
/// Returns an iterator over all root entities in the hierarchy.
///
/// Root entities are parent entities (entities that have spawned children) that
/// are not themselves children of another entity. They serve as the starting
/// points for hierarchical position propagation in the
/// `@inherit.inherit_position_system`.
///
/// **Important**: Only entities that have called `spawn_child()` at least once
/// can be root entities. Standalone entities created with `Entity::new()` that
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
/// let root1 = @entity.Entity::new()
/// let root2 = @entity.Entity::new()
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
/// Retrieves the positional offset of a child entity relative to its parent.
///
/// Parameters:
///
/// * `entity` : The child entity whose offset to retrieve.
///
/// Returns the offset vector. The child's absolute position is calculated as
/// `parent_position + offset` by the `@inherit.inherit_position_system`.
///
/// Example:
///
/// ```moonbit nocheck
/// let parent = @entity.Entity::new()
/// let offset = @math.Vec2D(10.0, 5.0)
/// let child = parent.spawn_child(offset~)
///
/// inspect(child.get_offset(), content="Vec2D(10, 5)")
///
/// parent.destroy()
/// ```
///
pub fn Entity::get_offset(entity : Entity) -> @math.Vec2D {
  let children = hierarchy_children()
  children.get(entity).unwrap().offset
}
