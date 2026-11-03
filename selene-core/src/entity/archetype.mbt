///|
priv struct ArchetypeColumn {
  append_to : (Int32, Int32) -> Unit
  remove_row : (Int32) -> Unit
}

///|
priv struct Archetype {
  signature : Array[Int32]
  entities : Array[Entity]
  columns : Array[ArchetypeColumn]
  transitions : Map[Int32, Int32?]
}

///|
priv struct ArchetypeWorld {
  tables : Array[Archetype]
  table_ids : Map[Array[Int32], Int32]
  locations : Array[(Int32, Int32)?]
  create_columns : Array[(Int32) -> ArchetypeColumn]
  singleton_tables : Array[Int32?]
  mut active_queries : Int32
}

///|
let archetype_world_key : @ecs.WorldKey[ArchetypeWorld] = WorldKey(() => {
  tables: [],
  table_ids: {},
  locations: [],
  create_columns: [],
  singleton_tables: [],
  active_queries: 0,
})

///|
fn ArchetypeWorld::table_for(
  self : ArchetypeWorld,
  signature : Array[Int32],
) -> Int32 {
  self.table_ids.get_or_init(signature, () => {
    let id = self.tables.length()
    let columns = signature.map(component => self.create_columns[component](id))
    self.tables.push({ signature, entities: [], columns, transitions: {}, })
    id
  })
}

///|
fn ArchetypeWorld::transition(
  self : ArchetypeWorld,
  id : Int32,
  component : Int32,
) -> Int32? {
  let table = self.tables[id]
  table.transitions.get_or_init(component, () => {
    let signature = table.signature.copy()
    match signature.binary_search(component) {
      Ok(at) => ignore(signature.remove(at))
      Err(at) => signature.insert(at, component)
    }
    if signature.is_empty() {
      None
    } else {
      Some(self.table_for(signature))
    }
  })
}

///|
fn ArchetypeWorld::singleton_table(
  self : ArchetypeWorld,
  component : Int32,
) -> Int32 {
  if self.singleton_tables[component] is Some(id) {
    return id
  }
  let id = self.table_for([component])
  self.singleton_tables[component] = Some(id)
  id
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
fn ArchetypeWorld::location(
  self : ArchetypeWorld,
  entity : Entity,
) -> (Int32, Int32)? {
  self.locations.get(entity.id().reinterpret_as_int()).unwrap_or(None)
}

///|
fn ArchetypeWorld::append_entity(
  self : ArchetypeWorld,
  id : Int32,
  entity : Entity,
) -> Unit {
  let index = entity.id().reinterpret_as_int()
  while self.locations.length() <= index {
    self.locations.push(None)
  }
  let entities = self.tables[id].entities
  self.locations[index] = Some((id, entities.length()))
  entities.push(entity)
}

///|
fn ArchetypeWorld::move_row(
  self : ArchetypeWorld,
  entity : Entity,
  source : (Int32, Int32)?,
  target : Int32?,
) -> Unit {
  if source is Some((id, row)) {
    let table = self.tables[id]
    if target is Some(target) {
      let signature = self.tables[target].signature
      // Both signatures are sorted. Transfer only the common columns.
      let mut next = 0
      for i, component in table.signature {
        while next < signature.length() && signature[next] < component {
          next += 1
        }
        if next < signature.length() && signature[next] == component {
          (table.columns[i].append_to)(target, row)
        }
      }
    }
    let last = table.entities.length() - 1
    if row != last {
      let moved = table.entities[last].id().reinterpret_as_int()
      self.locations[moved] = Some((id, row))
    }
    for column in table.columns {
      (column.remove_row)(row)
    }
    swap_remove_row(table.entities, row)
  }
  match target {
    Some(id) => self.append_entity(id, entity)
    None => self.locations[entity.id().reinterpret_as_int()] = None
  }
}
