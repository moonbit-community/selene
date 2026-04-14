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

///|
test "sprite inspector returns unified sprite debug entries" {
  with_runtime_debug_world(fn() raise {
    let entity = @entity.Entity::new()
    @name.names().set(entity, @name.Name::new("Sprite Debug"))
    let image = @asset.load_image("assets/debug/sprite.png")
    let source_rect : @math.Rect = {
      position: @math.Vec2(2.0, 4.0),
      size: @math.Vec2(8.0, 16.0),
    }
    let local_transform = @transform.Transform::from_xyz(12.0, 34.0, 1.0)
    @transform.transforms().set(entity, local_transform)
    @transform.global_transforms().set(
      entity,
      @transform.GlobalTransform::from_transform(local_transform),
    )
    @sprite.sprites().set(
      entity,
      @sprite.Sprite::new(
        image=Some(image),
        rect=Some(source_rect),
        flip_x=true,
        anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
      ),
    )
    let entries = sprite_inspector_entries()
    inspect(entries.length(), content="1")
    inspect(entries[0].entity_name == Some("Sprite Debug"), content="true")
    inspect(
      entries[0].image_path == Some("assets/debug/sprite.png"),
      content="true",
    )
    inspect(entries[0].source_rect is Some(_), content="true")
    inspect(entries[0].flip_x, content="true")
  })
}

///|
test "atlas overlay decoration appends highlight rects when enabled" {
  with_runtime_debug_world(fn() raise {
    let image = @asset.load_image("assets/debug/atlas.png")
    let draw_image : @render2d_types.ImageDrawCommand2D = {
      image,
      destination: {
        position: @math.Vec2(10.0, 20.0),
        size: @math.Vec2(30.0, 40.0),
      },
      source: Some({
        position: @math.Vec2(1.0, 2.0),
        size: @math.Vec2(3.0, 4.0),
      }),
      transform: @math.Transform::identity(),
      repeat: @math.NoRepeat,
      color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    }
    let world_command : @render2d.DrawCommandWithDepth2D = {
      depth: 1.0,
      order: 0,
      entity_id: Some(7U),
      command: Image(draw_image),
    }
    let frame : @render_pipeline.RenderFrame = {
      frame2d: { world_commands: [Image(draw_image)], ui_commands: [] },
      frame3d: @render3d_types.empty_render_frame3d(),
      assets3d: @render_pipeline.empty_asset_sync3d(),
    }
    set_atlas_overlay_enabled(false)
    let disabled = decorate_frame_for_debug(frame, [world_command])
    inspect(disabled.frame2d.ui_commands.length(), content="0")
    set_atlas_overlay_enabled(true)
    let enabled = decorate_frame_for_debug(frame, [world_command])
    inspect(enabled.frame2d.ui_commands.length(), content="1")
  })
}

///|
test "frame metadata export includes draw commands and atlas overlay entries" {
  with_runtime_debug_world(fn() raise {
    let image = @asset.load_image("assets/debug/metadata.png")
    let draw_image : @render2d_types.ImageDrawCommand2D = {
      image,
      destination: {
        position: @math.Vec2(0.0, 0.0),
        size: @math.Vec2(16.0, 16.0),
      },
      source: Some({
        position: @math.Vec2(4.0, 5.0),
        size: @math.Vec2(6.0, 7.0),
      }),
      transform: @math.Transform::identity(),
      repeat: @math.NoRepeat,
      color: { r: 255U, g: 255U, b: 255U, a: 1.0 },
    }
    let world_command : @render2d.DrawCommandWithDepth2D = {
      depth: 2.0,
      order: 0,
      entity_id: Some(9U),
      command: Image(draw_image),
    }
    let frame : @render_pipeline.RenderFrame = {
      frame2d: { world_commands: [Image(draw_image)], ui_commands: [] },
      frame3d: @render3d_types.empty_render_frame3d(),
      assets3d: @render_pipeline.empty_asset_sync3d(),
    }
    record_render_submission(frame, [world_command])
    let metadata = capture_last_frame_metadata().unwrap()
    inspect(metadata.draw2d.length(), content="1")
    inspect(metadata.atlas_overlay.length(), content="1")
    let json_text = capture_last_frame_metadata_json().unwrap()
    inspect(json_text.contains("\"frame_index\""), content="true")
    inspect(json_text.contains("\"atlas_overlay\""), content="true")
    inspect(
      frame_capture_file_stem(metadata.frame_index, metadata.fixed_step_index).contains(
        "frame_",
      ),
      content="true",
    )
  })
}

///|
test "export sprite inspector regions only processes entries with image and source rect" {
  with_runtime_debug_world(fn() raise {
    let naming_calls = Ref::new(0)
    let entries : Array[SpriteInspectorEntry] = [
      {
        entity_id: 1U,
        entity_name: Some("No Image"),
        visible: true,
        image_path: None,
        source_rect: Some({ x: 0.0, y: 0.0, width: 8.0, height: 8.0 }),
        destination_size: None,
        anchor: { x: 0.0, y: 0.0 },
        flip_x: false,
        flip_y: false,
        local_translation: None,
        world_translation: None,
      },
      {
        entity_id: 2U,
        entity_name: Some("No Rect"),
        visible: true,
        image_path: Some("assets/debug/export.png"),
        source_rect: None,
        destination_size: None,
        anchor: { x: 0.0, y: 0.0 },
        flip_x: false,
        flip_y: false,
        local_translation: None,
        world_translation: None,
      },
      {
        entity_id: 3U,
        entity_name: Some("Valid"),
        visible: true,
        image_path: Some("assets/debug/export.png"),
        source_rect: Some({ x: 1.0, y: 2.0, width: 4.0, height: 5.0 }),
        destination_size: None,
        anchor: { x: 0.0, y: 0.0 },
        flip_x: false,
        flip_y: false,
        local_translation: None,
        world_translation: None,
      },
    ]
    let exported = export_sprite_inspector_regions(entries, "/tmp", file_naming=fn(
      _entry,
      _index,
    ) {
      naming_calls.val = naming_calls.val + 1
      "runtime_debug_export_test.png"
    })
    inspect(naming_calls.val, content="1")
    inspect(exported, content="0")
  })
}

///|
test "export texture region png returns false for missing image path" {
  with_runtime_debug_world(fn() raise {
    inspect(
      export_texture_region_png(
        "/tmp/selene_runtime_debug_missing.png",
        { position: @math.Vec2(0.0, 0.0), size: @math.Vec2(1.0, 1.0) },
        "/tmp/selene_runtime_debug_missing_out.png",
      ),
      content="false",
    )
  })
}
