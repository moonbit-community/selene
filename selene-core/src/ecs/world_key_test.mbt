///|
test "typed keys initialize independently in each world and exceed 64 slots" {
  let first = @ecs.World()
  let second = @ecs.World()
  let keys = [ for i in 0..<80 => @ecs.WorldKey(() => Ref(i)) ]
  let label = @ecs.WorldKey(() => "world")
  for i, key in keys {
    let value = first.get_or_init(key)
    assert_eq(value.val, i)
    value.val += 100
    assert_eq(second.get_or_init(key).val, i)
  }
  assert_eq(first.get_or_init(label), "world")
  for i, key in keys {
    assert_eq(first.get_or_init(key).val, i + 100)
    assert_eq(second.get_or_init(key).val, i)
  }
}
