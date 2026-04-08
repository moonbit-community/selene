///|
pub(all) struct Name {
  value : String

  fn new(value : String) -> Name
} derive(Eq, Debug)

///|
priv struct NameWorldStore {
  names : Map[@entity.Entity, Name]
}

///|
let name_world_stores : Map[UInt, NameWorldStore] = Map::new()

///|
fn name_world_store() -> NameWorldStore {
  let world_id = @ecs.require_current_world().id()
  name_world_stores.get_or_init(world_id, () => { names: Map::new() })
}

///|
pub fn Name::new(value : String) -> Name {
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
