///|
// Archetype signatures and their column arrays stay stable as entities migrate.
priv struct ArchetypeQuery[Columns] {
  world_id : UInt32
  storage : ArchetypeWorld
  bind : (Int32) -> Columns?
  matches : Array[(Int32, Columns)]
  mut scanned : Int32
}

///|
fn[A, Columns] new_archetype_query(
  first : ComponentStore[A],
  other_worlds : Array[UInt32],
  bind : (Int32) -> Columns?,
) -> ArchetypeQuery[Columns] {
  for world_id in other_worlds {
    guard first.world_id == world_id else {
      abort("component stores belong to different worlds")
    }
  }
  {
    world_id: first.world_id,
    storage: first.storage,
    bind,
    matches: [],
    scanned: 0,
  }
}

///|
fn[Columns] ArchetypeQuery::location(
  self : ArchetypeQuery[Columns],
  entity : Entity,
) -> (Int32, Int32)? {
  guard self.world_id == entity.world_id else { None }
  self.storage.location(entity)
}

///|
fn[Columns] ArchetypeQuery::for_each_table(
  self : ArchetypeQuery[Columns],
  visit : (Array[Entity], Columns) -> Unit,
) -> Unit {
  let storage = self.storage
  for id in self.scanned..<storage.tables.length() {
    if (self.bind)(id) is Some(columns) {
      self.matches.push((id, columns))
    }
  }
  self.scanned = storage.tables.length()

  enter_query()
  storage.active_queries += 1
  defer {
    storage.active_queries -= 1
    leave_query()
  }
  for match_entry in self.matches {
    let (id, columns) = match_entry
    let entities = storage.tables[id].entities
    if !entities.is_empty() {
      visit(entities, columns)
    }
  }
}
