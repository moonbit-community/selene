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
let meshes : Map[MeshHandle, MeshAsset] = Map([])

///|
let materials : Map[MaterialHandle, StandardMaterial3D] = Map([])

///|
let cubemaps : Map[CubemapHandle, CubemapAsset3D] = Map([])

///|
let scene_paths : Map[SceneHandle, String] = Map([])

///|
let next_mesh_id : Ref[UInt32] = Ref(0)

///|
let next_material_id : Ref[UInt32] = Ref(0)

///|
let next_cubemap_id : Ref[UInt32] = Ref(0)

///|
let next_scene_id : Ref[UInt32] = Ref(0)

///|
let dirty_mesh_assets : Map[MeshHandle, MeshAsset] = Map([])

///|
let dirty_material_assets : Map[MaterialHandle, StandardMaterial3D] = Map([])

///|
let dirty_cubemap_assets : Map[CubemapHandle, CubemapAsset3D] = Map([])

///|
let released_mesh_assets : Array[MeshHandle] = []

///|
let released_material_assets : Array[MaterialHandle] = []

///|
let released_cubemap_assets : Array[CubemapHandle] = []

///|
pub fn register_mesh_asset(mesh : MeshAsset) -> MeshHandle {
  let handle = @render3d_types.MeshHandle(next_mesh_id.val)
  next_mesh_id.val += 1
  meshes.set(handle, mesh)
  dirty_mesh_assets.set(handle, mesh)
  handle
}

///|
pub fn mesh_asset(handle : MeshHandle) -> MeshAsset? {
  meshes.get(handle)
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
pub fn register_cubemap_asset(cubemap : CubemapAsset3D) -> CubemapHandle {
  let handle = @render3d_types.CubemapHandle(next_cubemap_id.val)
  next_cubemap_id.val += 1
  cubemaps.set(handle, cubemap)
  dirty_cubemap_assets.set(handle, cubemap)
  handle
}

///|
pub fn cubemap_asset(handle : CubemapHandle) -> CubemapAsset3D? {
  cubemaps.get(handle)
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
pub fn update_cubemap_asset(
  handle : CubemapHandle,
  cubemap : CubemapAsset3D,
) -> Unit {
  cubemaps.set(handle, cubemap)
  dirty_cubemap_assets.set(handle, cubemap)
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
pub fn release_cubemap_asset(handle : CubemapHandle) -> Unit {
  cubemaps.remove(handle)
  dirty_cubemap_assets.remove(handle)
  released_cubemap_assets.push(handle)
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
pub fn take_dirty_cubemap_assets() -> Array[(CubemapHandle, CubemapAsset3D)] {
  let values = dirty_cubemap_assets.to_array()
  dirty_cubemap_assets.clear()
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
pub fn take_released_cubemap_assets() -> Array[CubemapHandle] {
  let values = released_cubemap_assets.copy()
  released_cubemap_assets.clear()
  values
}
