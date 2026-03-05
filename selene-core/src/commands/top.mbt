///|
let queued_commands : Array[() -> Unit] = []

///|
pub(all) struct Commands {
  _tag : Unit
}

///|
pub fn commands() -> Commands {
  { _tag: () }
}

///|
pub fn Commands::add(self : Commands, command : () -> Unit) -> Unit {
  ignore(self)
  queued_commands.push(command)
}

///|
pub fn Commands::spawn(self : Commands) -> @entity.Entity {
  ignore(self)
  @entity.Entity::reserve_spawn()
}

///|
pub fn Commands::despawn(self : Commands, entity : @entity.Entity) -> Unit {
  self.add(fn() { entity.destroy() })
}

///|
pub fn[T] Commands::insert(
  self : Commands,
  storage : Map[@entity.Entity, T],
  entity : @entity.Entity,
  value : T,
) -> Unit {
  self.add(fn() { storage.set(entity, value) })
}

///|
pub fn[T] Commands::remove(
  self : Commands,
  storage : Map[@entity.Entity, T],
  entity : @entity.Entity,
) -> Unit {
  self.add(fn() { storage.remove(entity) })
}

///|
pub fn[T] Commands::send(
  self : Commands,
  events : @event.Events[T],
  event : T,
) -> Unit {
  self.add(fn() { events.send(event) })
}

///|
pub fn[T] Commands::trigger(
  self : Commands,
  events : @event.Events[T],
  event : T,
  target : @entity.Entity?,
) -> Unit {
  self.add(fn() { events.trigger(event, target) })
}

///|
pub fn has_pending_commands() -> Bool {
  queued_commands.length() > 0
}

///|
pub fn commands_flush_system(_delta : Double) -> Unit {
  if queued_commands.length() == 0 {
    return
  }
  let commands = queued_commands.copy()
  queued_commands.clear()
  for command in commands {
    command()
  }
}
