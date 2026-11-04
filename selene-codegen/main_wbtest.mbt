///|
test "generates typed keys only for marked declarations" {
  let source =
    #|#selene.component
    #|pub(all) struct Position { x : Double }
    #|
    #|#selene.resource(new_clock)
    #|priv struct Clock { mut tick : Int }
    #|
    #|// #selene.component
    #|priv struct Unmarked { x : Double }
  let generated = generate(source, "state.mbt")
  assert_true(generated.contains("@entity.ComponentKey[Position]"))
  assert_true(generated.contains("pub impl @entity.Component for Position"))
  assert_true(
    generated.contains("@ecs.ResourceKey[Clock] = ResourceKey(new_clock)"),
  )
  assert_false(generated.contains("pub impl @ecs.Resource for Clock"))
  assert_false(generated.contains("Unmarked"))
}

///|
test "rejects a resource marker without an initializer" {
  let result = try {
    ignore(generate("#selene.resource\npriv struct Clock {}", "state.mbt"))
    false
  } catch {
    InvalidInput(_) => true
  }
  assert_true(result)
}
