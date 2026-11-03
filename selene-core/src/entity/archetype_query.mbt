///|
/// A World-bound two-column query. Only new archetypes need to be matched.
struct ArchetypeQuery2[A, B] {
  a : ComponentStore[A]
  b : ComponentStore[B]
  matches : Array[Int32]
  mut scanned : Int32
}

///|
pub fn[A, B] ArchetypeQuery2::ArchetypeQuery2(
  a : ComponentStore[A],
  b : ComponentStore[B],
) -> ArchetypeQuery2[A, B] {
  guard a.world_id == b.world_id else {
    abort("component stores belong to different worlds")
  }
  { a, b, matches: [], scanned: 0, }
}

///|
/// Binds matching columns once per archetype. Queue structural changes after traversal.
pub fn[A, B] ArchetypeQuery2::for_each(
  self : ArchetypeQuery2[A, B],
  visit : (Entity, A, B) -> Unit,
) -> Unit {
  let storage = self.a.storage
  for id in self.scanned..<storage.tables.length() {
    if self.a.column(id) is Some(_) && self.b.column(id) is Some(_) {
      self.matches.push(id)
    }
  }
  self.scanned = storage.tables.length()
  storage.active_queries += 1
  defer {
    storage.active_queries -= 1
  }
  for id in self.matches {
    let entities = storage.tables[id].entities
    let a = self.a.columns[id].unwrap()
    let b = self.b.columns[id].unwrap()
    for row in 0..<entities.length() {
      visit(entities[row], a[row], b[row])
    }
  }
}
