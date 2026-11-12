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
#selene.component
pub(all) struct AudioPlayer {
  source : AudioHandle
}

///|
pub extend AudioPlayer with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioPlayer with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct AudioEvent {
  source : AudioHandle
  settings : PlaybackSettings
  target : @ecs.Entity?
}

///|
pub extend AudioEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioEvent with Eq::{not_equal, equal}

///|
pub fn AudioPlayer::AudioPlayer(source : AudioHandle) -> AudioPlayer {
  { source, }
}

///|
pub fn AudioPlayer::from_path(path : String) -> AudioPlayer {
  AudioPlayer(@asset.load_audio(path))
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
    @ecs.commands(world).prepare_spawn()
  })
  @ecs.commands(world).spawn_prepared(
    plan,
    (AudioPlayer(source), normalize_settings(settings)),
  )
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
