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
/// Schedules a callback function to be executed after a specified time delay.
///
/// Parameters:
///
/// * `time` : The delay in seconds before the callback is executed.
/// * `callback` : The function to be called when the timer expires.
/// * `pausible` : Whether the timer should be affected by the pausible timer
///   system. Defaults to `true`. If `true`, the timer will be processed by
///   `timer_system()` and affected by `set_time_scale()`, if `false`, it 
///   will be processed by `realtime_timer_system()` and not affected by 
///   `set_time_scale()`.
///
/// Example:
///
/// ```moonbit
/// // Schedule a callback to run after 2.5 seconds (pausible timer)
/// @system.timeout(2.5, fn() { println("Timer expired!") })
///
/// // Schedule a realtime callback that won't be paused
/// @system.timeout(1.0, fn() { println("Realtime timer!") }, pausible=false)
/// ```
///
pub fn timeout(
  time : Double,
  callback : () -> Unit,
  pausible? : Bool = true,
) -> Unit {
  timers.push({ rest: time, pausible, callback })
}

///|
/// Updates and processes all pausible timers by the given time delta.
///
/// Parameters:
///
/// * `delta` : The time elapsed since the last update, in seconds.
///
pub fn timer_system(delta : Double) -> Unit {
  for timer in timers.filter(timer => timer.pausible) {
    timer.rest -= delta
    if timer.rest <= 0 {
      (timer.callback)()
    }
  }
  timers.retain(fn(timer) { timer.rest > 0 })
}

///|
/// Updates and processes all realtime timers by the given time delta.
///
/// Parameters:
///
/// * `delta` : The time elapsed since the last update, in seconds.
///
pub fn realtime_timer_system(_delta : Double) -> Unit {
  for timer in timers.filter(timer => !timer.pausible) {
    let realtime_delta = @backend.get_realtime_delta()
    timer.rest -= realtime_delta
    if timer.rest <= 0 {
      (timer.callback)()
    }
  }
  timers.retain(fn(timer) { timer.rest > 0 })
}
