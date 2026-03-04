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
fn color(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @math3d.Vec3 {
  @math3d.Vec3::new(x, y, z)
}

///|
pub fn run() -> Unit {
  @system.App::new()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .with_fps(60)
  .add_plugin(@plugins.default_3d_plugin)
  .add_system(setup_scene3d, schedule=Startup)
  .add_system(rotate_cube_system, schedule=Update)
  .add_system(draw_overlay_system, schedule=RenderCleanup)
  .run()
}

///|
fn setup_scene3d(_delta : Double) -> Unit {
  let camera = @entity.Entity::new()
  @transform3d.transforms3d.set(camera, {
    translation: vec3(0.0, 1.5, 8.0),
    rotation: @math3d.Quat::identity(),
    scale: @math3d.Vec3::one(),
  })
  @camera3d.cameras3d.set(camera, {
    ..@camera3d.Camera3DComponent::default(),
    clear_color: color(20U, 20U, 24U, 1.0),
  })

  let scene = @scene3d_api.load_scene_gltf("assets/scene3d/scene3d.gltf")
  ignore(
    @scene3d_api.instantiate_scene(scene, @transform3d.Transform3D::identity()),
  )

  let cube_mesh = @render3d.register_mesh_asset(
    @render3d.cube_mesh(vec3(1.0, 1.0, 1.0)),
  )
  let cube_material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(124U, 144U, 255U, 1.0),
    roughness: 0.35,
  })

  let cube = @entity.Entity::new()
  @transform3d.transforms3d.set(cube, {
    translation: vec3(0.0, 0.5, 0.0),
    rotation: @math3d.Quat::identity(),
    scale: @math3d.Vec3::one(),
  })
  @render3d.mesh3d_renderers.set(cube, {
    mesh: cube_mesh,
    material: cube_material,
    visible: true,
  })
  rotating_cube.val = Some(cube)

  let dir_light = @entity.Entity::new()
  @render3d.directional_lights3d.set(dir_light, {
    direction: vec3(-0.35, -1.0, -0.2).normalize(),
    color: color(255U, 255U, 255U, 1.0),
    intensity: 2.0,
    shadows: true,
  })
  @render3d.set_ambient_light3d(
    Some({ color: color(255U, 255U, 255U, 1.0), intensity: 0.2 }),
  )
}

///|
fn rotate_cube_system(delta : Double) -> Unit {
  guard rotating_cube.val is Some(cube) else { return }
  guard @transform3d.transforms3d.get(cube) is Some(transform) else { return }
  cube_rotation.val += delta
  @transform3d.transforms3d.set(cube, {
    ..transform,
    rotation: @math3d.Quat::from_axis_angle(
      vec3(0.0, 1.0, 0.0),
      cube_rotation.val,
    ),
  })
}

///|
fn draw_overlay_system(_delta : Double) -> Unit {
  @backend.draw_text(@render.TextDrawCommand::{
    text: "3d_scene: ECS render3d pipeline",
    position: @math.Vec2D(16.0, 16.0),
    style: @render.TextStyle::{
      family: "sans-serif",
      size: 20.0,
      color: color(245U, 245U, 245U, 1.0),
      align: Left,
      baseline: Top,
    },
  })
}
