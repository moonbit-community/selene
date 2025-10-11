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
/// Unique identifier for game objects.
///
/// Example:
///
/// ```moonbit
/// let entity = @entity.Entity::new()
/// entity.destroy()
/// ```
///
struct Entity(UInt) derive(Eq, Show, Hash)

///|
let all_entities : @set.Set[Entity] = @set.Set::new()

///|
/// Returns an iterator over all entities currently registered in the
/// selene app.
///
/// Returns an `Iter[Entity]` that yields all entities that have been created,
/// including both active and inactive entities.
///
/// Example:
///
/// ```moonbit
/// let entity1 = @entity.Entity::new()
/// let entity2 = @entity.Entity::new()
///
/// // The following line will be executed in the game loop, instead of manual calling.
/// @system.deferred_event_system(0.0)
/// 
/// inspect(@system.iter_entities().count(), content="2")
/// 
/// entity1.destroy()
/// entity2.destroy()
/// ```
///
pub fn iter_entities() -> Iter[Entity] {
  all_entities.iter()
}

///|
/// Checks whether an entity is currently active in the selene app.
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
/// ```moonbit
/// let entity = @entity.Entity::new()
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
/// Creates a new unique entity and registers it in the selene app.
///
/// Returns a new `Entity` with a unique identifier that is automatically
/// tracked in the system.
///
/// Example:
///
/// ```moonbit
/// let entity1 = @entity.Entity::new()
/// let entity2 = @entity.Entity::new()
///
/// // Each entity has a unique identifier
/// inspect(entity1 == entity2, content="false")
///
/// // Both entities are automatically registered and alive
/// inspect(entity1.is_alive(), content="true")
/// inspect(entity2.is_alive(), content="true")
/// ```
///
pub fn Entity::new() -> Entity {
  let entity = entity_generator.val
  entity_generator.val += 1
  all_entities.add(entity)
  entity
}

///|
/// Marks an entity for destruction, scheduling its removal from the
/// selene app during the next deferred event processing cycle.
///
/// Parameters:
///
/// * `entity` : The entity to be destroyed.
///
/// Example:
///
/// ```moonbit
/// let entity = @entity.Entity::new()
/// inspect(entity.is_alive(), content="true")
///
/// entity.destroy()
/// 
/// // The following line will be executed in the game loop, instead of manual calling.
/// @system.deferred_event_system(0.0)
/// 
/// // Entity will be removed from all_entities during next deferred event cycle
/// inspect(entity.is_alive(), content="false")
/// ```
/// 
/// FIXME: document update
///
pub fn Entity::destroy(e : Entity) -> Unit {
  @system.defer_event(fn() { all_entities.remove(e) })
  if parents.get(e) is Some(p) {
    for c in p.children {
      c.destroy()
    }
  }
}

///|
/// Reactivates a previously destroyed entity by adding it back to the active
/// entities collection.
///
/// Parameters:
///
/// * `entity` : The entity to be reactivated in the selene app.
///
/// Example:
///
/// ```moonbit
/// let entity = @entity.Entity::new()
/// inspect(entity.is_alive(), content="true")
///
/// entity.destroy()
/// 
/// // The following line will be executed in the game loop, instead of manual calling.
/// @system.deferred_event_system(0.0)
/// 
/// inspect(entity.is_alive(), content="false")
/// // Entity is marked for removal during next deferred event cycle
///
/// entity.respawn()
/// 
/// // The following line will be executed in the game loop, instead of manual calling.
/// @system.deferred_event_system(0.0)
/// 
/// inspect(entity.is_alive(), content="true") // Entity is active again
/// ```
///
pub fn Entity::respawn(e : Entity) -> Unit {
  @system.defer_event(fn() { all_entities.add(e) })
  if parents.get(e) is Some(p) {
    for c in p.children {
      c.respawn()
    }
  }
}
