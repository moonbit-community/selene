///|
let next_identity : Ref[UInt32] = Ref(0U)

///|
fn allocate_identity() -> UInt32 {
  guard next_identity.val < 0xFFFFFFFFU else {
    abort("Asset identity exhausted")
  }
  next_identity.val += 1U
  next_identity.val
}

///|
/// A collection of resource values. Registration does not decode or upload data.
struct Assets[T] {
  id : UInt32
  entries : Map[UInt32, Handle[T]]
}

///|
pub fn[T] Assets::Assets() -> Assets[T] {
  { id: allocate_identity(), entries: Map([]), }
}

///|
/// Reserves an identity for an asset which has not finished loading.
pub fn[T] Assets::reserve(self : Assets[T]) -> Handle[T] {
  let handle = {
    id: allocate_identity(),
    owner: self.id,
    entry: { value: None, alive: true, invalidations: [], },
  }
  self.entries[handle.id] = handle
  handle
}

///|
pub fn[T] Assets::add(self : Assets[T], value : T) -> Handle[T] {
  let handle = self.reserve()
  handle.entry.value = Some(value)
  handle
}

///|
pub fn[T] Assets::get(self : Assets[T], handle : Handle[T]) -> T? {
  if handle.owner == self.id {
    handle.get()
  } else {
    None
  }
}

///|
fn[T] invalidate(entry : AssetEntry[T]) -> Unit {
  let callbacks = entry.invalidations.copy()
  entry.invalidations.clear()
  for callback in callbacks {
    callback()
  }
}

///|
/// Replaces an owned entry, including an identity reserved by the loader.
/// Removed entries and handles from another collection are rejected.
pub fn[T] Assets::insert(
  self : Assets[T],
  handle : Handle[T],
  value : T,
) -> Bool {
  guard handle.owner == self.id && handle.entry.alive else { return false }
  handle.entry.value = Some(value)
  invalidate(handle.entry)
  true
}

///|
pub fn[T] Assets::remove(self : Assets[T], handle : Handle[T]) -> T? {
  guard handle.owner == self.id && handle.entry.alive else { return None }
  let value = handle.entry.value
  handle.entry.value = None
  handle.entry.alive = false
  self.entries.remove(handle.id)
  invalidate(handle.entry)
  value
}

///|
/// Includes reserved entries whose loading has not completed.
pub fn[T] Assets::length(self : Assets[T]) -> Int32 {
  self.entries.length()
}
