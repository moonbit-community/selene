///|
fn plugin_add_startup_system(app : App) -> App {
  app.add_system(
    @system.Startup,
    fn(_world) { () },
    system_name="plugin_startup",
  )
}

///|
fn plugin_a(app : App) -> App {
  app.add_system(@system.Startup, fn(_world) { () }, system_name="plugin_a")
}

///|
fn plugin_b(app : App) -> App {
  app.add_system(@system.Startup, fn(_world) { () }, system_name="plugin_b")
}

///|
test "app: add_plugin applies plugin immediately" {
  let app = App::new().add_plugin(plugin_add_startup_system)
  inspect(app.systems.length(), content="1")
  inspect(app.systems[0].name, content="plugin_startup")
}

///|
test "app: add_plugins preserves plugin order" {
  let app = App::new().add_plugins([plugin_a, plugin_b])
  inspect(app.systems.length(), content="2")
  inspect(app.systems[0].name, content="plugin_a")
  inspect(app.systems[1].name, content="plugin_b")
}

///|
test "app: add_message registers buses to final world" {
  let events : @event.Events[Int] = @event.Events::new()
  let world_a = @ecs.World::new()
  let world_b = @ecs.World::new()
  let reader_a : @event.EventReader[Int] = @event.EventReader::new()
  let reader_b : @event.EventReader[Int] = @event.EventReader::new()

  let app = App::new()
    .with_world(world_a)
    .add_message(events)
    .with_world(world_b)
  for register in app.event_registrations {
    register(app.world)
  }

  @ecs.set_current_world(world_b)
  events.send(1)
  @event.event_frame_update_system(0.0)
  @event.event_frame_update_system(0.0)
  inspect(events.read(reader_b), content="[]")

  @ecs.set_current_world(world_a)
  events.send(2)
  @event.event_frame_update_system(0.0)
  @event.event_frame_update_system(0.0)
  inspect(events.read(reader_a), content="[2]")

  @ecs.set_current_world(@ecs.bootstrap_world())
}
