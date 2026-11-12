///|
/// Constructs and caches the inferred row shape once per World.
pub fn[T : QueryData] cache_query(
  filters~ : (World) -> Array[EntityFilter] = _ => [],
) -> (World) -> Query[T] {
  let cache : WorldKey[Query[T]] = WorldKey::with_world(world => {
    world.query(filters=filters(world))
  })
  world => world.get_or_init(cache)
}

///|
/// Adapts a typed query callback into a system without a caller-supplied factory.
pub fn[T : QueryData] query_system(
  run : (Query[T]) -> Unit,
  filters~ : (World) -> Array[EntityFilter] = _ => [],
) -> System {
  let cached : (World) -> Query[T] = cache_query(filters~)
  world => run(cached(world))
}
