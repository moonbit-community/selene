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
#selene.component
pub(all) struct Camera3DComponent {
  projection : @render3d_types.CameraProjection3D
  orthographic_size : @math.Vec2?
  near : Double
  far : Double
  fov_y : Double
  order : Int32
  clear_color : @render.Color
  mut enabled : Bool
}

///|
pub(all) struct ActiveCamera3D {
  entity : @ecs.Entity
  camera : @render3d_types.FrameCamera3D
}

///|
pub fn Camera3DComponent::Camera3DComponent() -> Camera3DComponent {
  {
    projection: Perspective,
    orthographic_size: None,
    near: 0.1,
    far: 2000.0,
    fov_y: 45.0,
    order: 0,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0, },
    enabled: true,
  }
}

///|
let active_camera3d_key : @ecs.ResourceKey[ActiveCamera3D?] = ResourceKey()

///|
pub fn get_active_camera3d() -> ActiveCamera3D? {
  active_camera3d_key.get_in(@ecs.require_current_world()).unwrap_or(None)
}

///|
pub fn set_active_camera3d(camera : ActiveCamera3D?) -> Unit {
  active_camera3d_key.insert_in(@ecs.require_current_world(), camera)
}

///|
pub fn camera3d_extract_system(world~ : @ecs.World, _delta : Double) -> Unit {
  let query_camera3_d_component : @ecs.Query[@ecs.Single[Camera3DComponent]] = world.query()
  let mut selected : (@ecs.Entity, Camera3DComponent)? = None
  for entity, Single(camera) in query_camera3_d_component {
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
      guard @transform.global_transform(world~, entity)
        is Some(global_transform) else {
        set_active_camera3d(None)
        return
      }
      let global = global_transform.affine
      let position = global.translation
      let forward = global
        .transform_vector(Vec3(0.0, 0.0, -1.0))
        .try_normalize()
        .unwrap_or(Vec3(0.0, 0.0, -1.0))
      let up = global.y_axis.try_normalize().unwrap_or(@math.Vec3::y_axis())
      set_active_camera3d(
        Some({
          entity,
          camera: {
            position,
            target: position + forward,
            up,
            fov_y: camera.fov_y,
            projection: camera.projection,
            orthographic_size: camera.orthographic_size,
            near: camera.near,
            far: camera.far,
            clear_color: camera.clear_color,
          },
        }),
      )
    }
    None => set_active_camera3d(None)
  }
}
