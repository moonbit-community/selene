///|
pub(all) enum ChannelInterpolation3D {
  Step
  Linear
  CubicSpline
} derive(Eq, Show)

///|
pub(all) struct Vec3Keyframe3D {
  time : Double
  value : @math.Vec3
  in_tangent : @math.Vec3?
  out_tangent : @math.Vec3?
} derive(Eq, Show)

///|
pub(all) struct QuatKeyframe3D {
  time : Double
  value : @math.Quat
  in_tangent : @math.Quat?
  out_tangent : @math.Quat?
} derive(Eq, Show)

///|
pub(all) struct WeightKeyframe3D {
  time : Double
  value : Array[Double]
  in_tangent : Array[Double]?
  out_tangent : Array[Double]?
} derive(Eq, Show)

///|
pub(all) struct AnimationChannel3D {
  node : Int
  translations : Array[Vec3Keyframe3D]
  rotations : Array[QuatKeyframe3D]
  scales : Array[Vec3Keyframe3D]
  weights : Array[WeightKeyframe3D]
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
pub(all) struct MorphTargetBinding3D {
  position_deltas : Array[@math.Vec3]?
  normal_deltas : Array[@math.Vec3]?
} derive(Eq, Show)

///|
pub(all) struct SkinnedMeshBinding3D {
  target_entity : @entity.Entity
  mesh : @render3d.MeshHandle
  base_positions : Array[@math.Vec3]
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
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2D]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetBinding3D]
  mut morph_weights : Array[Double]
}

///|
let next_clip_id : Ref[UInt] = Ref::new(0)

///|
let animation_clips3d : Map[AnimationClipHandle, AnimationClip3D] = Map::new()

///|
priv struct Animation3DWorldStore {
  animation_players3d : Map[@entity.Entity, AnimationPlayer3D]
  animation_targets3d : Map[@entity.Entity, AnimationTargets3D]
  skinned_meshes3d : Map[@entity.Entity, SkinnedMeshBinding3D]
  morphed_meshes3d : Map[@entity.Entity, MorphMeshBinding3D]
}

///|
let animation3d_world_stores : Map[UInt, Animation3DWorldStore] = Map::new()

///|
fn animation3d_world_store() -> Animation3DWorldStore {
  let world_id = @ecs.require_current_world().id()
  animation3d_world_stores.get_or_init(world_id, () => {
    animation_players3d: Map::new(),
    animation_targets3d: Map::new(),
    skinned_meshes3d: Map::new(),
    morphed_meshes3d: Map::new(),
  })
}

///|
pub fn animation_players3d() -> Map[@entity.Entity, AnimationPlayer3D] {
  animation3d_world_store().animation_players3d
}

///|
fn animation_targets3d() -> Map[@entity.Entity, AnimationTargets3D] {
  animation3d_world_store().animation_targets3d
}

///|
fn skinned_meshes3d() -> Map[@entity.Entity, SkinnedMeshBinding3D] {
  animation3d_world_store().skinned_meshes3d
}

///|
fn morphed_meshes3d() -> Map[@entity.Entity, MorphMeshBinding3D] {
  animation3d_world_store().morphed_meshes3d
}

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
  animation_players3d().set(entity, player)
}

///|
pub fn set_animation_graph(
  entity : @entity.Entity,
  graph : AnimationGraph3D,
  repeat? : Bool = true,
) -> Unit {
  let player = animation_players3d()
    .get(entity)
    .unwrap_or(AnimationPlayer3D::new())
  animation_players3d().set(entity, {
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
  let player = animation_players3d()
    .get(entity)
    .unwrap_or(AnimationPlayer3D::new())
  animation_players3d().set(entity, {
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
  guard animation_players3d().get(entity) is Some(player) else { return false }
  guard player.graph is Some(graph) else { return false }
  guard graph.states.get(state) is Some(clip) else { return false }
  animation_players3d().set(entity, {
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
  guard animation_players3d().get(entity) is Some(player) else { return }
  player.pending_triggers.push(trigger)
}

///|
pub fn bind_animation_targets(
  entity : @entity.Entity,
  nodes : Map[Int, @entity.Entity],
  clips_by_name : Map[String, AnimationClipHandle],
) -> Unit {
  animation_targets3d().set(entity, { nodes, clips_by_name })
}

///|
pub fn bind_skinned_mesh(
  entity : @entity.Entity,
  binding : SkinnedMeshBinding3D,
) -> Unit {
  skinned_meshes3d().set(entity, binding)
}

///|
pub fn bind_morph_mesh(
  entity : @entity.Entity,
  binding : MorphMeshBinding3D,
) -> Unit {
  morphed_meshes3d().set(entity, binding)
}

///|
pub fn clear_skinned_mesh(entity : @entity.Entity) -> Unit {
  skinned_meshes3d().remove(entity)
}

///|
pub fn clear_morph_mesh(entity : @entity.Entity) -> Unit {
  morphed_meshes3d().remove(entity)
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
fn cubic_hermite_basis(alpha : Double) -> (Double, Double, Double, Double) {
  let t = @cmp.maximum(0.0, @cmp.minimum(1.0, alpha))
  let t2 = t * t
  let t3 = t2 * t
  (2.0 * t3 - 3.0 * t2 + 1.0, t3 - 2.0 * t2 + t, -2.0 * t3 + 3.0 * t2, t3 - t2)
}

///|
fn cubic_hermite_vec3(
  lhs_value : @math.Vec3,
  lhs_out_tangent : @math.Vec3,
  rhs_value : @math.Vec3,
  rhs_in_tangent : @math.Vec3,
  alpha : Double,
  dt : Double,
) -> @math.Vec3 {
  let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
  lhs_value.scalar_mul(h00) +
  lhs_out_tangent.scalar_mul(dt * h10) +
  rhs_value.scalar_mul(h01) +
  rhs_in_tangent.scalar_mul(dt * h11)
}

///|
fn cubic_hermite_quat(
  lhs_value : @math.Quat,
  lhs_out_tangent : @math.Quat,
  rhs_value : @math.Quat,
  rhs_in_tangent : @math.Quat,
  alpha : Double,
  dt : Double,
) -> @math.Quat {
  let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
  @math.Quat::new(
    lhs_value.x * h00 +
    lhs_out_tangent.x * dt * h10 +
    rhs_value.x * h01 +
    rhs_in_tangent.x * dt * h11,
    lhs_value.y * h00 +
    lhs_out_tangent.y * dt * h10 +
    rhs_value.y * h01 +
    rhs_in_tangent.y * dt * h11,
    lhs_value.z * h00 +
    lhs_out_tangent.z * dt * h10 +
    rhs_value.z * h01 +
    rhs_in_tangent.z * dt * h11,
    lhs_value.w * h00 +
    lhs_out_tangent.w * dt * h10 +
    rhs_value.w * h01 +
    rhs_in_tangent.w * dt * h11,
  ).normalize()
}

///|
fn cubic_hermite_weights(
  lhs_value : Array[Double],
  lhs_out_tangent : Array[Double],
  rhs_value : Array[Double],
  rhs_in_tangent : Array[Double],
  alpha : Double,
  dt : Double,
) -> Array[Double] {
  let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
  let count = if lhs_value.length() > rhs_value.length() {
    lhs_value.length()
  } else {
    rhs_value.length()
  }
  let output : Array[Double] = []
  for index in 0..<count {
    output.push(
      lhs_value.get(index).unwrap_or(0.0) * h00 +
      lhs_out_tangent.get(index).unwrap_or(0.0) * dt * h10 +
      rhs_value.get(index).unwrap_or(0.0) * h01 +
      rhs_in_tangent.get(index).unwrap_or(0.0) * dt * h11,
    )
  }
  output
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
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out_tangent) &&
      rhs.in_tangent is Some(rhs_in_tangent) {
      return cubic_hermite_vec3(
        lhs.value,
        lhs_out_tangent,
        rhs.value,
        rhs_in_tangent,
        alpha,
        rhs.time - lhs.time,
      )
    }
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
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out_tangent) &&
      rhs.in_tangent is Some(rhs_in_tangent) {
      return cubic_hermite_quat(
        lhs.value,
        lhs_out_tangent,
        rhs.value,
        rhs_in_tangent,
        alpha,
        rhs.time - lhs.time,
      )
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
  keys : Array[WeightKeyframe3D],
  time : Double,
  interpolation : ChannelInterpolation3D,
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
    if interpolation is Step || rhs.time <= lhs.time {
      return lhs.value.copy()
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out_tangent) &&
      rhs.in_tangent is Some(rhs_in_tangent) {
      return cubic_hermite_weights(
        lhs.value,
        lhs_out_tangent,
        rhs.value,
        rhs_in_tangent,
        alpha,
        rhs.time - lhs.time,
      )
    }
    let count = if lhs.value.length() > rhs.value.length() {
      lhs.value.length()
    } else {
      rhs.value.length()
    }
    let mixed : Array[Double] = []
    for weight_index in 0..<count {
      let lhs_value = lhs.value.get(weight_index).unwrap_or(0.0)
      let rhs_value = rhs.value.get(weight_index).unwrap_or(lhs_value)
      mixed.push(lhs_value * (1.0 - alpha) + rhs_value * alpha)
    }
    return mixed
  }
  keys[last_index].value.copy()
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
  let target_count = if morph_targets.length() < morph_weights.length() {
    morph_targets.length()
  } else {
    morph_weights.length()
  }
  for target_index in 0..<target_count {
    let weight = morph_weights[target_index]
    if weight.abs() <= 0.0000001 {
      continue
    }
    let target = morph_targets[target_index]
    if target.position_deltas is Some(position_deltas) {
      let count = if positions.length() < position_deltas.length() {
        positions.length()
      } else {
        position_deltas.length()
      }
      for index in 0..<count {
        positions[index] = positions[index] +
          position_deltas[index].scalar_mul(weight)
      }
    }
    if target.normal_deltas is Some(normal_deltas) {
      let count = if normals.length() < normal_deltas.length() {
        normals.length()
      } else {
        normal_deltas.length()
      }
      for index in 0..<count {
        normals[index] = normals[index] +
          normal_deltas[index].scalar_mul(weight)
      }
    }
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    if normal.length_squared() > 0.0000001 {
      normals[index] = normal.normalize()
    } else {
      normals[index] = @math.Vec3::new(0.0, 1.0, 0.0)
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
fn update_bound_mesh(
  mesh : @render3d.MeshHandle,
  positions : Array[@math.Vec3],
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
    ),
  )
}

///|
fn set_target_morph_weights(
  target_entity : @entity.Entity,
  weights : Array[Double],
) -> Unit {
  for _, pair in morphed_meshes3d().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      morphed_meshes3d().set(entity, binding)
    }
  }
  for _, pair in skinned_meshes3d().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      skinned_meshes3d().set(entity, binding)
    }
  }
}

///|
fn apply_clip(
  clip : AnimationClip3D,
  time : Double,
  targets : AnimationTargets3D,
) -> Unit {
  for channel in clip.channels {
    guard targets.nodes.get(channel.node) is Some(entity) else { continue }
    let transform = @transform3d.transforms3d().get(entity).unwrap_or_default()
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
    @transform3d.transforms3d().set(entity, { translation, rotation, scale })
    if channel.weights.length() > 0 {
      set_target_morph_weights(
        entity,
        sample_weights(channel.weights, time, channel.interpolation),
      )
    }
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
  for _, pair in animation_players3d().to_array() {
    let (entity, current) = pair
    if !entity.is_alive() {
      animation_players3d().remove(entity)
      animation_targets3d().remove(entity)
      continue
    }
    guard animation_targets3d().get(entity) is Some(targets) else { continue }

    let mut player = resolve_graph_clip(current)
    guard player.clip is Some(clip_handle) else {
      player.pending_triggers.clear()
      animation_players3d().set(entity, player)
      continue
    }
    guard animation_clips3d.get(clip_handle) is Some(clip) else {
      player.pending_triggers.clear()
      animation_players3d().set(entity, player)
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
    animation_players3d().set(entity, player)
  }
}

///|
pub fn animation3d_skinning_system(_delta : Double) -> Unit {
  for _, pair in morphed_meshes3d().to_array() {
    let (entity, binding) = pair
    if !entity.is_alive() {
      morphed_meshes3d().remove(entity)
      continue
    }
    let (morphed_positions, morphed_normals) = apply_morph_targets(
      binding.base_positions,
      binding.base_normals,
      binding.morph_targets,
      binding.morph_weights,
    )
    update_bound_mesh(
      binding.mesh,
      morphed_positions,
      morphed_normals,
      binding.uv_sets,
      binding.tangents,
      binding.colors,
    )
  }
  for _, pair in skinned_meshes3d().to_array() {
    let (entity, binding) = pair
    if !entity.is_alive() {
      skinned_meshes3d().remove(entity)
      continue
    }
    if binding.base_positions.length() != binding.influences.length() {
      continue
    }
    let joint_matrices : Array[@math.Mat4] = []
    for joint_index, joint_entity in binding.joint_entities {
      let global = @transform3d.global_transforms3d()
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
      let normal = (normal_head - normal_tail).normalize()
      deformed_normals.push(normal)
      if binding.tangents is Some(base_tangents) &&
        base_tangents.get(index) is Some(base_tangent) {
        deformed_tangents.push(skin_tangent(base_tangent, skin_matrix))
      }
    }
    let tangents = if deformed_tangents.length() == deformed_positions.length() {
      Some(deformed_tangents)
    } else {
      binding.tangents
    }
    update_bound_mesh(
      binding.mesh,
      deformed_positions,
      deformed_normals,
      binding.uv_sets,
      tangents,
      binding.colors,
    )
  }
}
