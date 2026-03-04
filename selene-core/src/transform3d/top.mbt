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
pub(all) struct Transform3D {
  translation : @math3d.Vec3
  rotation : @math3d.Quat
  scale : @math3d.Vec3
} derive(Eq, Show)

///|
pub type GlobalTransform3D = Transform3D

///|
pub fn Transform3D::identity() -> Transform3D {
  {
    translation: @math3d.Vec3::zero(),
    rotation: @math3d.Quat::identity(),
    scale: @math3d.Vec3::one(),
  }
}

///|
pub impl Default for Transform3D with default() -> Transform3D {
  Transform3D::identity()
}

///|
/// Computes `parent * local`.
pub fn Transform3D::compose(
  parent : Transform3D,
  local_transform : Transform3D,
) -> Transform3D {
  let local_translation = parent.rotation.rotate_vec3(
    local_transform.translation * parent.scale,
  )
  {
    translation: parent.translation + local_translation,
    rotation: (parent.rotation * local_transform.rotation).normalize(),
    scale: parent.scale * local_transform.scale,
  }
}

///|
pub let transforms3d : Map[@entity.Entity, Transform3D] = Map::new()

///|
pub let global_transforms3d : Map[@entity.Entity, GlobalTransform3D] = Map::new()

///|
pub let previous_global_transforms3d : Map[@entity.Entity, GlobalTransform3D] = Map::new()

///|
pub fn capture_previous_global_transforms3d() -> Unit {
  previous_global_transforms3d.clear()
  for entity, global in global_transforms3d {
    if entity.is_alive() {
      previous_global_transforms3d.set(entity, global)
    }
  }
}

///|
pub fn capture_previous_global_transforms3d_system(_delta : Double) -> Unit {
  capture_previous_global_transforms3d()
}

///|
pub fn sample_global_transform3d(
  entity : @entity.Entity,
  alpha : Double,
) -> GlobalTransform3D {
  guard global_transforms3d.get(entity) is Some(current) else {
    return Transform3D::identity()
  }
  if previous_global_transforms3d.get(entity) is Some(previous) {
    {
      translation: previous.translation.lerp(current.translation, alpha),
      rotation: quat_nlerp(previous.rotation, current.rotation, alpha),
      scale: previous.scale.lerp(current.scale, alpha),
    }
  } else {
    current
  }
}

///|
pub fn sample_global_translation3d(
  entity : @entity.Entity,
  alpha : Double,
) -> @math3d.Vec3 {
  sample_global_transform3d(entity, alpha).translation
}

///|
pub fn transform3d_propagate_system(_delta : Double) -> Unit {
  global_transforms3d.clear()
  for entity, local_transform in transforms3d {
    if !entity.is_alive() {
      continue
    }
    if entity.get_parent() is Some(_) {
      continue
    }
    global_transforms3d.set(entity, local_transform)
    for child in entity.get_children() {
      propagate_from(child, local_transform)
    }
  }
  for entity, local_transform in transforms3d {
    if !entity.is_alive() {
      continue
    }
    if !global_transforms3d.contains(entity) {
      global_transforms3d.set(entity, local_transform)
    }
  }
}

///|
fn propagate_from(entity : @entity.Entity, parent_global : Transform3D) -> Unit {
  if !entity.is_alive() {
    return
  }
  let local_transform = transforms3d.get(entity).unwrap_or_default()
  let global = parent_global.compose(local_transform)
  global_transforms3d.set(entity, global)
  for child in entity.get_children() {
    propagate_from(child, global)
  }
}

///|
fn quat_nlerp(
  a : @math3d.Quat,
  b : @math3d.Quat,
  alpha : Double,
) -> @math3d.Quat {
  @math3d.Quat::new(
    a.x * (1.0 - alpha) + b.x * alpha,
    a.y * (1.0 - alpha) + b.y * alpha,
    a.z * (1.0 - alpha) + b.z * alpha,
    a.w * (1.0 - alpha) + b.w * alpha,
  ).normalize()
}
