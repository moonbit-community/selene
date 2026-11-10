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
#selene.component
pub(all) struct Transform {
  translation : @math.Vec3
  rotation : @math.Quat
  scale : @math.Vec3
}

///|
#derive(Eq, Debug)
#selene.component
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
priv struct TransformWorldStore {
  transforms : @ecs.ComponentStore[Transform]
  global_transforms : @ecs.ComponentStore[GlobalTransform]
  propagated : Array[Bool]
}

///|
let transform_store_key : @ecs.ResourceKey[TransformWorldStore] = ResourceKey()

///|
fn TransformWorldStore::TransformWorldStore(
  world : @ecs.World,
) -> TransformWorldStore {
  {
    transforms: @ecs.components_in(world),
    global_transforms: @ecs.components_in(world),
    propagated: [],
  }
}

///|
fn transform_world_store() -> TransformWorldStore {
  transform_store_key.get_or_insert_with(@ecs.require_current_world(), world => {
    TransformWorldStore(world)
  })
}

///|
pub fn transforms() -> @ecs.ComponentStore[Transform] {
  transform_world_store().transforms
}

///|
pub fn global_transforms() -> @ecs.ComponentStore[GlobalTransform] {
  transform_world_store().global_transforms
}

///|
pub fn compute_global_transform(entity : @ecs.Entity) -> GlobalTransform? {
  guard entity.is_alive() else { None }
  let local_global = GlobalTransform::from_transform(
    transforms().get(entity).unwrap_or_default(),
  )
  match entity.get_parent() {
    Some(parent) if parent.is_alive() =>
      match compute_global_transform(parent) {
        Some(parent_global) =>
          Some({ affine: parent_global.affine * local_global.affine, })
        None => Some(local_global)
      }
    _ => Some(local_global)
  }
}

///|
pub fn set_parent_in_place(child : @ecs.Entity, parent : @ecs.Entity) -> Unit {
  let world = @ecs.require_current_world()
  guard child.belongs_to(world) && parent.belongs_to(world) else { return }
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
pub fn remove_parent_in_place(child : @ecs.Entity) -> Unit {
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
  let is_alive = @ecs.alive_in_world(@ecs.require_current_world())
  let store = transform_world_store()
  let globals = store.global_transforms
  let locals = store.transforms
  let propagated = store.propagated
  propagated.fill(false)
  let write_global = (entity : @ecs.Entity, global : GlobalTransform) => {
    let index = entity.slot_index()
    while propagated.length() <= index {
      propagated.push(false)
    }
    propagated[index] = true
    globals.set(entity, global)
  }
  for entity in @ecs.iter_entities() {
    if !is_alive(entity) || entity.get_parent() is Some(_) {
      continue
    }
    let global = GlobalTransform::from_transform(
      locals.get(entity).unwrap_or_default(),
    )
    write_global(entity, global)
    propagate_children(entity, global, locals, write_global, is_alive)
  }
  for entity, transform in locals {
    if !is_alive(entity) || propagated.get(entity.slot_index()).unwrap_or(false) {
      continue
    }
    write_global(entity, GlobalTransform::from_transform(transform))
  }
  // Keep existing rows in place across frames. Only stale globals migrate.
  let stale = []
  for entity, _ in globals {
    if !propagated.get(entity.slot_index()).unwrap_or(false) {
      stale.push(entity)
    }
  }
  for entity in stale {
    globals.remove(entity)
  }
}

///|
fn propagate_children(
  entity : @ecs.Entity,
  parent_global : GlobalTransform,
  locals : @ecs.ComponentStore[Transform],
  write_global : (@ecs.Entity, GlobalTransform) -> Unit,
  is_alive : (@ecs.Entity) -> Bool,
) -> Unit {
  for child in entity.get_children() {
    if !is_alive(child) {
      continue
    }
    let local_transform = locals.get(child).unwrap_or_default()
    let global = {
      affine: parent_global.affine * local_transform.compute_affine(),
    }
    write_global(child, global)
    propagate_children(child, global, locals, write_global, is_alive)
  }
}
