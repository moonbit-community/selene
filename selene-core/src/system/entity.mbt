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
struct Entity(UInt) derive(Eq, Show, Hash)

///|
pub let all_entities : @set.Set[Entity] = @set.Set::new()

///|
pub fn Entity::is_alive(e : Entity) -> Bool {
  all_entities.contains(e)
}

///|
let entity_generator : Ref[UInt] = { val: 0 }

///|
pub fn Entity::new() -> Entity {
  let entity = entity_generator.val
  entity_generator.val += 1
  all_entities.add(entity)
  entity
}

///|
pub fn Entity::destroy(e : Entity) -> Unit {
  defer_event(fn() { all_entities.remove(e) })
}

///|
pub fn Entity::respawn(e : Entity) -> Unit {
  all_entities.add(e)
}
