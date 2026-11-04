///|
/// Adapts a typed query callback into a system, caching its query per World.
pub fn[A : @entity.Component, B : @entity.Component] query_system(
  run : (@query.Query2[A, B]) -> Unit,
) -> System {
  let cache : @ecs.ResourceKey[@query.Query2[A, B]] = ResourceKey(world => {
    let a : @entity.ComponentStore[A] = @entity.components_in(world)
    let b : @entity.ComponentStore[B] = @entity.components_in(world)
    @entity.ArchetypeQuery2(a, b)
  })
  world => run(cache.get_in(world))
}
