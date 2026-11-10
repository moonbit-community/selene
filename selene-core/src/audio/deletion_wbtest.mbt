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
  let parent = @ecs.require_current_world().spawn(())
  let child = @ecs.require_current_world().spawn((), parent~)
  attach_audio(child, AudioPlayer(clip), settings~)
  audio_playback_system(0.0)
  assert_true(audio_sinks().contains(direct))
  assert_true(audio_sinks().contains(child))
  assert_true(direct.delete())
  assert_true(parent.delete())

  let second = @ecs.World()
  @ecs.set_current_world(second)
  let survivor = spawn_audio(clip, settings~)
  audio_playback_system(0.0)
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
