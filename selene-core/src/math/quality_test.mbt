///|
test "checked rotation constructors reject invalid data" {
  let infinite = 1.0 / 0.0
  assert_true(
    @math.Rotation3::try_from_axis_angle(@math.Vec3::zero(), 1.0) is None,
  )
  assert_true(
    @math.Rotation3::try_from_axis_angle(@math.Vec3::x_axis(), infinite) is None,
  )
  assert_true(@math.Rotation3::try_from_quat(Quat(0.0, 0.0, 0.0, 0.0)) is None)
  assert_true(
    @math.Rotation3::try_from_quat(Quat(infinite, 0.0, 0.0, 1.0)) is None,
  )
  assert_true(
    @math.Rotation3::try_from_basis(
      @math.Vec3::x_axis(),
      @math.Vec3::y_axis(),
      -@math.Vec3::z_axis(),
    )
    is None,
  )
  let rotation = @math.Rotation3::try_from_axis_angle(
    Vec3(0.0, 0.0, 1.0e-300),
    0.5,
  ).unwrap()
  assert_true((rotation.to_quat().length_squared() - 1.0).abs() < 1.0e-12)
}

///|
test "rotation interpolation has correct endpoints speed and antipodal handling" {
  let axis = @math.Vec3::z_axis()
  let start = @math.Rotation3::identity()
  for angle in [0.02, 2.0] {
    let end = @math.Rotation3::from_axis_angle(axis, angle)
    for alpha in [-1.0, 0.0, 0.25, 0.5, 1.0, 2.0] {
      let actual = start.slerp(end, alpha)
      let expected = @math.Rotation3::from_axis_angle(axis, angle * alpha)
      assert_true(
        actual
        .rotate_vec3(@math.Vec3::x_axis())
        .distance(expected.rotate_vec3(@math.Vec3::x_axis())) <
        1.0e-12,
      )
    }
    let q = end.to_quat()
    let negative = @math.Rotation3::try_from_quat(Quat(-q.x, -q.y, -q.z, -q.w)).unwrap()
    for alpha in [0.0, 0.25, 0.5, 1.0] {
      assert_true(
        end
        .slerp(negative, alpha)
        .rotate_vec3(@math.Vec3::x_axis())
        .distance(end.rotate_vec3(@math.Vec3::x_axis())) <
        1.0e-12,
      )
      assert_true(
        start
        .nlerp(negative, alpha)
        .rotate_vec3(@math.Vec3::x_axis())
        .distance(start.nlerp(end, alpha).rotate_vec3(@math.Vec3::x_axis())) <
        1.0e-12,
      )
    }
  }
  let beyond_half_turn = @math.Rotation3::from_axis_angle(axis, 4.0)
  let midpoint = start.slerp(beyond_half_turn, 0.5)
  let expected = @math.Rotation3::from_axis_angle(axis, 2.0 - 3.141592653589793)
  assert_true(
    midpoint
    .rotate_vec3(@math.Vec3::x_axis())
    .distance(expected.rotate_vec3(@math.Vec3::x_axis())) <
    1.0e-12,
  )
  let end = @math.Rotation3::from_axis_angle(axis, 2.0)
  for alpha in [-1.0e308, 1.0e308] {
    assert_true(
      (start.nlerp(end, alpha).to_quat().length_squared() - 1.0).abs() < 1.0e-12,
    )
    assert_true(
      (start.slerp(end, alpha).to_quat().length_squared() - 1.0).abs() < 1.0e-12,
    )
  }
}

///|
test "repeated rotation composition preserves unit length and its inverse" {
  let step = @math.Rotation3::from_axis_angle(Vec3(1.0, 2.0, 3.0), 0.01)
  let mut rotation = @math.Rotation3::identity()
  for _ in 0..<10000 {
    rotation = rotation * step
  }
  assert_true((rotation.to_quat().length_squared() - 1.0).abs() < 1.0e-12)
  let point = @math.Vec3(3.0, -5.0, 7.0)
  assert_true(
    rotation.inverse().rotate_vec3(rotation.rotate_vec3(point)).distance(point) <
    1.0e-12,
  )
}

///|
test "normal direction transforms preserve reflections and handle collapsed planes" {
  let normal = @math.Vec3(1.0, 1.0, 0.0)
  let expected = @math.Vec3(-1.0, 0.5, 0.0).normalize_or_zero()
  for scale in [1.0e-300, 2.0, 1.0e300] {
    let affine = @math.Affine3::from_scale_rotation_translation(
      Vec3(-scale, scale * 2.0, scale * 3.0),
      @math.Rotation3::identity(),
      @math.Vec3::zero(),
    )
    let transform = affine.normal_transform()
    assert_eq(transform.handedness(), -1.0)
    assert_true(
      transform.transform_normal(normal).unwrap().distance(expected) < 1.0e-12,
    )
  }
  let collapsed = @math.Affine3::from_scale_rotation_translation(
    Vec3(1.0, 1.0, 0.0),
    @math.Rotation3::identity(),
    @math.Vec3::zero(),
  ).normal_transform()
  assert_eq(
    collapsed.transform_normal(@math.Vec3::z_axis()),
    Some(@math.Vec3::z_axis()),
  )
  assert_true(collapsed.transform_normal(@math.Vec3::x_axis()) is None)
  assert_true(collapsed.transform_normal(@math.Vec3::zero()) is None)
}

///|
test "vector interpolation and squared distance agree in both dimensions" {
  assert_eq(@math.Vec2(1.0, 2.0).distance_squared(Vec2(4.0, 6.0)), 25.0)
  assert_eq(
    @math.Vec3(1.0, 2.0, 3.0).distance_squared(Vec3(4.0, 6.0, 15.0)),
    169.0,
  )
  assert_eq(@math.Vec2(2.0, 4.0).lerp(Vec2(6.0, 8.0), 0.25), Vec2(3.0, 5.0))
  assert_eq(
    @math.Vec3(2.0, 4.0, 6.0).lerp(Vec3(6.0, 8.0, 10.0), 0.25),
    Vec3(3.0, 5.0, 7.0),
  )
}

///|
test "matrix multiplication matches affine composition and rejects invalid conversion" {
  let rotation = @math.Rotation3::from_axis_angle(@math.Vec3::z_axis(), 0.7)
  let parent = @math.Affine3::from_scale_rotation_translation(
    Vec3(2.0, 3.0, 1.0),
    rotation,
    Vec3(4.0, 5.0, 6.0),
  )
  let child = @math.Affine3::from_scale_rotation_translation(
    @math.Vec3::one(),
    rotation,
    Vec3(1.0, 2.0, 3.0),
  )
  let matrix = @math.Mat4::from_affine(parent) * @math.Mat4::from_affine(child)
  let point = @math.Vec3(7.0, 8.0, 9.0)
  assert_true(
    matrix
    .try_to_affine()
    .unwrap()
    .transform_point(point)
    .distance((parent * child).transform_point(point)) <
    1.0e-12,
  )
  assert_true(@math.Mat4::{ ..matrix, m00: 0.0 / 0.0, }.try_to_affine() is None)
  assert_true(
    @math.Mat4::perspective_rh_zo(1.0, 1.0, 0.1, 100.0).try_to_affine() is None,
  )
}
