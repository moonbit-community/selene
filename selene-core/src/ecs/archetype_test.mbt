///|
test "cached archetype query follows component migration and repairs swapped rows" {
  let world = @ecs.World()
  let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let b : @ecs.ComponentStore[String] = ComponentStore(world)
  let c : @ecs.ComponentStore[Bool] = ComponentStore(world)
  let first = @ecs.commands(world).spawn(())
  let second = @ecs.commands(world).spawn(())
  let query = @ecs.Query2(a, b)
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
  let entity = @ecs.commands(world).spawn(())
  let foreign = @ecs.commands(other).spawn(())
  assert_eq(entity.id(), foreign.id())
  let stores : Array[@ecs.ComponentStore[Int32]] = []
  for i in 0..<70 {
    let store = @ecs.ComponentStore(world)
    store.set(entity, i)
    store.set(foreign, -1)
    stores.push(store)
  }
  let query = @ecs.Query2(stores[0], stores[69])
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
  let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let b : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let tag : @ecs.ComponentStore[Unit] = ComponentStore(world)
  let first = @ecs.commands(world).spawn(())
  let second = @ecs.commands(world).spawn(())
  let unmatched = @ecs.commands(world).spawn(())
  a.set(first, 2)
  b.set(first, 3)
  a.set(second, 5)
  b.set(second, 7)
  tag.set(second, ())
  a.set(unmatched, 11)
  let query = @ecs.Query2(a, b)
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
  let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let b : @ecs.ComponentStore[Bool] = ComponentStore(world)
  let first = @ecs.commands(world).spawn(())
  let second = @ecs.commands(world).spawn(())
  let third = @ecs.commands(world).spawn(())
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

///|
test "three to five column queries follow new tables and recycled slots" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let b : @ecs.ComponentStore[String] = ComponentStore(world)
  let c : @ecs.ComponentStore[Bool] = ComponentStore(world)
  let d : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let e : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let three = @ecs.Query3(a, b, c)
  let four = @ecs.Query4(a, b, c, d)
  let five = @ecs.Query5(a, b, c, d, e)
  let first = world.spawn(())
  let second = world.spawn(())
  for entity in [first, second] {
    a.set(entity, 10 + entity.slot_index())
    b.set(entity, "label")
    c.set(entity, entity == first)
    d.set(entity, 40)
  }

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
  assert_true(five_values.is_empty())
  e.set(first, 50)
  five.for_each_batch_mut_a((_, a, _, _, d, e) => {
    for row in 0..<a.length() {
      a[row] += d[row] + e[row]
    }
  })
  assert_eq(five.get(first), Some((100, "label", true, 40, 50)))
  assert_eq(five.get(second), None)
  assert_eq(four.get(second), Some((11, "label", false, 40)))
  assert_eq(three.get(second), Some((11, "label", false)))
  let foreign = @ecs.commands(@ecs.World()).spawn(())
  assert_eq(foreign.slot_index(), first.slot_index())
  assert_eq(five.get(foreign), None)

  e.set(second, 51)
  b.remove(first)
  assert_eq(five.get(first), None)
  assert_true(first.delete())
  let replacement = world.spawn(())
  assert_eq(replacement.slot_index(), first.slot_index())
  a.set(replacement, 20)
  b.set(replacement, "new")
  c.set(replacement, true)
  d.set(replacement, 42)
  e.set(replacement, 52)
  assert_eq(five.get(first), None)
  assert_eq(five.get(replacement), Some((20, "new", true, 42, 52)))
  five.for_each((_, value, label, flag, fourth, fifth) => {
    five_values.push((value, label, flag, fourth, fifth))
  })
  assert_eq(five_values, [
    (11, "label", false, 40, 51),
    (20, "new", true, 42, 52),
  ])
}

///|
test "panic joined queries reject stores from another world" {
  let own : @ecs.ComponentStore[Int32] = ComponentStore(@ecs.World())
  let foreign : @ecs.ComponentStore[Int32] = ComponentStore(@ecs.World())
  ignore(@ecs.Query5(own, own, own, own, foreign))
}
