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
priv struct Render3DWorldState {
  mut ambient_light : AmbientLight3D?
  mut directional_shadow_map : DirectionalLightShadowMap3D
  mut point_shadow_map : PointLightShadowMap3D
  mut extracted_frame : RenderFrame3D
}

///|
let render3d_world_state_key : @ecs.ResourceKey[Render3DWorldState] = ResourceKey()

///|
fn render3d_world_state() -> Render3DWorldState {
  render3d_world_state_key.get_or_insert_with(@ecs.require_current_world(), _ => {
    ambient_light: None,
    directional_shadow_map: DirectionalLightShadowMap3D(),
    point_shadow_map: PointLightShadowMap3D(),
    extracted_frame: RenderFrame3D(),
  })
}

///|
pub fn push_line3d(line : RenderLine3D) -> Unit {
  render3d_world_state().extracted_frame.lines.push(line)
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
priv struct CameraCullingContext3D {
  camera : @render3d_types.FrameCamera3D
  forward_n : @math.Vec3
  right_n : @math.Vec3
  up_n : @math.Vec3
  tan_half_x : Double
  tan_half_y : Double
  half_width : Double
  half_height : Double
}

///|
fn camera_culling_context(
  camera : @render3d_types.FrameCamera3D,
) -> CameraCullingContext3D {
  let (right_n, up_n, forward_n) = @math.view_basis_rh(
    camera.target - camera.position,
    camera.up,
  )
  let viewport = @window.get_viewport_size()
  let aspect = if viewport.y <= 0.0000001 {
    1.0
  } else {
    viewport.x / viewport.y
  }
  let half_fovy_rad = camera.fov_y * 0.5 * @cmath.PI / 180.0
  let tan_half_y = @cmath.tan(half_fovy_rad)
  let ortho_size = camera.orthographic_size.unwrap_or(Vec2(20.0, 20.0))
  {
    camera,
    forward_n,
    right_n,
    up_n,
    tan_half_x: tan_half_y * aspect,
    tan_half_y,
    half_width: abs_double(ortho_size.x) * 0.5,
    half_height: abs_double(ortho_size.y) * 0.5,
  }
}

///|
fn is_visible_in_camera_culling_context(
  context : CameraCullingContext3D,
  mesh : MeshAsset,
  transform : @math.Affine3,
) -> Bool {
  // The largest absolute row sum of A^T A bounds the squared stretch.
  let { x_axis: x, y_axis: y, z_axis: z, .. } = transform
  let xy = x.dot(y).abs()
  let xz = x.dot(z).abs()
  let yz = y.dot(z).abs()
  let stretch_squared = (x.length_squared() + xy + xz).max(
    (y.length_squared() + xy + yz).max(z.length_squared() + xz + yz),
  )
  let radius = mesh_local_radius(mesh) * stretch_squared.sqrt()
  let camera = context.camera
  let to_center = transform.translation - camera.position
  let depth = to_center.dot(context.forward_n)
  if depth + radius < camera.near || depth - radius > camera.far {
    return false
  }
  match camera.projection {
    Perspective => {
      if depth <= 0.0 {
        return depth + radius >= 0.0
      }
      let side = abs_double(to_center.dot(context.right_n))
      let vertical = abs_double(to_center.dot(context.up_n))
      if side > depth * context.tan_half_x + radius {
        return false
      }
      if vertical > depth * context.tan_half_y + radius {
        return false
      }
      true
    }
    Orthographic => {
      let side = abs_double(to_center.dot(context.right_n))
      let vertical = abs_double(to_center.dot(context.up_n))
      side <= context.half_width + radius &&
      vertical <= context.half_height + radius
    }
  }
}

///|
fn _is_visible_in_camera_frustum(
  camera : @render3d_types.FrameCamera3D,
  mesh : MeshAsset,
  transform : @math.Affine3,
) -> Bool {
  is_visible_in_camera_culling_context(
    camera_culling_context(camera),
    mesh,
    transform,
  )
}

///|
pub fn render3d_extract_system(world~ : @ecs.World, _delta : Double) -> Unit {
  let query_skybox3_d : @ecs.Query[@ecs.Single[Skybox3D]] = world.query()
  let query_mesh3_d_renderer : @ecs.Query[@ecs.Single[Mesh3DRenderer]] = world.query()
  let query_directional_light3_d : @ecs.Query[@ecs.Single[DirectionalLight3D]] = world.query()
  let query_point_light3_d : @ecs.Query[@ecs.Single[PointLight3D]] = world.query()
  let query_spot_light3_d : @ecs.Query[@ecs.Single[SpotLight3D]] = world.query()
  let state = render3d_world_state()
  let frame = RenderFrame3D()
  let mut active_camera_layers = @visibility.RenderLayers()
  if @camera3d.get_active_camera3d() is Some(camera) {
    frame.camera = Some(camera.camera)
    frame.clear_color = camera.camera.clear_color
    active_camera_layers = @visibility.entity_render_layers(
      world~,
      camera.entity,
    )
    match query_skybox3_d.get(camera.entity).map(value => value.0) {
      Some(skybox) if cubemaps.get(skybox.cubemap) is Some(_) =>
        frame.skybox = Some(skybox)
      _ => ()
    }
  }
  frame.ambient_light = state.ambient_light
  frame.directional_shadow_map_size = state.directional_shadow_map.size
  frame.point_shadow_map_size = state.point_shadow_map.size
  let camera_culling = match frame.camera {
    Some(camera) => Some(camera_culling_context(camera))
    None => None
  }

  let items : Array[RenderItem3D] = []
  for entity, Single(renderer) in query_mesh3_d_renderer {
    if !entity.is_alive() ||
      !renderer.visible ||
      !@visibility.is_visible(entity) {
      continue
    }
    if !@visibility.matches(
        @visibility.entity_render_layers(world~, entity),
        active_camera_layers,
      ) {
      continue
    }
    guard meshes.get(renderer.mesh) is Some(_) else { continue }
    guard materials.get(renderer.material) is Some(_) else { continue }
    guard @transform.global_transform(world~, entity) is Some(global_transform) else {
      continue
    }
    let transform = global_transform.affine
    if camera_culling is Some(context) {
      if !is_visible_in_camera_culling_context(
          context,
          meshes[renderer.mesh],
          transform,
        ) {
        continue
      }
    }
    items.push({
      entity_id: Some(entity.id()),
      transform,
      mesh: renderer.mesh,
      material: renderer.material,
      cast_shadows: renderer.cast_shadows,
      receive_shadows: renderer.receive_shadows,
    })
  }

  let dir_lights : Array[DirectionalLight3D] = []
  for entity, Single(light) in query_directional_light3_d {
    if entity.is_alive() {
      guard @transform.global_transform(world~, entity)
        is Some(global_transform) else {
        continue
      }
      let transform = global_transform.affine
      let local_direction = if light.direction.length_squared() <= 0.0000001 {
        @math.Vec3(0.0, 0.0, -1.0)
      } else {
        light.direction.normalize_or_zero()
      }
      dir_lights.push({
        direction: transform
        .transform_vector(local_direction)
        .try_normalize()
        .unwrap_or(local_direction),
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
  for entity, Single(light) in query_point_light3_d {
    if entity.is_alive() {
      guard @transform.global_transform(world~, entity)
        is Some(global_transform) else {
        continue
      }
      let transform = global_transform.affine
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
  for entity, Single(light) in query_spot_light3_d {
    if entity.is_alive() {
      guard @transform.global_transform(world~, entity)
        is Some(global_transform) else {
        continue
      }
      let transform = global_transform.affine
      let local_direction = if light.direction.length_squared() <= 0.0000001 {
        @math.Vec3(0.0, -1.0, 0.0)
      } else {
        light.direction.normalize_or_zero()
      }
      let world_direction = transform
        .transform_vector(local_direction)
        .try_normalize()
        .unwrap_or(local_direction)
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
  state.extracted_frame = frame
}

///|
pub fn get_extracted_frame3d() -> RenderFrame3D {
  render3d_world_state().extracted_frame
}
