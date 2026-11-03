///|
/// A typed key for a value initialized separately in each World.
struct WorldKey[T] {
  id : Int32
  create : () -> T
  read_slot : Ref[T?]
}

///|
let next_storage_id : Ref[Int32] = Ref(0)

///|
pub fn[T] WorldKey::WorldKey(create : () -> T) -> WorldKey[T] {
  let id = next_storage_id.val
  next_storage_id.val += 1
  { id, create, read_slot: Ref(None), }
}

///|
/// Loads the world's value, initializing it on first access.
pub fn[T] World::get_or_init(self : World, key : WorldKey[T]) -> T {
  match self.storage.get(key.id) {
    Some(load) => {
      // The World owns the value inside this closure. The typed slot is
      // populated only during this synchronous lookup.
      load()
      let value = key.read_slot.val.unwrap()
      key.read_slot.val = None
      value
    }
    None => {
      let value = (key.create)()
      self.storage.set(key.id, () => key.read_slot.val = Some(value))
      value
    }
  }
}
