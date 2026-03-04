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
pub type AudioHandle = @asset.AudioHandle

///|
pub(all) enum PlaybackMode {
  Once
  Loop
  Remove
  Despawn
} derive(Eq, Show)

///|
pub(all) struct PlaybackSettings {
  mode : PlaybackMode
  volume : Double
  speed : Double
  paused : Bool
  muted : Bool
} derive(Eq, Show)

///|
pub(all) struct AudioPlayer {
  source : AudioHandle
} derive(Eq, Show)

///|
pub(all) struct AudioSink {
  instance : @platform_audio.AudioInstance
  mut finished : Bool
}

///|
pub let audio_players : Map[@entity.Entity, AudioPlayer] = Map::new()

///|
pub let audio_playback_settings : Map[@entity.Entity, PlaybackSettings] = Map::new()

///|
pub let audio_sinks : Map[@entity.Entity, AudioSink] = Map::new()

///|
let global_volume_ref : Ref[Double] = Ref::new(1.0)

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
fn effective_volume(settings : PlaybackSettings) -> Double {
  if settings.muted {
    0.0
  } else {
    sanitize_volume(settings.volume) * global_volume_ref.val
  }
}

///|
fn should_pause(settings : PlaybackSettings) -> Bool {
  settings.paused || settings.muted
}

///|
pub fn AudioPlayer::new(source : AudioHandle) -> AudioPlayer {
  { source, }
}

///|
pub fn AudioPlayer::from_path(path : String) -> AudioPlayer {
  AudioPlayer::new(@asset.load_audio(path))
}

///|
pub fn PlaybackSettings::once() -> PlaybackSettings {
  { mode: Once, volume: 1.0, speed: 1.0, paused: false, muted: false }
}

///|
pub fn PlaybackSettings::looped() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Loop }
}

///|
pub fn PlaybackSettings::remove() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Remove }
}

///|
pub fn PlaybackSettings::despawn() -> PlaybackSettings {
  { ..PlaybackSettings::once(), mode: Despawn }
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
  { ..self, volume: sanitize_volume(volume) }
}

///|
pub fn PlaybackSettings::with_speed(
  self : PlaybackSettings,
  speed : Double,
) -> PlaybackSettings {
  { ..self, speed: sanitize_speed(speed) }
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

///|
pub fn set_global_volume(volume : Double) -> Unit {
  global_volume_ref.val = sanitize_volume(volume)
}

///|
pub fn global_volume() -> Double {
  global_volume_ref.val
}

///|
pub fn attach_audio(
  entity : @entity.Entity,
  player : AudioPlayer,
  settings? : PlaybackSettings = PlaybackSettings::once(),
) -> Unit {
  audio_players.set(entity, player)
  audio_playback_settings.set(entity, normalize_settings(settings))
  if audio_sinks.get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks.remove(entity)
  }
}

///|
pub fn spawn_audio(
  source : AudioHandle,
  settings? : PlaybackSettings = PlaybackSettings::once(),
) -> @entity.Entity {
  let entity = @entity.Entity::new()
  attach_audio(entity, AudioPlayer::new(source), settings~)
  entity
}

///|
pub fn restart_audio(entity : @entity.Entity) -> Unit {
  if audio_sinks.get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks.remove(entity)
  }
}

///|
pub fn stop_audio(entity : @entity.Entity) -> Unit {
  if audio_sinks.get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks.remove(entity)
  }
  audio_players.remove(entity)
  audio_playback_settings.remove(entity)
}

///|
fn cleanup_orphaned_audio() -> Unit {
  for pair in audio_sinks.to_array() {
    if !pair.0.is_alive() || !audio_players.contains(pair.0) {
      @platform_audio.stop(instance=pair.1.instance)
      audio_sinks.remove(pair.0)
    }
  }
  for pair in audio_playback_settings.to_array() {
    if !pair.0.is_alive() || !audio_players.contains(pair.0) {
      audio_playback_settings.remove(pair.0)
    }
  }
  for pair in audio_players.to_array() {
    if !pair.0.is_alive() {
      audio_players.remove(pair.0)
    }
  }
}

///|
fn start_audio_sink(
  entity : @entity.Entity,
  player : AudioPlayer,
  settings : PlaybackSettings,
) -> Unit {
  guard @asset.audio_path(player.source) is Some(path) else { return }
  let sink = {
    instance: @platform_audio.play_audio(
      audio_path=path,
      volume=effective_volume(settings),
      speed=settings.speed,
      loop_=use_loop_mode(settings.mode),
      paused=should_pause(settings),
    ),
    finished: false,
  }
  audio_sinks.set(entity, sink)
}

///|
fn finish_audio_sink(entity : @entity.Entity, mode : PlaybackMode) -> Unit {
  guard audio_sinks.get(entity) is Some(sink) else { return }
  match mode {
    Once => sink.finished = true
    Loop => {
      @platform_audio.stop(instance=sink.instance)
      audio_sinks.remove(entity)
    }
    Remove => stop_audio(entity)
    Despawn => {
      stop_audio(entity)
      entity.destroy()
    }
  }
}

///|
fn sync_audio_sink(
  entity : @entity.Entity,
  player : AudioPlayer,
  settings : PlaybackSettings,
  sink : AudioSink,
) -> Unit {
  if sink.finished {
    if settings.mode is Loop {
      @platform_audio.stop(instance=sink.instance)
      audio_sinks.remove(entity)
      start_audio_sink(entity, player, settings)
    }
    return
  }
  @platform_audio.set_volume(
    instance=sink.instance,
    volume=effective_volume(settings),
  )
  @platform_audio.set_speed(instance=sink.instance, speed=settings.speed)
  @platform_audio.set_loop(
    instance=sink.instance,
    loop_=use_loop_mode(settings.mode),
  )
  @platform_audio.set_paused(
    instance=sink.instance,
    paused=should_pause(settings),
  )
  if @platform_audio.is_finished(instance=sink.instance) {
    finish_audio_sink(entity, settings.mode)
  }
}

///|
/// Legacy helper that spawns one-shot (or looping) audio players.
pub fn play_audio(
  audio_path : String,
  volume? : Double = 1.0,
  loop_? : Bool = false,
) -> Unit {
  let source = @asset.load_audio(audio_path)
  let settings = if loop_ {
    PlaybackSettings::looped()
  } else {
    PlaybackSettings::remove()
  }
  let settings = settings.with_volume(volume)
  ignore(spawn_audio(source, settings~))
}

///|
pub fn audio_playback_system(_delta : Double) -> Unit {
  cleanup_orphaned_audio()
  for entity, player in audio_players {
    if !entity.is_alive() {
      continue
    }
    let settings = normalize_settings(
      audio_playback_settings.get(entity).unwrap_or(PlaybackSettings::once()),
    )
    audio_playback_settings.set(entity, settings)
    if audio_sinks.get(entity) is Some(sink) {
      sync_audio_sink(entity, player, settings, sink)
    } else {
      start_audio_sink(entity, player, settings)
    }
  }
}
