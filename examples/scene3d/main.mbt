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
#selene.resource
priv struct Scene3dState {
  entities : Array[@ecs.Entity]
  mut rotating_cube : @ecs.Entity?
  mut cube_rotation : Double
  mut spotlight_entity : @ecs.Entity?
  mut spotlight_phase : Double
  mut physics_label : @ecs.Entity?
  mut dynamic_ball_entity : @ecs.Entity?
  mut joint_ball_entity : @ecs.Entity?
  mut controller_entity : @ecs.Entity?
  contact_force_reader : @event.EventReader[@physics3d.ContactForceEvent]
  mut last_contact_force : Double
}

///|
fn Scene3dState::Scene3dState() -> Scene3dState {
  {
    entities: [],
    rotating_cube: None,
    cube_rotation: 0.0,
    spotlight_entity: None,
    spotlight_phase: 0.0,
    physics_label: None,
    dynamic_ball_entity: None,
    joint_ball_entity: None,
    controller_entity: None,
    contact_force_reader: EventReader(),
    last_contact_force: 0.0,
  }
}

///|
fn scene3d_state() -> Scene3dState {
  @ecs.require_current_world().resource()
}

///|
fn[T : @ecs.Bundle] spawn_scene3d_entity(values : T) -> @ecs.Entity {
  let entity = @ecs.require_current_world().spawn(values)
  scene3d_state().entities.push(entity)
  entity
}

///|
fn color(r : UInt32, g : UInt32, b : UInt32, a : Double) -> @render.Color {
  { r, g, b, a, }
}

///|
fn character_input_vector() -> @math.Vec2 {
  let input = @math.Vec2(
    @input_action.action_value(scene3d_move_right_action()) -
    @input_action.action_value(scene3d_move_left_action()),
    @input_action.action_value(scene3d_move_back_action()) -
    @input_action.action_value(scene3d_move_forward_action()),
  )
  if input.distance() > 1.0 {
    input.normalize()
  } else {
    input
  }
}

///|
fn vec3(x : Double, y : Double, z : Double) -> @math.Vec3 {
  Vec3(x, y, z)
}

///|
fn ccd_marker() -> @physics3d.Ccd {
  @physics3d.Ccd::{ }
}

///|
fn[T : @ecs.Bundle] spawn_sphere(
  radius : Double,
  translation : @math.Vec3,
  base_color : @render.Color,
  components : T,
  active_events? : @collision.ActiveEvents,
) -> @ecs.Entity {
  let mesh = @render3d.register_mesh_asset(@render3d.sphere_mesh(radius))
  let material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color,
    roughness: 0.3,
  })
  let world = @ecs.require_current_world()
  let plan : @ecs.SpawnPlan[(@transform.Spatial, @render3d.Mesh3DRenderer)] = world.prepare_spawn()
  let plan = plan.combine(world.prepare_spawn())
  let values = (
    (
      @transform.Spatial({
        translation,
        rotation: @math.Quat::identity(),
        scale: @math.Vec3::one(),
      }),
      @render3d.Mesh3DRenderer::{
        mesh,
        material,
        visible: true,
        cast_shadows: true,
        receive_shadows: true,
      },
    ),
    components,
  )
  let entity = if active_events is Some(events) {
    plan
    .combine(@physics3d.active_events().spawn_plan(world))
    .spawn((values, events))
  } else {
    plan.spawn(values)
  }
  scene3d_state().entities.push(entity)
  entity
}

///|
fn physics_name(entity : @ecs.Entity) -> String {
  let state = scene3d_state()
  if state.dynamic_ball_entity == Some(entity) {
    "ball"
  } else if state.joint_ball_entity == Some(entity) {
    "joint"
  } else if state.controller_entity == Some(entity) {
    "controller"
  } else {
    "other"
  }
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
  @app.App()
  .with_viewport_width(VIEWPORT_WIDTH)
  .with_viewport_height(VIEWPORT_HEIGHT)
  .with_zoom(1.0)
  .add_plugin(@plugins.default_3d_plugin)
  .add_system(Startup, setup_scene3d)
  .add_system(Update, rotate_cube_system)
  .add_system(Update, animate_spotlight_system)
  .add_system(Update, drive_character_controller_system)
  .add_system(Update, update_physics_overlay_system)
  .run()
}

///|
fn setup_scene3d(world : @ecs.World) -> Unit {
  let previous : Scene3dState? = world.get_resource()
  if previous is Some(previous) {
    for entity in previous.entities {
      ignore(entity.delete())
    }
  }
  let state = Scene3dState()
  world.insert_resource(state)
  configure_scene3d_input()
  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial({
          translation: vec3(0.0, 1.5, 8.0),
          rotation: @math.Quat::identity(),
          scale: @math.Vec3::one(),
        }),
        @camera3d.Camera3DComponent::{
          ..Camera3DComponent(),
          clear_color: color(20U, 20U, 24U, 1.0),
        },
      ),
    ),
  )

  let scene = @scene.load_scene_gltf("assets/scene3d/scene3d.gltf")
  state.entities.push(
    @scene.instantiate_scene(scene, @transform.Transform::identity()).root,
  )

  let floor_mesh = @render3d.register_mesh_asset(
    @render3d.plane_mesh(vec3(10.0, 0.02, 10.0)),
  )
  let floor_material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color: color(96U, 104U, 110U, 1.0),
    roughness: 0.9,
  })
  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial({
          translation: vec3(0.0, -0.01, 0.0),
          rotation: @math.Quat::identity(),
          scale: @math.Vec3::one(),
        }),
        @render3d.Mesh3DRenderer::{
          mesh: floor_mesh,
          material: floor_material,
          visible: true,
          cast_shadows: false,
          receive_shadows: true,
        },
        @physics3d.Collider::cuboid(vec3(5.0, 0.02, 5.0)),
      ),
    ),
  )

  let cube_mesh = @render3d.register_mesh_asset(lit_cube_mesh(1.0))
  let cube_material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color: color(124U, 144U, 255U, 1.0),
    roughness: 0.25,
  })

  let cube = spawn_scene3d_entity(
    (
      @transform.Spatial({
        translation: vec3(0.0, 0.5, 0.0),
        rotation: @math.Quat::identity(),
        scale: @math.Vec3::one(),
      }),
      @render3d.Mesh3DRenderer::{
        mesh: cube_mesh,
        material: cube_material,
        visible: true,
        cast_shadows: true,
        receive_shadows: true,
      },
    ),
  )
  state.rotating_cube = Some(cube)

  let target_mesh = @render3d.register_mesh_asset(@render3d.sphere_mesh(0.45))
  let target_material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color: color(244U, 199U, 124U, 1.0),
    roughness: 0.25,
  })
  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial({
          translation: vec3(1.35, 1.55, -0.75),
          rotation: @math.Quat::identity(),
          scale: @math.Vec3::one(),
        }),
        @render3d.Mesh3DRenderer::{
          mesh: target_mesh,
          material: target_material,
          visible: true,
          cast_shadows: true,
          receive_shadows: true,
        },
      ),
    ),
  )

  let shadow_wall_mesh = @render3d.register_mesh_asset(
    @render3d.cube_mesh(vec3(8.0, 3.2, 0.16)),
  )
  let shadow_wall_material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color: color(86U, 96U, 112U, 1.0),
    roughness: 0.82,
  })
  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial({
          translation: vec3(0.0, 1.6, -2.9),
          rotation: @math.Quat::identity(),
          scale: @math.Vec3::one(),
        }),
        @render3d.Mesh3DRenderer::{
          mesh: shadow_wall_mesh,
          material: shadow_wall_material,
          visible: true,
          cast_shadows: false,
          receive_shadows: true,
        },
      ),
    ),
  )

  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial({
          translation: vec3(-2.2, 0.5, 1.8),
          rotation: @math.Quat::from_axis_angle(vec3(0.0, 1.0, 0.0), 0.45),
          scale: vec3(0.7, 0.7, 0.7),
        }),
        @render3d.Mesh3DRenderer::{
          mesh: cube_mesh,
          material: @render3d.register_material_asset({
            ..StandardMaterial3D(),
            base_color: color(118U, 168U, 240U, 1.0),
            roughness: 0.6,
          }),
          visible: true,
          cast_shadows: true,
          receive_shadows: true,
        },
      ),
    ),
  )

  let dynamic_ball = spawn_sphere(
    0.35,
    vec3(-0.8, 2.7, 1.2),
    color(224U, 123U, 94U, 1.0),
    (
      (Dynamic : @physics3d.RigidBody),
      @physics3d.Collider::ball(0.35),
      @physics3d.Velocity::{
        linvel: vec3(0.2, 0.0, -0.1),
        angvel: vec3(0.0, 0.0, 0.0),
      },
      @physics3d.Damping::{ linear_damping: 1.8, angular_damping: 1.2, },
      (ccd_marker() : @physics3d.Ccd),
      @physics3d.ContactForceEventThreshold(0.0),
    ),
    active_events=@collision.ActiveEvents::collision_events().union(
      @collision.ActiveEvents::contact_force_events(),
    ),
  )
  state.dynamic_ball_entity = Some(dynamic_ball)

  let compound_body = spawn_scene3d_entity(
    (
      @transform.Spatial({
        translation: vec3(-3.0, 0.45, -0.8),
        rotation: @math.Quat::identity(),
        scale: @math.Vec3::one(),
      }),
      @render3d.Mesh3DRenderer::{
        mesh: cube_mesh,
        material: @render3d.register_material_asset({
          ..StandardMaterial3D(),
          base_color: color(122U, 199U, 156U, 1.0),
          roughness: 0.5,
        }),
        visible: true,
        cast_shadows: true,
        receive_shadows: true,
      },
      (Fixed : @physics3d.RigidBody),
      @physics3d.Collider::cuboid(vec3(0.35, 0.35, 0.35)),
    ),
  )

  ignore(
    world.spawn(
      (
        @transform.Spatial({
          translation: vec3(0.0, 0.75, 0.0),
          rotation: @math.Quat::identity(),
          scale: @math.Vec3::one(),
        }),
        @render3d.Mesh3DRenderer::{
          mesh: @render3d.register_mesh_asset(@render3d.sphere_mesh(0.22)),
          material: @render3d.register_material_asset({
            ..StandardMaterial3D(),
            base_color: color(178U, 240U, 212U, 1.0),
            roughness: 0.3,
          }),
          visible: true,
          cast_shadows: true,
          receive_shadows: true,
        },
        @physics3d.Collider::ball(0.22),
      ),
      parent=compound_body,
    ),
  )

  let joint_anchor = spawn_sphere(
    0.14,
    vec3(3.25, 2.7, 1.2),
    color(245U, 245U, 245U, 1.0),
    ((Fixed : @physics3d.RigidBody), @physics3d.Collider::ball(0.14)),
  )

  let joint_ball = spawn_sphere(
    0.28,
    vec3(3.8, 1.5, 1.2),
    color(234U, 196U, 102U, 1.0),
    (
      (Dynamic : @physics3d.RigidBody),
      @physics3d.Collider::ball(0.28),
      @physics3d.Damping::{ linear_damping: 2.2, angular_damping: 1.6, },
      (ccd_marker() : @physics3d.Ccd),
      @physics3d.ImpulseJoint::{
        parent: joint_anchor,
        data: Spherical({
          ..SphericalJoint(),
          local_anchor1: vec3(-0.55, 1.2, 0.0),
          local_anchor2: vec3(0.0, 0.0, 0.0),
        }),
        contacts_enabled: false,
      },
    ),
  )
  state.joint_ball_entity = Some(joint_ball)

  let controller = spawn_sphere(
    0.3,
    vec3(0.0, 0.35, -2.1),
    color(110U, 182U, 255U, 1.0),
    (
      (KinematicPositionBased : @physics3d.RigidBody),
      @physics3d.Collider::ball(0.3),
      @physics3d.KinematicCharacterController(),
    ),
  )
  state.controller_entity = Some(controller)

  let spotlight = spawn_scene3d_entity(
    (
      @transform.Spatial({
        translation: vec3(3.2, 3.0, 0.0),
        rotation: @math.Quat::identity(),
        scale: @math.Vec3::one(),
      }),
      @render3d.SpotLight3D::{
        ..SpotLight3D(),
        direction: vec3(-1.0, -1.2, 0.0).normalize(),
        color: color(255U, 236U, 186U, 1.0),
        intensity: 8.0,
        range: 11.0,
        shadows: true,
        shadow_depth_bias: 0.001,
        shadow_normal_bias: 0.15,
        inner_angle: 0.28,
        outer_angle: 0.72,
      },
    ),
  )
  state.spotlight_entity = Some(spotlight)

  let spotlight_marker_mesh = @render3d.register_mesh_asset(
    @render3d.sphere_mesh(0.14),
  )
  let spotlight_marker_material = @render3d.register_material_asset({
    ..StandardMaterial3D(),
    base_color: color(255U, 236U, 186U, 1.0),
    roughness: 0.05,
  })
  ignore(
    world.spawn(
      (
        @transform.Spatial(@transform.Transform::identity()),
        @render3d.Mesh3DRenderer::{
          mesh: spotlight_marker_mesh,
          material: spotlight_marker_material,
          visible: true,
          cast_shadows: false,
          receive_shadows: false,
        },
      ),
      parent=spotlight,
    ),
  )

  ignore(
    spawn_scene3d_entity(
      (
        @transform.Spatial(@transform.Transform::identity()),
        @render3d.DirectionalLight3D::{
          ..DirectionalLight3D(),
          direction: vec3(-0.72, -1.0, -0.42).normalize(),
          color: color(255U, 255U, 255U, 1.0),
          intensity: 1.15,
          shadows: true,
          shadow_depth_bias: 0.001,
          shadow_normal_bias: 0.15,
        },
      ),
    ),
  )
  @render3d.set_ambient_light3d(
    Some({ color: color(255U, 255U, 255U, 1.0), intensity: 0.03, }),
  )

  ignore(
    spawn_scene3d_entity(
      (
        @ui.Node::absolute(Vec2(16.0, 16.0), size=Vec2(420.0, 28.0)),
        @ui.Text("3d_scene: WebGPU directional + spot shadows"),
        @ui.TextFont(family="sans-serif", size=20.0),
        @ui.TextColor(color(245U, 245U, 245U, 1.0)),
        @ui.ZIndex(100),
      ),
    ),
  )

  let physics_text = spawn_scene3d_entity(
    (
      @ui.Node::absolute(Vec2(16.0, 46.0), size=Vec2(620.0, 28.0)),
      @ui.Text(
        "physics: ball, child collider, joint, controller, raycast, contact force",
      ),
      @ui.TextFont(family="sans-serif", size=18.0),
      @ui.TextColor(color(214U, 224U, 235U, 1.0)),
      @ui.ZIndex(100),
    ),
  )
  state.physics_label = Some(physics_text)
}

///|
fn rotate_cube_system(_world : @ecs.World) -> Unit {
  let state = scene3d_state()
  let delta = @time.delta()
  guard state.rotating_cube is Some(cube) else { return }
  guard @transform.local_transform(cube) is Some(transform) else { return }
  state.cube_rotation += delta
  @transform.set_local_transform(cube, {
    ..transform,
    rotation: @math.Quat::from_axis_angle(
      vec3(0.0, 1.0, 0.0),
      state.cube_rotation,
    ),
  })
}

///|
fn animate_spotlight_system(_world : @ecs.World) -> Unit {
  let state = scene3d_state()
  let delta = @time.delta()
  guard state.spotlight_entity is Some(spotlight) else { return }
  state.spotlight_phase += delta * 0.9
  let x = @cmath.cos(state.spotlight_phase) * 3.2
  let y = 2.8 + @cmath.sin(state.spotlight_phase * 1.7) * 0.35
  let z = @cmath.sin(state.spotlight_phase) * 3.2
  let position = vec3(x, y, z)
  let focus = vec3(0.0, 0.45, 0.0)
  let direction = (focus - position).normalize()
  if @transform.local_transform(spotlight) is Some(transform) {
    @transform.set_local_transform(spotlight, {
      ..transform,
      translation: position,
    })
  }
  if @render3d.spot_lights3d().get(spotlight) is Some(light) {
    @render3d.spot_lights3d().set(spotlight, { ..light, direction, })
  }
}

///|
fn drive_character_controller_system(_world : @ecs.World) -> Unit {
  guard scene3d_state().controller_entity is Some(controller) else { return }
  guard @physics3d.kinematic_character_controllers().get(controller)
    is Some(config) else {
    return
  }
  let delta = @time.delta()
  let input = character_input_vector()
  let movement = if input == @math.Vec2::zero() {
    vec3(0.0, 0.0, 0.0)
  } else {
    let planar = input.normalize().scalar_mul(2.4 * delta)
    vec3(planar[X], 0.0, planar[Y])
  }
  @physics3d.kinematic_character_controllers().set(controller, {
    ..config,
    translation: Some(movement),
  })
}

///|
fn update_physics_overlay_system(_world : @ecs.World) -> Unit {
  let state = scene3d_state()
  let mut strongest_force = state.last_contact_force * 0.88
  for
    event in state.contact_force_reader.read(@physics3d.contact_force_event_bus) {
    strongest_force = Double::max(strongest_force, event.total_force_magnitude)
  }
  state.last_contact_force = strongest_force

  let ray_hit = @physics3d.context().cast_ray(
    vec3(0.0, 5.0, 1.2),
    vec3(0.0, -1.0, 0.0),
    query_filter=@physics3d.QueryFilter::only_dynamic(),
  )
  let ray_label = match ray_hit {
    Some(hit) => physics_name(hit.entity)
    None => "none"
  }
  let controller_status = match state.controller_entity {
    Some(controller) =>
      match
        @physics3d.kinematic_character_controller_outputs().get(controller) {
        Some(output) => if output.grounded { "grounded" } else { "airborne" }
        None => "pending"
      }
    None => "missing"
  }

  guard state.physics_label is Some(label) else { return }
  @ui.texts().set(
    label,
    Text(
      "physics: ray=\{ray_label}  contact=\{strongest_force}  controller=\{controller_status}",
    ),
  )
}
