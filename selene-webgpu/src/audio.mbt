// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
pub type AudioInstance = Int32

///|
const AUDIO_PLAY_STATE_BLOCKED = 2

///|
const AUDIO_PLAY_STATE_FAILED = 3

///|
priv struct AudioPlayback {
  audio : Audio
  source_url : String
  mut requested_paused : Bool
  mut last_play_attempt_activation_epoch : Int32
}

///|
let audio_instances : Map[AudioInstance, AudioPlayback] = Map([])

///|
let next_audio_instance : Ref[Int32] = Ref(1)

///|
let audio_user_activation_epoch : Ref[Int32] = Ref(0)

///|
let cached_audio_sources : Map[@asset_types.AudioHandle, String] = Map([])

///|
let retired_blob_audio_sources : Array[String] = []

///|
let preloaded_audio_templates : Map[@asset_types.AudioHandle, Audio] = Map([])

///|
fn clamp_playback_speed(speed : Double) -> Double {
  if speed <= 0.0 {
    0.01
  } else {
    speed
  }
}

///|
fn note_audio_user_activation() -> Unit {
  audio_user_activation_epoch.val += 1
}

///|
fn current_audio_activation_epoch() -> Int32 {
  audio_user_activation_epoch.val
}

///|
fn should_retry_blocked_audio_playback(
  play_state : Int32,
  requested_paused : Bool,
  activation_epoch : Int32,
  last_play_attempt_activation_epoch : Int32,
) -> Bool {
  play_state == AUDIO_PLAY_STATE_BLOCKED &&
  !requested_paused &&
  activation_epoch > last_play_attempt_activation_epoch
}

///|
fn clear_cached_audio_source(source : @asset_types.AudioHandle) -> Unit {
  if cached_audio_sources.get(source) is Some(url) {
    retired_blob_audio_sources.push(url)
    cached_audio_sources.remove(source)
  }
}

///|
fn resolved_audio_source(source : @asset_types.AudioHandle) -> String {
  if cached_audio_sources.get(source) is Some(url) {
    return url
  }
  guard source.get() is Some(asset) else { abort("Audio asset is unavailable") }
  let src = create_object_url(asset.bytes, "application/octet-stream")
  cached_audio_sources[source] = src
  source.on_invalidate(fn() {
    clear_preloaded_audio_template(source)
    clear_cached_audio_source(source)
  })
  src
}

///|
fn clear_preloaded_audio_template(source : @asset_types.AudioHandle) -> Unit {
  if preloaded_audio_templates.get(source) is Some(audio) {
    audio.pause()
    preloaded_audio_templates.remove(source)
  }
}

///|
fn ensure_preloaded_audio_template(source : @asset_types.AudioHandle) -> Audio {
  if preloaded_audio_templates.get(source) is Some(audio) {
    return audio
  }
  let audio = Audio(resolved_audio_source(source))
  audio.load()
  preloaded_audio_templates.set(source, audio)
  audio
}

///|
fn request_audio_playback(playback : AudioPlayback) -> Unit {
  let activation_epoch = current_audio_activation_epoch()
  playback.last_play_attempt_activation_epoch = activation_epoch
  request_audio_play(playback.audio, activation_epoch)
}

///|
fn create_audio_instance(
  source : @asset_types.AudioHandle,
) -> (AudioInstance, AudioPlayback) {
  let id = next_audio_instance.val
  next_audio_instance.val += 1
  let template = ensure_preloaded_audio_template(source)
  let audio = template.clone_audio()
  (
    id,
    {
      audio,
      source_url: (
        @js.Value::cast_from(template).get_with_string("src") : String),
      requested_paused: false,
      last_play_attempt_activation_epoch: -1,
    },
  )
}

///|
fn reset_audio_runtime() -> Unit {
  for playback in audio_instances.values() {
    playback.audio.pause()
    playback.audio.set_current_time(0.0)
  }
  audio_instances.clear()
  for template in preloaded_audio_templates.values() {
    template.pause()
    template.set_current_time(0.0)
  }
  preloaded_audio_templates.clear()
  for url in cached_audio_sources.values() {
    revoke_object_url(url)
  }
  cached_audio_sources.clear()
  for src in retired_blob_audio_sources {
    revoke_object_url(src)
  }
  retired_blob_audio_sources.clear()
}

///|
pub fn play_audio(
  source~ : @asset_types.AudioHandle,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  let (instance, playback) = create_audio_instance(source)
  playback.audio.set_volume(volume)
  playback.audio.set_loop(loop_)
  playback.audio.set_playback_rate(clamp_playback_speed(speed))
  playback.requested_paused = paused
  audio_instances.set(instance, playback)
  if paused {
    playback.audio.pause()
  } else {
    request_audio_playback(playback)
  }
  instance
}

///|
pub fn set_volume(instance~ : AudioInstance, volume~ : Double) -> Unit {
  if audio_instances.get(instance) is Some(playback) {
    playback.audio.set_volume(volume)
  }
}

///|
pub fn set_speed(instance~ : AudioInstance, speed~ : Double) -> Unit {
  if audio_instances.get(instance) is Some(playback) {
    playback.audio.set_playback_rate(clamp_playback_speed(speed))
  }
}

///|
pub fn set_loop(instance~ : AudioInstance, loop_~ : Bool) -> Unit {
  if audio_instances.get(instance) is Some(playback) {
    playback.audio.set_loop(loop_)
  }
}

///|
pub fn set_paused(instance~ : AudioInstance, paused~ : Bool) -> Unit {
  if audio_instances.get(instance) is Some(playback) {
    if playback.requested_paused == paused {
      return
    }
    playback.requested_paused = paused
    if paused {
      playback.audio.pause()
    } else if !playback.audio.is_ended() {
      request_audio_playback(playback)
    }
  }
}

///|
pub fn stop(instance~ : AudioInstance) -> Unit {
  if audio_instances.get(instance) is Some(playback) {
    playback.requested_paused = true
    playback.audio.pause()
    playback.audio.set_current_time(0.0)
  }
  audio_instances.remove(instance)
  collect_retired_audio_sources()
}

///|
pub fn is_finished(instance~ : AudioInstance) -> Bool {
  match audio_instances.get(instance) {
    Some(playback) =>
      playback.audio.is_ended() ||
      audio_play_state(playback.audio) == AUDIO_PLAY_STATE_FAILED
    None => true
  }
}

///|
pub fn tick_audio() -> Unit {
  defer collect_retired_audio_sources()
  let activation_epoch = current_audio_activation_epoch()
  audio_instances.retain((_instance, playback) => {
    let play_state = audio_play_state(playback.audio)
    if playback.audio.is_ended() || play_state == AUDIO_PLAY_STATE_FAILED {
      return false
    }
    if should_retry_blocked_audio_playback(
        play_state,
        playback.requested_paused,
        activation_epoch,
        playback.last_play_attempt_activation_epoch,
      ) {
      request_audio_playback(playback)
    }
    true
  })
}

///|
pub fn preload_audio(source : @asset_types.AudioHandle) -> Unit {
  ignore(ensure_preloaded_audio_template(source))
}

///|
pub fn audio_preparation_state(
  handle : @asset_types.AudioHandle,
) -> @asset_types.PreparationState {
  guard preloaded_audio_templates.get(handle) is Some(audio) else {
    return Unprepared
  }
  let value = @js.Value::cast_from(audio)
  let error : @js.Value = value.get_with_string("error")
  if is_js_object(error) {
    return Failed(error.get_with_string("message"))
  }
  let state : Int32 = value.get_with_string("readyState")
  if state >= 2 {
    Ready
  } else {
    Preparing
  }
}

///|
fn collect_retired_audio_sources() -> Unit {
  retired_blob_audio_sources.retain(url => {
    if audio_instances.values().any(playback => playback.source_url == url) {
      true
    } else {
      revoke_object_url(url)
      false
    }
  })
}
