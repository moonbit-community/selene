///|
test "vector normalization handles extreme magnitudes and rejects nonfinite input" {
  assert_eq(Vec2(0.0, 1.0e-300).try_normalize(), Some(Vec2(0.0, 1.0)))
  assert_eq(Vec3(1.0e300, 0.0, 0.0).try_normalize(), Some(Vec3::x_axis()))
  assert_true(Vec3::zero().try_normalize() is None)
  assert_true(Vec2(1.0 / 0.0, 0.0).try_normalize() is None)
}

///|
test "unit rotations reject invalid quaternions and normalize finite inputs" {
  assert_true(Rotation3::from_quat(Quat(0.0, 0.0, 0.0, 0.0)) is None)
  let rotation = Rotation3::from_quat(Quat(0.0, 0.0, 1.0e300, 0.0)).unwrap()
  assert_eq(rotation.rotate_vec3(Vec3::x_axis()), -Vec3::x_axis())
  assert_eq(
    (rotation * rotation.inverse()).rotate_vec3(Vec3::y_axis()),
    Vec3::y_axis(),
  )
}

///|
test "small affine bases invert and preserve reflected normals" {
  let affine : Affine3 = {
    x_axis: Vec3(-1.0e-20, 0.0, 0.0),
    y_axis: Vec3(5.0e-21, 1.0e-20, 0.0),
    z_axis: Vec3(0.0, 0.0, 1.0e-20),
    translation: Vec3(3.0e-20, 4.0e-20, 5.0e-20),
  }
  let point = Vec3(2.0, -3.0, 7.0)
  let inverse = affine.inverse().unwrap()
  assert_true(
    inverse.transform_point3(affine.transform_point3(point)).distance(point) <
    1.0e-12,
  )
  let (normal_matrix, sign) = affine.normal_matrix()
  let normal = normal_matrix.transform_vector3(Vec3::x_axis())
  assert_eq(sign, -1.0)
  assert_true(normal.x < 0.0)
  assert_true(normal.dot(affine.y_axis).abs() < 1.0e-30)
  assert_true({ ..affine, z_axis: Vec3::zero(), }.inverse() is None)
}

///|
test "projection maps near and far planes to WebGPU depth bounds" {
  let eye = Vec3(0.0, 0.0, 10.0)
  let view = Mat4::look_at_rh(eye, Vec3::zero(), Vec3::y_axis())
  for
    projection in [
      Mat4::perspective_rh_zo(1.0, 1.5, 0.5, 20.0),
      Mat4::orthographic_rh_zo(4.0, 6.0, 0.5, 20.0),
    ] {
    let view_projection = projection.mul(view)
    assert_eq(
      Mat4::from_column_major(view_projection.to_column_major()[:]),
      Some(view_projection),
    )
    assert_true(
      view_projection.project_point(Vec3(0.0, 0.0, 9.5)).unwrap().z.abs() <
      1.0e-12,
    )
    assert_true(
      (view_projection.project_point(Vec3(0.0, 0.0, -10.0)).unwrap().z - 1.0).abs() <
      1.0e-12,
    )
  }
}
