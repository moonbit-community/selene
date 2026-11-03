///|
test "alive entity count follows lifecycle-visible entities" {
  let baseline = alive_entity_count()
  let entity = Entity()
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  inspect(alive_entity_count(), content="\{baseline}")
  entity.respawn()
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  entity_flush_system(0.0)
  inspect(alive_entity_count(), content="\{baseline}")
}

///|
test "reserved spawn increments alive count on flush" {
  let baseline = alive_entity_count()
  let entity = Entity::reserve_spawn()
  inspect(alive_entity_count(), content="\{baseline}")
  entity_flush_system(0.0)
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  inspect(alive_entity_count(), content="\{baseline}")
  entity_flush_system(0.0)
}

///|
test "same local ID in two worlds cannot alias lifecycle or hierarchy" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  let entity = Entity()
  @ecs.set_current_world(second)
  let other = Entity()
  let alive_in_first = alive_in_world(first)
  assert_eq(entity.id(), other.id())
  assert_true(entity != other)
  assert_false(entity.is_alive())
  assert_true(alive_in_first(entity))
  assert_false(alive_in_first(other))
  entity.destroy()
  entity.respawn()
  other.set_parent(entity)
  entity_flush_system(0.0)
  assert_true(other.is_alive())
  assert_true(other.get_parent() is None)
  assert_eq(alive_entity_count(), 1)
  @ecs.set_current_world(first)
  assert_true(entity.is_alive())
  entity.destroy()
  entity_flush_system(0.0)
  assert_false(entity.is_alive())
  assert_false(alive_in_first(entity))
  entity.respawn()
  entity_flush_system(0.0)
  assert_true(entity.is_alive())
}
