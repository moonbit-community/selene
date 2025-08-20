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

/// Physics Systems following Selene ECS pattern

// Physics world is defined in world.mbt

///| Main physics integration system
pub fn physics_integration_system(_backend : &@system.Backend) -> Unit {
  let dt = 1.0 / 60.0 // Fixed timestep

  // Apply gravity and integrate forces
  for entity, rigid_body in rigid_bodies {
    guard physics_velocities.get(entity) is Some(velocity) else { continue }
    guard @position.positions.get(entity) is Some(position) else { continue }
    guard angular_positions.get(entity) is Some(angular_pos) else { continue }

    // Skip static bodies
    if rigid_body.body_type == Static {
      continue
    }

    // Get or create forces component
    let current_forces = forces.get(entity).unwrap_or(Forces::zero())

    // Apply gravity
    let gravity_force = physics_world.val.gravity.mul_scalar(
      rigid_body.mass * rigid_body.gravity_scale,
    )
    let total_force = current_forces.force + gravity_force

    // Integrate velocity: v = v + (F/m + gravity) * dt
    let new_linear_velocity = velocity.linear +
      total_force.mul_scalar(rigid_body.inv_mass * dt)
    let new_angular_velocity = velocity.angular +
      current_forces.torque * (rigid_body.inv_inertia * dt)

    // Apply damping
    let damped_linear = new_linear_velocity.mul_scalar(
      1.0 / (1.0 + dt * rigid_body.linear_damping),
    )
    let damped_angular = new_angular_velocity *
      (1.0 / (1.0 + dt * rigid_body.angular_damping))

    // Update velocity
    physics_velocities.set(entity, PhysicsVelocity::{
      linear: damped_linear,
      angular: damped_angular,
    })

    // Integrate position: p = p + v * dt
    let new_position = position.inner() + damped_linear.mul_scalar(dt)
    let new_angle = angular_pos.get() + damped_angular * dt

    // Update positions
    @position.positions.set(entity, @position.Position(new_position))
    angular_positions.set(entity, AngularPosition(new_angle))

    // Update physics transform (use existing PhysicsTransform functions)
    // physics_transforms.set(entity, PhysicsTransform::from_position_angle(new_position, new_angle))

    // Clear forces after integration
    forces.set(entity, Forces::zero())
  }
}

///| Sync physics velocities to Selene's velocity system (for compatibility)
pub fn sync_physics_to_velocity_system(_backend : &@system.Backend) -> Unit {
  for entity, physics_vel in physics_velocities {
    @velocity.velocities.set(entity, @velocity.Velocity(physics_vel.linear))
  }
}

///| Sync Selene's velocity system to physics (for kinematic bodies)
pub fn sync_velocity_to_physics_system(_backend : &@system.Backend) -> Unit {
  for entity, rigid_body in rigid_bodies {
    if rigid_body.body_type == Kinematic {
      guard @velocity.velocities.get(entity) is Some(velocity) else { continue }
      physics_velocities.set(entity, PhysicsVelocity::{
        linear: velocity.inner(),
        angular: 0.0,
      })
    }
  }
}

///| Apply force to an entity
pub fn apply_force_to_entity(
  entity : @system.Entity,
  force : @smath.Vec2D,
) -> Unit {
  let current_forces = forces.get(entity).unwrap_or(Forces::zero())
  forces.set(entity, Forces::{
    force: current_forces.force + force,
    torque: current_forces.torque,
  })
}

///|
test "apply_force_to_entity should accumulate forces correctly" {
  let test_entity = @system.Entity::new()

  // Apply first force
  apply_force_to_entity(test_entity, @smath.Vec2D(10.0, 5.0))
  match forces.get(test_entity) {
    Some(f1) => {
      assert_true(f1.force[X] == 10.0)
      assert_true(f1.force[Y] == 5.0)
    }
    None => assert_true(false)
  }

  // Apply second force - should accumulate
  apply_force_to_entity(test_entity, @smath.Vec2D(3.0, -2.0))
  match forces.get(test_entity) {
    Some(f2) => {
      assert_true(f2.force[X] == 13.0) // 10.0 + 3.0
      assert_true(f2.force[Y] == 3.0) // 5.0 + (-2.0)
    }
    None => assert_true(false)
  }
}

///| Apply impulse to an entity (immediate velocity change)
pub fn apply_impulse_to_entity(
  entity : @system.Entity,
  impulse : @smath.Vec2D,
) -> Unit {
  guard rigid_bodies.get(entity) is Some(rigid_body) else { return }
  guard physics_velocities.get(entity) is Some(velocity) else { return }
  let new_velocity = velocity.linear + impulse.mul_scalar(rigid_body.inv_mass)
  physics_velocities.set(entity, PhysicsVelocity::{
    linear: new_velocity,
    angular: velocity.angular,
  })
}

///|
test "apply_impulse_to_entity should change velocity immediately" {
  let test_entity = @system.Entity::new()
  create_physics_entity(test_entity, @smath.Vec2D(0.0, 0.0), Dynamic, 2.0)

  // Apply impulse
  apply_impulse_to_entity(test_entity, @smath.Vec2D(4.0, -2.0))
  match physics_velocities.get(test_entity) {
    Some(vel) => {
      // With mass = 2.0, inv_mass = 0.5
      // New velocity = 0 + impulse * inv_mass = (4, -2) * 0.5 = (2, -1)
      assert_true(vel.linear[X] == 2.0)
      assert_true(vel.linear[Y] == -1.0)
    }
    None => assert_true(false)
  }
}

///| Apply torque to an entity
pub fn apply_torque_to_entity(entity : @system.Entity, torque : Double) -> Unit {
  let current_forces = forces.get(entity).unwrap_or(Forces::zero())
  forces.set(entity, Forces::{
    force: current_forces.force,
    torque: current_forces.torque + torque,
  })
}

///| Set linear velocity of an entity
pub fn set_physics_velocity(
  entity : @system.Entity,
  velocity : @smath.Vec2D,
) -> Unit {
  guard physics_velocities.get(entity) is Some(current_vel) else { return }
  physics_velocities.set(entity, PhysicsVelocity::{
    linear: velocity,
    angular: current_vel.angular,
  })
}

///| Get linear velocity of an entity
pub fn get_physics_velocity(entity : @system.Entity) -> @smath.Vec2D? {
  guard physics_velocities.get(entity) is Some(velocity) else { return None }
  Some(velocity.linear)
}

///| Create a physics entity with all necessary components
pub fn create_physics_entity(
  entity : @system.Entity,
  position : @smath.Vec2D,
  body_type : BodyType,
  mass : Double,
) -> Unit {
  // Set standard components
  @position.positions.set(entity, @position.Position(position))
  @velocity.velocities.set(entity, @velocity.Velocity(@smath.Vec2D(0.0, 0.0)))

  // Set physics components
  rigid_bodies.set(entity, RigidBody::new(body_type, mass))
  physics_velocities.set(entity, PhysicsVelocity::zero())
  forces.set(entity, Forces::zero())
  angular_positions.set(entity, AngularPosition::zero())
}

///|
test "create_physics_entity should set up all components correctly" {
  let test_entity = @system.Entity::new()
  let test_pos = @smath.Vec2D(10.0, 20.0)
  create_physics_entity(test_entity, test_pos, Dynamic, 2.5)

  // Check position component
  match @position.positions.get(test_entity) {
    Some(pos) => {
      assert_true(pos.inner()[X] == 10.0)
      assert_true(pos.inner()[Y] == 20.0)
    }
    None => assert_true(false)
  }

  // Check rigid body component
  match rigid_bodies.get(test_entity) {
    Some(body) => {
      assert_true(body.body_type == Dynamic)
      assert_true(body.mass == 2.5)
    }
    None => assert_true(false)
  }

  // Check physics velocity is zero
  match physics_velocities.get(test_entity) {
    Some(vel) => {
      assert_true(vel.linear[X] == 0.0)
      assert_true(vel.linear[Y] == 0.0)
      assert_true(vel.angular == 0.0)
    }
    None => assert_true(false)
  }
}

///| Add a physics shape to an entity (placeholder - shapes handled in types.mbt)
pub fn add_physics_shape_to_entity(
  _entity : @system.Entity,
  _shape_def : ShapeDef,
) -> Unit {
  // Implementation will use the existing PhysicsShape from types.mbt
  // For now this is a placeholder for the ECS integration
}

///| Combined physics system (call this from your app)
pub fn physics_system(backend : &@system.Backend) -> Unit {
  sync_velocity_to_physics_system(backend)
  physics_integration_system(backend)
  sync_physics_to_velocity_system(backend)
}
