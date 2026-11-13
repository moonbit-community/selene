///|
test "metadata parameters stay bound across Worlds and slot reuse" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let commands = @ecs.commands(first)
  let entities = @ecs.Entities(first)
  let hierarchy = @ecs.Hierarchy(first)
  let root = commands.spawn(())
  let child = commands.spawn((), parent=root)
  let foreign = @ecs.commands(second).spawn(())
  assert_true(entities.is_valid(root))
  assert_false(entities.is_alive(root))
  assert_false(entities.is_valid(foreign))
  @ecs.Schedule().run(first)
  @ecs.Schedule().run(second)
  @ecs.set_current_world(second)
  assert_true(entities.is_alive(root))
  assert_eq(entities.count(), 2)
  assert_eq(entities.iter().count(), 2)
  assert_eq(hierarchy.parent(child), Some(root))
  assert_eq(hierarchy.children(root), [child])
  assert_eq(hierarchy.parent(foreign), None)
  assert_eq(hierarchy.children(foreign), [])
  assert_eq(hierarchy.roots().collect(), [root])
  let snapshot = hierarchy.children(root)
  snapshot.clear()
  assert_eq(hierarchy.children(root), [child])
  commands.delete(child)
  @ecs.Schedule().run(first)
  let replacement = commands.spawn((), parent=root)
  @ecs.Schedule().run(first)
  assert_eq(replacement.slot_index(), child.slot_index())
  @ecs.clear_current_world()
  assert_false(entities.is_valid(child))
  assert_false(entities.is_alive(child))
  assert_true(entities.is_alive(replacement))
  assert_eq(hierarchy.parent(child), None)
  assert_eq(hierarchy.children(root), [replacement])
}

///|
test "metadata injection observes deferred lifecycle changes on later runs" {
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let root = commands.spawn(())
  let child = commands.spawn((), parent=root)
  let observed = []
  let schedule = @ecs.Schedule().add_system(
    @ecs.args2(fn(entities : @ecs.Entities, hierarchy : @ecs.Hierarchy) {
      observed.push((entities.is_alive(child), hierarchy.parent(child)))
    }),
  )
  schedule.run(world)
  schedule.run(world)
  commands.delete(root)
  schedule.run(world)
  schedule.run(world)
  assert_eq(observed, [
    (false, None),
    (true, Some(root)),
    (true, Some(root)),
    (false, None),
  ])
}
