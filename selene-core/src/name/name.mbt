///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Name {
  value : String
}

///|
pub extend Name with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Name with Eq::{not_equal, equal}

///|
pub fn Name::Name(value : String) -> Name {
  { value, }
}

///|
pub fn name_of(world~ : @ecs.World, entity : @ecs.Entity) -> String? {
  (world.get_component(entity) : Name?).map(fn(name) { name.value })
}
