///|
test "a reusable bundle spawns directly into the final table" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let c : ComponentStore[Bool] = ComponentStore(world)
  let bundle = c
    .spawn_bundle()
    .combine(a.spawn_bundle().combine(b.spawn_bundle()))
  let first = bundle.spawn(world, (true, (11, "first")))
  let second = bundle.spawn(world, (false, (22, "second")))
  assert_eq(a.storage.tables.length(), 1)
  assert_eq(a.storage.tables[0].signature, [
    a.component,
    b.component,
    c.component,
  ])
  assert_eq(a.storage.tables[0].entities.map(entity => entity.id()), [
    first.id(),
    second.id(),
  ])
  assert_true(alive_in_world(world)(first))
  assert_eq(a.get(first), Some(11))
  assert_eq(b.get(second), Some("second"))
  assert_eq(c.get(second), Some(false))

  b.remove(first)
  assert_eq(b.get(first), None)
  assert_eq(c.get(first), Some(true))
  assert_eq(a.get(second), Some(22))
  assert_eq(b.get(second), Some("second"))
}

///|
test "panic a spawn bundle rejects a repeated component across layouts" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[Int32] = ComponentStore(world)
  let pair = a.spawn_bundle().combine(b.spawn_bundle())
  ignore(pair.combine(a.spawn_bundle()))
}

///|
test "panic a spawn bundle cannot allocate an entity in a foreign world" {
  let world = World()
  let other = World()
  let store : ComponentStore[Int32] = ComponentStore(world)
  ignore(store.spawn_bundle().spawn(other, 1))
}
