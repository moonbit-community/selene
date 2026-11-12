///|
test "typed UI queries stay bound to their explicit World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let nodes : @ecs.Query[@ui.Node] = first.query()
  let other_nodes : @ecs.Query[@ui.Node] = second.query()
  let entity = first.spawn1(@ui.Node())
  let found_by_accessor = Ref(false)

  @ecs.run_schedule(first, world => {
    found_by_accessor.val = (world.query() : @ecs.Query[@ui.Node]).contains(
      entity,
    )
    ignore(entity.delete())
  })

  assert_true(found_by_accessor.val)
  assert_false(nodes.contains(entity))
  assert_eq(other_nodes.length(), 0)
}
