///|
/// A typed component store with one contiguous column per matching archetype.
struct ComponentStore[T] {
  world_id : UInt32
  storage : ArchetypeWorld
  component : Int32
  columns : Array[Array[T]?]
  order : ComponentOrder
}

///|
pub fn[T] ComponentStore::ComponentStore(world : World) -> ComponentStore[T] {
  let storage = entity_store_key.get_or_insert_with(world, new_entity_store).archetypes
  let columns : Array[Array[T]?] = []
  let order = { entries: [], head: None, tail: None, length: 0, next_rank: 0, }
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
      forget: entity => order.remove(entity),
    }
  })
  { world_id: world.id(), storage, component, columns, order, }
}

///|
pub fn[T] ComponentStore::belongs_to(
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
#alias(op_set)
pub fn[T] ComponentStore::set(
  self : ComponentStore[T],
  entity : Entity,
  value : T,
) -> Unit {
  guard self.world_id == entity.world_id else { return }
  guard self.storage.slot(entity) is Some(slot) else { return }
  let location = slot.location
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
  self.order.append(entity)
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
/// Visits entries in component insertion order, independently of row migration.
pub fn[T] ComponentStore::iter2(self : ComponentStore[T]) -> Iter2[Entity, T] {
  let mut next = self.order.head
  let length = self.order.length
  let mut remaining = length
  Iter2::new(
    () => {
      guard remaining > 0 && next is Some(index) else { None }
      guard self.order.entries.get(index) is Some(Some(entry)) else { None }
      next = entry.next
      remaining -= 1
      let (table, row) = self.storage.slots[index].location.unwrap()
      Some((entry.entity, self.columns[table].unwrap()[row]))
    },
    size_hint=length,
  )
}

///|
pub fn[T] ComponentStore::iter(self : ComponentStore[T]) -> Iter[(Entity, T)] {
  let entries = self.iter2()
  Iter::new(() => entries.next())
}

///|
pub fn[T] ComponentStore::keys(self : ComponentStore[T]) -> Iter[Entity] {
  let mut next = self.order.head
  let length = self.order.length
  let mut remaining = length
  Iter::new(
    () => {
      guard remaining > 0 && next is Some(index) else { None }
      guard self.order.entries.get(index) is Some(Some(entry)) else { None }
      next = entry.next
      remaining -= 1
      Some(entry.entity)
    },
    size_hint=length,
  )
}

///|
pub fn[T] ComponentStore::values(self : ComponentStore[T]) -> Iter[T] {
  self.iter().map(pair => pair.1)
}

///|
pub fn[T] ComponentStore::to_array(
  self : ComponentStore[T],
) -> Array[(Entity, T)] {
  self.iter().collect()
}

///|
pub fn[T] ComponentStore::length(self : ComponentStore[T]) -> Int32 {
  self.order.length
}

///|
pub fn[T] ComponentStore::is_empty(self : ComponentStore[T]) -> Bool {
  self.order.length == 0
}

///|
pub fn[T] ComponentStore::get_or_init(
  self : ComponentStore[T],
  entity : Entity,
  create : () -> T,
) -> T {
  if self.get(entity) is Some(value) {
    value
  } else {
    let value = create()
    self.set(entity, value)
    value
  }
}

///|
pub fn[T] ComponentStore::retain(
  self : ComponentStore[T],
  predicate : (Entity) -> Bool,
) -> Unit {
  for entity in self.keys() {
    if !predicate(entity) {
      self.remove(entity)
    }
  }
}

///|
pub fn[T] ComponentStore::clear(self : ComponentStore[T]) -> Unit {
  while self.order.head is Some(index) {
    self.remove(self.order.entries[index].unwrap().entity)
  }
  self.order.entries.clear()
  self.order.next_rank = 0
}

///|
/// A stable insertion rank for an entity that has this component.
pub fn[T] ComponentStore::insertion_order(
  self : ComponentStore[T],
  entity : Entity,
) -> Int32 {
  guard self.world_id == entity.world_id &&
    self.order.entries.get(entity.slot) is Some(Some(entry)) &&
    entry.entity.generation == entity.generation else {
    abort("entity does not have this component")
  }
  entry.rank
}

///|
/// Upper bound of the insertion ranks of this store.
pub fn[T] ComponentStore::order_span(self : ComponentStore[T]) -> Int32 {
  self.order.next_rank
}
