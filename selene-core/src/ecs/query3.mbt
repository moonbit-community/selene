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
  let plan = new_archetype_query(a, [b.world_id, c.world_id], id => {
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
