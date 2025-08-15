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
#external
type Audio

///|
pub extern "js" fn Audio::new(path : String) -> Audio = "(path) => new Audio(path)"

///|
pub extern "js" fn Audio::play(self : Self) -> Unit = "(self) => self.play()"

///|
pub extern "js" fn Audio::pause(self : Self) -> Unit = "(self) => self.pause()"

///|
pub extern "js" fn Audio::set_volume(self : Self, volume : Double) -> Unit = "(self, volume) => self.volume = volume"

///|
pub extern "js" fn Audio::set_loop(self : Self, loop_ : Bool) -> Unit = "(self, loop_) => self.loop = loop_"

///|
let audio_cache : Map[String, Audio] = Map::new()

///|
fn get_audio(path : String) -> Audio {
  if audio_cache.get(path) is Some(audio) {
    return audio
  }
  let audio = Audio::new(path)
  audio_cache.set(path, audio)
  audio
}

///|
pub impl @system.Backend for CanvasBackend with play_audio(
  _self,
  audio_path : String,
  volume~ : Double,
  loop_~ : Bool,
) -> Unit {
  let audio = get_audio(audio_path)
  audio.set_volume(volume)
  audio.set_loop(loop_)
  audio.play()
}

///|
pub impl @system.Backend for CanvasBackend with preload_audio(
  _self,
  audio_path : String,
) -> Unit {
  get_audio(audio_path) |> ignore
}
