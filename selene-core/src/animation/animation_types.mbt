///|
#derive(Eq, Debug)
pub(all) enum ChannelInterpolation {
  Step
  Linear
  CubicSpline
}

///|
pub extend ChannelInterpolation with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ChannelInterpolation with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum AnimationValueKind {
  Scalar
  Vec3
  Quat
  Weights
}

///|
pub extend AnimationValueKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationValueKind with Eq::{not_equal, equal}

///|
pub(all) enum AnimatedValue {
  Scalar(Double)
  Vec3(@math.Vec3)
  Quat(@math.Quat)
  Weights(Array[Double])
}

///|
#derive(Eq, Debug)
pub(all) struct ScalarKeyframe {
  time : Double
  value : Double
  in_tangent : Double?
  out_tangent : Double?
}

///|
pub extend ScalarKeyframe with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ScalarKeyframe with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct Vec3Keyframe {
  time : Double
  value : @math.Vec3
  in_tangent : @math.Vec3?
  out_tangent : @math.Vec3?
}

///|
pub extend Vec3Keyframe with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Vec3Keyframe with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct QuatKeyframe {
  time : Double
  value : @math.Quat
  in_tangent : @math.Quat?
  out_tangent : @math.Quat?
}

///|
pub extend QuatKeyframe with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend QuatKeyframe with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct WeightKeyframe {
  time : Double
  value : Array[Double]
  in_tangent : Array[Double]?
  out_tangent : Array[Double]?
}

///|
pub extend WeightKeyframe with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend WeightKeyframe with Eq::{not_equal, equal}

///|
pub(all) struct AnimatedField {
  name : String
  kind : AnimationValueKind
  sample : (@ecs.World, @ecs.Entity) -> AnimatedValue
  apply : (@ecs.World, @ecs.Entity, AnimatedValue) -> Unit
}

///|
#derive(Eq, Debug, Hash)
pub(all) struct AnimatedFieldHandle(UInt32)

///|
pub extend AnimatedFieldHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimatedFieldHandle with Eq::{not_equal, equal}

///|
pub extend AnimatedFieldHandle with Hash::{hash, hash_combine}

///|
pub(all) enum VariableCurve {
  Scalar(AnimatedFieldHandle, Array[ScalarKeyframe], ChannelInterpolation)
  Vec3(AnimatedFieldHandle, Array[Vec3Keyframe], ChannelInterpolation)
  Quat(AnimatedFieldHandle, Array[QuatKeyframe], ChannelInterpolation)
  Weights(AnimatedFieldHandle, Array[WeightKeyframe], ChannelInterpolation)
}

///|
#derive(Eq, Debug, Hash)
#selene.component
pub(all) struct AnimationTargetId(String)

///|
pub extend AnimationTargetId with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationTargetId with Eq::{not_equal, equal}

///|
pub extend AnimationTargetId with Hash::{hash, hash_combine}

///|
#selene.component
pub(all) struct AnimatedBy {
  player : @ecs.Entity
}

///|
#derive(Eq, Debug)
pub(all) struct AnimationEventContext {
  clip : AnimationClipHandle
  player : @ecs.Entity
  target : @ecs.Entity?
  time : Double
}

///|
pub extend AnimationEventContext with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationEventContext with Eq::{not_equal, equal}

///|
#derive(Eq, Debug, Hash)
pub(all) struct AnimationEventDescriptorHandle(UInt32)

///|
pub extend AnimationEventDescriptorHandle with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend AnimationEventDescriptorHandle with Eq::{not_equal, equal}

///|
pub extend AnimationEventDescriptorHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
pub(all) struct AnimationClipEventDispatch {
  target : AnimationTargetId?
}

///|
pub extend AnimationClipEventDispatch with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend AnimationClipEventDispatch with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct AnimationClipEventKeyframe {
  time : Double
  descriptor : AnimationEventDescriptorHandle
  dispatch : AnimationClipEventDispatch
}

///|
pub extend AnimationClipEventKeyframe with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend AnimationClipEventKeyframe with Eq::{not_equal, equal}

///|
pub(all) struct AnimationClip {
  name : String
  mut duration : Double
  curves : Map[AnimationTargetId, Array[VariableCurve]]
  events : Array[AnimationClipEventKeyframe]
}

///|
#derive(Eq, Debug, Hash)
pub(all) struct AnimationClipHandle(UInt32)

///|
pub extend AnimationClipHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationClipHandle with Eq::{not_equal, equal}

///|
pub extend AnimationClipHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug, Hash)
pub(all) struct AnimationNodeIndex(UInt32)

///|
pub extend AnimationNodeIndex with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationNodeIndex with Eq::{not_equal, equal}

///|
pub extend AnimationNodeIndex with Hash::{hash, hash_combine}

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
  mask : UInt32
  children : Array[AnimationGraphEdge]
}

///|
pub(all) struct AnimationGraph {
  root : AnimationNodeIndex
  nodes : Array[AnimationGraphNode]
  mask_groups : Map[AnimationTargetId, UInt32]
}

///|
#derive(Eq, Debug, Hash)
#selene.component
pub(all) struct AnimationGraphHandle(UInt32)

///|
pub extend AnimationGraphHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AnimationGraphHandle with Eq::{not_equal, equal}

///|
pub extend AnimationGraphHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
pub(all) enum RepeatAnimation {
  Never
  Forever
  Count(UInt32)
}

///|
pub extend RepeatAnimation with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RepeatAnimation with Eq::{not_equal, equal}

///|
pub(all) struct ActiveAnimation {
  mut time : Double
  mut last_time : Double
  mut speed : Double
  mut weight : Double
  mut repeat : RepeatAnimation
  mut paused : Bool
  mut finished : Bool
  mut completed_repeats : UInt32
}

///|
#selene.component
pub(all) struct AnimationPlayer {
  active_animations : Map[AnimationNodeIndex, ActiveAnimation]
}
