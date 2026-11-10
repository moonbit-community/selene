///|
test "deletion repairs archetype rows and a stale handle cannot touch a recycled slot" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let values : ComponentStore[Int32] = ComponentStore(world)
  let labels : ComponentStore[String] = ComponentStore(world)
  let bundle = values.spawn_plan(world).combine(labels.spawn_plan(world))
  let old = bundle.spawn((10, "old"))
  let survivor = bundle.spawn((20, "survivor"))
  assert_true(old.delete())
  assert_eq(values.get(survivor), Some(20))
  assert_eq(labels.get(survivor), Some("survivor"))

  let replacement = world.spawn(())
  assert_eq(replacement.slot_index(), old.slot_index())
  assert_eq(replacement.generation, old.generation + 1U)
  assert_true(replacement.id() != old.id())
  values.set(old, 99)
  assert_eq(values.get(replacement), None)
  values.set(replacement, 30)
  values.set(old, 99)
  values.remove(old)
  assert_eq(values.get(old), None)
  assert_eq(values.get(replacement), Some(30))
  old.destroy()
  old.respawn()
  assert_false(old.delete())
  flush_entity_lifecycle(require_current_world())
  assert_false(old.is_valid_in(world))
  assert_false(old.is_alive())
  assert_true(replacement.is_alive())
  assert_eq(alive_entity_count(), 2)
}

///|
test "recoverable destruction keeps the slot until a permanent subtree deletion" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let parent = world.spawn(())
  let root = parent.spawn_child()
  let child = root.spawn_child()
  let values : ComponentStore[Int32] = ComponentStore(world)
  values.set(child, 42)
  root.destroy()
  flush_entity_lifecycle(require_current_world())
  let spare = world.spawn(())
  assert_true(spare.slot_index() != root.slot_index())
  assert_true(root.is_valid_in(world))
  root.respawn()
  flush_entity_lifecycle(require_current_world())
  assert_true(child.is_alive())
  assert_eq(values.get(child), Some(42))

  assert_true(root.delete())
  assert_true(parent.get_children().is_empty())
  assert_eq(child.get_parent(), None)
  assert_false(child.is_valid_in(world))
  assert_eq(values.get(child), None)
  spare.set_parent(root)
  assert_eq(spare.get_parent(), None)
  assert_eq(alive_entity_count(), 2)
}

///|
test "an exhausted generation retires the slot without wrapping" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let first = world.spawn(())
  assert_true(first.delete())
  entity_store().archetypes.slots[first.slot].generation = 0xffffffffU
  let last = world.spawn(())
  assert_eq(last.slot_index(), first.slot_index())
  assert_eq(last.generation, 0xffffffffU)
  assert_true(last.delete())
  assert_false(last.is_valid_in(world))
  assert_true(world.spawn(()).slot_index() != last.slot_index())
}

///|
test "generation rejects every previous occupant while the same slot is live again" {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let values : ComponentStore[Int32] = ComponentStore(world)
  let bundle = values.spawn_plan(world)
  let retired : Array[Entity] = []
  for generation in 0..<32 {
    let current = bundle.spawn(generation)
    assert_eq(current.slot_index(), 0)
    assert_eq(current.generation, generation.reinterpret_as_uint())
    assert_true(current.is_alive())
    for stale in retired {
      // The slot has a live row, so lookup must validate the generation.
      assert_eq(stale.slot_index(), current.slot_index())
      assert_eq(values.get(stale), None)
      values.set(stale, -1)
    }
    assert_eq(values.get(current), Some(generation))
    assert_true(current.delete())
    retired.push(current)
  }
  assert_eq(entity_store().archetypes.slots.length(), 1)
}
