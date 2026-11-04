///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Name {
  value : String
}

///|
pub fn Name::Name(value : String) -> Name {
  { value, }
}

///|
pub fn names() -> @ecs.ComponentStore[Name] {
  @ecs.components()
}

///|
pub fn name_of(entity : @ecs.Entity) -> String? {
  names().get(entity).map(fn(name) { name.value })
}
