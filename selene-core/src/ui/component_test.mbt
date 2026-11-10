///|
test "typed UI components share the named store in each World" {
  let first = @ecs.World()
  let second = @ecs.World()
  let nodes : @ecs.ComponentStore[@ui.Node] = @ecs.components_in(first)
  let other_nodes : @ecs.ComponentStore[@ui.Node] = @ecs.components_in(second)
  let entity = nodes.spawn_plan(first).spawn(Node())
  let found_by_accessor = Ref(false)

  @ecs.run_schedule(first, _ => {
    found_by_accessor.val = @ui.nodes().contains(entity)
    ignore(entity.delete())
  })

  assert_true(found_by_accessor.val)
  assert_false(nodes.contains(entity))
  assert_eq(other_nodes.length(), 0)
}
