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
struct VisibilityState {
  inherited : @ecs.EntityTable[InheritedVisibility]
  view : @ecs.EntityTable[ViewVisibility]
}

///|
fn visibility_state(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> VisibilityState {
  visibility_state_key.get_or_insert_with(world, world => {
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
  hierarchy : @ecs.Hierarchy,
  visibilities : @ecs.Query[@ecs.Single[Visibility]],
  entity : @ecs.Entity,
  cache : @ecs.EntityTable[InheritedVisibility],
) -> Bool {
  if cache.get(entity) is Some(visible) {
    return visible.visible
  }
  let own_visible = visibilities
    .get(entity)
    .map(value => value.0)
    .unwrap_or(Visible)
    is Visible
  let parent_visible = match hierarchy.parent(entity) {
    Some(parent) =>
      compute_inherited_visibility(hierarchy, visibilities, parent, cache)
    None => true
  }
  let visible = own_visible && parent_visible
  cache.set(entity, { visible, })
  visible
}

///|
pub fn visibility_propagate_system(
  entities : @ecs.Entities,
  hierarchy : @ecs.Hierarchy,
  visibilities : @ecs.Query[@ecs.Single[Visibility]],
  state : VisibilityState,
) -> Unit {
  let inherited_visibilities = state.inherited
  let view_visibilities = state.view
  inherited_visibilities.clear()
  view_visibilities.clear()
  for entity in entities.iter() {
    guard entities.is_alive(entity) else { continue }
    let visible = compute_inherited_visibility(
      hierarchy, visibilities, entity, inherited_visibilities,
    )
    view_visibilities.set(entity, { visible, })
  }
  inherited_visibilities.retain((entity, _) => entities.is_alive(entity))
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

///|
pub fn VisibilityState::VisibilityState(world : @ecs.World) -> VisibilityState {
  visibility_state(world~)
}

///|
pub fn VisibilityState::is_visible(
  self : VisibilityState,
  entity : @ecs.Entity,
) -> Bool {
  self.view.get(entity).map_or(true, value => value.visible)
}

///|
pub impl @ecs.SystemParam for VisibilityState with fn prepare(world) {
  let state = VisibilityState(world)
  _ => state
}

///|
pub extend VisibilityState with @ecs.SystemParam::{prepare}
