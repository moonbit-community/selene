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
/// Plays an audio file with specified volume and loop settings.
///
/// Parameters:
///
/// * `audio_path` : The file path to the audio file to be played.
/// * `volume` : The playback volume level, ranging from 0.0 (silent) to 1.0
///   (full volume). Defaults to 1.0.
/// * `loop_` : Whether the audio should loop continuously after finishing.
///   Defaults to false.
///
/// Example:
///
/// ```moonbit nocheck
/// // Play audio once at full volume
/// @audio.play_audio("sounds/music.wav")
///
/// // Play audio at half volume
/// @audio.play_audio("sounds/effect.wav", volume=0.5)
///
/// // Play audio in a loop at 80% volume
/// @audio.play_audio("sounds/background.mp3", volume=0.8, loop_=true)
/// ```
///
pub fn play_audio(
  audio_path : String,
  volume? : Double = 1.0,
  loop_? : Bool = false,
) -> Unit {
  @backend.play_audio(audio_path~, volume~, loop_~)
}
