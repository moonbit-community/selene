///|
/// Materializes fixture entities through the public scheduling boundary.
pub fn[T : @ecs.Bundle] spawn(
  world : @ecs.World,
  values : T,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  let entity = @ecs.commands(world).spawn(values, parent?)
  try! @ecs.Schedule().run(world)
  entity
}

///|
pub fn[T : @ecs.Component] spawn1(
  world : @ecs.World,
  value : T,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  spawn(world, @ecs.Single(value), parent?)
}

///|
pub fn spawn_draft(
  draft : @ecs.SpawnDraft,
  world~ : @ecs.World = @ecs.require_current_world(),
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  let entity = @ecs.commands(world).spawn_draft(draft, parent?)
  try! @ecs.Schedule().run(world)
  entity
}

///|
pub fn delete(entity : @ecs.Entity) -> Bool {
  let world = @ecs.require_current_world()
  let valid = entity.is_valid_in(world)
  @ecs.commands(world).delete(entity)
  try! @ecs.Schedule().run(world)
  valid
}

///|
pub fn destroy(entity : @ecs.Entity) -> Unit {
  let world = @ecs.require_current_world()
  @ecs.commands(world).despawn(entity)
  try! @ecs.Schedule().run(world)
}
