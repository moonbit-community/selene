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
fn audio_sinks() -> @ecs.EntityTable[AudioSink] {
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
  sinks : @ecs.EntityTable[AudioSink]
  overrides : @ecs.EntityTable[AudioOverride]
}

///|
let audio_runtime_key : @ecs.ResourceKey[AudioRuntime] = ResourceKey()

///|
fn audio_runtime(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> AudioRuntime {
  audio_runtime_key.get_or_insert_with(world, world => {
    sinks: EntityTable(world),
    overrides: EntityTable(world),
  })
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
fn remove_audio_sink(runtime : AudioRuntime, entity : @ecs.Entity) -> Unit {
  if runtime.sinks.remove_and_get(entity) is Some(sink) && !sink.finished {
    @platform_audio.stop(instance=sink.instance)
  }
}

///|
pub fn restart_audio(entity : @ecs.Entity) -> Unit {
  remove_audio_sink(audio_runtime(), entity)
  let overrides = audio_runtime().overrides
  if overrides.get(entity) is Some(Stopped) {
    overrides.remove(entity)
  }
}

///|
pub fn stop_audio(entity : @ecs.Entity) -> Unit {
  guard entity.is_valid_in(@ecs.require_current_world()) else { return }
  remove_audio_sink(audio_runtime(), entity)
  audio_runtime().overrides.set(entity, Stopped)
}

///|
fn cleanup_orphaned_audio(
  playback : AudioPlayback,
  stop : (@platform_audio.AudioInstance) -> Unit,
) -> Unit {
  let runtime = playback.runtime
  runtime.sinks.retain((entity, sink) => {
    if playback.entities.is_alive(entity) {
      return true
    }
    if !sink.finished {
      stop(sink.instance)
    }
    false
  })
  runtime.overrides.retain((entity, _) => playback.entities.is_valid(entity))
}

///|
fn start_audio_sink(
  playback : AudioPlayback,
  entity : @ecs.Entity,
  player : AudioPlayer,
  settings : PlaybackSettings,
) -> Unit {
  guard player.source.get() is Some(_) else { return }
  let sink = {
    instance: @platform_audio.play_audio(
      source=player.source,
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
  playback.runtime.sinks.set(entity, sink)
}

///|
fn finish_audio_sink(playback : AudioPlayback, entity : @ecs.Entity) -> Unit {
  guard playback.runtime.sinks.get(entity) is Some(sink) else { return }
  sink.finished = true
  match sink.mode {
    Once => ()
    Loop => remove_audio_sink(playback.runtime, entity)
    Remove => {
      remove_audio_sink(playback.runtime, entity)
      if playback.entities.is_valid(entity) {
        playback.runtime.overrides.set(entity, Stopped)
      }
    }
    Despawn => {
      playback.runtime.sinks.remove(entity)
      playback.commands.delete(entity)
    }
  }
}

///|
fn sync_audio_sink(
  playback : AudioPlayback,
  entity : @ecs.Entity,
  sink : AudioSink,
) -> Unit {
  if sink.stopped {
    if !sink.finished {
      @platform_audio.stop(instance=sink.instance)
      sink.finished = true
    }
    return
  }
  if @platform_audio.is_finished(instance=sink.instance) {
    finish_audio_sink(playback, entity)
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
pub fn audio_event_playback_system(
  playback : AudioPlayback,
  events : AudioEvents,
) -> Unit {
  for event in events.reader.read() {
    let settings = normalize_settings(event.settings)
    match event.target {
      Some(entity) => {
        guard playback.entities.is_valid(entity) else { continue }
        playback.runtime.overrides.set(
          entity,
          Attached(AudioPlayer(event.source), settings),
        )
        remove_audio_sink(playback.runtime, entity)
      }
      None =>
        ignore(
          playback.commands.spawn_prepared(
            playback.plan,
            (AudioPlayer(event.source), settings),
          ),
        )
    }
  }
}

///|
pub fn audio_playback_system(
  players : @ecs.Query[@ecs.Single[AudioPlayer]],
  query_playback_settings : @ecs.Query[@ecs.Single[PlaybackSettings]],
  playback : AudioPlayback,
) -> Unit {
  cleanup_orphaned_audio(playback, instance => @platform_audio.stop(instance~))
  let runtime = playback.runtime
  for entity, Single(player) in players {
    guard playback.entities.is_alive(entity) &&
      !runtime.overrides.contains(entity) else {
      continue
    }
    update_audio_playback(
      playback,
      entity,
      player,
      query_playback_settings
      .get(entity)
      .map(value => value.0)
      .unwrap_or(PlaybackSettings::once()),
    )
  }
  for entity, setting in runtime.overrides {
    if playback.entities.is_alive(entity) &&
      setting is Attached(player, settings) {
      update_audio_playback(playback, entity, player, settings)
    }
  }
}

///|
fn update_audio_playback(
  playback : AudioPlayback,
  entity : @ecs.Entity,
  player : AudioPlayer,
  settings : PlaybackSettings,
) -> Unit {
  if playback.runtime.sinks.get(entity) is Some(sink) {
    sync_audio_sink(playback, entity, sink)
  } else {
    start_audio_sink(playback, entity, player, normalize_settings(settings))
  }
}

///|
/// Returns the playback control handle for an entity in the active World.
/// A sink is available after the audio playback system starts its instance.
pub fn audio_sink(entity : @ecs.Entity) -> AudioSink? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  audio_sinks().get(entity)
}

///|
/// Audio runtime state and deferred commands bound to one World.
struct AudioPlayback {
  runtime : AudioRuntime
  commands : @ecs.Commands
  plan : @ecs.SpawnPlan[(AudioPlayer, PlaybackSettings)]
  entities : @ecs.Entities
}

///|
pub fn AudioPlayback::AudioPlayback(world : @ecs.World) -> AudioPlayback {
  {
    runtime: audio_runtime(world~),
    commands: @ecs.commands(world),
    plan: audio_spawn_plan.get_or_insert_with(world, world => {
      @ecs.commands(world).prepare_spawn()
    }),
    entities: Entities(world),
  }
}

///|
pub impl @ecs.SystemParam for AudioPlayback with fn prepare(world) {
  let playback = AudioPlayback(world)
  _ => playback
}

///|
pub extend AudioPlayback with @ecs.SystemParam::{prepare}

///|
struct AudioEvents {
  reader : @event.EventReaderView[AudioEvent]
}

///|
pub fn AudioEvents::AudioEvents(world : @ecs.World) -> AudioEvents {
  { reader: audio_event_reader.bind(world, audio_event_bus), }
}

///|
pub impl @ecs.SystemParam for AudioEvents with fn prepare(world) {
  let events = AudioEvents(world)
  _ => events
}

///|
pub extend AudioEvents with @ecs.SystemParam::{prepare}
