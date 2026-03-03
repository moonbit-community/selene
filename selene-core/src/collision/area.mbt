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
  filter : CollisionFilter
  mut contains : Set[@entity.Entity]
}

///|
pub fn Area::new(filter : CollisionFilter) -> Area {
  { filter, contains: Set::new() }
}

///|
/// All area components.
pub let areas : Map[@entity.Entity, Area] = Map::new()

///|
/// Trigger event emitted by the fixed-step physics system.
pub struct TriggerEvent {
  area : @entity.Entity
  other : @entity.Entity
  entered : Bool
}

///|
/// Frame-local trigger events generated during the latest fixed step.
let frame_trigger_events : Array[TriggerEvent] = []

///|
fn clear_trigger_events() -> Unit {
  frame_trigger_events.clear()
}

///|
fn push_trigger_event(event : TriggerEvent) -> Unit {
  frame_trigger_events.push(event)
}

///|
pub fn trigger_events() -> Array[TriggerEvent] {
  frame_trigger_events
}

///|
pub fn get_contains(area : @entity.Entity) -> Set[@entity.Entity] {
  areas.get(area).map_or(Set::new(), fn(area) { area.contains })
}
