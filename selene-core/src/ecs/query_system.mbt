///|
/// Binds a query constructor once per World and reuses the resulting query.
pub fn[Q] cache_query(make : (World) -> Q) -> (World) -> Q {
  let cache = WorldKey::with_world(make)
  world => world.get_or_init(cache)
}

///|
/// Adapts a typed query callback into a system, caching its query per World.
pub fn[Q] query_system(make : (World) -> Q, run : (Q) -> Unit) -> System {
  let cached = cache_query(make)
  world => run(cached(world))
}
