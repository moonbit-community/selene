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
pub fn transform_propagate_system(_delta : Double) -> Unit {
  let is_alive = @ecs.alive_in_world(@ecs.require_current_world())
  let spatials = spatials()
  for entity in @ecs.get_roots() {
    propagate_spatial(entity, None, spatials, is_alive)
  }
}

///|
fn propagate_spatial(
  entity : @ecs.Entity,
  parent_global : GlobalTransform?,
  spatials : @ecs.ComponentStore[Spatial],
  is_alive : (@ecs.Entity) -> Bool,
) -> Unit {
  let global = match spatials.get(entity) {
    Some(spatial) => {
      let affine = spatial.pose.compute_affine()
      let global = match parent_global {
        Some(parent) => GlobalTransform::{ affine: parent.affine * affine, }
        None => { affine, }
      }
      spatial.global = global
      Some(global)
    }
    None => parent_global
  }
  for child in entity.get_children() {
    if is_alive(child) {
      propagate_spatial(child, global, spatials, is_alive)
    }
  }
}
