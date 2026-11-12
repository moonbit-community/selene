///|
test "entity side tables preserve insertion order across removal and reuse" {
  let world = @ecs.World()
  let table : @ecs.EntityTable[Int32] = EntityTable(world)
  let entities = [
    @ecs_runtime.spawn(world, ()),
    @ecs_runtime.spawn(world, ()),
    @ecs_runtime.spawn(world, ()),
    @ecs_runtime.spawn(world, ()),
  ]
  for index, entity in entities {
    table.set(entity, index)
  }
  table.set(entities[1], 10)
  assert_eq(table.remove_and_get(entities[1]), Some(10))
  assert_eq(table.remove_and_get(entities[1]), None)
  assert_eq(table.get(entities[3]), Some(3))
  debug_inspect(table.values().collect(), content="[0, 2, 3]")
  table.set(entities[1], 11)
  debug_inspect(table.values().collect(), content="[0, 2, 3, 11]")
  table.retain((_, value) => value % 2 == 1)
  debug_inspect(table.values().collect(), content="[3, 11]")
  assert_eq(table.length(), 2)
  table.remove(entities[3])
  table.remove(entities[1])
  assert_true(table.is_empty())
  table.set(entities[0], 20)
  table.clear()
  assert_false(table.contains(entities[0]))
  assert_true(table.keys().next() is None)
  table.set(entities[2], 30)
  debug_inspect(table.values().collect(), content="[30]")
}

///|
test "entity side tables distinguish Worlds and generations while retaining orphan cleanup data" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  let old = @ecs_runtime.spawn(first, ())
  let other = @ecs_runtime.spawn(second, ())
  let table : @ecs.EntityTable[Int32] = EntityTable(first)
  table.set(old, 42)
  assert_eq(table.get(other), None)
  assert_eq(table.remove_and_get(other), None)
  assert_true(@ecs_runtime.delete(old))
  let replacement = @ecs_runtime.spawn(first, ())
  assert_eq(replacement.slot_index(), old.slot_index())
  assert_eq(table.get(replacement), None)
  // External resource cleanup must still be able to read the deleted handle.
  assert_eq(table.remove_and_get(old), Some(42))
  table.set(replacement, 100)
  table.remove(old)
  assert_eq(table.get(replacement), Some(100))
  assert_true(@ecs_runtime.delete(replacement))
  let newest = @ecs_runtime.spawn(first, ())
  table.set(newest, 200)
  assert_eq(table.get(replacement), Some(100))
  assert_eq(table.get(newest), Some(200))
  assert_eq(table.length(), 2)
  table.retain((entity, _) => entity.is_valid_in(first))
  assert_eq(table.get(replacement), None)
  assert_eq(table.length(), 1)
  let calls = Ref(0)
  assert_eq(
    table.get_or_init(newest, () => {
      calls.val += 1
      0
    }),
    200,
  )
  assert_eq(calls.val, 0)
}

///|
test "panic entity side tables reject writes from a different World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let table : @ecs.EntityTable[Int32] = EntityTable(first)
  table.set(@ecs_runtime.spawn(second, ()), 1)
}

///|
test "panic stale entity side table writes cannot replace a newer generation" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let old = @ecs_runtime.spawn(world, ())
  ignore(@ecs_runtime.delete(old))
  let replacement = @ecs_runtime.spawn(world, ())
  let table : @ecs.EntityTable[Int32] = EntityTable(world)
  table.set(replacement, 2)
  table.set(old, 1)
}

///|
test "multiple orphan generations survive slot reuse until explicitly released" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let table : @ecs.EntityTable[Int32] = EntityTable(world)
  let generations = []
  for value in 0..<4 {
    let entity = @ecs_runtime.spawn(world, ())
    table.set(entity, value)
    generations.push(entity)
    ignore(@ecs_runtime.delete(entity))
  }
  assert_eq(generations[0].slot_index(), generations[3].slot_index())
  assert_eq(table.remove_and_get(generations[1]), Some(1))
  assert_eq(table.get(generations[0]), Some(0))
  assert_eq(table.remove_and_get(generations[3]), Some(3))
  assert_eq(table.get(generations[2]), Some(2))
  debug_inspect(table.values().collect(), content="[0, 2]")
  table.clear()
  let entity = @ecs_runtime.spawn(world, ())
  table.set(entity, 4)
  assert_eq(table.length(), 1)
  assert_eq(table.get(generations[0]), None)
  assert_eq(table.get(entity), Some(4))
}
