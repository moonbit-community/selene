///|
fn[A, B] update_rows_for_bench(
  query : Query2[A, B],
  update : (A, B) -> A,
) -> Unit {
  query.plan.for_each_table((entities, columns) => {
    let (a, b) = columns
    for row in 0..<entities.length() {
      a[row] = update(a[row], b[row])
    }
  })
}

///|
test "archetype batch reads and writes" (bench : @bench.T) {
  for size in [1000, 10000] {
    let world = World()
    let a : ComponentStore[Int32] = ComponentStore(world)
    let b : ComponentStore[Int32] = ComponentStore(world)
    let tag : ComponentStore[Unit] = ComponentStore(world)
    let first = world.spawn(())
    a.set(first, 0)
    b.set(first, 1)
    for i in 1..<size {
      let entity = world.spawn(())
      a.set(entity, i)
      if i % 4 != 0 {
        b.set(entity, i + 1)
        if i % 2 == 0 {
          tag.set(entity, ())
        }
      }
    }
    let query = Query2(a, b)
    let read_rows = () => {
      let mut sum = 0
      query.for_each((_, x, y) => sum += x + y)
      sum
    }
    let read_batches = () => {
      let mut sum = 0
      query.for_each_batch((entities, x, y) => {
        for row in 0..<entities.length() {
          sum += x[row] + y[row]
        }
      })
      sum
    }
    let write_rows = () => update_rows_for_bench(query, (_, y) => y + 1)
    let write_batches = () => {
      query.for_each_batch_mut_a((entities, x, y) => {
        for row in 0..<entities.length() {
          x[row] = y[row] + 1
        }
      })
    }
    assert_eq(read_rows(), read_batches())
    write_rows()
    let written = read_rows()
    update_rows_for_bench(query, (_, y) => y - 1)
    write_batches()
    assert_eq(read_batches(), written)
    bench.bench(name="archetype-read/row/n=\{size}", count=10, () => {
      bench.keep(read_rows())
    })
    bench.bench(name="archetype-read/batch/n=\{size}", count=10, () => {
      bench.keep(read_batches())
    })
    bench.bench(name="archetype-write/row/n=\{size}", count=10, () => {
      write_rows()
      bench.keep(a.get(first))
    })
    bench.bench(name="archetype-write/batch/n=\{size}", count=10, () => {
      write_batches()
      bench.keep(a.get(first))
    })
  }
}
