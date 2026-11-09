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
  let plan = new_archetype_query(a, [b.world_id], id => {
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
