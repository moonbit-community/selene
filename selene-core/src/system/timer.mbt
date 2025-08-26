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
priv struct FrameTimer {
  mut rest : Int
  callback : () -> Unit
}

///|
let timers : Array[FrameTimer] = Array::new()

///|
pub fn timeout_with_frames(frames : Int, callback : () -> Unit) -> Unit {
  timers.push({ rest: frames, callback })
}

///|
pub fn timer_system(_backend : &Backend) -> Unit {
  for timer in timers {
    timer.rest -= 1
    if timer.rest <= 0 {
      (timer.callback)()
    }
  }
  timers.retain(fn(timer) { timer.rest > 0 })
}
