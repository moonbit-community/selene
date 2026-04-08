///|
pub(all) enum ChannelInterpolation {
  Step
  Linear
  CubicSpline
} derive(Eq, Debug)

///|
pub(all) enum AnimationValueKind {
  Scalar
  Vec3
  Quat
  Weights
} derive(Eq, Debug)

///|
pub(all) enum AnimatedValue {
  Scalar(Double)
  Vec3(@math.Vec3)
  Quat(@math.Quat)
  Weights(Array[Double])
}

///|
pub(all) struct ScalarKeyframe {
  time : Double
  value : Double
  in_tangent : Double?
  out_tangent : Double?
} derive(Eq, Debug)

///|
pub(all) struct Vec3Keyframe {
  time : Double
  value : @math.Vec3
  in_tangent : @math.Vec3?
  out_tangent : @math.Vec3?
} derive(Eq, Debug)

///|
pub(all) struct QuatKeyframe {
  time : Double
  value : @math.Quat
  in_tangent : @math.Quat?
  out_tangent : @math.Quat?
} derive(Eq, Debug)

///|
pub(all) struct WeightKeyframe {
  time : Double
  value : Array[Double]
  in_tangent : Array[Double]?
  out_tangent : Array[Double]?
} derive(Eq, Debug)

///|
pub(all) struct AnimatedField {
  name : String
  kind : AnimationValueKind
  sample : (@entity.Entity) -> AnimatedValue
  apply : (@entity.Entity, AnimatedValue) -> Unit
}

///|
pub(all) struct AnimatedFieldHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) enum VariableCurve {
  Scalar(AnimatedFieldHandle, Array[ScalarKeyframe], ChannelInterpolation)
  Vec3(AnimatedFieldHandle, Array[Vec3Keyframe], ChannelInterpolation)
  Quat(AnimatedFieldHandle, Array[QuatKeyframe], ChannelInterpolation)
  Weights(AnimatedFieldHandle, Array[WeightKeyframe], ChannelInterpolation)
}

///|
pub(all) struct AnimationTargetId(String) derive(Eq, Debug, Hash)

///|
pub(all) struct AnimatedBy {
  player : @entity.Entity

  fn new(player : @entity.Entity) -> AnimatedBy
}

///|
pub(all) struct AnimationEventContext {
  clip : AnimationClipHandle
  player : @entity.Entity
  target : @entity.Entity?
  time : Double
} derive(Eq, Debug)

///|
pub(all) struct AnimationEventDescriptorHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct AnimationClipEventDispatch {
  target : AnimationTargetId?
} derive(Eq, Debug)

///|
pub(all) struct AnimationClipEventKeyframe {
  time : Double
  descriptor : AnimationEventDescriptorHandle
  dispatch : AnimationClipEventDispatch
} derive(Eq, Debug)

///|
pub(all) struct AnimationClip {
  name : String
  mut duration : Double
  curves : Map[AnimationTargetId, Array[VariableCurve]]
  events : Array[AnimationClipEventKeyframe]

  fn new(name : String) -> AnimationClip
}

///|
pub(all) struct AnimationClipHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) struct AnimationNodeIndex(UInt) derive(Eq, Debug, Hash)

///|
pub(all) enum AnimationGraphNodeType {
  Blend
  AdditiveBlend
  Clip(AnimationClipHandle)
}

///|
pub(all) struct AnimationGraphEdge {
  child : AnimationNodeIndex
  mut weight : Double
}

///|
pub(all) struct AnimationGraphNode {
  node_type : AnimationGraphNodeType
  mask : UInt
  children : Array[AnimationGraphEdge]
}

///|
pub(all) struct AnimationGraph {
  root : AnimationNodeIndex
  nodes : Map[AnimationNodeIndex, AnimationGraphNode]
  mask_groups : Map[AnimationTargetId, UInt]
  mut next_node : UInt

  fn new() -> AnimationGraph
}

///|
pub(all) struct AnimationGraphHandle(UInt) derive(Eq, Debug, Hash)

///|
pub(all) enum RepeatAnimation {
  Never
  Forever
  Count(UInt)
} derive(Eq, Debug)

///|
pub(all) struct ActiveAnimation {
  mut time : Double
  mut last_time : Double
  mut speed : Double
  mut weight : Double
  mut repeat : RepeatAnimation
  mut paused : Bool
  mut finished : Bool
  mut completed_repeats : UInt
}

///|
pub(all) struct AnimationPlayer {
  active_animations : Map[AnimationNodeIndex, ActiveAnimation]

  fn new() -> AnimationPlayer
}

///|
pub(all) struct TransitionEntry {
  mut remaining : Double
  total : Double
  start_weight : Double
}

///|
pub(all) struct AnimationTransitions {
  mut main : AnimationNodeIndex?
  fading : Map[AnimationNodeIndex, TransitionEntry]

  fn new() -> AnimationTransitions
}

///|
pub(all) struct MorphTargetBinding3D {
  position_deltas : Array[@math.Vec3]?
  normal_deltas : Array[@math.Vec3]?
} derive(Eq, Debug)

///|
pub(all) struct SkinVertexInfluence3D {
  joint0 : Int
  joint1 : Int
  joint2 : Int
  joint3 : Int
  weight0 : Double
  weight1 : Double
  weight2 : Double
  weight3 : Double
}

///|
pub(all) struct SkinnedMeshBinding3D {
  target_entity : @entity.Entity
  mesh : @render3d.MeshHandle
  base_positions : Array[@math.Vec3]
  indices : Array[Int]?
  topology : @render3d.TriangleTopology3D
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2D]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetBinding3D]
  mut morph_weights : Array[Double]
  influences : Array[SkinVertexInfluence3D]
  joint_entities : Array[@entity.Entity]
  inverse_bind_matrices : Array[@math.Mat4]
}

///|
pub(all) struct MorphMeshBinding3D {
  target_entity : @entity.Entity
  mesh : @render3d.MeshHandle
  base_positions : Array[@math.Vec3]
  indices : Array[Int]?
  topology : @render3d.TriangleTopology3D
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2D]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetBinding3D]
  mut morph_weights : Array[Double]
}

///|
priv struct AnimationWorldStore {
  animation_players : Map[@entity.Entity, AnimationPlayer]
  animation_graph_handles : Map[@entity.Entity, AnimationGraphHandle]
  animation_transitions : Map[@entity.Entity, AnimationTransitions]
  animation_target_ids : Map[@entity.Entity, AnimationTargetId]
  animated_bys : Map[@entity.Entity, AnimatedBy]
  skinned_meshes : Map[@entity.Entity, SkinnedMeshBinding3D]
  morphed_meshes : Map[@entity.Entity, MorphMeshBinding3D]
}

///|
let animation_world_stores : Map[UInt, AnimationWorldStore] = Map::new()

///|
fn animation_world_store() -> AnimationWorldStore {
  let world_id = @ecs.require_current_world().id()
  animation_world_stores.get_or_init(world_id, () => {
    animation_players: Map::new(),
    animation_graph_handles: Map::new(),
    animation_transitions: Map::new(),
    animation_target_ids: Map::new(),
    animated_bys: Map::new(),
    skinned_meshes: Map::new(),
    morphed_meshes: Map::new(),
  })
}

///|
let next_clip_id : Ref[UInt] = Ref::new(0U)

///|
let next_graph_id : Ref[UInt] = Ref::new(0U)

///|
let next_field_id : Ref[UInt] = Ref::new(0U)

///|
let next_event_descriptor_id : Ref[UInt] = Ref::new(0U)

///|
let animation_clips : Map[AnimationClipHandle, AnimationClip] = Map::new()

///|
let animation_graphs : Map[AnimationGraphHandle, AnimationGraph] = Map::new()

///|
let animated_fields : Map[AnimatedFieldHandle, AnimatedField] = Map::new()

///|
let discrete_animated_fields : Set[AnimatedFieldHandle] = Set::new()

///|
priv struct AnimationEventDescriptor {
  dispatch : (AnimationEventContext, @entity.Entity?) -> Unit
}

///|
let animation_event_descriptors : Map[
  AnimationEventDescriptorHandle,
  AnimationEventDescriptor,
] = Map::new()

///|
let dirty_animation_clip_assets : Map[AnimationClipHandle, AnimationClip] = Map::new()

///|
let dirty_animation_graph_assets : Map[AnimationGraphHandle, AnimationGraph] = Map::new()

///|
let released_animation_clip_assets : Array[AnimationClipHandle] = []

///|
let released_animation_graph_assets : Array[AnimationGraphHandle] = []

///|
pub let animation_clip_asset_events : @event.Events[
  @asset.AssetEvent[AnimationClipHandle],
] = @event.Events::new()

///|
pub let animation_graph_asset_events : @event.Events[
  @asset.AssetEvent[AnimationGraphHandle],
] = @event.Events::new()

///|
pub fn animation_players() -> Map[@entity.Entity, AnimationPlayer] {
  animation_world_store().animation_players
}

///|
pub fn animation_graph_handles() -> Map[@entity.Entity, AnimationGraphHandle] {
  animation_world_store().animation_graph_handles
}

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

///|
pub fn register_animated_field(field : AnimatedField) -> AnimatedFieldHandle {
  let handle = AnimatedFieldHandle(next_field_id.val)
  next_field_id.val += 1U
  animated_fields.set(handle, field)
  handle
}

///|
pub fn[T] register_animation_event_descriptor(
  events : @event.Events[T],
  build : (AnimationEventContext) -> T,
) -> AnimationEventDescriptorHandle {
  let handle = AnimationEventDescriptorHandle(next_event_descriptor_id.val)
  next_event_descriptor_id.val += 1U
  animation_event_descriptors.set(handle, {
    dispatch: fn(context, observer_target) {
      events.trigger(build(context), observer_target)
    },
  })
  handle
}

///|
fn allocate_node(
  graph : AnimationGraph,
  node_type : AnimationGraphNodeType,
  mask : UInt,
) -> AnimationNodeIndex {
  let node = AnimationNodeIndex(graph.next_node)
  graph.next_node += 1U
  graph.nodes.set(node, { node_type, mask, children: [] })
  node
}

///|
pub fn AnimationGraph::add_edge(
  self : AnimationGraph,
  parent : AnimationNodeIndex,
  child : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> Unit {
  guard self.nodes.get(parent) is Some(node) else { return }
  node.children.push({ child, weight })
}

///|
pub fn AnimationGraph::add_blend(
  self : AnimationGraph,
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, Blend, 0U)
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_blend_with_mask(
  self : AnimationGraph,
  groups : Array[Int],
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, Blend, mask_from_groups(groups))
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_additive_blend(
  self : AnimationGraph,
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, AdditiveBlend, 0U)
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_additive_blend_with_mask(
  self : AnimationGraph,
  groups : Array[Int],
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, AdditiveBlend, mask_from_groups(groups))
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_clip(
  self : AnimationGraph,
  clip : AnimationClipHandle,
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, Clip(clip), 0U)
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_clip_with_mask(
  self : AnimationGraph,
  clip : AnimationClipHandle,
  groups : Array[Int],
  parent? : AnimationNodeIndex,
  weight? : Double = 1.0,
) -> AnimationNodeIndex {
  let node = allocate_node(self, Clip(clip), mask_from_groups(groups))
  self.add_edge(parent.unwrap_or(self.root), node, weight~)
  node
}

///|
pub fn AnimationGraph::add_target_to_mask_group(
  self : AnimationGraph,
  target : AnimationTargetId,
  group : Int,
) -> Unit {
  if group < 0 || group >= 63 {
    return
  }
  let current = self.mask_groups.get(target).unwrap_or(0U)
  self.mask_groups.set(target, current | (1U << group))
}

///|
pub fn AnimationGraph::from_clip(
  clip : AnimationClipHandle,
) -> (AnimationGraph, AnimationNodeIndex) {
  let graph = AnimationGraph::new()
  let node = graph.add_clip(clip)
  (graph, node)
}

///|
pub fn AnimationGraph::from_clips(
  clips : Array[AnimationClipHandle],
) -> (AnimationGraph, Array[AnimationNodeIndex]) {
  let graph = AnimationGraph::new()
  let nodes : Array[AnimationNodeIndex] = []
  for clip in clips {
    nodes.push(graph.add_clip(clip))
  }
  (graph, nodes)
}

///|
pub fn AnimationGraph::set_edge_weight(
  self : AnimationGraph,
  parent : AnimationNodeIndex,
  child : AnimationNodeIndex,
  weight : Double,
) -> Unit {
  guard self.nodes.get(parent) is Some(node) else { return }
  for edge in node.children {
    if edge.child == child {
      edge.weight = weight
      return
    }
  }
}

///|
pub fn AnimationClip::add_curve_to_target(
  self : AnimationClip,
  target : AnimationTargetId,
  curve : VariableCurve,
) -> Unit {
  let curves = self.curves.get_or_init(target, () => [])
  curves.push(curve)
  let duration = curve_end_time(curve)
  if duration > self.duration {
    self.duration = duration
  }
}

///|
pub fn AnimationClip::add_event(
  self : AnimationClip,
  time : Double,
  descriptor : AnimationEventDescriptorHandle,
  dispatch? : AnimationClipEventDispatch = { target: None },
) -> Unit {
  self.events.push({ time, descriptor, dispatch })
  if time > self.duration {
    self.duration = time
  }
}

///|
pub fn VariableCurve::scalar(
  field : AnimatedFieldHandle,
  keys : Array[ScalarKeyframe],
  interpolation? : ChannelInterpolation = Linear,
) -> VariableCurve {
  Scalar(field, keys, interpolation)
}

///|
pub fn VariableCurve::vec3(
  field : AnimatedFieldHandle,
  keys : Array[Vec3Keyframe],
  interpolation? : ChannelInterpolation = Linear,
) -> VariableCurve {
  Vec3(field, keys, interpolation)
}

///|
pub fn VariableCurve::quat(
  field : AnimatedFieldHandle,
  keys : Array[QuatKeyframe],
  interpolation? : ChannelInterpolation = Linear,
) -> VariableCurve {
  Quat(field, keys, interpolation)
}

///|
pub fn VariableCurve::weights(
  field : AnimatedFieldHandle,
  keys : Array[WeightKeyframe],
  interpolation? : ChannelInterpolation = Linear,
) -> VariableCurve {
  Weights(field, keys, interpolation)
}

///|
fn active_animation_default(repeat : RepeatAnimation) -> ActiveAnimation {
  {
    time: 0.0,
    last_time: 0.0,
    speed: 1.0,
    weight: 1.0,
    repeat,
    paused: false,
    finished: false,
    completed_repeats: 0U,
  }
}

///|
pub fn ActiveAnimation::is_finished(self : ActiveAnimation) -> Bool {
  self.finished
}

///|
pub fn ActiveAnimation::is_paused(self : ActiveAnimation) -> Bool {
  self.paused
}

///|
pub fn ActiveAnimation::weight(self : ActiveAnimation) -> Double {
  self.weight
}

///|
pub fn ActiveAnimation::speed(self : ActiveAnimation) -> Double {
  self.speed
}

///|
pub fn ActiveAnimation::repeat_mode(self : ActiveAnimation) -> RepeatAnimation {
  self.repeat
}

///|
pub fn ActiveAnimation::completions(self : ActiveAnimation) -> UInt {
  self.completed_repeats
}

///|
pub fn ActiveAnimation::elapsed(self : ActiveAnimation) -> Double {
  self.time
}

///|
pub fn ActiveAnimation::seek_time(self : ActiveAnimation) -> Double {
  self.time
}

///|
pub fn ActiveAnimation::pause(self : ActiveAnimation) -> ActiveAnimation {
  self.paused = true
  self
}

///|
pub fn ActiveAnimation::unpause(self : ActiveAnimation) -> ActiveAnimation {
  self.paused = false
  self
}

///|
pub fn ActiveAnimation::set_speed(
  self : ActiveAnimation,
  speed : Double,
) -> ActiveAnimation {
  self.speed = speed
  self
}

///|
pub fn ActiveAnimation::set_weight(
  self : ActiveAnimation,
  weight : Double,
) -> ActiveAnimation {
  self.weight = @cmp.maximum(0.0, weight)
  self
}

///|
pub fn ActiveAnimation::set_repeat(
  self : ActiveAnimation,
  repeat : RepeatAnimation,
) -> ActiveAnimation {
  self.repeat = repeat
  self
}

///|
pub fn ActiveAnimation::repeat(self : ActiveAnimation) -> ActiveAnimation {
  self.repeat = Forever
  self
}

///|
pub fn ActiveAnimation::replay(self : ActiveAnimation) -> ActiveAnimation {
  self.time = 0.0
  self.last_time = 0.0
  self.finished = false
  self.completed_repeats = 0U
  self
}

///|
pub fn ActiveAnimation::rewind(self : ActiveAnimation) -> ActiveAnimation {
  self.time = 0.0
  self.last_time = 0.0
  self.finished = false
  self
}

///|
pub fn ActiveAnimation::set_seek_time(
  self : ActiveAnimation,
  time : Double,
) -> ActiveAnimation {
  let clamped = @cmp.maximum(0.0, time)
  self.time = clamped
  self.last_time = clamped
  self
}

///|
pub fn ActiveAnimation::seek_to(
  self : ActiveAnimation,
  time : Double,
) -> ActiveAnimation {
  let clamped = @cmp.maximum(0.0, time)
  self.time = clamped
  self.last_time = clamped
  self
}

///|
pub fn AnimationPlayer::play(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  match self.active_animations.get(node) {
    Some(active) => active
    None => self.start(node, repeat~)
  }
}

///|
pub fn AnimationPlayer::start(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  self.active_animations.set(node, active_animation_default(repeat))
  self.active_animations.get(node).unwrap()
}

///|
pub fn AnimationPlayer::animation(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> ActiveAnimation? {
  self.active_animations.get(node)
}

///|
pub fn AnimationPlayer::animation_mut(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> ActiveAnimation? {
  self.active_animations.get(node)
}

///|
pub fn AnimationPlayer::playing_animations(
  self : AnimationPlayer,
) -> Array[(AnimationNodeIndex, ActiveAnimation)] {
  self.active_animations.to_array()
}

///|
pub fn AnimationPlayer::is_playing_animation(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> Bool {
  self.active_animations.contains(node)
}

///|
pub fn AnimationPlayer::stop(
  self : AnimationPlayer,
  node : AnimationNodeIndex,
) -> AnimationPlayer {
  self.active_animations.remove(node)
  self
}

///|
pub fn AnimationPlayer::stop_all(self : AnimationPlayer) -> AnimationPlayer {
  self.active_animations.clear()
  self
}

///|
pub fn AnimationPlayer::pause_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.pause())
  }
  self
}

///|
pub fn AnimationPlayer::resume_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.unpause())
  }
  self
}

///|
pub fn AnimationPlayer::rewind_all(self : AnimationPlayer) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.rewind())
  }
  self
}

///|
pub fn AnimationPlayer::seek_all_by(
  self : AnimationPlayer,
  amount : Double,
) -> AnimationPlayer {
  for _, active in self.active_animations {
    ignore(active.seek_to(active.time + amount))
  }
  self
}

///|
pub fn AnimationPlayer::all_finished(self : AnimationPlayer) -> Bool {
  for _, active in self.active_animations {
    if !active.is_finished() {
      return false
    }
  }
  true
}

///|
pub fn AnimationPlayer::all_paused(self : AnimationPlayer) -> Bool {
  for _, active in self.active_animations {
    if !active.is_paused() {
      return false
    }
  }
  true
}

///|
pub fn AnimationTransitions::play(
  self : AnimationTransitions,
  player : AnimationPlayer,
  node : AnimationNodeIndex,
  duration : Double,
  repeat? : RepeatAnimation = Forever,
) -> ActiveAnimation {
  let safe_duration = @cmp.maximum(0.0, duration)
  if self.main == Some(node) && player.animation(node) is Some(active) {
    if safe_duration <= 0.0 {
      active.weight = 1.0
    }
    return active
  }
  if self.main is Some(current) &&
    current != node &&
    player.animation(current) is Some(active) {
    self.fading.set(current, {
      remaining: safe_duration,
      total: safe_duration,
      start_weight: active.weight,
    })
  }
  self.fading.remove(node)
  let active = player.play(node, repeat~)
  active.weight = if safe_duration > 0.0 { 0.0 } else { 1.0 }
  self.main = Some(node)
  active
}

///|
pub fn AnimationTransitions::get_main_animation(
  self : AnimationTransitions,
) -> AnimationNodeIndex? {
  self.main
}

///|
pub fn bind_skinned_mesh(
  entity : @entity.Entity,
  binding : SkinnedMeshBinding3D,
) -> Unit {
  skinned_meshes().set(entity, binding)
}

///|
pub fn bind_morph_mesh(
  entity : @entity.Entity,
  binding : MorphMeshBinding3D,
) -> Unit {
  morphed_meshes().set(entity, binding)
}

///|
pub fn clear_skinned_mesh(entity : @entity.Entity) -> Unit {
  skinned_meshes().remove(entity)
}

///|
pub fn clear_morph_mesh(entity : @entity.Entity) -> Unit {
  morphed_meshes().remove(entity)
}

///|
fn curve_end_time(curve : VariableCurve) -> Double {
  match curve {
    Scalar(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Vec3(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Quat(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Weights(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
  }
}

///|
priv struct AnimationPropertyKey {
  entity : @entity.Entity
  field : AnimatedFieldHandle
} derive(Eq, Hash)

///|
priv struct AnimationSampleBuffer {
  normal : Array[(AnimatedValue, Double)]
  additive : Array[(AnimatedValue, Double)]
}

///|
let translation_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let rotation_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let scale_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let morph_weights_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let texture_atlas_index_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
pub fn transform_translation_field() -> AnimatedFieldHandle {
  match translation_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.translation",
        kind: Vec3,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Vec3(transform.translation)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Vec3(translation)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(
            entity,
            transform.with_translation(translation),
          )
        },
      })
      translation_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn transform_rotation_field() -> AnimatedFieldHandle {
  match rotation_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.rotation",
        kind: Quat,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Quat(transform.rotation)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Quat(rotation)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(entity, transform.with_rotation(rotation))
        },
      })
      rotation_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn transform_scale_field() -> AnimatedFieldHandle {
  match scale_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.scale",
        kind: Vec3,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Vec3(transform.scale)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Vec3(scale)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(entity, transform.with_scale(scale))
        },
      })
      scale_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
fn morph_weights_of(target_entity : @entity.Entity) -> Array[Double] {
  for _, pair in morphed_meshes().to_array() {
    let (_, binding) = pair
    if binding.target_entity == target_entity {
      return binding.morph_weights.copy()
    }
  }
  for _, pair in skinned_meshes().to_array() {
    let (_, binding) = pair
    if binding.target_entity == target_entity {
      return binding.morph_weights.copy()
    }
  }
  []
}

///|
fn set_target_morph_weights(
  target_entity : @entity.Entity,
  weights : Array[Double],
) -> Unit {
  for _, pair in morphed_meshes().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      morphed_meshes().set(entity, binding)
    }
  }
  for _, pair in skinned_meshes().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      skinned_meshes().set(entity, binding)
    }
  }
}

///|
pub fn morph_weights_field() -> AnimatedFieldHandle {
  match morph_weights_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Morph.weights",
        kind: Weights,
        sample: fn(entity) { AnimatedValue::Weights(morph_weights_of(entity)) },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Weights(weights)
          set_target_morph_weights(entity, weights)
        },
      })
      morph_weights_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn texture_atlas_index_field() -> AnimatedFieldHandle {
  match texture_atlas_index_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Sprite.texture_atlas.index",
        kind: Scalar,
        sample: fn(entity) {
          let index = @sprite.sprites()
            .get(entity)
            .bind(fn(sprite) {
              sprite.texture_atlas.map(fn(texture_atlas) {
                texture_atlas.index.to_double()
              })
            })
            .unwrap_or(0.0)
          AnimatedValue::Scalar(index)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Scalar(frame)
          guard @sprite.sprites().get(entity) is Some(sprite) else { return }
          guard sprite.texture_atlas is Some(texture_atlas) else { return }
          let next_index = if frame < 0.0 { 0 } else { frame.round().to_int() }
          let updated_atlas = { ..texture_atlas, index: next_index }
          @sprite.sprites().set(entity, {
            ..sprite,
            texture_atlas: Some(updated_atlas),
          })
        },
      })
      discrete_animated_fields.add(handle) |> ignore
      texture_atlas_index_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
fn entity_name_path(entity : @entity.Entity) -> Array[String]? {
  let segments : Array[String] = []
  let mut current : @entity.Entity? = Some(entity)
  while current is Some(node) {
    guard @name.name_of(node) is Some(name) else { return None }
    segments.push(name)
    current = node.get_parent()
  }
  let output : Array[String] = []
  let mut index = segments.length() - 1
  while index >= 0 {
    output.push(segments[index])
    index -= 1
  }
  Some(output)
}

///|
pub fn animation_target_id_of(entity : @entity.Entity) -> AnimationTargetId? {
  if animation_target_ids().get(entity) is Some(target) {
    return Some(target)
  }
  entity_name_path(entity).map(AnimationTargetId::from_names)
}

///|
fn cubic_hermite_basis(alpha : Double) -> (Double, Double, Double, Double) {
  let t = @cmp.maximum(0.0, @cmp.minimum(1.0, alpha))
  let t2 = t * t
  let t3 = t2 * t
  (2.0 * t3 - 3.0 * t2 + 1.0, t3 - 2.0 * t2 + t, -2.0 * t3 + 3.0 * t2, t3 - t2)
}

///|
fn sample_scalar(
  keys : Array[ScalarKeyframe],
  time : Double,
  interpolation : ChannelInterpolation,
) -> Double {
  if keys.length() == 0 {
    return 0.0
  }
  if keys.length() == 1 || time <= keys[0].time {
    return keys[0].value
  }
  let last_index = keys.length() - 1
  if time >= keys[last_index].time {
    return keys[last_index].value
  }
  for index in 0..<last_index {
    let lhs = keys[index]
    let rhs = keys[index + 1]
    if time < lhs.time || time > rhs.time {
      continue
    }
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return lhs.value * h00 +
        lhs_out * dt * h10 +
        rhs.value * h01 +
        rhs_in * dt * h11
    }
    return lhs.value * (1.0 - alpha) + rhs.value * alpha
  }
  keys[last_index].value
}

///|
fn sample_vec3(
  keys : Array[Vec3Keyframe],
  time : Double,
  interpolation : ChannelInterpolation,
) -> @math.Vec3 {
  if keys.length() == 0 {
    return @math.Vec3::zero()
  }
  if keys.length() == 1 || time <= keys[0].time {
    return keys[0].value
  }
  let last_index = keys.length() - 1
  if time >= keys[last_index].time {
    return keys[last_index].value
  }
  for index in 0..<last_index {
    let lhs = keys[index]
    let rhs = keys[index + 1]
    if time < lhs.time || time > rhs.time {
      continue
    }
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return lhs.value.scalar_mul(h00) +
        lhs_out.scalar_mul(dt * h10) +
        rhs.value.scalar_mul(h01) +
        rhs_in.scalar_mul(dt * h11)
    }
    return lhs.value.lerp(rhs.value, alpha)
  }
  keys[last_index].value
}

///|
fn sample_quat(
  keys : Array[QuatKeyframe],
  time : Double,
  interpolation : ChannelInterpolation,
) -> @math.Quat {
  if keys.length() == 0 {
    return @math.Quat::identity()
  }
  if keys.length() == 1 || time <= keys[0].time {
    return keys[0].value
  }
  let last_index = keys.length() - 1
  if time >= keys[last_index].time {
    return keys[last_index].value
  }
  for index in 0..<last_index {
    let lhs = keys[index]
    let rhs = keys[index + 1]
    if time < lhs.time || time > rhs.time {
      continue
    }
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return @math.Quat::new(
        lhs.value.x * h00 +
        lhs_out.x * dt * h10 +
        rhs.value.x * h01 +
        rhs_in.x * dt * h11,
        lhs.value.y * h00 +
        lhs_out.y * dt * h10 +
        rhs.value.y * h01 +
        rhs_in.y * dt * h11,
        lhs.value.z * h00 +
        lhs_out.z * dt * h10 +
        rhs.value.z * h01 +
        rhs_in.z * dt * h11,
        lhs.value.w * h00 +
        lhs_out.w * dt * h10 +
        rhs.value.w * h01 +
        rhs_in.w * dt * h11,
      ).normalize()
    }
    return @math.Quat::new(
      lhs.value.x * (1.0 - alpha) + rhs.value.x * alpha,
      lhs.value.y * (1.0 - alpha) + rhs.value.y * alpha,
      lhs.value.z * (1.0 - alpha) + rhs.value.z * alpha,
      lhs.value.w * (1.0 - alpha) + rhs.value.w * alpha,
    ).normalize()
  }
  keys[last_index].value
}

///|
fn sample_weights(
  keys : Array[WeightKeyframe],
  time : Double,
  interpolation : ChannelInterpolation,
) -> Array[Double] {
  if keys.length() == 0 {
    return []
  }
  if keys.length() == 1 || time <= keys[0].time {
    return keys[0].value.copy()
  }
  let last_index = keys.length() - 1
  if time >= keys[last_index].time {
    return keys[last_index].value.copy()
  }
  for index in 0..<last_index {
    let lhs = keys[index]
    let rhs = keys[index + 1]
    if time < lhs.time || time > rhs.time {
      continue
    }
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value.copy()
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value.copy()
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    let count = if lhs.value.length() > rhs.value.length() {
      lhs.value.length()
    } else {
      rhs.value.length()
    }
    let output : Array[Double] = []
    for weight_index in 0..<count {
      let lhs_value = lhs.value.get(weight_index).unwrap_or(0.0)
      let rhs_value = rhs.value.get(weight_index).unwrap_or(lhs_value)
      output.push(lhs_value * (1.0 - alpha) + rhs_value * alpha)
    }
    return output
  }
  keys[last_index].value.copy()
}

///|
fn sample_curve(
  curve : VariableCurve,
  time : Double,
) -> (AnimatedFieldHandle, AnimatedValue) {
  match curve {
    Scalar(field, keys, interpolation) =>
      (field, AnimatedValue::Scalar(sample_scalar(keys, time, interpolation)))
    Vec3(field, keys, interpolation) =>
      (field, AnimatedValue::Vec3(sample_vec3(keys, time, interpolation)))
    Quat(field, keys, interpolation) =>
      (field, AnimatedValue::Quat(sample_quat(keys, time, interpolation)))
    Weights(field, keys, interpolation) =>
      (field, AnimatedValue::Weights(sample_weights(keys, time, interpolation)))
  }
}

///|
fn push_sample(
  buffers : Map[AnimationPropertyKey, AnimationSampleBuffer],
  key : AnimationPropertyKey,
  value : AnimatedValue,
  weight : Double,
  additive : Bool,
) -> Unit {
  if weight <= 0.0 {
    return
  }
  let buffer = buffers.get_or_init(key, fn() { { normal: [], additive: [] } })
  if additive {
    buffer.additive.push((value, weight))
  } else {
    buffer.normal.push((value, weight))
  }
}

///|
fn blend_scalar(
  values : Array[(AnimatedValue, Double)],
  fallback : Double,
) -> Double {
  if values.length() == 0 {
    return fallback
  }
  let mut total = 0.0
  let mut weighted = 0.0
  for pair in values {
    if pair.0 is AnimatedValue::Scalar(value) {
      total += pair.1
      weighted += value * pair.1
    }
  }
  if total <= 0.000001 {
    fallback
  } else {
    weighted / total
  }
}

///|
fn blend_vec3(
  values : Array[(AnimatedValue, Double)],
  fallback : @math.Vec3,
) -> @math.Vec3 {
  if values.length() == 0 {
    return fallback
  }
  let mut total = 0.0
  let mut weighted = @math.Vec3::zero()
  for pair in values {
    if pair.0 is AnimatedValue::Vec3(value) {
      total += pair.1
      weighted = weighted + value.scalar_mul(pair.1)
    }
  }
  if total <= 0.000001 {
    fallback
  } else {
    weighted.scalar_div(total)
  }
}

///|
fn blend_quat(
  values : Array[(AnimatedValue, Double)],
  fallback : @math.Quat,
) -> @math.Quat {
  if values.length() == 0 {
    return fallback
  }
  let mut total = 0.0
  let mut x = 0.0
  let mut y = 0.0
  let mut z = 0.0
  let mut w = 0.0
  for pair in values {
    if pair.0 is AnimatedValue::Quat(value) {
      total += pair.1
      x += value.x * pair.1
      y += value.y * pair.1
      z += value.z * pair.1
      w += value.w * pair.1
    }
  }
  if total <= 0.000001 {
    fallback
  } else {
    @math.Quat::new(x / total, y / total, z / total, w / total).normalize()
  }
}

///|
fn blend_weights(
  values : Array[(AnimatedValue, Double)],
  fallback : Array[Double],
) -> Array[Double] {
  if values.length() == 0 {
    return fallback.copy()
  }
  let mut max_len = fallback.length()
  for pair in values {
    if pair.0 is AnimatedValue::Weights(weights) && weights.length() > max_len {
      max_len = weights.length()
    }
  }
  let totals : Array[Double] = []
  let weighted : Array[Double] = []
  for _ in 0..<max_len {
    totals.push(0.0)
    weighted.push(0.0)
  }
  for pair in values {
    if pair.0 is AnimatedValue::Weights(weights) {
      for index in 0..<max_len {
        let value = weights.get(index).unwrap_or(0.0)
        totals[index] = totals[index] + pair.1
        weighted[index] = weighted[index] + value * pair.1
      }
    }
  }
  let output : Array[Double] = []
  for index in 0..<max_len {
    if totals[index] <= 0.000001 {
      output.push(fallback.get(index).unwrap_or(0.0))
    } else {
      output.push(weighted[index] / totals[index])
    }
  }
  output
}

///|
fn select_discrete_value(
  values : Array[(AnimatedValue, Double)],
  fallback : AnimatedValue,
) -> AnimatedValue {
  if values.length() == 0 {
    return fallback
  }
  let mut selected = fallback
  let mut selected_weight = -1.0
  for pair in values {
    if pair.1 > selected_weight {
      selected = pair.0
      selected_weight = pair.1
    }
  }
  selected
}

///|
fn apply_additive_value(
  base : AnimatedValue,
  values : Array[(AnimatedValue, Double)],
) -> AnimatedValue {
  match base {
    AnimatedValue::Scalar(value) => {
      let mut output = value
      for pair in values {
        if pair.0 is AnimatedValue::Scalar(add) {
          output += add * pair.1
        }
      }
      AnimatedValue::Scalar(output)
    }
    AnimatedValue::Vec3(value) => {
      let mut output = value
      for pair in values {
        if pair.0 is AnimatedValue::Vec3(add) {
          output = output + add.scalar_mul(pair.1)
        }
      }
      AnimatedValue::Vec3(output)
    }
    AnimatedValue::Quat(value) => {
      let mut output = value
      for pair in values {
        if pair.0 is AnimatedValue::Quat(add) {
          let weighted = @math.Quat::identity().nlerp(add, pair.1)
          output = output.mul(weighted).normalize()
        }
      }
      AnimatedValue::Quat(output)
    }
    AnimatedValue::Weights(weights) => {
      let output = weights.copy()
      for pair in values {
        if pair.0 is AnimatedValue::Weights(add) {
          let count = if output.length() > add.length() {
            output.length()
          } else {
            add.length()
          }
          while output.length() < count {
            output.push(0.0)
          }
          for index in 0..<count {
            output[index] = output[index] +
              add.get(index).unwrap_or(0.0) * pair.1
          }
        }
      }
      AnimatedValue::Weights(output)
    }
  }
}

///|
fn resolve_sample_value(
  field_handle : AnimatedFieldHandle,
  field : AnimatedField,
  entity : @entity.Entity,
  buffer : AnimationSampleBuffer,
) -> AnimatedValue {
  let base = (field.sample)(entity)
  if discrete_animated_fields.contains(field_handle) {
    return select_discrete_value(buffer.normal, base)
  }
  let normal = match field.kind {
    Scalar =>
      AnimatedValue::Scalar(
        blend_scalar(
          buffer.normal,
          match base {
            AnimatedValue::Scalar(value) => value
            _ => 0.0
          },
        ),
      )
    Vec3 =>
      AnimatedValue::Vec3(
        blend_vec3(
          buffer.normal,
          match base {
            AnimatedValue::Vec3(value) => value
            _ => @math.Vec3::zero()
          },
        ),
      )
    Quat =>
      AnimatedValue::Quat(
        blend_quat(
          buffer.normal,
          match base {
            AnimatedValue::Quat(value) => value
            _ => @math.Quat::identity()
          },
        ),
      )
    Weights =>
      AnimatedValue::Weights(
        blend_weights(
          buffer.normal,
          match base {
            AnimatedValue::Weights(value) => value
            _ => []
          },
        ),
      )
  }
  apply_additive_value(
    if buffer.normal.length() == 0 {
      base
    } else {
      normal
    },
    buffer.additive,
  )
}

///|
fn collect_targets_by_player() -> Map[
  @entity.Entity,
  Map[AnimationTargetId, @entity.Entity],
] {
  let targets_by_player : Map[
    @entity.Entity,
    Map[AnimationTargetId, @entity.Entity],
  ] = Map::new()
  for entity in @entity.iter_entities() {
    guard entity.is_alive() else { continue }
    let player = animated_bys()
      .get(entity)
      .map_or(entity, fn(binding) { binding.player })
    guard animation_target_id_of(entity) is Some(target_id) else { continue }
    targets_by_player
    .get_or_init(player, fn() { Map::new() })
    .set(target_id, entity)
  }
  targets_by_player
}

///|
fn graph_node_duration(
  graph : AnimationGraph,
  node_index : AnimationNodeIndex,
) -> Double {
  guard graph.nodes.get(node_index) is Some(node) else { return 0.0 }
  match node.node_type {
    Clip(handle) =>
      animation_clip_asset(handle).map_or(0.0, fn(clip) { clip.duration })
    _ => {
      let mut duration = 0.0
      for edge in node.children {
        let child_duration = graph_node_duration(graph, edge.child)
        if child_duration > duration {
          duration = child_duration
        }
      }
      duration
    }
  }
}

///|
fn evaluate_graph_node(
  graph : AnimationGraph,
  node_index : AnimationNodeIndex,
  time : Double,
  weight : Double,
  inherited_mask : UInt,
  additive : Bool,
  targets : Map[AnimationTargetId, @entity.Entity],
  buffers : Map[AnimationPropertyKey, AnimationSampleBuffer],
) -> Unit {
  if weight <= 0.0 {
    return
  }
  guard graph.nodes.get(node_index) is Some(node) else { return }
  let combined_mask = inherited_mask | node.mask
  match node.node_type {
    Blend =>
      for edge in node.children {
        evaluate_graph_node(
          graph,
          edge.child,
          time,
          weight * edge.weight,
          combined_mask,
          additive,
          targets,
          buffers,
        )
      }
    AdditiveBlend =>
      for edge in node.children {
        evaluate_graph_node(
          graph,
          edge.child,
          time,
          weight * edge.weight,
          combined_mask,
          true,
          targets,
          buffers,
        )
      }
    Clip(handle) =>
      if animation_clip_asset(handle) is Some(clip) {
        for target_id, curves in clip.curves {
          guard targets.get(target_id) is Some(entity) else { continue }
          let target_groups = graph.mask_groups.get(target_id).unwrap_or(0U)
          if (combined_mask & target_groups) != 0U {
            continue
          }
          for curve in curves {
            let (field, value) = sample_curve(curve, time)
            push_sample(buffers, { entity, field }, value, weight, additive)
          }
        }
      }
  }
}

///|
fn collect_clip_nodes(
  graph : AnimationGraph,
  node_index : AnimationNodeIndex,
  output : Array[AnimationNodeIndex],
) -> Unit {
  guard graph.nodes.get(node_index) is Some(node) else { return }
  match node.node_type {
    Clip(_) => output.push(node_index)
    _ =>
      for edge in node.children {
        collect_clip_nodes(graph, edge.child, output)
      }
  }
}

///|
fn emit_clip_events_between(
  clip_handle : AnimationClipHandle,
  clip : AnimationClip,
  player_entity : @entity.Entity,
  targets : Map[AnimationTargetId, @entity.Entity],
  from_time : Double,
  to_time : Double,
  wrapped : Bool,
  forward : Bool,
) -> Unit {
  for event in clip.events {
    let triggered = if wrapped {
      if forward {
        event.time >= from_time || event.time <= to_time
      } else {
        event.time <= from_time || event.time >= to_time
      }
    } else if forward {
      event.time >= from_time && event.time <= to_time
    } else {
      event.time <= from_time && event.time >= to_time
    }
    if !triggered {
      continue
    }
    let target = event.dispatch.target.bind(fn(target_id) {
      targets.get(target_id)
    })
    let observer_target = match target {
      Some(entity) => Some(entity)
      None => Some(player_entity)
    }
    guard animation_event_descriptors.get(event.descriptor) is Some(descriptor) else {
      continue
    }
    (descriptor.dispatch)(
      { clip: clip_handle, player: player_entity, target, time: event.time },
      observer_target,
    )
  }
}

///|
pub fn animation_player_system(delta : Double) -> Unit {
  let targets_by_player = collect_targets_by_player()
  for _, pair in animation_players().to_array() {
    let (entity, player) = pair
    if !entity.is_alive() {
      animation_players().remove(entity)
      animation_graph_handles().remove(entity)
      animation_transitions().remove(entity)
      continue
    }
    guard animation_graph_handles().get(entity) is Some(graph_handle) else {
      continue
    }
    guard animation_graph_asset(graph_handle) is Some(graph) else { continue }
    let targets = targets_by_player.get_or_init(entity, fn() { Map::new() })
    for node_index, active in player.active_animations {
      if active.paused || active.finished {
        continue
      }
      let duration = graph_node_duration(graph, node_index)
      active.last_time = active.time
      if duration <= 0.000001 {
        active.time = 0.0
        continue
      }
      let mut next_time = active.time + delta * active.speed
      let mut wrapped = false
      let forward = active.speed >= 0.0
      match active.repeat {
        Never =>
          if forward {
            if next_time >= duration {
              next_time = duration
              active.finished = true
            } else if next_time < 0.0 {
              next_time = 0.0
            }
          } else if next_time <= 0.0 {
            next_time = 0.0
            active.finished = true
          } else if next_time > duration {
            next_time = duration
          }
        Forever => {
          while next_time >= duration {
            next_time -= duration
            active.completed_repeats += 1U
            wrapped = true
          }
          while next_time < 0.0 {
            next_time += duration
            active.completed_repeats += 1U
            wrapped = true
          }
        }
        Count(count) =>
          if count == 0U {
            active.finished = true
            next_time = if forward { duration } else { 0.0 }
          } else if forward {
            while next_time >= duration {
              if active.completed_repeats + 1U < count {
                next_time -= duration
                active.completed_repeats += 1U
                wrapped = true
              } else {
                next_time = duration
                active.finished = true
                break
              }
            }
            if next_time < 0.0 {
              next_time = 0.0
            }
          } else {
            while next_time < 0.0 {
              if active.completed_repeats + 1U < count {
                next_time += duration
                active.completed_repeats += 1U
                wrapped = true
              } else {
                next_time = 0.0
                active.finished = true
                break
              }
            }
            if next_time > duration {
              next_time = duration
            }
          }
      }
      let clip_nodes : Array[AnimationNodeIndex] = []
      collect_clip_nodes(graph, node_index, clip_nodes)
      for clip_node in clip_nodes {
        guard graph.nodes.get(clip_node) is Some(node) else { continue }
        guard node.node_type is Clip(clip_handle) else { continue }
        guard animation_clip_asset(clip_handle) is Some(clip) else { continue }
        emit_clip_events_between(
          clip_handle,
          clip,
          entity,
          targets,
          active.last_time,
          next_time,
          wrapped,
          forward,
        )
      }
      active.time = next_time
    }
  }
}

///|
pub fn animation_transition_system(delta : Double) -> Unit {
  for _, pair in animation_transitions().to_array() {
    let (entity, transitions) = pair
    if !entity.is_alive() {
      animation_transitions().remove(entity)
      continue
    }
    guard animation_players().get(entity) is Some(player) else { continue }
    let mut main_weight = 1.0
    for node_index, fade in transitions.fading {
      if player.active_animations.get(node_index) is Some(active) {
        if fade.total <= 0.000001 {
          active.weight = 0.0
          active.finished = true
          player.active_animations.remove(node_index)
          transitions.fading.remove(node_index)
          continue
        }
        fade.remaining -= delta
        let ratio = @cmp.maximum(0.0, fade.remaining / fade.total)
        active.weight = fade.start_weight * ratio
        if ratio <= 0.0 {
          active.finished = true
          player.active_animations.remove(node_index)
          transitions.fading.remove(node_index)
        } else if 1.0 - ratio < main_weight {
          main_weight = 1.0 - ratio
        }
      } else {
        transitions.fading.remove(node_index)
      }
    }
    if transitions.main is Some(main) &&
      player.active_animations.get(main) is Some(active) {
      active.weight = if transitions.fading.is_empty() {
        1.0
      } else {
        main_weight
      }
    }
  }
}

///|
pub fn animation_apply_system(_delta : Double) -> Unit {
  let targets_by_player = collect_targets_by_player()
  for _, pair in animation_players().to_array() {
    let (player_entity, player) = pair
    guard player_entity.is_alive() else { continue }
    guard animation_graph_handles().get(player_entity) is Some(graph_handle) else {
      continue
    }
    guard animation_graph_asset(graph_handle) is Some(graph) else { continue }
    let targets = targets_by_player.get_or_init(player_entity, fn() {
      Map::new()
    })
    let buffers : Map[AnimationPropertyKey, AnimationSampleBuffer] = Map::new()
    for node_index, active in player.active_animations {
      if active.weight <= 0.0 {
        continue
      }
      evaluate_graph_node(
        graph,
        node_index,
        active.time,
        active.weight,
        0U,
        false,
        targets,
        buffers,
      )
    }
    for key, buffer in buffers {
      guard animated_field(key.field) is Some(field) else { continue }
      let value = resolve_sample_value(key.field, field, key.entity, buffer)
      (field.apply)(key.entity, value)
    }
  }
}

///|
fn apply_morph_targets(
  base_positions : Array[@math.Vec3],
  base_normals : Array[@math.Vec3],
  morph_targets : Array[MorphTargetBinding3D],
  morph_weights : Array[Double],
) -> (Array[@math.Vec3], Array[@math.Vec3]) {
  let positions = base_positions.copy()
  let normals = base_normals.copy()
  if morph_targets.length() == 0 || morph_weights.length() == 0 {
    return (positions, normals)
  }
  let count = if morph_targets.length() < morph_weights.length() {
    morph_targets.length()
  } else {
    morph_weights.length()
  }
  for index in 0..<count {
    let weight = morph_weights[index]
    if weight.abs() <= 0.0000001 {
      continue
    }
    let target = morph_targets[index]
    if target.position_deltas is Some(position_deltas) {
      let limit = if positions.length() < position_deltas.length() {
        positions.length()
      } else {
        position_deltas.length()
      }
      for vertex_index in 0..<limit {
        positions[vertex_index] = positions[vertex_index] +
          position_deltas[vertex_index].scalar_mul(weight)
      }
    }
    if target.normal_deltas is Some(normal_deltas) {
      let limit = if normals.length() < normal_deltas.length() {
        normals.length()
      } else {
        normal_deltas.length()
      }
      for vertex_index in 0..<limit {
        normals[vertex_index] = normals[vertex_index] +
          normal_deltas[vertex_index].scalar_mul(weight)
      }
    }
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    normals[index] = if normal.length_squared() > 0.0000001 {
      normal.normalize()
    } else {
      @math.Vec3::new(0.0, 1.0, 0.0)
    }
  }
  (positions, normals)
}

///|
fn skin_tangent(
  tangent : @render3d.Tangent3D,
  skin_matrix : @math.Mat4,
) -> @render3d.Tangent3D {
  let tangent_head = skin_matrix.transform_point(
    @math.Vec3::new(tangent.x, tangent.y, tangent.z),
  )
  let tangent_tail = skin_matrix.transform_point(@math.Vec3::zero())
  let direction = tangent_head - tangent_tail
  let normalized = if direction.length_squared() > 0.0000001 {
    direction.normalize()
  } else {
    @math.Vec3::new(1.0, 0.0, 0.0)
  }
  { x: normalized.x, y: normalized.y, z: normalized.z, w: tangent.w }
}

///|
fn zero_mat4() -> @math.Mat4 {
  {
    m00: 0.0,
    m01: 0.0,
    m02: 0.0,
    m03: 0.0,
    m10: 0.0,
    m11: 0.0,
    m12: 0.0,
    m13: 0.0,
    m20: 0.0,
    m21: 0.0,
    m22: 0.0,
    m23: 0.0,
    m30: 0.0,
    m31: 0.0,
    m32: 0.0,
    m33: 0.0,
  }
}

///|
fn scale_mat4(matrix : @math.Mat4, scalar : Double) -> @math.Mat4 {
  {
    m00: matrix.m00 * scalar,
    m01: matrix.m01 * scalar,
    m02: matrix.m02 * scalar,
    m03: matrix.m03 * scalar,
    m10: matrix.m10 * scalar,
    m11: matrix.m11 * scalar,
    m12: matrix.m12 * scalar,
    m13: matrix.m13 * scalar,
    m20: matrix.m20 * scalar,
    m21: matrix.m21 * scalar,
    m22: matrix.m22 * scalar,
    m23: matrix.m23 * scalar,
    m30: matrix.m30 * scalar,
    m31: matrix.m31 * scalar,
    m32: matrix.m32 * scalar,
    m33: matrix.m33 * scalar,
  }
}

///|
fn add_mat4(lhs : @math.Mat4, rhs : @math.Mat4) -> @math.Mat4 {
  {
    m00: lhs.m00 + rhs.m00,
    m01: lhs.m01 + rhs.m01,
    m02: lhs.m02 + rhs.m02,
    m03: lhs.m03 + rhs.m03,
    m10: lhs.m10 + rhs.m10,
    m11: lhs.m11 + rhs.m11,
    m12: lhs.m12 + rhs.m12,
    m13: lhs.m13 + rhs.m13,
    m20: lhs.m20 + rhs.m20,
    m21: lhs.m21 + rhs.m21,
    m22: lhs.m22 + rhs.m22,
    m23: lhs.m23 + rhs.m23,
    m30: lhs.m30 + rhs.m30,
    m31: lhs.m31 + rhs.m31,
    m32: lhs.m32 + rhs.m32,
    m33: lhs.m33 + rhs.m33,
  }
}

///|
fn weighted_skin_matrix(
  influence : SkinVertexInfluence3D,
  joint_matrices : Array[@math.Mat4],
) -> @math.Mat4 {
  let joint_ids = [
    influence.joint0,
    influence.joint1,
    influence.joint2,
    influence.joint3,
  ]
  let weights = [
    influence.weight0,
    influence.weight1,
    influence.weight2,
    influence.weight3,
  ]
  let mut output = zero_mat4()
  for index in 0..<4 {
    let joint_id = joint_ids[index]
    if joint_id < 0 || joint_id >= joint_matrices.length() {
      continue
    }
    let weight = weights[index]
    if weight <= 0.0 {
      continue
    }
    output = add_mat4(output, scale_mat4(joint_matrices[joint_id], weight))
  }
  output
}

///|
fn update_bound_mesh(
  mesh : @render3d.MeshHandle,
  positions : Array[@math.Vec3],
  indices : Array[Int]?,
  topology : @render3d.TriangleTopology3D,
  normals : Array[@math.Vec3],
  uv_sets : Array[Array[@math.Vec2D]],
  tangents : Array[@render3d.Tangent3D]?,
  colors : Array[@render.Color]?,
) -> Unit {
  @render3d.update_mesh_asset(
    mesh,
    @render3d.triangle_mesh(
      positions,
      normals=Some(normals),
      tangents~,
      colors~,
      uv_sets~,
      indices~,
      topology~,
    ),
  )
}

///|
pub fn animation_skinning_system(_delta : Double) -> Unit {
  for _, pair in morphed_meshes().to_array() {
    let (entity, binding) = pair
    if !entity.is_alive() {
      morphed_meshes().remove(entity)
      continue
    }
    let (positions, normals) = apply_morph_targets(
      binding.base_positions,
      binding.base_normals,
      binding.morph_targets,
      binding.morph_weights,
    )
    update_bound_mesh(
      binding.mesh,
      positions,
      binding.indices,
      binding.topology,
      normals,
      binding.uv_sets,
      binding.tangents,
      binding.colors,
    )
  }

  for _, pair in skinned_meshes().to_array() {
    let (entity, binding) = pair
    if !entity.is_alive() {
      skinned_meshes().remove(entity)
      continue
    }
    if binding.base_positions.length() != binding.influences.length() {
      continue
    }
    let joint_matrices : Array[@math.Mat4] = []
    let mut missing_joint_transform = false
    for joint_index, joint_entity in binding.joint_entities {
      guard @transform.global_transforms().get(joint_entity)
        is Some(global_transform) else {
        missing_joint_transform = true
        break
      }
      let global = global_transform.compute_transform()
      let world = @math.Mat4::from_trs(
        global.translation,
        global.rotation,
        global.scale,
      )
      let inverse_bind = binding.inverse_bind_matrices
        .get(joint_index)
        .unwrap_or(@math.Mat4::identity())
      joint_matrices.push(world.mul(inverse_bind))
    }
    if missing_joint_transform || joint_matrices.length() == 0 {
      continue
    }
    let (morphed_positions, morphed_normals) = apply_morph_targets(
      binding.base_positions,
      binding.base_normals,
      binding.morph_targets,
      binding.morph_weights,
    )
    let deformed_positions : Array[@math.Vec3] = []
    let deformed_normals : Array[@math.Vec3] = []
    let deformed_tangents : Array[@render3d.Tangent3D] = []
    for index, base_position in morphed_positions {
      let influence = binding.influences[index]
      let skin_matrix = weighted_skin_matrix(influence, joint_matrices)
      deformed_positions.push(skin_matrix.transform_point(base_position))
      let base_normal = morphed_normals
        .get(index)
        .unwrap_or(@math.Vec3::new(0.0, 1.0, 0.0))
      let normal_head = skin_matrix.transform_point(base_normal)
      let normal_tail = skin_matrix.transform_point(@math.Vec3::zero())
      let direction = normal_head - normal_tail
      let normal = if direction.length_squared() > 0.0000001 {
        direction.normalize()
      } else {
        @math.Vec3::new(0.0, 1.0, 0.0)
      }
      deformed_normals.push(normal)
      if binding.tangents is Some(tangents) &&
        tangents.get(index) is Some(tangent) {
        deformed_tangents.push(skin_tangent(tangent, skin_matrix))
      }
    }
    update_bound_mesh(
      binding.mesh,
      deformed_positions,
      binding.indices,
      binding.topology,
      deformed_normals,
      binding.uv_sets,
      if deformed_tangents.is_empty() {
        None
      } else {
        Some(deformed_tangents)
      },
      binding.colors,
    )
  }
}
