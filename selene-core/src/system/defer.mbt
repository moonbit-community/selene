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
pub typealias () -> Unit as Event

///|
/// Stores a collection of events that will be executed in a deferred manner
/// during the next frame.
///
/// This array acts as a queue for events that need to be processed later,
/// typically used in game development scenarios where certain operations need
/// to be delayed until the appropriate system update cycle. Events are added to
/// this collection via `defer_event` and processed by `deferred_event_system`.
///
/// The array is automatically cleared after all deferred events have been
/// executed in each frame, ensuring that events are only processed once and the
/// queue doesn't accumulate stale events across multiple frames.
///
let deferred_events : Array[Event] = Array::new()

///|
/// Processes all deferred events and clears the event queue.
///
/// Executes all events that have been added to the deferred events queue during
/// the current frame cycle, then removes them from the queue to prepare for the
/// next frame. This system is typically called once per frame to handle events
/// that need to be processed in a delayed manner.
///
/// Parameters:
///
/// * `backend` : The backend instance used for rendering and system operations
///   (unused in this implementation).
/// 
/// Usage:
/// 
/// ```notest
/// app.add_system(@camera.deferred_event_system)
/// ```
///
/// Example:
///
/// ```notest
/// // Add some events to be processed later
/// defer_event(fn() { println("First event") })
/// defer_event(fn() { println("Second event") }) 
/// ```
/// 
pub fn deferred_event_system(_backend : &Backend, _delta : Double) -> Unit {
  while deferred_events.pop() is Some(event) {
    event()
  }
}

///|
/// Adds an event to the deferred events queue to be executed in the next frame.
///
/// Parameters:
///
/// * `event` : The event function to be executed later.
///
/// Example:
///
/// ```notest
/// // Schedule a simple logging event
/// @system.defer_event(fn() { println("This will be executed next frame") })
///
/// // Schedule an event that modifies game state
/// @system.defer_event(fn() { 
///   // Some game logic that needs to be delayed
///   player.respawn()
/// })
/// ```
///
pub fn defer_event(event : Event) -> Unit {
  deferred_events.push(event)
}
