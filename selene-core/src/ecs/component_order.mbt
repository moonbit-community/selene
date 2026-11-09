///|
priv struct ComponentOrderEntry {
  entity : Entity
  rank : Int32
  mut previous : Int32?
  mut next : Int32?
}

///|
/// The insertion order of one component, independent of archetype row movement.
priv struct ComponentOrder {
  entries : Array[ComponentOrderEntry?]
  mut head : Int32?
  mut tail : Int32?
  mut length : Int32
  mut next_rank : Int32
}

///|
fn ComponentOrder::append(self : ComponentOrder, entity : Entity) -> Unit {
  let index = entity.slot
  while self.entries.length() <= index {
    self.entries.push(None)
  }
  if self.tail is Some(tail) {
    self.entries[tail].unwrap().next = Some(index)
  } else {
    self.head = Some(index)
  }
  self.entries[index] = Some({
    entity,
    rank: self.next_rank,
    previous: self.tail,
    next: None,
  })
  self.tail = Some(index)
  self.length += 1
  self.next_rank += 1
}

///|
fn ComponentOrder::remove(self : ComponentOrder, entity : Entity) -> Unit {
  let index = entity.slot
  let entry = self.entries[index].unwrap()
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
  self.length -= 1
}
