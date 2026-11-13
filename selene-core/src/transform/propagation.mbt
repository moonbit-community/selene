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
pub fn transform_propagate_system(
  entities : @ecs.Entities,
  hierarchy : @ecs.Hierarchy,
  spatials : @ecs.Query[@ecs.Single[Spatial]],
) -> Unit {
  for entity in hierarchy.roots() {
    propagate_spatial(hierarchy, entities, entity, None, spatials)
  }
}

///|
fn propagate_spatial(
  hierarchy : @ecs.Hierarchy,
  entities : @ecs.Entities,
  entity : @ecs.Entity,
  parent_global : GlobalTransform?,
  spatials : @ecs.Query[@ecs.Single[Spatial]],
) -> Unit {
  let global = match spatials.get(entity).map(value => value.0) {
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
  for child in hierarchy.children(entity) {
    if entities.is_alive(child) {
      propagate_spatial(hierarchy, entities, child, global, spatials)
    }
  }
}
