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
test "events: reader consumes unseen events in order" {
  let events : Events[Int] = Events::new()
  let reader : EventReader[Int] = EventReader::new()
  events.send(10)
  events.send(20)
  inspect(events.read(reader), content="[10, 20]")
  inspect(events.read(reader), content="[]")
}

///|
test "events: readers are independent" {
  let events : Events[Int] = Events::new()
  let reader_a : EventReader[Int] = EventReader::new()
  let reader_b : EventReader[Int] = EventReader::new()
  events.send(7)
  inspect(events.read(reader_a), content="[7]")
  inspect(events.read(reader_a), content="[]")
  inspect(events.read(reader_b), content="[7]")
}

///|
test "events: update keeps last and current cycle payloads" {
  let events : Events[Int] = Events::new()
  let reader : EventReader[Int] = EventReader::new()
  events.send(1)
  events.update()
  events.send(2)
  inspect(events.read(reader), content="[1, 2]")
  events.update()
  events.update()
  inspect(events.read(reader), content="[]")
}

///|
test "events: trigger dispatches observers while send does not" {
  let events : Events[Int] = Events::new()
  let received : Array[Int] = []
  events.observe_global(fn(item) { received.push(item.event) }) |> ignore

  events.send(1)
  events.dispatch_observers()
  inspect(received, content="[]")

  events.trigger(2, None)
  events.dispatch_observers()
  inspect(received, content="[2]")
}

///|
test "events: entity observer only receives targeted trigger" {
  let events : Events[Int] = Events::new()
  let target = @entity.Entity::new()
  let other = @entity.Entity::new()
  let received : Array[Int] = []
  events.observe_entity(target, fn(item) { received.push(item.event) })
  |> ignore

  events.trigger(3, Some(other))
  events.dispatch_observers()
  inspect(received, content="[]")

  events.trigger(4, Some(target))
  events.dispatch_observers()
  inspect(received, content="[4]")
}

///|
test "events: unobserve removes callback" {
  let events : Events[Int] = Events::new()
  let received : Array[Int] = []
  let handle = events.observe_global(fn(item) { received.push(item.event) })
  events.unobserve(handle)
  events.trigger(5, None)
  events.dispatch_observers()
  inspect(received, content="[]")
}
