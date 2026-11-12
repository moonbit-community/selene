///|
priv struct QueryBenchA(Int32)

///|
let query_bench_a : ComponentKey[QueryBenchA] = ComponentKey()

///|
impl Component for QueryBenchA with fn component_key() {
  query_bench_a
}

///|
priv struct QueryBenchB(Int32)

///|
let query_bench_b : ComponentKey[QueryBenchB] = ComponentKey()

///|
impl Component for QueryBenchB with fn component_key() {
  query_bench_b
}

///|
priv struct QueryBenchC(Int32)

///|
let query_bench_c : ComponentKey[QueryBenchC] = ComponentKey()

///|
impl Component for QueryBenchC with fn component_key() {
  query_bench_c
}

///|
priv struct QueryBenchD(Int32)

///|
let query_bench_d : ComponentKey[QueryBenchD] = ComponentKey()

///|
impl Component for QueryBenchD with fn component_key() {
  query_bench_d
}

///|
priv struct QueryBenchE(Int32)

///|
let query_bench_e : ComponentKey[QueryBenchE] = ComponentKey()

///|
impl Component for QueryBenchE with fn component_key() {
  query_bench_e
}

///|
test "unified query row and typed column traversal" (bench : @bench.T) {
  for stride in [1, 8] {
    let world = World()
    let a : ComponentStore[QueryBenchA] = components_in(world)
    let b : ComponentStore[QueryBenchB] = components_in(world)
    let c : ComponentStore[QueryBenchC] = components_in(world)
    let d : ComponentStore[QueryBenchD] = components_in(world)
    let e : ComponentStore[QueryBenchE] = components_in(world)
    let base : SpawnPlan[
      (QueryBenchA, QueryBenchB, QueryBenchC, QueryBenchD, QueryBenchE),
    ] = commands(world).prepare_spawn()
    let partial = a.spawn_plan(world).combine(b.spawn_plan(world))
    for group in 0..<8 {
      let tag : ComponentStore[Unit] = ComponentStore(world)
      let full = base.combine(tag.spawn_plan(world))
      let sparse = partial.combine(tag.spawn_plan(world))
      for index in 0..<1024 {
        let value = group * 1024 + index
        if index % stride == 0 {
          ignore(
            full.spawn(
              (
                (
                  QueryBenchA(value),
                  QueryBenchB(value + 1),
                  QueryBenchC(value + 2),
                  QueryBenchD(value + 3),
                  QueryBenchE(value + 4),
                ),
                (),
              ),
            ),
          )
        } else {
          ignore(
            sparse.spawn(((QueryBenchA(value), QueryBenchB(value + 1)), ())),
          )
        }
      }
    }
    let query : Query[
      (QueryBenchA, QueryBenchB, QueryBenchC, QueryBenchD, QueryBenchE),
    ] = world.query()
    let read_rows = () => {
      let mut sum = 0
      for _, (a, b, c, d, e) in query {
        sum += a.0 + b.0 + c.0 + d.0 + e.0
      }
      sum
    }
    let read_columns = () => {
      let mut sum = 0
      query.batches(batch => {
        let a : ReadColumn[QueryBenchA] = batch.read_column()
        let b : ReadColumn[QueryBenchB] = batch.read_column()
        let c : ReadColumn[QueryBenchC] = batch.read_column()
        let d : ReadColumn[QueryBenchD] = batch.read_column()
        let e : ReadColumn[QueryBenchE] = batch.read_column()
        for row in 0..<batch.length() {
          sum += a[row].0 + b[row].0 + c[row].0 + d[row].0 + e[row].0
        }
      })
      sum
    }
    // A direct-column reference isolates the cost of the public scoped views.
    let raw_columns = () => {
      let mut sum = 0
      query.for_each_table((entities, table, _) => {
        let a = a.column(table).unwrap()
        let b = b.column(table).unwrap()
        let c = c.column(table).unwrap()
        let d = d.column(table).unwrap()
        let e = e.column(table).unwrap()
        for row in 0..<entities.length() {
          sum += a[row].0 + b[row].0 + c[row].0 + d[row].0 + e[row].0
        }
      })
      sum
    }
    let write_columns = () => {
      query.batches(batch => {
        let a : ReadColumn[QueryBenchA] = batch.read_column()
        let b : WriteColumn[QueryBenchB] = batch.write_column()
        let c : ReadColumn[QueryBenchC] = batch.read_column()
        let e : WriteColumn[QueryBenchE] = batch.write_column()
        for row in 0..<batch.length() {
          b[row] = QueryBenchB(a[row].0 + 2)
          e[row] = QueryBenchE(c[row].0 + 4)
        }
      })
    }
    assert_eq(read_rows(), raw_columns())
    assert_eq(read_columns(), raw_columns())
    write_columns()
    assert_eq(read_columns(), raw_columns())
    for
      (name, read) in [
        ("row", read_rows),
        ("columns", read_columns),
        ("raw-columns", raw_columns),
      ] {
      bench.bench(name="unified/\{name}/cols=5/stride=\{stride}", count=12, () => {
        bench.keep(read())
      })
    }
    bench.bench(
      name="unified/write-second-and-fifth/stride=\{stride}",
      count=12,
      () => {
        write_columns()
        bench.keep(world.id())
      },
    )
  }
}
