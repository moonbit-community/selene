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
  rotation : @math.Rotation3
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
    rotation: @math.Rotation3::identity(),
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
pub fn Transform::from_rotation(rotation : @math.Rotation3) -> Transform {
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
  rotation : @math.Rotation3,
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
/// Decomposes finite TRS, returning None for shear. A collapsed axis has no
/// unique orientation, so its basis is completed from the surviving axes.
/// Tolerance bounds normalized basis and reconstruction error. Match it to
/// source precision when importing transforms.
pub fn GlobalTransform::try_decompose_trs(
  self : GlobalTransform,
  tolerance~ : Double = 1.0e-8,
) -> Transform? {
  guard tolerance.is_finite() && tolerance >= 0.0 else { None }
  let { x_axis, y_axis, z_axis, translation, } = self.affine
  let scale_x = x_axis.length()
  let scale_y = y_axis.length()
  let scale_z = z_axis.length()
  guard translation.is_finite() &&
    scale_x.is_finite() &&
    scale_y.is_finite() &&
    scale_z.is_finite() else {
    None
  }
  let x = if scale_x > 0.0 { Some(x_axis.scalar_div(scale_x)) } else { None }
  let y = if scale_y > 0.0 { Some(y_axis.scalar_div(scale_y)) } else { None }
  let z = if scale_z > 0.0 { Some(z_axis.scalar_div(scale_z)) } else { None }
  let (x, y, z) = match (x, y, z) {
    (Some(x), Some(y), Some(z)) => (x, y, z)
    (None, Some(y), Some(z)) => (y.cross(z), y, z)
    (Some(x), None, Some(z)) => (x, z.cross(x), z)
    (Some(x), Some(y), None) => (x, y, x.cross(y))
    (Some(x), None, None) => {
      let (y, z, _) = @math.view_basis_rh(-x, @math.Vec3::y_axis())
      (x, y, z)
    }
    (None, Some(y), None) => {
      let (z, x, _) = @math.view_basis_rh(-y, @math.Vec3::y_axis())
      (x, y, z)
    }
    (None, None, Some(z)) => {
      let (x, y, _) = @math.view_basis_rh(-z, @math.Vec3::y_axis())
      (x, y, z)
    }
    (None, None, None) =>
      (@math.Vec3::x_axis(), @math.Vec3::y_axis(), @math.Vec3::z_axis())
  }
  let sign = if x.cross(y).dot(z) < 0.0 { -1.0 } else { 1.0 }
  guard @math.Rotation3::try_from_basis(x, y.scalar_mul(sign), z, tolerance~)
    is Some(rotation) else {
    None
  }
  let basis = @math.Affine3::from_scale_rotation_translation(
    @math.Vec3::one(),
    rotation,
    @math.Vec3::zero(),
  )
  let allowed_error = tolerance * tolerance
  guard basis.x_axis.distance_squared(x) <= allowed_error &&
    basis.y_axis.distance_squared(y.scalar_mul(sign)) <= allowed_error &&
    basis.z_axis.distance_squared(z) <= allowed_error else {
    None
  }
  Some({ translation, rotation, scale: Vec3(scale_x, scale_y * sign, scale_z), })
}

///|
pub fn GlobalTransform::transform_point(
  self : GlobalTransform,
  point : @math.Vec3,
) -> @math.Vec3 {
  self.affine.transform_point(point)
}

///|
/// Returns the local TRS relative to an invertible parent when representable.
pub fn GlobalTransform::relative_trs(
  self : GlobalTransform,
  parent : GlobalTransform,
) -> Transform? {
  guard parent.affine.inverse() is Some(inverse) else { None }
  GlobalTransform::{ affine: inverse * self.affine, }.try_decompose_trs()
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
