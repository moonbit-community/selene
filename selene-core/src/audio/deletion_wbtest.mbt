///|
test "audio cleanup stops deleted loops only in the active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let clip = @asset.load_audio("audio-deletion-test.ogg")
  let settings = PlaybackSettings::looped()
  let first = @ecs.World()
  @ecs.set_current_world(first)
  let direct = spawn_audio(clip, settings~)
  let parent = @ecs_runtime.spawn(@ecs.require_current_world(), ())
  let child = @ecs_runtime.spawn(@ecs.require_current_world(), (), parent~)
  attach_audio(child, AudioPlayer(clip), settings~)
  try! @ecs_runtime.run_schedule(@ecs.require_current_world(), _ => ())
  audio_playback_system(world=first, 0.0)
  assert_true(audio_sinks().contains(direct))
  assert_true(audio_sinks().contains(child))
  assert_true(@ecs_runtime.delete(direct))
  assert_true(@ecs_runtime.delete(parent))

  let second = @ecs.World()
  @ecs.set_current_world(second)
  let survivor = spawn_audio(clip, settings~)
  try! @ecs_runtime.run_schedule(@ecs.require_current_world(), _ => ())
  audio_playback_system(world=second, 0.0)
  let stopped = []
  cleanup_orphaned_audio(instance => stopped.push(instance))
  assert_true(stopped.is_empty())
  assert_true(audio_sinks().contains(survivor))

  @ecs.set_current_world(first)
  cleanup_orphaned_audio(instance => stopped.push(instance))
  cleanup_orphaned_audio(instance => stopped.push(instance))
  assert_eq(stopped.length(), 2)
  assert_true(audio_sinks().is_empty())

  @ecs.set_current_world(second)
  assert_true(audio_sinks().contains(survivor))
  assert_eq(audio_sinks().length(), 1)
  stop_audio(survivor)
  cleanup_orphaned_audio(instance => stopped.push(instance))
  assert_eq(stopped.length(), 2)
  assert_true(audio_sinks().is_empty())
}

///|
test "audio cleanup retains old loop handles when the entity slot is reused" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let clip = @asset.load_audio("audio-slot-reuse-test.ogg")
  let old = spawn_audio(clip, settings=PlaybackSettings::looped())
  try! @ecs_runtime.run_schedule(@ecs.require_current_world(), _ => ())
  audio_playback_system(world~, 0.0)
  ignore(@ecs_runtime.delete(old))
  let replacement = spawn_audio(clip, settings=PlaybackSettings::looped())
  assert_eq(old.slot_index(), replacement.slot_index())
  assert_true(audio_sinks().get(replacement) is None)
  let stopped = []
  cleanup_orphaned_audio(instance => stopped.push(instance))
  assert_eq(stopped.length(), 1)
  try! @ecs_runtime.run_schedule(@ecs.require_current_world(), _ => ())
  audio_playback_system(world~, 0.0)
  assert_false(audio_sinks().contains(old))
  assert_true(audio_sinks().contains(replacement))
}

///|
test "finished despawn audio queues deletion until query traversal completes" {
  let world = @ecs.World()
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  @ecs.set_current_world(world)
  let clip = @asset.load_audio("audio-deferred-delete-test.ogg")
  let first = spawn_audio(clip, settings=PlaybackSettings::despawn())
  let second = spawn_audio(clip, settings=PlaybackSettings::despawn())
  try! @ecs_runtime.run_schedule(@ecs.require_current_world(), _ => ())
  audio_playback_system(world~, 0.0)
  let players : @ecs.Query[@ecs.Single[AudioPlayer]] = world.query1()
  let visited = []
  @ecs_runtime.run_schedule(world, _ => {
    for entity, _ in players {
      finish_audio_sink(entity)
      visited.push((entity, entity.is_valid_in(world)))
    }
  })
  assert_eq(visited, [(first, true), (second, true)])
  assert_false(first.is_valid_in(world))
  assert_false(second.is_valid_in(world))
  assert_true(players.is_empty())
  assert_true(audio_sinks().is_empty())
}
