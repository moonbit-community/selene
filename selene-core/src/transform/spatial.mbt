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
pub fn local_transform(world~ : @ecs.World, entity : @ecs.Entity) -> Transform? {
  (world.get_component(entity) : Spatial?).map(spatial => spatial.pose())
}

///|
pub fn set_local_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  pose : Transform,
) -> Unit {
  guard (world.get_component(entity) : Spatial?) is Some(spatial) else {
    abort("local transform write requires a Spatial component")
  }
  spatial.set_local(pose)
}

///|
/// Returns the world-space pose from the last propagation pass.
pub fn global_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> GlobalTransform? {
  guard world.is_alive(entity) else { None }
  (world.get_component(entity) : Spatial?).map(spatial => spatial.global())
}

///|
/// Computes a world-space pose from the current pose values and parent links.
pub fn compute_global_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> GlobalTransform? {
  guard world.is_alive(entity) else { None }
  let pose = local_transform(world~, entity).unwrap_or_default()
  if world.get_parent(entity) is Some(parent) &&
    compute_global_transform(world~, parent) is Some(parent_global) {
    Some({ affine: parent_global.affine * pose.compute_affine(), })
  } else {
    Some(GlobalTransform::from_transform(pose))
  }
}

///|
/// Spatial queries and fixed hierarchy metadata for one World.
struct Transforms {
  spatials : @ecs.Query[@ecs.Single[Spatial]]
  entities : @ecs.Entities
  hierarchy : @ecs.Hierarchy
}

///|
pub fn Transforms::Transforms(world : @ecs.World) -> Transforms {
  {
    spatials: world.query(),
    entities: Entities(world),
    hierarchy: Hierarchy(world),
  }
}

///|
pub fn Transforms::local_transform(
  self : Transforms,
  entity : @ecs.Entity,
) -> Transform? {
  self.spatials.get(entity).map(value => value.0.pose())
}

///|
pub fn Transforms::set_local(
  self : Transforms,
  entity : @ecs.Entity,
  pose : Transform,
) -> Unit {
  guard self.spatials.get(entity) is Some(Single(spatial)) else {
    abort("local transform write requires a Spatial component")
  }
  spatial.set_local(pose)
}

///|
pub fn Transforms::global_transform(
  self : Transforms,
  entity : @ecs.Entity,
) -> GlobalTransform? {
  guard self.entities.is_alive(entity) else { None }
  self.spatials.get(entity).map(value => value.0.global())
}

///|
pub fn Transforms::compute_global_transform(
  self : Transforms,
  entity : @ecs.Entity,
) -> GlobalTransform? {
  guard self.entities.is_alive(entity) else { None }
  let pose = self.local_transform(entity).unwrap_or_default()
  if self.hierarchy.parent(entity) is Some(parent) &&
    self.compute_global_transform(parent) is Some(parent_global) {
    Some({ affine: parent_global.affine * pose.compute_affine(), })
  } else {
    Some(GlobalTransform::from_transform(pose))
  }
}

///|
pub impl @ecs.SystemParam for Transforms with fn prepare(world) {
  let transforms = Transforms(world)
  _ => transforms
}

///|
pub extend Transforms with @ecs.SystemParam::{prepare}
