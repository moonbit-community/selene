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
const VIEWPORT_WIDTH : Double = 960.0

///|
const VIEWPORT_HEIGHT : Double = 640.0

///|
let rotating_cube : Ref[@entity.Entity?] = Ref::new(None)

///|
let cube_rotation : Ref[Double] = Ref::new(0.0)

///|
let spotlight_entity : Ref[@entity.Entity?] = Ref::new(None)

///|
let spotlight_phase : Ref[Double] = Ref::new(0.0)

///|
let hud_label : Ref[@entity.Entity?] = Ref::new(None)

///|
fn color(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @math.Vec3 {
  @math.Vec3::new(x, y, z)
}

///|
fn append_cube_face(
  positions : Array[@math.Vec3],
  normals : Array[@math.Vec3],
  a : @math.Vec3,
  b : @math.Vec3,
  c : @math.Vec3,
  d : @math.Vec3,
  normal : @math.Vec3,
) -> Unit {
  positions.push(a)
  positions.push(b)
  positions.push(c)
  positions.push(a)
  positions.push(c)
  positions.push(d)
  for _ in 0..<6 {
    normals.push(normal)
  }
}

///|
fn lit_cube_mesh(size : Double) -> @render3d.MeshAsset {
  let half = size * 0.5
  let positions : Array[@math.Vec3] = []
  let normals : Array[@math.Vec3] = []

  append_cube_face(
    positions,
    normals,
    vec3(-half, -half, half),
    vec3(half, -half, half),
    vec3(half, half, half),
    vec3(-half, half, half),
    vec3(0.0, 0.0, 1.0),
  )
  append_cube_face(
    positions,
    normals,
    vec3(half, -half, -half),
    vec3(-half, -half, -half),
    vec3(-half, half, -half),
    vec3(half, half, -half),
    vec3(0.0, 0.0, -1.0),
  )
  append_cube_face(
    positions,
    normals,
    vec3(-half, -half, -half),
    vec3(-half, -half, half),
    vec3(-half, half, half),
    vec3(-half, half, -half),
    vec3(-1.0, 0.0, 0.0),
  )
  append_cube_face(
    positions,
    normals,
    vec3(half, -half, half),
    vec3(half, -half, -half),
    vec3(half, half, -half),
    vec3(half, half, half),
    vec3(1.0, 0.0, 0.0),
  )
  append_cube_face(
    positions,
    normals,
    vec3(-half, half, half),
    vec3(half, half, half),
    vec3(half, half, -half),
    vec3(-half, half, -half),
    vec3(0.0, 1.0, 0.0),
  )
  append_cube_face(
    positions,
    normals,
    vec3(-half, -half, -half),
    vec3(half, -half, -half),
    vec3(half, -half, half),
    vec3(-half, -half, half),
    vec3(0.0, -1.0, 0.0),
  )

  @render3d.triangle_mesh(positions, normals=Some(normals))
}

///|
pub fn run() -> Unit {
  @app.App::new()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .with_fps(60)
  .add_plugin(@plugins.default_3d_plugin)
  .add_system(Startup, fn(_world) { setup_scene3d(@time.delta()) })
  .add_system(Update, fn(_world) { rotate_cube_system(@time.delta()) })
  .add_system(Update, fn(_world) { animate_spotlight_system(@time.delta()) })
  .run()
}

///|
fn setup_scene3d(_delta : Double) -> Unit {
  let camera = @entity.Entity::new()
  @transform3d.transforms3d().set(camera, {
    translation: vec3(0.0, 1.5, 8.0),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @camera3d.cameras3d().set(camera, {
    ..@camera3d.Camera3DComponent::default(),
    clear_color: color(20U, 20U, 24U, 1.0),
  })

  let scene = @scene.load_scene_gltf("assets/scene3d/scene3d.gltf")
  ignore(@scene.instantiate_scene(scene, @transform3d.Transform3D::identity()))

  let floor_mesh = @render3d.register_mesh_asset(
    @render3d.plane_mesh(vec3(10.0, 0.02, 10.0)),
  )
  let floor_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(96U, 104U, 110U, 1.0),
    roughness: 0.9,
  })
  let floor = @entity.Entity::new()
  @transform3d.transforms3d().set(floor, {
    translation: vec3(0.0, -0.01, 0.0),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.mesh3d_renderers().set(floor, {
    mesh: floor_mesh,
    material: floor_material,
    visible: true,
    cast_shadows: false,
    receive_shadows: true,
  })

  let cube_mesh = @render3d.register_mesh_asset(lit_cube_mesh(1.0))
  let cube_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(124U, 144U, 255U, 1.0),
    roughness: 0.25,
  })

  let cube = @entity.Entity::new()
  @transform3d.transforms3d().set(cube, {
    translation: vec3(0.0, 0.5, 0.0),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.mesh3d_renderers().set(cube, {
    mesh: cube_mesh,
    material: cube_material,
    visible: true,
    cast_shadows: true,
    receive_shadows: true,
  })
  rotating_cube.val = Some(cube)

  let target_mesh = @render3d.register_mesh_asset(@render3d.sphere_mesh(0.45))
  let target_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(244U, 199U, 124U, 1.0),
    roughness: 0.25,
  })
  let target = @entity.Entity::new()
  @transform3d.transforms3d().set(target, {
    translation: vec3(1.35, 1.55, -0.75),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.mesh3d_renderers().set(target, {
    mesh: target_mesh,
    material: target_material,
    visible: true,
    cast_shadows: true,
    receive_shadows: true,
  })

  let shadow_wall_mesh = @render3d.register_mesh_asset(
    @render3d.cube_mesh(vec3(8.0, 3.2, 0.16)),
  )
  let shadow_wall_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(86U, 96U, 112U, 1.0),
    roughness: 0.82,
  })
  let shadow_wall = @entity.Entity::new()
  @transform3d.transforms3d().set(shadow_wall, {
    translation: vec3(0.0, 1.6, -2.9),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.mesh3d_renderers().set(shadow_wall, {
    mesh: shadow_wall_mesh,
    material: shadow_wall_material,
    visible: true,
    cast_shadows: false,
    receive_shadows: true,
  })

  let off_axis_cube = @entity.Entity::new()
  @transform3d.transforms3d().set(off_axis_cube, {
    translation: vec3(-2.2, 0.5, 1.8),
    rotation: @math.Quat::from_axis_angle(vec3(0.0, 1.0, 0.0), 0.45),
    scale: vec3(0.7, 0.7, 0.7),
  })
  @render3d.mesh3d_renderers().set(off_axis_cube, {
    mesh: cube_mesh,
    material: @render3d.register_material_asset({
      ..@render3d.default_standard_material3d(),
      base_color: color(118U, 168U, 240U, 1.0),
      roughness: 0.6,
    }),
    visible: true,
    cast_shadows: true,
    receive_shadows: true,
  })

  let spotlight = @entity.Entity::new()
  @transform3d.transforms3d().set(spotlight, {
    translation: vec3(3.2, 3.0, 0.0),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.spot_lights3d().set(spotlight, {
    ..@render3d.default_spot_light3d(),
    direction: vec3(-1.0, -1.2, 0.0).normalize(),
    color: color(255U, 236U, 186U, 1.0),
    intensity: 8.0,
    range: 11.0,
    shadows: true,
    shadow_depth_bias: 0.001,
    shadow_normal_bias: 0.15,
    inner_angle: 0.28,
    outer_angle: 0.72,
  })
  spotlight_entity.val = Some(spotlight)

  let spotlight_marker_mesh = @render3d.register_mesh_asset(
    @render3d.sphere_mesh(0.14),
  )
  let spotlight_marker_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(255U, 236U, 186U, 1.0),
    roughness: 0.05,
  })
  let spotlight_marker = spotlight.spawn_child()
  @transform3d.transforms3d().set(
    spotlight_marker,
    @transform3d.Transform3D::identity(),
  )
  @render3d.mesh3d_renderers().set(spotlight_marker, {
    mesh: spotlight_marker_mesh,
    material: spotlight_marker_material,
    visible: true,
    cast_shadows: false,
    receive_shadows: false,
  })

  let dir_light = @entity.Entity::new()
  @render3d.directional_lights3d().set(dir_light, {
    ..@render3d.default_directional_light3d(),
    direction: vec3(-0.72, -1.0, -0.42).normalize(),
    color: color(255U, 255U, 255U, 1.0),
    intensity: 1.15,
    shadows: true,
    shadow_depth_bias: 0.001,
    shadow_normal_bias: 0.15,
  })
  @render3d.set_ambient_light3d(
    Some({ color: color(255U, 255U, 255U, 1.0), intensity: 0.03 }),
  )

  let label = @entity.Entity::new()
  @ui.nodes().set(
    label,
    @ui.Node::absolute(@math.Vec2D(16.0, 16.0), size=@math.Vec2D(420.0, 28.0)),
  )
  @ui.texts().set(
    label,
    @ui.Text::new("3d_scene: WebGPU directional + spot shadows"),
  )
  @ui.text_fonts().set(label, @ui.TextFont::new(family="sans-serif", size=20.0))
  @ui.text_colors().set(label, @ui.TextColor::new(color(245U, 245U, 245U, 1.0)))
  @ui.z_indexes().set(label, @ui.ZIndex::new(100))
  hud_label.val = Some(label)
}

///|
fn rotate_cube_system(delta : Double) -> Unit {
  guard rotating_cube.val is Some(cube) else { return }
  guard @transform3d.transforms3d().get(cube) is Some(transform) else { return }
  cube_rotation.val += delta
  @transform3d.transforms3d().set(cube, {
    ..transform,
    rotation: @math.Quat::from_axis_angle(
      vec3(0.0, 1.0, 0.0),
      cube_rotation.val,
    ),
  })
}

///|
fn animate_spotlight_system(delta : Double) -> Unit {
  guard spotlight_entity.val is Some(spotlight) else { return }
  spotlight_phase.val += delta * 0.9
  let x = @cmath.cos(spotlight_phase.val) * 3.2
  let y = 2.8 + @cmath.sin(spotlight_phase.val * 1.7) * 0.35
  let z = @cmath.sin(spotlight_phase.val) * 3.2
  let position = vec3(x, y, z)
  let focus = vec3(0.0, 0.45, 0.0)
  let direction = (focus - position).normalize()
  if @transform3d.transforms3d().get(spotlight) is Some(transform) {
    @transform3d.transforms3d().set(spotlight, {
      ..transform,
      translation: position,
    })
  }
  if @render3d.spot_lights3d().get(spotlight) is Some(light) {
    @render3d.spot_lights3d().set(spotlight, { ..light, direction, })
  }
}
