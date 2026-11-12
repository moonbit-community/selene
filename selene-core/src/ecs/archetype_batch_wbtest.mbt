///|
fn[A, B] update_rows_for_bench(
  query : Query[(A, B)],
  update : (A, B) -> A,
) -> Unit {
  query.for_each_batch(batch => {
    for row in 0..<batch.length() {
      let (a, b) = batch.get(row)
      batch.set(row, (update(a, b), b))
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
    let single = a.spawn_plan(world)
    let pair = single.combine(b.spawn_plan(world))
    let tagged = pair.combine(tag.spawn_plan(world))
    let first = pair.spawn((0, 1))
    for i in 1..<size {
      if i % 4 == 0 {
        ignore(single.spawn(i))
      } else if i % 2 == 0 {
        ignore(tagged.spawn(((i, i + 1), ())))
      } else {
        ignore(pair.spawn((i, i + 1)))
      }
    }
    let query = make_query2(a, b)
    let read_rows = () => {
      let mut sum = 0
      query.for_each((_, query_row) => {
        let (x, y) = query_row
        sum += x + y
      })
      sum
    }
    let read_batches = () => {
      let mut sum = 0
      query.for_each_batch(batch => {
        for row in 0..<batch.length() {
          let (x, y) = batch.get(row)
          sum += x + y
        }
      })
      sum
    }
    let write_rows = () => update_rows_for_bench(query, (_, y) => y + 1)
    let write_batches = () => {
      query.for_each_batch(batch => {
        for row in 0..<batch.length() {
          let (_, y) = batch.get(row)
          batch.set(row, (y + 1, y))
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
