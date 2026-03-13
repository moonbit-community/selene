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

  fn new(source : AudioHandle) -> AudioPlayer
} derive(Eq, Show)

///|
pub(all) struct AudioSink {
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
pub(all) struct AudioEvent {
  source : AudioHandle
  settings : PlaybackSettings
  target : @entity.Entity?
} derive(Eq, Show)

///|
priv struct AudioWorldStore {
  audio_players : Map[@entity.Entity, AudioPlayer]
  audio_playback_settings : Map[@entity.Entity, PlaybackSettings]
  audio_sinks : Map[@entity.Entity, AudioSink]
}

///|
let audio_world_stores : Map[UInt, AudioWorldStore] = Map::new()

///|
fn audio_world_store() -> AudioWorldStore {
  let world_id = @ecs.require_current_world().id()
  audio_world_stores.get_or_init(world_id, () => {
    audio_players: Map::new(),
    audio_playback_settings: Map::new(),
    audio_sinks: Map::new(),
  })
}

///|
pub fn audio_players() -> Map[@entity.Entity, AudioPlayer] {
  audio_world_store().audio_players
}

///|
pub fn audio_playback_settings() -> Map[@entity.Entity, PlaybackSettings] {
  audio_world_store().audio_playback_settings
}

///|
pub fn audio_sinks() -> Map[@entity.Entity, AudioSink] {
  audio_world_store().audio_sinks
}

///|
pub let audio_event_bus : @event.Events[AudioEvent] = @event.Events::new()

///|
let audio_event_reader : @event.EventReader[AudioEvent] = @event.EventReader::new()

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
  audio_players().set(entity, player)
  audio_playback_settings().set(entity, normalize_settings(settings))
  if audio_sinks().get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks().remove(entity)
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
pub fn send_audio_event(
  source : AudioHandle,
  settings? : PlaybackSettings = PlaybackSettings::once(),
  target? : @entity.Entity,
) -> Unit {
  audio_event_bus.send({ source, settings, target })
}

///|
pub fn play_one_shot(source : AudioHandle, volume? : Double = 1.0) -> Unit {
  send_audio_event(
    source,
    settings=PlaybackSettings::remove().with_volume(volume),
  )
}

///|
pub fn restart_audio(entity : @entity.Entity) -> Unit {
  if audio_sinks().get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks().remove(entity)
  }
}

///|
pub fn stop_audio(entity : @entity.Entity) -> Unit {
  if audio_sinks().get(entity) is Some(sink) {
    @platform_audio.stop(instance=sink.instance)
    audio_sinks().remove(entity)
  }
  audio_players().remove(entity)
  audio_playback_settings().remove(entity)
}

///|
fn cleanup_orphaned_audio() -> Unit {
  for pair in audio_sinks().to_array() {
    if !pair.0.is_alive() || !audio_players().contains(pair.0) {
      @platform_audio.stop(instance=pair.1.instance)
      audio_sinks().remove(pair.0)
    }
  }
  for pair in audio_playback_settings().to_array() {
    if !pair.0.is_alive() || !audio_players().contains(pair.0) {
      audio_playback_settings().remove(pair.0)
    }
  }
  for pair in audio_players().to_array() {
    if !pair.0.is_alive() {
      audio_players().remove(pair.0)
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
      volume=if settings.muted {
        0.0
      } else {
        sanitize_volume(settings.volume) * global_volume_ref.val
      },
      speed=sanitize_speed(settings.speed),
      loop_=use_loop_mode(settings.mode),
      paused=settings.paused || settings.muted,
    ),
    mode: settings.mode,
    volume: sanitize_volume(settings.volume),
    speed: sanitize_speed(settings.speed),
    paused: settings.paused,
    muted: settings.muted,
    stopped: false,
    finished: false,
  }
  audio_sinks().set(entity, sink)
}

///|
fn finish_audio_sink(entity : @entity.Entity) -> Unit {
  guard audio_sinks().get(entity) is Some(sink) else { return }
  match sink.mode {
    Once => sink.finished = true
    Loop => {
      @platform_audio.stop(instance=sink.instance)
      audio_sinks().remove(entity)
    }
    Remove => stop_audio(entity)
    Despawn => {
      stop_audio(entity)
      entity.destroy()
    }
  }
}

///|
fn sync_audio_sink(entity : @entity.Entity, sink : AudioSink) -> Unit {
  if sink.stopped {
    if !sink.finished {
      @platform_audio.stop(instance=sink.instance)
      sink.finished = true
    }
    return
  }
  if @platform_audio.is_finished(instance=sink.instance) {
    finish_audio_sink(entity)
    return
  }
  if sink.finished {
    return
  }
  @platform_audio.set_volume(
    instance=sink.instance,
    volume=effective_sink_volume(sink),
  )
  @platform_audio.set_speed(instance=sink.instance, speed=sink.speed)
  @platform_audio.set_paused(
    instance=sink.instance,
    paused=should_sink_pause(sink),
  )
}

///|
pub fn audio_event_playback_system(_delta : Double) -> Unit {
  for event in @event.read(audio_event_reader, audio_event_bus) {
    let settings = normalize_settings(event.settings)
    match event.target {
      Some(entity) =>
        attach_audio(entity, AudioPlayer::new(event.source), settings~)
      None => ignore(spawn_audio(event.source, settings~))
    }
  }
}

///|
pub fn audio_playback_system(_delta : Double) -> Unit {
  cleanup_orphaned_audio()
  for entity, player in audio_players() {
    if !entity.is_alive() {
      continue
    }
    if audio_sinks().get(entity) is Some(sink) {
      sync_audio_sink(entity, sink)
    } else {
      let settings = normalize_settings(
        audio_playback_settings()
        .get(entity)
        .unwrap_or(PlaybackSettings::once()),
      )
      audio_playback_settings().set(entity, settings)
      start_audio_sink(entity, player, settings)
    }
  }
}
