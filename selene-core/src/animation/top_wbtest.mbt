///|
fn with_animation_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @asset.set_io(fn(_path) { Some(Bytes::from_array([1U.to_byte()])) })
  action()
  @asset.set_io(fn(_path) { None })
  @ecs.set_current_world(previous)
}

///|
fn animation_test_translation_clip(
  name : String,
  target : AnimationTargetId,
  x : Double,
) -> AnimationClipHandle {
  let clip = AnimationClip(name)
  clip.add_curve_to_target(
    target,
    VariableCurve::vec3(
      transform_translation_field(),
      [
        {
          time: 0.0,
          value: Vec3(x, 0.0, 0.0),
          in_tangent: None,
          out_tangent: None,
        },
      ],
      interpolation=Step,
    ),
  )
  register_animation_clip_asset(clip)
}

///|
test "animation player play preserves active animation state while start restarts it" {
  let player = AnimationPlayer()
  let node = AnimationNodeIndex(1U)
  with_animation_test_world(fn() raise {
    let active = player.start(node)
    ignore(active.seek_to(2.5))
    ignore(active.set_speed(3.0))
    let preserved = player.play(node)
    inspect(preserved.elapsed(), content="2.5")
    inspect(preserved.speed(), content="3")
    let restarted = player.start(node)
    inspect(restarted.elapsed(), content="0")
    inspect(restarted.completions(), content="0")
  })
}

///|
test "animation player bulk controls update all active animations" {
  let player = AnimationPlayer()
  let node_a = AnimationNodeIndex(1U)
  let node_b = AnimationNodeIndex(2U)
  with_animation_test_world(fn() raise {
    ignore(player.start(node_a))
    ignore(player.start(node_b))
    ignore(player.pause_all())
    inspect(player.all_paused(), content="true")
    ignore(player.resume_all())
    inspect(player.all_paused(), content="false")
    ignore(player.seek_all_by(1.25))
    inspect(player.animation(node_a).unwrap().elapsed(), content="1.25")
    inspect(player.animation(node_b).unwrap().elapsed(), content="1.25")
    ignore(player.stop_all())
    inspect(player.playing_animations().length(), content="0")
  })
}

///|
test "animation transitions track the main animation and return the active animation" {
  let player = AnimationPlayer()
  let transitions = AnimationTransitions()
  let first = AnimationNodeIndex(1U)
  let second = AnimationNodeIndex(2U)
  with_animation_test_world(fn() raise {
    let first_active = transitions.play(player, first, 0.0)
    inspect(transitions.get_main_animation() == Some(first), content="true")
    inspect(first_active.weight(), content="1")
    let second_active = transitions.play(player, second, 0.2)
    inspect(transitions.get_main_animation() == Some(second), content="true")
    inspect(second_active.weight(), content="0")
    inspect(player.is_playing_animation(first), content="true")
    inspect(player.is_playing_animation(second), content="true")
  })
}

///|
test "texture atlas index field resolves as a discrete value instead of a weighted blend" {
  with_animation_test_world(fn() raise {
    let image = @asset.load_image("animation/test.png")
    let layout = @sprite.register_texture_atlas_layout(
      @sprite.TextureAtlasLayout::from_grid(Vec2(16.0, 16.0), 6, 1),
    )
    let entity = @ecs.require_current_world().spawn1(
      @sprite.Sprite::from_atlas_image(image, TextureAtlas(layout, index=1)),
    )
    let handle = texture_atlas_index_field()
    let field = animated_field(handle).unwrap()
    let resolved = resolve_sample_value(handle, field, entity, {
      normal: [(Scalar(0.0), 0.25), (Scalar(5.0), 0.75)],
      additive: [(Scalar(3.0), 1.0)],
    })
    let frame = match resolved {
      Scalar(value) => value
      _ => -1.0
    }
    inspect(frame, content="5")
  })
}

///|
test "step scalar sampling switches at an interior keyframe boundary" {
  inspect(
    sample_scalar(
      [
        { time: 0.0, value: 0.0, in_tangent: None, out_tangent: None, },
        { time: 1.0, value: 1.0, in_tangent: None, out_tangent: None, },
        { time: 2.0, value: 2.0, in_tangent: None, out_tangent: None, },
      ],
      1.0,
      Step,
    ),
    content="1",
  )
}

///|
test "animation graph mask groups exclude masked targets during apply" {
  with_animation_test_world(fn() raise {
    let world = @ecs.require_current_world()
    let target_id = AnimationTargetId("masked")
    let masked_clip = animation_test_translation_clip("masked", target_id, 10.0)
    let masked_graph = AnimationGraph()
    let masked_node = masked_graph.add_clip_with_mask(masked_clip, [1])
    masked_graph.add_target_to_mask_group(target_id, 1)
    let masked_player = AnimationPlayer()
    let player_entity = world.spawn(
      (masked_player, register_animation_graph_asset(masked_graph)),
    )
    let target_entity = world.spawn(
      (
        @transform.Spatial(@transform.Transform::identity()),
        target_id,
        AnimatedBy(player_entity),
      ),
    )
    ignore(masked_player.start(masked_node, repeat=Never))
    animation_apply_system(0.0)
    inspect(
      @transform.local_transform(target_entity).unwrap().translation.x,
      content="0",
    )

    let unmasked_graph = AnimationGraph()
    let unmasked_node = unmasked_graph.add_clip(masked_clip)
    animation_graph_handles().set(
      player_entity,
      register_animation_graph_asset(unmasked_graph),
    )
    let unmasked_player = animation_players().get(player_entity).unwrap()
    ignore(unmasked_player.stop_all())
    ignore(unmasked_player.start(unmasked_node, repeat=Never))
    animation_apply_system(0.0)
    inspect(
      @transform.local_transform(target_entity).unwrap().translation.x,
      content="10",
    )
  })
}

///|
test "animation event descriptors dispatch typed events to readers and observers" {
  with_animation_test_world(fn() raise {
    let events : @event.Events[Int32] = Events()
    let reader : @event.EventReader[Int32] = EventReader()
    let observed : Array[Int32] = []
    let descriptor = register_animation_event_descriptor(events, fn(context) {
      context.time.to_int() + 6
    })
    let clip = AnimationClip("event")
    clip.add_event(1.0, descriptor)
    let clip_handle = register_animation_clip_asset(clip)
    let (graph, nodes) = AnimationGraph::from_clips([clip_handle])
    let player = AnimationPlayer()
    let player_entity = @ecs.require_current_world().spawn(
      (player, register_animation_graph_asset(graph)),
    )
    events.observe_entity(player_entity, fn(trigger) {
      observed.push(trigger.event)
    })
    |> ignore
    ignore(player.start(nodes[0], repeat=Never))
    animation_player_system(1.0)
    let reader_events = events.read(reader)
    inspect(reader_events.length(), content="1")
    inspect(reader_events[0], content="7")
    events.dispatch_observers()
    inspect(observed.length(), content="1")
    inspect(observed[0], content="7")
  })
}

///|
test "animation asset queues report dirty and released handles" {
  with_animation_test_world(fn() raise {
    ignore(take_dirty_animation_clip_assets())
    ignore(take_dirty_animation_graph_assets())
    let clip_handle = register_animation_clip_asset(AnimationClip("dirty"))
    let graph_handle = register_animation_graph_asset(AnimationGraph())
    inspect(take_dirty_animation_clip_assets().length(), content="1")
    inspect(take_dirty_animation_graph_assets().length(), content="1")
    release_animation_clip_asset(clip_handle)
    release_animation_graph_asset(graph_handle)
    inspect(take_released_animation_clip_assets().length(), content="1")
    inspect(take_released_animation_graph_assets().length(), content="1")
  })
}

///|
test "skinning uses the joint world affine for positions and normals" {
  with_animation_test_world(fn() raise {
    let world = @ecs.require_current_world()
    let parent = world.spawn1(
      @transform.Spatial(@transform.Transform::from_scale(Vec3(2.0, 1.0, 1.0))),
    )
    let joint = world.spawn1(
      @transform.Spatial(
        @transform.Transform::from_rotation(
          @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), 0.7),
        ),
      ),
      parent~,
    )
    let point = @math.Vec3(3.0, 5.0, 0.0)
    let target = world.spawn(())
    let mesh = @render3d.register_mesh_asset(@render3d.triangle_mesh([point]))
    defer @render3d.release_mesh_asset(mesh)
    bind_skinned_mesh(target, {
      target_entity: target,
      mesh,
      base_positions: [point],
      indices: None,
      topology: TriangleList,
      base_normals: [@math.Vec3::x_axis()],
      uv_sets: [],
      colors: None,
      tangents: None,
      morph_targets: [],
      morph_weights: [],
      influences: [
        {
          joint0: 0,
          joint1: 0,
          joint2: 0,
          joint3: 0,
          weight0: 1.0,
          weight1: 0.0,
          weight2: 0.0,
          weight3: 0.0,
        },
      ],
      joint_entities: [joint],
      inverse_bind_matrices: [@math.Mat4::identity()],
    })
    @transform.transform_propagate_system(0.0)
    animation_skinning_system(0.0)
    guard @render3d.mesh_asset(mesh).unwrap().primitive is Triangles(deformed) else {
      fail("expected a skinned triangle mesh")
    }
    let affine = @transform.global_transform(joint).unwrap().affine
    assert_true(
      deformed.positions[0].distance(affine.transform_point3(point)) < 1.0e-10,
    )
    assert_true(deformed.normals.unwrap()[0].dot(affine.y_axis).abs() < 1.0e-10)
  })
}
