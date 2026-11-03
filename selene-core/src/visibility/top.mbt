///|
pub(all) enum Visibility {
  Visible
  Hidden
} derive(Eq, Debug)

///|
pub(all) struct InheritedVisibility {
  visible : Bool
} derive(Eq, Debug)

///|
pub(all) struct ViewVisibility {
  visible : Bool
} derive(Eq, Debug)

///|
pub(all) struct RenderLayers {
  mask : UInt32
} derive(Eq, Debug)

///|
priv struct VisibilityWorldStore {
  visibilities : @entity.ComponentStore[Visibility]
  inherited_visibilities : @entity.ComponentStore[InheritedVisibility]
  view_visibilities : @entity.ComponentStore[ViewVisibility]
  render_layers : @entity.ComponentStore[RenderLayers]
}

///|
let visibility_world_store_key : @ecs.WorldKey[VisibilityWorldStore] = WorldKey(() => {
    visibilities: ComponentStore(@ecs.require_current_world()),
    inherited_visibilities: ComponentStore(@ecs.require_current_world()),
    view_visibilities: ComponentStore(@ecs.require_current_world()),
    render_layers: ComponentStore(@ecs.require_current_world()),
  },
)

///|
fn visibility_world_store() -> VisibilityWorldStore {
  @ecs.require_current_world().get_or_init(visibility_world_store_key)
}

///|
pub fn visibilities() -> @entity.ComponentStore[Visibility] {
  visibility_world_store().visibilities
}

///|
pub fn inherited_visibilities() -> @entity.ComponentStore[InheritedVisibility] {
  visibility_world_store().inherited_visibilities
}

///|
pub fn view_visibilities() -> @entity.ComponentStore[ViewVisibility] {
  visibility_world_store().view_visibilities
}

///|
pub fn render_layers() -> @entity.ComponentStore[RenderLayers] {
  visibility_world_store().render_layers
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
pub fn entity_render_layers(entity : @entity.Entity) -> RenderLayers {
  render_layers().get(entity).unwrap_or(default_render_layers())
}

///|
fn compute_inherited_visibility(
  entity : @entity.Entity,
  cache : Map[@entity.Entity, Bool],
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
  let cache : Map[@entity.Entity, Bool] = Map([])
  for entity in @entity.iter_entities() {
    let visible = compute_inherited_visibility(entity, cache)
    inherited_visibilities.set(entity, { visible, })
    view_visibilities.set(entity, { visible, })
  }
  let alive = @entity.alive_in_world(@ecs.require_current_world())
  inherited_visibilities.retain(alive)
  view_visibilities.retain(alive)
  render_layers.retain(alive)
  visibilities.retain(alive)
}

///|
pub fn is_visible(entity : @entity.Entity) -> Bool {
  view_visibilities().get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}
