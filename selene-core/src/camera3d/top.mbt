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
pub(all) struct Camera3DComponent {
  projection : @render3d_types.CameraProjection3D
  orthographic_size : @math.Vec2?
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
  camera : @render3d_types.FrameCamera3D
}

///|
pub fn Camera3DComponent::default() -> Camera3DComponent {
  {
    projection: @render3d_types.CameraProjection3D::Perspective,
    orthographic_size: None,
    near: 0.1,
    far: 2000.0,
    fov_y: 45.0,
    order: 0,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
    enabled: true,
  }
}

///|
priv struct Camera3DWorldStore {
  cameras3d : Map[@entity.Entity, Camera3DComponent]
}

///|
let camera3d_world_stores : Map[UInt, Camera3DWorldStore] = Map::new()

///|
fn camera3d_world_store() -> Camera3DWorldStore {
  let world_id = @ecs.require_current_world().id()
  camera3d_world_stores.get_or_init(world_id, () => { cameras3d: Map::new() })
}

///|
pub fn cameras3d() -> Map[@entity.Entity, Camera3DComponent] {
  camera3d_world_store().cameras3d
}

///|
let active_cameras3d_by_world : Map[UInt, ActiveCamera3D?] = Map::new()

///|
fn current_world_id() -> UInt {
  @ecs.require_current_world().id()
}

///|
pub fn get_active_camera3d() -> ActiveCamera3D? {
  active_cameras3d_by_world.get(current_world_id()).unwrap_or(None)
}

///|
pub fn set_active_camera3d(camera : ActiveCamera3D?) -> Unit {
  active_cameras3d_by_world.set(current_world_id(), camera)
}

///|
pub fn camera3d_extract_system(_delta : Double) -> Unit {
  let mut selected : (@entity.Entity, Camera3DComponent)? = None
  for entity, camera in cameras3d() {
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
      guard @transform.global_transforms().get(entity) is Some(global_transform) else {
        set_active_camera3d(None)
        return
      }
      let global = global_transform.compute_transform()
      let position = global.translation
      let forward = global.rotation.rotate_vec3(@math.Vec3(0.0, 0.0, -1.0))
      let up = global.rotation.rotate_vec3(@math.Vec3(0.0, 1.0, 0.0))
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
