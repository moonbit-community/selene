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
pub type MeshHandle = @render3d_types.MeshHandle

///|
pub type MaterialHandle = @render3d_types.MaterialHandle

///|
pub type ImageHandle = @render3d_types.ImageHandle

///|
pub type SceneHandle = @render3d_types.SceneHandle

///|
pub type AlphaMode3D = @render3d_types.AlphaMode3D

///|
pub type MeshPrimitive3D = @render3d_types.MeshPrimitive3D

///|
pub type MeshAsset = @render3d_types.MeshAsset

///|
pub type ImageAsset = @render3d_types.ImageAsset

///|
pub type StandardMaterial3D = @render3d_types.StandardMaterial3D

///|
pub type DirectionalLight3D = @render3d_types.DirectionalLight3D

///|
pub type PointLight3D = @render3d_types.PointLight3D

///|
pub type FramePointLight3D = @render3d_types.FramePointLight3D

///|
pub type FrameSpotLight3D = @render3d_types.FrameSpotLight3D

///|
pub type SpotLight3D = @render3d_types.SpotLight3D

///|
pub type AmbientLight3D = @render3d_types.AmbientLight3D

///|
pub type RenderItem3D = @render3d_types.RenderItem3D

///|
pub type RenderFrame3D = @render3d_types.RenderFrame3D

///|
pub(all) struct Mesh3DRenderer {
  mesh : MeshHandle
  material : MaterialHandle
  mut visible : Bool
} derive(Eq, Show)

///|
pub let mesh3d_renderers : Map[@entity.Entity, Mesh3DRenderer] = Map::new()

///|
pub let directional_lights3d : Map[@entity.Entity, DirectionalLight3D] = Map::new()

///|
pub let point_lights3d : Map[@entity.Entity, PointLight3D] = Map::new()

///|
pub let spot_lights3d : Map[@entity.Entity, SpotLight3D] = Map::new()

///|
let ambient_light3d : Ref[AmbientLight3D?] = Ref::new(None)

///|
let meshes : Map[MeshHandle, MeshAsset] = Map::new()

///|
let materials : Map[MaterialHandle, StandardMaterial3D] = Map::new()

///|
let images : Map[ImageHandle, ImageAsset] = Map::new()

///|
let scene_paths : Map[SceneHandle, String] = Map::new()

///|
let next_mesh_id : Ref[UInt] = Ref::new(0)

///|
let next_material_id : Ref[UInt] = Ref::new(0)

///|
let next_image_id : Ref[UInt] = Ref::new(0)

///|
let next_scene_id : Ref[UInt] = Ref::new(0)

///|
let dirty_mesh_assets : Map[MeshHandle, MeshAsset] = Map::new()

///|
let dirty_material_assets : Map[MaterialHandle, StandardMaterial3D] = Map::new()

///|
let dirty_image_assets : Map[ImageHandle, ImageAsset] = Map::new()

///|
let released_mesh_assets : Array[MeshHandle] = []

///|
let released_material_assets : Array[MaterialHandle] = []

///|
let released_image_assets : Array[ImageHandle] = []

///|
let extracted_frame3d : Ref[RenderFrame3D] = Ref::new(empty_render_frame3d())

///|
pub fn empty_render_frame3d() -> RenderFrame3D {
  @render3d_types.empty_render_frame3d()
}

///|
pub fn default_standard_material3d() -> StandardMaterial3D {
  @render3d_types.default_standard_material3d()
}

///|
pub fn cube_mesh(size : @math.Vec3) -> MeshAsset {
  { primitive: Cube(size) }
}

///|
pub fn sphere_mesh(radius : Double) -> MeshAsset {
  { primitive: Sphere(radius) }
}

///|
pub fn cylinder_mesh(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices? : Int = 24,
) -> MeshAsset {
  { primitive: Cylinder(radius_top, radius_bottom, height, slices) }
}

///|
pub fn plane_mesh(size : @math.Vec3) -> MeshAsset {
  { primitive: Plane(size) }
}

///|
pub fn triangle_mesh(
  positions : Array[@math.Vec3],
  uvs? : Array[@math.Vec2D]? = None,
  normals? : Array[@math.Vec3]? = None,
) -> MeshAsset {
  { primitive: Triangles({ positions, uvs, normals }) }
}

///|
pub fn register_mesh_asset(mesh : MeshAsset) -> MeshHandle {
  let handle = @render3d_types.MeshHandle(next_mesh_id.val)
  next_mesh_id.val += 1
  meshes.set(handle, mesh)
  dirty_mesh_assets.set(handle, mesh)
  handle
}

///|
pub fn register_material_asset(material : StandardMaterial3D) -> MaterialHandle {
  let handle = @render3d_types.MaterialHandle(next_material_id.val)
  next_material_id.val += 1
  materials.set(handle, material)
  dirty_material_assets.set(handle, material)
  handle
}

///|
pub fn register_image_asset(image : ImageAsset) -> ImageHandle {
  let handle = @render3d_types.ImageHandle(next_image_id.val)
  next_image_id.val += 1
  images.set(handle, image)
  dirty_image_assets.set(handle, image)
  handle
}

///|
pub fn update_mesh_asset(handle : MeshHandle, mesh : MeshAsset) -> Unit {
  meshes.set(handle, mesh)
  dirty_mesh_assets.set(handle, mesh)
}

///|
pub fn update_material_asset(
  handle : MaterialHandle,
  material : StandardMaterial3D,
) -> Unit {
  materials.set(handle, material)
  dirty_material_assets.set(handle, material)
}

///|
pub fn update_image_asset(handle : ImageHandle, image : ImageAsset) -> Unit {
  images.set(handle, image)
  dirty_image_assets.set(handle, image)
}

///|
pub fn release_mesh_asset(handle : MeshHandle) -> Unit {
  meshes.remove(handle)
  dirty_mesh_assets.remove(handle)
  released_mesh_assets.push(handle)
}

///|
pub fn release_material_asset(handle : MaterialHandle) -> Unit {
  materials.remove(handle)
  dirty_material_assets.remove(handle)
  released_material_assets.push(handle)
}

///|
pub fn release_image_asset(handle : ImageHandle) -> Unit {
  images.remove(handle)
  dirty_image_assets.remove(handle)
  released_image_assets.push(handle)
}

///|
pub fn register_scene_path(path : String) -> SceneHandle {
  let handle = @render3d_types.SceneHandle(next_scene_id.val)
  next_scene_id.val += 1
  scene_paths.set(handle, path)
  handle
}

///|
pub fn get_scene_path(handle : SceneHandle) -> String? {
  scene_paths.get(handle)
}

///|
pub fn set_ambient_light3d(light : AmbientLight3D?) -> Unit {
  ambient_light3d.val = light
}

///|
pub fn get_ambient_light3d() -> AmbientLight3D? {
  ambient_light3d.val
}

///|
pub fn render3d_extract_system(_delta : Double) -> Unit {
  let frame = empty_render_frame3d()
  let mut active_camera_layers = @visibility.default_render_layers()
  if @camera3d.active_camera3d.val is Some(camera) {
    frame.camera = Some(camera.camera)
    frame.clear_color = camera.camera.clear_color
    active_camera_layers = @visibility.entity_render_layers(camera.entity)
  }
  frame.ambient_light = ambient_light3d.val

  let items : Array[RenderItem3D] = []
  for entity, renderer in mesh3d_renderers {
    if !entity.is_alive() ||
      !renderer.visible ||
      !@visibility.is_visible(entity) {
      continue
    }
    if !@visibility.matches(
        @visibility.entity_render_layers(entity),
        active_camera_layers,
      ) {
      continue
    }
    guard meshes.get(renderer.mesh) is Some(_) else { continue }
    guard materials.get(renderer.material) is Some(_) else { continue }
    let transform = @transform3d.global_transforms3d
      .get(entity)
      .unwrap_or(@transform3d.transforms3d.get(entity).unwrap_or_default())
    if frame.camera is Some(camera) {
      let distance = (transform.translation - camera.position).length()
      if distance < camera.near || distance > camera.far {
        continue
      }
    }
    items.push({
      transform: {
        translation: transform.translation,
        rotation: transform.rotation,
        scale: transform.scale,
      },
      mesh: renderer.mesh,
      material: renderer.material,
    })
  }

  let dir_lights = []
  for entity, light in directional_lights3d {
    if entity.is_alive() {
      dir_lights.push(light)
    }
  }
  let point_lights : Array[FramePointLight3D] = []
  for entity, light in point_lights3d {
    if entity.is_alive() {
      let transform = @transform3d.global_transforms3d
        .get(entity)
        .unwrap_or(@transform3d.transforms3d.get(entity).unwrap_or_default())
      point_lights.push({
        position: transform.translation,
        color: light.color,
        intensity: light.intensity,
        range: light.range,
      })
    }
  }
  let spot_lights : Array[FrameSpotLight3D] = []
  for entity, light in spot_lights3d {
    if entity.is_alive() {
      let transform = @transform3d.global_transforms3d
        .get(entity)
        .unwrap_or(@transform3d.transforms3d.get(entity).unwrap_or_default())
      let local_direction = if light.direction.length_squared() <= 0.0000001 {
        @math.Vec3::new(0.0, -1.0, 0.0)
      } else {
        light.direction.normalize()
      }
      let world_direction = transform.rotation
        .rotate_vec3(local_direction)
        .normalize()
      spot_lights.push({
        position: transform.translation,
        direction: world_direction,
        color: light.color,
        intensity: light.intensity,
        range: light.range,
        inner_angle: light.inner_angle,
        outer_angle: light.outer_angle,
      })
    }
  }

  frame.items = items
  frame.directional_lights = dir_lights
  frame.point_lights = point_lights
  frame.spot_lights = spot_lights
  extracted_frame3d.val = frame
}

///|
pub fn get_extracted_frame3d() -> RenderFrame3D {
  extracted_frame3d.val
}

///|
pub fn take_dirty_mesh_assets() -> Array[(MeshHandle, MeshAsset)] {
  let values = dirty_mesh_assets.to_array()
  dirty_mesh_assets.clear()
  values
}

///|
pub fn take_dirty_material_assets() -> Array[
  (MaterialHandle, StandardMaterial3D),
] {
  let values = dirty_material_assets.to_array()
  dirty_material_assets.clear()
  values
}

///|
pub fn take_dirty_image_assets() -> Array[(ImageHandle, ImageAsset)] {
  let values = dirty_image_assets.to_array()
  dirty_image_assets.clear()
  values
}

///|
pub fn take_released_mesh_assets() -> Array[MeshHandle] {
  let values = released_mesh_assets.copy()
  released_mesh_assets.clear()
  values
}

///|
pub fn take_released_material_assets() -> Array[MaterialHandle] {
  let values = released_material_assets.copy()
  released_material_assets.clear()
  values
}

///|
pub fn take_released_image_assets() -> Array[ImageHandle] {
  let values = released_image_assets.copy()
  released_image_assets.clear()
  values
}
