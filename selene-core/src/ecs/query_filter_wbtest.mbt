///|
test "structural filters run once per archetype rather than once per row" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let single = a.spawn_plan(world)
  let pair = single.combine(b.spawn_plan(world))
  let entity = pair.spawn((1, "first"))
  for i in 0..<100 {
    ignore(single.spawn(i))
  }
  let matched = Ref(0)
  let base = make_query1(a)
  let query = base.with_filters([
    {
      world_id: world.id(),
      accepts: id => {
        matched.val += 1
        b.column(id) is Some(_)
      },
    },
  ])
  assert_eq(query.length(), 1)
  let scanned = matched.val
  assert_eq(scanned, 2)
  for _ in 0..<3 {
    for _, _ in query {

    }
    assert_true(query.get(entity) is Some(_))
  }
  assert_eq(matched.val, scanned)
  let tag : ComponentStore[Unit] = ComponentStore(world)
  ignore(pair.combine(tag.spawn_plan(world)).spawn(((2, "new"), ())))
  assert_eq(query.length(), 2)
  assert_eq(matched.val, scanned + 1)
}

///|
test "query iterator construction reads no rows and early exit reads only demand" {
  let world = World()
  let store : ComponentStore[Int32] = ComponentStore(world)
  let plan = store.spawn_plan(world)
  for i in 0..<100 {
    ignore(plan.spawn(i))
  }
  let reads = Ref(0)
  let binds = Ref(0)
  let base = make_query1(store)
  let query = Query(
    world.id(),
    store.storage,
    store.order,
    id => {
      binds.val += 1
      (base.bind)(id).map(column => {
        ..column,
        read: row => {
          reads.val += 1
          (column.read)(row)
        },
      })
    },
    [],
  )
  let entries : Iter[(Entity, Single[Int32])] = query.iter()
  let pairs = query.iter2()
  assert_eq(binds.val, 0)
  assert_eq(reads.val, 0)
  assert_eq(entries.take(1).collect().map(entry => entry.1.0), [0])
  assert_eq(reads.val, 1)
  assert_eq(pairs.next().unwrap().1.0, 0)
  assert_eq(reads.val, 2)
  let keys = query.keys()
  ignore(keys.next())
  assert_eq(reads.val, 2)
}
