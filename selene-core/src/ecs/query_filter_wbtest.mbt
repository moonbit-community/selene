///|
test "structural filters run once per archetype rather than once per row" {
  let world = World()
  let a : ComponentStore[Int32] = ComponentStore(world)
  let b : ComponentStore[String] = ComponentStore(world)
  let single = a.spawn_plan(world)
  let pair = single.combine(b.spawn_plan(world))
  let entity = pair.spawn((1, "first"))
  for i in 0..<100 {
    ignore(single.spawn(i))
  }
  let matched = Ref(0)
  let base = make_query1(a)
  let query = base.with_filters([
    {
      world_id: world.id(),
      accepts: id => {
        matched.val += 1
        b.column(id) is Some(_)
      },
    },
  ])
  assert_eq(query.length(), 1)
  let scanned = matched.val
  assert_eq(scanned, 2)
  for _ in 0..<3 {
    query.for_each((_, _) => ())
    assert_true(query.get(entity) is Some(_))
  }
  assert_eq(matched.val, scanned)
  let tag : ComponentStore[Unit] = ComponentStore(world)
  ignore(pair.combine(tag.spawn_plan(world)).spawn(((2, "new"), ())))
  assert_eq(query.length(), 2)
  assert_eq(matched.val, scanned + 1)
}
