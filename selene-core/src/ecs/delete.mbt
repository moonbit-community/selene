///|
/// Permanently deletes this entity and its descendants in the active World.
/// Removes archetype rows, invalidates the handles, and recycles their slots.
/// Queue deletion through commands when traversing an archetype query.
fn Entity::delete(self : Entity) -> Bool {
  let world = require_current_world()
  guard self.belongs_to(world) else { false }
  let store = entity_store(world~)
  guard store.archetypes.slot(self) is Some(root) else { false }
  store.archetypes.require_no_query()

  store.unlink_child(root, self)
  let pending = [self]
  while pending.pop() is Some(entity) {
    guard entity.belongs_to(world) &&
      store.archetypes.slot(entity) is Some(slot) else {
      continue
    }
    if slot.children is Some(children) {
      pending.append(children[:])
    }
    if slot.location is Some((id, row)) {
      store.archetypes.remove_entity_row(entity, id, row)
    }
    if store.all_entities.contains(entity) {
      if slot.state is Some(Alive) || slot.state is Some(PendingRespawn) {
        store.alive_count -= 1
      }
      store.all_entities.remove(entity)
    }
    store.release_slot(entity, slot)
  }
  true
}

///|
#doc(hidden)
pub fn Entity::runtime_delete(
  self : Entity,
  _access : @ecs_access.Access,
) -> Bool {
  self.delete()
}
