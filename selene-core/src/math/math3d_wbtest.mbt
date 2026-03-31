///|
fn approx(a : Double, b : Double, eps? : Double = 0.000001) -> Bool {
  let diff = a - b
  diff < eps && diff > -eps
}

///|
test "quat identity converts to rapier xyzw layout" {
  let rapier = Quat::identity().to_rapier()
  inspect(approx(rapier.x.to_double(), 0.0), content="true")
  inspect(approx(rapier.y.to_double(), 0.0), content="true")
  inspect(approx(rapier.z.to_double(), 0.0), content="true")
  inspect(approx(rapier.w.to_double(), 1.0), content="true")
}

///|
test "quat rapier roundtrip preserves components" {
  let source = Quat::from_axis_angle(Vec3::new(0.0, 1.0, 0.0), 0.7).normalize()
  let roundtrip = quat_from_rapier(source.to_rapier()).normalize()
  inspect(approx(source.x, roundtrip.x), content="true")
  inspect(approx(source.y, roundtrip.y), content="true")
  inspect(approx(source.z, roundtrip.z), content="true")
  inspect(approx(source.w, roundtrip.w), content="true")
}
