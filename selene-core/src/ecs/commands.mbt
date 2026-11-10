///|
struct Commands {
  world : World
}

///|
pub fn commands(world : World) -> Commands {
  { world, }
}

///|
pub fn Commands::add(self : Commands, command : (World) -> Unit) -> Unit {
  enqueue(self.world, command)
}

///|
/// Queues a component value or tuple for insertion at the end of the schedule.
pub fn[T : Bundle] Commands::spawn(self : Commands, values : T) -> Entity {
  self.spawn_prepared(self.world.prepare_spawn(), values)
}

///|
/// Queues an entity with its initial archetype components and returns its pending handle.
pub fn[T] Commands::spawn_prepared(
  self : Commands,
  plan : SpawnPlan[T],
  values : T,
) -> Entity {
  plan.queue_spawn(self.world, values)
}

///|
pub fn Commands::despawn(self : Commands, entity : Entity) -> Unit {
  self.add(fn(_world) { entity.destroy() })
}

///|
/// Queues permanent deletion and slot recycling for this entity and its descendants.
pub fn Commands::delete(self : Commands, entity : Entity) -> Unit {
  self.add(_ => ignore(entity.delete()))
}

///|
pub fn has_pending_commands(world : World) -> Bool {
  !queues.get_or_insert_with(world, _ => CommandQueue()).pending.is_empty()
}

///|
/// Queues an insertion into an archetype component store.
pub fn[T] Commands::insert_component(
  self : Commands,
  storage : ComponentStore[T],
  entity : Entity,
  value : T,
) -> Unit {
  guard entity.belongs_to(self.world) else { return }
  self.add(_ => storage.set(entity, value))
}

///|
/// Queues a removal from an archetype component store.
pub fn[T] Commands::remove_component(
  self : Commands,
  storage : ComponentStore[T],
  entity : Entity,
) -> Unit {
  guard entity.belongs_to(self.world) else { return }
  self.add(_ => storage.remove(entity))
}
