///|
test "component keys keep same-type columns and World stores separate" {
  let first = @ecs.World()
  let second = @ecs.World()
  let x : @entity.ComponentKey[Int32] = ComponentKey()
  let y : @entity.ComponentKey[Int32] = ComponentKey()
  let store = x.store_in(first)
  let entity = store.spawn_bundle().spawn(first, 42)
  assert_eq(x.store_in(first).get(entity), Some(42))
  assert_eq(y.store_in(first).get(entity), None)
  assert_true(x.store_in(second).belongs_to(second))
  assert_eq(x.store_in(second).get(entity), None)
}
