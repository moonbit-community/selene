///|
pub(all) enum ChannelInterpolation3D {
  Step
  Linear
} derive(Eq, Show)

///|
pub(all) struct Vec3Keyframe3D {
  time : Double
  value : @math.Vec3
} derive(Eq, Show)

///|
pub(all) struct QuatKeyframe3D {
  time : Double
  value : @math.Quat
} derive(Eq, Show)

///|
pub(all) struct AnimationChannel3D {
  node : Int
  translations : Array[Vec3Keyframe3D]
  rotations : Array[QuatKeyframe3D]
  scales : Array[Vec3Keyframe3D]
  interpolation : ChannelInterpolation3D
}

///|
pub(all) struct AnimationClip3D {
  name : String
  duration : Double
  channels : Array[AnimationChannel3D]
}

///|
pub(all) struct AnimationClipHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct AnimationTransition3D {
  from : String
  to : String
  trigger : String?
  on_complete : Bool
}

///|
pub(all) struct AnimationGraph3D {
  entry : String
  states : Map[String, AnimationClipHandle]
  transitions : Array[AnimationTransition3D]
}

///|
pub(all) struct AnimationPlayer3D {
  mut graph : AnimationGraph3D?
  mut current_state : String?
  mut clip : AnimationClipHandle?
  mut time : Double
  mut speed : Double
  mut repeat : Bool
  mut playing : Bool
  mut pending_triggers : Array[String]
}

///|
pub(all) struct AnimationTargets3D {
  nodes : Map[Int, @entity.Entity]
  clips_by_name : Map[String, AnimationClipHandle]
}

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
  mesh : @render3d.MeshHandle
  base_positions : Array[@math.Vec3]
  base_normals : Array[@math.Vec3]
  uvs : Array[@math.Vec2D]?
  influences : Array[SkinVertexInfluence3D]
  joint_entities : Array[@entity.Entity]
  inverse_bind_matrices : Array[@math.Mat4]
}

///|
let next_clip_id : Ref[UInt] = Ref::new(0)

///|
let animation_clips3d : Map[AnimationClipHandle, AnimationClip3D] = Map::new()

///|
pub let animation_players3d : Map[@entity.Entity, AnimationPlayer3D] = Map::new()

///|
let animation_targets3d : Map[@entity.Entity, AnimationTargets3D] = Map::new()

///|
let skinned_meshes3d : Map[@entity.Entity, SkinnedMeshBinding3D] = Map::new()

///|
pub fn register_animation_clip(clip : AnimationClip3D) -> AnimationClipHandle {
  let handle = AnimationClipHandle(next_clip_id.val)
  next_clip_id.val += 1
  animation_clips3d.set(handle, clip)
  handle
}

///|
pub fn animation_clip(handle : AnimationClipHandle) -> AnimationClip3D? {
  animation_clips3d.get(handle)
}

///|
pub fn AnimationGraph3D::new(entry : String) -> AnimationGraph3D {
  { entry, states: Map::new(), transitions: [] }
}

///|
pub fn AnimationGraph3D::with_state(
  self : AnimationGraph3D,
  state : String,
  clip : AnimationClipHandle,
) -> AnimationGraph3D {
  let states = self.states.copy()
  states.set(state, clip)
  { ..self, states, }
}

///|
pub fn AnimationGraph3D::with_trigger_transition(
  self : AnimationGraph3D,
  from : String,
  to : String,
  trigger : String,
) -> AnimationGraph3D {
  let transitions = self.transitions.copy()
  transitions.push({ from, to, trigger: Some(trigger), on_complete: false })
  { ..self, transitions, }
}

///|
pub fn AnimationGraph3D::with_completion_transition(
  self : AnimationGraph3D,
  from : String,
  to : String,
) -> AnimationGraph3D {
  let transitions = self.transitions.copy()
  transitions.push({ from, to, trigger: None, on_complete: true })
  { ..self, transitions, }
}

///|
pub fn AnimationPlayer3D::new() -> AnimationPlayer3D {
  {
    graph: None,
    current_state: None,
    clip: None,
    time: 0.0,
    speed: 1.0,
    repeat: true,
    playing: true,
    pending_triggers: [],
  }
}

///|
pub fn AnimationPlayer3D::from_clip(
  clip : AnimationClipHandle,
  repeat? : Bool = true,
) -> AnimationPlayer3D {
  { ..AnimationPlayer3D::new(), clip: Some(clip), repeat }
}

///|
pub fn attach_animation_player(
  entity : @entity.Entity,
  player : AnimationPlayer3D,
) -> Unit {
  animation_players3d.set(entity, player)
}

///|
pub fn set_animation_graph(
  entity : @entity.Entity,
  graph : AnimationGraph3D,
  repeat? : Bool = true,
) -> Unit {
  let player = animation_players3d
    .get(entity)
    .unwrap_or(AnimationPlayer3D::new())
  animation_players3d.set(entity, {
    ..player,
    graph: Some(graph),
    current_state: None,
    clip: None,
    time: 0.0,
    repeat,
    playing: true,
  })
}

///|
pub fn play_clip(
  entity : @entity.Entity,
  clip : AnimationClipHandle,
  repeat? : Bool = true,
) -> Unit {
  let player = animation_players3d
    .get(entity)
    .unwrap_or(AnimationPlayer3D::new())
  animation_players3d.set(entity, {
    ..player,
    graph: None,
    current_state: None,
    clip: Some(clip),
    time: 0.0,
    repeat,
    playing: true,
  })
}

///|
pub fn play_state(
  entity : @entity.Entity,
  state : String,
  repeat? : Bool = true,
) -> Bool {
  guard animation_players3d.get(entity) is Some(player) else { return false }
  guard player.graph is Some(graph) else { return false }
  guard graph.states.get(state) is Some(clip) else { return false }
  animation_players3d.set(entity, {
    ..player,
    current_state: Some(state),
    clip: Some(clip),
    time: 0.0,
    repeat,
    playing: true,
  })
  true
}

///|
pub fn trigger_animation(entity : @entity.Entity, trigger : String) -> Unit {
  guard animation_players3d.get(entity) is Some(player) else { return }
  player.pending_triggers.push(trigger)
}

///|
pub fn bind_animation_targets(
  entity : @entity.Entity,
  nodes : Map[Int, @entity.Entity],
  clips_by_name : Map[String, AnimationClipHandle],
) -> Unit {
  animation_targets3d.set(entity, { nodes, clips_by_name })
}

///|
pub fn bind_skinned_mesh(
  entity : @entity.Entity,
  binding : SkinnedMeshBinding3D,
) -> Unit {
  skinned_meshes3d.set(entity, binding)
}

///|
pub fn clear_skinned_mesh(entity : @entity.Entity) -> Unit {
  skinned_meshes3d.remove(entity)
}

///|
fn resolve_graph_clip(player : AnimationPlayer3D) -> AnimationPlayer3D {
  guard player.graph is Some(graph) else { return player }
  let current_state = player.current_state.unwrap_or(graph.entry)
  let clip = graph.states.get(current_state)
  { ..player, current_state: Some(current_state), clip }
}

///|
fn choose_transition(
  graph : AnimationGraph3D,
  current_state : String,
  completed : Bool,
  triggers : Array[String],
) -> String? {
  for transition in graph.transitions {
    if transition.from != current_state {
      continue
    }
    if transition.on_complete && completed {
      return Some(transition.to)
    }
    if transition.trigger is Some(trigger) {
      for fired in triggers {
        if fired == trigger {
          return Some(transition.to)
        }
      }
    }
  }
  None
}

///|
fn sample_vec3(
  keys : Array[Vec3Keyframe3D],
  time : Double,
  interpolation : ChannelInterpolation3D,
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
    if interpolation is Step || rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    return lhs.value.lerp(rhs.value, alpha)
  }
  keys[last_index].value
}

///|
fn sample_quat(
  keys : Array[QuatKeyframe3D],
  time : Double,
  interpolation : ChannelInterpolation3D,
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
    if interpolation is Step || rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
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
fn apply_clip(
  clip : AnimationClip3D,
  time : Double,
  targets : AnimationTargets3D,
) -> Unit {
  for channel in clip.channels {
    guard targets.nodes.get(channel.node) is Some(entity) else { continue }
    let transform = @transform3d.transforms3d.get(entity).unwrap_or_default()
    let translation = if channel.translations.length() == 0 {
      transform.translation
    } else {
      sample_vec3(channel.translations, time, channel.interpolation)
    }
    let rotation = if channel.rotations.length() == 0 {
      transform.rotation
    } else {
      sample_quat(channel.rotations, time, channel.interpolation)
    }
    let scale = if channel.scales.length() == 0 {
      transform.scale
    } else {
      sample_vec3(channel.scales, time, channel.interpolation)
    }
    @transform3d.transforms3d.set(entity, { translation, rotation, scale })
  }
}

///|
fn weighted_skin_matrix(
  influence : SkinVertexInfluence3D,
  joint_matrices : Array[@math.Mat4],
) -> @math.Mat4 {
  let mut output : @math.Mat4 = {
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
  for index in 0..<4 {
    let joint_id = joint_ids[index]
    if joint_id < 0 || joint_id >= joint_matrices.length() {
      continue
    }
    let weight = weights[index]
    if weight <= 0.0 {
      continue
    }
    let matrix = joint_matrices[joint_id]
    output = {
      m00: output.m00 + matrix.m00 * weight,
      m01: output.m01 + matrix.m01 * weight,
      m02: output.m02 + matrix.m02 * weight,
      m03: output.m03 + matrix.m03 * weight,
      m10: output.m10 + matrix.m10 * weight,
      m11: output.m11 + matrix.m11 * weight,
      m12: output.m12 + matrix.m12 * weight,
      m13: output.m13 + matrix.m13 * weight,
      m20: output.m20 + matrix.m20 * weight,
      m21: output.m21 + matrix.m21 * weight,
      m22: output.m22 + matrix.m22 * weight,
      m23: output.m23 + matrix.m23 * weight,
      m30: output.m30 + matrix.m30 * weight,
      m31: output.m31 + matrix.m31 * weight,
      m32: output.m32 + matrix.m32 * weight,
      m33: output.m33 + matrix.m33 * weight,
    }
  }
  output
}

///|
pub fn animation3d_player_system(delta : Double) -> Unit {
  for _, pair in animation_players3d.to_array() {
    let (entity, current) = pair
    if !entity.is_alive() {
      animation_players3d.remove(entity)
      animation_targets3d.remove(entity)
      continue
    }
    guard animation_targets3d.get(entity) is Some(targets) else { continue }

    let mut player = resolve_graph_clip(current)
    guard player.clip is Some(clip_handle) else {
      player.pending_triggers.clear()
      animation_players3d.set(entity, player)
      continue
    }
    guard animation_clips3d.get(clip_handle) is Some(clip) else {
      player.pending_triggers.clear()
      animation_players3d.set(entity, player)
      continue
    }

    let mut completed = false
    if player.playing {
      player.time += delta * player.speed
      if clip.duration > 0.000001 && player.time >= clip.duration {
        completed = true
        if player.repeat {
          player.time = player.time % clip.duration
        } else {
          player.time = clip.duration
          player.playing = false
        }
      }
    }

    if player.graph is Some(graph) {
      let state = player.current_state.unwrap_or(graph.entry)
      if choose_transition(graph, state, completed, player.pending_triggers)
        is Some(next_state) {
        player.current_state = Some(next_state)
        player.time = 0.0
        player.playing = true
        player = resolve_graph_clip(player)
      }
    }

    player.pending_triggers.clear()
    if player.clip is Some(active_clip_handle) &&
      animation_clips3d.get(active_clip_handle) is Some(active_clip) {
      apply_clip(active_clip, player.time, targets)
    }
    animation_players3d.set(entity, player)
  }
}

///|
pub fn animation3d_skinning_system(_delta : Double) -> Unit {
  for _, pair in skinned_meshes3d.to_array() {
    let (entity, binding) = pair
    if !entity.is_alive() {
      skinned_meshes3d.remove(entity)
      continue
    }
    if binding.base_positions.length() != binding.influences.length() {
      continue
    }
    let joint_matrices : Array[@math.Mat4] = []
    for joint_index, joint_entity in binding.joint_entities {
      let global = @transform3d.global_transforms3d
        .get(joint_entity)
        .unwrap_or_default()
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
    if joint_matrices.length() == 0 {
      continue
    }
    let deformed_positions : Array[@math.Vec3] = []
    let deformed_normals : Array[@math.Vec3] = []
    for index, base_position in binding.base_positions {
      let influence = binding.influences[index]
      let skin_matrix = weighted_skin_matrix(influence, joint_matrices)
      deformed_positions.push(skin_matrix.transform_point(base_position))
      let base_normal = binding.base_normals
        .get(index)
        .unwrap_or(@math.Vec3::new(0.0, 1.0, 0.0))
      let normal_head = skin_matrix.transform_point(base_normal)
      let normal_tail = skin_matrix.transform_point(@math.Vec3::zero())
      let normal = (normal_head - normal_tail).normalize()
      deformed_normals.push(normal)
    }
    @render3d.update_mesh_asset(
      binding.mesh,
      @render3d.triangle_mesh(
        deformed_positions,
        uvs=binding.uvs,
        normals=Some(deformed_normals),
      ),
    )
  }
}
