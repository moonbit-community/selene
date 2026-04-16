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
