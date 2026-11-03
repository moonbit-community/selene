///|
test "query traversal and reader snapshots are scoped to their world" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  let first_entity = @entity.Entity()
  @ecs.set_current_world(second)
  let second_entity = @entity.Entity()
  let entries : @entity.ComponentStore[Int32] = ComponentStore(first)
  let other : @entity.ComponentStore[Int32] = ComponentStore(second)
  entries.set(first_entity, 10)
  entries.set(second_entity, 99)
  other.set(second_entity, 20)
  let query = @query.query(first, entries)
  let visited = []
  query.for_each((entity, value) => visited.push((entity, value)))
  assert_eq(visited, [(first_entity, 10)])
  assert_eq(query.iter(), visited)

  let reader : @query.QueryReader[Int32] = QueryReader()
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
  let old = @entity.Entity()
  let entries : @entity.ComponentStore[Int32] = ComponentStore(world)
  entries.set(old, 10)
  let reader : @query.QueryReader[Int32] = QueryReader()
  assert_eq(reader.read(world, entries).added, [(old, 10)])
  assert_true(old.delete())
  let replacement = @entity.Entity()
  assert_eq(replacement.slot_index(), old.slot_index())
  entries.set(replacement, 20)
  let delta = reader.read(world, entries)
  assert_eq(delta.removed, [old])
  assert_eq(delta.added, [(replacement, 20)])
  assert_eq(@query.query(world, entries).iter(), [(replacement, 20)])
}
