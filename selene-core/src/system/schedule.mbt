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
/// Defines when and how often a system should be executed within the game loop.
///
/// Constructors:
///
/// * `Startup` : Executes once at application startup before the main loop
///   begins.
/// * `Update` : Executes every frame during the main update loop.
/// * `Render(Int)` : Executes during the render phase with the specified
///   priority. Lower numbers execute first.
/// * `UpdateFrame(UInt)` : Executes every specified number of frames. For
///   example, `UpdateFrame(60)` executes once every 60 frames.
/// * `UpdateTime(Double)` : Executes at regular time intervals specified in
///   seconds. For example, `UpdateTime(1.0)` executes once per second.
///
pub(all) enum Schedule {
  Startup
  Update
  Render(Int) // priority
  UpdateFrame(UInt) // every x frames
  UpdateTime(Double) // as interval
}
