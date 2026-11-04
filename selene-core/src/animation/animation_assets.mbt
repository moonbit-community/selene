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
}

///|
#derive(Eq, Debug)
pub(all) struct MorphTargetBinding3D {
  position_deltas : Array[@math.Vec3]?
  normal_deltas : Array[@math.Vec3]?
}

///|
pub(all) struct SkinVertexInfluence3D {
  joint0 : Int32
  joint1 : Int32
  joint2 : Int32
  joint3 : Int32
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
  indices : Array[Int32]?
  topology : @render3d.TriangleTopology3D
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2]]
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
  indices : Array[Int32]?
  topology : @render3d.TriangleTopology3D
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetBinding3D]
  mut morph_weights : Array[Double]
}

///|
priv struct AnimationWorldStore {
  animation_players : @entity.ComponentStore[AnimationPlayer]
  animation_graph_handles : @entity.ComponentStore[AnimationGraphHandle]
  animation_transitions : @entity.ComponentStore[AnimationTransitions]
  animation_target_ids : @entity.ComponentStore[AnimationTargetId]
  animated_bys : @entity.ComponentStore[AnimatedBy]
  skinned_meshes : @entity.ComponentStore[SkinnedMeshBinding3D]
  morphed_meshes : @entity.ComponentStore[MorphMeshBinding3D]
}

///|
let animation_world_store_key : @ecs.WorldKey[AnimationWorldStore] = WorldKey(() => {
  animation_players: ComponentStore(@ecs.require_current_world()),
  animation_graph_handles: ComponentStore(@ecs.require_current_world()),
  animation_transitions: ComponentStore(@ecs.require_current_world()),
  animation_target_ids: ComponentStore(@ecs.require_current_world()),
  animated_bys: ComponentStore(@ecs.require_current_world()),
  skinned_meshes: ComponentStore(@ecs.require_current_world()),
  morphed_meshes: ComponentStore(@ecs.require_current_world()),
})

///|
fn animation_world_store() -> AnimationWorldStore {
  @ecs.require_current_world().get_or_init(animation_world_store_key)
}

///|
let next_clip_id : Ref[UInt32] = Ref(0U)

///|
let next_graph_id : Ref[UInt32] = Ref(0U)

///|
let next_field_id : Ref[UInt32] = Ref(0U)

///|
let next_event_descriptor_id : Ref[UInt32] = Ref(0U)

///|
let animation_clips : Map[AnimationClipHandle, AnimationClip] = Map([])

///|
let animation_graphs : Map[AnimationGraphHandle, AnimationGraph] = Map([])

///|
let animated_fields : Map[AnimatedFieldHandle, AnimatedField] = Map([])

///|
let discrete_animated_fields : Set[AnimatedFieldHandle] = Set([])

///|
priv struct AnimationEventDescriptor {
  dispatch : (AnimationEventContext, @entity.Entity?) -> Unit
}

///|
let animation_event_descriptors : Map[
  AnimationEventDescriptorHandle,
  AnimationEventDescriptor,
] = Map([])

///|
let dirty_animation_clip_assets : Map[AnimationClipHandle, AnimationClip] = Map([],
)

///|
let dirty_animation_graph_assets : Map[AnimationGraphHandle, AnimationGraph] = Map([],
)

///|
let released_animation_clip_assets : Array[AnimationClipHandle] = []

///|
let released_animation_graph_assets : Array[AnimationGraphHandle] = []

///|
pub let animation_clip_asset_events : @event.Events[
  @asset.AssetEvent[AnimationClipHandle],
] = Events()

///|
pub let animation_graph_asset_events : @event.Events[
  @asset.AssetEvent[AnimationGraphHandle],
] = Events()

///|
pub fn animation_players() -> @entity.ComponentStore[AnimationPlayer] {
  animation_world_store().animation_players
}

///|
pub fn animation_graph_handles() -> @entity.ComponentStore[AnimationGraphHandle] {
  animation_world_store().animation_graph_handles
}
