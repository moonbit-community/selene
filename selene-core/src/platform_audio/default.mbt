///|
pub(all) struct AudioInstance(Int) derive(Eq, Show, Hash)

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  ignore(audio_path)
  ignore(volume)
  ignore(speed)
  ignore(loop_)
  ignore(paused)
  AudioInstance(0)
}

///|
pub fn set_volume(instance~ : AudioInstance, volume~ : Double) -> Unit {
  ignore(instance)
  ignore(volume)
}

///|
pub fn set_speed(instance~ : AudioInstance, speed~ : Double) -> Unit {
  ignore(instance)
  ignore(speed)
}

///|
pub fn set_loop(instance~ : AudioInstance, loop_~ : Bool) -> Unit {
  ignore(instance)
  ignore(loop_)
}

///|
pub fn set_paused(instance~ : AudioInstance, paused~ : Bool) -> Unit {
  ignore(instance)
  ignore(paused)
}

///|
pub fn stop(instance~ : AudioInstance) -> Unit {
  ignore(instance)
}

///|
pub fn is_finished(instance~ : AudioInstance) -> Bool {
  ignore(instance)
  true
}

///|
pub fn tick() -> Unit {

}
