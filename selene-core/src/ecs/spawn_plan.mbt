///|
/// A reusable, World-bound layout for spawning directly into an archetype.
/// The type parameter describes the values supplied for each spawn.
struct SpawnPlan[T] {
  world_id : UInt32
  entities : EntityWorldStore
  signature : Array[Int32]
  mut table : Int32?
  append : (Int32, Entity, T) -> Unit
}

///|
/// Prepares an explicitly selected component column for spawning in its World.
fn[T] ComponentStore::spawn_plan(
  self : ComponentStore[T],
  world : World,
) -> SpawnPlan[T] {
  guard self.belongs_to(world) else {
    abort("spawn plan component belongs to another world")
  }
  {
    world_id: self.world_id,
    entities: entity_store(world~),
    signature: [self.component],
    table: None,
    append: (id, entity, value) => self.append_new(id, entity, value),
  }
}

///|
/// Combines two layouts. Aborts for foreign-World or duplicate components.
pub fn[A, B] SpawnPlan::combine(
  self : SpawnPlan[A],
  other : SpawnPlan[B],
) -> SpawnPlan[(A, B)] {
  self.combine_with(other, pair => pair)
}

///|
fn[A, B, T] SpawnPlan::combine_with(
  self : SpawnPlan[A],
  other : SpawnPlan[B],
  split : (T) -> (A, B),
) -> SpawnPlan[T] {
  guard self.world_id == other.world_id else {
    abort("spawn plan components belong to different worlds")
  }
  let signature = self.signature.copy()
  signature.append(other.signature[:])
  signature.sort()
  for i in 1..<signature.length() {
    guard signature[i - 1] != signature[i] else {
      abort("duplicate component in spawn plan")
    }
  }
  {
    world_id: self.world_id,
    entities: self.entities,
    signature,
    table: None,
    append: (id, entity, values) => {
      let (left, right) = split(values)
      (self.append)(id, entity, left)
      (other.append)(id, entity, right)
    },
  }
}

///|
fn[T] SpawnPlan::append_row(
  self : SpawnPlan[T],
  entity : Entity,
  values : T,
) -> Unit {
  guard !self.signature.is_empty() else { return }
  let storage = self.entities.archetypes
  let id = match self.table {
    Some(id) => id
    None => {
      let id = storage.table_for(self.signature)
      self.table = Some(id)
      id
    }
  }
  storage.append_entity(id, entity)
  (self.append)(id, entity, values)
}

///|
/// Creates a live entity and appends all bundle values to one archetype row.
pub fn[T] SpawnPlan::spawn(
  self : SpawnPlan[T],
  values : T,
  parent? : Entity,
) -> Entity {
  if parent is Some(parent) &&
    (parent.world_id != self.world_id || !self.entities.is_alive(parent)) {
    abort("parent must be alive in this World")
  }
  self.entities.archetypes.require_no_query()
  let entity = self.entities.spawn(self.world_id)
  self.append_row(entity, values)
  self.entities.link_child(entity, parent)
  entity
}

///|
/// Reserves a pending entity and queues initialization of its bundle.
/// A later command can overwrite its initialized values.
fn[T] SpawnPlan::queue_spawn(
  self : SpawnPlan[T],
  world : World,
  values : T,
  parent : Entity?,
) -> Entity {
  guard self.world_id == world.id() else {
    abort("spawn plan belongs to another world")
  }
  queue_entity_spawn(world, parent, entity => self.append_row(entity, values))
}
