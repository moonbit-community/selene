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
  ignore(self)
  @entity.Entity::reserve_spawn()
}

///|
pub fn Commands::despawn(self : Commands, entity : @entity.Entity) -> Unit {
  self.add(fn(_world) { entity.destroy() })
}

///|
pub fn[T] Commands::insert(
  self : Commands,
  storage : Map[@entity.Entity, T],
  entity : @entity.Entity,
  value : T,
) -> Unit {
  self.add(fn(_world) { storage.set(entity, value) })
}

///|
pub fn[T] Commands::remove(
  self : Commands,
  storage : Map[@entity.Entity, T],
  entity : @entity.Entity,
) -> Unit {
  self.add(fn(_world) { storage.remove(entity) })
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
