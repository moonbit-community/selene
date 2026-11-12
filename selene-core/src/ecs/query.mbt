///|
/// A structural filter evaluated once for each archetype.
struct EntityFilter {
  world_id : UInt32
  accepts : (Int32) -> Bool
}

///|
struct With[T] {
  storage : ComponentStore[T]
}

///|
struct Without[T] {
  storage : ComponentStore[T]
}

///|
priv struct QueryColumn[T] {
  read : (Int32) -> T
  write : (Int32, T) -> Unit
  visit_rows : (Array[Entity], (Entity, T) -> Unit) -> Unit
}

///|
priv struct QueryComponent {
  key_id : Int32
  load : () -> Unit
}

///|
/// A World-bound query over one row shape, backed by separate component columns.
/// It retains columns rather than its World so World-local caches cannot form a cycle.
struct Query[T] {
  world_id : UInt32
  storage : ArchetypeWorld
  order : ComponentOrder
  bind : (Int32) -> QueryColumn[T]?
  components : Array[QueryComponent]
  columns : Array[QueryColumn[T]?]
  matches : Array[(Int32, QueryColumn[T])]
}

///|
fn[T] Query::Query(
  world_id : UInt32,
  storage : ArchetypeWorld,
  order : ComponentOrder,
  bind : (Int32) -> QueryColumn[T]?,
  components : Array[QueryComponent],
) -> Query[T] {
  { world_id, storage, order, bind, components, columns: [], matches: [], }
}

///|
fn[T] Query::refresh(self : Query[T]) -> Unit {
  for id in self.columns.length()..<self.storage.tables.length() {
    let column = (self.bind)(id)
    self.columns.push(column)
    if column is Some(column) {
      self.matches.push((id, column))
    }
  }
}

///|
fn[T] Query::for_each_table(
  self : Query[T],
  visit : (Array[Entity], Int32, QueryColumn[T]) -> Unit,
) -> Unit {
  self.refresh()
  enter_query()
  self.storage.active_queries += 1
  defer {
    self.storage.active_queries -= 1
    leave_query()
  }
  for (id, column) in self.matches {
    let entities = self.storage.tables[id].entities
    if !entities.is_empty() {
      visit(entities, id, column)
    }
  }
}

///|
/// Creates a separately cached view with structural filters applied to all operations.
pub fn[T] Query::with_filters(
  self : Query[T],
  filters : Array[EntityFilter],
) -> Query[T] {
  let filters = filters.copy()
  for filter in filters {
    guard filter.world_id == self.world_id else {
      abort("query filter belongs to another World")
    }
  }
  Query(
    self.world_id,
    self.storage,
    self.order,
    id => {
      for filter in filters {
        guard (filter.accepts)(id) else { return None }
      }
      (self.bind)(id)
    },
    self.components,
  )
}

///|
/// Reads one row. Missing, foreign, and deleted entities return None.
pub fn[T] Query::get(self : Query[T], entity : Entity) -> T? {
  guard entity.world_id == self.world_id else { None }
  guard self.storage.location(entity) is Some((id, row)) else { None }
  self.refresh()
  guard self.columns[id] is Some(column) else { None }
  Some((column.read)(row))
}

///|
pub fn[T] Query::contains(self : Query[T], entity : Entity) -> Bool {
  guard entity.world_id == self.world_id else { false }
  guard self.storage.location(entity) is Some((id, _)) else { false }
  self.refresh()
  self.columns[id] is Some(_)
}

///|
/// Visits rows in archetype order without collecting a result array.
pub fn[T] Query::for_each(self : Query[T], visit : (Entity, T) -> Unit) -> Unit {
  self.for_each_table((entities, _, column) => {
    (column.visit_rows)(entities, visit)
  })
}

///|
/// Collects a snapshot. Structural changes after collection cannot invalidate traversal.
/// Component objects inside the snapshot still have MoonBit reference semantics.
pub fn[T] Query::iter(self : Query[T]) -> Array[(Entity, T)] {
  let output = []
  self.for_each((entity, value) => output.push((entity, value)))
  output
}

///|
pub fn[T] Query::to_array(self : Query[T]) -> Array[(Entity, T)] {
  self.iter()
}

///|
/// Captures entity handles in insertion order, then reads each current row.
/// Deleted handles are skipped and newly spawned entities are not visited.
/// No archetype array remains borrowed between iterator steps.
pub fn[T] Query::iter2(self : Query[T]) -> Iter2[Entity, T] {
  let entities = self.keys()
  Iter2::new(() => {
    while entities.next() is Some(entity) {
      if self.get(entity) is Some(value) {
        return Some((entity, value))
      }
    }
    None
  })
}

///|
/// Captures matching handles, so later structural changes cannot invalidate it.
pub fn[T] Query::keys(self : Query[T]) -> Iter[Entity] {
  self.refresh()
  let entities = []
  let mut next = self.order.head
  while next is Some(index) {
    let entry = self.order.entries[index].unwrap()
    next = entry.next
    if self.contains(entry.entity) {
      entities.push(entry.entity)
    }
  }
  entities.iter()
}

///|
pub fn[T] Query::values(self : Query[T]) -> Iter[T] {
  let entries = self.iter2()
  Iter::new(() => entries.next().map(entry => entry.1))
}

///|
pub fn[T] Query::length(self : Query[T]) -> Int32 {
  self.refresh()
  let mut length = 0
  for (id, _) in self.matches {
    length += self.storage.tables[id].entities.length()
  }
  length
}

///|
pub fn[T] Query::is_empty(self : Query[T]) -> Bool {
  self.length() == 0
}

///|
pub fn[T] Query::single(self : Query[T]) -> (Entity, T)? {
  guard self.length() == 1 else { None }
  let mut found = None
  self.for_each((entity, value) => found = Some((entity, value)))
  found
}

///|
/// A stable insertion rank in the query's first component column.
pub fn[T] Query::insertion_order(self : Query[T], entity : Entity) -> Int32 {
  guard self.contains(entity) &&
    self.order.entries.get(entity.slot) is Some(Some(entry)) else {
    abort("entity does not match this query")
  }
  entry.rank
}

///|
pub fn[T] Query::order_span(self : Query[T]) -> Int32 {
  self.order.next_rank
}

///|
pub fn[T : Component] With::With(world : World) -> With[T] {
  { storage: components_in(world), }
}

///|
pub fn[T : Component] Without::Without(world : World) -> Without[T] {
  { storage: components_in(world), }
}

///|
pub fn[T] With::to_filter(self : With[T]) -> EntityFilter {
  {
    world_id: self.storage.world_id,
    accepts: id => self.storage.column(id) is Some(_),
  }
}

///|
pub fn[T] Without::to_filter(self : Without[T]) -> EntityFilter {
  {
    world_id: self.storage.world_id,
    accepts: id => self.storage.column(id) is None,
  }
}
