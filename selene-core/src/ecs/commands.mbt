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
pub fn Commands::spawn(self : Commands) -> Entity {
  queue_entity_spawn(self.world, _ => ())
}

///|
/// Queues an entity with its initial archetype components and returns its pending handle.
pub fn[T] Commands::spawn_bundle(
  self : Commands,
  bundle : SpawnBundle[T],
  values : T,
) -> Entity {
  bundle.queue_spawn(self.world, values)
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
  !queues.get_or_insert_with(world, new_queues).pending.is_empty()
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
