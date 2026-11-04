///|
/// A World-bound two-column query. Only new archetypes need to be matched.
struct Query2[A, B] {
  a : ComponentStore[A]
  b : ComponentStore[B]
  matches : Array[Int32]
  mut scanned : Int32
}

///|
pub fn[A, B] Query2::Query2(
  a : ComponentStore[A],
  b : ComponentStore[B],
) -> Query2[A, B] {
  guard a.world_id == b.world_id else {
    abort("component stores belong to different worlds")
  }
  { a, b, matches: [], scanned: 0, }
}

///|
fn[A, B] Query2::for_each_columns(
  self : Query2[A, B],
  visit : (Array[Entity], Array[A], Array[B]) -> Unit,
) -> Unit {
  let storage = self.a.storage
  for id in self.scanned..<storage.tables.length() {
    if self.a.column(id) is Some(_) && self.b.column(id) is Some(_) {
      self.matches.push(id)
    }
  }
  self.scanned = storage.tables.length()
  enter_query()
  storage.active_queries += 1
  defer {
    storage.active_queries -= 1
    leave_query()
  }
  for id in self.matches {
    let entities = storage.tables[id].entities
    if !entities.is_empty() {
      visit(entities, self.a.columns[id].unwrap(), self.b.columns[id].unwrap())
    }
  }
}

///|
/// Visits matching rows. Queue structural changes after traversal.
pub fn[A, B] Query2::for_each(
  self : Query2[A, B],
  visit : (Entity, A, B) -> Unit,
) -> Unit {
  self.for_each_columns((entities, a, b) => {
    for row in 0..<entities.length() {
      visit(entities[row], a[row], b[row])
    }
  })
}

///|
/// Visits each nonempty matching archetype with aligned, zero-copy columns.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
pub fn[A, B] Query2::for_each_batch(
  self : Query2[A, B],
  visit : (ArrayView[Entity], ArrayView[A], ArrayView[B]) -> Unit,
) -> Unit {
  self.for_each_columns((entities, a, b) => visit(entities[:], a[:], b[:]))
}

///|
/// Visits each batch with write access to its first component column.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
/// If both query inputs are the same store, the second view observes the writes.
pub fn[A, B] Query2::for_each_batch_mut_a(
  self : Query2[A, B],
  visit : (ArrayView[Entity], MutArrayView[A], ArrayView[B]) -> Unit,
) -> Unit {
  self.for_each_columns((entities, a, b) => {
    visit(entities[:], a.mut_view(), b[:])
  })
}
