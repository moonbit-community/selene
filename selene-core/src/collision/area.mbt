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
#derive(Eq)
#selene.component
pub(all) struct Area {
  mut active : Bool
  filter : CollisionFilter
  mut contains : Set[@ecs.Entity]
}

///|
pub fn Area::Area(filter : CollisionFilter) -> Area {
  { active: true, filter, contains: Set([]), }
}

///|
/// All area components.
pub fn areas() -> @ecs.ComponentStore[Area] {
  @ecs.components()
}

///|
/// Trigger event emitted by the fixed-step physics system.
pub struct TriggerEvent {
  area : @ecs.Entity
  other : @ecs.Entity
  entered : Bool
}

///|
/// Trigger event bus.
pub let trigger_event_bus : @event.Events[TriggerEvent] = Events()

///|
fn push_trigger_event(event : TriggerEvent) -> Unit {
  trigger_event_bus.send(event)
}

///|
pub fn get_contains(area : @ecs.Entity) -> Set[@ecs.Entity] {
  areas().get(area).map_or(Set([]), fn(area) { area.contains })
}
