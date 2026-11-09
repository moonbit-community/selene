///|
/// A typed key for a value initialized separately in each World.
priv struct WorldKey[T] {
  id : Int32
  create : (World) -> T
  read_slot : Ref[T?]
}

///|
let next_storage_id : Ref[Int32] = Ref(0)

///|
/// Creates a key whose initializer receives the World that owns the value.
fn[T] WorldKey::with_world(create : (World) -> T) -> WorldKey[T] {
  let id = next_storage_id.val
  next_storage_id.val += 1
  { id, create, read_slot: Ref(None), }
}

///|
/// Loads the world's value, initializing it on first access.
fn[T] World::get_or_init(self : World, key : WorldKey[T]) -> T {
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
      let value = (key.create)(self)
      self.storage.set(key.id, () => key.read_slot.val = Some(value))
      value
    }
  }
}
