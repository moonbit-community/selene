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
/// Children will inherit their parent's positions (with an offset) and liveness
///
pub fn inherit_position_system(_delta : Double) -> Unit {
  let roots = @entity.get_roots()
  for p in roots {
    adjust_children(p)
  }
}

///|
fn adjust_children(entity : @entity.Entity) -> Unit {
  for c in entity.get_children() {
    guard c.is_alive() else { continue }
    guard @position.positions.get(entity) is Some(parent_position) else {
      continue
    }
    let offset = c.get_offset()
    @position.positions.set(c, parent_position.0 + offset)
    adjust_children(c)
  }
}
