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
  mask : UInt
} derive(Eq, Debug)

///|
priv struct VisibilityWorldStore {
  visibilities : Map[@entity.Entity, Visibility]
  inherited_visibilities : Map[@entity.Entity, InheritedVisibility]
  view_visibilities : Map[@entity.Entity, ViewVisibility]
  camera_view_visibilities : Map[@entity.Entity, @set.Set[UInt]]
  render_layers : Map[@entity.Entity, RenderLayers]
}

///|
let visibility_world_stores : Map[UInt, VisibilityWorldStore] = Map::new()

///|
fn visibility_world_store() -> VisibilityWorldStore {
  let world_id = @ecs.require_current_world().id()
  visibility_world_stores.get_or_init(world_id, () => {
    visibilities: Map::new(),
    inherited_visibilities: Map::new(),
    view_visibilities: Map::new(),
    camera_view_visibilities: Map::new(),
    render_layers: Map::new(),
  })
}

///|
pub fn visibilities() -> Map[@entity.Entity, Visibility] {
  visibility_world_store().visibilities
}

///|
pub fn inherited_visibilities() -> Map[@entity.Entity, InheritedVisibility] {
  visibility_world_store().inherited_visibilities
}

///|
pub fn view_visibilities() -> Map[@entity.Entity, ViewVisibility] {
  visibility_world_store().view_visibilities
}

///|
pub fn camera_view_visibilities() -> Map[@entity.Entity, @set.Set[UInt]] {
  visibility_world_store().camera_view_visibilities
}

///|
pub fn render_layers() -> Map[@entity.Entity, RenderLayers] {
  visibility_world_store().render_layers
}

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
  render_layers().get(entity).unwrap_or(default_render_layers())
}

///|
fn camera_visibility_set(entity : @entity.Entity) -> @set.Set[UInt] {
  camera_view_visibilities().get_or_init(entity, fn() { @set.Set::new() })
}

///|
pub fn mark_visible_to_camera(
  entity : @entity.Entity,
  camera_entity_id : UInt,
) -> Unit {
  camera_visibility_set(entity).add(camera_entity_id)
}

///|
pub fn is_visible_to_camera(
  entity : @entity.Entity,
  camera_entity_id : UInt,
) -> Bool {
  camera_view_visibilities().get(entity).map(fn(visible_cameras) {
    visible_cameras.contains(camera_entity_id)
  }).unwrap_or(false)
}

///|
pub fn visible_camera_entity_ids(entity : @entity.Entity) -> Array[UInt] {
  let camera_ids = camera_view_visibilities().get(entity).map(fn(visible_cameras) {
    visible_cameras.to_array()
  }).unwrap_or([])
  camera_ids.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
  camera_ids
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
  let camera_view_visibilities = camera_view_visibilities()
  let render_layers = render_layers()
  let visibilities = visibilities()
  let cache : Map[@entity.Entity, Bool] = Map::new()
  for entity in @entity.iter_entities() {
    let visible = compute_inherited_visibility(entity, cache)
    inherited_visibilities.set(entity, { visible, })
    view_visibilities.set(entity, { visible, })
    match camera_view_visibilities.get(entity) {
      Some(visible_cameras) => visible_cameras.clear()
      None => ()
    }
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
  for pair in camera_view_visibilities.to_array() {
    let entity = pair.0
    if !entity.is_alive() {
      camera_view_visibilities.remove(entity)
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
  view_visibilities().get(entity).map(fn(v) { v.visible }).unwrap_or(true)
}
