///|
/// A reusable, World-bound layout for spawning directly into an archetype.
/// The type parameter describes the values supplied for each spawn.
struct SpawnBundle[T] {
  world_id : UInt32
  storage : ArchetypeWorld
  signature : Array[Int32]
  mut table : Int32?
  append : (Int32, Entity, T) -> Unit
  insert : (Entity, T) -> Unit
}

///|
/// Starts a spawn bundle with this component. Compose stores before spawning.
pub fn[T] ComponentStore::spawn_bundle(
  self : ComponentStore[T],
) -> SpawnBundle[T] {
  {
    world_id: self.world_id,
    storage: self.storage,
    signature: [self.component],
    table: None,
    append: (id, entity, value) => self.append_new(id, entity, value),
    insert: (entity, value) => self.set(entity, value),
  }
}

///|
/// Combines two layouts. Aborts for foreign-World or duplicate components.
pub fn[A, B] SpawnBundle::combine(
  self : SpawnBundle[A],
  other : SpawnBundle[B],
) -> SpawnBundle[(A, B)] {
  guard self.world_id == other.world_id else {
    abort("spawn bundle components belong to different worlds")
  }
  let signature = self.signature.copy()
  signature.append(other.signature[:])
  signature.sort()
  for i in 1..<signature.length() {
    guard signature[i - 1] != signature[i] else {
      abort("duplicate component in spawn bundle")
    }
  }
  {
    world_id: self.world_id,
    storage: self.storage,
    signature,
    table: None,
    append: (id, entity, values) => {
      (self.append)(id, entity, values.0)
      (other.append)(id, entity, values.1)
    },
    insert: (entity, values) => {
      (self.insert)(entity, values.0)
      (other.insert)(entity, values.1)
    },
  }
}

///|
fn[T] SpawnBundle::append_row(
  self : SpawnBundle[T],
  entity : Entity,
  values : T,
) -> Unit {
  let id = match self.table {
    Some(id) => id
    None => {
      let id = self.storage.table_for(self.signature)
      self.table = Some(id)
      id
    }
  }
  self.storage.append_entity(id, entity)
  (self.append)(id, entity, values)
}

///|
/// Creates a live entity and appends all bundle values to one archetype row.
pub fn[T] SpawnBundle::spawn(
  self : SpawnBundle[T],
  world : @ecs.World,
  values : T,
) -> Entity {
  guard self.world_id == world.id() else {
    abort("spawn bundle belongs to another world")
  }
  self.storage.require_no_query()
  let entity = spawn_in(world)
  self.append_row(entity, values)
  entity
}

///|
/// Reserves a pending entity and queues initialization of its bundle.
/// Queue later component changes to avoid migrating the row during initialization.
pub fn[T] SpawnBundle::queue_spawn(
  self : SpawnBundle[T],
  world : @ecs.World,
  values : T,
) -> Entity {
  guard self.world_id == world.id() else {
    abort("spawn bundle belongs to another world")
  }
  queue_entity_spawn(world, entity => {
    self.storage.require_no_query()
    if self.storage.location(entity) is Some(_) {
      // Immediate edits to a pending entity may already have created a row.
      (self.insert)(entity, values)
    } else {
      self.append_row(entity, values)
    }
  })
}
