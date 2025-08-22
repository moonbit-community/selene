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
/// Unique identifier for game objects in the entity-component system.
///
/// Example:
///
/// ```notest
/// let entity = @system.Entity::new()
/// if entity.is_alive() {
///   println("Entity is active")
/// }
/// entity.destroy()
/// ```
///
struct Entity(UInt) derive(Eq, Show, Hash)

///|
let all_entities : @set.Set[Entity] = @set.Set::new()

///|
pub fn iter_entities() -> Iter[Entity] {
  all_entities.iter()
}

///|
/// Checks whether an entity is currently active in the entity-component system.
///
/// Parameters:
///
/// * `entity` : The entity to check for activity status.
///
/// Returns `true` if the entity is currently active and tracked in the system,
/// `false` otherwise.
///
/// Example:
///
/// ```notest
/// let entity = @system.Entity::new()
/// inspect(entity.is_alive(), content="true")
///
/// entity.destroy()
/// // Note: The entity will be marked as inactive during the next deferred event cycle
/// ```
///
pub fn Entity::is_alive(e : Entity) -> Bool {
  all_entities.contains(e)
}

///|
let entity_generator : Ref[UInt] = { val: 0 }

///|
pub fn Entity::new() -> Entity {
  let entity = entity_generator.val
  entity_generator.val += 1
  all_entities.add(entity)
  entity
}

///|
/// Marks an entity for destruction, scheduling its removal from the
/// entity-component system during the next deferred event processing cycle.
///
/// Parameters:
///
/// * `entity` : The entity to be destroyed.
///
/// Example:
///
/// ```notest
/// let entity = @system.Entity::new()
/// inspect(entity.is_alive(), content="true")
///
/// entity.destroy()
/// // Entity will be removed from all_entities during next deferred event cycle
/// ```
///
pub fn Entity::destroy(e : Entity) -> Unit {
  defer_event(fn() { all_entities.remove(e) })
}

///|
/// Reactivates a previously destroyed entity by adding it back to the active
/// entities collection.
///
/// Parameters:
///
/// * `entity` : The entity to be reactivated in the entity-component system.
///
/// Example:
///
/// ```notest
/// let entity = @system.Entity::new()
/// inspect(entity.is_alive(), content="true")
///
/// entity.destroy()
/// inspect(entity.is_alive(), content="false")
/// // Entity is marked for removal during next deferred event cycle
///
/// entity.respawn()
/// inspect(entity.is_alive(), content="true") // Entity is active again
/// ```
///
pub fn Entity::respawn(e : Entity) -> Unit {
  all_entities.add(e)
}
