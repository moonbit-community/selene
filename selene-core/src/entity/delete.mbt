///|
/// Permanently deletes this entity and its descendants in the active World.
/// Removes archetype rows, invalidates the handles, and recycles their slots.
/// Queue deletion through commands when traversing an archetype query.
pub fn Entity::delete(self : Entity) -> Bool {
  let world = @ecs.require_current_world()
  guard self.belongs_to(world) else { false }
  let store = world.get_or_init(entity_store_key)
  guard store.archetypes.slot(self) is Some(_) else { false }
  store.archetypes.require_no_query()

  let hierarchy = hierarchy_store()
  unlink_from_parent(self)
  let pending = [self]
  while pending.pop() is Some(entity) {
    guard entity.belongs_to(world) &&
      store.archetypes.slot(entity) is Some(slot) else {
      continue
    }
    if hierarchy.parents.get(entity) is Some(parent) {
      for child in parent.children {
        if hierarchy.children.get(child) is Some(link) && link.parent == entity {
          pending.push(child)
        }
      }
    }
    if slot.location is Some(location) {
      store.archetypes.move_row(entity, Some(location), None)
    }
    if store.all_entities.contains(entity) {
      if slot.state is Some(Alive) || slot.state is Some(PendingRespawn) {
        store.alive_count -= 1
      }
      store.all_entities.remove(entity)
    }
    store.pending_state_changes.remove(entity)
    slot.state = None
    // An exhausted generation retires its slot instead of reviving old handles.
    if slot.generation != 0xffffffffU {
      slot.generation += 1U
      store.free_slots.push(entity.slot)
    }
  }
  true
}
