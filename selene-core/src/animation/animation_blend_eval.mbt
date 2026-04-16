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
