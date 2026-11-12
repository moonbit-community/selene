///|
test "a cached query sees new tables and repairs swapped rows after deletion" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let query = Query2(a, b)
  let plan = a.spawn_plan(world).combine(b.spawn_plan(world))
  let matches = () => {
    let result = []
    query.for_each((entity, x, y) => result.push((entity.id(), x, y)))
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
  let draft = world.spawn_draft()
  let foreign = other.spawn(())
  let stores : Array[ComponentStore[Int32]] = []
  for i in 0..<70 {
    let store = ComponentStore(world)
    draft.add_to(store, i)
    stores.push(store)
  }
  let entity = draft.spawn()
  assert_eq(entity.id(), foreign.id())
  let query = Query2(stores[0], stores[69])
  let result = []
  query.for_each((_, first, last) => result.push((first, last)))
  assert_eq(result, [(0, 69)])
  assert_eq(stores[35].get(entity), Some(35))
  assert_eq(stores[69].get(entity), Some(69))
  assert_eq(stores[0].get(foreign), None)
  result.clear()
  query.for_each((_, first, last) => result.push((first, last)))
  assert_eq(result, [(0, 69)])
}

///|
test "batch views stay aligned across tables and write only the first column" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[Int32] = ComponentStore(world)
  let tag : ComponentStore[Unit] = ComponentStore(world)
  let plan = a.spawn_plan(world).combine(b.spawn_plan(world))
  let first = plan.spawn((2, 3))
  let second = plan.combine(tag.spawn_plan(world)).spawn(((5, 7), ()))
  let unmatched = a.spawn_plan(world).spawn(11)
  let query = Query2(a, b)
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
  run_schedule(world, _ => {
    if !first.delete() {
      abort("first row was not deleted")
    }
  })
  let entries = []
  query.for_each_batch((entities, left, right) => {
    for row in 0..<entities.length() {
      entries.push((entities[row].id(), left[row], right[row]))
    }
  })
  assert_eq(entries, [(second.id(), 12, 7)])
}

///|
test "component iteration preserves spawn order when the current row is deleted" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let plan = a.spawn_plan(world)
  let first = plan.spawn(1)
  let second = plan.spawn(2)
  let third = plan.spawn(3)
  let seen = []
  run_schedule(world, _ => {
    for entity, value in a {
      seen.push(value)
      if entity == second {
        if !entity.delete() {
          abort("row was not deleted")
        }
      }
    }
  })
  assert_eq(seen, [1, 2, 3])
  assert_eq(a.to_array(), [(first, 1), (third, 3)])
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
  let three = Query3(a, b, c)
  let four = Query4(a, b, c, d)
  let five = Query5(a, b, c, d, e)
  let four_plan = a
    .spawn_plan(world)
    .combine(b.spawn_plan(world))
    .combine(c.spawn_plan(world))
    .combine(d.spawn_plan(world))
  let five_plan = four_plan.combine(e.spawn_plan(world))
  let first = five_plan.spawn(((((10, "label"), true), 40), 50))
  let second = four_plan.spawn((((11, "label"), false), 40))

  let three_values = []
  three.for_each((_, value, label, flag) => {
    three_values.push((value, label, flag))
  })
  assert_eq(three_values, [(10, "label", true), (11, "label", false)])
  let four_values = []
  four.for_each_batch((_, a, b, c, d) => {
    for row in 0..<a.length() {
      four_values.push((a[row], b[row], c[row], d[row]))
    }
  })
  assert_eq(four_values, [(10, "label", true, 40), (11, "label", false, 40)])
  let five_values = []
  five.for_each((_, value, label, flag, fourth, fifth) => {
    five_values.push((value, label, flag, fourth, fifth))
  })
  assert_eq(five_values, [(10, "label", true, 40, 50)])
  five_values.clear()
  five.for_each_batch_mut_a((_, a, _, _, d, e) => {
    for row in 0..<a.length() {
      a[row] += d[row] + e[row]
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
  five.for_each((_, value, label, flag, fourth, fifth) => {
    five_values.push((value, label, flag, fourth, fifth))
  })
  assert_eq(five_values, [(20, "new", true, 42, 52)])
}

///|
test "panic joined queries reject stores from another world" {
  let own : ComponentStore[Int32] = ComponentStore(World())
  let foreign : ComponentStore[Int32] = ComponentStore(World())
  ignore(Query5(own, own, own, own, foreign))
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
