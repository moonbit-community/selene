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
  let entries = Map([(first_entity, 10), (second_entity, 20)])
  let query = @query.query(first, entries)
  let visited = []
  query.for_each((entity, value) => visited.push((entity, value)))
  assert_eq(visited, [(first_entity, 10)])
  assert_eq(query.iter(), visited)

  let reader : @query.QueryReader[Int32] = QueryReader()
  assert_eq(reader.read(first, entries).added, [(first_entity, 10)])
  entries.set(first_entity, 11)
  assert_eq(reader.read(first, entries).changed, [(first_entity, 11)])
  let delta = reader.read(second, entries)
  assert_eq(delta.added, [(second_entity, 20)])
  assert_true(delta.removed.is_empty())
  assert_true(delta.changed.is_empty())
}
