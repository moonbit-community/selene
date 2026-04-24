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
pub(all) struct Transform {
  translation : @math.Vec3
  rotation : @math.Quat
  scale : @math.Vec3
} derive(Eq, Debug)

///|
pub(all) struct GlobalTransform {
  affine : @math.Affine3
} derive(Eq, Debug)

///|
pub fn Transform::identity() -> Transform {
  {
    translation: @math.Vec3::zero(),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  }
}

///|
pub impl Default for Transform with default() -> Transform {
  Transform::identity()
}

///|
pub fn Transform::from_translation(translation : @math.Vec3) -> Transform {
  { ..Transform::identity(), translation, }
}

///|
pub fn Transform::from_xyz(x : Double, y : Double, z : Double) -> Transform {
  Transform::from_translation(@math.Vec3(x, y, z))
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
  { affine: @math.Affine3::identity() }
}

///|
pub impl Default for GlobalTransform with default() -> GlobalTransform {
  GlobalTransform::identity()
}

///|
pub fn GlobalTransform::from_transform(
  transform : Transform,
) -> GlobalTransform {
  { affine: transform.compute_affine() }
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
    scale: @math.Vec3(scale_x, scale_y, scale_z),
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
      GlobalTransform::{ affine: inverse_parent * self.affine }.compute_transform()
    None => self.compute_transform()
  }
}

///|
priv struct TransformWorldStore {
  transforms : Map[@entity.Entity, Transform]
  global_transforms : Map[@entity.Entity, GlobalTransform]
}

///|
let transform_world_stores : Map[UInt, TransformWorldStore] = Map::new()

///|
fn transform_world_store() -> TransformWorldStore {
  let world_id = @ecs.require_current_world().id()
  transform_world_stores.get_or_init(world_id, () => {
    transforms: Map::new(),
    global_transforms: Map::new(),
  })
}

///|
pub fn transforms() -> Map[@entity.Entity, Transform] {
  transform_world_store().transforms
}

///|
pub fn global_transforms() -> Map[@entity.Entity, GlobalTransform] {
  transform_world_store().global_transforms
}

///|
pub fn compute_global_transform(entity : @entity.Entity) -> GlobalTransform? {
  guard entity.is_alive() else { None }
  let local_global = GlobalTransform::from_transform(
    transforms().get(entity).unwrap_or_default(),
  )
  match entity.get_parent() {
    Some(parent) if parent.is_alive() =>
      match compute_global_transform(parent) {
        Some(parent_global) =>
          Some({ affine: parent_global.affine * local_global.affine })
        None => Some(local_global)
      }
    _ => Some(local_global)
  }
}

///|
pub fn set_parent_in_place(
  child : @entity.Entity,
  parent : @entity.Entity,
) -> Unit {
  guard child != parent else { return }
  let current_global = compute_global_transform(child)
  let parent_global = compute_global_transform(parent)
  child.set_parent(parent)
  match (current_global, parent_global) {
    (Some(child_global), Some(parent_world)) =>
      transforms().set(child, child_global.reparented_to(parent_world))
    (Some(child_global), None) =>
      transforms().set(child, child_global.compute_transform())
    _ => ()
  }
}

///|
pub fn remove_parent_in_place(child : @entity.Entity) -> Unit {
  let current_global = compute_global_transform(child)
  child.remove_parent()
  match current_global {
    Some(world_transform) =>
      transforms().set(child, world_transform.compute_transform())
    None => ()
  }
}

///|
pub fn transform_propagate_system(_delta : Double) -> Unit {
  let globals = global_transforms()
  globals.clear()
  for entity in @entity.iter_entities() {
    if !entity.is_alive() || entity.get_parent() is Some(_) {
      continue
    }
    let global = GlobalTransform::from_transform(
      transforms().get(entity).unwrap_or_default(),
    )
    globals.set(entity, global)
    propagate_children(entity, global)
  }
  for entity, transform in transforms() {
    if !entity.is_alive() || globals.contains(entity) {
      continue
    }
    globals.set(entity, GlobalTransform::from_transform(transform))
  }
}

///|
fn propagate_children(
  entity : @entity.Entity,
  parent_global : GlobalTransform,
) -> Unit {
  for child in entity.get_children() {
    if !child.is_alive() {
      continue
    }
    let local_transform = transforms().get(child).unwrap_or_default()
    let global = {
      affine: parent_global.affine * local_transform.compute_affine(),
    }
    global_transforms().set(child, global)
    propagate_children(child, global)
  }
}
