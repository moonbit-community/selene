///|
priv struct AssetEntry[T] {
  mut value : T?
  mut alive : Bool
  invalidations : Array[() -> Unit]
}

///|
/// A typed identity. Copies refer to the same entry; removing it invalidates all copies.
struct Handle[T] {
  id : UInt32
  owner : UInt32
  entry : AssetEntry[T]
}

///|
pub fn[T] Handle::id(self : Handle[T]) -> UInt32 {
  self.id
}

///|
/// Reads the current asset without retaining its owning collection.
pub fn[T] Handle::get(self : Handle[T]) -> T? {
  self.entry.value
}

///|
pub fn[T] Handle::is_alive(self : Handle[T]) -> Bool {
  self.entry.alive
}

///|
/// Runs once when the entry is replaced or removed. Used to invalidate prepared resources.
pub fn[T] Handle::on_invalidate(
  self : Handle[T],
  callback : () -> Unit,
) -> Unit {
  if self.entry.alive {
    self.entry.invalidations.push(callback)
  } else {
    callback()
  }
}

///|
pub impl[T] Eq for Handle[T] with fn equal(self, other) {
  self.id == other.id
}

///|
pub extend Handle with Eq::{equal, not_equal}

///|
pub impl[T] Hash for Handle[T] with fn hash_combine(self, hasher) {
  Hash::hash_combine(self.id, hasher)
}

///|
pub extend Handle with Hash::{hash, hash_combine}

///|
pub impl[T] @debug.Debug for Handle[T] with fn to_repr(self) {
  @debug.Repr::literal("Handle(\{self.id})")
}

///|
pub extend Handle with @debug.Debug::{to_repr}

///|
pub type ImageHandle = Handle[Image]

///|
pub type AudioHandle = Handle[Audio]

///|
pub type FontHandle = Handle[Font]

///|
pub impl[T] ToJson for Handle[T] with fn to_json(self) {
  ToJson::to_json(self.id)
}

///|
pub extend Handle with ToJson::{to_json}
