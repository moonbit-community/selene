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
  let active = @ecs_test.spawn(first, ())
  let commands = @ecs.commands(second)
  let components : @ecs.Query[@ecs.Single[Position]] = second.query()
  let entity = commands.spawn1(Position(30))
  assert_eq(components.get(entity).map(value => value.0), None)
  @ecs.Schedule().run(second)
  assert_eq(@ecs.require_current_world().id(), first.id())
  assert_true(entity.belongs_to(second))
  assert_eq(components.get(entity).map(value => value.0), Some(Position(30)))
  assert_eq(components.get(active).map(value => value.0), None)
  assert_true(active.is_alive())
  @ecs.set_current_world(second)
  assert_true(entity.is_alive())
  @ecs.set_current_world(first)
  commands.despawn(entity)
  @ecs.Schedule().run(second)
  assert_true(active.is_alive())
  @ecs.set_current_world(second)
  assert_false(entity.is_alive())
  assert_eq(components.get(entity).map(value => value.0), Some(Position(30)))
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
  let a : @ecs.Query[@ecs.Single[Position]] = world.query()
  let b : @ecs.Query[@ecs.Single[Label]] = world.query()
  let tag : @ecs.Query[@ecs.Single[Tagged]] = world.query()
  let bundle : @ecs.SpawnPlan[(Position, Label)] = @ecs.commands(world).prepare_spawn()
  let first = commands.spawn_prepared(bundle, (Position(11), Label("first")))
  let tagged : @ecs.SpawnPlan[(Position, Label, Tagged)] = @ecs.commands(world).prepare_spawn()
  let second = commands.spawn_prepared(
    tagged,
    (Position(22), Label("second"), Tagged(true)),
  )
  let alive = @ecs.alive_in_world(world)
  assert_false(alive(first))
  assert_eq(a.get(first).map(value => value.0), None)
  commands.add(world => world.set_component(first, Position(12)))
  @ecs.Schedule().run(world)
  assert_eq(@ecs.require_current_world().id(), active.id())
  assert_eq(a.get(first).map(value => value.0), Some(Position(12)))
  assert_eq(b.get(first).map(value => value.0), Some(Label("first")))
  assert_eq(a.get(second).map(value => value.0), Some(Position(22)))
  assert_eq(b.get(second).map(value => value.0), Some(Label("second")))
  assert_eq(tag.get(second).map(value => value.0), Some(Tagged(true)))
  assert_true(alive(first))
  assert_true(alive(second))
}

///|
test "permanent commands remove pending entities and recycle their slots" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let queue = @ecs.commands(world)
  let components : @ecs.Query[@ecs.Single[Position]] = world.query()
  let pending = queue.spawn1(Position(99))
  assert_true(@ecs_test.delete(pending))
  let entity = @ecs_test.spawn1(world, Position(10))
  assert_eq(entity.slot_index(), pending.slot_index())
  @ecs.Schedule().run(world)
  assert_eq(components.get(entity).map(value => value.0), Some(Position(10)))
  queue.delete(entity)
  @ecs.Schedule().run(world)
  assert_false(entity.is_valid_in(world))
  assert_eq(components.get(entity).map(value => value.0), None)
  assert_eq(@ecs_test.spawn(world, ()).slot_index(), entity.slot_index())
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
  @ecs.Schedule().run(world)
  assert_eq(parent.get_children(), [first, second])
  assert_eq(first.get_parent(), Some(parent))
  assert_true(second.is_alive())
  assert_false(canceled.is_valid_in(world))
  let recycled = @ecs_test.spawn(world, ())
  assert_eq(recycled.slot_index(), canceled.slot_index())
  assert_eq(recycled.get_parent(), None)
}

///|
test "panic deferred spawn rejects a parent in another World" {
  let parent = @ecs_test.spawn(World(), ())
  ignore(@ecs.commands(World()).spawn((), parent~))
}

///|
test "despawning a newly initialized parent also suspends its pending child" {
  let world = @ecs.World()
  let queue = @ecs.commands(world)
  let values : @ecs.Query[@ecs.Single[Position]] = world.query()
  let parent = queue.spawn(())
  let child = queue.spawn1(Position(42), parent~)
  queue.despawn(parent)
  @ecs.Schedule().run(world)
  let alive = @ecs.alive_in_world(world)
  assert_false(alive(parent))
  assert_false(alive(child))
  assert_eq(values.get(child).map(value => value.0), Some(Position(42)))

  @ecs.Schedule()
  .add_exclusive_system(_ => {
    @ecs.commands(@ecs.require_current_world()).respawn(parent)
  })
  .run(world)
  assert_true(alive(parent))
  assert_true(alive(child))
  assert_eq(values.get(child).map(value => value.0), Some(Position(42)))
}

///|
#derive(Eq, Debug)
struct Label(String)

///|
let key_label : @ecs.ComponentKey[Label] = ComponentKey()

///|
impl @ecs.Component for Label with fn component_key() {
  key_label
}

///|
#derive(Eq, Debug)
struct Tagged(Bool)

///|
let key_tagged : @ecs.ComponentKey[Tagged] = ComponentKey()

///|
impl @ecs.Component for Tagged with fn component_key() {
  key_tagged
}

///|
test "draft commands preserve pending parent order and later value writes" {
  let world = @ecs.World()
  let other = @ecs.World()
  let queue = @ecs.commands(world)
  let parent = queue.spawn1(Position(1))
  let draft = @ecs.commands(world).draft()
  draft.add(Position(2))
  let child = queue.spawn_draft(draft, parent~)
  let query : @ecs.Query[@ecs.Single[Position]] = world.query1()
  assert_true(query.is_empty())
  assert_false(world.is_alive(parent))
  assert_false(world.is_alive(child))
  queue.add(world => world.set_component(child, Position(3)))
  @ecs.Schedule().run(other)
  assert_true(query.is_empty())
  @ecs.Schedule().run(world)
  assert_eq(query.get(child), Some(Single(Position(3))))
  assert_eq(world.get_parent(child), Some(parent))
  assert_eq(world.get_children(parent), [child])
  queue.despawn(parent)
  assert_true(world.is_alive(child))
  @ecs.Schedule().run(world)
  assert_false(world.is_alive(child))
  assert_true(query.contains(child))
  queue.respawn(parent)
  @ecs.Schedule().run(world)
  assert_true(world.is_alive(child))
  queue.delete(parent)
  assert_true(child.is_valid_in(world))
  @ecs.Schedule().run(world)
  assert_false(parent.is_valid_in(world))
  assert_false(child.is_valid_in(world))
  assert_true(query.is_empty())
}

///|
test "panic a draft cannot be queued in another World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let draft = @ecs.commands(first).draft()
  draft.add(Position(1))
  ignore(@ecs.commands(second).spawn_draft(draft))
}
