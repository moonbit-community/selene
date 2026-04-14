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

///|
test "app: run_frames advances startup/update/fixed/render schedules deterministically" {
  let world = @ecs.World::new()
  let startup_count : Ref[Int] = { val: 0 }
  let update_count : Ref[Int] = { val: 0 }
  let fixed_count : Ref[Int] = { val: 0 }
  let render_count : Ref[Int] = { val: 0 }

  let app = App::new()
    .with_world(world)
    .with_fixed_hz(30)
    .add_system(@system.Startup, fn(_world) { startup_count.val += 1 })
    .add_system(@system.Update, fn(_world) { update_count.val += 1 })
    .add_system(@system.FixedUpdate, fn(_world) { fixed_count.val += 1 })
    .add_system(@system.Render, fn(_world) { render_count.val += 1 })
  app.run_frames(2, raw_delta=1.0 / 30.0)

  inspect(startup_count.val, content="1")
  inspect(update_count.val, content="2")
  inspect(fixed_count.val, content="2")
  inspect(render_count.val, content="2")
}

///|
test "app: step_fixed advances only fixed schedule after startup" {
  let world = @ecs.World::new()
  let startup_count : Ref[Int] = { val: 0 }
  let update_count : Ref[Int] = { val: 0 }
  let fixed_count : Ref[Int] = { val: 0 }

  let app = App::new()
    .with_world(world)
    .add_system(@system.Startup, fn(_world) { startup_count.val += 1 })
    .add_system(@system.Update, fn(_world) { update_count.val += 1 })
    .add_system(@system.FixedUpdate, fn(_world) { fixed_count.val += 1 })
  app.step_fixed(3)

  inspect(startup_count.val, content="1")
  inspect(update_count.val, content="0")
  inspect(fixed_count.val, content="3")
}

///|
test "app: deterministic ordering sorts systems by name when enabled" {
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  @runtime_debug.set_deterministic_mode({
    rng_seed: 1U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: true,
  })
  let order : Ref[String] = { val: "" }
  let app = App::new()
    .with_world(world)
    .add_system(
      @system.Update,
      fn(_world) { order.val = order.val + "b" },
      system_name="b",
    )
    .add_system(
      @system.Update,
      fn(_world) { order.val = order.val + "a" },
      system_name="a",
    )
  app.run_frames(1, raw_delta=1.0 / 60.0)
  inspect(order.val, content="ab")
}

///|
test "app: deterministic ordering keeps insertion order when disabled" {
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  @runtime_debug.set_deterministic_mode({
    rng_seed: 1U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: false,
  })
  let order : Ref[String] = { val: "" }
  let app = App::new()
    .with_world(world)
    .add_system(
      @system.Update,
      fn(_world) { order.val = order.val + "b" },
      system_name="b",
    )
    .add_system(
      @system.Update,
      fn(_world) { order.val = order.val + "a" },
      system_name="a",
    )
  app.run_frames(1, raw_delta=1.0 / 60.0)
  inspect(order.val, content="ba")
}
