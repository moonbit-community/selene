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
fn int_array_matches(values : Array[Int], expected : Array[Int]) -> Bool {
  let mut matches = values.length() == expected.length()
  if matches {
    for index in 0..<values.length() {
      if values[index] != expected[index] {
        matches = false
      }
    }
  }
  matches
}

///|
test "events: reader consumes unseen events in order" {
  let events : Events[Int] = Events()
  let reader : EventReader[Int] = EventReader()
  events.send(10)
  events.send(20)
  inspect(int_array_matches(events.read(reader), [10, 20]), content="true")
  inspect(int_array_matches(events.read(reader), []), content="true")
}

///|
test "events: readers are independent" {
  let events : Events[Int] = Events()
  let reader_a : EventReader[Int] = EventReader()
  let reader_b : EventReader[Int] = EventReader()
  events.send(7)
  inspect(int_array_matches(events.read(reader_a), [7]), content="true")
  inspect(int_array_matches(events.read(reader_a), []), content="true")
  inspect(int_array_matches(events.read(reader_b), [7]), content="true")
}

///|
test "events: update keeps last and current cycle payloads" {
  let events : Events[Int] = Events()
  let reader : EventReader[Int] = EventReader()
  events.send(1)
  events.update()
  events.send(2)
  inspect(int_array_matches(events.read(reader), [1, 2]), content="true")
  events.update()
  events.update()
  inspect(int_array_matches(events.read(reader), []), content="true")
}

///|
test "events: trigger dispatches observers while send does not" {
  let events : Events[Int] = Events()
  let received : Array[Int] = []
  events.observe_global(fn(item) { received.push(item.event) }) |> ignore

  events.send(1)
  events.dispatch_observers()
  inspect(int_array_matches(received, []), content="true")

  events.trigger(2, None)
  events.dispatch_observers()
  inspect(int_array_matches(received, [2]), content="true")
}

///|
test "events: entity observer only receives targeted trigger" {
  let events : Events[Int] = Events()
  let target = @entity.Entity()
  let other = @entity.Entity()
  let received : Array[Int] = []
  events.observe_entity(target, fn(item) { received.push(item.event) })
  |> ignore

  events.trigger(3, Some(other))
  events.dispatch_observers()
  inspect(int_array_matches(received, []), content="true")

  events.trigger(4, Some(target))
  events.dispatch_observers()
  inspect(int_array_matches(received, [4]), content="true")
}

///|
test "events: unobserve removes callback" {
  let events : Events[Int] = Events()
  let received : Array[Int] = []
  let handle = events.observe_global(fn(item) { received.push(item.event) })
  events.unobserve(handle)
  events.trigger(5, None)
  events.dispatch_observers()
  inspect(int_array_matches(received, []), content="true")
}

///|
test "events: frame update systems are world-scoped and require explicit registration" {
  let events : Events[Int] = Events()
  let world_a = @ecs.World()
  let world_b = @ecs.World()
  let reader_a : EventReader[Int] = EventReader()
  let reader_b : EventReader[Int] = EventReader()

  events.register_to_world(world_a)

  @ecs.set_current_world(world_a)
  events.send(1)
  event_frame_update_system(0.0)
  event_frame_update_system(0.0)
  inspect(int_array_matches(events.read(reader_a), []), content="true")

  @ecs.set_current_world(world_b)
  events.send(2)
  event_frame_update_system(0.0)
  event_frame_update_system(0.0)
  inspect(int_array_matches(events.read(reader_b), [2]), content="true")
  @ecs.set_current_world(@ecs.bootstrap_world())
}
