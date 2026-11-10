///|
test "commands reserve and flush entities in the queue's world" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  @ecs.set_current_world(first)
  let active = first.spawn(())
  let commands = @ecs.commands(second)
  let components : @ecs.ComponentStore[Int32] = ComponentStore(second)
  let entity = commands.spawn_prepared(components.spawn_plan(second), 30)
  assert_eq(components.get(entity), None)
  @ecs.run_schedule(second, _ => ())
  assert_eq(@ecs.require_current_world().id(), first.id())
  assert_true(entity.belongs_to(second))
  assert_eq(components.get(entity), Some(30))
  assert_eq(components.get(active), None)
  assert_true(active.is_alive())
  @ecs.set_current_world(second)
  assert_true(entity.is_alive())
  @ecs.set_current_world(first)
  commands.despawn(entity)
  @ecs.run_schedule(second, _ => ())
  assert_true(active.is_alive())
  @ecs.set_current_world(second)
  assert_false(entity.is_alive())
  assert_eq(components.get(entity), Some(30))
}

///|
test "deferred bundles initialize before later commands in the queue's world" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let active = @ecs.World()
  @ecs.set_current_world(active)
  let world = @ecs.World()
  let commands = @ecs.commands(world)
  let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let b : @ecs.ComponentStore[String] = ComponentStore(world)
  let tag : @ecs.ComponentStore[Bool] = ComponentStore(world)
  let bundle = a.spawn_plan(world).combine(b.spawn_plan(world))
  let first = commands.spawn_prepared(bundle, (11, "first"))
  let second = commands.spawn_prepared(
    bundle.combine(tag.spawn_plan(world)),
    ((22, "second"), true),
  )
  let alive = @ecs.alive_in_world(world)
  assert_false(alive(first))
  assert_eq(a.get(first), None)
  commands.add(_ => a.set(first, 12))
  @ecs.run_schedule(world, _ => ())
  assert_eq(@ecs.require_current_world().id(), active.id())
  assert_eq(a.get(first), Some(12))
  assert_eq(b.get(first), Some("first"))
  assert_eq(a.get(second), Some(22))
  assert_eq(b.get(second), Some("second"))
  assert_eq(tag.get(second), Some(true))
  assert_true(alive(first))
  assert_true(alive(second))
}

///|
test "permanent commands recycle a slot and skip canceled initialization" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let queue = @ecs.commands(world)
  let components : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let pending = queue.spawn_prepared(components.spawn_plan(world), 99)
  assert_true(pending.delete())
  let entity = components.spawn_plan(world).spawn(10)
  assert_eq(entity.slot_index(), pending.slot_index())
  @ecs.run_schedule(world, _ => ())
  assert_eq(components.get(entity), Some(10))
  queue.delete(entity)
  @ecs.run_schedule(world, _ => ())
  assert_false(entity.is_valid_in(world))
  assert_eq(components.get(entity), None)
  assert_eq(world.spawn(()).slot_index(), entity.slot_index())
}

///|
test "deferred children link in spawn order and cancel if their parent is deleted" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let queue = @ecs.commands(world)
  let parent = queue.spawn(())
  let first = queue.spawn((), parent~)
  let second = queue.spawn((), parent~)
  let deleted = queue.spawn(())
  queue.delete(deleted)
  let canceled = queue.spawn((), parent=deleted)
  assert_eq(first.get_parent(), None)
  @ecs.run_schedule(world, _ => ())
  assert_eq(parent.get_children(), [first, second])
  assert_eq(first.get_parent(), Some(parent))
  assert_true(second.is_alive())
  assert_false(canceled.is_valid_in(world))
  let recycled = world.spawn(())
  assert_eq(recycled.slot_index(), canceled.slot_index())
  assert_eq(recycled.get_parent(), None)
}

///|
test "panic immediate spawn rejects a parent in another World" {
  let parent = @ecs.World().spawn(())
  ignore(@ecs.World().spawn((), parent~))
}

///|
test "panic deferred spawn rejects a parent in another World" {
  let parent = @ecs.World().spawn(())
  ignore(@ecs.commands(World()).spawn((), parent~))
}

///|
test "despawning a newly initialized parent also suspends its pending child" {
  let world = @ecs.World()
  let queue = @ecs.commands(world)
  let values : @ecs.ComponentStore[Int32] = ComponentStore(world)
  let parent = queue.spawn(())
  let child = queue.spawn_prepared(values.spawn_plan(world), 42, parent~)
  queue.despawn(parent)
  @ecs.run_schedule(world, _ => ())
  let alive = @ecs.alive_in_world(world)
  assert_false(alive(parent))
  assert_false(alive(child))
  assert_eq(values.get(child), Some(42))

  @ecs.run_schedule(world, _ => parent.respawn())
  assert_true(alive(parent))
  assert_true(alive(child))
  assert_eq(values.get(child), Some(42))
}
