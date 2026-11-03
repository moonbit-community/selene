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
