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
}
