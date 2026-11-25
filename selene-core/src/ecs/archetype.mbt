///|
priv struct ArchetypeColumn {
  remove_row : (Int32) -> Unit
  swap_rows : (Int32, Int32) -> Unit
  forget : (Entity) -> Unit
}

///|
priv struct Archetype {
  mut active_count : Int32
  entities : Array[Entity]
  columns : Array[ArchetypeColumn]
}

///|
priv struct ArchetypeWorld {
  tables : Array[Archetype]
  table_ids : Map[Array[Int32], Int32]
  slots : Array[EntitySlot]
  create_columns : Array[(Int32) -> ArchetypeColumn]
  mut active_queries : Int32
  mut structural_version : UInt64
}

///|
fn ArchetypeWorld::ArchetypeWorld(slots : Array[EntitySlot]) -> ArchetypeWorld {
  {
    tables: [],
    table_ids: {},
    slots,
    create_columns: [],
    active_queries: 0,
    structural_version: 0UL,
  }
}

///|
fn ArchetypeWorld::table_for(
  self : ArchetypeWorld,
  signature : Array[Int32],
) -> Int32 {
  self.table_ids.get_or_init(signature, () => {
    let id = self.tables.length()
    let columns = signature.map(component => self.create_columns[component](id))
    self.tables.push({ active_count: 0, entities: [], columns, })
    id
  })
}

///|
fn ArchetypeWorld::require_no_query(self : ArchetypeWorld) -> Unit {
  guard self.active_queries == 0 else {
    abort("queue structural changes outside an archetype query")
  }
}

///|
fn[T] swap_remove_row(column : Array[T], row : Int32) -> Unit {
  let last = column.length() - 1
  if row != last {
    column[row] = column[last]
  }
  ignore(column.pop())
}

///|
fn ArchetypeWorld::slot(self : ArchetypeWorld, entity : Entity) -> EntitySlot? {
  guard self.slots.get(entity.slot) is Some(slot) else { None }
  guard slot.generation == entity.generation && slot.state is Some(_) else {
    None
  }
  Some(slot)
}

///|
fn ArchetypeWorld::location(
  self : ArchetypeWorld,
  entity : Entity,
) -> (Int32, Int32)? {
  guard self.slot(entity) is Some(slot) else { None }
  slot.location
}

///|
fn ArchetypeWorld::append_entity(
  self : ArchetypeWorld,
  id : Int32,
  entity : Entity,
) -> Unit {
  let entities = self.tables[id].entities
  self.slots[entity.slot].location = Some((id, entities.length()))
  entities.push(entity)
  self.structural_version += 1UL
}

///|
fn ArchetypeWorld::swap_rows(
  self : ArchetypeWorld,
  id : Int32,
  first : Int32,
  second : Int32,
) -> Unit {
  guard first != second else { return }
  let table = self.tables[id]
  for column in table.columns {
    (column.swap_rows)(first, second)
  }
  let entity = table.entities[first]
  table.entities[first] = table.entities[second]
  table.entities[second] = entity
  self.slots[table.entities[first].slot].location = Some((id, first))
  self.slots[table.entities[second].slot].location = Some((id, second))
}

///|
fn ArchetypeWorld::set_active(
  self : ArchetypeWorld,
  entity : Entity,
  active : Bool,
) -> Unit {
  guard self.location(entity) is Some((id, row)) else { return }
  let table = self.tables[id]
  if active {
    guard row >= table.active_count else { return }
    self.swap_rows(id, row, table.active_count)
    table.active_count += 1
  } else {
    guard row < table.active_count else { return }
    self.swap_rows(id, row, table.active_count - 1)
    table.active_count -= 1
  }
  self.structural_version += 1UL
}

///|
fn ArchetypeWorld::remove_entity_row(
  self : ArchetypeWorld,
  entity : Entity,
  id : Int32,
  row : Int32,
) -> Unit {
  let table = self.tables[id]
  let mut row = row
  if row < table.active_count {
    self.swap_rows(id, row, table.active_count - 1)
    table.active_count -= 1
    row = table.active_count
  }
  let last = table.entities.length() - 1
  self.swap_rows(id, row, last)
  for column in table.columns {
    (column.forget)(entity)
    (column.remove_row)(last)
  }
  ignore(table.entities.pop())
  self.slots[entity.slot].location = None
  self.structural_version += 1UL
}
