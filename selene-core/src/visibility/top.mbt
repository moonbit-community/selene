///|
#derive(Eq, Debug)
#selene.component
pub(all) enum Visibility {
  Visible
  Hidden
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct InheritedVisibility {
  visible : Bool
}

///|
#derive(Eq, Debug)
#selene.component
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
pub fn inherited_visibilities() -> @ecs.ComponentStore[InheritedVisibility] {
  @ecs.components()
}

///|
pub fn view_visibilities() -> @ecs.ComponentStore[ViewVisibility] {
  @ecs.components()
}

///|
pub fn render_layers() -> @ecs.ComponentStore[RenderLayers] {
  @ecs.components()
}

///|
pub fn default_render_layers() -> RenderLayers {
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
  render_layers().get(entity).unwrap_or(default_render_layers())
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
  let render_layers = render_layers()
  let visibilities = visibilities()
  let cache : Map[@ecs.Entity, Bool] = Map([])
  for entity in @ecs.iter_entities() {
    let visible = compute_inherited_visibility(entity, cache)
    inherited_visibilities.set(entity, { visible, })
    view_visibilities.set(entity, { visible, })
  }
  let alive = @ecs.alive_in_world(@ecs.require_current_world())
  inherited_visibilities.retain(alive)
  view_visibilities.retain(alive)
  render_layers.retain(alive)
  visibilities.retain(alive)
}

///|
pub fn is_visible(entity : @ecs.Entity) -> Bool {
  view_visibilities().get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}
