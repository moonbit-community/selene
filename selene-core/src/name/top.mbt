///|
#derive(Eq, Debug)
pub(all) struct Name {
  value : String
}

///|
let name_component_key : @entity.ComponentKey[Name] = ComponentKey()

///|
pub fn Name::Name(value : String) -> Name {
  { value, }
}

///|
pub fn names() -> @entity.ComponentStore[Name] {
  name_component_key.store()
}

///|
pub fn name_of(entity : @entity.Entity) -> String? {
  names().get(entity).map(fn(name) { name.value })
}
