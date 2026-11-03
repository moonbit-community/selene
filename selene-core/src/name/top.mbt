///|
pub(all) struct Name {
  value : String
} derive(Eq, Debug)

///|
priv struct NameWorldStore {
  names : @entity.ComponentStore[Name]
}

///|
let name_world_store_key : @ecs.WorldKey[NameWorldStore] = WorldKey(() => {
  names: ComponentStore(@ecs.require_current_world()),
})

///|
fn name_world_store() -> NameWorldStore {
  @ecs.require_current_world().get_or_init(name_world_store_key)
}

///|
pub fn Name::Name(value : String) -> Name {
  { value, }
}

///|
pub fn names() -> @entity.ComponentStore[Name] {
  name_world_store().names
}

///|
pub fn name_of(entity : @entity.Entity) -> String? {
  names().get(entity).map(fn(name) { name.value })
}
