///|
test "affine point batch" (b : @bench.T) {
  let points = Array::makei(4096, i => {
    @math.Vec3(
      i.to_double() * 0.13,
      (i % 127).to_double(),
      -(i % 97).to_double(),
    )
  })
  let transforms = Array::makei(32, i => @math.Affine3::{
    x_axis: Vec3(1.0 + i.to_double() * 0.01, 0.1, 0.2),
    y_axis: Vec3(0.7, 2.0, -0.4),
    z_axis: Vec3(-0.3, 0.6, 0.7),
    translation: Vec3(11.0, 13.0, 17.0),
  })
  b.bench(name="affine/4096", () => {
    let mut sum = 0.0
    for i in 0..<points.length() {
      let result = transforms[i % transforms.length()].transform_point(
        points[i],
      )
      sum += result.x + result.y + result.z
    }
    b.keep(sum)
  })
}

///|
test "unit rotation composition batch" (b : @bench.T) {
  let values = Array::makei(4096, i => {
    @math.Rotation3::from_axis_angle(Vec3(1.0, 2.0, 3.0), i.to_double() * 0.001)
  })
  let rhs = @math.Rotation3::from_axis_angle(@math.Vec3::y_axis(), 0.7)
  b.bench(name="rotation/4096", () => {
    let mut sum = 0.0
    for lhs in values {
      let q = (lhs * rhs).to_quat()
      sum += q.x + q.y + q.z + q.w
    }
    b.keep(sum)
  })
}
