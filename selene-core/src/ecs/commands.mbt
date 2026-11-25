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
pub fn[T : Bundle] Commands::spawn(
  self : Commands,
  values : T,
  parent? : Entity,
) -> Entity {
  self.spawn_prepared(self.prepare_spawn(), values, parent?)
}

///|
/// Queues an entity with one component.
pub fn[T : Component] Commands::spawn1(
  self : Commands,
  value : T,
  parent? : Entity,
) -> Entity {
  let plan : SpawnPlan[T] = component_spawn_plan(self.world)
  self.spawn_prepared(plan, value, parent?)
}

///|
/// Queues an entity with its initial archetype components and returns its pending handle.
pub fn[T] Commands::spawn_prepared(
  self : Commands,
  plan : SpawnPlan[T],
  values : T,
  parent? : Entity,
) -> Entity {
  plan.queue_spawn(self.world, values, parent)
}

///|
/// Queues permanent removal of this entity and its descendants, recycling their slots.
pub fn Commands::despawn(self : Commands, entity : Entity) -> Unit {
  self.add(_ => ignore(entity.despawn()))
}

///|
/// Suspends this subtree without changing component layouts or entity handles.
pub fn Commands::disable(self : Commands, entity : Entity) -> Unit {
  self.add(_ => entity.disable())
}

///|
/// Reactivates this subtree. A disabled ancestor must be enabled first.
pub fn Commands::enable(self : Commands, entity : Entity) -> Unit {
  self.add(_ => entity.enable())
}

///|
pub fn has_pending_commands(world : World) -> Bool {
  !queues.get_or_insert_with(world, _ => CommandQueue()).pending.is_empty()
}
