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
/// Lazily visits rows in archetype order without collecting a snapshot.
/// Structural row changes invalidate the iterator; value writes do not.
pub fn[T] Query::iter(self : Query[T]) -> Iter[(Entity, T)] {
  self.iter2().iter()
}

///|
/// Explicitly collects a shallow snapshot of entity handles and component values.
pub fn[T] Query::to_array(self : Query[T]) -> Array[(Entity, T)] {
  self.iter().collect()
}

///|
fn ArchetypeWorld::check_iteration(
  self : ArchetypeWorld,
  version : UInt64,
) -> Unit {
  guard self.structural_version == version else {
    abort("query iterator invalidated by structural changes in its World")
  }
}

///|
/// Lazily reads matching archetype rows for two-variable for loops.
/// No query lock survives a step. Structural changes are detected before the
/// next read, so early exit never requires releasing a traversal guard.
pub fn[T] Query::iter2(self : Query[T]) -> Iter2[Entity, T] {
  let version = self.storage.structural_version
  let mut started = false
  let mut finished = false
  let mut table = 0
  let mut row = 0
  Iter2::new(() => {
    guard !finished else { return None }
    self.storage.check_iteration(version)
    if !started {
      self.refresh()
      started = true
    }
    while table < self.matches.length() {
      let (id, column) = self.matches[table]
      let entities = self.storage.tables[id].entities
      if row < entities.length() {
        let entry = (entities[row], (column.read)(row))
        row += 1
        return Some(entry)
      }
      table += 1
      row = 0
    }
    finished = true
    None
  })
}

///|
/// Lazily visits matching entity handles in the first component's insertion order.
/// Uses the same structural invalidation rule as row iterators.
pub fn[T] Query::keys(self : Query[T]) -> Iter[Entity] {
  let version = self.storage.structural_version
  let mut next = self.order.head
  Iter::new(() => {
    guard next is Some(_) else { return None }
    self.storage.check_iteration(version)
    while next is Some(index) {
      let entry = self.order.entries[index].unwrap()
      next = entry.next
      if self.contains(entry.entity) {
        return Some(entry.entity)
      }
    }
    None
  })
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
  self.iter().next()
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
