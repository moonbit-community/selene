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
pub fn debug_info_display_system(
  backend : &@system.Backend,
  _delta : Double,
) -> Unit {
  fn print_info() -> Unit {
    let debug_info = backend.get_debug_info()
    println("FPS: \{debug_info.fps}")
    println("System Execution Time (ms):")
    for system_name, time in debug_info.system_execution_time {
      println("  \{system_name}: \{time}")
    }
    @system.timeout(1.0, false, print_info)
  }

  print_info()
}
