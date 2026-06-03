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
const TANK_SCENE_PATH : String = "assets/tank3d/tank_1_green.glb"

///|
const TANK_SCALE : Double = 1.35

///|
let tank_root : Ref[@entity.Entity?] = Ref(None)

///|
fn color(r : UInt, g : UInt, b : UInt, a : Double) -> @render.Color {
  @render.Color::{ r, g, b, a }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @math.Vec3 {
  @math.Vec3(x, y, z)
}

///|
fn look_at_rotation(position : @math.Vec3, target : @math.Vec3) -> @math.Quat {
  let forward = (target - position).normalize()
  if forward.length_squared() <= 0.0000001 {
    return @math.Quat::identity()
  }
  let world_up = @math.Vec3::y_axis()
  let right = forward.cross(world_up).normalize()
  let camera_z = -forward
  let camera_y = camera_z.cross(right).normalize()
  @math.Quat::from_basis(right, camera_y, camera_z)
}

///|
fn tank_basis_rotation() -> @math.Quat {
  // The source model is z-up. Selene's 3D camera and primitives are y-up.
  @math.Quat::from_axis_angle(@math.Vec3::x_axis(), -@cmath.PI / 2.0)
}

///|
pub fn app() -> @app.App {
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .with_fps(60)
  .add_plugin(@plugins.default_3d_plugin)
  .add_system(Startup, setup_tank3d)
  .add_system(Update, rotate_tank_system)
}

///|
pub fn run() -> Unit {
  app().run()
}

///|
fn setup_tank3d(_world : @ecs.World) -> Unit {
  setup_camera()
  setup_lighting()
  setup_floor()
  let scene = @scene.load_scene_gltf(TANK_SCENE_PATH)
  let instance = @scene.instantiate_scene(scene, {
    translation: vec3(0.0, 0.5, 0.0),
    rotation: tank_basis_rotation(),
    scale: vec3(TANK_SCALE, TANK_SCALE, TANK_SCALE),
  })
  tank_root.val = Some(instance.root)
}

///|
fn setup_camera() -> Unit {
  let camera = @entity.Entity()
  let position = vec3(0.0, 2.1, 4.8)
  @transform.transforms().set(camera, {
    translation: position,
    rotation: look_at_rotation(position, vec3(0.0, 0.55, 0.0)),
    scale: @math.Vec3::one(),
  })
  @camera3d.cameras3d().set(camera, {
    ..@camera3d.Camera3DComponent::default(),
    clear_color: color(18U, 22U, 28U, 1.0),
    fov_y: 50.0,
    near: 0.05,
    far: 100.0,
  })
}

///|
fn setup_lighting() -> Unit {
  @render3d.set_ambient_light3d(
    Some({ color: color(255U, 255U, 255U, 1.0), intensity: 0.12 }),
  )
  let light = @entity.Entity()
  @render3d.directional_lights3d().set(light, {
    ..@render3d.default_directional_light3d(),
    direction: vec3(-0.35, -0.82, -0.46).normalize(),
    color: color(255U, 244U, 220U, 1.0),
    intensity: 2.1,
    shadows: false,
  })
}

///|
fn setup_floor() -> Unit {
  let mesh = @render3d.register_mesh_asset(
    @render3d.plane_mesh(vec3(8.0, 0.02, 8.0)),
  )
  let material = @render3d.register_material_asset({
    ..@render3d.default_standard_material3d(),
    base_color: color(54U, 61U, 68U, 1.0),
    roughness: 0.85,
  })
  let floor = @entity.Entity()
  @transform.transforms().set(floor, {
    translation: vec3(0.0, -0.02, 0.0),
    rotation: @math.Quat::identity(),
    scale: @math.Vec3::one(),
  })
  @render3d.mesh3d_renderers().set(floor, {
    mesh,
    material,
    visible: true,
    cast_shadows: false,
    receive_shadows: true,
  })
}

///|
fn rotate_tank_system(_world : @ecs.World) -> Unit {
  guard tank_root.val is Some(root) else { return }
  let yaw = @math.Quat::from_axis_angle(
    @math.Vec3::y_axis(),
    @time.elapsed() * 0.35,
  )
  @transform.transforms().set(root, {
    translation: vec3(0.0, 0.5, 0.0),
    rotation: yaw * tank_basis_rotation(),
    scale: vec3(TANK_SCALE, TANK_SCALE, TANK_SCALE),
  })
}
