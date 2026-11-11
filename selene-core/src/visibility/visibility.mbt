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
pub fn visibilities() -> @ecs.ComponentStore[Visibility] {
  @ecs.components()
}

///|
let visibility_state_key : @ecs.ResourceKey[VisibilityState] = ResourceKey()

///|
priv struct VisibilityState {
  inherited : Map[@ecs.Entity, InheritedVisibility]
  view : Map[@ecs.Entity, ViewVisibility]
}

///|
fn visibility_state() -> VisibilityState {
  visibility_state_key.get_or_insert_with(@ecs.require_current_world(), _ => {
    inherited: {},
    view: {},
  })
}

///|
pub fn inherited_visibilities() -> Map[@ecs.Entity, InheritedVisibility] {
  visibility_state().inherited
}

///|
pub fn view_visibilities() -> Map[@ecs.Entity, ViewVisibility] {
  visibility_state().view
}

///|
fn compute_inherited_visibility(
  entity : @ecs.Entity,
  cache : Map[@ecs.Entity, Bool],
) -> Bool {
  if cache.get(entity) is Some(visible) {
    return visible
  }
  let own_visible = visibilities().get(entity).unwrap_or(Visible) is Visible
  let parent_visible = match entity.get_parent() {
    Some(parent) => compute_inherited_visibility(parent, cache)
    None => true
  }
  let visible = own_visible && parent_visible
  cache.set(entity, visible)
  visible
}

///|
pub fn visibility_propagate_system(_delta : Double) -> Unit {
  let inherited_visibilities = inherited_visibilities()
  let view_visibilities = view_visibilities()
  inherited_visibilities.clear()
  view_visibilities.clear()
  let cache : Map[@ecs.Entity, Bool] = Map([])
  for entity in @ecs.iter_entities() {
    guard entity.is_alive() else { continue }
    let visible = compute_inherited_visibility(entity, cache)
    inherited_visibilities.set(entity, { visible, })
    view_visibilities.set(entity, { visible, })
  }
}

///|
pub fn is_visible(entity : @ecs.Entity) -> Bool {
  view_visibilities().get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}
