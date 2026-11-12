///|
#derive(Eq, Debug, Hash)
pub(all) struct AudioInstance(Int32)

///|
pub extend AudioInstance with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioInstance with Eq::{not_equal, equal}

///|
pub extend AudioInstance with Hash::{hash, hash_combine}

///|
pub fn play_audio(
  source~ : @asset_types.AudioHandle,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  ignore(source)
  ignore(volume)
  ignore(speed)
  ignore(loop_)
  ignore(paused)
  AudioInstance(0)
}

///|
pub fn preload(source : @asset_types.AudioHandle) -> Unit {
  ignore(source)
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

///|
pub fn preparation_state(
  handle : @asset_types.AudioHandle,
) -> @asset_types.PreparationState {
  ignore(handle)
  Unprepared
}
