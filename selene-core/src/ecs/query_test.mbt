///|
test "query traversal and reader snapshots are scoped to their World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let first_entity = @ecs_test.spawn1(first, Position(10))
  let second_entity = @ecs_test.spawn1(second, Position(20))
  let query : @ecs.Query[@ecs.Single[Position]] = first.query()
  let other : @ecs.Query[@ecs.Single[Position]] = second.query()
  let visited = []
  for entity, query_row in query {
    let value = query_row.0
    visited.push((entity, value))
  }
  assert_eq(visited, [(first_entity, Position(10))])
  assert_eq(query.iter().collect(), [(first_entity, Single(Position(10)))])
  assert_eq(query.get(second_entity).map(value => value.0), None)
  let reader : @ecs.QueryReader[@ecs.Single[Position]] = QueryReader()
  assert_eq(reader.read(query).added, [(first_entity, Single(Position(10)))])
  first.set_component(first_entity, Position(11))
  assert_eq(reader.read(query).changed, [(first_entity, Single(Position(11)))])
  let delta = reader.read(other)
  assert_eq(delta.added, [(second_entity, Single(Position(20)))])
  assert_true(delta.removed.is_empty())
  assert_true(delta.changed.is_empty())
}

///|
test "component queries report a permanently deleted handle as removed" {
  let world = @ecs.World()
  let old = @ecs_test.spawn1(world, Position(10))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query()
  let reader : @ecs.QueryReader[@ecs.Single[Position]] = QueryReader()
  assert_eq(reader.read(query).added, [(old, Single(Position(10)))])
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    @ecs.commands(@ecs.require_current_world()).delete(old)
  })
  .run(world)
  let replacement = @ecs_test.spawn1(world, Position(20))
  assert_eq(replacement.slot_index(), old.slot_index())
  let delta = reader.read(query)
  assert_eq(delta.removed, [old])
  assert_eq(delta.added, [(replacement, Single(Position(20)))])
  assert_eq(query.iter().collect(), [(replacement, Single(Position(20)))])
}

///|
test "multi-column queries are constructed from the owning World" {
  let world = @ecs.World()
  let other = @ecs.World()
  let one = @ecs_test.spawn1(world, Position(1))
  let both = @ecs_test.spawn(world, (Position(2), Speed(3)))
  let foreign = @ecs_test.spawn(other, (Position(9), Speed(8)))
  let two : @ecs.Query[(Position, Speed)] = world.query()
  let three : @ecs.Query[(Position, Speed, Position)] = world.query()
  let four : @ecs.Query[(Position, Speed, Position, Speed)] = world.query()
  let five : @ecs.Query[(Position, Speed, Position, Speed, Position)] = world.query()
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
  for entity, (a, b, _, _, _) in five {
    visited.push((entity, a, b))
  }
  assert_eq(visited, [(both, Position(2), Speed(3))])
  world.set_component(both, Speed(4))
  assert_eq(two.get(both), Some((Position(2), Speed(4))))
}

///|
test "filters require a World and cannot expose its component store" {
  let world = @ecs.World()
  let only = @ecs_test.spawn1(world, Position(1))
  let both = @ecs_test.spawn(world, (Position(2), Speed(3)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query()
  let with_speed : @ecs.With[Speed] = With(world)
  let without_speed : @ecs.Without[Speed] = Without(world)
  assert_eq(query.with_filters([with_speed.to_filter()]).iter().collect(), [
    (both, Single(Position(2))),
  ])
  assert_eq(query.with_filters([without_speed.to_filter()]).iter().collect(), [
    (only, Single(Position(1))),
  ])
}

///|
test "panic point writes cannot add a component" {
  let world = @ecs.World()
  let entity = @ecs_test.spawn1(world, Position(1))
  world.set_component(entity, Speed(2))
}

///|
test "panic point writes cannot target another World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let entity = @ecs_test.spawn1(first, Position(1))
  second.set_component(entity, Position(2))
}

///|
test "panic point writes reject a deleted generation after slot reuse" {
  let world = @ecs.World()
  let old = @ecs_test.spawn1(world, Position(1))
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    @ecs.commands(@ecs.require_current_world()).delete(old)
  })
  .run(world)
  ignore(@ecs_test.spawn1(world, Position(2)))
  world.set_component(old, Position(3))
}

///|
test "panic filters reject another World's identity" {
  let first = @ecs.World()
  let second = @ecs.World()
  let foreign : @ecs.Without[Speed] = Without(second)
  let query : @ecs.Query[@ecs.Single[Position]] = first.query(filters=[
    foreign.to_filter(),
  ])
  ignore(query.length())
}

///|
test "batch writes can select the second column or several columns" {
  let world = @ecs.World()
  let other = @ecs.World()
  let first = @ecs_test.spawn(world, (Position(1), Speed(2)))
  let second = @ecs_test.spawn(world, (Position(3), Speed(4), Tagged(true)))
  let unmatched = @ecs_test.spawn1(world, Position(9))
  let foreign = @ecs_test.spawn(other, (Position(7), Speed(8)))
  let query : @ecs.Query[(Position, Speed)] = world.query()
  let visited = []
  let mirrored = []
  query.batches(batch => {
    let positions : @ecs.WriteColumn[Position] = batch.write_column()
    let speeds : @ecs.WriteColumn[Speed] = batch.write_column()
    let observed : @ecs.ReadColumn[Position] = batch.read_column()
    for row in 0..<batch.length() {
      positions[row] = Position(positions[row].0 + 10)
      speeds[row] = Speed(speeds[row].0 + 20)
      mirrored.push(observed[row] == positions[row])
      visited.push(batch.entity(row))
    }
  })
  assert_eq(visited, [first, second])
  assert_eq(mirrored, [true, true])
  assert_eq(query.get(first), Some((Position(11), Speed(22))))
  assert_eq(query.get(second), Some((Position(13), Speed(24))))
  assert_eq(world.get_component(unmatched), Some(Position(9)))
  assert_eq(other.get_component(foreign), Some(Position(7)))
  assert_eq(other.get_component(foreign), Some(Speed(8)))
  query.batches(batch => {
    let speeds : @ecs.WriteColumn[Speed] = batch.write_column()
    for row in 0..<speeds.length() {
      speeds[row] = Speed(0)
    }
  })
  assert_eq(query.get(second), Some((Position(13), Speed(0))))
}

///|
test "filtered queries apply the same matching rules to every operation" {
  let world = @ecs.World()
  let first = @ecs_test.spawn(world, (Position(1), Speed(2), Tagged(true)))
  let second = @ecs_test.spawn(world, (Position(3), Speed(4)))
  let third = @ecs_test.spawn1(world, Position(5))
  let included : @ecs.With[Tagged] = With(world)
  let excluded : @ecs.Without[Tagged] = Without(world)
  let filters = [included.to_filter()]
  let query : @ecs.Query[(Position, Speed)] = world.query(filters~)
  filters.clear()
  assert_eq(query.length(), 1)
  assert_eq(query.single(), Some((first, (Position(1), Speed(2)))))
  assert_eq(query.get(second), None)
  assert_eq(query.get(third), None)
  assert_false(query.contains(second))
  assert_eq(query.keys().collect(), [first])
  assert_eq(query.values().collect(), [(Position(1), Speed(2))])
  let batched = []
  query.batches(batch => {
    for row in 0..<batch.length() {
      batched.push(batch.entity(row))
    }
  })
  assert_eq(batched, [first])
  let without : @ecs.Query[(Position, Speed)] = world.query(filters=[
    excluded.to_filter(),
  ])
  assert_eq(without.single(), Some((second, (Position(3), Speed(4)))))
  let fourth = @ecs_test.spawn(
    world,
    (Position(6), Speed(7), Tagged(true), Label("new table")),
  )
  assert_eq(query.length(), 2)
  assert_true(query.single() is None)
  assert_true(query.contains(fourth))
}

///|
test "query shapes support six through eight columns without new query types" {
  let world = @ecs.World()
  let entity = @ecs_test.spawn(world, (Position(1), Speed(2)))
  let six : @ecs.Query[(Position, Speed, Position, Speed, Position, Speed)] = world.query()
  let seven : @ecs.Query[
    (Position, Speed, Position, Speed, Position, Speed, Position),
  ] = world.query()
  let eight : @ecs.Query[
    (Position, Speed, Position, Speed, Position, Speed, Position, Speed),
  ] = world.query()
  assert_eq(six.get(entity).unwrap().5, Speed(2))
  assert_eq(seven.get(entity).unwrap().6, Position(1))
  assert_eq(eight.get(entity).unwrap().7, Speed(2))
  assert_eq(eight.single().unwrap().0, entity)
}

///|
test "query snapshots survive deletion and slot reuse explicitly" {
  let world = @ecs.World()
  let first = @ecs_test.spawn1(world, Position(1))
  let deleted = @ecs_test.spawn1(world, Position(2))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let snapshot = query.to_array()
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    @ecs.commands(@ecs.require_current_world()).delete(deleted)
    ignore(@ecs.commands(world).spawn1(Position(3)))
    world.set_component(first, Position(10))
  })
  .run(world)
  assert_eq(snapshot, [
    (first, Single(Position(1))),
    (deleted, Single(Position(2))),
  ])
  assert_eq(query.length(), 2)
}

///|
test "query iter and iter2 support ordinary loops across filtered archetypes" {
  let world = @ecs.World()
  let other = @ecs.World()
  ignore(@ecs_test.spawn1(world, Position(0)))
  let first = @ecs_test.spawn(world, (Position(1), Speed(2)))
  let second = @ecs_test.spawn(world, (Position(3), Speed(4), Tagged(true)))
  ignore(@ecs_test.spawn(other, (Position(8), Speed(9))))
  let query : @ecs.Query[(Position, Speed)] = world.query()
  let expected = [
    (first, (Position(1), Speed(2))),
    (second, (Position(3), Speed(4))),
  ]
  let singles = []
  for (entity, (position, speed)) in query {
    singles.push((entity, (position, speed)))
  }
  let pairs = []
  for entity, (position, speed) in query {
    pairs.push((entity, (position, speed)))
  }
  assert_eq(singles, expected)
  assert_eq(pairs, expected)
  let without : @ecs.Without[Tagged] = Without(world)
  let filtered = query.with_filters([without.to_filter()])
  assert_eq(filtered.iter().collect(), [expected[0]])
  assert_eq(filtered.iter2().iter().collect(), [expected[0]])
  let with_tag : @ecs.With[Tagged] = With(other)
  let empty : @ecs.Query[@ecs.Single[Speed]] = other.query1(filters=[
    with_tag.to_filter(),
  ])
  assert_eq(empty.iter().collect(), [])
  assert_eq(empty.iter2().iter().collect(), [])
}

///|
test "lazy query iterators observe value writes and ignore other World changes" {
  let world = @ecs.World()
  let other = @ecs.World()
  let first = @ecs_test.spawn1(world, Position(1))
  let second = @ecs_test.spawn1(world, Position(2))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let entries : Iter[(@ecs.Entity, @ecs.Single[Position])] = query.iter()
  let pairs = query.iter2()
  let values = query.values()
  world.set_component(first, Position(10))
  assert_eq(entries.next(), Some((first, Single(Position(10)))))
  assert_eq(pairs.next(), Some((first, Single(Position(10)))))
  assert_eq(values.next(), Some(Single(Position(10))))
  @ecs.Schedule()
  .add_exclusive_system(_ => world.set_component(second, Position(20)))
  .run(world)
  ignore(@ecs_test.spawn1(other, Position(99)))
  assert_eq(entries.next(), Some((second, Single(Position(20)))))
  assert_eq(pairs.next(), Some((second, Single(Position(20)))))
  assert_eq(values.next(), Some(Single(Position(20))))
  assert_eq(entries.next(), None)
  assert_eq(pairs.next(), None)
  ignore(@ecs_test.spawn1(world, Position(30)))
  assert_eq(entries.next(), None)
  assert_eq(pairs.next(), None)
}

///|
fn return_from_query(query : @ecs.Query[@ecs.Single[Position]]) -> Unit {
  for _ in query {
    return
  }
}

///|
test "early exit discarded and nested query iterators do not retain locks" {
  let world = @ecs.World()
  ignore(@ecs_test.spawn1(world, Position(1)))
  ignore(@ecs_test.spawn(world, (Position(2), Speed(3))))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  ignore(query.iter())
  ignore(query.iter2())
  for _ in query {
    break
  }
  return_from_query(query)
  let mut count = 0
  for _ in query {
    for _, _ in query {
      count += 1
    }
  }
  assert_eq(count, 4)
  @ecs.Schedule()
  .add_exclusive_system(_ => ignore(@ecs.commands(world).spawn1(Position(3))))
  .run(world)
  assert_eq(query.length(), 3)
}

///|
test "panic an escaped read column expires after its callback" {
  let world = @ecs.World()
  ignore(@ecs_test.spawn1(world, Position(1)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let saved : Ref[@ecs.ReadColumn[Position]?] = Ref(None)
  query.batches(batch => saved.val = Some(batch.read_column()))
  ignore(saved.val.unwrap()[0])
}

///|
test "panic an escaped write column expires after its callback" {
  let world = @ecs.World()
  ignore(@ecs_test.spawn1(world, Position(1)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let saved : Ref[@ecs.WriteColumn[Position]?] = Ref(None)
  query.batches(batch => saved.val = Some(batch.write_column()))
  saved.val.unwrap()[0] = Position(9)
}

///|
test "panic iter rejects a spawn before its first advance" {
  let world = @ecs.World()
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let entries = query.iter()
  ignore(@ecs_test.spawn1(world, Position(1)))
  ignore(entries.next())
}

///|
test "panic iter2 rejects deletion and reuse before reading the replacement" {
  let world = @ecs.World()
  let first = @ecs_test.spawn1(world, Position(1))
  ignore(@ecs_test.spawn1(world, Position(2)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let entries = query.iter2()
  ignore(entries.next())
  let replacement = Ref(None)
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    @ecs.commands(@ecs.require_current_world()).delete(first)
  })
  .run(world)
  replacement.val = Some(@ecs_test.spawn1(world, Position(3)))
  assert_eq(replacement.val.unwrap().slot_index(), first.slot_index())
  ignore(entries.next())
}

///|
test "panic keys rejects deletion before advancing linked order entries" {
  let world = @ecs.World()
  ignore(@ecs_test.spawn1(world, Position(1)))
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let keys = query.keys()
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    let entity = query.single().unwrap().0
    @ecs.commands(@ecs.require_current_world()).delete(entity)
  })
  .run(world)
  ignore(keys.next())
}

///|
test "query point writes replace matching rows without changing layouts or invalidating iterators" {
  let world = @ecs.World()
  let entity = @ecs.commands(world).spawn((Position(1), Speed(2)))
  let other = @ecs.commands(world).spawn((Position(3), Speed(4)))
  @ecs.Schedule().run(world)
  let positions : @ecs.Query[@ecs.Single[Position]] = world.query1()
  let pairs : @ecs.Query[(Position, Speed)] = world.query()
  let entries = pairs.iter()
  assert_eq(entries.next(), Some((entity, (Position(1), Speed(2)))))
  pairs.set(other, (Position(30), Speed(40)))
  assert_eq(entries.next(), Some((other, (Position(30), Speed(40)))))
  positions.set(entity, Single(Position(10)))
  assert_eq(pairs.get(entity), Some((Position(10), Speed(2))))
  assert_eq(pairs.length(), 2)
  assert_false(@ecs.has_pending_commands(world))
}

///|
test "filtered point writes use their own World without changing the active World" {
  let world = @ecs.World()
  let other = @ecs.World()
  let entity = @ecs.commands(world).spawn((Position(1), Speed(2)))
  @ecs.Schedule().run(world)
  let with_speed : @ecs.With[Speed] = With(world)
  let positions : @ecs.Query[@ecs.Single[Position]] = world.query1(filters=[
    with_speed.to_filter(),
  ])
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  @ecs.set_current_world(other)
  positions.set(entity, Single(Position(9)))
  assert_eq(positions.get(entity), Some(Single(Position(9))))
  assert_eq(@ecs.require_current_world().id(), other.id())
}

///|
test "panic a query cannot insert a missing component through a point write" {
  let world = @ecs.World()
  let entity = @ecs.commands(world).spawn1(Position(1))
  @ecs.Schedule().run(world)
  let speeds : @ecs.Query[@ecs.Single[Speed]] = world.query1()
  speeds.set(entity, Single(Speed(2)))
}

///|
test "panic a query cannot point-write a filtered-out entity" {
  let world = @ecs.World()
  let entity = @ecs.commands(world).spawn1(Position(1))
  @ecs.Schedule().run(world)
  let with_speed : @ecs.With[Speed] = With(world)
  let positions : @ecs.Query[@ecs.Single[Position]] = world.query1(filters=[
    with_speed.to_filter(),
  ])
  positions.set(entity, Single(Position(9)))
}

///|
test "panic a query cannot point-write a foreign entity" {
  let world = @ecs.World()
  let other = @ecs.World()
  let entity = @ecs.commands(other).spawn1(Position(1))
  @ecs.Schedule().run(other)
  let positions : @ecs.Query[@ecs.Single[Position]] = world.query1()
  positions.set(entity, Single(Position(9)))
}

///|
test "panic a query cannot point-write a recycled generation" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let entity = commands.spawn1(Position(1))
  @ecs.Schedule().run(world)
  commands.delete(entity)
  @ecs.Schedule().run(world)
  ignore(commands.spawn1(Position(2)))
  @ecs.Schedule().run(world)
  let positions : @ecs.Query[@ecs.Single[Position]] = world.query1()
  positions.set(entity, Single(Position(9)))
}
