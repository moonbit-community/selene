///|
#derive(Eq, Debug)
#selene.component
pub(all) enum Visibility {
  Visible
  Hidden
}

///|
pub extend Visibility with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Visibility with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct InheritedVisibility {
  visible : Bool
}

///|
pub extend InheritedVisibility with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend InheritedVisibility with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct ViewVisibility {
  visible : Bool
}

///|
pub extend ViewVisibility with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ViewVisibility with Eq::{not_equal, equal}

///|
let visibility_state_key : @ecs.ResourceKey[VisibilityState] = ResourceKey()

///|
priv struct VisibilityState {
  inherited : @ecs.EntityTable[InheritedVisibility]
  view : @ecs.EntityTable[ViewVisibility]
}

///|
fn visibility_state() -> VisibilityState {
  visibility_state_key.get_or_insert_with(@ecs.require_current_world(), world => {
    inherited: EntityTable(world),
    view: EntityTable(world),
  })
}

///|
fn inherited_visibilities() -> @ecs.EntityTable[InheritedVisibility] {
  visibility_state().inherited
}

///|
fn view_visibilities() -> @ecs.EntityTable[ViewVisibility] {
  visibility_state().view
}

///|
fn compute_inherited_visibility(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  cache : @ecs.EntityTable[InheritedVisibility],
) -> Bool {
  if cache.get(entity) is Some(visible) {
    return visible.visible
  }
  let own_visible = (world.get_component(entity) : Visibility?).unwrap_or(
      Visible,
    )
    is Visible
  let parent_visible = match entity.get_parent() {
    Some(parent) => compute_inherited_visibility(world~, parent, cache)
    None => true
  }
  let visible = own_visible && parent_visible
  cache.set(entity, { visible, })
  visible
}

///|
pub fn visibility_propagate_system(
  world~ : @ecs.World,
  _delta : Double,
) -> Unit {
  let inherited_visibilities = inherited_visibilities()
  let view_visibilities = view_visibilities()
  inherited_visibilities.clear()
  view_visibilities.clear()
  for entity in @ecs.iter_entities() {
    guard entity.is_alive() else { continue }
    let visible = compute_inherited_visibility(
      world~,
      entity,
      inherited_visibilities,
    )
    view_visibilities.set(entity, { visible, })
  }
  inherited_visibilities.retain((entity, _) => entity.is_alive())
}

///|
pub fn is_visible(entity : @ecs.Entity) -> Bool {
  view_visibilities().get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}

///|
/// Reads inherited visibility produced by the latest propagation pass.
pub fn inherited_visibility(entity : @ecs.Entity) -> InheritedVisibility? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  inherited_visibilities().get(entity)
}

///|
/// Reads view visibility produced by the latest propagation pass.
pub fn view_visibility(entity : @ecs.Entity) -> ViewVisibility? {
  guard entity.is_valid_in(@ecs.require_current_world()) else { None }
  view_visibilities().get(entity)
}
