///|
test "typed UI queries stay bound to their explicit World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let nodes : @ecs.Query[@ecs.Single[@ui.Node]] = first.query()
  let other_nodes : @ecs.Query[@ecs.Single[@ui.Node]] = second.query()
  let entity = @ecs_test.spawn1(first, @ui.Node())
  let found_by_accessor = Ref(false)

  @ecs.Schedule()
  .add_exclusive_system(world => {
    found_by_accessor.val = (world.query() : @ecs.Query[@ecs.Single[@ui.Node]]).contains(
      entity,
    )
    @ecs.commands(@ecs.require_current_world()).delete(entity)
  })
  .run(first)

  assert_true(found_by_accessor.val)
  assert_false(nodes.contains(entity))
  assert_eq(other_nodes.length(), 0)
}
