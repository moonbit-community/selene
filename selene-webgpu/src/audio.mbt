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
pub type AudioInstance = Int

///|

///|
const AUDIO_PLAY_STATE_BLOCKED = 2

///|
const AUDIO_PLAY_STATE_FAILED = 3

///|
priv struct CachedAudioSource {
  src : String
  blob_owned : Bool
}

///|
priv struct AudioPlayback {
  audio : Audio
  mut requested_paused : Bool
  mut last_play_attempt_activation_epoch : Int
}

///|
let audio_instances : Map[AudioInstance, AudioPlayback] = Map::new()

///|
let next_audio_instance : Ref[Int] = Ref::new(1)

///|
let audio_user_activation_epoch : Ref[Int] = Ref::new(0)

///|
let cached_audio_sources : Map[String, CachedAudioSource] = Map::new()

///|
let retired_blob_audio_sources : Array[String] = []

///|
let preloaded_audio_templates : Map[String, Audio] = Map::new()

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
fn current_audio_activation_epoch() -> Int {
  audio_user_activation_epoch.val
}

///|
fn audio_prefers_byte_backed_source(path : String) -> Bool {
  if path.has_prefix("http://") || path.has_prefix("https://") {
    return false
  }
  if path.has_prefix("data:") || path.has_prefix("blob:") {
    return false
  }
  path.has_prefix("assets/")
}

///|
fn browser_audio_mime_type(path : String) -> String {
  if path.has_suffix(".ogg") || path.has_suffix(".oga") {
    return "audio/ogg"
  }
  if path.has_suffix(".mp3") {
    return "audio/mpeg"
  }
  if path.has_suffix(".wav") {
    return "audio/wav"
  }
  if path.has_suffix(".flac") {
    return "audio/flac"
  }
  if path.has_suffix(".aac") {
    return "audio/aac"
  }
  "application/octet-stream"
}

///|
fn should_retry_blocked_audio_playback(
  play_state : Int,
  requested_paused : Bool,
  activation_epoch : Int,
  last_play_attempt_activation_epoch : Int,
) -> Bool {
  play_state == AUDIO_PLAY_STATE_BLOCKED &&
  !requested_paused &&
  activation_epoch > last_play_attempt_activation_epoch
}

///|
fn retire_cached_audio_source(entry : CachedAudioSource) -> Unit {
  if entry.blob_owned {
    retired_blob_audio_sources.push(entry.src)
  }
}

///|
fn clear_cached_audio_source(path : String, retire? : Bool = true) -> Unit {
  if cached_audio_sources.get(path) is Some(entry) {
    if retire {
      retire_cached_audio_source(entry)
    } else if entry.blob_owned {
      revoke_object_url(entry.src)
    }
    cached_audio_sources.remove(path)
  }
}

///|
fn resolved_audio_source(path : String, refresh? : Bool = false) -> String {
  if !refresh {
    if cached_audio_sources.get(path) is Some(entry) {
      return entry.src
    }
  } else {
    clear_cached_audio_source(path)
  }
  let src = if audio_prefers_byte_backed_source(path) {
    match get_asset_bytes(path) {
      Some(bytes) => {
        let blob_url = create_audio_object_url(
          bytes,
          browser_audio_mime_type(path),
        )
        cached_audio_sources.set(path, { src: blob_url, blob_owned: true })
        blob_url
      }
      None => {
        let resolved = resolve_asset_path(path)
        cached_audio_sources.set(path, { src: resolved, blob_owned: false })
        resolved
      }
    }
  } else {
    let resolved = resolve_asset_path(path)
    cached_audio_sources.set(path, { src: resolved, blob_owned: false })
    resolved
  }
  src
}

///|
fn clear_preloaded_audio_template(path : String) -> Unit {
  if preloaded_audio_templates.get(path) is Some(audio) {
    audio.pause()
    preloaded_audio_templates.remove(path)
  }
}

///|
fn ensure_preloaded_audio_template(
  path : String,
  refresh? : Bool = false,
) -> Audio {
  if !refresh {
    if preloaded_audio_templates.get(path) is Some(audio) {
      return audio
    }
  } else {
    clear_preloaded_audio_template(path)
  }
  let audio = Audio::new(resolved_audio_source(path, refresh~))
  audio.load()
  preloaded_audio_templates.set(path, audio)
  audio
}

///|
fn request_audio_playback(playback : AudioPlayback) -> Unit {
  let activation_epoch = current_audio_activation_epoch()
  playback.last_play_attempt_activation_epoch = activation_epoch
  request_audio_play(playback.audio, activation_epoch)
}

///|
fn create_audio_instance(path : String) -> (AudioInstance, AudioPlayback) {
  let id = next_audio_instance.val
  next_audio_instance.val += 1
  let template = ensure_preloaded_audio_template(path)
  let audio = template.clone_audio()
  (
    id,
    { audio, requested_paused: false, last_play_attempt_activation_epoch: -1 },
  )
}

///|
fn reset_audio_runtime() -> Unit {
  for pair in audio_instances.to_array() {
    let playback = pair.1
    playback.audio.pause()
    playback.audio.set_current_time(0.0)
  }
  audio_instances.clear()
  for pair in preloaded_audio_templates.to_array() {
    let template = pair.1
    template.pause()
    template.set_current_time(0.0)
  }
  preloaded_audio_templates.clear()
  for pair in cached_audio_sources.to_array() {
    let entry = pair.1
    if entry.blob_owned {
      revoke_object_url(entry.src)
    }
  }
  cached_audio_sources.clear()
  for src in retired_blob_audio_sources {
    revoke_object_url(src)
  }
  retired_blob_audio_sources.clear()
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  let (instance, playback) = create_audio_instance(audio_path)
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
  let activation_epoch = current_audio_activation_epoch()
  for pair in audio_instances.to_array() {
    let playback = pair.1
    let play_state = audio_play_state(playback.audio)
    if playback.audio.is_ended() || play_state == AUDIO_PLAY_STATE_FAILED {
      audio_instances.remove(pair.0)
    } else if should_retry_blocked_audio_playback(
        play_state,
        playback.requested_paused,
        activation_epoch,
        playback.last_play_attempt_activation_epoch,
      ) {
      request_audio_playback(playback)
    }
  }
}

///|
pub fn preload_audio(audio_path : String) -> Unit {
  ignore(ensure_preloaded_audio_template(audio_path, refresh=true))
}
