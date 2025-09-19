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
/// Plays an audio file through the specified backend with configurable volume
/// and looping options.
///
/// Parameters:
///
/// * `backend` : The audio backend used to play the audio file.
/// * `audio_path` : The file path or identifier of the audio file to play.
/// * `volume` : The playback volume level, defaults to 1.0 (full volume).
/// * `loop_` : Whether the audio should loop continuously, defaults to false.
///
/// Example:
///
/// ```notest
/// // Play audio once at full volume
/// @audio.play_audio(backend, "sound.wav")
///
/// // Play audio at half volume with looping
/// @audio.play_audio(backend, "music.mp3", volume=0.5, loop_=true)
/// ```
///
pub fn play_audio(
  audio_path : String,
  volume? : Double = 1.0,
  loop_? : Bool = false,
) -> Unit {
  @backend.play_audio(audio_path~, volume~, loop_~)
}
