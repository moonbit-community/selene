///|
pub(all) struct Name {
  value : String
} derive(Eq, Debug)

///|
priv struct NameWorldStore {
  names : Map[@entity.Entity, Name]
}

///|
let name_world_stores : Map[UInt, NameWorldStore] = Map([])

///|
fn name_world_store() -> NameWorldStore {
  let world_id = @ecs.require_current_world().id()
  name_world_stores.get_or_init(world_id, () => { names: Map([]) })
}

///|
pub fn Name::Name(value : String) -> Name {
  { value, }
}

///|
pub fn names() -> Map[@entity.Entity, Name] {
  name_world_store().names
}

///|
pub fn name_of(entity : @entity.Entity) -> String? {
  names().get(entity).map(fn(name) { name.value })
}
