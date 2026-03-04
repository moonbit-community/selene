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
let audio_instances : Map[AudioInstance, Audio] = Map::new()

///|
let next_audio_instance : Ref[Int] = Ref::new(1)

///|
fn clamp_playback_speed(speed : Double) -> Double {
  if speed <= 0.0 {
    0.01
  } else {
    speed
  }
}

///|
fn create_audio_instance(path : String) -> (AudioInstance, Audio) {
  let id = next_audio_instance.val
  next_audio_instance.val += 1
  let audio = Audio::new(resolve_asset_path(path))
  audio_instances.set(id, audio)
  (id, audio)
}

///|
pub fn play_audio(
  audio_path~ : String,
  volume~ : Double,
  speed~ : Double,
  loop_~ : Bool,
  paused~ : Bool,
) -> AudioInstance {
  let (instance, audio) = create_audio_instance(audio_path)
  audio.set_volume(volume)
  audio.set_loop(loop_)
  audio.set_playback_rate(clamp_playback_speed(speed))
  if paused {
    audio.pause()
  } else {
    audio.play()
  }
  instance
}

///|
pub fn set_volume(instance~ : AudioInstance, volume~ : Double) -> Unit {
  if audio_instances.get(instance) is Some(audio) {
    audio.set_volume(volume)
  }
}

///|
pub fn set_speed(instance~ : AudioInstance, speed~ : Double) -> Unit {
  if audio_instances.get(instance) is Some(audio) {
    audio.set_playback_rate(clamp_playback_speed(speed))
  }
}

///|
pub fn set_loop(instance~ : AudioInstance, loop_~ : Bool) -> Unit {
  if audio_instances.get(instance) is Some(audio) {
    audio.set_loop(loop_)
  }
}

///|
pub fn set_paused(instance~ : AudioInstance, paused~ : Bool) -> Unit {
  if audio_instances.get(instance) is Some(audio) {
    let currently_paused = audio.is_paused()
    let ended = audio.is_ended()
    if paused && !currently_paused {
      audio.pause()
    } else if !paused && currently_paused && !ended {
      audio.play()
    }
  }
}

///|
pub fn stop(instance~ : AudioInstance) -> Unit {
  if audio_instances.get(instance) is Some(audio) {
    audio.pause()
    audio.set_current_time(0.0)
  }
  audio_instances.remove(instance)
}

///|
pub fn is_finished(instance~ : AudioInstance) -> Bool {
  match audio_instances.get(instance) {
    Some(audio) => audio.is_ended()
    None => true
  }
}

///|
pub fn tick_audio() -> Unit {
  for pair in audio_instances.to_array() {
    if pair.1.is_ended() {
      audio_instances.remove(pair.0)
    }
  }
}

///|
pub fn preload_audio(audio_path : String) -> Unit {
  let audio = Audio::new(resolve_asset_path(audio_path))
  audio.pause()
}
