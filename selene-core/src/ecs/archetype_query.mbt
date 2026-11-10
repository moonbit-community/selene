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
fn[A, Columns] ArchetypeQuery::ArchetypeQuery(
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

///|
/// A World-bound 2-column query. Only new archetypes need to be matched.
struct Query2[A, B] {
  plan : ArchetypeQuery[(Array[A], Array[B])]
}

///|
pub fn[A, B] Query2::Query2(
  a : ComponentStore[A],
  b : ComponentStore[B],
) -> Query2[A, B] {
  let plan = ArchetypeQuery(a, [b.world_id], id => {
    guard a.column(id) is Some(column_a) else { None }
    guard b.column(id) is Some(column_b) else { None }
    Some((column_a, column_b))
  })
  { plan, }
}

///|
/// Reads a matching entity in this World without scanning archetypes.
pub fn[A, B] Query2::get(self : Query2[A, B], entity : Entity) -> (A, B)? {
  guard self.plan.location(entity) is Some((id, row)) else { None }
  guard (self.plan.bind)(id) is Some((a, b)) else { None }
  Some((a[row], b[row]))
}

///|
/// Visits matching rows. Queue structural changes after traversal.
pub fn[A, B] Query2::for_each(
  self : Query2[A, B],
  visit : (Entity, A, B) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b) = columns
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
  self.plan.for_each_table((entities, columns) => {
    let (a, b) = columns
    visit(entities[:], a[:], b[:])
  })
}

///|
/// Visits each batch with write access to its first component column.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
/// Any other view of the first store observes those writes.
pub fn[A, B] Query2::for_each_batch_mut_a(
  self : Query2[A, B],
  visit : (ArrayView[Entity], MutArrayView[A], ArrayView[B]) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b) = columns
    visit(entities[:], a.mut_view(), b[:])
  })
}

///|
/// A World-bound 3-column query. Only new archetypes need to be matched.
struct Query3[A, B, C] {
  plan : ArchetypeQuery[(Array[A], Array[B], Array[C])]
}

///|
pub fn[A, B, C] Query3::Query3(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
) -> Query3[A, B, C] {
  let plan = ArchetypeQuery(a, [b.world_id, c.world_id], id => {
    guard a.column(id) is Some(column_a) else { None }
    guard b.column(id) is Some(column_b) else { None }
    guard c.column(id) is Some(column_c) else { None }
    Some((column_a, column_b, column_c))
  })
  { plan, }
}

///|
/// Reads a matching entity in this World without scanning archetypes.
pub fn[A, B, C] Query3::get(
  self : Query3[A, B, C],
  entity : Entity,
) -> (A, B, C)? {
  guard self.plan.location(entity) is Some((id, row)) else { None }
  guard (self.plan.bind)(id) is Some((a, b, c)) else { None }
  Some((a[row], b[row], c[row]))
}

///|
/// Visits matching rows. Queue structural changes after traversal.
pub fn[A, B, C] Query3::for_each(
  self : Query3[A, B, C],
  visit : (Entity, A, B, C) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c) = columns
    for row in 0..<entities.length() {
      visit(entities[row], a[row], b[row], c[row])
    }
  })
}

///|
/// Visits each nonempty matching archetype with aligned, zero-copy columns.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
pub fn[A, B, C] Query3::for_each_batch(
  self : Query3[A, B, C],
  visit : (ArrayView[Entity], ArrayView[A], ArrayView[B], ArrayView[C]) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c) = columns
    visit(entities[:], a[:], b[:], c[:])
  })
}

///|
/// Visits each batch with write access to its first component column.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
/// Any other view of the first store observes those writes.
pub fn[A, B, C] Query3::for_each_batch_mut_a(
  self : Query3[A, B, C],
  visit : (ArrayView[Entity], MutArrayView[A], ArrayView[B], ArrayView[C]) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c) = columns
    visit(entities[:], a.mut_view(), b[:], c[:])
  })
}

///|
/// A World-bound 4-column query. Only new archetypes need to be matched.
struct Query4[A, B, C, D] {
  plan : ArchetypeQuery[(Array[A], Array[B], Array[C], Array[D])]
}

///|
pub fn[A, B, C, D] Query4::Query4(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
) -> Query4[A, B, C, D] {
  let plan = ArchetypeQuery(a, [b.world_id, c.world_id, d.world_id], id => {
    guard a.column(id) is Some(column_a) else { None }
    guard b.column(id) is Some(column_b) else { None }
    guard c.column(id) is Some(column_c) else { None }
    guard d.column(id) is Some(column_d) else { None }
    Some((column_a, column_b, column_c, column_d))
  })
  { plan, }
}

///|
/// Reads a matching entity in this World without scanning archetypes.
pub fn[A, B, C, D] Query4::get(
  self : Query4[A, B, C, D],
  entity : Entity,
) -> (A, B, C, D)? {
  guard self.plan.location(entity) is Some((id, row)) else { None }
  guard (self.plan.bind)(id) is Some((a, b, c, d)) else { None }
  Some((a[row], b[row], c[row], d[row]))
}

///|
/// Visits matching rows. Queue structural changes after traversal.
pub fn[A, B, C, D] Query4::for_each(
  self : Query4[A, B, C, D],
  visit : (Entity, A, B, C, D) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d) = columns
    for row in 0..<entities.length() {
      visit(entities[row], a[row], b[row], c[row], d[row])
    }
  })
}

///|
/// Visits each nonempty matching archetype with aligned, zero-copy columns.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
pub fn[A, B, C, D] Query4::for_each_batch(
  self : Query4[A, B, C, D],
  visit : (
    ArrayView[Entity],
    ArrayView[A],
    ArrayView[B],
    ArrayView[C],
    ArrayView[D],
  ) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d) = columns
    visit(entities[:], a[:], b[:], c[:], d[:])
  })
}

///|
/// Visits each batch with write access to its first component column.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
/// Any other view of the first store observes those writes.
pub fn[A, B, C, D] Query4::for_each_batch_mut_a(
  self : Query4[A, B, C, D],
  visit : (
    ArrayView[Entity],
    MutArrayView[A],
    ArrayView[B],
    ArrayView[C],
    ArrayView[D],
  ) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d) = columns
    visit(entities[:], a.mut_view(), b[:], c[:], d[:])
  })
}

///|
/// A World-bound 5-column query. Only new archetypes need to be matched.
struct Query5[A, B, C, D, E] {
  plan : ArchetypeQuery[(Array[A], Array[B], Array[C], Array[D], Array[E])]
}

///|
pub fn[A, B, C, D, E] Query5::Query5(
  a : ComponentStore[A],
  b : ComponentStore[B],
  c : ComponentStore[C],
  d : ComponentStore[D],
  e : ComponentStore[E],
) -> Query5[A, B, C, D, E] {
  let plan = ArchetypeQuery(
    a,
    [b.world_id, c.world_id, d.world_id, e.world_id],
    id => {
      guard a.column(id) is Some(column_a) else { None }
      guard b.column(id) is Some(column_b) else { None }
      guard c.column(id) is Some(column_c) else { None }
      guard d.column(id) is Some(column_d) else { None }
      guard e.column(id) is Some(column_e) else { None }
      Some((column_a, column_b, column_c, column_d, column_e))
    },
  )
  { plan, }
}

///|
/// Reads a matching entity in this World without scanning archetypes.
pub fn[A, B, C, D, E] Query5::get(
  self : Query5[A, B, C, D, E],
  entity : Entity,
) -> (A, B, C, D, E)? {
  guard self.plan.location(entity) is Some((id, row)) else { None }
  guard (self.plan.bind)(id) is Some((a, b, c, d, e)) else { None }
  Some((a[row], b[row], c[row], d[row], e[row]))
}

///|
/// Visits matching rows. Queue structural changes after traversal.
pub fn[A, B, C, D, E] Query5::for_each(
  self : Query5[A, B, C, D, E],
  visit : (Entity, A, B, C, D, E) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d, e) = columns
    for row in 0..<entities.length() {
      visit(entities[row], a[row], b[row], c[row], d[row], e[row])
    }
  })
}

///|
/// Visits each nonempty matching archetype with aligned, zero-copy columns.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
pub fn[A, B, C, D, E] Query5::for_each_batch(
  self : Query5[A, B, C, D, E],
  visit : (
    ArrayView[Entity],
    ArrayView[A],
    ArrayView[B],
    ArrayView[C],
    ArrayView[D],
    ArrayView[E],
  ) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d, e) = columns
    visit(entities[:], a[:], b[:], c[:], d[:], e[:])
  })
}

///|
/// Visits each batch with write access to its first component column.
/// Views are valid only during the callback. Defer structural changes until traversal finishes.
/// Any other view of the first store observes those writes.
pub fn[A, B, C, D, E] Query5::for_each_batch_mut_a(
  self : Query5[A, B, C, D, E],
  visit : (
    ArrayView[Entity],
    MutArrayView[A],
    ArrayView[B],
    ArrayView[C],
    ArrayView[D],
    ArrayView[E],
  ) -> Unit,
) -> Unit {
  self.plan.for_each_table((entities, columns) => {
    let (a, b, c, d, e) = columns
    visit(entities[:], a.mut_view(), b[:], c[:], d[:], e[:])
  })
}
