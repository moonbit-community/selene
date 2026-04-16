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
