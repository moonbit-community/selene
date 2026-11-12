///|
test "spatial propagation passes through nonspatial parents" {
  let world = @ecs.require_current_world()
  let parent = @ecs_test.spawn1(
    world,
    Spatial(Transform::from_xyz(10.0, 0.0, 0.0)),
  )
  let container = @ecs_test.spawn(world, (), parent~)
  let child = @ecs_test.spawn1(
    world,
    Spatial(Transform::from_xyz(2.0, 0.0, 0.0)),
    parent=container,
  )
  defer ignore(@ecs_test.delete(parent))

  let child_global = compute_global_transform(world~, child).unwrap()
  assert_eq(child_global.translation().x, 12.0)
  transform_propagate_system(world~, 0.0)
  assert_eq(global_transform(world~, child).unwrap().translation().x, 12.0)
  assert_true(global_transform(world~, container) is None)
}

///|
test "spatial propagation replaces the cached pose across despawn and respawn" {
  let world = @ecs.require_current_world()
  let entity = @ecs_test.spawn1(
    world,
    Spatial(Transform::from_xyz(1.0, 0.0, 0.0)),
  )
  defer ignore(@ecs_test.delete(entity))
  transform_propagate_system(world~, 0.0)
  assert_eq(global_transform(world~, entity).unwrap().translation().x, 1.0)
  set_local_transform(world~, entity, Transform::from_xyz(2.0, 0.0, 0.0))
  transform_propagate_system(world~, 0.0)
  assert_eq(global_transform(world~, entity).unwrap().translation().x, 2.0)
  @ecs_test.destroy(entity)
  try! @ecs.Schedule().run(world)
  assert_true(global_transform(world~, entity) is None)
  @ecs.commands(@ecs.require_current_world()).respawn(entity)
  try! @ecs.Schedule().run(world)
  transform_propagate_system(world~, 0.0)
  assert_eq(global_transform(world~, entity).unwrap().translation().x, 2.0)
}

///|
test "world TRS decomposition rejects shear and round-trips reflections" {
  let parent = Transform::from_scale(Vec3(2.0, 1.0, 1.0)).compute_affine()
  let rotated = Transform::from_rotation(
    @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), 0.4),
  )
  let shear : GlobalTransform = { affine: parent * rotated.compute_affine(), }
  assert_true(shear.try_decompose_trs() is None)
  let reflected = GlobalTransform::from_transform(
    rotated
    .with_scale(Vec3(-2.0, 3.0, 1.0))
    .with_translation(Vec3(5.0, 3.0, -2.0)),
  )
  let recovered = reflected.try_decompose_trs().unwrap().compute_affine()
  let point = @math.Vec3(3.0, 1.0, 4.0)
  assert_true(
    recovered.transform_point(point).distance(reflected.transform_point(point)) <
    1.0e-12,
  )
  let singular = GlobalTransform::from_transform(
    Transform::from_scale(Vec3(0.0, 1.0, 1.0)),
  )
  assert_eq(
    singular.try_decompose_trs().unwrap().compute_affine(),
    singular.affine,
  )
}

///|
test "TRS decomposition reconstructs reflected and collapsed rotation bases" {
  for index in 0..<32 {
    let rotation = @math.Rotation3::from_axis_angle(
      Vec3(1.0, 2.0, 3.0),
      index.to_double() * 0.2,
    )
    for mask in 0..<8 {
      let scale = @math.Vec3(
        if (mask & 1) == 0 {
          -2.0
        } else {
          0.0
        },
        if (mask & 2) == 0 {
          3.0
        } else {
          0.0
        },
        if (mask & 4) == 0 {
          -4.0
        } else {
          0.0
        },
      )
      let expected = Transform::from_rotation(rotation)
        .with_scale(scale)
        .with_translation(Vec3(5.0, 6.0, 7.0))
        .compute_affine()
      let actual = GlobalTransform::{ affine: expected, }
        .try_decompose_trs()
        .unwrap()
        .compute_affine()
      assert_true(actual.x_axis.distance(expected.x_axis) < 1.0e-12)
      assert_true(actual.y_axis.distance(expected.y_axis) < 1.0e-12)
      assert_true(actual.z_axis.distance(expected.z_axis) < 1.0e-12)
      assert_eq(actual.translation, expected.translation)
    }
  }
}
