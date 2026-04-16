///|
fn shapes_intersect(
  shape_a : @collision.Shape3D,
  iso_a : @core.Isometry3,
  shape_b : @collision.Shape3D,
  iso_b : @core.Isometry3,
) -> Bool {
  match shape_a {
    @collision.Ball(radius_a) =>
      match shape_b {
        @collision.Ball(radius_b) =>
          @collision.compute_ball_ball_contact(
            iso_a.translation,
            radius_a,
            iso_b.translation,
            radius_b,
          )
          is Some(_)
        @collision.Cuboid(half_extents) =>
          @collision.compute_ball_cuboid_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_extents,
          )
          is Some(_)
        @collision.CapsuleY(half_height, capsule_radius) =>
          @collision.compute_ball_capsule_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            capsule_radius,
          )
          is Some(_)
        @collision.Cylinder(half_height, cylinder_radius) =>
          @collision.compute_ball_cylinder_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cylinder_radius,
          )
          is Some(_)
        @collision.Cone(half_height, cone_radius) =>
          @collision.compute_ball_cone_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            half_height,
            cone_radius,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_ball_trimesh_contact(
            iso_a.translation,
            radius_a,
            iso_b,
            vertices,
            indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
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
    @collision.Cuboid(half_extents_a) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cuboid(half_extents_b) =>
          @collision.compute_cuboid_cuboid_contact(
            iso_a, half_extents_a, iso_b, half_extents_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cuboid_trimesh_contact(
            iso_a, half_extents_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cuboid_heightfield_contact(
            iso_a, half_extents_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.CapsuleY(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.CapsuleY(half_height_b, radius_b) =>
          @collision.compute_capsule_capsule_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_capsule_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_capsule_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Cylinder(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) | @collision.Cone(_, _) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cylinder(half_height_b, radius_b) =>
          @collision.compute_cylinder_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cylinder_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cylinder_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Cone(half_height_a, radius_a) =>
      match shape_b {
        @collision.Ball(_) | @collision.Cuboid(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        @collision.Cylinder(half_height_b, radius_b) =>
          @collision.compute_cone_cylinder_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.Cone(half_height_b, radius_b) =>
          @collision.compute_cone_cone_contact(
            iso_a, half_height_a, radius_a, iso_b, half_height_b, radius_b,
          )
          is Some(_)
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_cone_trimesh_contact(
            iso_a, half_height_a, radius_a, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_cone_heightfield_contact(
            iso_a, half_height_a, radius_a, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.RoundCylinder(half_height, radius, border_radius) =>
      match shape_b {
        @collision.HalfSpace(normal) =>
          @collision.compute_halfspace_contact(iso_b, normal, iso_a, shape_a)
          is Some(_)
        @collision.TriMesh(vertices, indices) =>
          @collision.compute_round_cylinder_trimesh_contact(
            iso_a, half_height, radius, border_radius, iso_b, vertices, indices,
          )
          is Some(_)
        @collision.Heightfield(points, _, nrows, ncols, _) =>
          @collision.compute_round_cylinder_heightfield_contact(
            iso_a, half_height, radius, border_radius, iso_b, points, nrows, ncols,
          )
          is Some(_)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.HalfSpace(normal) =>
      @collision.compute_halfspace_contact(iso_a, normal, iso_b, shape_b)
      is Some(_)
    @collision.TriMesh(_, _) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.Cuboid(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _)
        | @collision.RoundCylinder(_, _, _)
        | @collision.HalfSpace(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
        _ =>
          @collision.compute_convex_contact(iso_a, shape_a, iso_b, shape_b)
          is Some(_)
      }
    @collision.Heightfield(_, _, _, _, _) =>
      match shape_b {
        @collision.Ball(_)
        | @collision.Cuboid(_)
        | @collision.CapsuleY(_, _)
        | @collision.Cylinder(_, _)
        | @collision.Cone(_, _)
        | @collision.RoundCylinder(_, _, _)
        | @collision.HalfSpace(_) =>
          shapes_intersect(shape_b, iso_b, shape_a, iso_a)
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
fn current_world_transform(entity : @entity.Entity) -> @transform.Transform? {
  @transform.compute_global_transform(entity).map(global => {
    global.compute_transform()
  })
}

///|
fn set_entity_world_transform(
  entity : @entity.Entity,
  world_transform : @transform.Transform,
) -> Unit {
  let local_transform = match entity.get_parent() {
    Some(parent) =>
      match @transform.compute_global_transform(parent) {
        Some(parent_global) =>
          @transform.GlobalTransform::from_transform(world_transform).reparented_to(
            parent_global,
          )
        None => world_transform
      }
    None => world_transform
  }
  @transform.transforms().set(entity, local_transform)
}

///|
fn attached_rigid_body_entity(entity : @entity.Entity) -> @entity.Entity? {
  if rigid_bodies().contains(entity) {
    return Some(entity)
  }
  let mut current = entity.get_parent()
  while current is Some(parent) {
    if rigid_bodies().contains(parent) {
      return Some(parent)
    }
    current = parent.get_parent()
  }
  None
}

///|
fn collider_relative_transform(
  entity : @entity.Entity,
  body_entity : @entity.Entity,
) -> @transform.Transform {
  if entity == body_entity {
    return @transform.Transform::identity()
  }
  match
    (
      current_world_transform(entity),
      @transform.compute_global_transform(body_entity),
    ) {
    (Some(entity_world), Some(body_global)) =>
      @transform.GlobalTransform::from_transform(entity_world).reparented_to(
        body_global,
      )
    _ => @transform.transforms().get(entity).unwrap_or_default()
  }
}

///|
fn set_standalone_collider_position(
  collider : @collision.Collider3D,
  entity : @entity.Entity,
) -> Unit {
  match current_world_transform(entity) {
    Some(transform) =>
      collider.set_position(
        @core.Isometry3::new(
          transform.translation.to_rapier(),
          transform.rotation.to_rapier(),
        ),
      )
    None => ()
  }
}

///|
fn resolve_collider_entity(
  handle : @collision.ColliderHandle3D,
) -> @entity.Entity? {
  collider_entities_by_key().get(collider_key(handle))
}

///|
fn collider_key(handle : @collision.ColliderHandle3D) -> String {
  let (id, generation) = handle.into_raw_parts()
  "\{id}:\{generation}"
}
