///|
fn with_runtime_debug_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
test "deterministic rng is reproducible with the same seed" {
  with_runtime_debug_world(fn() raise {
    set_deterministic_mode({
      rng_seed: 123U,
      fixed_delta_override: None,
      frame_delta_override: None,
      deterministic_ordering: true,
    })
    let first_a = next_deterministic_u32()
    let second_a = next_deterministic_u32()
    set_rng_seed(123U)
    let first_b = next_deterministic_u32()
    let second_b = next_deterministic_u32()
    inspect(first_a == first_b, content="true")
    inspect(second_a == second_b, content="true")
  })
}

///|
test "input queue supports event injection and fallback polling" {
  with_runtime_debug_world(fn() raise {
    clear_queued_inputs()
    queue_input_event(KeyDown(@inputs.Space))
    let injected = consume_injected_input_or(fn() {
      @inputs.empty_input_snapshot()
    })
    inspect(injected.pressed_keys.contains(@inputs.Space), content="true")
    inspect(queued_input_count(), content="0")
    let fallback = consume_injected_input_or(fn() {
      let snapshot = @inputs.empty_input_snapshot()
      snapshot.pressed_keys.add(@inputs.KeyA)
      snapshot
    })
    inspect(fallback.pressed_keys.contains(@inputs.KeyA), content="true")
  })
}

///|
test "frame metrics track fixed update and render phases" {
  with_runtime_debug_world(fn() raise {
    begin_frame_metrics()
    note_fixed_step(0.016)
    note_update(0.032, 7)
    note_render(0.01, 3, 1)
    let latest = latest_metrics()
    inspect(latest.fixed_steps_this_frame, content="1")
    inspect(latest.entity_count, content="7")
    inspect(latest.draw2d_count, content="3")
    inspect(latest.draw3d_count, content="1")
    inspect(rolling_metrics().length(), content="1")
  })
}

///|
test "atlas validation reports overlaps and out-of-bounds regions" {
  with_runtime_debug_world(fn() raise {
    let rect_a : @math.Rect = {
      position: @math.Vec2(0.0, 0.0),
      size: @math.Vec2(8.0, 8.0),
    }
    let rect_b : @math.Rect = {
      position: @math.Vec2(4.0, 4.0),
      size: @math.Vec2(8.0, 8.0),
    }
    let rect_c : @math.Rect = {
      position: @math.Vec2(14.0, 14.0),
      size: @math.Vec2(4.0, 4.0),
    }
    let layout = @sprite.TextureAtlasLayout::new(@math.Vec2(16.0, 16.0), [
      rect_a, rect_b, rect_c,
    ])
    let report = validate_texture_atlas_layout(layout)
    let mut has_overlap = false
    let mut has_out_of_bounds = false
    for issue in report.issues {
      if issue.kind is Overlap {
        has_overlap = true
      }
      if issue.kind is OutOfBounds {
        has_out_of_bounds = true
      }
    }
    inspect(report.total_rects, content="3")
    inspect(has_overlap, content="true")
    inspect(has_out_of_bounds, content="true")
  })
}

///|
test "render submission keeps entity ids and exposes offscreen capture API" {
  with_runtime_debug_world(fn() raise {
    let world_command : @render2d.DrawCommandWithDepth2D = {
      depth: 1.0,
      order: 0,
      entity_id: Some(42U),
      command: Rect({
        rect: { position: @math.Vec2(0.0, 0.0), size: @math.Vec2(2.0, 2.0) },
        transform: @math.Transform::identity(),
        fill_color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
        stroke_color: None,
      }),
    }
    let frame : @render_pipeline.RenderFrame = {
      frame2d: { world_commands: [], ui_commands: [] },
      frame3d: @render3d_types.empty_render_frame3d(),
      assets3d: @render_pipeline.empty_asset_sync3d(),
    }
    record_render_submission(frame, [world_command])
    let submission = latest_render_submission().unwrap()
    inspect(submission.draw2d.length(), content="1")
    inspect(submission.draw2d[0].entity_id == Some(42U), content="true")
    inspect(render_last_frame_offscreen_png(64, 64) is None, content="true")
  })
}
