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
/// A local pose and its world-space result for the current propagation pass.
#selene.component
pub struct Spatial {
  priv mut pose : Transform
  priv mut global : GlobalTransform
}

///|
pub fn Spatial::Spatial(pose : Transform) -> Spatial {
  { pose, global: GlobalTransform::from_transform(pose), }
}

///|
pub fn Spatial::pose(self : Spatial) -> Transform {
  self.pose
}

///|
pub fn Spatial::set_local(self : Spatial, pose : Transform) -> Unit {
  self.pose = pose
}

///|
pub fn Spatial::global(self : Spatial) -> GlobalTransform {
  self.global
}

///|
pub fn spatials() -> @ecs.ComponentStore[Spatial] {
  @ecs.components()
}

///|
pub fn local_transform(entity : @ecs.Entity) -> Transform? {
  spatials().get(entity).map(spatial => spatial.pose())
}

///|
pub fn set_local_transform(entity : @ecs.Entity, pose : Transform) -> Unit {
  guard spatials().get(entity) is Some(spatial) else {
    abort("local transform write requires a Spatial component")
  }
  spatial.set_local(pose)
}

///|
/// Returns the world-space pose from the last propagation pass.
pub fn global_transform(entity : @ecs.Entity) -> GlobalTransform? {
  guard entity.is_alive() else { None }
  spatials().get(entity).map(spatial => spatial.global())
}

///|
/// Computes a world-space pose from the current pose values and parent links.
pub fn compute_global_transform(entity : @ecs.Entity) -> GlobalTransform? {
  guard entity.is_alive() else { None }
  let pose = local_transform(entity).unwrap_or_default()
  if entity.get_parent() is Some(parent) &&
    compute_global_transform(parent) is Some(parent_global) {
    Some({ affine: parent_global.affine * pose.compute_affine(), })
  } else {
    Some(GlobalTransform::from_transform(pose))
  }
}
