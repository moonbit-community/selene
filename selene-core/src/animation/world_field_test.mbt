///|
test "shared animation fields use the execution World rather than the registration World" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let first = @ecs.World()
  let second = @ecs.World()
  let a = first.spawn1(
    @transform.Spatial(@transform.Transform::from_xyz(1.0, 0.0, 0.0)),
  )
  let b = second.spawn1(
    @transform.Spatial(@transform.Transform::from_xyz(2.0, 0.0, 0.0)),
  )
  @ecs.set_current_world(first)
  let handle = @animation.transform_translation_field()
  @ecs.set_current_world(second)
  assert_eq(handle, @animation.transform_translation_field())
  let field = @animation.animated_field(handle).unwrap()
  (field.apply)(first, a, Vec3(Vec3(3.0, 0.0, 0.0)))
  (field.apply)(second, b, Vec3(Vec3(4.0, 0.0, 0.0)))
  // A foreign handle must not update another World's same-numbered entity.
  (field.apply)(second, a, Vec3(Vec3(99.0, 0.0, 0.0)))
  assert_eq(
    @transform.local_transform(world=first, a).unwrap().translation.x,
    3.0,
  )
  assert_eq(
    @transform.local_transform(world=second, b).unwrap().translation.x,
    4.0,
  )
  guard (field.sample)(first, a) is Vec3(value) else {
    fail("expected a translation")
  }
  assert_eq(value.x, 3.0)
}
