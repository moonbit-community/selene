///|
/// Adapts a typed query callback into a system, caching its query per World.
pub fn[A : Component, B : Component] query_system(
  run : (Query2[A, B]) -> Unit,
) -> System {
  let cache : ResourceKey[Query2[A, B]] = ResourceKey(world => {
    let a : ComponentStore[A] = components_in(world)
    let b : ComponentStore[B] = components_in(world)
    Query2(a, b)
  })
  world => run(cache.get_in(world))
}
