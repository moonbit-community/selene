///|
test "query traversal and reader snapshots are scoped to their world" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let entries : @ecs.ComponentStore[Int32] = ComponentStore(first)
  let other : @ecs.ComponentStore[Int32] = ComponentStore(second)
  let first_entity = entries.spawn_plan(first).spawn(10)
  let second_entity = other.spawn_plan(second).spawn(20)
  @ecs.set_current_world(second)
  let query = @ecs.query(first, entries)
  let visited = []
  query.for_each((entity, value) => visited.push((entity, value)))
  assert_eq(visited, [(first_entity, 10)])
  assert_eq(query.iter(), visited)

  let reader : @ecs.QueryReader[Int32] = QueryReader()
  assert_eq(reader.read(first, entries).added, [(first_entity, 10)])
  entries.set(first_entity, 11)
  assert_eq(reader.read(first, entries).changed, [(first_entity, 11)])
  let delta = reader.read(second, other)
  assert_eq(delta.added, [(second_entity, 20)])
  assert_true(delta.removed.is_empty())
  assert_true(delta.changed.is_empty())
}

///|
test "component queries report a permanently deleted handle as removed" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let entries : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let plan = entries.spawn_plan(world)
  let old = plan.spawn(10)
  let reader : @ecs.QueryReader[Int32] = QueryReader()
  assert_eq(reader.read(world, entries).added, [(old, 10)])
  assert_true(old.delete())
  let replacement = plan.spawn(20)
  assert_eq(replacement.slot_index(), old.slot_index())
  let delta = reader.read(world, entries)
  assert_eq(delta.removed, [old])
  assert_eq(delta.added, [(replacement, 20)])
  assert_eq(@ecs.query(world, entries).iter(), [(replacement, 20)])
}
