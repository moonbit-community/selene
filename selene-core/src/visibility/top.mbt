///|
#derive(Eq, Debug)
#selene.component
pub(all) enum Visibility {
  Visible
  Hidden
}

///|
#derive(Eq, Debug)
pub(all) struct InheritedVisibility {
  visible : Bool
}

///|
#derive(Eq, Debug)
pub(all) struct ViewVisibility {
  visible : Bool
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct RenderLayers {
  mask : UInt32
}

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
pub fn render_layers() -> @ecs.ComponentStore[RenderLayers] {
  @ecs.components()
}

///|
pub fn RenderLayers::RenderLayers() -> RenderLayers {
  { mask: 1U, }
}

///|
pub fn layer(index : UInt32) -> RenderLayers {
  if index >= 63U {
    { mask: 0U, }
  } else {
    { mask: 1U << index.reinterpret_as_int(), }
  }
}

///|
pub fn layers(mask : UInt32) -> RenderLayers {
  { mask, }
}

///|
pub fn matches(lhs : RenderLayers, rhs : RenderLayers) -> Bool {
  (lhs.mask & rhs.mask) != 0U
}

///|
pub fn entity_render_layers(entity : @ecs.Entity) -> RenderLayers {
  render_layers().get(entity).unwrap_or(RenderLayers())
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
