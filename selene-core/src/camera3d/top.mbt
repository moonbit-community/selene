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
pub(all) enum CameraProjection3D {
  Perspective
  Orthographic
} derive(Eq, Show)

///|
pub(all) struct Camera3DComponent {
  projection : CameraProjection3D
  near : Double
  far : Double
  fov_y : Double
  order : Int
  clear_color : @render.Color
  mut enabled : Bool
}

///|
pub(all) struct ActiveCamera3D {
  entity : @entity.Entity
  camera : @render.Camera3D
  projection : CameraProjection3D
  near : Double
  far : Double
  clear_color : @render.Color
}

///|
pub fn Camera3DComponent::default() -> Camera3DComponent {
  {
    projection: Perspective,
    near: 0.1,
    far: 2000.0,
    fov_y: 45.0,
    order: 0,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
    enabled: true,
  }
}

///|
pub let cameras3d : Map[@entity.Entity, Camera3DComponent] = Map::new()

///|
pub let active_camera3d : Ref[ActiveCamera3D?] = Ref::new(None)

///|
pub fn camera3d_extract_system(_delta : Double) -> Unit {
  let mut selected : (@entity.Entity, Camera3DComponent)? = None
  for entity, camera in cameras3d {
    if !entity.is_alive() || !camera.enabled {
      continue
    }
    selected = match selected {
      Some((_, selected_camera)) if selected_camera.order <= camera.order =>
        selected
      _ => Some((entity, camera))
    }
  }
  match selected {
    Some((entity, camera)) => {
      let global = @transform3d.global_transforms3d
        .get(entity)
        .unwrap_or_default()
      let position = global.translation
      let forward = global.rotation.rotate_vec3(
        @math3d.Vec3::new(0.0, 0.0, -1.0),
      )
      let up = global.rotation.rotate_vec3(@math3d.Vec3::new(0.0, 1.0, 0.0))
      active_camera3d.val = Some({
        entity,
        camera: {
          position: to_render_vec3(position),
          target: to_render_vec3(position + forward),
          up: to_render_vec3(up),
          fovy: camera.fov_y,
        },
        projection: camera.projection,
        near: camera.near,
        far: camera.far,
        clear_color: camera.clear_color,
      })
    }
    None => active_camera3d.val = None
  }
}

///|
fn to_render_vec3(vec : @math3d.Vec3) -> @render.Vec3 {
  { x: vec.x, y: vec.y, z: vec.z }
}
