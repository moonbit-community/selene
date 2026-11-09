///|
struct Score {
  mut value : Int32
}

///|
let score_key : @ecs.ResourceKey[Score] = ResourceKey()

///|
impl @ecs.Resource for Score with fn resource_key() {
  score_key
}

///|
test "resources require insertion and replacement is isolated to one World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let missing : Score? = first.get_resource()
  assert_true(missing is None)

  let original : Score = { value: 10, }
  first.insert_resource(original)
  second.insert_resource(Score::{ value: 20, })
  let first_score : Score = first.resource()
  first_score.value += 1
  assert_eq(original.value, 11)
  let second_score : Score = second.resource()
  assert_eq(second_score.value, 20)

  first.insert_resource(Score::{ value: 30, })
  let replacement : Score = first.resource()
  assert_eq(replacement.value, 30)
  assert_eq(first_score.value, 11)
  assert_eq(second_score.value, 20)
}

///|
test "explicit resource initializers run only for missing World values" {
  let first = @ecs.World()
  let second = @ecs.World()
  let calls = Ref(0)
  let key : @ecs.ResourceKey[Ref[UInt32]] = ResourceKey()
  let create = (world : @ecs.World) => {
    calls.val += 1
    Ref(world.id())
  }
  assert_true(key.get_in(first) is None)
  assert_eq(calls.val, 0)
  assert_eq(key.get_or_insert_with(first, create).val, first.id())
  key.get_or_insert_with(first, create).val = 0U
  assert_eq(key.get_or_insert_with(first, create).val, 0U)
  assert_eq(key.get_or_insert_with(second, create).val, second.id())
  assert_eq(calls.val, 2)
}

///|
test "resource keys of the same type keep distinct values" {
  let world = @ecs.World()
  let first : @ecs.ResourceKey[Int32] = ResourceKey()
  let second : @ecs.ResourceKey[Int32] = ResourceKey()
  first.insert_in(world, 1)
  second.insert_in(world, 2)
  assert_eq(first.get_in(world), Some(1))
  assert_eq(second.get_in(world), Some(2))
}

///|
test "panic reading a required resource before insertion fails" {
  let world = @ecs.World()
  let value : Score = world.resource()
  ignore(value)
}
