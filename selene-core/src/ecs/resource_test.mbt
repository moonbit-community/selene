///|
test "resource initializers receive the requested World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let key = @ecs.ResourceKey(world => Ref(world.id()))
  assert_eq(key.get_in(first).val, first.id())
  assert_eq(key.get_in(second).val, second.id())
  key.get_in(first).val = 0U
  assert_eq(key.get_in(first).val, 0U)
  assert_eq(key.get_in(second).val, second.id())
}
