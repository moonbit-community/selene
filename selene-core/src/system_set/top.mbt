///|
pub(all) struct SystemSet {
  name : String

  fn new(name : String) -> SystemSet
} derive(Eq, Debug, Hash)

///|
pub(all) struct SystemOrdering {
  set : SystemSet?
  before : Array[SystemSet]
  after : Array[SystemSet]
}

///|
pub fn SystemSet::new(name : String) -> SystemSet {
  { name, }
}

///|
pub fn named(name : String) -> SystemSet {
  SystemSet::new(name)
}

///|
pub fn in_set(set : SystemSet) -> SystemOrdering {
  { set: Some(set), before: [], after: [] }
}

///|
pub fn before(set : SystemSet) -> SystemOrdering {
  { set: None, before: [set], after: [] }
}

///|
pub fn after(set : SystemSet) -> SystemOrdering {
  { set: None, before: [], after: [set] }
}

///|
pub fn SystemOrdering::with_before(
  self : SystemOrdering,
  set : SystemSet,
) -> SystemOrdering {
  let before = self.before.copy()
  before.push(set)
  { ..self, before, }
}

///|
pub fn SystemOrdering::with_after(
  self : SystemOrdering,
  set : SystemSet,
) -> SystemOrdering {
  let after = self.after.copy()
  after.push(set)
  { ..self, after, }
}

///|
pub fn SystemOrdering::with_set(
  self : SystemOrdering,
  set : SystemSet,
) -> SystemOrdering {
  { ..self, set: Some(set) }
}

///|
pub fn merge(lhs : SystemOrdering, rhs : SystemOrdering) -> SystemOrdering {
  let set = match rhs.set {
    Some(current) => Some(current)
    None => lhs.set
  }
  let before = lhs.before.copy()
  before.append(rhs.before)
  let after = lhs.after.copy()
  after.append(rhs.after)
  { set, before, after }
}
