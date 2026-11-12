///|
priv struct EntityTableEntry[T] {
  entity : Entity
  mut value : T
  mut previous : Int32?
  mut next : Int32?
  mut older : Int32?
}

///|
/// World-local runtime data indexed by reusable entity slots. Full handles
/// distinguish generations. Orphaned entries remain available until the owner
/// releases them, even if the entity slot has already been reused.
struct EntityTable[T] {
  world_id : UInt32
  sparse : Array[Int32?]
  entries : Array[EntityTableEntry[T]?]
  free : Array[Int32]
  mut head : Int32?
  mut tail : Int32?
  mut length : Int32
}

///|
pub fn[T] EntityTable::EntityTable(world : World) -> EntityTable[T] {
  {
    world_id: world.id(),
    sparse: [],
    entries: [],
    free: [],
    head: None,
    tail: None,
    length: 0,
  }
}

///|
fn[T] EntityTable::index(self : EntityTable[T], entity : Entity) -> Int32? {
  guard entity.world_id == self.world_id else { None }
  for next = self.sparse.get(entity.slot).unwrap_or(None) {
    guard next is Some(index) else { return None }
    let entry = self.entries[index].unwrap()
    if entry.entity == entity {
      return Some(index)
    }
    continue entry.older
  }
}

///|
pub fn[T] EntityTable::get(self : EntityTable[T], entity : Entity) -> T? {
  self.index(entity).map(index => self.entries[index].unwrap().value)
}

///|
pub fn[T] EntityTable::contains(self : EntityTable[T], entity : Entity) -> Bool {
  self.index(entity) is Some(_)
}

///|
pub fn[T] EntityTable::set(
  self : EntityTable[T],
  entity : Entity,
  value : T,
) -> Unit {
  guard entity.world_id == self.world_id else {
    abort("entity table belongs to another World")
  }
  while self.sparse.length() <= entity.slot {
    self.sparse.push(None)
  }
  let older = self.sparse[entity.slot]
  if older is Some(index) {
    let entry = self.entries[index].unwrap()
    if entry.entity == entity {
      entry.value = value
      return
    }
    guard entity.generation > entry.entity.generation else {
      abort("stale entity table write")
    }
  }
  let entry = { entity, value, previous: self.tail, next: None, older, }
  let index = match self.free.pop() {
    Some(index) => {
      self.entries[index] = Some(entry)
      index
    }
    None => {
      let index = self.entries.length()
      self.entries.push(Some(entry))
      index
    }
  }
  if self.tail is Some(tail) {
    self.entries[tail].unwrap().next = Some(index)
  } else {
    self.head = Some(index)
  }
  self.tail = Some(index)
  self.sparse[entity.slot] = Some(index)
  self.length += 1
}

///|
pub fn[T] EntityTable::get_or_init(
  self : EntityTable[T],
  entity : Entity,
  create : () -> T,
) -> T {
  match self.get(entity) {
    Some(value) => value
    None => {
      let value = create()
      self.set(entity, value)
      value
    }
  }
}

///|
pub fn[T] EntityTable::remove_and_get(
  self : EntityTable[T],
  entity : Entity,
) -> T? {
  guard self.index(entity) is Some(index) else { None }
  let entry = self.entries[index].unwrap()
  if self.sparse[entity.slot] == Some(index) {
    self.sparse[entity.slot] = entry.older
  } else {
    for next = self.sparse[entity.slot] {
      guard next is Some(newer) else {
        abort("entity table generation chain is missing")
      }
      let newer_entry = self.entries[newer].unwrap()
      if newer_entry.older == Some(index) {
        newer_entry.older = entry.older
        break
      }
      continue newer_entry.older
    }
  }
  if entry.previous is Some(previous) {
    self.entries[previous].unwrap().next = entry.next
  } else {
    self.head = entry.next
  }
  if entry.next is Some(next) {
    self.entries[next].unwrap().previous = entry.previous
  } else {
    self.tail = entry.previous
  }
  self.entries[index] = None
  self.free.push(index)
  self.length -= 1
  Some(entry.value)
}

///|
pub fn[T] EntityTable::remove(self : EntityTable[T], entity : Entity) -> Unit {
  ignore(self.remove_and_get(entity))
}

///|
pub fn[T] EntityTable::length(self : EntityTable[T]) -> Int32 {
  self.length
}

///|
pub fn[T] EntityTable::is_empty(self : EntityTable[T]) -> Bool {
  self.length == 0
}

///|
pub fn[T] EntityTable::clear(self : EntityTable[T]) -> Unit {
  for next = self.head {
    guard next is Some(index) else { break }
    let entry = self.entries[index].unwrap()
    self.sparse[entry.entity.slot] = None
    self.entries[index] = None
    self.free.push(index)
    continue entry.next
  }
  self.head = None
  self.tail = None
  self.length = 0
}

///|
/// Visits entries in insertion order. Do not structurally modify this table
/// while iterating; use retain or collect only the pending changes instead.
pub fn[T] EntityTable::iter2(self : EntityTable[T]) -> Iter2[Entity, T] {
  let mut next = self.head
  Iter2::new(
    () => {
      guard next is Some(index) && self.entries[index] is Some(entry) else {
        None
      }
      next = entry.next
      Some((entry.entity, entry.value))
    },
    size_hint=self.length,
  )
}

///|
pub fn[T] EntityTable::iter(self : EntityTable[T]) -> Iter[(Entity, T)] {
  let entries = self.iter2()
  Iter::new(() => entries.next())
}

///|
pub fn[T] EntityTable::keys(self : EntityTable[T]) -> Iter[Entity] {
  let mut next = self.head
  Iter::new(
    () => {
      guard next is Some(index) && self.entries[index] is Some(entry) else {
        None
      }
      next = entry.next
      Some(entry.entity)
    },
    size_hint=self.length,
  )
}

///|
pub fn[T] EntityTable::values(self : EntityTable[T]) -> Iter[T] {
  let mut next = self.head
  Iter::new(
    () => {
      guard next is Some(index) && self.entries[index] is Some(entry) else {
        None
      }
      next = entry.next
      Some(entry.value)
    },
    size_hint=self.length,
  )
}

///|
pub fn[T] EntityTable::to_array(self : EntityTable[T]) -> Array[(Entity, T)] {
  self.iter().collect()
}

///|
/// Removes entries in place, preserving insertion order. The predicate must
/// not structurally modify this table, including through another reference.
pub fn[T] EntityTable::retain(
  self : EntityTable[T],
  keep : (Entity, T) -> Bool,
) -> Unit {
  for next = self.head {
    guard next is Some(index) else { break }
    let entry = self.entries[index].unwrap()
    let following = entry.next
    if !keep(entry.entity, entry.value) {
      self.remove(entry.entity)
    }
    continue following
  }
}
