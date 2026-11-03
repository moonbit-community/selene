///|
pub(all) struct Commands {
  world : @ecs.World
}

///|
pub fn commands(world : @ecs.World) -> Commands {
  { world, }
}

///|
pub fn Commands::add(self : Commands, command : (@ecs.World) -> Unit) -> Unit {
  self.world.queue_command(command)
}

///|
pub fn Commands::spawn(self : Commands) -> @entity.Entity {
  @entity.Entity::reserve_spawn_in(self.world)
}

///|
/// Queues an entity with its initial archetype components and returns its pending handle.
pub fn[T] Commands::spawn_bundle(
  self : Commands,
  bundle : @entity.SpawnBundle[T],
  values : T,
) -> @entity.Entity {
  bundle.queue_spawn(self.world, values)
}

///|
pub fn Commands::despawn(self : Commands, entity : @entity.Entity) -> Unit {
  self.add(fn(_world) { entity.destroy() })
}

///|
/// Queues permanent deletion and slot recycling for this entity and its descendants.
pub fn Commands::delete(self : Commands, entity : @entity.Entity) -> Unit {
  self.add(_ => ignore(entity.delete()))
}

///|
pub fn[T] Commands::send(
  self : Commands,
  events : @event.Events[T],
  event : T,
) -> Unit {
  self.add(fn(_world) { events.send(event) })
}

///|
pub fn[T] Commands::trigger(
  self : Commands,
  events : @event.Events[T],
  event : T,
  target : @entity.Entity?,
) -> Unit {
  self.add(fn(_world) { events.trigger(event, target) })
}

///|
pub fn has_pending_commands(world : @ecs.World) -> Bool {
  world.has_pending_commands()
}

///|
pub fn commands_flush_system(world : @ecs.World, _delta : Double) -> Unit {
  world.flush_commands()
}

///|
/// Queues an insertion into an archetype component store.
pub fn[T] Commands::insert_component(
  self : Commands,
  storage : @entity.ComponentStore[T],
  entity : @entity.Entity,
  value : T,
) -> Unit {
  guard entity.belongs_to(self.world) else { return }
  self.add(_ => storage.set(entity, value))
}

///|
/// Queues a removal from an archetype component store.
pub fn[T] Commands::remove_component(
  self : Commands,
  storage : @entity.ComponentStore[T],
  entity : @entity.Entity,
) -> Unit {
  guard entity.belongs_to(self.world) else { return }
  self.add(_ => storage.remove(entity))
}
