///|
/// A typed component store with one contiguous column per matching archetype.
priv struct ComponentStore[T] {
  world_id : UInt32
  storage : ArchetypeWorld
  component : Int32
  columns : Array[Array[T]?]
  order : ComponentOrder
}

///|
fn[T] ComponentStore::ComponentStore(world : World) -> ComponentStore[T] {
  let storage = entity_store(world~).archetypes
  let columns : Array[Array[T]?] = []
  let order = { entries: [], head: None, tail: None, length: 0, next_rank: 0, }
  let component = storage.create_columns.length()
  storage.create_columns.push(table => {
    while columns.length() <= table {
      columns.push(None)
    }
    let values = []
    columns[table] = Some(values)
    {
      remove_row: row => swap_remove_row(values, row),
      forget: entity => order.remove(entity),
    }
  })
  { world_id: world.id(), storage, component, columns, order, }
}

///|
fn[T] ComponentStore::belongs_to(
  self : ComponentStore[T],
  world : World,
) -> Bool {
  self.world_id == world.id()
}

///|
fn[T] ComponentStore::location(
  self : ComponentStore[T],
  entity : Entity,
) -> (Int32, Int32)? {
  guard self.order.length > 0 && self.world_id == entity.world_id else { None }
  self.storage.location(entity)
}

///|
fn[T] ComponentStore::column(self : ComponentStore[T], id : Int32) -> Array[T]? {
  self.columns.get(id).unwrap_or(None)
}

///|
fn[T] ComponentStore::get(self : ComponentStore[T], entity : Entity) -> T? {
  guard self.location(entity) is Some((id, row)) else { None }
  guard self.column(id) is Some(column) else { None }
  Some(column[row])
}

///|
/// Overwrites a value in an existing row. Aborts if the entity has no such
/// column, belongs to another World, or has no materialized row.
fn[T] ComponentStore::set(
  self : ComponentStore[T],
  entity : Entity,
  value : T,
) -> Unit {
  guard self.location(entity) is Some((id, row)) &&
    self.column(id) is Some(column) else {
    abort("component write requires an existing column on this entity")
  }
  column[row] = value
}

///|
fn[T] ComponentStore::append_new(
  self : ComponentStore[T],
  id : Int32,
  entity : Entity,
  value : T,
) -> Unit {
  self.columns[id].unwrap().push(value)
  self.order.append(entity)
}
