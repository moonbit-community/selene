///|
test "a cached query sees new tables and repairs swapped rows after deletion" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let query = make_query2(a, b)
  let plan = a.spawn_plan(world).combine(b.spawn_plan(world))
  let matches = () => {
    let result = []
    for entity, (x, y) in query {
      result.push((entity.id(), x, y))
    }
    result
  }
  assert_true(matches().is_empty())
  run_schedule(world, _ => {
    let first = plan.spawn((11, "first"))
    let second = plan.spawn((22, "second"))
    if matches() != [(first.id(), 11, "first"), (second.id(), 22, "second")] {
      abort("missing rows")
    }
    if !first.delete() {
      abort("first row was not deleted")
    }
    a.set(second, 23)
    if matches() != [(second.id(), 23, "second")] {
      abort("incorrect survivor")
    }
  })
}

///|
test "archetype signatures support more than 64 components and isolate worlds" {
  let world = World()
  let other = World()
  let draft = commands(world).draft()
  let foreign = other.spawn(())
  let stores : Array[ComponentStore[Int32]] = []
  for i in 0..<70 {
    let store = ComponentStore(world)
    draft.add_to(store, i)
    stores.push(store)
  }
  let entity = draft.spawn()
  assert_eq(entity.id(), foreign.id())
  let query = make_query2(stores[0], stores[69])
  let result = []
  for _, (first, last) in query {
    result.push((first, last))
  }
  assert_eq(result, [(0, 69)])
  assert_eq(stores[35].get(entity), Some(35))
  assert_eq(stores[69].get(entity), Some(69))
  assert_eq(stores[0].get(foreign), None)
  result.clear()
  for _, (first, last) in query {
    result.push((first, last))
  }
  assert_eq(result, [(0, 69)])
}

///|
test "batch row replacement preserves alignment across tables" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[Int32] = ComponentStore(world)
  let tag : ComponentStore[Unit] = ComponentStore(world)
  let plan = a.spawn_plan(world).combine(b.spawn_plan(world))
  let first = plan.spawn((2, 3))
  let second = plan.combine(tag.spawn_plan(world)).spawn(((5, 7), ()))
  let unmatched = a.spawn_plan(world).spawn(11)
  let query = make_query2(a, b)
  let batches = []
  query.batches(batch => {
    batches.push(batch.length())
    for row in 0..<batch.length() {
      let (left, right) = batch.get(row)
      batch.set(row, (left + right, right))
    }
  })
  assert_eq(batches, [1, 1])
  assert_eq(a.get(first), Some(5))
  assert_eq(a.get(second), Some(12))
  assert_eq(a.get(unmatched), Some(11))
  assert_eq(b.get(first), Some(3))
  assert_eq(b.get(second), Some(7))
  run_schedule(world, _ => {
    if !first.delete() {
      abort("first row was not deleted")
    }
  })
  let entries = []
  query.batches(batch => {
    for row in 0..<batch.length() {
      let (left, right) = batch.get(row)
      entries.push((batch.entity(row).id(), left, right))
    }
  })
  assert_eq(entries, [(second.id(), 12, 7)])
}

///|
test "explicit component snapshots allow deletion during traversal" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let plan = a.spawn_plan(world)
  let first = plan.spawn(1)
  let second = plan.spawn(2)
  let third = plan.spawn(3)
  let seen = []
  run_schedule(world, _ => {
    for (entity, Single(value)) in make_query1(a).to_array() {
      seen.push(value)
      if entity == second {
        if !entity.delete() {
          abort("row was not deleted")
        }
      }
    }
  })
  assert_eq(seen, [1, 2, 3])
  assert_eq(
    make_query1(a).iter().map(entry => (entry.0, entry.1.0)).collect(),
    [(first, 1), (third, 3)],
  )
}

///|
test "three to five column queries follow new tables and recycled slots" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let c : ComponentStore[Bool] = ComponentStore(world)
  let d : ComponentStore[Int32] = ComponentStore(world)
  let e : ComponentStore[Int32] = ComponentStore(world)
  let three = make_query3(a, b, c)
  let four = make_query4(a, b, c, d)
  let five = make_query5(a, b, c, d, e)
  let four_plan = a
    .spawn_plan(world)
    .combine(b.spawn_plan(world))
    .combine(c.spawn_plan(world))
    .combine(d.spawn_plan(world))
  let five_plan = four_plan.combine(e.spawn_plan(world))
  let first = five_plan.spawn(((((10, "label"), true), 40), 50))
  let second = four_plan.spawn((((11, "label"), false), 40))

  let three_values = []
  for _, (value, label, flag) in three {
    three_values.push((value, label, flag))
  }
  assert_eq(three_values, [(10, "label", true), (11, "label", false)])
  let four_values = []
  four.batches(batch => {
    for row in 0..<batch.length() {
      four_values.push(batch.get(row))
    }
  })
  assert_eq(four_values, [(10, "label", true, 40), (11, "label", false, 40)])
  let five_values = []
  for _, (value, label, flag, fourth, fifth) in five {
    five_values.push((value, label, flag, fourth, fifth))
  }
  assert_eq(five_values, [(10, "label", true, 40, 50)])
  five_values.clear()
  five.batches(batch => {
    for row in 0..<batch.length() {
      let (a, b, c, d, e) = batch.get(row)
      batch.set(row, (a + d + e, b, c, d, e))
    }
  })
  assert_eq(five.get(first), Some((100, "label", true, 40, 50)))
  assert_eq(five.get(second), None)
  assert_eq(four.get(second), Some((11, "label", false, 40)))
  assert_eq(three.get(second), Some((11, "label", false)))
  let foreign = commands(World()).spawn(())
  assert_eq(foreign.slot_index(), first.slot_index())
  assert_eq(five.get(foreign), None)

  assert_true(first.delete())
  let replacement = five_plan.spawn(((((20, "new"), true), 42), 52))
  assert_eq(replacement.slot_index(), first.slot_index())
  assert_eq(five.get(first), None)
  assert_eq(five.get(replacement), Some((20, "new", true, 42, 52)))
  for _, (value, label, flag, fourth, fifth) in five {
    five_values.push((value, label, flag, fourth, fifth))
  }
  assert_eq(five_values, [(20, "new", true, 42, 52)])
}

///|
test "panic joined queries reject stores from another world" {
  let own : ComponentStore[Int32] = ComponentStore(World())
  let foreign : ComponentStore[Int32] = ComponentStore(World())
  ignore(make_query5(own, own, own, own, foreign))
}

///|
test "panic a value write cannot add a column to an entity" {
  let world = World()
  let store : ComponentStore[Int32] = ComponentStore(world)
  store.set(world.spawn(()), 1)
}

///|
test "panic a value write cannot address an entity from another World" {
  let world = World()
  let store : ComponentStore[Int32] = ComponentStore(world)
  let other = World()
  let foreign : ComponentStore[Int32] = ComponentStore(other)
  ignore(store.spawn_plan(world).spawn(1))
  store.set(foreign.spawn_plan(other).spawn(2), 3)
}
