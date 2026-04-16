///|
pub fn AnimationTransitions::get_main_animation(
  self : AnimationTransitions,
) -> AnimationNodeIndex? {
  self.main
}

///|
pub fn bind_skinned_mesh(
  entity : @entity.Entity,
  binding : SkinnedMeshBinding3D,
) -> Unit {
  skinned_meshes().set(entity, binding)
}

///|
pub fn bind_morph_mesh(
  entity : @entity.Entity,
  binding : MorphMeshBinding3D,
) -> Unit {
  morphed_meshes().set(entity, binding)
}

///|
pub fn clear_skinned_mesh(entity : @entity.Entity) -> Unit {
  skinned_meshes().remove(entity)
}

///|
pub fn clear_morph_mesh(entity : @entity.Entity) -> Unit {
  morphed_meshes().remove(entity)
}

///|
fn curve_end_time(curve : VariableCurve) -> Double {
  match curve {
    Scalar(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Vec3(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Quat(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
    Weights(_, keys, _) =>
      if keys.length() == 0 {
        0.0
      } else {
        keys[keys.length() - 1].time
      }
  }
}

///|
priv struct AnimationPropertyKey {
  entity : @entity.Entity
  field : AnimatedFieldHandle
} derive(Eq, Hash)

///|
priv struct AnimationSampleBuffer {
  normal : Array[(AnimatedValue, Double)]
  additive : Array[(AnimatedValue, Double)]
}

///|
let translation_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let rotation_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let scale_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let morph_weights_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
let texture_atlas_index_field_ref : Ref[AnimatedFieldHandle?] = Ref::new(None)

///|
pub fn transform_translation_field() -> AnimatedFieldHandle {
  match translation_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.translation",
        kind: Vec3,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Vec3(transform.translation)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Vec3(translation)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(
            entity,
            transform.with_translation(translation),
          )
        },
      })
      translation_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn transform_rotation_field() -> AnimatedFieldHandle {
  match rotation_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.rotation",
        kind: Quat,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Quat(transform.rotation)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Quat(rotation)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(entity, transform.with_rotation(rotation))
        },
      })
      rotation_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn transform_scale_field() -> AnimatedFieldHandle {
  match scale_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Transform.scale",
        kind: Vec3,
        sample: fn(entity) {
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          AnimatedValue::Vec3(transform.scale)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Vec3(scale)
          let transform = @transform.transforms()
            .get(entity)
            .unwrap_or_default()
          @transform.transforms().set(entity, transform.with_scale(scale))
        },
      })
      scale_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
fn morph_weights_of(target_entity : @entity.Entity) -> Array[Double] {
  for _, pair in morphed_meshes().to_array() {
    let (_, binding) = pair
    if binding.target_entity == target_entity {
      return binding.morph_weights.copy()
    }
  }
  for _, pair in skinned_meshes().to_array() {
    let (_, binding) = pair
    if binding.target_entity == target_entity {
      return binding.morph_weights.copy()
    }
  }
  []
}

///|
fn set_target_morph_weights(
  target_entity : @entity.Entity,
  weights : Array[Double],
) -> Unit {
  for _, pair in morphed_meshes().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      morphed_meshes().set(entity, binding)
    }
  }
  for _, pair in skinned_meshes().to_array() {
    let (entity, binding) = pair
    if binding.target_entity == target_entity {
      binding.morph_weights = weights.copy()
      skinned_meshes().set(entity, binding)
    }
  }
}

///|
pub fn morph_weights_field() -> AnimatedFieldHandle {
  match morph_weights_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Morph.weights",
        kind: Weights,
        sample: fn(entity) { AnimatedValue::Weights(morph_weights_of(entity)) },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Weights(weights)
          set_target_morph_weights(entity, weights)
        },
      })
      morph_weights_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
pub fn texture_atlas_index_field() -> AnimatedFieldHandle {
  match texture_atlas_index_field_ref.val {
    Some(handle) => handle
    None => {
      let handle = register_animated_field({
        name: "Sprite.texture_atlas.index",
        kind: Scalar,
        sample: fn(entity) {
          let index = @sprite.sprites()
            .get(entity)
            .bind(fn(sprite) {
              sprite.texture_atlas.map(fn(texture_atlas) {
                texture_atlas.index.to_double()
              })
            })
            .unwrap_or(0.0)
          AnimatedValue::Scalar(index)
        },
        apply: fn(entity, value) {
          guard value is AnimatedValue::Scalar(frame)
          guard @sprite.sprites().get(entity) is Some(sprite) else { return }
          guard sprite.texture_atlas is Some(texture_atlas) else { return }
          let next_index = if frame < 0.0 { 0 } else { frame.round().to_int() }
          let updated_atlas = { ..texture_atlas, index: next_index }
          @sprite.sprites().set(entity, {
            ..sprite,
            texture_atlas: Some(updated_atlas),
          })
        },
      })
      discrete_animated_fields.add(handle) |> ignore
      texture_atlas_index_field_ref.val = Some(handle)
      handle
    }
  }
}

///|
fn entity_name_path(entity : @entity.Entity) -> Array[String]? {
  let segments : Array[String] = []
  let mut current : @entity.Entity? = Some(entity)
  while current is Some(node) {
    guard @name.name_of(node) is Some(name) else { return None }
    segments.push(name)
    current = node.get_parent()
  }
  let output : Array[String] = []
  let mut index = segments.length() - 1
  while index >= 0 {
    output.push(segments[index])
    index -= 1
  }
  Some(output)
}

///|
pub fn animation_target_id_of(entity : @entity.Entity) -> AnimationTargetId? {
  if animation_target_ids().get(entity) is Some(target) {
    return Some(target)
  }
  entity_name_path(entity).map(AnimationTargetId::from_names)
}

///|
fn cubic_hermite_basis(alpha : Double) -> (Double, Double, Double, Double) {
  let t = @cmp.maximum(0.0, @cmp.minimum(1.0, alpha))
  let t2 = t * t
  let t3 = t2 * t
  (2.0 * t3 - 3.0 * t2 + 1.0, t3 - 2.0 * t2 + t, -2.0 * t3 + 3.0 * t2, t3 - t2)
}

///|
fn sample_scalar(
  keys : Array[ScalarKeyframe],
  time : Double,
  interpolation : ChannelInterpolation,
) -> Double {
  if keys.length() == 0 {
    return 0.0
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
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return lhs.value * h00 +
        lhs_out * dt * h10 +
        rhs.value * h01 +
        rhs_in * dt * h11
    }
    return lhs.value * (1.0 - alpha) + rhs.value * alpha
  }
  keys[last_index].value
}

///|
fn sample_vec3(
  keys : Array[Vec3Keyframe],
  time : Double,
  interpolation : ChannelInterpolation,
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
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return lhs.value.scalar_mul(h00) +
        lhs_out.scalar_mul(dt * h10) +
        rhs.value.scalar_mul(h01) +
        rhs_in.scalar_mul(dt * h11)
    }
    return lhs.value.lerp(rhs.value, alpha)
  }
  keys[last_index].value
}

///|
fn sample_quat(
  keys : Array[QuatKeyframe],
  time : Double,
  interpolation : ChannelInterpolation,
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
    if interpolation is Step {
      if rhs.time <= lhs.time || time < rhs.time {
        return lhs.value
      }
      continue
    }
    if rhs.time <= lhs.time {
      return lhs.value
    }
    let alpha = @cmp.maximum(
      0.0,
      @cmp.minimum(1.0, (time - lhs.time) / (rhs.time - lhs.time)),
    )
    if interpolation is CubicSpline &&
      lhs.out_tangent is Some(lhs_out) &&
      rhs.in_tangent is Some(rhs_in) {
      let (h00, h10, h01, h11) = cubic_hermite_basis(alpha)
      let dt = rhs.time - lhs.time
      return @math.Quat::new(
        lhs.value.x * h00 +
        lhs_out.x * dt * h10 +
        rhs.value.x * h01 +
        rhs_in.x * dt * h11,
        lhs.value.y * h00 +
        lhs_out.y * dt * h10 +
        rhs.value.y * h01 +
        rhs_in.y * dt * h11,
        lhs.value.z * h00 +
        lhs_out.z * dt * h10 +
        rhs.value.z * h01 +
        rhs_in.z * dt * h11,
        lhs.value.w * h00 +
        lhs_out.w * dt * h10 +
        rhs.value.w * h01 +
        rhs_in.w * dt * h11,
      ).normalize()
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
