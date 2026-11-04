///|
/// Declares one component identity that can be used in multiple Worlds.
struct ComponentKey[T] {
  key : @ecs.WorldKey[ComponentStore[T]]
}

///|
pub fn[T] ComponentKey::ComponentKey() -> ComponentKey[T] {
  { key: @ecs.WorldKey::with_world(world => ComponentStore(world)), }
}

///|
pub fn[T] ComponentKey::store_in(
  self : ComponentKey[T],
  world : @ecs.World,
) -> ComponentStore[T] {
  world.get_or_init(self.key)
}

///|
pub fn[T] ComponentKey::store(self : ComponentKey[T]) -> ComponentStore[T] {
  self.store_in(@ecs.require_current_world())
}

///|
pub fn[T] ComponentKey::get(self : ComponentKey[T], entity : Entity) -> T? {
  self.store().get(entity)
}

///|
pub fn[T] ComponentKey::set(
  self : ComponentKey[T],
  entity : Entity,
  value : T,
) -> Unit {
  self.store().set(entity, value)
}

///|
/// Provides the default component key for a type.
pub(open) trait Component {
  fn component_key() -> ComponentKey[Self]
}

///|
pub fn[T : Component] components_in(world : @ecs.World) -> ComponentStore[T] {
  let key : ComponentKey[T] = Component::component_key()
  key.store_in(world)
}

///|
pub fn[T : Component] components() -> ComponentStore[T] {
  components_in(@ecs.require_current_world())
}
