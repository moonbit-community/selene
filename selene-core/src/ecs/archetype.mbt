///|
priv struct ArchetypeColumn {
  remove_row : (Int32) -> Unit
  forget : (Entity) -> Unit
}

///|
priv struct Archetype {
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
}

///|
fn ArchetypeWorld::ArchetypeWorld(slots : Array[EntitySlot]) -> ArchetypeWorld {
  { tables: [], table_ids: {}, slots, create_columns: [], active_queries: 0, }
}

///|
fn ArchetypeWorld::table_for(
  self : ArchetypeWorld,
  signature : Array[Int32],
) -> Int32 {
  self.table_ids.get_or_init(signature, () => {
    let id = self.tables.length()
    let columns = signature.map(component => self.create_columns[component](id))
    self.tables.push({ entities: [], columns, })
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
}

///|
fn ArchetypeWorld::remove_entity_row(
  self : ArchetypeWorld,
  entity : Entity,
  id : Int32,
  row : Int32,
) -> Unit {
  let table = self.tables[id]
  let last = table.entities.length() - 1
  if row != last {
    let moved = table.entities[last]
    self.slots[moved.slot].location = Some((id, row))
  }
  for column in table.columns {
    (column.forget)(entity)
    (column.remove_row)(row)
  }
  swap_remove_row(table.entities, row)
  self.slots[entity.slot].location = None
}
