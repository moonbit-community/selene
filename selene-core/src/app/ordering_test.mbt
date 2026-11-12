///|
test "system sets order an application stage independently of registration order" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  let first = @ecs.SystemSet("first")
  let middle = @ecs.SystemSet("middle")
  let last = @ecs.SystemSet("last")
  let calls = []
  @app.App()
  .with_world(world)
  .add_system(Update, fn(_ : Unit) { calls.push(3) }, in_set=last)
  .add_system(
    Update,
    fn(_ : Unit) { calls.push(2) },
    in_set=middle,
    before=[last],
    after=[first],
  )
  .add_system(Update, fn(_ : Unit) { calls.push(1) }, in_set=first)
  .run_frames(1, raw_delta=0.125, fixed_delta_override=Some(1.0))
  assert_eq(calls, [1, 2, 3])
}
