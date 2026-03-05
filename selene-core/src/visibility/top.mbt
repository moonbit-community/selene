///|
pub(all) enum Visibility {
  Visible
  Hidden
} derive(Eq, Show)

///|
pub(all) struct InheritedVisibility {
  visible : Bool
} derive(Eq, Show)

///|
pub(all) struct ViewVisibility {
  visible : Bool
} derive(Eq, Show)

///|
pub(all) struct RenderLayers {
  mask : UInt
} derive(Eq, Show)

///|
pub let visibilities : Map[@entity.Entity, Visibility] = Map::new()

///|
pub let inherited_visibilities : Map[@entity.Entity, InheritedVisibility] = Map::new()

///|
pub let view_visibilities : Map[@entity.Entity, ViewVisibility] = Map::new()

///|
pub let render_layers : Map[@entity.Entity, RenderLayers] = Map::new()

///|
pub fn default_render_layers() -> RenderLayers {
  { mask: 1U }
}

///|
pub fn layer(index : UInt) -> RenderLayers {
  if index >= 63U {
    { mask: 0U }
  } else {
    { mask: 1U << index.reinterpret_as_int() }
  }
}

///|
pub fn layers(mask : UInt) -> RenderLayers {
  { mask, }
}

///|
pub fn matches(lhs : RenderLayers, rhs : RenderLayers) -> Bool {
  (lhs.mask & rhs.mask) != 0U
}

///|
pub fn entity_render_layers(entity : @entity.Entity) -> RenderLayers {
  render_layers.get(entity).unwrap_or(default_render_layers())
}

///|
fn compute_inherited_visibility(
  entity : @entity.Entity,
  cache : Map[@entity.Entity, Bool],
) -> Bool {
  if cache.get(entity) is Some(visible) {
    return visible
  }
  let own_visible = visibilities.get(entity).unwrap_or(Visible) is Visible
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
  let cache : Map[@entity.Entity, Bool] = Map::new()
  for entity in @entity.iter_entities() {
    let visible = compute_inherited_visibility(entity, cache)
    inherited_visibilities.set(entity, { visible, })
    view_visibilities.set(entity, { visible, })
  }
  for pair in inherited_visibilities.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      inherited_visibilities.remove(entity)
    }
  }
  for pair in view_visibilities.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      view_visibilities.remove(entity)
    }
  }
  for pair in render_layers.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      render_layers.remove(entity)
    }
  }
  for pair in visibilities.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      visibilities.remove(entity)
    }
  }
}

///|
pub fn is_visible(entity : @entity.Entity) -> Bool {
  view_visibilities.get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}
