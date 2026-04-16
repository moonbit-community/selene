///|
pub fn LockedAxes::lock_rotations() -> LockedAxes {
  {
    ..LockedAxes::default(),
    lock_rotation_x: true,
    lock_rotation_y: true,
    lock_rotation_z: true,
  }
}

///|
pub fn LockedAxes::lock_translations() -> LockedAxes {
  {
    ..LockedAxes::default(),
    lock_translation_x: true,
    lock_translation_y: true,
    lock_translation_z: true,
  }
}

///|
pub fn Dominance::new(group : Int) -> Dominance {
  Dominance(group)
}

///|
pub fn AdditionalMassProperties::mass(
  mass : Double,
) -> AdditionalMassProperties {
  Mass(mass)
}

///|
pub fn AdditionalMassProperties::mass_properties(
  props : @core.MassProperties3,
) -> AdditionalMassProperties {
  MassProperties(props)
}

///|
pub fn Collider::cuboid(half_extents : @math.Vec3) -> Collider {
  Cuboid(half_extents)
}

///|
pub fn Collider::ball(radius : Double) -> Collider {
  Ball(radius)
}

///|
pub fn Collider::capsule_x(half_height : Double, radius : Double) -> Collider {
  CapsuleX(half_height, radius)
}

///|
pub fn Collider::capsule_y(half_height : Double, radius : Double) -> Collider {
  CapsuleY(half_height, radius)
}

///|
pub fn Collider::capsule_z(half_height : Double, radius : Double) -> Collider {
  CapsuleZ(half_height, radius)
}

///|
pub fn Collider::cylinder(half_height : Double, radius : Double) -> Collider {
  Cylinder(half_height, radius)
}

///|
pub fn Collider::cone(half_height : Double, radius : Double) -> Collider {
  Cone(half_height, radius)
}

///|
pub fn Collider::round_cylinder(
  half_height : Double,
  radius : Double,
  border_radius : Double,
) -> Collider {
  RoundCylinder(half_height, radius, border_radius)
}

///|
pub fn Collider::halfspace(normal : @math.Vec3) -> Collider {
  Halfspace(normal)
}

///|
pub fn Collider::convex_hull(points : Array[@math.Vec3]) -> Collider {
  ConvexHull(points)
}

///|
pub fn Collider::trimesh(
  vertices : Array[@math.Vec3],
  indices : Array[(Int, Int, Int)],
) -> Collider {
  TriMesh(vertices, indices)
}

///|
pub fn Collider::heightfield(
  heights : Array[Double],
  nrows : Int,
  ncols : Int,
  scale : @math.Vec3,
) -> Collider {
  Heightfield(heights, nrows, ncols, scale)
}

///|
pub fn Friction::new(coefficient : Double) -> Friction {
  Friction(coefficient)
}

///|
pub fn Restitution::new(coefficient : Double) -> Restitution {
  Restitution(coefficient)
}

///|
pub fn CollisionGroups::new(
  memberships : Int,
  filters : Int,
) -> CollisionGroups {
  { memberships, filters }
}

///|
pub fn CollisionGroups::all() -> CollisionGroups {
  { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF }
}

///|
pub fn SolverGroups::new(memberships : Int, filters : Int) -> SolverGroups {
  { memberships, filters }
}

///|
pub fn SolverGroups::all() -> SolverGroups {
  { memberships: 0xFFFF_FFFF, filters: 0xFFFF_FFFF }
}

///|
pub fn ContactForceEventThreshold::default() -> ContactForceEventThreshold {
  ContactForceEventThreshold(1.0e30)
}

///|
pub fn ColliderMassProperties::density(
  density : Double,
) -> ColliderMassProperties {
  Density(density)
}

///|
pub fn QueryFilter::default() -> QueryFilter {
  {
    groups: None,
    exclude_entity: None,
    exclude_collider: None,
    exclude_rigid_body: None,
    exclude_sensors: false,
    exclude_solids: false,
    body_filter: All,
  }
}

///|
pub fn QueryFilter::all() -> QueryFilter {
  QueryFilter::default()
}

///|
pub fn QueryFilter::only_dynamic() -> QueryFilter {
  { ..QueryFilter::default(), body_filter: Dynamic }
}
