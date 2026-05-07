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
/// Sensor area component.
pub(all) struct Area {
  mut active : Bool
  filter : CollisionFilter
  mut contains : Set[@entity.Entity]
} derive(Eq)

///|
pub fn Area::Area(filter : CollisionFilter) -> Area {
  { active: true, filter, contains: Set::from_iter(Iter::empty()) }
}

///|
priv struct AreaWorldStore {
  areas : Map[@entity.Entity, Area]
}

///|
let area_world_stores : Map[UInt, AreaWorldStore] = Map::of([])

///|
fn area_world_store() -> AreaWorldStore {
  let world_id = @ecs.require_current_world().id()
  area_world_stores.get_or_init(world_id, () => { areas: Map::of([]) })
}

///|
/// All area components.
pub fn areas() -> Map[@entity.Entity, Area] {
  area_world_store().areas
}

///|
/// Trigger event emitted by the fixed-step physics system.
pub struct TriggerEvent {
  area : @entity.Entity
  other : @entity.Entity
  entered : Bool
}

///|
/// Trigger event bus.
pub let trigger_event_bus : @event.Events[TriggerEvent] = @event.Events()

///|
fn push_trigger_event(event : TriggerEvent) -> Unit {
  trigger_event_bus.send(event)
}

///|
pub fn get_contains(area : @entity.Entity) -> Set[@entity.Entity] {
  areas().get(area).map_or(Set::from_iter(Iter::empty()), fn(area) { area.contains })
}
