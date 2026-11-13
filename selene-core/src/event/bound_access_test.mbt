///|
test "bound event cursors and writers do not follow the active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let events : @event.Events[Int32] = Events()
  let reader : @event.EventReader[Int32] = EventReader()
  let first_reader = reader.bind(first, events)
  let second_reader = reader.bind(second, events)
  let first_writer = events.writer(world=first)
  let second_writer = events.writer(world=second)
  @ecs.set_current_world(second)
  first_writer.send(10)
  second_writer.send(20)
  @ecs.clear_current_world()
  assert_eq(first_reader.read(), [10])
  assert_eq(second_reader.read(), [20])
  first_writer.send(11)
  assert_eq(reader.bind(first, events).read(), [11])
  assert_eq(first_reader.read(), [])
  // Rebinding the same reader shares its cursor, not a copied cursor value.
  assert_eq(second_reader.read(), [])
}

///|
test "event maintenance uses the injected World's registry" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let events : @event.Events[Int32] = Events()
  let reader : @event.EventReader[Int32] = EventReader()
  events.register_to_world(first)
  events.register_to_world(second)
  let registry = @event.EventRegistry(first)
  events.writer(world=first).send(1)
  events.writer(world=second).send(2)
  @ecs.set_current_world(second)
  @event.event_frame_update_system(registry)
  @event.event_frame_update_system(registry)
  assert_eq(reader.bind(first, events).read(), [])
  assert_eq(reader.bind(second, events).read(), [2])
}
