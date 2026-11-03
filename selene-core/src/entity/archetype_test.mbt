///|
test "cached archetype query follows component migration and repairs swapped rows" {
  let world = @ecs.World()
  let a : @entity.ComponentStore[Int32] = ComponentStore(world)
  let b : @entity.ComponentStore[String] = ComponentStore(world)
  let c : @entity.ComponentStore[Bool] = ComponentStore(world)
  let first = @entity.Entity::reserve_spawn_in(world)
  let second = @entity.Entity::reserve_spawn_in(world)
  let query = @entity.ArchetypeQuery2(a, b)
  let matches = () => {
    let result = []
    query.for_each((entity, x, y) => result.push((entity.id(), x, y)))
    result
  }
  a.set(first, 11)
  a.set(second, 22)
  assert_true(matches().is_empty())
  b.set(first, "first")
  b.set(second, "second")
  assert_eq(matches(), [(first.id(), 11, "first"), (second.id(), 22, "second")])
  c.set(first, true)
  assert_eq(a.get(second), Some(22))
  assert_eq(b.get(second), Some("second"))
  assert_eq(c.get(first), Some(true))
  assert_eq(matches(), [(second.id(), 22, "second"), (first.id(), 11, "first")])
  b.remove(first)
  assert_eq(matches(), [(second.id(), 22, "second")])
  a.set(second, 23)
  b.clear()
  assert_true(matches().is_empty())
  assert_eq(a.get(first), Some(11))
  assert_eq(a.get(second), Some(23))
  assert_eq(c.get(first), Some(true))
}

///|
test "archetype signatures support more than 64 components and isolate worlds" {
  let world = @ecs.World()
  let other = @ecs.World()
  let entity = @entity.Entity::reserve_spawn_in(world)
  let foreign = @entity.Entity::reserve_spawn_in(other)
  assert_eq(entity.id(), foreign.id())
  let stores : Array[@entity.ComponentStore[Int32]] = []
  for i in 0..<70 {
    let store = @entity.ComponentStore(world)
    store.set(entity, i)
    store.set(foreign, -1)
    stores.push(store)
  }
  let query = @entity.ArchetypeQuery2(stores[0], stores[69])
  let result = []
  query.for_each((_, first, last) => result.push((first, last)))
  assert_eq(result, [(0, 69)])
  stores[35].remove(entity)
  assert_eq(stores[35].get(entity), None)
  assert_eq(stores[69].get(entity), Some(69))
  assert_eq(stores[0].get(foreign), None)
  result.clear()
  query.for_each((_, first, last) => result.push((first, last)))
  assert_eq(result, [(0, 69)])
}

///|
test "batch views stay aligned across tables and write only the first column" {
  let world = @ecs.World()
  let a : @entity.ComponentStore[Int32] = ComponentStore(world)
  let b : @entity.ComponentStore[Int32] = ComponentStore(world)
  let tag : @entity.ComponentStore[Unit] = ComponentStore(world)
  let first = @entity.Entity::reserve_spawn_in(world)
  let second = @entity.Entity::reserve_spawn_in(world)
  let unmatched = @entity.Entity::reserve_spawn_in(world)
  a.set(first, 2)
  b.set(first, 3)
  a.set(second, 5)
  b.set(second, 7)
  tag.set(second, ())
  a.set(unmatched, 11)
  let query = @entity.ArchetypeQuery2(a, b)
  let batches = []
  query.for_each_batch_mut_a((entities, left, right) => {
    batches.push(entities.length())
    for row in 0..<entities.length() {
      left[row] = left[row] + right[row]
    }
  })
  assert_eq(batches, [1, 1])
  assert_eq(a.get(first), Some(5))
  assert_eq(a.get(second), Some(12))
  assert_eq(a.get(unmatched), Some(11))
  assert_eq(b.get(first), Some(3))
  assert_eq(b.get(second), Some(7))
  b.remove(first)
  let entries = []
  query.for_each_batch((entities, left, right) => {
    for row in 0..<entities.length() {
      entries.push((entities[row].id(), left[row], right[row]))
    }
  })
  assert_eq(entries, [(second.id(), 12, 7)])
}

///|
test "component iteration survives other column moves and removal of the current row" {
  let world = @ecs.World()
  let a : @entity.ComponentStore[Int32] = ComponentStore(world)
  let b : @entity.ComponentStore[Bool] = ComponentStore(world)
  let first = @entity.Entity::reserve_spawn_in(world)
  let second = @entity.Entity::reserve_spawn_in(world)
  let third = @entity.Entity::reserve_spawn_in(world)
  a.set(first, 1)
  a.set(second, 2)
  a.set(third, 3)
  let seen = []
  for entity, value in a {
    seen.push(value)
    b.set(entity, true)
    if entity == second {
      a.remove(entity)
    }
  }
  assert_eq(seen, [1, 2, 3])
  assert_eq(a.to_array(), [(first, 1), (third, 3)])
  assert_eq(b.keys().collect(), [first, second, third])
}
