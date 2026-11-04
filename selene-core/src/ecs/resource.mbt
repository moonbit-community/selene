///|
/// A reusable key for a resource with one value per World.
struct ResourceKey[T] {
  key : WorldKey[T]
}

///|
pub fn[T] ResourceKey::ResourceKey(create : (World) -> T) -> ResourceKey[T] {
  { key: WorldKey::with_world(create), }
}

///|
pub fn[T] ResourceKey::get_in(self : ResourceKey[T], world : World) -> T {
  world.get_or_init(self.key)
}

///|
pub fn[T] ResourceKey::get(self : ResourceKey[T]) -> T {
  self.get_in(require_current_world())
}

///|
/// Provides the default resource key for a type.
pub(open) trait Resource {
  fn resource_key() -> ResourceKey[Self]
}

///|
pub fn[T : Resource] resource_in(world : World) -> T {
  let key : ResourceKey[T] = Resource::resource_key()
  key.get_in(world)
}

///|
pub fn[T : Resource] resource() -> T {
  resource_in(require_current_world())
}
