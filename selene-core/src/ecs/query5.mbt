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
  let plan = new_archetype_query(
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
