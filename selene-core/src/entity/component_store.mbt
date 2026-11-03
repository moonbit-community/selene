///|
/// A typed component store with one contiguous column per matching archetype.
struct ComponentStore[T] {
  world_id : UInt32
  storage : ArchetypeWorld
  component : Int32
  columns : Array[Array[T]?]
  orders : Array[Int32]
  mut next_order : Int32
}

///|
pub fn[T] ComponentStore::ComponentStore(
  world : @ecs.World,
) -> ComponentStore[T] {
  let storage = world.get_or_init(archetype_world_key)
  let columns : Array[Array[T]?] = []
  let component = storage.create_columns.length()
  storage.singleton_tables.push(None)
  storage.create_columns.push(table => {
    while columns.length() <= table {
      columns.push(None)
    }
    let values = []
    columns[table] = Some(values)
    {
      append_to: (target, row) => columns[target].unwrap().push(values[row]),
      remove_row: row => swap_remove_row(values, row),
    }
  })
  {
    world_id: world.id(),
    storage,
    component,
    columns,
    orders: [],
    next_order: 0,
  }
}

///|
fn[T] ComponentStore::location(
  self : ComponentStore[T],
  entity : Entity,
) -> (Int32, Int32)? {
  guard self.world_id == entity.world_id else { None }
  self.storage.location(entity)
}

///|
fn[T] ComponentStore::column(self : ComponentStore[T], id : Int32) -> Array[T]? {
  self.columns.get(id).unwrap_or(None)
}

///|
pub fn[T] ComponentStore::get(self : ComponentStore[T], entity : Entity) -> T? {
  guard self.location(entity) is Some((id, row)) else { None }
  guard self.column(id) is Some(column) else { None }
  Some(column[row])
}

///|
pub fn[T] ComponentStore::contains(
  self : ComponentStore[T],
  entity : Entity,
) -> Bool {
  guard self.location(entity) is Some((id, _)) else { false }
  self.column(id) is Some(_)
}

///|
pub fn[T] ComponentStore::set(
  self : ComponentStore[T],
  entity : Entity,
  value : T,
) -> Unit {
  guard self.world_id == entity.world_id else { return }
  let location = self.location(entity)
  if location is Some((id, row)) && self.column(id) is Some(column) {
    column[row] = value
    return
  }
  self.storage.require_no_query()
  let id = match location {
    Some((id, _)) => self.storage.transition(id, self.component).unwrap()
    None => self.storage.singleton_table(self.component)
  }
  self.storage.move_row(entity, location, Some(id))
  self.append_new(id, entity, value)
}

///|
fn[T] ComponentStore::append_new(
  self : ComponentStore[T],
  id : Int32,
  entity : Entity,
  value : T,
) -> Unit {
  self.columns[id].unwrap().push(value)
  let index = entity.id().reinterpret_as_int()
  while self.orders.length() <= index {
    self.orders.push(0)
  }
  self.orders[index] = self.next_order
  self.next_order += 1
}

///|
pub fn[T] ComponentStore::remove(
  self : ComponentStore[T],
  entity : Entity,
) -> Unit {
  guard self.location(entity) is Some((id, row)) else { return }
  guard self.column(id) is Some(_) else { return }
  self.storage.require_no_query()
  self.storage.move_row(
    entity,
    Some((id, row)),
    self.storage.transition(id, self.component),
  )
}

///|
/// Visits entries in archetype order. Queue structural changes after iteration.
pub fn[T] ComponentStore::iter2(self : ComponentStore[T]) -> Iter2[Entity, T] {
  let mut id = 0
  let mut row = 0
  Iter2::new(() => {
    while id < self.columns.length() {
      if self.columns[id] is Some(column) && row < column.length() {
        let result = (self.storage.tables[id].entities[row], column[row])
        row += 1
        return Some(result)
      }
      id += 1
      row = 0
    }
    None
  })
}

///|
pub fn[T] ComponentStore::clear(self : ComponentStore[T]) -> Unit {
  for id, column in self.columns {
    if column is Some(_) {
      let entities = self.storage.tables[id].entities
      while entities.last() is Some(entity) {
        self.remove(entity)
      }
    }
  }
  self.orders.clear()
  self.next_order = 0
}

///|
/// A stable insertion rank for an entity that has this component.
pub fn[T] ComponentStore::insertion_order(
  self : ComponentStore[T],
  entity : Entity,
) -> Int32 {
  self.orders[entity.id().reinterpret_as_int()]
}

///|
/// Upper bound of the insertion ranks of this store.
pub fn[T] ComponentStore::order_span(self : ComponentStore[T]) -> Int32 {
  self.next_order
}
