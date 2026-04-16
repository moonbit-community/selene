///|
pub fn rigid_body_rotation(entity : @entity.Entity) -> Double? {
  entity_physics_snapshot(entity).map(fn(snapshot) { snapshot.rotation })
}

///|
pub fn set_rigid_body_rotation(
  entity : @entity.Entity,
  rotation : Double,
) -> Unit {
  set_entity_rotation(entity, rotation)
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    match entity_rigid_body(entity).body_type {
      KinematicPositionBased => {
        body.set_rotation(to_physics_rotation(rotation), true) |> ignore
        body.set_next_kinematic_rotation(to_physics_rotation(rotation))
        |> ignore
      }
      _ => body.set_rotation(to_physics_rotation(rotation), true) |> ignore
    }
  } else {
    pending_body_rotations().set(entity, rotation)
  }
}

///|
pub fn rigid_body_linear_velocity(entity : @entity.Entity) -> @math.Vec2? {
  entity_physics_snapshot(entity).map(fn(snapshot) {
    snapshot.linear_velocity.unwrap_or(@math.Vec2::zero())
  })
}

///|
pub fn set_rigid_body_linear_velocity(
  entity : @entity.Entity,
  linear_velocity : @math.Vec2,
) -> Unit {
  match entity_rigid_body(entity).body_type {
    Fixed => {
      @velocity.velocities().remove(entity)
      pending_body_linear_velocities().remove(entity)
      if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get_mut(handle) is Some(body) {
        body.set_linvel(@rapier_full.Vec2::zero(), false) |> ignore
      }
    }
    Dynamic =>
      if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get_mut(handle) is Some(body) {
        body.set_linvel(to_physics_vec2(linear_velocity), true) |> ignore
      } else {
        pending_body_linear_velocities().set(entity, linear_velocity)
      }
    KinematicPositionBased | KinematicVelocityBased => {
      @velocity.velocities().set(entity, linear_velocity)
      if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get_mut(handle) is Some(body) {
        body.set_linvel(to_physics_vec2(linear_velocity), true) |> ignore
      } else {
        pending_body_linear_velocities().set(entity, linear_velocity)
      }
    }
  }
}

///|
pub fn rigid_body_angular_velocity(entity : @entity.Entity) -> Double? {
  entity_physics_snapshot(entity).map(fn(snapshot) {
    snapshot.angular_velocity.unwrap_or(0.0)
  })
}

///|
pub fn set_rigid_body_angular_velocity(
  entity : @entity.Entity,
  angular_velocity : Double,
) -> Unit {
  match entity_rigid_body(entity).body_type {
    Dynamic | KinematicVelocityBased =>
      if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get_mut(handle) is Some(body) {
        body.set_angvel(Float::from_double(angular_velocity), true) |> ignore
      } else {
        pending_body_angular_velocities().set(entity, angular_velocity)
      }
    _ =>
      if world().entity_bodies.get(entity) is Some(handle) &&
        world().bodies.get_mut(handle) is Some(body) {
        body.set_angvel(0.0F, false) |> ignore
      } else {
        pending_body_angular_velocities().remove(entity)
      }
  }
}

///|
pub fn add_force(
  entity : @entity.Entity,
  force : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(force) <= EPSILON {
    return
  }
  if !apply_force_now(entity, force, wake_up) {
    accumulate_pending_vec2(pending_body_forces(), entity, force)
  }
}

///|
pub fn add_force_at_point(
  entity : @entity.Entity,
  force : @math.Vec2,
  point : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(force) <= EPSILON {
    return
  }
  if !apply_force_at_point_now(entity, force, point, wake_up) {
    push_pending_force_point(
      pending_body_force_points(),
      entity,
      (force, point),
    )
  }
}

///|
pub fn add_torque(
  entity : @entity.Entity,
  torque : Double,
  wake_up? : Bool = true,
) -> Unit {
  if torque.abs() <= EPSILON {
    return
  }
  if !apply_torque_now(entity, torque, wake_up) {
    accumulate_pending_scalar(pending_body_torques(), entity, torque)
  }
}

///|
pub fn apply_impulse(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(impulse) <= EPSILON {
    return
  }
  if !apply_impulse_now(entity, impulse, wake_up) {
    accumulate_pending_vec2(pending_body_impulses(), entity, impulse)
  }
}

///|
pub fn apply_impulse_at_point(
  entity : @entity.Entity,
  impulse : @math.Vec2,
  point : @math.Vec2,
  wake_up? : Bool = true,
) -> Unit {
  if vec2_length_squared(impulse) <= EPSILON {
    return
  }
  if !apply_impulse_at_point_now(entity, impulse, point, wake_up) {
    push_pending_force_point(
      pending_body_impulse_points(),
      entity,
      (impulse, point),
    )
  }
}

///|
pub fn apply_torque_impulse(
  entity : @entity.Entity,
  impulse : Double,
  wake_up? : Bool = true,
) -> Unit {
  if impulse.abs() <= EPSILON {
    return
  }
  if !apply_torque_impulse_now(entity, impulse, wake_up) {
    accumulate_pending_scalar(pending_body_torque_impulses(), entity, impulse)
  }
}

///|
pub fn reset_forces(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
  pending_body_forces().remove(entity)
  pending_body_force_points().remove(entity)
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.reset_forces(wake_up) |> ignore
  }
}

///|
pub fn reset_torques(entity : @entity.Entity, wake_up? : Bool = true) -> Unit {
  pending_body_torques().remove(entity)
  pending_body_torque_impulses().remove(entity)
  if world().entity_bodies.get(entity) is Some(handle) &&
    world().bodies.get_mut(handle) is Some(body) {
    body.reset_torques(wake_up) |> ignore
  }
}

///|
fn to_physics_scalar(value : Double) -> Double {
  value / physics_config.pixels_per_meter
}

///|
fn from_physics_scalar(value : Double) -> Double {
  value * physics_config.pixels_per_meter
}

///|
fn to_physics_vec2(value : @math.Vec2) -> @rapier_full.Vec2 {
  @rapier_full.Vec2::new(
    Float::from_double(to_physics_scalar(value[X])),
    Float::from_double(to_physics_scalar(value[Y])),
  )
}

///|
fn to_physics_direction(value : @math.Vec2) -> @rapier_full.Vec2 {
  @rapier_full.Vec2::new(
    Float::from_double(value[X]),
    Float::from_double(value[Y]),
  )
}

///|
fn from_physics_vec2(value : @rapier_full.Vec2) -> @math.Vec2 {
  @math.Vec2(
    from_physics_scalar(value.x.to_double()),
    from_physics_scalar(value.y.to_double()),
  )
}
