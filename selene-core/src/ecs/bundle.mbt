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
  insert: (_, _) => (),
})

///|
pub impl Bundle for Unit with fn prepare(world) {
  world.get_or_init(empty_spawn_plan)
}

///|
pub impl[A : Bundle, B : Bundle] Bundle for (A, B) with fn prepare(world) {
  let a : SpawnPlan[A] = Bundle::prepare(world)
  let b : SpawnPlan[B] = Bundle::prepare(world)
  a.combine(b)
}

///|
pub impl[A : Bundle, B : Bundle, C : Bundle] Bundle for (A, B, C) with fn prepare(
  world,
) {
  let first : SpawnPlan[(A, B)] = Bundle::prepare(world)
  let last : SpawnPlan[C] = Bundle::prepare(world)
  first.combine_with(last, values => ((values.0, values.1), values.2))
}

///|
pub impl[A : Bundle, B : Bundle, C : Bundle, D : Bundle] Bundle for (A, B, C, D) with fn prepare(
  world,
) {
  let first : SpawnPlan[(A, B, C)] = Bundle::prepare(world)
  let last : SpawnPlan[D] = Bundle::prepare(world)
  first.combine_with(last, values => ((values.0, values.1, values.2), values.3))
}

///|
pub impl[A : Bundle, B : Bundle, C : Bundle, D : Bundle, E : Bundle] Bundle for (
  A,
  B,
  C,
  D,
  E,
) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D)] = Bundle::prepare(world)
  let last : SpawnPlan[E] = Bundle::prepare(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3), values.4)
  })
}

///|
pub impl[A : Bundle, B : Bundle, C : Bundle, D : Bundle, E : Bundle, F : Bundle] Bundle for (
  A,
  B,
  C,
  D,
  E,
  F,
) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E)] = Bundle::prepare(world)
  let last : SpawnPlan[F] = Bundle::prepare(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3, values.4), values.5)
  })
}

///|
pub impl[
  A : Bundle,
  B : Bundle,
  C : Bundle,
  D : Bundle,
  E : Bundle,
  F : Bundle,
  G : Bundle,
] Bundle for (A, B, C, D, E, F, G) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E, F)] = Bundle::prepare(world)
  let last : SpawnPlan[G] = Bundle::prepare(world)
  first.combine_with(last, values => {
    ((values.0, values.1, values.2, values.3, values.4, values.5), values.6)
  })
}

///|
pub impl[
  A : Bundle,
  B : Bundle,
  C : Bundle,
  D : Bundle,
  E : Bundle,
  F : Bundle,
  G : Bundle,
  H : Bundle,
] Bundle for (A, B, C, D, E, F, G, H) with fn prepare(world) {
  let first : SpawnPlan[(A, B, C, D, E, F, G)] = Bundle::prepare(world)
  let last : SpawnPlan[H] = Bundle::prepare(world)
  first.combine_with(last, values => {
    (
      (values.0, values.1, values.2, values.3, values.4, values.5, values.6),
      values.7,
    )
  })
}

///|
/// Prepares a World-bound plan for repeatedly spawning the same component types.
pub fn[T : Bundle] World::prepare_spawn(self : World) -> SpawnPlan[T] {
  let plan : SpawnPlan[T] = Bundle::prepare(self)
  guard plan.world_id == self.id() else {
    abort("spawn plan belongs to another world")
  }
  plan
}

///|
/// Creates an entity directly in the archetype for the supplied components.
pub fn[T : Bundle] World::spawn(self : World, values : T) -> Entity {
  self.prepare_spawn().spawn(values)
}
