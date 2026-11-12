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
struct AudioSink {
  instance : @platform_audio.AudioInstance
  mode : PlaybackMode
  mut volume : Double
  mut speed : Double
  mut paused : Bool
  mut muted : Bool
  mut stopped : Bool
  mut finished : Bool
}

///|
fn effective_sink_volume(sink : AudioSink) -> Double {
  if sink.muted {
    0.0
  } else {
    sanitize_volume(sink.volume) * global_volume_ref.val
  }
}

///|
fn should_sink_pause(sink : AudioSink) -> Bool {
  sink.paused || sink.muted
}

///|
pub fn AudioSink::mode(self : AudioSink) -> PlaybackMode {
  self.mode
}

///|
pub fn AudioSink::volume(self : AudioSink) -> Double {
  self.volume
}

///|
pub fn AudioSink::speed(self : AudioSink) -> Double {
  self.speed
}

///|
pub fn AudioSink::paused(self : AudioSink) -> Bool {
  self.paused
}

///|
pub fn AudioSink::muted(self : AudioSink) -> Bool {
  self.muted
}

///|
pub fn AudioSink::stopped(self : AudioSink) -> Bool {
  self.stopped
}

///|
pub fn AudioSink::finished(self : AudioSink) -> Bool {
  self.finished
}

///|
pub fn AudioSink::set_volume(self : AudioSink, volume : Double) -> Unit {
  self.volume = sanitize_volume(volume)
}

///|
pub fn AudioSink::set_speed(self : AudioSink, speed : Double) -> Unit {
  self.speed = sanitize_speed(speed)
}

///|
pub fn AudioSink::set_paused(self : AudioSink, paused : Bool) -> Unit {
  self.paused = paused
}

///|
pub fn AudioSink::set_muted(self : AudioSink, muted : Bool) -> Unit {
  self.muted = muted
}

///|
pub fn AudioSink::pause(self : AudioSink) -> Unit {
  self.paused = true
}

///|
pub fn AudioSink::play(self : AudioSink) -> Unit {
  self.paused = false
}

///|
pub fn AudioSink::stop(self : AudioSink) -> Unit {
  self.stopped = true
  self.paused = true
}
