///|
fn[T : Bundle] World::spawn(
  self : World,
  values : T,
  parent? : Entity,
) -> Entity {
  commands(self).prepare_spawn().spawn(values, parent?)
}

///|
fn SpawnDraft::spawn(self : SpawnDraft, parent? : Entity) -> Entity {
  self.take_plan().spawn((), parent?)
}

///|
/// Creates a live entity and appends all bundle values to one archetype row.
fn[T] SpawnPlan::spawn(
  self : SpawnPlan[T],
  values : T,
  parent? : Entity,
) -> Entity {
  if parent is Some(parent) &&
    (
      parent.world_id != self.world_id ||
      !self.entities.accepts_deferred_child(parent)
    ) {
    abort("parent must be alive in this World")
  }
  self.entities.archetypes.require_no_query()
  let entity = self.entities.spawn(self.world_id)
  self.append_row(entity, values)
  self.entities.link_child(entity, parent)
  entity
}

///|
fn EntityWorldStore::spawn(
  self : EntityWorldStore,
  world_id : UInt32,
) -> Entity {
  let entity = self.allocate(world_id, Alive)
  self.archetypes.slots[entity.slot].materialized = true
  self.all_entities.add(entity)
  self.alive_count += 1
  entity
}
