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
  indices : Array[Int]?
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
  animation_players : Map[@entity.Entity, AnimationPlayer]
  animation_graph_handles : Map[@entity.Entity, AnimationGraphHandle]
  animation_transitions : Map[@entity.Entity, AnimationTransitions]
  animation_target_ids : Map[@entity.Entity, AnimationTargetId]
  animated_bys : Map[@entity.Entity, AnimatedBy]
  skinned_meshes : Map[@entity.Entity, SkinnedMeshBinding3D]
  morphed_meshes : Map[@entity.Entity, MorphMeshBinding3D]
}

///|
let animation_world_stores : Map[UInt, AnimationWorldStore] = Map([])

///|
fn animation_world_store() -> AnimationWorldStore {
  let world_id = @ecs.require_current_world().id()
  animation_world_stores.get_or_init(world_id, () => {
    animation_players: Map([]),
    animation_graph_handles: Map([]),
    animation_transitions: Map([]),
    animation_target_ids: Map([]),
    animated_bys: Map([]),
    skinned_meshes: Map([]),
    morphed_meshes: Map([]),
  })
}

///|
let next_clip_id : Ref[UInt] = Ref(0U)

///|
let next_graph_id : Ref[UInt] = Ref(0U)

///|
let next_field_id : Ref[UInt] = Ref(0U)

///|
let next_event_descriptor_id : Ref[UInt] = Ref(0U)

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
] = @event.Events()

///|
pub let animation_graph_asset_events : @event.Events[
  @asset.AssetEvent[AnimationGraphHandle],
] = @event.Events()

///|
pub fn animation_players() -> Map[@entity.Entity, AnimationPlayer] {
  animation_world_store().animation_players
}

///|
pub fn animation_graph_handles() -> Map[@entity.Entity, AnimationGraphHandle] {
  animation_world_store().animation_graph_handles
}
