///|
/// A component or group of components that can initialize an entity.
pub(open) trait Bundle {
  fn prepare(World) -> SpawnPlan[Self]
}

///|
let empty_spawn_plan : WorldKey[SpawnPlan[Unit]] = WorldKey::with_world(world => {
  world_id: world.id(),
  entities: entity_store(world~),
  signature: [],
  table: None,
  append: (_, _, _) => (),
})

///|
pub impl Bundle for Unit with fn prepare(world) {
  world.get_or_init(empty_spawn_plan)
}

///|
/// Wraps one component for use with the spawn API.
#derive(Eq, Debug)
pub(all) struct Single[T](T)

///|
pub extend Single with Eq::{equal, not_equal}

///|
pub extend Single with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub impl[T : Component] Bundle for Single[T] with fn prepare(world) {
  let plan : SpawnPlan[T] = component_spawn_plan(world)
  {
    world_id: plan.world_id,
    entities: plan.entities,
    signature: plan.signature,
    table: plan.table,
    append: (id, entity, single) => (plan.append)(id, entity, single.0),
  }
}

///|
#deprecated("Use Commands::prepare_spawn.", skip_current_package=true)
#doc(hidden)
pub extend Single with Bundle::{prepare}

///|
fn[T : Component] component_spawn_plan(world : World) -> SpawnPlan[T] {
  let store : ComponentStore[T] = components_in(world)
  store.spawn_plan(world)
}

///|
pub impl[A : Component, B : Component] Bundle for (A, B) with fn prepare(world) {
  let a : SpawnPlan[A] = component_spawn_plan(world)
  let b : SpawnPlan[B] = component_spawn_plan(world)
  a.combine(b)
}

///|
pub impl[A : Component, B : Component, C : Component] Bundle for (A, B, C) with fn prepare(
  world,
) {
  let first : SpawnPlan[(A, B)] = Bundle::prepare(world)
  let last : SpawnPlan[C] = component_spawn_plan(world)
  first.combine_with(last, values => ((values.0, values.1), values.2))
}

///|
pub impl[A : Component, B : Component, C : Component, D : Component] Bundle for (
  A,
  B,
  C,
  D,
) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C)] = Bundle::prepare(world)
  let last : SpawnPlan[D] = component_spawn_plan(world)
  first.combine_with(last, values => ((values.0, values.1, values.2), values.3))
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
] Bundle for (A, B, C, D, E) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D)] = Bundle::prepare(world)
  let last : SpawnPlan[E] = component_spawn_plan(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3), values.4)
  })
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
] Bundle for (A, B, C, D, E, F) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E)] = Bundle::prepare(world)
  let last : SpawnPlan[F] = component_spawn_plan(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3, values.4), values.5)
  })
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
  G : Component,
] Bundle for (A, B, C, D, E, F, G) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E, F)] = Bundle::prepare(world)
  let last : SpawnPlan[G] = component_spawn_plan(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3, values.4, values.5), values.6)
  })
}

///|
pub impl[
  A : Component,
  B : Component,
  C : Component,
  D : Component,
  E : Component,
  F : Component,
  G : Component,
  H : Component,
] Bundle for (A, B, C, D, E, F, G, H) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E, F, G)] = Bundle::prepare(world)
  let last : SpawnPlan[H] = component_spawn_plan(world)
  first.combine_with(last, values => {
    (
      (values.0, values.1, values.2, values.3, values.4, values.5, values.6),
      values.7,
    )
  })
}

///|
/// Prepares a World-bound plan for repeatedly spawning the same component types.
pub fn[T : Bundle] Commands::prepare_spawn(self : Commands) -> SpawnPlan[T] {
  let plan : SpawnPlan[T] = Bundle::prepare(self.world)
  guard plan.world_id == self.world.id() else {
    abort("spawn plan belongs to another world")
  }
  plan
}
