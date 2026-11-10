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
#derive(Eq, Debug)
pub(all) struct Transform {
  translation : @math.Vec3
  rotation : @math.Quat
  scale : @math.Vec3
}

///|
#derive(Eq, Debug)
pub(all) struct GlobalTransform {
  affine : @math.Affine3
}

///|
pub fn Transform::identity() -> Transform {
  {
    translation: @math.Vec3::zero(),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  }
}

///|
pub impl Default for Transform with fn default() -> Transform {
  Transform::identity()
}

///|
pub fn Transform::from_translation(translation : @math.Vec3) -> Transform {
  { ..Transform::identity(), translation, }
}

///|
pub fn Transform::from_xyz(x : Double, y : Double, z : Double) -> Transform {
  Transform::from_translation(Vec3(x, y, z))
}

///|
pub fn Transform::from_rotation(rotation : @math.Quat) -> Transform {
  { ..Transform::identity(), rotation, }
}

///|
pub fn Transform::from_scale(scale : @math.Vec3) -> Transform {
  { ..Transform::identity(), scale, }
}

///|
pub fn Transform::with_translation(
  self : Transform,
  translation : @math.Vec3,
) -> Transform {
  { ..self, translation, }
}

///|
pub fn Transform::with_rotation(
  self : Transform,
  rotation : @math.Quat,
) -> Transform {
  { ..self, rotation, }
}

///|
pub fn Transform::with_scale(self : Transform, scale : @math.Vec3) -> Transform {
  { ..self, scale, }
}

///|
pub fn Transform::compute_affine(self : Transform) -> @math.Affine3 {
  @math.Affine3::from_scale_rotation_translation(
    self.scale,
    self.rotation,
    self.translation,
  )
}

///|
pub fn GlobalTransform::identity() -> GlobalTransform {
  { affine: @math.Affine3::identity(), }
}

///|
pub impl Default for GlobalTransform with fn default() -> GlobalTransform {
  GlobalTransform::identity()
}

///|
pub fn GlobalTransform::from_transform(
  transform : Transform,
) -> GlobalTransform {
  { affine: transform.compute_affine(), }
}

///|
pub fn GlobalTransform::translation(self : GlobalTransform) -> @math.Vec3 {
  self.affine.translation
}

///|
pub fn GlobalTransform::compute_transform(self : GlobalTransform) -> Transform {
  let x_axis = self.affine.x_axis
  let y_axis = self.affine.y_axis
  let z_axis = self.affine.z_axis
  let mut scale_x = x_axis.length()
  let mut scale_y = y_axis.length()
  let mut scale_z = z_axis.length()
  if scale_x <= 0.000000001 {
    scale_x = 1.0
  }
  if scale_y <= 0.000000001 {
    scale_y = 1.0
  }
  if scale_z <= 0.000000001 {
    scale_z = 1.0
  }
  let basis_x = x_axis.scalar_div(scale_x)
  let basis_y = y_axis.scalar_div(scale_y)
  let mut basis_z = z_axis.scalar_div(scale_z)
  if basis_x.cross(basis_y).dot(basis_z) < 0.0 {
    scale_z = -scale_z
    basis_z = -basis_z
  }
  {
    translation: self.translation(),
    rotation: @math.Quat::from_basis(basis_x, basis_y, basis_z),
    scale: Vec3(scale_x, scale_y, scale_z),
  }
}

///|
pub fn GlobalTransform::transform_point(
  self : GlobalTransform,
  point : @math.Vec3,
) -> @math.Vec3 {
  self.affine.transform_point3(point)
}

///|
pub fn GlobalTransform::reparented_to(
  self : GlobalTransform,
  parent : GlobalTransform,
) -> Transform {
  match parent.affine.inverse() {
    Some(inverse_parent) =>
      GlobalTransform::{ affine: inverse_parent * self.affine, }.compute_transform()
    None => self.compute_transform()
  }
}

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
