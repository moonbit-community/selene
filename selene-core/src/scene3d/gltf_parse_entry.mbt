///|
fn parse_animation_channels(
  animation_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
  target_ids : Map[Int, @animation.AnimationTargetId],
) -> Array[ParsedAnimationChannel] {
  guard field_array(animation_object, "samplers") is Some(samplers_json) else {
    return []
  }
  guard field_array(animation_object, "channels") is Some(channels_json) else {
    return []
  }

  let samplers : Array[AnimationSamplerTemplate?] = []
  for sampler_json in samplers_json {
    guard json_object(sampler_json) is Some(sampler_object) else {
      samplers.push(None)
      continue
    }
    guard field_int(sampler_object, "input") is Some(input_accessor) else {
      samplers.push(None)
      continue
    }
    guard field_int(sampler_object, "output") is Some(output_accessor) else {
      samplers.push(None)
      continue
    }
    guard read_accessor_scalar(input_accessor, buffers, buffer_views, accessors)
      is Some(times) else {
      samplers.push(None)
      continue
    }
    guard accessors.get(output_accessor) is Some(Some(_)) else {
      samplers.push(None)
      continue
    }
    let interpolation = match
      field_string(sampler_object, "interpolation").map_or("LINEAR", fn(v) {
        v.to_upper()
      }) {
      "STEP" => @animation.ChannelInterpolation::Step
      "CUBICSPLINE" => @animation.ChannelInterpolation::CubicSpline
      _ => @animation.ChannelInterpolation::Linear
    }
    samplers.push(Some({ times, output_accessor, interpolation }))
  }

  let output : Array[ParsedAnimationChannel] = []
  for channel_json in channels_json {
    guard json_object(channel_json) is Some(channel_object) else { continue }
    guard field_int(channel_object, "sampler") is Some(sampler_index) else {
      continue
    }
    guard samplers.get(sampler_index) is Some(Some(sampler)) else { continue }
    guard field_object(channel_object, "target") is Some(target_object) else {
      continue
    }
    guard field_int(target_object, "node") is Some(node_index) else { continue }
    guard target_ids.get(node_index) is Some(target_id) else { continue }
    let path = field_string(target_object, "path").map_or("", fn(v) {
      v.to_lower()
    })
    let times = sampler.times
    let output_accessor = sampler.output_accessor
    let interpolation = sampler.interpolation
    let translations : Array[@animation.Vec3Keyframe] = []
    let rotations : Array[@animation.QuatKeyframe] = []
    let scales : Array[@animation.Vec3Keyframe] = []
    let weights : Array[@animation.WeightKeyframe] = []
    match path {
      "translation" =>
        if read_accessor_vec3(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          for keyframe in parse_vec3_keyframes(times, values, interpolation) {
            translations.push(keyframe)
          }
        }
      "rotation" =>
        if read_accessor_quat(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          for keyframe in parse_quat_keyframes(times, values, interpolation) {
            rotations.push(keyframe)
          }
        }
      "scale" =>
        if read_accessor_vec3(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          for keyframe in parse_vec3_keyframes(times, values, interpolation) {
            scales.push(keyframe)
          }
        }
      "weights" =>
        if read_accessor_scalar(
            output_accessor, buffers, buffer_views, accessors,
          )
          is Some(values) {
          for keyframe in parse_weight_keyframes(times, values, interpolation) {
            weights.push(keyframe)
          }
        }
      _ => ()
    }
    if translations.length() == 0 &&
      rotations.length() == 0 &&
      scales.length() == 0 &&
      weights.length() == 0 {
      continue
    }
    output.push({
      target: target_id,
      translations,
      rotations,
      scales,
      weights,
      interpolation,
    })
  }
  output
}

///|
fn parse_vec3_keyframes(
  times : Array[Double],
  values : Array[@math.Vec3],
  interpolation : @animation.ChannelInterpolation,
) -> Array[@animation.Vec3Keyframe] {
  let output : Array[@animation.Vec3Keyframe] = []
  if interpolation is @animation.ChannelInterpolation::CubicSpline {
    let key_count = times.length()
    if key_count <= 0 || values.length() < key_count * 3 {
      return output
    }
    for index in 0..<key_count {
      let base = index * 3
      output.push({
        time: times[index],
        in_tangent: Some(values[base]),
        value: values[base + 1],
        out_tangent: Some(values[base + 2]),
      })
    }
    return output
  }
  let count = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  for index in 0..<count {
    output.push({
      time: times[index],
      value: values[index],
      in_tangent: None,
      out_tangent: None,
    })
  }
  output
}

///|
fn parse_quat_keyframes(
  times : Array[Double],
  values : Array[@math.Quat],
  interpolation : @animation.ChannelInterpolation,
) -> Array[@animation.QuatKeyframe] {
  let output : Array[@animation.QuatKeyframe] = []
  if interpolation is @animation.ChannelInterpolation::CubicSpline {
    let key_count = times.length()
    if key_count <= 0 || values.length() < key_count * 3 {
      return output
    }
    for index in 0..<key_count {
      let base = index * 3
      output.push({
        time: times[index],
        in_tangent: Some(values[base]),
        value: values[base + 1],
        out_tangent: Some(values[base + 2]),
      })
    }
    return output
  }
  let count = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  for index in 0..<count {
    output.push({
      time: times[index],
      value: values[index],
      in_tangent: None,
      out_tangent: None,
    })
  }
  output
}

///|
fn parse_weight_keyframes(
  times : Array[Double],
  values : Array[Double],
  interpolation : @animation.ChannelInterpolation,
) -> Array[@animation.WeightKeyframe] {
  let output : Array[@animation.WeightKeyframe] = []
  let key_count = times.length()
  if key_count <= 0 || values.length() < key_count {
    return output
  }
  let lanes_per_key = match interpolation {
    @animation.ChannelInterpolation::CubicSpline => 3
    _ => 1
  }
  if values.length() < key_count * lanes_per_key {
    return output
  }
  let lane_count = values.length() / (key_count * lanes_per_key)
  if lane_count <= 0 {
    return output
  }
  for index in 0..<key_count {
    let base = index * lane_count * lanes_per_key
    let value_index = if interpolation
      is @animation.ChannelInterpolation::CubicSpline {
      base + lane_count
    } else {
      base
    }
    let weight_values : Array[Double] = []
    let in_tangent : Array[Double] = []
    let out_tangent : Array[Double] = []
    for lane in 0..<lane_count {
      if interpolation is @animation.ChannelInterpolation::CubicSpline {
        in_tangent.push(values[base + lane])
        weight_values.push(values[value_index + lane])
        out_tangent.push(values[value_index + lane_count + lane])
      } else {
        weight_values.push(values[value_index + lane])
      }
    }
    output.push({
      time: times[index],
      value: weight_values,
      in_tangent: if interpolation
        is @animation.ChannelInterpolation::CubicSpline {
        Some(in_tangent)
      } else {
        None
      },
      out_tangent: if interpolation
        is @animation.ChannelInterpolation::CubicSpline {
        Some(out_tangent)
      } else {
        None
      },
    })
  }
  output
}

///|
fn parse_image_handles(
  scene_path : String,
  root_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> Array[@render3d.ImageHandle?] {
  guard root_object.get("images") is Some(images_json) else { return [] }
  guard json_array(images_json) is Some(images) else { return [] }
  let handles : Array[@render3d.ImageHandle?] = []
  for image_json in images {
    guard json_object(image_json) is Some(image_object) else {
      handles.push(None)
      continue
    }
    if image_object.get("uri") is Some(uri_json) {
      guard json_string(uri_json) is Some(uri) else {
        handles.push(None)
        continue
      }
      let resolved = resolve_relative_asset_path(scene_path, uri)
      handles.push(Some(@render3d.register_image_asset({ path: resolved })))
      continue
    }
    guard field_int(image_object, "bufferView") is Some(buffer_view_index) else {
      handles.push(None)
      continue
    }
    let mime_type = field_string(image_object, "mimeType").unwrap_or(
      "image/png",
    )
    guard resolve_buffer_view_bytes(buffer_view_index, buffers, buffer_views)
      is Some(image_bytes) else {
      handles.push(None)
      continue
    }
    let data_uri = "data:\{mime_type};base64,\{@base64.encode(image_bytes[:])}"
    handles.push(Some(@render3d.register_image_asset({ path: data_uri })))
  }
  handles
}

///|
fn parse_texture_sources(
  root_object : Map[String, Json],
  image_handles : Array[@render3d.ImageHandle?],
) -> Array[TextureSourceTemplate?] {
  guard root_object.get("textures") is Some(textures_json) else { return [] }
  guard json_array(textures_json) is Some(textures) else { return [] }
  let samplers = parse_texture_samplers(root_object)
  let sources : Array[TextureSourceTemplate?] = []
  for texture_json in textures {
    guard json_object(texture_json) is Some(texture_object) else {
      sources.push(None)
      continue
    }
    let image_handle = match field_int(texture_object, "source") {
      Some(image_index) => image_handles.get(image_index).unwrap_or(None)
      None => None
    }
    let sampler = match field_int(texture_object, "sampler") {
      Some(sampler_index) =>
        samplers
        .get(sampler_index)
        .unwrap_or(@render3d.default_texture_sampler3d())
      None => @render3d.default_texture_sampler3d()
    }
    sources.push(Some({ image: image_handle, sampler }))
  }
  sources
}

///|
fn parse_texture_samplers(
  root_object : Map[String, Json],
) -> Array[@render3d.TextureSampler3D] {
  guard root_object.get("samplers") is Some(samplers_json) else { return [] }
  guard json_array(samplers_json) is Some(samplers) else { return [] }
  let output : Array[@render3d.TextureSampler3D] = []
  for sampler_json in samplers {
    let mut sampler = @render3d.default_texture_sampler3d()
    if json_object(sampler_json) is Some(sampler_object) {
      sampler = {
        ..sampler,
        wrap_u: parse_texture_wrap(
          field_int(sampler_object, "wrapS").unwrap_or(10497),
        ),
        wrap_v: parse_texture_wrap(
          field_int(sampler_object, "wrapT").unwrap_or(10497),
        ),
      }
      let min_filter = field_int(sampler_object, "minFilter")
      sampler = {
        ..sampler,
        min_filter: parse_texture_min_filter(min_filter).0,
        mipmap_filter: parse_texture_min_filter(min_filter).1,
      }
      sampler = {
        ..sampler,
        mag_filter: parse_texture_mag_filter(
          field_int(sampler_object, "magFilter").unwrap_or(9729),
        ),
      }
    }
    output.push(sampler)
  }
  output
}

///|
fn parse_texture_wrap(value : Int) -> @render3d.TextureWrap3D {
  match value {
    33071 => ClampToEdge
    33648 => MirroredRepeat
    _ => Repeat
  }
}

///|
fn parse_texture_mag_filter(value : Int) -> @render3d.TextureFilter3D {
  match value {
    9728 => Nearest
    _ => Linear
  }
}

///|
fn parse_texture_min_filter(
  value : Int?,
) -> (@render3d.TextureFilter3D, @render3d.TextureFilter3D?) {
  match value {
    Some(9728) => (Nearest, None)
    Some(9729) => (Linear, None)
    Some(9984) => (Nearest, Some(Nearest))
    Some(9985) => (Linear, Some(Nearest))
    Some(9986) => (Nearest, Some(Linear))
    Some(9987) => (Linear, Some(Linear))
    _ => (Linear, Some(Linear))
  }
}

///|
fn parse_material_handles(
  root_object : Map[String, Json],
  texture_sources : Array[TextureSourceTemplate?],
  _image_handles : Array[@render3d.ImageHandle?],
) -> Array[@render3d.MaterialHandle] {
  guard root_object.get("materials") is Some(materials_json) else { return [] }
  guard json_array(materials_json) is Some(materials) else { return [] }
  let handles : Array[@render3d.MaterialHandle] = []
  for material_json in materials {
    let material = parse_material_asset(material_json, texture_sources)
    handles.push(@render3d.register_material_asset(material))
  }
  handles
}

///|
fn parse_material_asset(
  material_json : Json,
  texture_sources : Array[TextureSourceTemplate?],
) -> @render3d.StandardMaterial3D {
  guard json_object(material_json) is Some(material_object) else {
    return @render3d.default_standard_material3d()
  }
  let mut material = @render3d.default_standard_material3d()
  material = match field_string(material_object, "alphaMode") {
    Some(alpha) => {
      let alpha_mode = match alpha.to_lower() {
        "mask" => @render3d.AlphaMode3D::Mask
        "blend" => @render3d.AlphaMode3D::Blend
        _ => @render3d.AlphaMode3D::Opaque
      }
      { ..material, alpha_mode, }
    }
    None => material
  }
  material = match field_number(material_object, "alphaCutoff") {
    Some(alpha_cutoff) => { ..material, alpha_cutoff, }
    None => material
  }
  material = match field_bool(material_object, "doubleSided") {
    Some(double_sided) => { ..material, double_sided, }
    None => material
  }
  if material_has_unlit_extension(material_object) {
    material = { ..material, unlit: true }
  }
  material = match field_array(material_object, "emissiveFactor") {
    Some(values) =>
      if values.length() >= 3 {
        let r = json_number(values[0]).unwrap_or(0.0)
        let g = json_number(values[1]).unwrap_or(0.0)
        let b = json_number(values[2]).unwrap_or(0.0)
        { ..material, emissive_color: color_from_factor4([r, g, b, 1.0]) }
      } else {
        material
      }
    None => material
  }
  material = match field_object(material_object, "emissiveTexture") {
    Some(emissive_texture) =>
      match
        resolve_texture_binding(
          emissive_texture,
          texture_sources,
          texture_transform=true,
        ) {
        Some(binding) => { ..material, emissive_texture: Some(binding) }
        None => material
      }
    None => material
  }
  material = match field_object(material_object, "normalTexture") {
    Some(normal_texture) =>
      match
        resolve_texture_binding(
          normal_texture,
          texture_sources,
          texture_transform=true,
        ) {
        Some(binding) =>
          {
            ..material,
            normal_texture: Some(binding),
            normal_scale: field_number(normal_texture, "scale").unwrap_or(1.0),
          }
        None => material
      }
    None => material
  }
  material = match field_object(material_object, "occlusionTexture") {
    Some(occlusion_texture) =>
      match
        resolve_texture_binding(
          occlusion_texture,
          texture_sources,
          texture_transform=true,
        ) {
        Some(binding) =>
          {
            ..material,
            occlusion_texture: Some(binding),
            occlusion_strength: field_number(occlusion_texture, "strength").unwrap_or(
              1.0,
            ),
          }
        None => material
      }
    None => material
  }
  material = match field_object(material_object, "pbrMetallicRoughness") {
    Some(pbr_object) =>
      parse_pbr_material(material, pbr_object, texture_sources)
    None => material
  }
  material
}

///|
fn material_has_unlit_extension(material_object : Map[String, Json]) -> Bool {
  match field_object(material_object, "extensions") {
    Some(extensions) => field_json(extensions, "KHR_materials_unlit") is Some(_)
    None => false
  }
}

///|
fn parse_pbr_material(
  material : @render3d.StandardMaterial3D,
  pbr_object : Map[String, Json],
  texture_sources : Array[TextureSourceTemplate?],
) -> @render3d.StandardMaterial3D {
  let mut output = material
  output = match field_array(pbr_object, "baseColorFactor") {
    Some(values) =>
      if values.length() >= 4 {
        {
          ..output,
          base_color: color_from_factor4([
            json_number(values[0]).unwrap_or(1.0),
            json_number(values[1]).unwrap_or(1.0),
            json_number(values[2]).unwrap_or(1.0),
            json_number(values[3]).unwrap_or(1.0),
          ]),
        }
      } else {
        output
      }
    None => output
  }
  output = match field_number(pbr_object, "metallicFactor") {
    Some(metallic) => { ..output, metallic, }
    None => output
  }
  output = match field_number(pbr_object, "roughnessFactor") {
    Some(roughness) => { ..output, roughness, }
    None => output
  }
  output = match field_object(pbr_object, "baseColorTexture") {
    Some(base_texture) =>
      match
        resolve_texture_binding(
          base_texture,
          texture_sources,
          texture_transform=true,
        ) {
        Some(binding) => { ..output, base_color_texture: Some(binding) }
        None => output
      }
    None => output
  }
  output = match field_object(pbr_object, "metallicRoughnessTexture") {
    Some(metallic_roughness_texture) =>
      match
        resolve_texture_binding(
          metallic_roughness_texture,
          texture_sources,
          texture_transform=true,
        ) {
        Some(binding) => { ..output, metallic_roughness_texture: Some(binding) }
        None => output
      }
    None => output
  }
  output
}
