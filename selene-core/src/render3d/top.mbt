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
pub type TextureWrap3D = @render3d_types.TextureWrap3D

///|
pub type TextureFilter3D = @render3d_types.TextureFilter3D

///|
pub type TextureSampler3D = @render3d_types.TextureSampler3D

///|
pub type TextureTransform3D = @render3d_types.TextureTransform3D

///|
pub type TextureBinding3D = @render3d_types.TextureBinding3D

///|
pub type Tangent3D = @render3d_types.Tangent3D

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
pub type DirectionalLightShadowMap3D = @render3d_types.DirectionalLightShadowMap3D

///|
pub type PointLightShadowMap3D = @render3d_types.PointLightShadowMap3D

///|
pub type CascadeShadowConfigBuilder3D = @render3d_types.CascadeShadowConfigBuilder3D

///|
pub type CascadeShadowConfig3D = @render3d_types.CascadeShadowConfig3D

///|
pub type RenderItem3D = @render3d_types.RenderItem3D

///|
pub type RenderFrame3D = @render3d_types.RenderFrame3D

///|
pub(all) struct Mesh3DRenderer {
  mesh : MeshHandle
  material : MaterialHandle
  mut visible : Bool
  mut cast_shadows : Bool
  mut receive_shadows : Bool
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
let directional_light_shadow_map3d : Ref[DirectionalLightShadowMap3D] = Ref::new(
  @render3d_types.default_directional_light_shadow_map3d(),
)

///|
let point_light_shadow_map3d : Ref[PointLightShadowMap3D] = Ref::new(
  @render3d_types.default_point_light_shadow_map3d(),
)

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
pub fn default_directional_light3d() -> DirectionalLight3D {
  @render3d_types.default_directional_light3d()
}

///|
pub fn default_directional_light_shadow_map3d() -> DirectionalLightShadowMap3D {
  @render3d_types.default_directional_light_shadow_map3d()
}

///|
pub fn default_cascade_shadow_config_builder3d() -> CascadeShadowConfigBuilder3D {
  @render3d_types.default_cascade_shadow_config_builder3d()
}

///|
pub fn build_cascade_shadow_config3d(
  builder : CascadeShadowConfigBuilder3D,
) -> CascadeShadowConfig3D {
  @render3d_types.build_cascade_shadow_config3d(builder)
}

///|
pub fn default_cascade_shadow_config3d() -> CascadeShadowConfig3D {
  @render3d_types.default_cascade_shadow_config3d()
}

///|
pub fn default_point_light3d() -> PointLight3D {
  @render3d_types.default_point_light3d()
}

///|
pub fn default_point_light_shadow_map3d() -> PointLightShadowMap3D {
  @render3d_types.default_point_light_shadow_map3d()
}

///|
pub fn default_spot_light3d() -> SpotLight3D {
  @render3d_types.default_spot_light3d()
}

///|
pub fn default_standard_material3d() -> StandardMaterial3D {
  @render3d_types.default_standard_material3d()
}

///|
pub fn default_texture_sampler3d() -> TextureSampler3D {
  @render3d_types.default_texture_sampler3d()
}

///|
pub fn default_texture_transform3d() -> TextureTransform3D {
  @render3d_types.default_texture_transform3d()
}

///|
pub fn apply_texture_transform3d(
  transform : TextureTransform3D,
  uv : @math.Vec2D,
) -> @math.Vec2D {
  @render3d_types.apply_texture_transform3d(transform, uv)
}

///|
pub fn texture_binding3d(
  image : ImageHandle,
  texcoord_set? : Int = 0,
  sampler? : TextureSampler3D = default_texture_sampler3d(),
  transform? : TextureTransform3D = default_texture_transform3d(),
) -> TextureBinding3D {
  @render3d_types.texture_binding3d(image, texcoord_set~, sampler~, transform~)
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
  tangents? : Array[Tangent3D]? = None,
  colors? : Array[@render.Color]? = None,
  uv_sets? : Array[Array[@math.Vec2D]] = [],
) -> MeshAsset {
  let resolved_uv_sets = uv_sets.copy()
  if resolved_uv_sets.length() == 0 {
    if uvs is Some(primary_uvs) {
      resolved_uv_sets.push(primary_uvs)
    }
  } else if uvs is Some(primary_uvs) {
    if resolved_uv_sets.length() > 0 {
      resolved_uv_sets[0] = primary_uvs
    } else {
      resolved_uv_sets.push(primary_uvs)
    }
  }
  {
    primitive: Triangles({
      positions,
      uv_sets: resolved_uv_sets,
      normals,
      tangents,
      colors,
    }),
  }
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
pub fn set_directional_light_shadow_map3d(resource : DirectionalLightShadowMap3D) -> Unit {
  directional_light_shadow_map3d.val = {
    size: if resource.size < 1 { 1 } else { resource.size },
  }
}

///|
pub fn get_directional_light_shadow_map3d() -> DirectionalLightShadowMap3D {
  directional_light_shadow_map3d.val
}

///|
pub fn set_point_light_shadow_map3d(resource : PointLightShadowMap3D) -> Unit {
  point_light_shadow_map3d.val = {
    size: if resource.size < 1 { 1 } else { resource.size },
  }
}

///|
pub fn get_point_light_shadow_map3d() -> PointLightShadowMap3D {
  point_light_shadow_map3d.val
}

///|
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn mesh_local_radius(mesh : MeshAsset) -> Double {
  match mesh.primitive {
    Cube(size) => size.length() * 0.5
    Sphere(radius) => radius
    Cylinder(radius_top, radius_bottom, height, _) => {
      let radius = if radius_top > radius_bottom {
        radius_top
      } else {
        radius_bottom
      }
      @cmath.pow(radius * radius + height * 0.5 * (height * 0.5), 0.5)
    }
    Plane(size) => size.length() * 0.5
    Triangles(triangles) => {
      let mut radius_sq = 0.0
      for position in triangles.positions {
        let sq = position.length_squared()
        if sq > radius_sq {
          radius_sq = sq
        }
      }
      @cmath.pow(radius_sq, 0.5)
    }
  }
}

///|
fn is_visible_in_camera_frustum(
  camera : @render3d_types.FrameCamera3D,
  mesh : MeshAsset,
  transform : @transform3d.GlobalTransform3D,
) -> Bool {
  let scale = transform.scale
  let max_scale_xy = if abs_double(scale.x) > abs_double(scale.y) {
    abs_double(scale.x)
  } else {
    abs_double(scale.y)
  }
  let max_scale = if max_scale_xy > abs_double(scale.z) {
    max_scale_xy
  } else {
    abs_double(scale.z)
  }
  let radius = mesh_local_radius(mesh) * max_scale
  let to_center = transform.translation - camera.position
  let forward = camera.target - camera.position
  if forward.length_squared() <= 0.0000001 {
    return true
  }
  let forward_n = forward.normalize()
  let depth = to_center.dot(forward_n)
  if depth + radius < camera.near || depth - radius > camera.far {
    return false
  }
  match camera.projection {
    Perspective => {
      if depth <= 0.0 {
        return depth + radius >= 0.0
      }
      let up = if camera.up.length_squared() > 0.0000001 {
        camera.up.normalize()
      } else {
        @math.Vec3::new(0.0, 1.0, 0.0)
      }
      let right = forward_n.cross(up)
      let right_n = if right.length_squared() > 0.0000001 {
        right.normalize()
      } else {
        @math.Vec3::new(1.0, 0.0, 0.0)
      }
      let up_n = right_n.cross(forward_n).normalize()
      let viewport = @system.get_viewport_size()
      let aspect = if viewport[Y] <= 0.0000001 {
        1.0
      } else {
        viewport[X] / viewport[Y]
      }
      let half_fovy_rad = camera.fov_y * 0.5 * @cmath.PI / 180.0
      let tan_half_y = @cmath.tan(half_fovy_rad)
      let tan_half_x = tan_half_y * aspect
      let side = abs_double(to_center.dot(right_n))
      let vertical = abs_double(to_center.dot(up_n))
      if side > depth * tan_half_x + radius {
        return false
      }
      if vertical > depth * tan_half_y + radius {
        return false
      }
      true
    }
    Orthographic => {
      let up = if camera.up.length_squared() > 0.0000001 {
        camera.up.normalize()
      } else {
        @math.Vec3::new(0.0, 1.0, 0.0)
      }
      let right = forward_n.cross(up)
      let right_n = if right.length_squared() > 0.0000001 {
        right.normalize()
      } else {
        @math.Vec3::new(1.0, 0.0, 0.0)
      }
      let up_n = right_n.cross(forward_n).normalize()
      let ortho_size = camera.orthographic_size.unwrap_or(
        @math.Vec2D(20.0, 20.0),
      )
      let half_width = abs_double(ortho_size[X]) * 0.5
      let half_height = abs_double(ortho_size[Y]) * 0.5
      let side = abs_double(to_center.dot(right_n))
      let vertical = abs_double(to_center.dot(up_n))
      side <= half_width + radius && vertical <= half_height + radius
    }
  }
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
  frame.directional_shadow_map_size = directional_light_shadow_map3d.val.size
  frame.point_shadow_map_size = point_light_shadow_map3d.val.size

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
      if !is_visible_in_camera_frustum(camera, meshes[renderer.mesh], transform) {
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
      cast_shadows: renderer.cast_shadows,
      receive_shadows: renderer.receive_shadows,
    })
  }

  let dir_lights : Array[DirectionalLight3D] = []
  for entity, light in directional_lights3d {
    if entity.is_alive() {
      let transform = @transform3d.global_transforms3d
        .get(entity)
        .unwrap_or(@transform3d.transforms3d.get(entity).unwrap_or_default())
      let local_direction = if light.direction.length_squared() <= 0.0000001 {
        @math.Vec3::new(0.0, 0.0, -1.0)
      } else {
        light.direction.normalize()
      }
      dir_lights.push({
        direction: transform.rotation.rotate_vec3(local_direction),
        color: light.color,
        intensity: light.intensity,
        shadows: light.shadows,
        shadow_depth_bias: light.shadow_depth_bias,
        shadow_normal_bias: light.shadow_normal_bias,
        cascade_shadow_config: light.cascade_shadow_config,
      })
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
        shadows: light.shadows,
        shadow_depth_bias: light.shadow_depth_bias,
        shadow_normal_bias: light.shadow_normal_bias,
        shadow_map_near_z: light.shadow_map_near_z,
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
        shadows: light.shadows,
        shadow_depth_bias: light.shadow_depth_bias,
        shadow_normal_bias: light.shadow_normal_bias,
        shadow_map_near_z: light.shadow_map_near_z,
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
