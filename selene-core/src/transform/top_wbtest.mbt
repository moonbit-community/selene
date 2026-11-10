///|
test "spatial propagation passes through nonspatial parents" {
  let world = @ecs.require_current_world()
  let parent = world.spawn1(Spatial(Transform::from_xyz(10.0, 0.0, 0.0)))
  let container = world.spawn((), parent~)
  let child = world.spawn1(
    Spatial(Transform::from_xyz(2.0, 0.0, 0.0)),
    parent=container,
  )
  defer ignore(parent.delete())

  let child_global = compute_global_transform(child).unwrap()
  assert_eq(child_global.translation().x, 12.0)
  transform_propagate_system(0.0)
  assert_eq(global_transform(child).unwrap().translation().x, 12.0)
  assert_true(global_transform(container) is None)
}

///|
test "spatial propagation replaces the cached pose across despawn and respawn" {
  let world = @ecs.require_current_world()
  let entity = world.spawn1(Spatial(Transform::from_xyz(1.0, 0.0, 0.0)))
  defer ignore(entity.delete())
  transform_propagate_system(0.0)
  assert_eq(global_transform(entity).unwrap().translation().x, 1.0)
  set_local_transform(entity, Transform::from_xyz(2.0, 0.0, 0.0))
  transform_propagate_system(0.0)
  assert_eq(global_transform(entity).unwrap().translation().x, 2.0)
  entity.destroy()
  try! @ecs.run_schedule(world, _ => ())
  assert_true(global_transform(entity) is None)
  entity.respawn()
  try! @ecs.run_schedule(world, _ => ())
  transform_propagate_system(0.0)
  assert_eq(global_transform(entity).unwrap().translation().x, 2.0)
}
