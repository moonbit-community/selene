///|
test "query traversal and reader snapshots are scoped to their World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let first_entity = first.spawn1(Position(10))
  let second_entity = second.spawn1(Position(20))
  let query : @ecs.Query[Position] = first.query()
  let other : @ecs.Query[Position] = second.query()
  let visited = []
  query.for_each((entity, value) => visited.push((entity, value)))
  assert_eq(visited, [(first_entity, Position(10))])
  assert_eq(query.iter(), visited)
  assert_eq(query.get(second_entity), None)
  let reader : @ecs.QueryReader[Position] = QueryReader()
  assert_eq(reader.read(query).added, [(first_entity, Position(10))])
  first.set_component(first_entity, Position(11))
  assert_eq(reader.read(query).changed, [(first_entity, Position(11))])
  let delta = reader.read(other)
  assert_eq(delta.added, [(second_entity, Position(20))])
  assert_true(delta.removed.is_empty())
  assert_true(delta.changed.is_empty())
}

///|
test "component queries report a permanently deleted handle as removed" {
  let world = @ecs.World()
  let old = world.spawn1(Position(10))
  let query : @ecs.Query[Position] = world.query()
  let reader : @ecs.QueryReader[Position] = QueryReader()
  assert_eq(reader.read(query).added, [(old, Position(10))])
  @ecs.run_schedule(world, _ => ignore(old.delete()))
  let replacement = world.spawn1(Position(20))
  assert_eq(replacement.slot_index(), old.slot_index())
  let delta = reader.read(query)
  assert_eq(delta.removed, [old])
  assert_eq(delta.added, [(replacement, Position(20))])
  assert_eq(query.iter(), [(replacement, Position(20))])
}

///|
test "multi-column queries are constructed from the owning World" {
  let world = @ecs.World()
  let other = @ecs.World()
  let one = world.spawn1(Position(1))
  let both = world.spawn((Position(2), Speed(3)))
  let foreign = other.spawn((Position(9), Speed(8)))
  let two : @ecs.Query2[Position, Speed] = world.query2()
  let three : @ecs.Query3[Position, Speed, Position] = world.query3()
  let four : @ecs.Query4[Position, Speed, Position, Speed] = world.query4()
  let five : @ecs.Query5[Position, Speed, Position, Speed, Position] = world.query5()
  assert_eq(two.get(both), Some((Position(2), Speed(3))))
  assert_eq(three.get(both), Some((Position(2), Speed(3), Position(2))))
  assert_eq(
    four.get(both),
    Some((Position(2), Speed(3), Position(2), Speed(3))),
  )
  assert_eq(
    five.get(both),
    Some((Position(2), Speed(3), Position(2), Speed(3), Position(2))),
  )
  assert_eq(two.get(one), None)
  assert_eq(five.get(foreign), None)
  let visited = []
  five.for_each((entity, a, b, _, _, _) => visited.push((entity, a, b)))
  assert_eq(visited, [(both, Position(2), Speed(3))])
  world.set_component(both, Speed(4))
  assert_eq(two.get(both), Some((Position(2), Speed(4))))
}

///|
test "filters require a World and cannot expose its component store" {
  let world = @ecs.World()
  let other = @ecs.World()
  let only = world.spawn1(Position(1))
  let both = world.spawn((Position(2), Speed(3)))
  let query : @ecs.Query[Position] = world.query()
  let with_speed : @ecs.With[Speed] = With(world)
  let without_speed : @ecs.Without[Speed] = Without(world)
  let foreign : @ecs.Without[Speed] = Without(other)
  assert_eq(query.iter(require_filters=[with_speed.to_filter()]), [
    (both, Position(2)),
  ])
  assert_eq(query.iter(require_filters=[without_speed.to_filter()]), [
    (only, Position(1)),
  ])
  assert_true(query.iter(require_filters=[foreign.to_filter()]).is_empty())
}

///|
test "panic point writes cannot add a component" {
  let world = @ecs.World()
  let entity = world.spawn1(Position(1))
  world.set_component(entity, Speed(2))
}

///|
test "panic point writes cannot target another World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let entity = first.spawn1(Position(1))
  second.set_component(entity, Position(2))
}

///|
test "panic point writes reject a deleted generation after slot reuse" {
  let world = @ecs.World()
  let old = world.spawn1(Position(1))
  @ecs.run_schedule(world, _ => ignore(old.delete()))
  ignore(world.spawn1(Position(2)))
  world.set_component(old, Position(3))
}
