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
/// A handle to one timeout. Cancellation is independent of the active World.
struct TimerHandle {
  mut callback : (() -> Unit)?
}

///|
/// Cancels a pending callback. Returns true only if it was still pending.
pub fn TimerHandle::cancel(self : TimerHandle) -> Bool {
  let pending = self.callback is Some(_)
  self.callback = None
  pending
}

///|
priv struct Timer {
  mut remaining : Double
  pausible : Bool
  handle : TimerHandle
}

///|
#selene.resource
struct Timers {
  pending : Array[Timer]
  mut ticking : Bool
}

///|
pub fn Timers::Timers(world : @ecs.World) -> Timers {
  let key : @ecs.ResourceKey[Timers] = @ecs.Resource::resource_key()
  key.get_or_insert_with(world, _ => { pending: [], ticking: false, })
}

///|
/// Schedules a one-shot callback in the active World and returns its handle.
/// The delay is in seconds. By default it uses scaled frame time.
/// Pass `pausible=false` to use unscaled frame time.
/// A timeout scheduled by a callback is first eligible on the next timer tick.
pub fn timeout(
  time : Double,
  callback : () -> Unit,
  pausible~ : Bool = true,
) -> TimerHandle {
  Timers(@ecs.require_current_world()).timeout(time, callback, pausible~)
}

///|
/// Schedules a callback in the timer queue bound to this resource.
pub fn Timers::timeout(
  self : Timers,
  time : Double,
  callback : () -> Unit,
  pausible~ : Bool = true,
) -> TimerHandle {
  let handle = { callback: Some(callback), }
  self.pending.push({ remaining: time, pausible, handle, })
  handle
}

///|
fn tick_timers(state : Timers, scaled : Double?, unscaled : Double?) -> Unit {
  let world = @ecs.require_current_world()
  guard !state.ticking && !state.pending.is_empty() else { return }
  state.ticking = true
  defer {
    state.ticking = false
    @ecs.set_current_world(world)
  }
  let due = []
  state.pending.retain(timer => {
    if timer.handle.callback is None {
      return false
    }
    let delta = if timer.pausible { scaled } else { unscaled }
    if delta is Some(delta) {
      timer.remaining -= delta
      if timer.remaining <= 0.0 {
        due.push(timer.handle)
        return false
      }
    }
    true
  })
  for handle in due {
    if handle.callback is Some(callback) {
      handle.callback = None
      @ecs.set_current_world(world)
      callback()
    }
  }
}

///|
/// Advances both timer clocks in one tick. The default plugins use this system.
pub fn timers_system(timers : Timers, time : Time) -> Unit {
  tick_timers(timers, Some(time.delta()), Some(time.raw_delta()))
}

///|
/// Advances only scaled timers by the given delta in seconds.
pub fn timer_system(timers : Timers, time : Time) -> Unit {
  tick_timers(timers, Some(time.delta()), None)
}

///|
/// Advances only unscaled timers using the active World's raw frame delta.
pub fn realtime_timer_system(timers : Timers, time : Time) -> Unit {
  tick_timers(timers, None, Some(time.raw_delta()))
}

///|
pub impl @ecs.SystemParam for Timers with fn prepare(world) {
  let timers = Timers(world)
  _ => timers
}

///|
pub extend Timers with @ecs.SystemParam::{prepare}
