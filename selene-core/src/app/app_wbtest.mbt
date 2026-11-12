///|
let plugin_calls : Array[String] = []

///|
fn plugin_add_startup_system(app : App) -> App {
  app.add_system(
    Startup,
    fn(_ : Unit) { plugin_calls.push("plugin_startup") },
    system_name="plugin_startup",
  )
}

///|
fn plugin_a(app : App) -> App {
  app.add_system(
    Startup,
    fn(_ : Unit) { plugin_calls.push("plugin_a") },
    system_name="plugin_a",
  )
}

///|
fn plugin_b(app : App) -> App {
  app.add_system(
    Startup,
    fn(_ : Unit) { plugin_calls.push("plugin_b") },
    system_name="plugin_b",
  )
}

///|
test "app: add_plugin applies plugin immediately" {
  plugin_calls.clear()
  let app = App().add_plugin(plugin_add_startup_system)
  inspect(app.systems.length(), content="1")
  app.run_frames(1)
  assert_eq(plugin_calls, ["plugin_startup"])
}

///|
test "app: add_plugins preserves plugin order" {
  plugin_calls.clear()
  let app = App().add_plugins([plugin_a, plugin_b])
  inspect(app.systems.length(), content="2")
  app.run_frames(1)
  assert_eq(plugin_calls, ["plugin_a", "plugin_b"])
}

///|
test "app: add_message registers buses to final world" {
  let events : @event.Events[Int32] = Events()
  let world_a = @ecs.World()
  let world_b = @ecs.World()
  let reader_a : @event.EventReader[Int32] = EventReader()
  let reader_b : @event.EventReader[Int32] = EventReader()

  let app = App().with_world(world_a).add_message(events).with_world(world_b)
  for register in app.event_registrations {
    register(app.world)
  }

  @ecs.set_current_world(world_b)
  events.send(1)
  @event.event_frame_update_system(0.0)
  @event.event_frame_update_system(0.0)
  inspect(events.read(reader_b).length(), content="0")

  @ecs.set_current_world(world_a)
  events.send(2)
  @event.event_frame_update_system(0.0)
  @event.event_frame_update_system(0.0)
  let reader_events = events.read(reader_a)
  inspect(reader_events.length(), content="1")
  inspect(reader_events[0], content="2")

  @ecs.set_current_world(@ecs.bootstrap_world())
}

///|
test "app: run_frames advances startup/update/fixed/render schedules deterministically" {
  let world = @ecs.World()
  let startup_count : Ref[Int32] = { val: 0, }
  let update_count : Ref[Int32] = { val: 0, }
  let fixed_count : Ref[Int32] = { val: 0, }
  let render_count : Ref[Int32] = { val: 0, }

  let app = App()
    .with_world(world)
    .with_fixed_hz(30)
    .add_system(Startup, fn(_ : Unit) { startup_count.val += 1 })
    .add_system(Update, fn(_ : Unit) { update_count.val += 1 })
    .add_system(FixedUpdate, fn(_ : Unit) { fixed_count.val += 1 })
    .add_system(Render, fn(_ : Unit) { render_count.val += 1 })
  app.run_frames(2, raw_delta=1.0 / 30.0)

  inspect(startup_count.val, content="1")
  inspect(update_count.val, content="2")
  inspect(fixed_count.val, content="2")
  inspect(render_count.val, content="2")
}

///|
test "app: headless frames service platform maintenance around game and render" {
  let world = @ecs.World()
  let trace : Ref[String] = { val: "", }
  let app = App()
    .with_world(world)
    .add_system(
      Update,
      fn(_ : Unit) { trace.val = trace.val + "g" },
      system_name="update_trace",
    )
    .add_system(
      Render,
      fn(_ : Unit) { trace.val = trace.val + "r" },
      system_name="render_trace",
    )
  setup_runtime_world(app)
  let plan = build_runtime_plan(app)
  startup_runtime(plan)
  let accumulator : Ref[Double] = { val: 0.0, }

  run_headless_frame(plan, accumulator, 1.0 / 60.0, None, fn() {
    trace.val = trace.val + "s"
  })

  inspect(trace.val, content="sgrs")
}

///|
test "app: step_fixed advances only fixed schedule after startup" {
  let world = @ecs.World()
  let startup_count : Ref[Int32] = { val: 0, }
  let update_count : Ref[Int32] = { val: 0, }
  let fixed_count : Ref[Int32] = { val: 0, }

  let app = App()
    .with_world(world)
    .add_system(Startup, fn(_ : Unit) { startup_count.val += 1 })
    .add_system(Update, fn(_ : Unit) { update_count.val += 1 })
    .add_system(FixedUpdate, fn(_ : Unit) { fixed_count.val += 1 })
  app.step_fixed(3)

  inspect(startup_count.val, content="1")
  inspect(update_count.val, content="0")
  inspect(fixed_count.val, content="3")
}

///|
test "app: deterministic ordering sorts systems by name when enabled" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @runtime_debug.set_deterministic_mode({
    rng_seed: 1U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: true,
  })
  let order : Ref[String] = { val: "", }
  let app = App()
    .with_world(world)
    .add_system(
      Update,
      fn(_ : Unit) { order.val = order.val + "b" },
      system_name="b",
    )
    .add_system(
      Update,
      fn(_ : Unit) { order.val = order.val + "a" },
      system_name="a",
    )
  app.run_frames(1, raw_delta=1.0 / 60.0)
  inspect(order.val, content="ab")
}

///|
test "app: deterministic ordering keeps insertion order when disabled" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @runtime_debug.set_deterministic_mode({
    rng_seed: 1U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: false,
  })
  let order : Ref[String] = { val: "", }
  let app = App()
    .with_world(world)
    .add_system(
      Update,
      fn(_ : Unit) { order.val = order.val + "b" },
      system_name="b",
    )
    .add_system(
      Update,
      fn(_ : Unit) { order.val = order.val + "a" },
      system_name="a",
    )
  app.run_frames(1, raw_delta=1.0 / 60.0)
  inspect(order.val, content="ba")
}

///|
test "app: run_frames_capture provides a generic capture pipeline without game-specific systems" {
  let world = @ecs.World()
  let app = App().with_world(world)
  let captures = app.run_frames_capture(
    2,
    capture_width=64,
    capture_height=64,
    raw_delta=1.0 / 60.0,
  )
  inspect(captures.length(), content="0")
}

///|
test "app: run_frames_capture accepts selected frame indexes" {
  let world = @ecs.World()
  let rendered_frames : Array[Int32] = []
  let capture_attempts : Array[Int32] = []
  let app = App()
    .with_world(world)
    .add_system(
      Render,
      fn(_ : Unit) { rendered_frames.push(rendered_frames.length()) },
      system_name="render_frame_counter",
    )
  let captures = app.run_frames_capture_with(
    4,
    1.0 / 60.0,
    None,
    Some([2147483647, -1, -2147483647 - 1, 3, 1, 1, 10]),
    fn(frame_index) {
      capture_attempts.push(frame_index)
      None
    },
  )
  inspect(rendered_frames.length(), content="4")
  debug_inspect(capture_attempts, content="[1, 3]")
  inspect(captures.length(), content="0")
}

///|
test "app: render frame does not perform platform service work implicitly" {
  let world = @ecs.World()
  let trace : Ref[String] = { val: "", }
  let app = App()
    .with_world(world)
    .add_system(
      Render,
      fn(_ : Unit) { trace.val = trace.val + "r" },
      system_name="render_trace",
    )
  setup_runtime_world(app)
  let plan = build_runtime_plan(app)
  startup_runtime(plan)

  run_render_frame(plan, 1.0 / 60.0)

  inspect(trace.val, content="r")
}

///|
test "render limits do not determine headless simulation time" {
  assert_eq(App().max_fps, None)
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for cap in [None, Some(30U), Some(120U)] {
    let world = @ecs.World()
    let mut elapsed = 0.0
    let mut fixed_steps = 0
    let app = { ..App().with_world(world).with_fixed_hz(60), max_fps: cap, }
      .add_system(Update, fn(_ : Unit) { elapsed += @time.delta() })
      .add_system(FixedUpdate, fn(_ : Unit) { fixed_steps += 1 })
    app.run_frames(60, raw_delta=0.0)
    assert_true((elapsed - 1.0).abs() < 0.000001)
    assert_eq(fixed_steps, 60)
  }
}
