///|
test "typed UI queries stay bound to their explicit World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let nodes : @ecs.Query[@ecs.Single[@ui.Node]] = first.query()
  let other_nodes : @ecs.Query[@ecs.Single[@ui.Node]] = second.query()
  let entity = @ecs_runtime.spawn1(first, @ui.Node())
  let found_by_accessor = Ref(false)

  @ecs_runtime.run_schedule(first, world => {
    found_by_accessor.val = (world.query() : @ecs.Query[@ecs.Single[@ui.Node]]).contains(
      entity,
    )
    ignore(@ecs_runtime.delete(entity))
  })

  assert_true(found_by_accessor.val)
  assert_false(nodes.contains(entity))
  assert_eq(other_nodes.length(), 0)
}
