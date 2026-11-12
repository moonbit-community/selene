///|
/// Declares the parameters prepared separately for each registration and World.
/// Prepared fetchers must not retain their owning World.
pub(open) trait SystemParam {
  fn prepare(World) -> (World) -> Self
}

///|
/// An immutable system description. Schedule registrations own its execution state.
struct System {
  bind : () -> (World) -> Unit
}

///|
pub fn[P : SystemParam] System::System(run : (P) -> Unit) -> System {
  {
    bind: () => {
      // Cache only parameter state in the World, never the user's callback.
      let state : WorldKey[(World) -> P] = WorldKey::with_world(world => {
        SystemParam::prepare(world)
      })
      world => {
        let fetch = world.get_or_init(state)
        let params = fetch(world)
        set_current_world(world)
        run(params)
      }
    },
  }
}

///|
/// Explicitly requests complete World access without exposing private structural APIs.
pub fn System::exclusive(run : (World) -> Unit) -> System {
  { bind: () => run, }
}

///|
/// A predicate prepared independently for every registration and World.
struct Condition {
  bind : () -> (World) -> Bool
}

///|
pub fn[P : SystemParam] Condition::Condition(
  predicate : (P) -> Bool,
) -> Condition {
  {
    bind: () => {
      let state : WorldKey[(World) -> P] = WorldKey::with_world(world => {
        SystemParam::prepare(world)
      })
      world => {
        let fetch = world.get_or_init(state)
        let params = fetch(world)
        set_current_world(world)
        predicate(params)
      }
    },
  }
}

///|
pub impl SystemParam for Unit with fn prepare(_world) {
  _ => ()
}

///|
pub impl SystemParam for Commands with fn prepare(_world) {
  world => commands(world)
}

///|
pub impl[T : QueryData] SystemParam for Query[T] with fn prepare(world) {
  let query : Query[T] = world.query()
  _ => query
}

///|
/// A resource slot bound to one World. Reads observe subsequent replacements.
struct Res[T] {
  slot : Ref[T?]
}

///|
pub fn[T] Res::get(self : Res[T]) -> T {
  self.slot.val.unwrap_or_else(() => {
    abort("Resource is not initialized. Insert it before accessing it.")
  })
}

///|
pub fn[T] Res::set(self : Res[T], value : T) -> Unit {
  self.slot.val = Some(value)
}

///|
pub impl[T : Resource] SystemParam for Res[T] with fn prepare(world) {
  let key : ResourceKey[T] = Resource::resource_key()
  let value = Res::{ slot: world.get_or_init(key.key), }
  _ => {
    ignore(value.get())
    value
  }
}

///|
pub impl[T : Resource] SystemParam for Res[T]? with fn prepare(world) {
  let key : ResourceKey[T] = Resource::resource_key()
  let value = Res::{ slot: world.get_or_init(key.key), }
  _ => if value.slot.val is Some(_) { Some(value) } else { None }
}

///|
pub impl[A : SystemParam, B : SystemParam] SystemParam for (A, B) with fn prepare(
  world,
) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  world => (fetch_0(world), fetch_1(world))
}

///|
pub impl[A : SystemParam, B : SystemParam, C : SystemParam] SystemParam for (
  A,
  B,
  C,
) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  world => (fetch_0(world), fetch_1(world), fetch_2(world))
}

///|
pub impl[A : SystemParam, B : SystemParam, C : SystemParam, D : SystemParam] SystemParam for (
  A,
  B,
  C,
  D,
) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  let fetch_3 : (World) -> D = SystemParam::prepare(world)
  world => (fetch_0(world), fetch_1(world), fetch_2(world), fetch_3(world))
}

///|
pub impl[
  A : SystemParam,
  B : SystemParam,
  C : SystemParam,
  D : SystemParam,
  E : SystemParam,
] SystemParam for (A, B, C, D, E) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  let fetch_3 : (World) -> D = SystemParam::prepare(world)
  let fetch_4 : (World) -> E = SystemParam::prepare(world)
  world => {
    (
      fetch_0(world),
      fetch_1(world),
      fetch_2(world),
      fetch_3(world),
      fetch_4(world),
    )
  }
}

///|
pub impl[
  A : SystemParam,
  B : SystemParam,
  C : SystemParam,
  D : SystemParam,
  E : SystemParam,
  F : SystemParam,
] SystemParam for (A, B, C, D, E, F) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  let fetch_3 : (World) -> D = SystemParam::prepare(world)
  let fetch_4 : (World) -> E = SystemParam::prepare(world)
  let fetch_5 : (World) -> F = SystemParam::prepare(world)
  world => {
    (
      fetch_0(world),
      fetch_1(world),
      fetch_2(world),
      fetch_3(world),
      fetch_4(world),
      fetch_5(world),
    )
  }
}

///|
pub impl[
  A : SystemParam,
  B : SystemParam,
  C : SystemParam,
  D : SystemParam,
  E : SystemParam,
  F : SystemParam,
  G : SystemParam,
] SystemParam for (A, B, C, D, E, F, G) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  let fetch_3 : (World) -> D = SystemParam::prepare(world)
  let fetch_4 : (World) -> E = SystemParam::prepare(world)
  let fetch_5 : (World) -> F = SystemParam::prepare(world)
  let fetch_6 : (World) -> G = SystemParam::prepare(world)
  world => {
    (
      fetch_0(world),
      fetch_1(world),
      fetch_2(world),
      fetch_3(world),
      fetch_4(world),
      fetch_5(world),
      fetch_6(world),
    )
  }
}

///|
pub impl[
  A : SystemParam,
  B : SystemParam,
  C : SystemParam,
  D : SystemParam,
  E : SystemParam,
  F : SystemParam,
  G : SystemParam,
  H : SystemParam,
] SystemParam for (A, B, C, D, E, F, G, H) with fn prepare(world) {
  let fetch_0 : (World) -> A = SystemParam::prepare(world)
  let fetch_1 : (World) -> B = SystemParam::prepare(world)
  let fetch_2 : (World) -> C = SystemParam::prepare(world)
  let fetch_3 : (World) -> D = SystemParam::prepare(world)
  let fetch_4 : (World) -> E = SystemParam::prepare(world)
  let fetch_5 : (World) -> F = SystemParam::prepare(world)
  let fetch_6 : (World) -> G = SystemParam::prepare(world)
  let fetch_7 : (World) -> H = SystemParam::prepare(world)
  world => {
    (
      fetch_0(world),
      fetch_1(world),
      fetch_2(world),
      fetch_3(world),
      fetch_4(world),
      fetch_5(world),
      fetch_6(world),
      fetch_7(world),
    )
  }
}

///|
pub extend Commands with SystemParam::{prepare}

///|
pub extend Query with SystemParam::{prepare}

///|
pub extend Res with SystemParam::{prepare}

///|
/// A predicate that explicitly needs complete World access.
pub fn Condition::exclusive(predicate : (World) -> Bool) -> Condition {
  { bind: () => predicate, }
}
