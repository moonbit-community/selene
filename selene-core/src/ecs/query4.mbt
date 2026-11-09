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
  let plan = new_archetype_query(a, [b.world_id, c.world_id, d.world_id], id => {
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
