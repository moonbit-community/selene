///|
fn spawn_recycled_population(
  world : World,
  bundle : SpawnBundle[Int32],
  population : Array[Entity],
  size : Int32,
) -> Unit {
  for i in 0..<size {
    population.push(bundle.spawn(world, i))
  }
}

///|
fn delete_population(population : Array[Entity]) -> Unit {
  for entity in population {
    ignore(entity.delete())
  }
  population.clear()
}

///|
fn cycle_entity_slots(waves : Int32, size : Int32) -> World {
  let world = World()
  set_current_world(world)
  let values : ComponentStore[Int32] = ComponentStore(world)
  let bundle = values.spawn_bundle()
  let population = []
  for _ in 0..<waves {
    spawn_recycled_population(world, bundle, population, size)
    delete_population(population)
  }
  world
}

///|
test "batch entity slot churn" (b : @bench.T) {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })

  b.bench(name="spawn-delete/100x1000", count=10, () => {
    b.keep(cycle_entity_slots(100, 1000))
  })
}

///|
fn bench_steady_population(b : @bench.T, replacements : Int32) -> Unit raise {
  let previous = current_world()
  defer (match previous {
    Some(world) => set_current_world(world)
    None => clear_current_world()
  })
  let world = World()
  set_current_world(world)
  let values : ComponentStore[Int32] = ComponentStore(world)
  let bundle = values.spawn_bundle()
  let population = []
  spawn_recycled_population(world, bundle, population, 4096)
  // Keep 1024 long-lived entities and rotate the remaining 3072 in place.
  for step in 0..<replacements {
    let index = 1024 + step * 1103 % 3072
    ignore(population[index].delete())
    population[index] = bundle.spawn(world, index)
  }
  assert_eq(alive_entity_count(), population.length())
  let is_alive = alive_in_world(world)
  let slots = entity_store_key.get_or_insert_with(world, new_entity_store).archetypes.slots.length()
  b.bench(
    name="live-update/n=4096/replaced=\{replacements}/slots=\{slots}",
    count=10,
    () => {
      let mut sum = 0
      for entity in population {
        if is_alive(entity) {
          let value = values.get(entity).unwrap()
          sum += value
          values.set(entity, (value + 1) & 0x7fff)
        }
      }
      b.keep(sum)
    },
  )
}

///|
test "update a fixed population in a fresh world" (b : @bench.T) {
  bench_steady_population(b, 0)
}

///|
test "update a fixed population after a million replacements" (b : @bench.T) {
  bench_steady_population(b, 1000000)
}
