///|
/// Declares one component identity that can be used in multiple Worlds.
struct ComponentKey[T] {
  key : WorldKey[ComponentStore[T]]
}

///|
pub fn[T] ComponentKey::ComponentKey() -> ComponentKey[T] {
  { key: WorldKey::with_world(world => ComponentStore(world)), }
}

///|
fn[T] ComponentKey::store_in(
  self : ComponentKey[T],
  world : World,
) -> ComponentStore[T] {
  world.get_or_init(self.key)
}

///|
/// Provides the default component key for a type.
pub(open) trait Component {
  fn component_key() -> ComponentKey[Self]
}

///|
fn[T : Component] components_in(world : World) -> ComponentStore[T] {
  let key : ComponentKey[T] = Component::component_key()
  key.store_in(world)
}

///|
/// Reads an existing component in this World. Foreign and stale handles return None.
pub fn[T : Component] World::get_component(self : World, entity : Entity) -> T? {
  let store : ComponentStore[T] = components_in(self)
  store.get(entity)
}

///|
/// Replaces an existing component; never changes an entity's component layout.
pub fn[T : Component] World::set_component(
  self : World,
  entity : Entity,
  value : T,
) -> Unit {
  let store : ComponentStore[T] = components_in(self)
  store.set(entity, value)
}
