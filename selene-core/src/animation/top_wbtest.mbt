///|
fn with_animation_test_world(action : () -> Unit raise) -> Unit raise {
  let previous = @ecs.current_world().unwrap_or(@ecs.bootstrap_world())
  let world = @ecs.World::new()
  @ecs.set_current_world(world)
  action()
  @ecs.set_current_world(previous)
}

///|
fn animation_test_translation_clip(
  name : String,
  target : AnimationTargetId,
  x : Double,
) -> AnimationClipHandle {
  let clip = AnimationClip::new(name)
  clip.add_curve_to_target(
    target,
    VariableCurve::vec3(
      transform_translation_field(),
      [
        {
          time: 0.0,
          value: @math.Vec3::new(x, 0.0, 0.0),
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
  let player = AnimationPlayer::new()
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
  let player = AnimationPlayer::new()
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
  let player = AnimationPlayer::new()
  let transitions = AnimationTransitions::new()
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
    let entity = @entity.Entity::new()
    let image = @asset.load_image("animation/test.png")
    let layout = @sprite.register_texture_atlas_layout(
      @sprite.TextureAtlasLayout::from_grid(@math.Vec2(16.0, 16.0), 6, 1),
    )
    @sprite.sprites().set(
      entity,
      @sprite.Sprite::from_atlas_image(
        image,
        @sprite.TextureAtlas::new(layout, index=1),
      ),
    )
    let handle = texture_atlas_index_field()
    let field = animated_field(handle).unwrap()
    let resolved = resolve_sample_value(handle, field, entity, {
      normal: [
        (AnimatedValue::Scalar(0.0), 0.25),
        (AnimatedValue::Scalar(5.0), 0.75),
      ],
      additive: [(AnimatedValue::Scalar(3.0), 1.0)],
    })
    let frame = match resolved {
      AnimatedValue::Scalar(value) => value
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
        { time: 0.0, value: 0.0, in_tangent: None, out_tangent: None },
        { time: 1.0, value: 1.0, in_tangent: None, out_tangent: None },
        { time: 2.0, value: 2.0, in_tangent: None, out_tangent: None },
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
    let player_entity = @entity.Entity::new()
    let target_entity = @entity.Entity::new()
    let target_id = AnimationTargetId::new("masked")
    @transform.transforms().set(target_entity, @transform.Transform::default())
    animation_target_ids().set(target_entity, target_id)
    animated_bys().set(target_entity, AnimatedBy::new(player_entity))

    let masked_clip = animation_test_translation_clip("masked", target_id, 10.0)
    let masked_graph = AnimationGraph::new()
    let masked_node = masked_graph.add_clip_with_mask(masked_clip, [1])
    masked_graph.add_target_to_mask_group(target_id, 1)
    animation_graph_handles().set(
      player_entity,
      register_animation_graph_asset(masked_graph),
    )
    let masked_player = animation_players().get_or_init(player_entity, fn() {
      AnimationPlayer::new()
    })
    ignore(masked_player.start(masked_node, repeat=Never))
    animation_apply_system(0.0)
    inspect(
      @transform.transforms().get(target_entity).unwrap().translation.x,
      content="0",
    )

    let unmasked_graph = AnimationGraph::new()
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
      @transform.transforms().get(target_entity).unwrap().translation.x,
      content="10",
    )
  })
}

///|
test "animation event descriptors dispatch typed events to readers and observers" {
  with_animation_test_world(fn() raise {
    let events : @event.Events[Int] = @event.Events::new()
    let reader : @event.EventReader[Int] = @event.EventReader::new()
    let observed : Array[Int] = []
    let player_entity = @entity.Entity::new()
    events.observe_entity(player_entity, fn(trigger) {
      observed.push(trigger.event)
    })
    |> ignore
    let descriptor = register_animation_event_descriptor(events, fn(context) {
      context.time.to_int() + 6
    })
    let clip = AnimationClip::new("event")
    clip.add_event(1.0, descriptor)
    let clip_handle = register_animation_clip_asset(clip)
    let (graph, nodes) = AnimationGraph::from_clips([clip_handle])
    animation_graph_handles().set(
      player_entity,
      register_animation_graph_asset(graph),
    )
    let player = animation_players().get_or_init(player_entity, fn() {
      AnimationPlayer::new()
    })
    ignore(player.start(nodes[0], repeat=Never))
    animation_player_system(1.0)
    inspect(events.read(reader), content="[7]")
    events.dispatch_observers()
    inspect(observed, content="[7]")
  })
}

///|
test "animation asset queues report dirty and released handles" {
  with_animation_test_world(fn() raise {
    ignore(take_dirty_animation_clip_assets())
    ignore(take_dirty_animation_graph_assets())
    let clip_handle = register_animation_clip_asset(AnimationClip::new("dirty"))
    let graph_handle = register_animation_graph_asset(AnimationGraph::new())
    inspect(take_dirty_animation_clip_assets().length(), content="1")
    inspect(take_dirty_animation_graph_assets().length(), content="1")
    release_animation_clip_asset(clip_handle)
    release_animation_graph_asset(graph_handle)
    inspect(take_released_animation_clip_assets().length(), content="1")
    inspect(take_released_animation_graph_assets().length(), content="1")
  })
}
