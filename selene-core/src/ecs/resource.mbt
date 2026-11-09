///|
/// A reusable identity for a resource stored separately in each World.
struct ResourceKey[T] {
  key : WorldKey[Ref[T?]]
}

///|
pub fn[T] ResourceKey::ResourceKey() -> ResourceKey[T] {
  { key: WorldKey::with_world(_ => Ref(None)), }
}

///|
/// Returns the resource if it has been inserted into this World.
pub fn[T] ResourceKey::get_in(self : ResourceKey[T], world : World) -> T? {
  world.get_or_init(self.key).val
}

///|
/// Inserts a resource, replacing the previous value in this World.
pub fn[T] ResourceKey::insert_in(
  self : ResourceKey[T],
  world : World,
  value : T,
) -> Unit {
  world.get_or_init(self.key).val = Some(value)
}

///|
/// Returns an existing value or explicitly initializes it for this World.
pub fn[T] ResourceKey::get_or_insert_with(
  self : ResourceKey[T],
  world : World,
  create : (World) -> T,
) -> T {
  match self.get_in(world) {
    Some(value) => value
    None => {
      let value = create(world)
      self.insert_in(world, value)
      value
    }
  }
}

///|
/// Provides the default resource identity for a type.
pub(open) trait Resource {
  fn resource_key() -> ResourceKey[Self]
}

///|
/// Inserts a resource, replacing an existing value of the same type.
pub fn[T : Resource] World::insert_resource(self : World, value : T) -> Unit {
  let key : ResourceKey[T] = Resource::resource_key()
  key.insert_in(self, value)
}

///|
/// Returns None when the resource has not been inserted.
pub fn[T : Resource] World::get_resource(self : World) -> T? {
  let key : ResourceKey[T] = Resource::resource_key()
  key.get_in(self)
}

///|
/// Returns an inserted resource. Aborts if initialization was omitted.
pub fn[T : Resource] World::resource(self : World) -> T {
  match self.get_resource() {
    Some(value) => value
    None => abort("Resource is not initialized. Insert it before accessing it.")
  }
}
