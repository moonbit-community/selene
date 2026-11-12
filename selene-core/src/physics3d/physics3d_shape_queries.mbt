///|
fn shapes_intersect(
  shape_a : @collision.Shape3D,
  iso_a : @core.Isometry3,
  shape_b : @collision.Shape3D,
  iso_b : @core.Isometry3,
) -> Bool {
  match shape_a {
    Ball(radius_a) =>
      match shape_b {
        Ball(radius_b) =>
          @collision.compute_ball_ball_contact(
            iso_a.translation,
            radius_a,
            iso_b.translation,
            radius_b,
          )
          is Some(_)
        Cuboid(half_extents) =>
          @collision.compute_ball_cuboid_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_extents,
          )
          is Some(_)
        CapsuleY(half_height, capsule_radius) =>
          @collision.compute_ball_capsule_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            capsule_radius,
          )
          is Some(_)
        Cylinder(half_height, cylinder_radius) =>
          @collision.compute_ball_cylinder_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cylinder_radius,
          )
          is Some(_)
        Cone(half_height, cone_radius) =>
          @collision.compute_ball_cone_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cone_radius,
          )
          is Some(_)
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_ball_trimesh_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            vertices,
            indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_ball_heightfield_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            points,
            nrows,
            ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    Cuboid(half_extents_a) =>
      match shape_b {
        Ball(_) | CapsuleY(_, _) | Cylinder(_, _) | Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        Cuboid(half_extents_b) =>
          @collision.compute_cuboid_cuboid_contact(
            iso_a, half_extents_a, iso_b, half_extents_b,
          )
          is Some(_)
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_cuboid_trimesh_contact(
            iso_a, half_extents_a, iso_b, vertices, indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cuboid_heightfield_contact(
            iso_a, half_extents_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    CapsuleY(half_height_a, radius_a) =>
      match shape_b {
        Ball(_) | Cuboid(_) => shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        CapsuleY(half_height_b, radius_b) =>
          @collision.compute_capsule_capsule_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_capsule_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_capsule_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    Cylinder(half_height_a, radius_a) =>
      match shape_b {
        Ball(_) | Cuboid(_) | Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        Cylinder(half_height_b, radius_b) =>
          @collision.compute_cylinder_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_cylinder_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cylinder_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    Cone(half_height_a, radius_a) =>
      match shape_b {
        Ball(_) | Cuboid(_) => shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        Cylinder(half_height_b, radius_b) =>
          @collision.compute_cone_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        Cone(half_height_b, radius_b) =>
          @collision.compute_cone_cone_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_cone_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cone_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    RoundCylinder(half_height, radius, border_radius) =>
      match shape_b {
        HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        TriMesh(vertices, indices) =>
          @collision.compute_round_cylinder_trimesh_contact(
            iso_a, half_height, radius, border_radius, iso_b, vertices, indices,
          )
          is Some(_)
        Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_round_cylinder_heightfield_contact(
            iso_a, half_height, radius, border_radius, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    HalfSpace(normal) =>
      @collision.compute_halfspace_contact(iso_a, normal, iso_b, shape_b)
      is Some(_)
    TriMesh(_, _) =>
      match shape_b {
        Ball(_)
        | Cuboid(_)
        | CapsuleY(_, _)
        | Cylinder(_, _)
        | Cone(_, _)
        | RoundCylinder(_, _, _)
        | HalfSpace(_) => shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    Heightfield(_, _, _, _, _) =>
      match shape_b {
        Ball(_)
        | Cuboid(_)
        | CapsuleY(_, _)
        | Cylinder(_, _)
        | Cone(_, _)
        | RoundCylinder(_, _, _)
        | HalfSpace(_) => shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    _ =>
      @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
      is Some(_)
  }
}

///|
fn additional_mass_properties_to_rapier(
  props : AdditionalMassProperties,
) -> @core.MassProperties3 {
  match props {
    Mass(mass) =>
      @core.MassProperties3::default().set_mass(Float::from_double(mass), true)
    MassProperties(mass_properties) => mass_properties
  }
}

///|
fn rigid_pose(global : @transform.GlobalTransform) -> @transform.Transform? {
  let { x_axis, y_axis, z_axis, .. } = global.affine
  let zero = @math.Vec3::zero()
  guard x_axis != zero && y_axis != zero && z_axis != zero else { None }
  global.try_decompose_trs()
}

///|
fn current_world_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> @transform.Transform? {
  @transform.compute_global_transform(world~, entity).bind(rigid_pose)
}

///|
fn set_entity_world_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  world_transform : @transform.Transform,
) -> Bool {
  let query_spatial : @ecs.Query[@transform.Spatial] = world.query()
  if query_spatial.contains(entity) {
    let local_transform = match entity.get_parent() {
      Some(parent) => {
        guard @transform.compute_global_transform(world~, parent)
          is Some(parent_global) &&
          @transform.GlobalTransform::from_transform(world_transform).relative_trs(
            parent_global,
          )
          is Some(local_transform) else {
          return false
        }
        local_transform
      }
      None => world_transform
    }
    @transform.set_local_transform(world~, entity, local_transform)
  }
  true
}

///|
fn attached_rigid_body_entity(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> @ecs.Entity? {
  let query_rigid_body : @ecs.Query[RigidBody] = world.query()
  if query_rigid_body.contains(entity) {
    return Some(entity)
  }
  let mut current = entity.get_parent()
  while current is Some(parent) {
    if query_rigid_body.contains(parent) {
      return Some(parent)
    }
    current = parent.get_parent()
  }
  None
}

///|
fn collider_transform(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  body_entity : @ecs.Entity?,
) -> @transform.Transform? {
  guard @transform.compute_global_transform(world~, entity) is Some(global) &&
    rigid_pose(global) is Some(world_pose) else {
    None
  }
  match body_entity {
    Some(parent) if parent == entity => Some(@transform.Transform::identity())
    Some(parent) => {
      guard @transform.compute_global_transform(world~, parent)
        is Some(parent_global) &&
        rigid_pose(parent_global) is Some(_) else {
        None
      }
      global.relative_trs(parent_global)
    }
    None => Some(world_pose)
  }
}

///|
fn set_standalone_collider_position(
  world~ : @ecs.World,
  collider : @collision.Collider3D,
  entity : @ecs.Entity,
) -> Unit {
  match current_world_transform(world~, entity) {
    Some(transform) =>
      collider.set_position(
        Isometry3(
          vec3_to_rapier(transform.translation),
          rotation_to_rapier(transform.rotation),
        ),
      )
    None => ()
  }
}

///|
fn resolve_collider_entity(
  handle : @collision.ColliderHandle3D,
) -> @ecs.Entity? {
  collider_entities_by_key().get(collider_key(handle))
}

///|
fn collider_key(handle : @collision.ColliderHandle3D) -> (Int32, Int32) {
  handle.into_raw_parts()
}
