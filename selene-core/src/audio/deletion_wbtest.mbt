///|
test "audio cleanup stops deleted loops only in the active World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let clip = @asset.audios.add(@asset.Audio::from_bytes(b"test audio"))
  let settings = PlaybackSettings::looped()
  let first = @ecs.World()
  @ecs.set_current_world(first)
  let direct = spawn_audio(clip, settings~)
  let parent = @ecs_test.spawn(@ecs.require_current_world(), ())
  let child = @ecs_test.spawn(@ecs.require_current_world(), (), parent~)
  attach_audio(child, AudioPlayer(clip), settings~)
  try! @ecs.Schedule().run(@ecs.require_current_world())
  audio_playback_system(first.query(), first.query())
  assert_true(audio_sinks().contains(direct))
  assert_true(audio_sinks().contains(child))
  assert_true(@ecs_test.delete(direct))
  assert_true(@ecs_test.delete(parent))

  let second = @ecs.World()
  @ecs.set_current_world(second)
  let survivor = spawn_audio(clip, settings~)
  try! @ecs.Schedule().run(@ecs.require_current_world())
  audio_playback_system(second.query(), second.query())
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
  let clip = @asset.audios.add(@asset.Audio::from_bytes(b"test audio"))
  let old = spawn_audio(clip, settings=PlaybackSettings::looped())
  try! @ecs.Schedule().run(@ecs.require_current_world())
  audio_playback_system(world.query(), world.query())
  ignore(@ecs_test.delete(old))
  let replacement = spawn_audio(clip, settings=PlaybackSettings::looped())
  assert_eq(old.slot_index(), replacement.slot_index())
  assert_true(audio_sinks().get(replacement) is None)
  let stopped = []
  cleanup_orphaned_audio(instance => stopped.push(instance))
  assert_eq(stopped.length(), 1)
  try! @ecs.Schedule().run(@ecs.require_current_world())
  audio_playback_system(world.query(), world.query())
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
  let clip = @asset.audios.add(@asset.Audio::from_bytes(b"test audio"))
  let first = spawn_audio(clip, settings=PlaybackSettings::despawn())
  let second = spawn_audio(clip, settings=PlaybackSettings::despawn())
  try! @ecs.Schedule().run(@ecs.require_current_world())
  audio_playback_system(world.query(), world.query())
  let players : @ecs.Query[@ecs.Single[AudioPlayer]] = world.query1()
  let visited = []
  @ecs.Schedule()
  .add_exclusive_system(_ => {
    for entity, _ in players {
      finish_audio_sink(entity)
      visited.push((entity, entity.is_valid_in(world)))
    }
  })
  .run(world)
  assert_eq(visited, [(first, true), (second, true)])
  assert_false(first.is_valid_in(world))
  assert_false(second.is_valid_in(world))
  assert_true(players.is_empty())
  assert_true(audio_sinks().is_empty())
}
