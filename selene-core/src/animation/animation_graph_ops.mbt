///|
pub fn animation_transitions() -> Map[@entity.Entity, AnimationTransitions] {
  animation_world_store().animation_transitions
}

///|
pub fn animation_target_ids() -> Map[@entity.Entity, AnimationTargetId] {
  animation_world_store().animation_target_ids
}

///|
pub fn animated_bys() -> Map[@entity.Entity, AnimatedBy] {
  animation_world_store().animated_bys
}

///|
fn skinned_meshes() -> Map[@entity.Entity, SkinnedMeshBinding3D] {
  animation_world_store().skinned_meshes
}

///|
fn morphed_meshes() -> Map[@entity.Entity, MorphMeshBinding3D] {
  animation_world_store().morphed_meshes
}

///|
pub fn AnimatedBy::new(player : @entity.Entity) -> AnimatedBy {
  { player, }
}

///|
fn mask_from_groups(groups : Array[Int]) -> UInt {
  let mut mask = 0U
  for group in groups {
    if group >= 0 && group < 63 {
      mask = mask | (1U << group)
    }
  }
  mask
}

///|
pub fn AnimationClip::new(name : String) -> AnimationClip {
  { name, duration: 0.0, curves: Map::new(), events: [] }
}

///|
pub fn AnimationGraph::new() -> AnimationGraph {
  let root = AnimationNodeIndex(0U)
  let nodes : Map[AnimationNodeIndex, AnimationGraphNode] = Map::new()
  nodes.set(root, { node_type: Blend, mask: 0U, children: [] })
  { root, nodes, mask_groups: Map::new(), next_node: 1U }
}

///|
pub fn AnimationPlayer::new() -> AnimationPlayer {
  { active_animations: Map::new() }
}

///|
pub fn AnimationTransitions::new() -> AnimationTransitions {
  { main: None, fading: Map::new() }
}

///|
pub fn AnimationTargetId::new(path : String) -> AnimationTargetId {
  AnimationTargetId(path)
}

///|
pub fn AnimationTargetId::path(self : AnimationTargetId) -> String {
  match self {
    AnimationTargetId(path) => path
  }
}

///|
pub fn AnimationTargetId::from_names(
  names : Array[String],
) -> AnimationTargetId {
  let mut path = ""
  for index, name in names {
    if index > 0 {
      path = path + "/"
    }
    path = path + name
  }
  AnimationTargetId(path)
}

///|
pub fn animation_clip_asset(handle : AnimationClipHandle) -> AnimationClip? {
  animation_clips.get(handle)
}

///|
pub fn animation_graph_asset(handle : AnimationGraphHandle) -> AnimationGraph? {
  animation_graphs.get(handle)
}

///|
pub fn animated_field(handle : AnimatedFieldHandle) -> AnimatedField? {
  animated_fields.get(handle)
}

///|
pub fn register_animation_clip_asset(
  clip : AnimationClip,
) -> AnimationClipHandle {
  let handle = AnimationClipHandle(next_clip_id.val)
  next_clip_id.val += 1U
  animation_clips.set(handle, clip)
  dirty_animation_clip_assets.set(handle, clip)
  animation_clip_asset_events.send({ handle, kind: Added })
  handle
}

///|
pub fn update_animation_clip_asset(
  handle : AnimationClipHandle,
  clip : AnimationClip,
) -> Unit {
  animation_clips.set(handle, clip)
  dirty_animation_clip_assets.set(handle, clip)
  animation_clip_asset_events.send({ handle, kind: Modified })
}

///|
pub fn release_animation_clip_asset(handle : AnimationClipHandle) -> Unit {
  animation_clips.remove(handle)
  dirty_animation_clip_assets.remove(handle)
  released_animation_clip_assets.push(handle)
  animation_clip_asset_events.send({ handle, kind: Removed })
}

///|
pub fn take_dirty_animation_clip_assets() -> Array[
  (AnimationClipHandle, AnimationClip),
] {
  let values = dirty_animation_clip_assets.to_array()
  dirty_animation_clip_assets.clear()
  values
}

///|
pub fn take_released_animation_clip_assets() -> Array[AnimationClipHandle] {
  let values = released_animation_clip_assets.copy()
  released_animation_clip_assets.clear()
  values
}

///|
pub fn register_animation_graph_asset(
  graph : AnimationGraph,
) -> AnimationGraphHandle {
  let handle = AnimationGraphHandle(next_graph_id.val)
  next_graph_id.val += 1U
  animation_graphs.set(handle, graph)
  dirty_animation_graph_assets.set(handle, graph)
  animation_graph_asset_events.send({ handle, kind: Added })
  handle
}

///|
pub fn update_animation_graph_asset(
  handle : AnimationGraphHandle,
  graph : AnimationGraph,
) -> Unit {
  animation_graphs.set(handle, graph)
  dirty_animation_graph_assets.set(handle, graph)
  animation_graph_asset_events.send({ handle, kind: Modified })
}

///|
pub fn release_animation_graph_asset(handle : AnimationGraphHandle) -> Unit {
  animation_graphs.remove(handle)
  dirty_animation_graph_assets.remove(handle)
  released_animation_graph_assets.push(handle)
  animation_graph_asset_events.send({ handle, kind: Removed })
}

///|
pub fn take_dirty_animation_graph_assets() -> Array[
  (AnimationGraphHandle, AnimationGraph),
] {
  let values = dirty_animation_graph_assets.to_array()
  dirty_animation_graph_assets.clear()
  values
}

///|
pub fn take_released_animation_graph_assets() -> Array[AnimationGraphHandle] {
  let values = released_animation_graph_assets.copy()
  released_animation_graph_assets.clear()
  values
}
