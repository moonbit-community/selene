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
pub fn audio_sinks() -> @ecs.EntityTable[AudioSink] {
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
fn audio_runtime() -> AudioRuntime {
  audio_runtime_key.get_or_insert_with(@ecs.require_current_world(), world => {
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
  for entity, playback in runtime.overrides {
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
