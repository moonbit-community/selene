///|
fn consume_pending_body_actions(entity : @entity.Entity) -> Unit {
  pending_body_forces().remove(entity)
  pending_body_force_points().remove(entity)
  pending_body_torques().remove(entity)
  pending_body_impulses().remove(entity)
  pending_body_impulse_points().remove(entity)
  pending_body_torque_impulses().remove(entity)
}

///|
fn apply_pending_body_actions(entity : @entity.Entity) -> Unit {
  if pending_body_forces().get(entity) is Some(force) {
    ignore(apply_force_now(entity, force, true))
  }
  if pending_body_force_points().get(entity) is Some(force_points) {
    for entry in force_points {
      ignore(apply_force_at_point_now(entity, entry.0, entry.1, true))
    }
  }
  if pending_body_torques().get(entity) is Some(torque) {
    ignore(apply_torque_now(entity, torque, true))
  }
  if pending_body_impulses().get(entity) is Some(impulse) {
    ignore(apply_impulse_now(entity, impulse, true))
  }
  if pending_body_impulse_points().get(entity) is Some(impulse_points) {
    for entry in impulse_points {
      ignore(apply_impulse_at_point_now(entity, entry.0, entry.1, true))
    }
  }
  if pending_body_torque_impulses().get(entity) is Some(torque_impulse) {
    ignore(apply_torque_impulse_now(entity, torque_impulse, true))
  }
  consume_pending_body_actions(entity)
}

///|
fn prune_pending_body_state() -> Unit {
  for _idx, entry in pending_body_rotations().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_rotations().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_linear_velocities().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_linear_velocities().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_angular_velocities().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_angular_velocities().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_forces().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_forces().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_force_points().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_force_points().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_torques().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_torques().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_impulses().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_impulses().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_impulse_points().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_impulse_points().remove(entry.0)
    }
  }
  for _idx, entry in pending_body_torque_impulses().to_array() {
    if !entry.0.is_alive() || !world_entity(entry.0) {
      pending_body_torque_impulses().remove(entry.0)
    }
  }
}

///|
fn motor_model_to_rapier(
  model : JointMotorModel,
) -> @rapier_dynamics.MotorModel {
  match model {
    AccelerationBased => @rapier_dynamics.MotorModel::AccelerationBased
    ForceBased => @rapier_dynamics.MotorModel::ForceBased
  }
}

///|
fn joint_softness_to_rapier(
  softness : JointSoftness,
) -> @rapier_dynamics.SpringCoefficients {
  @rapier_dynamics.SpringCoefficients::new(
    Float::from_double(softness.natural_frequency),
    Float::from_double(softness.damping_ratio),
  )
}

///|
fn body_handle_parts(handle : @rapier_dynamics.RigidBodyHandle) -> (Int, Int) {
  handle.into_raw_parts()
}

///|
fn joint_endpoint_handles(
  joint : Joint,
) -> (@rapier_dynamics.RigidBodyHandle, @rapier_dynamics.RigidBodyHandle)? {
  guard world().entity_bodies.get(joint.entity1) is Some(body1) else {
    return None
  }
  guard world().entity_bodies.get(joint.entity2) is Some(body2) else {
    return None
  }
  if body_handle_parts(body1) == body_handle_parts(body2) {
    None
  } else {
    Some((body1, body2))
  }
}

///|
fn entity_joint_config_key(
  joint : Joint,
  body1 : @rapier_dynamics.RigidBodyHandle,
  body2 : @rapier_dynamics.RigidBodyHandle,
) -> EntityJointConfigKey {
  { joint, body1: body_handle_parts(body1), body2: body_handle_parts(body2) }
}

///|
fn joint_to_rapier(joint : Joint) -> @rapier_dynamics.GenericJoint? {
  let generic = match joint.kind {
    Fixed(local_anchor1~, local_anchor2~) => {
      let builder = @rapier_dynamics.FixedJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      Some(@rapier_dynamics.GenericJoint::from_fixed(builder.build()))
    }
    Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~) => {
      let mut builder = @rapier_dynamics.RevoluteJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      if limits is Some(limits) {
        builder = builder.limits(
          Float::from_double(limits.min),
          Float::from_double(limits.max),
        )
      }
      if softness is Some(softness) {
        builder = builder.softness(joint_softness_to_rapier(softness))
      }
      if motor is Some(motor) {
        match motor {
          Position(target_position~, stiffness~, damping~, max_force~, model~) => {
            builder = builder
              .motor_position(
                Float::from_double(target_position),
                Float::from_double(stiffness),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
          Velocity(target_velocity~, damping~, max_force~, model~) => {
            builder = builder
              .motor_velocity(
                Float::from_double(target_velocity),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
        }
      }
      Some(@rapier_dynamics.GenericJoint::from_revolute(builder.build()))
    }
    Prismatic(axis~, local_anchor1~, local_anchor2~, limits~) =>
      if vec2_length_squared(axis) <= EPSILON {
        None
      } else {
        let mut builder = @rapier_dynamics.PrismaticJointBuilder::new(
            to_physics_direction(axis.normalize()),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
        if limits is Some(limits) {
          builder = builder.limits(
            Float::from_double(to_physics_scalar(limits.min)),
            Float::from_double(to_physics_scalar(limits.max)),
          )
        }
        Some(@rapier_dynamics.GenericJoint::from_prismatic(builder.build()))
      }
    Rope(max_distance~, local_anchor1~, local_anchor2~) =>
      if max_distance < 0.0 {
        None
      } else {
        let builder = @rapier_dynamics.RopeJointBuilder::new(
            Float::from_double(to_physics_scalar(max_distance)),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
        Some(@rapier_dynamics.GenericJoint::from_rope(builder.build()))
      }
    Spring(
      rest_length~,
      stiffness~,
      damping~,
      local_anchor1~,
      local_anchor2~,
      model~
    ) =>
      if rest_length < 0.0 {
        None
      } else {
        let spring = @rapier_dynamics.SpringJointBuilder::new(
            Float::from_double(to_physics_scalar(rest_length)),
            Float::from_double(stiffness),
            Float::from_double(damping),
          )
          .local_anchor1(to_physics_vec2(local_anchor1))
          .local_anchor2(to_physics_vec2(local_anchor2))
          .contacts_enabled(joint.contacts_enabled)
          .spring_model(motor_model_to_rapier(model))
          .build()
        Some(spring.data())
      }
  }
  generic.map(fn(generic) {
    generic
    .set_contacts_enabled(joint.contacts_enabled)
    .set_enabled(joint.active)
  })
}

///|
fn multibody_joint_endpoint_handles(
  entity : @entity.Entity,
  joint : MultibodyJoint,
) -> (@rapier_dynamics.RigidBodyHandle, @rapier_dynamics.RigidBodyHandle)? {
  guard world().entity_bodies.get(joint.parent) is Some(parent) else {
    return None
  }
  guard world().entity_bodies.get(entity) is Some(child) else { return None }
  if body_handle_parts(parent) == body_handle_parts(child) {
    None
  } else {
    Some((parent, child))
  }
}

///|
fn entity_multibody_joint_config_key(
  entity : @entity.Entity,
  joint : MultibodyJoint,
  parent : @rapier_dynamics.RigidBodyHandle,
  child : @rapier_dynamics.RigidBodyHandle,
) -> EntityMultibodyJointConfigKey {
  entity |> ignore
  { joint, parent: body_handle_parts(parent), child: body_handle_parts(child) }
}

///|
fn multibody_joint_to_rapier(
  joint : MultibodyJoint,
) -> @rapier_dynamics.GenericJoint? {
  if !joint.active {
    return None
  }
  match joint.kind {
    Revolute(local_anchor1~, local_anchor2~, limits~, motor~, softness~) => {
      let mut builder = @rapier_dynamics.RevoluteJointBuilder::new()
        .local_anchor1(to_physics_vec2(local_anchor1))
        .local_anchor2(to_physics_vec2(local_anchor2))
      if limits is Some(limits) {
        builder = builder.limits(
          Float::from_double(limits.min),
          Float::from_double(limits.max),
        )
      }
      if softness is Some(softness) {
        builder = builder.softness(joint_softness_to_rapier(softness))
      }
      if motor is Some(motor) {
        match motor {
          Position(target_position~, stiffness~, damping~, max_force~, model~) => {
            builder = builder
              .motor_position(
                Float::from_double(target_position),
                Float::from_double(stiffness),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
          Velocity(target_velocity~, damping~, max_force~, model~) => {
            builder = builder
              .motor_velocity(
                Float::from_double(target_velocity),
                Float::from_double(damping),
              )
              .motor_model(motor_model_to_rapier(model))
            if max_force is Some(max_force) {
              builder = builder.motor_max_force(Float::from_double(max_force))
            }
          }
        }
      }
      Some(@rapier_dynamics.GenericJoint::from_revolute(builder.build()))
    }
  }
}

///|
fn should_have_joint(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  joints().get(entity) is Some(joint) &&
  joint.entity1.is_alive() &&
  joint.entity2.is_alive() &&
  joint_endpoint_handles(joint) is Some(_)
}

///|
fn remove_joint_physics(entity : @entity.Entity) -> Unit {
  if world().entity_joints.get(entity) is Some(handle) &&
    world().impulse_joints.contains(handle) {
    world().impulse_joints.remove(handle, true) |> ignore
  }
  world().entity_joints.remove(entity)
  entity_joint_config_keys().remove(entity)
}

///|
fn should_have_multibody_joint(entity : @entity.Entity) -> Bool {
  entity.is_alive() &&
  world_entity(entity) &&
  multibody_joints().get(entity) is Some(joint) &&
  joint.active &&
  joint.parent.is_alive() &&
  multibody_joint_endpoint_handles(entity, joint) is Some(_)
}

///|
fn remove_multibody_joint_physics(entity : @entity.Entity) -> Unit {
  if world().entity_multibody_joints.get(entity) is Some(handle) &&
    world().multibody_joints.get(handle) is Some(_) {
    world().multibody_joints.remove(handle, true)
  }
  world().entity_multibody_joints.remove(entity)
  entity_multibody_joint_config_keys().remove(entity)
}

///|
fn sync_world_joints() -> Unit {
  for _idx, entry in world().entity_joints.to_array() {
    let entity = entry.0
    let handle = entry.1
    if !should_have_joint(entity) || !world().impulse_joints.contains(handle) {
      remove_joint_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard world_entity(entity) else { continue }
    guard joints().get(entity) is Some(joint) else {
      remove_joint_physics(entity)
      continue
    }
    guard joint_endpoint_handles(joint) is Some((body1, body2)) else {
      remove_joint_physics(entity)
      continue
    }
    guard joint_to_rapier(joint) is Some(rapier_joint) else {
      remove_joint_physics(entity)
      continue
    }
    let config_key = entity_joint_config_key(joint, body1, body2)
    if world().entity_joints.get(entity) is Some(handle) &&
      world().impulse_joints.contains(handle) &&
      entity_joint_config_keys().get(entity) == Some(config_key) {
      continue
    }
    remove_joint_physics(entity)
    let handle = world().impulse_joints.insert(body1, body2, rapier_joint, true)
    world().entity_joints.set(entity, handle)
    entity_joint_config_keys().set(entity, config_key)
  }
}

///|
fn sync_world_multibody_joints() -> Unit {
  for _idx, entry in world().entity_multibody_joints.to_array() {
    let entity = entry.0
    let handle = entry.1
    if !should_have_multibody_joint(entity) ||
      world().multibody_joints.get(handle) is None {
      remove_multibody_joint_physics(entity)
    }
  }

  for entity in @entity.iter_entities() {
    guard world_entity(entity) else { continue }
    guard multibody_joints().get(entity) is Some(joint) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    guard multibody_joint_endpoint_handles(entity, joint)
      is Some((parent, child)) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    guard multibody_joint_to_rapier(joint) is Some(rapier_joint) else {
      remove_multibody_joint_physics(entity)
      continue
    }
    let config_key = entity_multibody_joint_config_key(
      entity, joint, parent, child,
    )
    if world().entity_multibody_joints.get(entity) is Some(handle) &&
      world().multibody_joints.get(handle) is Some(_) &&
      entity_multibody_joint_config_keys().get(entity) == Some(config_key) {
      continue
    }
    remove_multibody_joint_physics(entity)
    guard world().multibody_joints.insert(parent, child, rapier_joint, true)
      is Some(handle) else {
      continue
    }
    world().entity_multibody_joints.set(entity, handle)
    entity_multibody_joint_config_keys().set(entity, config_key)
  }
}
