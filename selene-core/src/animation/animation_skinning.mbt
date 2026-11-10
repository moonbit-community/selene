///|
pub fn animation_player_system(delta : Double) -> Unit {
  let targets_by_player = collect_targets_by_player()
  for _, pair in animation_players().to_array() {
    let (entity, player) = pair
    if !entity.is_alive() {
      continue
    }
    guard animation_graph_handles().get(entity) is Some(graph_handle) else {
      continue
    }
    guard animation_graph_asset(graph_handle) is Some(graph) else { continue }
    let targets = targets_by_player.get_or_init(entity, fn() { Map([]) })
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
    let targets = targets_by_player.get_or_init(player_entity, fn() { Map([]) })
    let buffers : Map[AnimationPropertyKey, AnimationSampleBuffer] = Map([])
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
      normal.normalize_or_zero()
    } else {
      Vec3(0.0, 1.0, 0.0)
    }
  }
  (positions, normals)
}

///|
fn skin_tangent(
  tangent : @render3d.Tangent3D,
  skin_matrix : @math.Affine3,
  handedness : Double,
) -> @render3d.Tangent3D {
  let direction = skin_matrix
    .transform_vector3(Vec3(tangent.x, tangent.y, tangent.z))
    .try_normalize()
    .unwrap_or(@math.Vec3::x_axis())
  { x: direction.x, y: direction.y, z: direction.z, w: tangent.w * handedness, }
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
  let mut output = @math.Mat4::zero()
  for index in 0..<4 {
    let joint_id = joint_ids[index]
    if joint_id < 0 || joint_id >= joint_matrices.length() {
      continue
    }
    let weight = weights[index]
    if weight <= 0.0 {
      continue
    }
    output = output + joint_matrices[joint_id].scalar_mul(weight)
  }
  output
}

///|
fn update_bound_mesh(
  mesh : @render3d.MeshHandle,
  positions : Array[@math.Vec3],
  indices : Array[Int32]?,
  topology : @render3d.TriangleTopology3D,
  normals : Array[@math.Vec3],
  uv_sets : Array[Array[@math.Vec2]],
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
      if !entity.is_valid_in(@ecs.require_current_world()) {
        morphed_meshes().remove(entity)
      }
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
      if !entity.is_valid_in(@ecs.require_current_world()) {
        skinned_meshes().remove(entity)
      }
      continue
    }
    if binding.base_positions.length() != binding.influences.length() {
      continue
    }
    let joint_matrices : Array[@math.Mat4] = []
    let mut missing_joint_transform = false
    for joint_index, joint_entity in binding.joint_entities {
      guard @transform.global_transform(joint_entity) is Some(global_transform) else {
        missing_joint_transform = true
        break
      }
      let world = @math.Mat4::from_affine(global_transform.affine)
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
      let skin_matrix = weighted_skin_matrix(influence, joint_matrices).affine_part()
      deformed_positions.push(skin_matrix.transform_point3(base_position))
      let base_normal = morphed_normals
        .get(index)
        .unwrap_or(Vec3(0.0, 1.0, 0.0))
      let (normal_map, handedness) = skin_matrix.normal_matrix()
      let normal = normal_map
        .transform_vector3(base_normal)
        .try_normalize()
        .unwrap_or(@math.Vec3::y_axis())
      deformed_normals.push(normal)
      if binding.tangents is Some(tangents) &&
        tangents.get(index) is Some(tangent) {
        deformed_tangents.push(skin_tangent(tangent, skin_matrix, handedness))
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
