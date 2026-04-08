///|
pub(all) struct AudioInstance(Int) derive(Eq, Debug, Hash)

///|
fn to_impl_instance(instance : AudioInstance) -> @impl.AudioInstance {
  instance.0
}

///|
fn from_impl_instance(instance : @impl.AudioInstance) -> AudioInstance {
  AudioInstance(instance)
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  from_impl_instance(
    @impl.play_audio(audio_path~, volume~, speed~, loop_~, paused~),
  )
}

///|
pub fn set_volume(instance~ : AudioInstance, volume~ : Double) -> Unit {
  @impl.set_volume(instance=to_impl_instance(instance), volume~)
}

///|
pub fn set_speed(instance~ : AudioInstance, speed~ : Double) -> Unit {
  @impl.set_speed(instance=to_impl_instance(instance), speed~)
}

///|
pub fn set_loop(instance~ : AudioInstance, loop_~ : Bool) -> Unit {
  @impl.set_loop(instance=to_impl_instance(instance), loop_~)
}

///|
pub fn set_paused(instance~ : AudioInstance, paused~ : Bool) -> Unit {
  @impl.set_paused(instance=to_impl_instance(instance), paused~)
}

///|
pub fn stop(instance~ : AudioInstance) -> Unit {
  @impl.stop(instance=to_impl_instance(instance))
}

///|
pub fn is_finished(instance~ : AudioInstance) -> Bool {
  @impl.is_finished(instance=to_impl_instance(instance))
}

///|
pub fn tick() -> Unit {
  @impl.tick_audio()
}
