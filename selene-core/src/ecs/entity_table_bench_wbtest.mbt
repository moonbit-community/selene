///|
test "BENCH runtime entity side tables versus Map" (bench : @bench.T) {
  let world = World()
  let entities = Array::makei(8192, _ => world.spawn(()))
  for stride in [1, 16] {
    let map : Map[Entity, Int32] = Map([])
    let table : EntityTable[Int32] = EntityTable(world)
    for index, entity in entities {
      if index % stride == 0 {
        map.set(entity, index)
        table.set(entity, index)
      }
    }
    let read_map = () => {
      let mut sum = 0
      for entity in entities {
        sum += map.get(entity).unwrap_or(0)
      }
      sum
    }
    let read_table = () => {
      let mut sum = 0
      for entity in entities {
        sum += table.get(entity).unwrap_or(0)
      }
      sum
    }
    assert_eq(read_map(), read_table())
    bench.bench(name="Map/read/stride=\{stride}", count=20, () => {
      bench.keep(read_map())
    })
    bench.bench(name="EntityTable/read/stride=\{stride}", count=20, () => {
      bench.keep(read_table())
    })
    bench.bench(name="Map/read-write/stride=\{stride}", count=20, () => {
      for entity in entities {
        if map.get(entity) is Some(value) {
          map.set(entity, value ^ 1)
        }
      }
      bench.keep(map.length())
    })
    bench.bench(name="EntityTable/read-write/stride=\{stride}", count=20, () => {
      for entity in entities {
        if table.get(entity) is Some(value) {
          table.set(entity, value ^ 1)
        }
      }
      bench.keep(table.length())
    })
    bench.bench(name="Map/scan/stride=\{stride}", count=20, () => {
      let mut sum = 0
      for _, value in map {
        sum += value
      }
      bench.keep(sum)
    })
    bench.bench(name="EntityTable/scan/stride=\{stride}", count=20, () => {
      let mut sum = 0
      for _, value in table {
        sum += value
      }
      bench.keep(sum)
    })
  }
}
