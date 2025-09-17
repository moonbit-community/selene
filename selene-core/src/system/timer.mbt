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
priv struct Timer {
  mut rest : Double
  pausible : Bool
  callback : () -> Unit
}

///|
let timers : Array[Timer] = Array::new()

///|
pub fn timeout(time : Double, pausible : Bool, callback : () -> Unit) -> Unit {
  timers.push({ rest: time, pausible, callback })
}

///|
pub fn timer_system(_backend : &Backend, delta : Double) -> Unit {
  for timer in timers.filter(timer => timer.pausible) {
    if timer.pausible {

    }
    timer.rest -= delta
    if timer.rest <= 0 {
      (timer.callback)()
    }
  }
  timers.retain(fn(timer) { timer.rest > 0 })
}

///|
pub fn realtime_timer_system(_backend : &Backend, delta : Double) -> Unit {
  for timer in timers.filter(timer => !timer.pausible) {
    if timer.pausible {

    }
    timer.rest -= delta
    if timer.rest <= 0 {
      (timer.callback)()
    }
  }
  timers.retain(fn(timer) { timer.rest > 0 })
}
