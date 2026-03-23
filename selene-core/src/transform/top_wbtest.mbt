///|
fn transform_test_translation(entity : @entity.Entity) -> String {
  let transform = transforms().get(entity).unwrap_or_default()
  let translation = transform.translation
  "\{translation.x.to_int()},\{translation.y.to_int()},\{translation.z.to_int()}"
}

///|
fn transform_test_global_translation(entity : @entity.Entity) -> String {
  let translation = global_transforms()
    .get(entity)
    .unwrap_or_default()
    .translation()
  "\{translation.x.to_int()},\{translation.y.to_int()},\{translation.z.to_int()}"
}

///|
test "compute_global_transform follows parent hierarchy" {
  let parent = @entity.Entity::new()
  let child = parent.spawn_child()
  defer parent.destroy()
  defer child.destroy()

  transforms().set(parent, Transform::from_xyz(10.0, 0.0, 0.0))
  transforms().set(child, Transform::from_xyz(2.0, 0.0, 0.0))

  let child_global = compute_global_transform(child).unwrap()
  let translation = child_global.translation()
  inspect(translation.x == 12.0, content="true")
  inspect(translation.y == 0.0, content="true")
  inspect(translation.z == 0.0, content="true")
}

///|
test "set_parent_in_place preserves global transform" {
  let parent_a = @entity.Entity::new()
  let parent_b = @entity.Entity::new()
  defer parent_a.destroy()
  defer parent_b.destroy()

  transforms().set(parent_a, Transform::from_xyz(10.0, 0.0, 0.0))
  transforms().set(parent_b, Transform::from_xyz(100.0, 0.0, 0.0))

  let child = parent_a.spawn_child()
  defer child.destroy()
  transforms().set(child, Transform::from_xyz(2.0, 0.0, 0.0))
  transform_propagate_system(0.0)

  set_parent_in_place(child, parent_b)
  transform_propagate_system(0.0)

  inspect(child.get_parent() == Some(parent_b), content="true")
  inspect(transform_test_translation(child), content="-88,0,0")
  inspect(transform_test_global_translation(child), content="12,0,0")
}

///|
test "remove_parent_in_place preserves global transform" {
  let parent = @entity.Entity::new()
  defer parent.destroy()
  transforms().set(parent, Transform::from_xyz(10.0, 0.0, 0.0))

  let child = parent.spawn_child()
  defer child.destroy()
  transforms().set(child, Transform::from_xyz(2.0, 0.0, 0.0))
  transform_propagate_system(0.0)

  remove_parent_in_place(child)
  transform_propagate_system(0.0)

  inspect(child.get_parent(), content="None")
  inspect(transform_test_translation(child), content="12,0,0")
  inspect(transform_test_global_translation(child), content="12,0,0")
}
