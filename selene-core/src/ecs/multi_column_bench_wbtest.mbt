///|
test "BENCH-ECS three to five component joins" (bench : @bench.T) {
  for stride in [1, 8] {
    let world = World()
    let a : ComponentStore[Int32] = ComponentStore(world)
    let b : ComponentStore[Int32] = ComponentStore(world)
    let c : ComponentStore[Int32] = ComponentStore(world)
    let d : ComponentStore[Int32] = ComponentStore(world)
    let e : ComponentStore[Int32] = ComponentStore(world)
    let pair = a.spawn_plan(world).combine(b.spawn_plan(world))
    let full = pair
      .combine(c.spawn_plan(world))
      .combine(d.spawn_plan(world))
      .combine(e.spawn_plan(world))
    // Split both matching and nonmatching rows among different archetypes.
    for group in 0..<8 {
      let tag : ComponentStore[Unit] = ComponentStore(world)
      let matching = full.combine(tag.spawn_plan(world))
      let partial = pair.combine(tag.spawn_plan(world))
      for index in 0..<1024 {
        let value = group * 1024 + index
        if index % stride == 0 {
          ignore(
            matching.spawn(
              (((((value, value + 1), value + 2), value + 3), value + 4), ()),
            ),
          )
        } else {
          ignore(partial.spawn(((value, value + 1), ())))
        }
      }
    }

    let two = Query2(a, b)
    let three = Query3(a, b, c)
    let four = Query4(a, b, c, d)
    let five = Query5(a, b, c, d, e)
    let point3 = () => {
      let mut sum = 0
      two.for_each((entity, a, b) => {
        guard c.get(entity) is Some(c) else { return }
        sum += a + b + c
      })
      sum
    }
    let point4 = () => {
      let mut sum = 0
      two.for_each((entity, a, b) => {
        guard c.get(entity) is Some(c) else { return }
        guard d.get(entity) is Some(d) else { return }
        sum += a + b + c + d
      })
      sum
    }
    let point5 = () => {
      let mut sum = 0
      two.for_each((entity, a, b) => {
        guard c.get(entity) is Some(c) else { return }
        guard d.get(entity) is Some(d) else { return }
        guard e.get(entity) is Some(e) else { return }
        sum += a + b + c + d + e
      })
      sum
    }
    let scan3 = () => {
      let mut sum = 0
      three.for_each((_, a, b, c) => sum += a + b + c)
      sum
    }
    let scan4 = () => {
      let mut sum = 0
      four.for_each((_, a, b, c, d) => sum += a + b + c + d)
      sum
    }
    let scan5 = () => {
      let mut sum = 0
      five.for_each((_, a, b, c, d, e) => sum += a + b + c + d + e)
      sum
    }

    for
      (columns, point, scan) in [
        (3, point3, scan3),
        (4, point4, scan4),
        (5, point5, scan5),
      ] {
      assert_eq(point(), scan())
      bench.bench(
        name="Query2+get/cols=\{columns}/stride=\{stride}",
        count=15,
        () => bench.keep(point()),
      )
      bench.bench(
        name="column-scan/cols=\{columns}/stride=\{stride}",
        count=15,
        () => bench.keep(scan()),
      )
    }
  }
}
