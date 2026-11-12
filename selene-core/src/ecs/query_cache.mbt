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
