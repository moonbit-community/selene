///|
fn rotation_bridge_approx(
  a : Double,
  b : Double,
  eps~ : Double = 0.000001,
) -> Bool {
  let diff = a - b
  diff < eps && diff > -eps
}

///|
test "quat identity converts to rapier xyzw layout" {
  let rapier = rotation_to_rapier(@math.Rotation3::identity())
  inspect(rotation_bridge_approx(rapier.x.to_double(), 0.0), content="true")
  inspect(rotation_bridge_approx(rapier.y.to_double(), 0.0), content="true")
  inspect(rotation_bridge_approx(rapier.z.to_double(), 0.0), content="true")
  inspect(rotation_bridge_approx(rapier.w.to_double(), 1.0), content="true")
}

///|
test "quat rapier roundtrip preserves components" {
  let source = @math.Rotation3::from_axis_angle(Vec3(0.0, 1.0, 0.0), 0.7)
  let roundtrip = rotation_from_rapier(rotation_to_rapier(source)).to_quat()
  let source = source.to_quat()
  inspect(rotation_bridge_approx(source.x, roundtrip.x), content="true")
  inspect(rotation_bridge_approx(source.y, roundtrip.y), content="true")
  inspect(rotation_bridge_approx(source.z, roundtrip.z), content="true")
  inspect(rotation_bridge_approx(source.w, roundtrip.w), content="true")
}
