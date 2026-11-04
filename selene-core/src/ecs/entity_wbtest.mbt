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
  flush_entity_lifecycle(require_current_world())
  inspect(alive_entity_count(), content="\{baseline}")
}

///|
test "reserved spawn increments alive count on flush" {
  let baseline = alive_entity_count()
  let world = require_current_world()
  let entity = commands(world).spawn()
  inspect(alive_entity_count(), content="\{baseline}")
  run_schedule(world, _ => ())
  inspect(alive_entity_count(), content="\{baseline + 1}")
  entity.destroy()
  inspect(alive_entity_count(), content="\{baseline}")
  flush_entity_lifecycle(require_current_world())
}

///|
test "same local ID in two worlds cannot alias lifecycle or hierarchy" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let first = World()
  let second = World()
  set_current_world(first)
  let entity = Entity()
  set_current_world(second)
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
  flush_entity_lifecycle(require_current_world())
  assert_true(other.is_alive())
  assert_true(other.get_parent() is None)
  assert_eq(alive_entity_count(), 1)
  set_current_world(first)
  assert_true(entity.is_alive())
  entity.destroy()
  flush_entity_lifecycle(require_current_world())
  assert_false(entity.is_alive())
  assert_false(alive_in_first(entity))
  entity.respawn()
  flush_entity_lifecycle(require_current_world())
  assert_true(entity.is_alive())
}
