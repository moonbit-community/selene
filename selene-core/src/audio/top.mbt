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
#derive(Eq, Debug)
pub(all) enum PlaybackMode {
  Once
  Loop
  Remove
  Despawn
}

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
#derive(Eq, Debug)
#selene.component
pub(all) struct AudioPlayer {
  source : AudioHandle
}

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
#derive(Eq, Debug)
pub(all) struct AudioEvent {
  source : AudioHandle
  settings : PlaybackSettings
  target : @ecs.Entity?
}

///|
pub fn audio_players() -> @ecs.ComponentStore[AudioPlayer] {
  @ecs.components()
}

///|
pub fn audio_playback_settings() -> @ecs.ComponentStore[PlaybackSettings] {
  @ecs.components()
}

///|
pub fn audio_sinks() -> Map[@ecs.Entity, AudioSink] {
  audio_runtime().sinks
}

///|
pub let audio_event_bus : @event.Events[AudioEvent] = Events()

///|
let audio_event_reader : @event.EventReader[AudioEvent] = EventReader()

///|
let global_volume_ref : Ref[Double] = Ref(1.0)

///|
priv enum AudioOverride {
  Attached(AudioPlayer, PlaybackSettings)
  Stopped
}

///|
priv struct AudioRuntime {
  sinks : Map[@ecs.Entity, AudioSink]
  overrides : Map[@ecs.Entity, AudioOverride]
}

///|
let audio_runtime_key : @ecs.ResourceKey[AudioRuntime] = ResourceKey()

///|
fn audio_runtime() -> AudioRuntime {
  audio_runtime_key.get_or_insert_with(@ecs.require_current_world(), _ => {
    sinks: {},
    overrides: {},
  })
}

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
pub fn AudioPlayer::AudioPlayer(source : AudioHandle) -> AudioPlayer {
  { source, }
}

///|
pub fn AudioPlayer::from_path(path : String) -> AudioPlayer {
  AudioPlayer(@asset.load_audio(path))
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
  entity : @ecs.Entity,
  player : AudioPlayer,
  settings~ : PlaybackSettings = PlaybackSettings::once(),
) -> Unit {
  guard entity.is_valid_in(@ecs.require_current_world()) else { return }
  audio_runtime().overrides.set(
    entity,
    Attached(player, normalize_settings(settings)),
  )
  remove_audio_sink(entity)
}

///|
let audio_spawn_plan : @ecs.ResourceKey[
  @ecs.SpawnPlan[(AudioPlayer, PlaybackSettings)],
] = ResourceKey()

///|
pub fn spawn_audio(
  source : AudioHandle,
  settings~ : PlaybackSettings = PlaybackSettings::once(),
) -> @ecs.Entity {
  let world = @ecs.require_current_world()
  let plan = audio_spawn_plan.get_or_insert_with(world, world => {
    world.prepare_spawn()
  })
  plan.spawn((AudioPlayer(source), normalize_settings(settings)))
}

///|
pub fn send_audio_event(
  source : AudioHandle,
  settings~ : PlaybackSettings = PlaybackSettings::once(),
  target? : @ecs.Entity,
) -> Unit {
  audio_event_bus.send({ source, settings, target, })
}

///|
pub fn play_one_shot(source : AudioHandle, volume~ : Double = 1.0) -> Unit {
  send_audio_event(
    source,
    settings=PlaybackSettings::despawn().with_volume(volume),
  )
}

///|
fn remove_audio_sink(entity : @ecs.Entity) -> Unit {
  if audio_sinks().remove_and_get(entity) is Some(sink) && !sink.finished {
    @platform_audio.stop(instance=sink.instance)
  }
}

///|
pub fn restart_audio(entity : @ecs.Entity) -> Unit {
  remove_audio_sink(entity)
  let overrides = audio_runtime().overrides
  if overrides.get(entity) is Some(Stopped) {
    overrides.remove(entity)
  }
}

///|
pub fn stop_audio(entity : @ecs.Entity) -> Unit {
  guard entity.is_valid_in(@ecs.require_current_world()) else { return }
  remove_audio_sink(entity)
  audio_runtime().overrides.set(entity, Stopped)
}

///|
fn cleanup_orphaned_audio(
  stop : (@platform_audio.AudioInstance) -> Unit,
) -> Unit {
  let world = @ecs.require_current_world()
  let alive = @ecs.alive_in_world(world)
  let runtime = audio_runtime()
  runtime.sinks.retain((entity, sink) => {
    if alive(entity) {
      return true
    }
    if !sink.finished {
      stop(sink.instance)
    }
    false
  })
  runtime.overrides.retain((entity, _) => entity.is_valid_in(world))
}

///|
fn start_audio_sink(
  entity : @ecs.Entity,
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
fn finish_audio_sink(entity : @ecs.Entity) -> Unit {
  guard audio_sinks().get(entity) is Some(sink) else { return }
  sink.finished = true
  match sink.mode {
    Once => ()
    Loop => remove_audio_sink(entity)
    Remove => stop_audio(entity)
    Despawn => {
      audio_sinks().remove(entity)
      ignore(entity.delete())
    }
  }
}

///|
fn sync_audio_sink(entity : @ecs.Entity, sink : AudioSink) -> Unit {
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
      Some(entity) => attach_audio(entity, AudioPlayer(event.source), settings~)
      None => ignore(spawn_audio(event.source, settings~))
    }
  }
}

///|
pub fn audio_playback_system(_delta : Double) -> Unit {
  cleanup_orphaned_audio(instance => @platform_audio.stop(instance~))
  let runtime = audio_runtime()
  let players = audio_players()
  for entity, player in players {
    guard entity.is_alive() && !runtime.overrides.contains(entity) else {
      continue
    }
    update_audio_playback(
      entity,
      player,
      audio_playback_settings().get(entity).unwrap_or(PlaybackSettings::once()),
    )
  }
  for (entity, playback) in runtime.overrides.to_array() {
    if entity.is_alive() && playback is Attached(player, settings) {
      update_audio_playback(entity, player, settings)
    }
  }
}

///|
fn update_audio_playback(
  entity : @ecs.Entity,
  player : AudioPlayer,
  settings : PlaybackSettings,
) -> Unit {
  if audio_sinks().get(entity) is Some(sink) {
    sync_audio_sink(entity, sink)
  } else {
    start_audio_sink(entity, player, normalize_settings(settings))
  }
}
