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
#derive(Eq, Debug)
pub(all) enum PlaybackMode {
  Once
  Loop
  Remove
  Despawn
}

///|
pub extend PlaybackMode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PlaybackMode with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct PlaybackSettings {
  mode : PlaybackMode
  volume : Double
  speed : Double
  paused : Bool
  muted : Bool
}

///|
pub extend PlaybackSettings with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PlaybackSettings with Eq::{not_equal, equal}

///|
fn sanitize_volume(volume : Double) -> Double {
  if volume < 0.0 {
    0.0
  } else {
    volume
  }
}

///|
fn sanitize_speed(speed : Double) -> Double {
  if speed <= 0.0 {
    0.01
  } else {
    speed
  }
}

///|
fn normalize_settings(settings : PlaybackSettings) -> PlaybackSettings {
  {
    ..settings,
    volume: sanitize_volume(settings.volume),
    speed: sanitize_speed(settings.speed),
  }
}

///|
fn use_loop_mode(mode : PlaybackMode) -> Bool {
  mode is Loop
}

///|
pub fn PlaybackSettings::once() -> PlaybackSettings {
  { mode: Once, volume: 1.0, speed: 1.0, paused: false, muted: false, }
}

///|
pub fn PlaybackSettings::looped() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Loop, }
}

///|
pub fn PlaybackSettings::remove() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Remove, }
}

///|
pub fn PlaybackSettings::despawn() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Despawn, }
}

///|
pub fn PlaybackSettings::with_mode(
  self : PlaybackSettings,
  mode : PlaybackMode,
) -> PlaybackSettings {
  { ..self, mode, }
}

///|
pub fn PlaybackSettings::with_volume(
  self : PlaybackSettings,
  volume : Double,
) -> PlaybackSettings {
  { ..self, volume: sanitize_volume(volume), }
}

///|
pub fn PlaybackSettings::with_speed(
  self : PlaybackSettings,
  speed : Double,
) -> PlaybackSettings {
  { ..self, speed: sanitize_speed(speed), }
}

///|
pub fn PlaybackSettings::with_paused(
  self : PlaybackSettings,
  paused : Bool,
) -> PlaybackSettings {
  { ..self, paused, }
}

///|
pub fn PlaybackSettings::with_muted(
  self : PlaybackSettings,
  muted : Bool,
) -> PlaybackSettings {
  { ..self, muted, }
}
