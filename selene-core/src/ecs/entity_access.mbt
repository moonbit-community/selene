///|
/// Read-only entity lifecycle metadata for one World.
struct Entities {
  world_id : UInt32
  store : EntityWorldStore
}

///|
pub fn Entities::Entities(world : World) -> Entities {
  { world_id: world.id(), store: entity_store(world~), }
}

///|
pub fn Entities::is_valid(self : Entities, entity : Entity) -> Bool {
  entity.world_id == self.world_id &&
  self.store.archetypes.slot(entity) is Some(_)
}

///|
pub fn Entities::is_alive(self : Entities, entity : Entity) -> Bool {
  entity.world_id == self.world_id && self.store.is_alive(entity)
}

///|
pub fn Entities::iter(self : Entities) -> Iter[Entity] {
  self.store.all_entities.iter().filter(entity => self.store.is_alive(entity))
}

///|
pub fn Entities::count(self : Entities) -> Int32 {
  self.store.alive_count
}

///|
pub impl SystemParam for Entities with fn prepare(world) {
  let entities = Entities(world)
  _ => entities
}

///|
pub extend Entities with SystemParam::{prepare}

///|
/// Read-only access to the fixed parent-child tree in one World.
struct Hierarchy {
  world_id : UInt32
  store : EntityWorldStore
}

///|
pub fn Hierarchy::Hierarchy(world : World) -> Hierarchy {
  { world_id: world.id(), store: entity_store(world~), }
}

///|
pub fn Hierarchy::parent(self : Hierarchy, entity : Entity) -> Entity? {
  guard entity.world_id == self.world_id else { None }
  match self.store.archetypes.slot(entity) {
    Some(slot) => slot.parent
    None => None
  }
}

///|
pub fn Hierarchy::children(self : Hierarchy, entity : Entity) -> Array[Entity] {
  guard entity.world_id == self.world_id else { [] }
  self.store.archetypes
  .slot(entity)
  .map_or([], slot => slot.children.map_or([], children => children.copy()))
}

///|
pub fn Hierarchy::roots(self : Hierarchy) -> Iter[Entity] {
  self.store.all_entities
  .iter()
  .filter(entity => {
    self.store.is_alive(entity) &&
    self.store.archetypes.slot(entity).unwrap().parent is None
  })
}

///|
pub impl SystemParam for Hierarchy with fn prepare(world) {
  let hierarchy = Hierarchy(world)
  _ => hierarchy
}

///|
pub extend Hierarchy with SystemParam::{prepare}
