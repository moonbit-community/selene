// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
priv struct SceneNodeTemplate {
  name : String?
  transform : @transform3d.Transform3D
  renderers : Array[MeshRendererTemplate]
  skin_index : Int?
  morph_weights : Array[Double]
  camera : @camera3d.Camera3DComponent?
  directional_light : @render3d.DirectionalLight3D?
  point_light : @render3d.PointLight3D?
  spot_light : @render3d.SpotLight3D?
  children : Array[Int]
}

///|
priv struct SceneTemplate {
  roots : Array[Int]
  nodes : Array[SceneNodeTemplate]
  skins : Array[SkinTemplate]
  animations : Map[String, @animation3d.AnimationClipHandle]
}

///|
pub(all) struct SceneInstance {
  root : @entity.Entity
  parts : Map[String, @entity.Entity]
  animations : Map[String, @animation3d.AnimationClipHandle]
}

///|
priv struct MeshSceneTemplate {
  renderers : Array[MeshRendererTemplate]
  morph_weights : Array[Double]
  morph_target_count : Int
}

///|
priv struct MeshRendererTemplate {
  renderer : @render3d.Mesh3DRenderer
  skinned : SkinnedPrimitiveTemplate?
}

///|
priv struct MorphTargetTemplate {
  position_deltas : Array[@math.Vec3]?
  normal_deltas : Array[@math.Vec3]?
}

///|
priv struct SkinTemplate {
  joints : Array[Int]
  inverse_bind_matrices : Array[@math.Mat4]
}

///|
priv struct SkinnedPrimitiveTemplate {
  base_positions : Array[@math.Vec3]
  base_normals : Array[@math.Vec3]
  uv_sets : Array[Array[@math.Vec2D]]
  colors : Array[@render.Color]?
  tangents : Array[@render3d.Tangent3D]?
  morph_targets : Array[MorphTargetTemplate]
  morph_weights : Array[Double]
  influences : Array[@animation3d.SkinVertexInfluence3D]
}

///|
priv struct PendingSkinBinding {
  entity : @entity.Entity
  target_entity : @entity.Entity
  mesh : @render3d.MeshHandle
  skin_index : Int
  skinned : SkinnedPrimitiveTemplate
}

///|
priv struct ParsedMeshAsset {
  mesh : @render3d.MeshAsset
  skinned : SkinnedPrimitiveTemplate?
}

///|
priv struct AnimationSamplerTemplate {
  times : Array[Double]
  output_accessor : Int
  interpolation : @animation3d.ChannelInterpolation3D
}

///|
priv struct GltfSource {
  document : Json
  glb_buffers : Array[Bytes?]
}

///|
priv struct TextureSourceTemplate {
  image : @render3d.ImageHandle?
  sampler : @render3d.TextureSampler3D
}

///|
priv struct ParsedLightTemplate {
  directional : @render3d.DirectionalLight3D?
  point : @render3d.PointLight3D?
  spot : @render3d.SpotLight3D?
}

///|
priv struct BufferViewTemplate {
  buffer : Int
  byte_offset : Int
  byte_length : Int
  byte_stride : Int?
}

///|
priv struct SparseIndicesTemplate {
  buffer_view : Int
  byte_offset : Int
  component_type : Int
}

///|
priv struct SparseValuesTemplate {
  buffer_view : Int
  byte_offset : Int
}

///|
priv struct SparseAccessorTemplate {
  count : Int
  indices : SparseIndicesTemplate
  values : SparseValuesTemplate
}

///|
priv struct AccessorTemplate {
  buffer_view : Int?
  byte_offset : Int
  component_type : Int
  count : Int
  type_name : String
  normalized : Bool
  sparse : SparseAccessorTemplate?
}

///|
let scene_templates : Map[@render3d.SceneHandle, SceneTemplate] = Map::new()

///|
let scene_paths : Map[@render3d.SceneHandle, String] = Map::new()

///|
fn empty_scene_template() -> SceneTemplate {
  { roots: [], nodes: [], skins: [], animations: Map::new() }
}

///|
fn default_scene_node_template() -> SceneNodeTemplate {
  {
    name: None,
    transform: @transform3d.Transform3D::identity(),
    renderers: [],
    skin_index: None,
    morph_weights: [],
    camera: None,
    directional_light: None,
    point_light: None,
    spot_light: None,
    children: [],
  }
}

///|
/// Registers a glTF/GLB scene path and returns a stable scene handle.
pub fn load_scene_gltf(path : String) -> @render3d.SceneHandle {
  let handle = @render3d.register_scene_path(path)
  scene_paths.set(handle, path)
  scene_templates.set(handle, load_scene_template(path))
  handle
}

///|
/// Instantiates a scene root entity with the requested root transform.
pub fn instantiate_scene(
  scene : @render3d.SceneHandle,
  root_transform : @transform3d.Transform3D,
) -> @entity.Entity {
  instantiate_scene_instance(scene, root_transform).root
}

///|
pub fn instantiate_scene_instance(
  scene : @render3d.SceneHandle,
  root_transform : @transform3d.Transform3D,
) -> SceneInstance {
  let root = @entity.Entity::new()
  @transform3d.transforms3d.set(root, root_transform)
  let parts : Map[String, @entity.Entity] = Map::new()
  guard scene_templates.get(scene) is Some(template) else {
    return { root, parts, animations: Map::new() }
  }
  let node_entities : Map[Int, @entity.Entity] = Map::new()
  let pending_skin_bindings : Array[PendingSkinBinding] = []
  for root_order, node_index in template.roots {
    instantiate_scene_node(
      template,
      node_index,
      root,
      node_entities,
      pending_skin_bindings,
      parts,
      "root\{root_order}",
      0,
    )
  }
  resolve_scene_skin_bindings(template, node_entities, pending_skin_bindings)
  @animation3d.bind_animation_targets(root, node_entities, template.animations)
  if template.animations.length() > 0 {
    let first_clip = template.animations.values().next()
    if first_clip is Some(handle) {
      @animation3d.attach_animation_player(
        root,
        @animation3d.AnimationPlayer3D::from_clip(handle),
      )
    }
  }
  { root, parts, animations: template.animations.copy() }
}

///|
pub fn scene_instance_part(
  instance : SceneInstance,
  path : String,
) -> @entity.Entity? {
  instance.parts.get(path)
}

///|
pub fn scene_instance_animation(
  instance : SceneInstance,
  name : String,
) -> @animation3d.AnimationClipHandle? {
  instance.animations.get(name)
}

///|
pub fn play_scene_animation(
  instance : SceneInstance,
  name : String,
  repeat? : Bool = true,
) -> Bool {
  guard instance.animations.get(name) is Some(handle) else { return false }
  @animation3d.play_clip(instance.root, handle, repeat~)
  true
}

///|
pub fn set_scene_animation_graph(
  instance : SceneInstance,
  graph : @animation3d.AnimationGraph3D,
  repeat? : Bool = true,
) -> Unit {
  @animation3d.set_animation_graph(instance.root, graph, repeat~)
}

///|
pub fn trigger_scene_animation(
  instance : SceneInstance,
  trigger : String,
) -> Unit {
  @animation3d.trigger_animation(instance.root, trigger)
}

///|
fn resolve_scene_skin_bindings(
  template : SceneTemplate,
  node_entities : Map[Int, @entity.Entity],
  pending_skin_bindings : Array[PendingSkinBinding],
) -> Unit {
  for pending in pending_skin_bindings {
    guard pending.skin_index >= 0 &&
      pending.skin_index < template.skins.length() else {
      continue
    }
    let skin = template.skins[pending.skin_index]
    let joint_entities : Array[@entity.Entity] = []
    let mut complete = true
    for joint_node_index in skin.joints {
      guard node_entities.get(joint_node_index) is Some(joint_entity) else {
        complete = false
        break
      }
      joint_entities.push(joint_entity)
    }
    if joint_entities.length() == 0 || !complete {
      continue
    }
    @animation3d.bind_skinned_mesh(pending.entity, {
      target_entity: pending.target_entity,
      mesh: pending.mesh,
      base_positions: pending.skinned.base_positions,
      base_normals: pending.skinned.base_normals,
      uv_sets: pending.skinned.uv_sets,
      colors: pending.skinned.colors,
      tangents: pending.skinned.tangents,
      morph_targets: to_animation_morph_targets(pending.skinned.morph_targets),
      morph_weights: resolve_morph_weights(
        pending.skinned.morph_targets.length(),
        pending.skinned.morph_weights,
      ),
      influences: pending.skinned.influences,
      joint_entities,
      inverse_bind_matrices: skin.inverse_bind_matrices,
    })
  }
}

///|
fn clone_mesh_handle(handle : @render3d.MeshHandle) -> @render3d.MeshHandle {
  match @render3d.mesh_asset(handle) {
    Some(mesh_asset) => @render3d.register_mesh_asset(mesh_asset)
    None => handle
  }
}

///|
fn to_animation_morph_targets(
  targets : Array[MorphTargetTemplate],
) -> Array[@animation3d.MorphTargetBinding3D] {
  let output : Array[@animation3d.MorphTargetBinding3D] = []
  for target in targets {
    output.push({
      position_deltas: target.position_deltas,
      normal_deltas: target.normal_deltas,
    })
  }
  output
}

///|
fn bind_instantiated_morph_mesh(
  entity : @entity.Entity,
  target_entity : @entity.Entity,
  mesh : @render3d.MeshHandle,
  binding : SkinnedPrimitiveTemplate,
  morph_weights : Array[Double],
) -> Unit {
  @animation3d.bind_morph_mesh(entity, {
    target_entity,
    mesh,
    base_positions: binding.base_positions,
    base_normals: binding.base_normals,
    uv_sets: binding.uv_sets,
    colors: binding.colors,
    tangents: binding.tangents,
    morph_targets: to_animation_morph_targets(binding.morph_targets),
    morph_weights: resolve_morph_weights(
      binding.morph_targets.length(),
      morph_weights,
    ),
  })
}

///|
fn instantiate_scene_node(
  template : SceneTemplate,
  node_index : Int,
  parent : @entity.Entity,
  node_entities : Map[Int, @entity.Entity],
  pending_skin_bindings : Array[PendingSkinBinding],
  parts : Map[String, @entity.Entity],
  parent_path : String,
  depth : Int,
) -> Unit {
  if depth > 512 {
    return
  }
  guard node_index >= 0 && node_index < template.nodes.length() else { return }
  let node = template.nodes[node_index]
  let entity = parent.spawn_child()
  let base_name = node.name.unwrap_or("node\{node_index}")
  let path_base = "\{parent_path}/\{base_name}"
  let entity_path = if parts.contains(path_base) {
    "\{path_base}#\{node_index}"
  } else {
    path_base
  }
  parts.set(entity_path, entity)
  node_entities.set(node_index, entity)
  @transform3d.transforms3d.set(entity, node.transform)
  if node.camera is Some(camera) {
    @camera3d.cameras3d.set(entity, camera)
  }
  if node.directional_light is Some(light) {
    @render3d.directional_lights3d.set(entity, light)
  }
  if node.point_light is Some(light) {
    @render3d.point_lights3d.set(entity, light)
  }
  if node.spot_light is Some(light) {
    @render3d.spot_lights3d.set(entity, light)
  }
  if node.renderers.length() == 1 {
    let template_renderer = node.renderers[0]
    let renderer = match template_renderer.skinned {
      Some(_) =>
        {
          ..template_renderer.renderer,
          mesh: clone_mesh_handle(template_renderer.renderer.mesh),
        }
      None => template_renderer.renderer
    }
    @render3d.mesh3d_renderers.set(entity, renderer)
    if node.skin_index is Some(skin_index) &&
      template_renderer.skinned is Some(skinned) &&
      skinned.influences.length() > 0 {
      pending_skin_bindings.push({
        entity,
        target_entity: entity,
        mesh: renderer.mesh,
        skin_index,
        skinned: { ..skinned, morph_weights: node.morph_weights.copy() },
      })
    } else if template_renderer.skinned is Some(skinned) &&
      skinned.morph_targets.length() > 0 {
      bind_instantiated_morph_mesh(
        entity,
        entity,
        renderer.mesh,
        skinned,
        node.morph_weights,
      )
    }
  } else if node.renderers.length() > 1 {
    for primitive_index, template_renderer in node.renderers {
      let primitive_entity = entity.spawn_child()
      @transform3d.transforms3d.set(
        primitive_entity,
        @transform3d.Transform3D::identity(),
      )
      let renderer = match template_renderer.skinned {
        Some(_) =>
          {
            ..template_renderer.renderer,
            mesh: clone_mesh_handle(template_renderer.renderer.mesh),
          }
        None => template_renderer.renderer
      }
      @render3d.mesh3d_renderers.set(primitive_entity, renderer)
      parts.set("\{entity_path}/primitive\{primitive_index}", primitive_entity)
      if node.skin_index is Some(skin_index) &&
        template_renderer.skinned is Some(skinned) &&
        skinned.influences.length() > 0 {
        pending_skin_bindings.push({
          entity: primitive_entity,
          target_entity: entity,
          mesh: renderer.mesh,
          skin_index,
          skinned: { ..skinned, morph_weights: node.morph_weights.copy() },
        })
      } else if template_renderer.skinned is Some(skinned) &&
        skinned.morph_targets.length() > 0 {
        bind_instantiated_morph_mesh(
          primitive_entity,
          entity,
          renderer.mesh,
          skinned,
          node.morph_weights,
        )
      }
    }
  }
  for child_index in node.children {
    instantiate_scene_node(
      template,
      child_index,
      entity,
      node_entities,
      pending_skin_bindings,
      parts,
      entity_path,
      depth + 1,
    )
  }
}

///|
fn glb_magic_matches(bytes : Bytes) -> Bool {
  bytes.length() >= 4 &&
  bytes[0].to_int() == 0x67 &&
  bytes[1].to_int() == 0x6C &&
  bytes[2].to_int() == 0x54 &&
  bytes[3].to_int() == 0x46
}

///|
fn parse_glb_source(bytes : Bytes) -> GltfSource? {
  if bytes.length() < 20 {
    return None
  }
  guard read_u32_le(bytes, 4) is Some(version) && version == 2 else {
    return None
  }
  guard read_u32_le(bytes, 8) is Some(total_length) &&
    total_length <= bytes.length() else {
    return None
  }
  let mut offset = 12
  let mut json_document : Json? = None
  let glb_buffers : Array[Bytes?] = []
  while offset + 8 <= total_length {
    guard read_u32_le(bytes, offset) is Some(chunk_length) else { return None }
    guard read_u32_le(bytes, offset + 4) is Some(chunk_type) else {
      return None
    }
    let chunk_start = offset + 8
    let chunk_end = chunk_start + chunk_length
    if chunk_end > total_length || chunk_end > bytes.length() {
      return None
    }
    let chunk_bytes = bytes[chunk_start:chunk_end].to_bytes()
    match chunk_type {
      0x4E4F534A =>
        if json_document is None {
          let parsed : Result[Json, @json.ParseError] = try? @json.parse(
            chunk_bytes.to_unchecked_string().view(),
          )
          guard parsed is Ok(document) else { return None }
          json_document = Some(document)
        }
      0x004E4942 => glb_buffers.push(Some(chunk_bytes))
      _ => ()
    }
    offset = chunk_end
  }
  match json_document {
    Some(document) => Some({ document, glb_buffers })
    None => None
  }
}

///|
fn load_scene_template(path : String) -> SceneTemplate {
  guard @asset2.read_bytes(path) is Some(bytes) else {
    return empty_scene_template()
  }
  match parse_gltf_source(bytes) {
    Some(source) => parse_scene_template(path, source)
    None => empty_scene_template()
  }
}

///|
fn parse_gltf_source(bytes : Bytes) -> GltfSource? {
  if glb_magic_matches(bytes) {
    return parse_glb_source(bytes)
  }
  let source = bytes.to_unchecked_string()
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  match parsed {
    Ok(document) => Some({ document, glb_buffers: [] })
    Err(_) => None
  }
}

///|
fn parse_scene_template(path : String, source : GltfSource) -> SceneTemplate {
  guard json_object(source.document) is Some(root_object) else {
    return empty_scene_template()
  }
  let buffers = parse_buffer_blobs(path, root_object, source.glb_buffers)
  let buffer_views = parse_buffer_views(root_object)
  let accessors = parse_accessors(root_object)
  let image_handles = parse_image_handles(
    path, root_object, buffers, buffer_views,
  )
  let texture_sources = parse_texture_sources(root_object, image_handles)
  let material_handles = parse_material_handles(
    root_object, texture_sources, image_handles,
  )
  let skins = parse_skin_templates(
    root_object, buffers, buffer_views, accessors,
  )
  let cameras = parse_camera_templates(root_object)
  let lights = parse_light_templates(root_object)
  let mesh_templates = parse_mesh_templates(
    root_object, material_handles, buffers, buffer_views, accessors,
  )
  let nodes = parse_node_templates(root_object, mesh_templates, cameras, lights)
  let roots = parse_root_nodes(root_object, nodes.length())
  let animations = parse_animation_clips(
    root_object, buffers, buffer_views, accessors,
  )
  { roots, nodes, skins, animations }
}

///|
fn parse_skin_templates(
  root_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[SkinTemplate] {
  guard root_object.get("skins") is Some(skins_json) else { return [] }
  guard json_array(skins_json) is Some(skins) else { return [] }
  let output : Array[SkinTemplate] = []
  for skin_json in skins {
    guard json_object(skin_json) is Some(skin_object) else {
      output.push({ joints: [], inverse_bind_matrices: [] })
      continue
    }
    let joints = match field_array(skin_object, "joints") {
      Some(joints_json) => {
        let values : Array[Int] = []
        for value in joints_json {
          if json_int(value) is Some(index) {
            values.push(index)
          }
        }
        values
      }
      None => []
    }
    let inverse_bind_matrices = match
      field_int(skin_object, "inverseBindMatrices") {
      Some(accessor_index) =>
        read_accessor_mat4(accessor_index, buffers, buffer_views, accessors).unwrap_or([],
        )
      None => []
    }
    let matrices = inverse_bind_matrices.copy()
    while matrices.length() < joints.length() {
      matrices.push(@math.Mat4::identity())
    }
    output.push({ joints, inverse_bind_matrices: matrices })
  }
  output
}

///|
fn parse_animation_clips(
  root_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Map[String, @animation3d.AnimationClipHandle] {
  let animations : Map[String, @animation3d.AnimationClipHandle] = Map::new()
  guard root_object.get("animations") is Some(animations_json) else {
    return animations
  }
  guard json_array(animations_json) is Some(animation_items) else {
    return animations
  }
  for animation_index, animation_json in animation_items {
    guard json_object(animation_json) is Some(animation_object) else {
      continue
    }
    let channels = parse_animation_channels(
      animation_object, buffers, buffer_views, accessors,
    )
    if channels.length() == 0 {
      continue
    }
    let mut duration = 0.0
    for channel in channels {
      if channel.translations.length() > 0 {
        let end = channel.translations[channel.translations.length() - 1].time
        if end > duration {
          duration = end
        }
      }
      if channel.rotations.length() > 0 {
        let end = channel.rotations[channel.rotations.length() - 1].time
        if end > duration {
          duration = end
        }
      }
      if channel.scales.length() > 0 {
        let end = channel.scales[channel.scales.length() - 1].time
        if end > duration {
          duration = end
        }
      }
      if channel.weights.length() > 0 {
        let end = channel.weights[channel.weights.length() - 1].time
        if end > duration {
          duration = end
        }
      }
    }
    let name = field_string(animation_object, "name").unwrap_or(
      "animation_\{animation_index}",
    )
    let clip_handle = @animation3d.register_animation_clip({
      name,
      duration,
      channels,
    })
    animations.set(name, clip_handle)
  }
  animations
}

///|
fn parse_animation_channels(
  animation_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@animation3d.AnimationChannel3D] {
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
      "STEP" => @animation3d.ChannelInterpolation3D::Step
      "CUBICSPLINE" => @animation3d.ChannelInterpolation3D::CubicSpline
      _ => @animation3d.ChannelInterpolation3D::Linear
    }
    samplers.push(Some({ times, output_accessor, interpolation }))
  }

  let output : Array[@animation3d.AnimationChannel3D] = []
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
    let path = field_string(target_object, "path").map_or("", fn(v) {
      v.to_lower()
    })
    let times = sampler.times
    let output_accessor = sampler.output_accessor
    let interpolation = sampler.interpolation
    let translations : Array[@animation3d.Vec3Keyframe3D] = []
    let rotations : Array[@animation3d.QuatKeyframe3D] = []
    let scales : Array[@animation3d.Vec3Keyframe3D] = []
    let weights : Array[@animation3d.WeightKeyframe3D] = []
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
      node: node_index,
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
  interpolation : @animation3d.ChannelInterpolation3D,
) -> Array[@animation3d.Vec3Keyframe3D] {
  let output : Array[@animation3d.Vec3Keyframe3D] = []
  if interpolation is @animation3d.ChannelInterpolation3D::CubicSpline {
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
  interpolation : @animation3d.ChannelInterpolation3D,
) -> Array[@animation3d.QuatKeyframe3D] {
  let output : Array[@animation3d.QuatKeyframe3D] = []
  if interpolation is @animation3d.ChannelInterpolation3D::CubicSpline {
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
  interpolation : @animation3d.ChannelInterpolation3D,
) -> Array[@animation3d.WeightKeyframe3D] {
  let output : Array[@animation3d.WeightKeyframe3D] = []
  let key_count = times.length()
  if key_count <= 0 || values.length() < key_count {
    return output
  }
  let lanes_per_key = match interpolation {
    @animation3d.ChannelInterpolation3D::CubicSpline => 3
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
      is @animation3d.ChannelInterpolation3D::CubicSpline {
      base + lane_count
    } else {
      base
    }
    let weight_values : Array[Double] = []
    let in_tangent : Array[Double] = []
    let out_tangent : Array[Double] = []
    for lane in 0..<lane_count {
      if interpolation is @animation3d.ChannelInterpolation3D::CubicSpline {
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
        is @animation3d.ChannelInterpolation3D::CubicSpline {
        Some(in_tangent)
      } else {
        None
      },
      out_tangent: if interpolation
        is @animation3d.ChannelInterpolation3D::CubicSpline {
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
      match resolve_texture_binding(emissive_texture, texture_sources) {
        Some(binding) => { ..material, emissive_texture: Some(binding) }
        None => material
      }
    None => material
  }
  material = match field_object(material_object, "normalTexture") {
    Some(normal_texture) =>
      match resolve_texture_binding(normal_texture, texture_sources) {
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
      match resolve_texture_binding(occlusion_texture, texture_sources) {
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
      match resolve_texture_binding(base_texture, texture_sources) {
        Some(binding) => { ..output, base_color_texture: Some(binding) }
        None => output
      }
    None => output
  }
  output = match field_object(pbr_object, "metallicRoughnessTexture") {
    Some(metallic_roughness_texture) =>
      match
        resolve_texture_binding(metallic_roughness_texture, texture_sources) {
        Some(binding) => { ..output, metallic_roughness_texture: Some(binding) }
        None => output
      }
    None => output
  }
  output
}

///|
fn resolve_texture_binding(
  texture_object : Map[String, Json],
  texture_sources : Array[TextureSourceTemplate?],
) -> @render3d.TextureBinding3D? {
  guard field_int(texture_object, "index") is Some(texture_index) else {
    return None
  }
  guard texture_sources.get(texture_index) is Some(Some(source)) else {
    return None
  }
  guard source.image is Some(image_handle) else { return None }
  Some(
    @render3d.texture_binding3d(
      image_handle,
      texcoord_set=field_int(texture_object, "texCoord").unwrap_or(0),
      sampler=source.sampler,
    ),
  )
}

///|
fn parse_buffer_blobs(
  scene_path : String,
  root_object : Map[String, Json],
  glb_buffers : Array[Bytes?],
) -> Array[Bytes?] {
  guard root_object.get("buffers") is Some(buffers_json) else { return [] }
  guard json_array(buffers_json) is Some(buffers) else { return [] }
  let blobs : Array[Bytes?] = []
  for buffer_index, buffer_json in buffers {
    guard json_object(buffer_json) is Some(buffer_object) else {
      blobs.push(None)
      continue
    }
    if field_string(buffer_object, "uri") is Some(uri) {
      if uri.to_lower().has_prefix("data:") {
        blobs.push(decode_data_uri_base64(uri))
      } else {
        let resolved = resolve_relative_asset_path(scene_path, uri)
        blobs.push(@asset2.read_bytes(resolved))
      }
      continue
    }
    blobs.push(glb_buffers.get(buffer_index).unwrap_or(None))
  }
  blobs
}

///|
fn decode_data_uri_base64(uri : String) -> Bytes? {
  guard uri.find(",") is Some(comma_idx) else { return None }
  let meta = uri.unsafe_substring(start=0, end=comma_idx).to_lower()
  if !meta.has_suffix(";base64") {
    return None
  }
  let payload = uri.unsafe_substring(start=comma_idx + 1, end=uri.length())
  Some(@base64.decode_lossy(payload.view()))
}

///|
fn parse_buffer_views(
  root_object : Map[String, Json],
) -> Array[BufferViewTemplate?] {
  guard root_object.get("bufferViews") is Some(views_json) else { return [] }
  guard json_array(views_json) is Some(views) else { return [] }
  let templates : Array[BufferViewTemplate?] = []
  for view_json in views {
    guard json_object(view_json) is Some(view_object) else {
      templates.push(None)
      continue
    }
    guard field_int(view_object, "buffer") is Some(buffer_index) else {
      templates.push(None)
      continue
    }
    guard field_int(view_object, "byteLength") is Some(byte_length) else {
      templates.push(None)
      continue
    }
    if buffer_index < 0 || byte_length <= 0 {
      templates.push(None)
      continue
    }
    templates.push(
      Some({
        buffer: buffer_index,
        byte_offset: field_int(view_object, "byteOffset").unwrap_or(0),
        byte_length,
        byte_stride: field_int(view_object, "byteStride"),
      }),
    )
  }
  templates
}

///|
fn resolve_buffer_view_bytes(
  buffer_view_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> Bytes? {
  guard buffer_view_index >= 0 else { return None }
  guard buffer_views.get(buffer_view_index) is Some(Some(view)) else {
    return None
  }
  guard buffers.get(view.buffer) is Some(Some(bytes)) else { return None }
  let start = view.byte_offset
  let end_ = start + view.byte_length
  if start < 0 || end_ > bytes.length() || end_ < start {
    return None
  }
  Some(bytes[start:end_].to_bytes())
}

///|
fn parse_accessors(root_object : Map[String, Json]) -> Array[AccessorTemplate?] {
  guard root_object.get("accessors") is Some(accessors_json) else { return [] }
  guard json_array(accessors_json) is Some(accessors) else { return [] }
  let templates : Array[AccessorTemplate?] = []
  for accessor_json in accessors {
    guard json_object(accessor_json) is Some(accessor_object) else {
      templates.push(None)
      continue
    }
    guard field_int(accessor_object, "componentType") is Some(component_type) else {
      templates.push(None)
      continue
    }
    guard field_int(accessor_object, "count") is Some(count) else {
      templates.push(None)
      continue
    }
    let buffer_view = field_int(accessor_object, "bufferView")
    let sparse = parse_sparse_accessor(accessor_object)
    if count <= 0 ||
      (buffer_view is Some(view) && view < 0) ||
      (buffer_view is None && sparse is None) {
      templates.push(None)
      continue
    }
    templates.push(
      Some({
        buffer_view,
        byte_offset: field_int(accessor_object, "byteOffset").unwrap_or(0),
        component_type,
        count,
        type_name: field_string(accessor_object, "type").unwrap_or("SCALAR"),
        normalized: field_bool(accessor_object, "normalized").unwrap_or(false),
        sparse,
      }),
    )
  }
  templates
}

///|
fn parse_sparse_accessor(
  accessor_object : Map[String, Json],
) -> SparseAccessorTemplate? {
  guard field_object(accessor_object, "sparse") is Some(sparse_object) else {
    return None
  }
  guard field_int(sparse_object, "count") is Some(count) && count > 0 else {
    return None
  }
  guard field_object(sparse_object, "indices") is Some(indices_object) else {
    return None
  }
  guard field_int(indices_object, "bufferView") is Some(indices_buffer_view) else {
    return None
  }
  guard field_int(indices_object, "componentType")
    is Some(indices_component_type) else {
    return None
  }
  guard field_object(sparse_object, "values") is Some(values_object) else {
    return None
  }
  guard field_int(values_object, "bufferView") is Some(values_buffer_view) else {
    return None
  }
  Some({
    count,
    indices: {
      buffer_view: indices_buffer_view,
      byte_offset: field_int(indices_object, "byteOffset").unwrap_or(0),
      component_type: indices_component_type,
    },
    values: {
      buffer_view: values_buffer_view,
      byte_offset: field_int(values_object, "byteOffset").unwrap_or(0),
    },
  })
}

///|
fn parse_mesh_templates(
  root_object : Map[String, Json],
  material_handles : Array[@render3d.MaterialHandle],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[MeshSceneTemplate?] {
  guard root_object.get("meshes") is Some(meshes_json) else { return [] }
  guard json_array(meshes_json) is Some(meshes) else { return [] }
  let default_material = @render3d.register_material_asset(
    @render3d.default_standard_material3d(),
  )
  let templates : Array[MeshSceneTemplate?] = []
  for mesh_json in meshes {
    guard json_object(mesh_json) is Some(mesh_object) else {
      templates.push(None)
      continue
    }
    let default_morph_weights = parse_morph_weight_values(
      field_array(mesh_object, "weights"),
    )
    guard mesh_object.get("primitives") is Some(primitives_json) else {
      templates.push(None)
      continue
    }
    guard json_array(primitives_json) is Some(primitives) else {
      templates.push(None)
      continue
    }
    if primitives.length() == 0 {
      templates.push(None)
      continue
    }
    let renderers : Array[MeshRendererTemplate] = []
    let mut morph_target_count = 0
    for primitive_json in primitives {
      guard json_object(primitive_json) is Some(primitive_object) else {
        continue
      }
      let parsed_asset = parse_mesh_asset(
        mesh_object, primitive_object, buffers, buffer_views, accessors,
      )
      let mesh_handle = @render3d.register_mesh_asset(parsed_asset.mesh)
      let material_handle = match field_int(primitive_object, "material") {
        Some(material_index) =>
          material_handles.get(material_index).unwrap_or(default_material)
        None => default_material
      }
      renderers.push({
        renderer: {
          mesh: mesh_handle,
          material: material_handle,
          visible: true,
        },
        skinned: parsed_asset.skinned.map(fn(binding) {
          {
            ..binding,
            morph_weights: resolve_morph_weights(
              binding.morph_targets.length(),
              default_morph_weights,
            ),
          }
        }),
      })
      if parsed_asset.skinned is Some(binding) &&
        binding.morph_targets.length() > morph_target_count {
        morph_target_count = binding.morph_targets.length()
      }
    }
    if renderers.length() == 0 {
      templates.push(None)
      continue
    }
    let template_morph_weights = resolve_morph_weights(
      morph_target_count, default_morph_weights,
    )
    templates.push(
      Some({
        renderers,
        morph_weights: template_morph_weights,
        morph_target_count,
      }),
    )
  }
  templates
}

///|
fn parse_mesh_asset(
  mesh_object : Map[String, Json],
  primitive_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> ParsedMeshAsset {
  if parse_triangle_mesh_asset(
      primitive_object, buffers, buffer_views, accessors,
    )
    is Some(parsed_triangle_mesh) {
    return parsed_triangle_mesh
  }
  if parse_mesh_asset_from_extras(mesh_object, primitive_object) is Some(asset) {
    return { mesh: asset, skinned: None }
  }
  { mesh: @render3d.cube_mesh(@math.Vec3::one()), skinned: None }
}

///|
fn parse_mesh_asset_from_extras(
  mesh_object : Map[String, Json],
  primitive_object : Map[String, Json],
) -> @render3d.MeshAsset? {
  let extras = if primitive_object.get("extras") is Some(primitive_extras) {
    Some(primitive_extras)
  } else {
    mesh_object.get("extras")
  }
  guard extras is Some(extras_json) else { return None }
  guard json_object(extras_json) is Some(extras_object) else { return None }
  let primitive = field_string(extras_object, "selenePrimitive").map_or(
    "cube",
    fn(name) { name.to_lower() },
  )
  Some(
    match primitive {
      "sphere" =>
        @render3d.sphere_mesh(
          field_number(extras_object, "radius").unwrap_or(0.5),
        )
      "cylinder" =>
        @render3d.cylinder_mesh(
          field_number(extras_object, "radiusTop").unwrap_or(0.5),
          field_number(extras_object, "radiusBottom").unwrap_or(0.5),
          field_number(extras_object, "height").unwrap_or(1.0),
          slices=field_int(extras_object, "slices").unwrap_or(24),
        )
      "plane" =>
        @render3d.plane_mesh(
          parse_vec3(extras_object.get("size"), @math.Vec3::new(1.0, 0.1, 1.0)),
        )
      _ =>
        @render3d.cube_mesh(
          parse_vec3(extras_object.get("size"), @math.Vec3::one()),
        )
    },
  )
}

///|
fn parse_triangle_mesh_asset(
  primitive_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> ParsedMeshAsset? {
  guard field_object(primitive_object, "attributes") is Some(attributes_object) else {
    return None
  }
  guard field_int(attributes_object, "POSITION")
    is Some(position_accessor_index) else {
    return None
  }
  guard read_accessor_vec3(
      position_accessor_index, buffers, buffer_views, accessors,
    )
    is Some(positions) else {
    return None
  }
  if positions.length() == 0 {
    return None
  }
  let indices = match field_int(primitive_object, "indices") {
    Some(indices_accessor_index) =>
      read_accessor_indices(
        indices_accessor_index, buffers, buffer_views, accessors,
      ).unwrap_or(default_mesh_indices(positions.length()))
    None => default_mesh_indices(positions.length())
  }
  let mode = field_int(primitive_object, "mode").unwrap_or(4)
  let triangle_indices = decode_triangle_indices(indices, mode)
  if triangle_indices.length() < 3 {
    return None
  }
  guard map_indices_vec3(positions, triangle_indices)
    is Some(triangle_positions) else {
    return None
  }
  let triangle_normals = match field_int(attributes_object, "NORMAL") {
    Some(normal_accessor_index) =>
      match
        read_accessor_vec3(
          normal_accessor_index, buffers, buffer_views, accessors,
        ) {
        Some(normals) =>
          map_indices_vec3(normals, triangle_indices).unwrap_or(
            compute_flat_triangle_normals(triangle_positions),
          )
        None => compute_flat_triangle_normals(triangle_positions)
      }
    None => compute_flat_triangle_normals(triangle_positions)
  }
  let triangle_uv_sets = parse_triangle_uv_sets(
    attributes_object, triangle_indices, buffers, buffer_views, accessors,
  )
  let triangle_colors = parse_triangle_colors(
    attributes_object, triangle_indices, buffers, buffer_views, accessors,
  )
  let triangle_tangents = parse_triangle_tangents(
    attributes_object, triangle_indices, buffers, buffer_views, accessors,
  )
  let skinned = parse_triangle_binding(
    primitive_object, attributes_object, triangle_indices, triangle_positions, triangle_normals,
    triangle_uv_sets, triangle_colors, triangle_tangents, buffers, buffer_views,
    accessors,
  )
  Some({
    mesh: @render3d.triangle_mesh(
      triangle_positions,
      uv_sets=triangle_uv_sets,
      normals=Some(triangle_normals),
      tangents=triangle_tangents,
      colors=triangle_colors,
    ),
    skinned,
  })
}

///|
fn parse_triangle_binding(
  primitive_object : Map[String, Json],
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  triangle_positions : Array[@math.Vec3],
  triangle_normals : Array[@math.Vec3],
  triangle_uv_sets : Array[Array[@math.Vec2D]],
  triangle_colors : Array[@render.Color]?,
  triangle_tangents : Array[@render3d.Tangent3D]?,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> SkinnedPrimitiveTemplate? {
  let triangle_influences = parse_triangle_influences(
    attributes_object, triangle_indices, buffers, buffer_views, accessors,
  )
  let morph_targets = parse_triangle_morph_targets(
    primitive_object, triangle_indices, buffers, buffer_views, accessors,
  )
  if triangle_influences is None && morph_targets.length() == 0 {
    return None
  }
  let influences : Array[@animation3d.SkinVertexInfluence3D] = []
  if triangle_influences is Some(mapped_influences) {
    for influence in mapped_influences {
      influences.push(influence)
    }
  }
  Some({
    base_positions: triangle_positions,
    base_normals: triangle_normals,
    uv_sets: triangle_uv_sets,
    colors: triangle_colors,
    tangents: triangle_tangents,
    morph_targets,
    morph_weights: [],
    influences,
  })
}

///|
fn parse_triangle_uv_sets(
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Array[@math.Vec2D]] {
  let max_set = max_attribute_set_index(attributes_object, "TEXCOORD_")
  if max_set < 0 {
    return []
  }
  let uv_sets : Array[Array[@math.Vec2D]] = []
  for set_index in 0..<(max_set + 1) {
    let mapped_uvs = match
      field_int(attributes_object, "TEXCOORD_\{set_index}") {
      Some(accessor_index) =>
        read_accessor_vec2(accessor_index, buffers, buffer_views, accessors)
        .bind(fn(values) { map_indices_vec2(values, triangle_indices) })
        .unwrap_or([])
      None => []
    }
    uv_sets.push(mapped_uvs)
  }
  uv_sets
}

///|
fn parse_triangle_colors(
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render.Color]? {
  guard field_int(attributes_object, "COLOR_0") is Some(accessor_index) else {
    return None
  }
  read_accessor_color(accessor_index, buffers, buffer_views, accessors).bind(fn(
    values,
  ) {
    map_indices_color(values, triangle_indices)
  })
}

///|
fn parse_triangle_tangents(
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render3d.Tangent3D]? {
  guard field_int(attributes_object, "TANGENT") is Some(accessor_index) else {
    return None
  }
  read_accessor_tangent(accessor_index, buffers, buffer_views, accessors).bind(fn(
    values,
  ) {
    map_indices_tangent(values, triangle_indices)
  })
}

///|
fn parse_triangle_influences(
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@animation3d.SkinVertexInfluence3D]? {
  guard field_int(attributes_object, "JOINTS_0") is Some(joints0_accessor) else {
    return None
  }
  guard field_int(attributes_object, "WEIGHTS_0") is Some(weights0_accessor) else {
    return None
  }
  guard read_accessor_joint4(joints0_accessor, buffers, buffer_views, accessors)
    is Some(joints0) else {
    return None
  }
  guard read_accessor_weight4(
      weights0_accessor, buffers, buffer_views, accessors,
    )
    is Some(weights0) else {
    return None
  }
  if joints0.length() == 0 || weights0.length() == 0 {
    return None
  }
  guard map_indices_joint4(joints0, triangle_indices) is Some(triangle_joints0) else {
    return None
  }
  guard map_indices_weight4(weights0, triangle_indices)
    is Some(triangle_weights0) else {
    return None
  }
  let triangle_joints1 = match field_int(attributes_object, "JOINTS_1") {
    Some(joints1_accessor) =>
      read_accessor_joint4(joints1_accessor, buffers, buffer_views, accessors).bind(fn(
          values,
        ) {
          map_indices_joint4(values, triangle_indices)
        },
      )
    None => None
  }
  let triangle_weights1 = match field_int(attributes_object, "WEIGHTS_1") {
    Some(weights1_accessor) =>
      read_accessor_weight4(weights1_accessor, buffers, buffer_views, accessors).bind(fn(
          values,
        ) {
          map_indices_weight4(values, triangle_indices)
        },
      )
    None => None
  }
  let output : Array[@animation3d.SkinVertexInfluence3D] = []
  for index in 0..<triangle_joints0.length() {
    let joints4 = triangle_joints0[index]
    let weights4 = triangle_weights0[index]
    let extra_joints = triangle_joints1.bind(fn(values) { values.get(index) })
    let extra_weights = triangle_weights1.bind(fn(values) { values.get(index) })
    output.push(
      select_skin_influences(joints4, weights4, extra_joints, extra_weights),
    )
  }
  Some(output)
}

///|
fn select_skin_influences(
  joints0 : (Int, Int, Int, Int),
  weights0 : (Double, Double, Double, Double),
  joints1 : (Int, Int, Int, Int)?,
  weights1 : (Double, Double, Double, Double)?,
) -> @animation3d.SkinVertexInfluence3D {
  let best_joints = [-1, -1, -1, -1]
  let best_weights = [0.0, 0.0, 0.0, 0.0]
  let insert_candidate = fn(joint : Int, weight : Double) {
    if weight <= 0.0 {
      return
    }
    for slot in 0..<4 {
      if weight > best_weights[slot] {
        let mut shift_index = 3
        while shift_index > slot {
          best_weights[shift_index] = best_weights[shift_index - 1]
          best_joints[shift_index] = best_joints[shift_index - 1]
          shift_index -= 1
        }
        best_weights[slot] = weight
        best_joints[slot] = joint
        return
      }
    }
  }
  insert_candidate(joints0.0, weights0.0)
  insert_candidate(joints0.1, weights0.1)
  insert_candidate(joints0.2, weights0.2)
  insert_candidate(joints0.3, weights0.3)
  if joints1 is Some(extra_joints) && weights1 is Some(extra_weights) {
    insert_candidate(extra_joints.0, extra_weights.0)
    insert_candidate(extra_joints.1, extra_weights.1)
    insert_candidate(extra_joints.2, extra_weights.2)
    insert_candidate(extra_joints.3, extra_weights.3)
  }
  let weight_sum = best_weights[0] +
    best_weights[1] +
    best_weights[2] +
    best_weights[3]
  let normalized = if weight_sum > 0.000001 {
    [
      best_weights[0] / weight_sum,
      best_weights[1] / weight_sum,
      best_weights[2] / weight_sum,
      best_weights[3] / weight_sum,
    ]
  } else {
    best_weights
  }
  {
    joint0: best_joints[0],
    joint1: best_joints[1],
    joint2: best_joints[2],
    joint3: best_joints[3],
    weight0: normalized[0],
    weight1: normalized[1],
    weight2: normalized[2],
    weight3: normalized[3],
  }
}

///|
fn parse_triangle_morph_targets(
  primitive_object : Map[String, Json],
  triangle_indices : Array[Int],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[MorphTargetTemplate] {
  guard field_array(primitive_object, "targets") is Some(targets_json) else {
    return []
  }
  let output : Array[MorphTargetTemplate] = []
  for target_json in targets_json {
    guard json_object(target_json) is Some(target_object) else {
      output.push({ position_deltas: None, normal_deltas: None })
      continue
    }
    let position_deltas = match field_int(target_object, "POSITION") {
      Some(accessor_index) =>
        read_accessor_vec3(accessor_index, buffers, buffer_views, accessors).bind(fn(
            values,
          ) {
            map_indices_vec3(values, triangle_indices)
          },
        )
      None => None
    }
    let normal_deltas = match field_int(target_object, "NORMAL") {
      Some(accessor_index) =>
        read_accessor_vec3(accessor_index, buffers, buffer_views, accessors).bind(fn(
            values,
          ) {
            map_indices_vec3(values, triangle_indices)
          },
        )
      None => None
    }
    output.push({ position_deltas, normal_deltas })
  }
  output
}

///|
fn read_accessor_vec3(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Vec3]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC3" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@math.Vec3] = []
  for _ in 0..<accessor.count {
    output.push(@math.Vec3::zero())
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 3
    }
    if step < component_size * 3 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 3
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z) is (Some(px), Some(py), Some(pz)) else { return None }
      output[idx] = @math.Vec3::new(px, py, pz)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 3
    }
    if step < component_size * 3 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 3
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z) is (Some(px), Some(py), Some(pz)) else { return None }
      output[target_index] = @math.Vec3::new(px, py, pz)
    }
  }
  Some(output)
}

///|
fn read_accessor_vec2(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Vec2D]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC2" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@math.Vec2D] = []
  for _ in 0..<accessor.count {
    output.push(@math.Vec2D(0.0, 0.0))
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 2
    }
    if step < component_size * 2 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 2
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y) is (Some(px), Some(py)) else { return None }
      output[idx] = @math.Vec2D(px, py)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 2
    }
    if step < component_size * 2 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 2
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y) is (Some(px), Some(py)) else { return None }
      output[target_index] = @math.Vec2D(px, py)
    }
  }
  Some(output)
}

///|
fn read_accessor_quat(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Quat]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@math.Quat] = []
  for _ in 0..<accessor.count {
    output.push(@math.Quat::identity())
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 4
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[idx] = quat_from_components(px, py, pz, pw)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 4
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[target_index] = quat_from_components(px, py, pz, pw)
    }
  }
  Some(output)
}

///|
fn read_accessor_scalar(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Double]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "SCALAR" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[Double] = []
  for _ in 0..<accessor.count {
    output.push(0.0)
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      guard read_component_double(
          bytes,
          pos,
          accessor.component_type,
          accessor.normalized,
        )
        is Some(value) else {
        return None
      }
      output[idx] = value
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset + (sparse.count - 1) * step + component_size
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      guard read_component_double(
          bytes,
          pos,
          accessor.component_type,
          accessor.normalized,
        )
        is Some(value) else {
        return None
      }
      output[target_index] = value
    }
  }
  Some(output)
}

///|
fn read_accessor_tangent(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render3d.Tangent3D]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@render3d.Tangent3D] = []
  for _ in 0..<accessor.count {
    output.push({ x: 1.0, y: 0.0, z: 0.0, w: 1.0 })
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 4
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[idx] = { x: px, y: py, z: pz, w: pw }
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 4
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let x = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let y = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let z = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let w = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
        return None
      }
      output[target_index] = { x: px, y: py, z: pz, w: pw }
    }
  }
  Some(output)
}

///|
fn read_accessor_color(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@render.Color]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.count <= 0 ||
    (accessor.type_name != "VEC3" && accessor.type_name != "VEC4") {
    return None
  }
  let lane_count = if accessor.type_name == "VEC4" { 4 } else { 3 }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[@render.Color] = []
  for _ in 0..<accessor.count {
    output.push({ r: 0U, g: 0U, b: 0U, a: 0.0 })
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * lane_count
    }
    if step < component_size * lane_count {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * lane_count
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let r = read_component_color_factor(bytes, pos, accessor.component_type)
      let g = read_component_color_factor(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let b = read_component_color_factor(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let a = if lane_count == 4 {
        read_component_color_factor(
          bytes,
          pos + component_size * 3,
          accessor.component_type,
        )
      } else {
        Some(1.0)
      }
      guard (r, g, b, a) is (Some(pr), Some(pg), Some(pb), Some(pa)) else {
        return None
      }
      output[idx] = {
        r: factor_to_u8(pr),
        g: factor_to_u8(pg),
        b: factor_to_u8(pb),
        a: clamp01(pa),
      }
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * lane_count
    }
    if step < component_size * lane_count {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * lane_count
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let r = read_component_color_factor(bytes, pos, accessor.component_type)
      let g = read_component_color_factor(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let b = read_component_color_factor(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let a = if lane_count == 4 {
        read_component_color_factor(
          bytes,
          pos + component_size * 3,
          accessor.component_type,
        )
      } else {
        Some(1.0)
      }
      guard (r, g, b, a) is (Some(pr), Some(pg), Some(pb), Some(pa)) else {
        return None
      }
      output[target_index] = {
        r: factor_to_u8(pr),
        g: factor_to_u8(pg),
        b: factor_to_u8(pb),
        a: clamp01(pa),
      }
    }
  }
  Some(output)
}

///|
fn read_accessor_mat4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[@math.Mat4]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "MAT4" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  let output : Array[@math.Mat4] = []
  for _ in 0..<accessor.count {
    output.push(@math.Mat4::identity())
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = 64
    }
    if step < 64 {
      return None
    }
    let required_end = base_offset + (accessor.count - 1) * step + 64
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      guard read_mat4_value(bytes, pos) is Some(value) else { return None }
      output[idx] = value
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = 64
    }
    if step < 64 {
      return None
    }
    let required_end = base_offset + (sparse.count - 1) * step + 64
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      guard read_mat4_value(bytes, pos) is Some(value) else { return None }
      output[target_index] = value
    }
  }
  Some(output)
}

///|
fn read_accessor_joint4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[(Int, Int, Int, Int)]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = match accessor.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => 0
  }
  if component_size == 0 {
    return None
  }
  let output : Array[(Int, Int, Int, Int)] = []
  for _ in 0..<accessor.count {
    output.push((0, 0, 0, 0))
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 4
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let c0 = read_component_int(bytes, pos, accessor.component_type)
      let c1 = read_component_int(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let c2 = read_component_int(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let c3 = read_component_int(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
      )
      guard (c0, c1, c2, c3) is (Some(j0), Some(j1), Some(j2), Some(j3)) else {
        return None
      }
      output[idx] = (j0, j1, j2, j3)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 4
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let c0 = read_component_int(bytes, pos, accessor.component_type)
      let c1 = read_component_int(
        bytes,
        pos + component_size,
        accessor.component_type,
      )
      let c2 = read_component_int(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
      )
      let c3 = read_component_int(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
      )
      guard (c0, c1, c2, c3) is (Some(j0), Some(j1), Some(j2), Some(j3)) else {
        return None
      }
      output[target_index] = (j0, j1, j2, j3)
    }
  }
  Some(output)
}

///|
fn read_accessor_weight4(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[(Double, Double, Double, Double)]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "VEC4" || accessor.count <= 0 {
    return None
  }
  let component_size = accessor_component_size(accessor.component_type)
  if component_size <= 0 {
    return None
  }
  let output : Array[(Double, Double, Double, Double)] = []
  for _ in 0..<accessor.count {
    output.push((0.0, 0.0, 0.0, 0.0))
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size * 4
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let c0 = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let c1 = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let c2 = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let c3 = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (c0, c1, c2, c3) is (Some(w0), Some(w1), Some(w2), Some(w3)) else {
        return None
      }
      output[idx] = (w0, w1, w2, w3)
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views) is Some(indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size * 4
    }
    if step < component_size * 4 {
      return None
    }
    let required_end = base_offset +
      (sparse.count - 1) * step +
      component_size * 4
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = indices[idx]
      if target_index < 0 || target_index >= output.length() {
        return None
      }
      let pos = base_offset + idx * step
      let c0 = read_component_double(
        bytes,
        pos,
        accessor.component_type,
        accessor.normalized,
      )
      let c1 = read_component_double(
        bytes,
        pos + component_size,
        accessor.component_type,
        accessor.normalized,
      )
      let c2 = read_component_double(
        bytes,
        pos + component_size * 2,
        accessor.component_type,
        accessor.normalized,
      )
      let c3 = read_component_double(
        bytes,
        pos + component_size * 3,
        accessor.component_type,
        accessor.normalized,
      )
      guard (c0, c1, c2, c3) is (Some(w0), Some(w1), Some(w2), Some(w3)) else {
        return None
      }
      output[target_index] = (w0, w1, w2, w3)
    }
  }
  Some(output)
}

///|
fn read_accessor_indices(
  accessor_index : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> Array[Int]? {
  guard accessor_index >= 0 else { return None }
  guard accessors.get(accessor_index) is Some(Some(accessor)) else {
    return None
  }
  if accessor.type_name != "SCALAR" || accessor.count <= 0 {
    return None
  }
  let component_size = match accessor.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => return None
  }
  let indices : Array[Int] = []
  for _ in 0..<accessor.count {
    indices.push(0)
  }
  if resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) {
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset +
      (accessor.count - 1) * step +
      component_size
    if accessor.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<accessor.count {
      let pos = base_offset + idx * step
      let value = match accessor.component_type {
        5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
        5123 => read_u16_le(bytes, pos)
        5125 => read_u32_le(bytes, pos)
        _ => None
      }
      guard value is Some(index_value) else { return None }
      indices[idx] = index_value
    }
  }
  if accessor.sparse is Some(sparse) {
    if sparse.count > accessor.count {
      return None
    }
    guard read_sparse_indices(sparse, buffers, buffer_views)
      is Some(override_indices) else {
      return None
    }
    guard resolve_sparse_values_bytes(sparse, buffers, buffer_views)
      is Some((bytes, base_offset, stride, view_end)) else {
      return None
    }
    let mut step = stride
    if step <= 0 {
      step = component_size
    }
    if step < component_size {
      return None
    }
    let required_end = base_offset + (sparse.count - 1) * step + component_size
    if sparse.count > 0 &&
      (required_end > view_end || required_end > bytes.length()) {
      return None
    }
    for idx in 0..<sparse.count {
      let target_index = override_indices[idx]
      if target_index < 0 || target_index >= indices.length() {
        return None
      }
      let pos = base_offset + idx * step
      let value = match accessor.component_type {
        5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
        5123 => read_u16_le(bytes, pos)
        5125 => read_u32_le(bytes, pos)
        _ => None
      }
      guard value is Some(index_value) else { return None }
      indices[target_index] = index_value
    }
  }
  Some(indices)
}

///|
fn resolve_accessor_bytes(
  accessor : AccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  match accessor.buffer_view {
    Some(buffer_view_index) =>
      resolve_buffer_region(
        buffer_view_index,
        accessor.byte_offset,
        buffers,
        buffer_views,
      )
    None => None
  }
}

///|
fn resolve_sparse_values_bytes(
  sparse : SparseAccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  resolve_buffer_region(
    sparse.values.buffer_view,
    sparse.values.byte_offset,
    buffers,
    buffer_views,
  )
}

///|
fn resolve_buffer_region(
  buffer_view_index : Int,
  extra_offset : Int,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  guard buffer_view_index >= 0 else { return None }
  guard buffer_views.get(buffer_view_index) is Some(Some(view)) else {
    return None
  }
  if view.buffer < 0 || view.byte_offset < 0 || extra_offset < 0 {
    return None
  }
  guard buffers.get(view.buffer) is Some(Some(bytes)) else { return None }
  let total_offset = view.byte_offset + extra_offset
  let view_end = view.byte_offset + view.byte_length
  if total_offset < view.byte_offset || total_offset > view_end {
    return None
  }
  if total_offset < 0 || total_offset > bytes.length() {
    return None
  }
  let stride = view.byte_stride.unwrap_or(0)
  Some((bytes, total_offset, stride, view_end))
}

///|
fn read_sparse_indices(
  sparse : SparseAccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> Array[Int]? {
  let component_size = match sparse.indices.component_type {
    5121 => 1
    5123 => 2
    5125 => 4
    _ => return None
  }
  guard resolve_buffer_region(
      sparse.indices.buffer_view,
      sparse.indices.byte_offset,
      buffers,
      buffer_views,
    )
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = component_size
  }
  if step < component_size {
    return None
  }
  let required_end = base_offset + (sparse.count - 1) * step + component_size
  if sparse.count > 0 &&
    (required_end > view_end || required_end > bytes.length()) {
    return None
  }
  let output : Array[Int] = []
  for idx in 0..<sparse.count {
    let pos = base_offset + idx * step
    let value = match sparse.indices.component_type {
      5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
      5123 => read_u16_le(bytes, pos)
      5125 => read_u32_le(bytes, pos)
      _ => None
    }
    guard value is Some(index_value) else { return None }
    output.push(index_value)
  }
  Some(output)
}

///|
fn accessor_component_size(component_type : Int) -> Int {
  match component_type {
    5120 => 1
    5121 => 1
    5122 => 2
    5123 => 2
    5125 => 4
    5126 => 4
    _ => 0
  }
}

///|
fn read_f32_le(bytes : Bytes, offset : Int) -> Double? {
  if offset < 0 || offset + 3 >= bytes.length() {
    return None
  }
  Some(
    Float::reinterpret_from_uint(bytes.unsafe_read_uint32_le(offset)).to_double(),
  )
}

///|
fn quat_from_components(
  x : Double,
  y : Double,
  z : Double,
  w : Double,
) -> @math.Quat {
  let length_squared = x * x + y * y + z * z + w * w
  if length_squared <= 0.0000000001 {
    @math.Quat::identity()
  } else {
    @math.Quat::new(x, y, z, w).normalize()
  }
}

///|
fn read_mat4_value(bytes : Bytes, offset : Int) -> @math.Mat4? {
  let values : Array[Double] = []
  for index in 0..<16 {
    guard read_f32_le(bytes, offset + index * 4) is Some(value) else {
      return None
    }
    values.push(value)
  }
  Some({
    m00: values[0],
    m01: values[4],
    m02: values[8],
    m03: values[12],
    m10: values[1],
    m11: values[5],
    m12: values[9],
    m13: values[13],
    m20: values[2],
    m21: values[6],
    m22: values[10],
    m23: values[14],
    m30: values[3],
    m31: values[7],
    m32: values[11],
    m33: values[15],
  })
}

///|
fn read_u16_le(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 1 >= bytes.length() {
    return None
  }
  Some(bytes.unsafe_read_uint16_le(offset).to_int())
}

///|
fn read_i8(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset >= bytes.length() {
    return None
  }
  let value = bytes.unsafe_get(offset).to_int()
  if value >= 128 {
    Some(value - 256)
  } else {
    Some(value)
  }
}

///|
fn read_i16_le(bytes : Bytes, offset : Int) -> Int? {
  match read_u16_le(bytes, offset) {
    Some(value) =>
      if value >= 32768 {
        Some(value - 65536)
      } else {
        Some(value)
      }
    None => None
  }
}

///|
fn read_u32_le(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 3 >= bytes.length() {
    return None
  }
  let value = bytes.unsafe_read_uint32_le(offset).reinterpret_as_int()
  if value < 0 {
    None
  } else {
    Some(value)
  }
}

///|
fn read_component_int(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
) -> Int? {
  match component_type {
    5121 =>
      if offset < 0 || offset >= bytes.length() {
        None
      } else {
        Some(bytes.unsafe_get(offset).to_int())
      }
    5123 => read_u16_le(bytes, offset)
    5125 => read_u32_le(bytes, offset)
    _ => None
  }
}

///|
fn read_component_double(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
  normalized : Bool,
) -> Double? {
  match component_type {
    5126 => read_f32_le(bytes, offset)
    5120 =>
      match read_i8(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(@cmp.maximum(-1.0, value.to_double() / 127.0))
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5121 =>
      if offset < 0 || offset >= bytes.length() {
        None
      } else {
        let value = bytes.unsafe_get(offset).to_int()
        if normalized {
          Some(value.to_double() / 255.0)
        } else {
          Some(value.to_double())
        }
      }
    5122 =>
      match read_i16_le(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(@cmp.maximum(-1.0, value.to_double() / 32767.0))
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5123 =>
      match read_u16_le(bytes, offset) {
        Some(value) =>
          if normalized {
            Some(value.to_double() / 65535.0)
          } else {
            Some(value.to_double())
          }
        None => None
      }
    5125 =>
      match read_u32_le(bytes, offset) {
        Some(value) => Some(value.to_double())
        None => None
      }
    _ => None
  }
}

///|
fn read_component_color_factor(
  bytes : Bytes,
  offset : Int,
  component_type : Int,
) -> Double? {
  match component_type {
    5126 => read_f32_le(bytes, offset).map(fn(value) { clamp01(value) })
    _ =>
      read_component_double(bytes, offset, component_type, true).map(fn(value) {
        clamp01(value)
      })
  }
}

///|
fn default_mesh_indices(vertex_count : Int) -> Array[Int] {
  let indices : Array[Int] = []
  for index in 0..<vertex_count {
    indices.push(index)
  }
  indices
}

///|
fn decode_triangle_indices(indices : Array[Int], mode : Int) -> Array[Int] {
  let triangle_indices : Array[Int] = []
  let push_index = fn(index : Int) { triangle_indices.push(index) }
  match mode {
    4 => {
      let tri_count = indices.length() / 3
      for tri in 0..<tri_count {
        let base = tri * 3
        push_index(indices[base])
        push_index(indices[base + 1])
        push_index(indices[base + 2])
      }
    }
    5 =>
      if indices.length() >= 3 {
        for i in 0..<(indices.length() - 2) {
          if i % 2 == 0 {
            push_index(indices[i])
            push_index(indices[i + 1])
            push_index(indices[i + 2])
          } else {
            push_index(indices[i + 1])
            push_index(indices[i])
            push_index(indices[i + 2])
          }
        }
      }
    6 =>
      if indices.length() >= 3 {
        let head = indices[0]
        for i in 1..<(indices.length() - 1) {
          push_index(head)
          push_index(indices[i])
          push_index(indices[i + 1])
        }
      }
    _ => ()
  }
  triangle_indices
}

///|
fn map_indices_vec3(
  values : Array[@math.Vec3],
  indices : Array[Int],
) -> Array[@math.Vec3]? {
  let output : Array[@math.Vec3] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn map_indices_vec2(
  values : Array[@math.Vec2D],
  indices : Array[Int],
) -> Array[@math.Vec2D]? {
  let output : Array[@math.Vec2D] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn map_indices_tangent(
  values : Array[@render3d.Tangent3D],
  indices : Array[Int],
) -> Array[@render3d.Tangent3D]? {
  let output : Array[@render3d.Tangent3D] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn map_indices_color(
  values : Array[@render.Color],
  indices : Array[Int],
) -> Array[@render.Color]? {
  let output : Array[@render.Color] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn map_indices_joint4(
  values : Array[(Int, Int, Int, Int)],
  indices : Array[Int],
) -> Array[(Int, Int, Int, Int)]? {
  let output : Array[(Int, Int, Int, Int)] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn map_indices_weight4(
  values : Array[(Double, Double, Double, Double)],
  indices : Array[Int],
) -> Array[(Double, Double, Double, Double)]? {
  let output : Array[(Double, Double, Double, Double)] = []
  for index in indices {
    if index < 0 || index >= values.length() {
      return None
    }
    output.push(values[index])
  }
  Some(output)
}

///|
fn compute_flat_triangle_normals(
  positions : Array[@math.Vec3],
) -> Array[@math.Vec3] {
  let normals : Array[@math.Vec3] = []
  let triangle_count = positions.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let a = positions[base]
    let b = positions[base + 1]
    let c = positions[base + 2]
    let mut normal = (b - a).cross(c - a)
    if normal.length_squared() <= 0.0000001 {
      normal = @math.Vec3::new(0.0, 1.0, 0.0)
    } else {
      normal = normal.normalize()
    }
    normals.push(normal)
    normals.push(normal)
    normals.push(normal)
  }
  normals
}

///|
fn parse_camera_templates(
  root_object : Map[String, Json],
) -> Array[@camera3d.Camera3DComponent?] {
  guard root_object.get("cameras") is Some(cameras_json) else { return [] }
  guard json_array(cameras_json) is Some(cameras) else { return [] }
  let output : Array[@camera3d.Camera3DComponent?] = []
  for camera_json in cameras {
    output.push(
      json_object(camera_json).bind(fn(camera_object) {
        parse_camera_component(camera_object)
      }),
    )
  }
  output
}

///|
fn parse_camera_component(
  camera_object : Map[String, Json],
) -> @camera3d.Camera3DComponent? {
  let defaults = @camera3d.Camera3DComponent::default()
  match
    field_string(camera_object, "type").map_or("", fn(value) {
      value.to_lower()
    }) {
    "orthographic" =>
      field_object(camera_object, "orthographic").map(fn(orthographic) {
        let xmag = field_number(orthographic, "xmag").unwrap_or(1.0)
        let ymag = field_number(orthographic, "ymag").unwrap_or(1.0)
        {
          ..defaults,
          projection: Orthographic,
          orthographic_size: Some(@math.Vec2D(2.0 * xmag, 2.0 * ymag)),
          near: field_number(orthographic, "znear").unwrap_or(defaults.near),
          far: field_number(orthographic, "zfar").unwrap_or(defaults.far),
        }
      })
    "perspective" =>
      field_object(camera_object, "perspective").map(fn(perspective) {
        {
          ..defaults,
          projection: Perspective,
          fov_y: field_number(perspective, "yfov").unwrap_or(defaults.fov_y) *
          180.0 /
          3.141592653589793,
          near: field_number(perspective, "znear").unwrap_or(defaults.near),
          far: field_number(perspective, "zfar").unwrap_or(1000000.0),
        }
      })
    _ => None
  }
}

///|
fn parse_light_templates(
  root_object : Map[String, Json],
) -> Array[ParsedLightTemplate?] {
  guard field_object(root_object, "extensions") is Some(extensions_object) else {
    return []
  }
  guard field_object(extensions_object, "KHR_lights_punctual")
    is Some(lights_extension) else {
    return []
  }
  guard field_array(lights_extension, "lights") is Some(lights_json) else {
    return []
  }
  let output : Array[ParsedLightTemplate?] = []
  for light_json in lights_json {
    output.push(json_object(light_json).bind(parse_light_template))
  }
  output
}

///|
fn parse_light_template(
  light_object : Map[String, Json],
) -> ParsedLightTemplate? {
  let color = match field_array(light_object, "color") {
    Some(values) if values.length() >= 3 =>
      color_from_factor4([
        json_number(values[0]).unwrap_or(1.0),
        json_number(values[1]).unwrap_or(1.0),
        json_number(values[2]).unwrap_or(1.0),
        1.0,
      ])
    _ => color_from_factor4([1.0, 1.0, 1.0, 1.0])
  }
  let intensity = field_number(light_object, "intensity").unwrap_or(1.0)
  let range = field_number(light_object, "range").unwrap_or(0.0)
  match
    field_string(light_object, "type").map_or("", fn(value) { value.to_lower() }) {
    "directional" =>
      Some({
        directional: Some({
          direction: @math.Vec3::new(0.0, 0.0, -1.0),
          color,
          intensity,
          shadows: false,
        }),
        point: None,
        spot: None,
      })
    "point" =>
      Some({
        directional: None,
        point: Some({ color, intensity, range }),
        spot: None,
      })
    "spot" => {
      let spot_object = field_object(light_object, "spot").unwrap_or(Map::new())
      Some({
        directional: None,
        point: None,
        spot: Some({
          direction: @math.Vec3::new(0.0, 0.0, -1.0),
          color,
          intensity,
          range,
          inner_angle: field_number(spot_object, "innerConeAngle").unwrap_or(
            0.0,
          ),
          outer_angle: field_number(spot_object, "outerConeAngle").unwrap_or(
            0.7853981633974483,
          ),
        }),
      })
    }
    _ => None
  }
}

///|
fn parse_node_light(
  node_object : Map[String, Json],
  light_templates : Array[ParsedLightTemplate?],
) -> ParsedLightTemplate? {
  guard field_object(node_object, "extensions") is Some(extensions_object) else {
    return None
  }
  guard field_object(extensions_object, "KHR_lights_punctual")
    is Some(light_extension) else {
    return None
  }
  guard field_int(light_extension, "light") is Some(light_index) else {
    return None
  }
  light_templates.get(light_index).unwrap_or(None)
}

///|
fn parse_node_templates(
  root_object : Map[String, Json],
  mesh_templates : Array[MeshSceneTemplate?],
  camera_templates : Array[@camera3d.Camera3DComponent?],
  light_templates : Array[ParsedLightTemplate?],
) -> Array[SceneNodeTemplate] {
  guard root_object.get("nodes") is Some(nodes_json) else { return [] }
  guard json_array(nodes_json) is Some(nodes) else { return [] }
  let templates : Array[SceneNodeTemplate] = []
  for node_json in nodes {
    guard json_object(node_json) is Some(node_object) else {
      templates.push(default_scene_node_template())
      continue
    }
    let transform = parse_node_transform(node_object)
    let children = parse_node_children(node_object)
    let name = field_string(node_object, "name")
    let skin_index = field_int(node_object, "skin")
    let mut morph_weights : Array[Double] = []
    let camera = match field_int(node_object, "camera") {
      Some(camera_index) => camera_templates.get(camera_index).unwrap_or(None)
      None => None
    }
    let light = parse_node_light(node_object, light_templates)
    let renderers = match field_int(node_object, "mesh") {
      Some(mesh_index) =>
        match mesh_templates.get(mesh_index) {
          Some(Some(mesh_template)) => {
            morph_weights = match field_array(node_object, "weights") {
              Some(weights_json) =>
                resolve_morph_weights(
                  mesh_template.morph_target_count,
                  parse_morph_weight_values(Some(weights_json)),
                )
              None => mesh_template.morph_weights.copy()
            }
            mesh_template.renderers.copy()
          }
          _ => []
        }
      None => []
    }
    templates.push({
      name,
      transform,
      renderers,
      skin_index,
      morph_weights,
      camera,
      directional_light: light.bind(fn(template) { template.directional }),
      point_light: light.bind(fn(template) { template.point }),
      spot_light: light.bind(fn(template) { template.spot }),
      children,
    })
  }
  templates
}

///|
fn parse_node_transform(
  node_object : Map[String, Json],
) -> @transform3d.Transform3D {
  if field_array(node_object, "matrix") is Some(matrix_json) {
    if parse_matrix_transform(matrix_json) is Some(matrix_transform) {
      return matrix_transform
    }
  }
  {
    translation: parse_vec3(node_object.get("translation"), @math.Vec3::zero()),
    rotation: parse_quat(node_object.get("rotation"), @math.Quat::identity()),
    scale: parse_vec3(node_object.get("scale"), @math.Vec3::one()),
  }
}

///|
fn parse_matrix_transform(values : Array[Json]) -> @transform3d.Transform3D? {
  if values.length() < 16 {
    return None
  }
  let numbers : Array[Double] = []
  for index in 0..<16 {
    guard json_number(values[index]) is Some(value) else { return None }
    numbers.push(value)
  }
  let m00 = numbers[0]
  let m01 = numbers[4]
  let m02 = numbers[8]
  let m10 = numbers[1]
  let m11 = numbers[5]
  let m12 = numbers[9]
  let m20 = numbers[2]
  let m21 = numbers[6]
  let m22 = numbers[10]
  let translation = @math.Vec3::new(numbers[12], numbers[13], numbers[14])

  let mut scale_x = @math.Vec3::new(m00, m10, m20).length()
  let mut scale_y = @math.Vec3::new(m01, m11, m21).length()
  let mut scale_z = @math.Vec3::new(m02, m12, m22).length()
  if scale_x <= 0.0000001 {
    scale_x = 1.0
  }
  if scale_y <= 0.0000001 {
    scale_y = 1.0
  }
  if scale_z <= 0.0000001 {
    scale_z = 1.0
  }
  let r00 = m00 / scale_x
  let r01 = m01 / scale_y
  let r02 = m02 / scale_z
  let r10 = m10 / scale_x
  let r11 = m11 / scale_y
  let r12 = m12 / scale_z
  let r20 = m20 / scale_x
  let r21 = m21 / scale_y
  let r22 = m22 / scale_z
  let rotation = quat_from_matrix3(r00, r01, r02, r10, r11, r12, r20, r21, r22)
  Some({
    translation,
    rotation,
    scale: @math.Vec3::new(scale_x, scale_y, scale_z),
  })
}

///|
fn quat_from_matrix3(
  m00 : Double,
  m01 : Double,
  m02 : Double,
  m10 : Double,
  m11 : Double,
  m12 : Double,
  m20 : Double,
  m21 : Double,
  m22 : Double,
) -> @math.Quat {
  let trace = m00 + m11 + m22
  if trace > 0.0 {
    let s = (trace + 1.0).sqrt() * 2.0
    @math.Quat::new((m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, 0.25 * s).normalize()
  } else if m00 > m11 && m00 > m22 {
    let s = (1.0 + m00 - m11 - m22).sqrt() * 2.0
    @math.Quat::new(0.25 * s, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s).normalize()
  } else if m11 > m22 {
    let s = (1.0 + m11 - m00 - m22).sqrt() * 2.0
    @math.Quat::new((m01 + m10) / s, 0.25 * s, (m12 + m21) / s, (m02 - m20) / s).normalize()
  } else {
    let s = (1.0 + m22 - m00 - m11).sqrt() * 2.0
    @math.Quat::new((m02 + m20) / s, (m12 + m21) / s, 0.25 * s, (m10 - m01) / s).normalize()
  }
}

///|
fn parse_node_children(node_object : Map[String, Json]) -> Array[Int] {
  guard node_object.get("children") is Some(children_json) else { return [] }
  guard json_array(children_json) is Some(children) else { return [] }
  let indexes : Array[Int] = []
  for value in children {
    if json_number(value) is Some(number) {
      indexes.push(number.to_int())
    }
  }
  indexes
}

///|
fn parse_root_nodes(
  root_object : Map[String, Json],
  max_nodes : Int,
) -> Array[Int] {
  guard root_object.get("scenes") is Some(scenes_json) else {
    return fallback_root_nodes(max_nodes)
  }
  guard json_array(scenes_json) is Some(scenes) else {
    return fallback_root_nodes(max_nodes)
  }
  if scenes.length() == 0 {
    return fallback_root_nodes(max_nodes)
  }
  let mut scene_index = field_int(root_object, "scene").unwrap_or(0)
  if scene_index < 0 {
    scene_index = 0
  }
  if scene_index >= scenes.length() {
    scene_index = scenes.length() - 1
  }
  guard json_object(scenes[scene_index]) is Some(scene_object) else {
    return fallback_root_nodes(max_nodes)
  }
  guard scene_object.get("nodes") is Some(root_nodes_json) else {
    return fallback_root_nodes(max_nodes)
  }
  guard json_array(root_nodes_json) is Some(root_nodes) else {
    return fallback_root_nodes(max_nodes)
  }
  let indexes : Array[Int] = []
  for value in root_nodes {
    if json_number(value) is Some(number) {
      let index = number.to_int()
      if index >= 0 && index < max_nodes {
        indexes.push(index)
      }
    }
  }
  if indexes.length() == 0 {
    fallback_root_nodes(max_nodes)
  } else {
    indexes
  }
}

///|
fn fallback_root_nodes(max_nodes : Int) -> Array[Int] {
  if max_nodes > 0 {
    [0]
  } else {
    []
  }
}

///|
fn parse_vec3(value : Json?, fallback : @math.Vec3) -> @math.Vec3 {
  guard value is Some(actual) else { return fallback }
  guard json_array(actual) is Some(values) else { return fallback }
  if values.length() < 3 {
    return fallback
  }
  let x = json_number(values[0]).unwrap_or(fallback.x)
  let y = json_number(values[1]).unwrap_or(fallback.y)
  let z = json_number(values[2]).unwrap_or(fallback.z)
  @math.Vec3::new(x, y, z)
}

///|
fn parse_quat(value : Json?, fallback : @math.Quat) -> @math.Quat {
  guard value is Some(actual) else { return fallback }
  guard json_array(actual) is Some(values) else { return fallback }
  if values.length() < 4 {
    return fallback
  }
  let x = json_number(values[0]).unwrap_or(fallback.x)
  let y = json_number(values[1]).unwrap_or(fallback.y)
  let z = json_number(values[2]).unwrap_or(fallback.z)
  let w = json_number(values[3]).unwrap_or(fallback.w)
  @math.Quat::new(x, y, z, w).normalize()
}

///|
fn color_from_factor4(values : Array[Double]) -> @render.Color {
  let r = factor_to_u8(values.get(0).unwrap_or(1.0))
  let g = factor_to_u8(values.get(1).unwrap_or(1.0))
  let b = factor_to_u8(values.get(2).unwrap_or(1.0))
  let a = clamp01(values.get(3).unwrap_or(1.0))
  { r, g, b, a }
}

///|
fn factor_to_u8(value : Double) -> UInt {
  (clamp01(value) * 255.0).to_int().reinterpret_as_uint()
}

///|
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn parse_morph_weight_values(values : Array[Json]?) -> Array[Double] {
  let weights : Array[Double] = []
  guard values is Some(items) else { return weights }
  for value in items {
    if json_number(value) is Some(number) {
      weights.push(number)
    }
  }
  weights
}

///|
fn resolve_morph_weights(
  target_count : Int,
  candidate_weights : Array[Double],
) -> Array[Double] {
  if target_count <= 0 {
    return []
  }
  let weights = candidate_weights.copy()
  while weights.length() < target_count {
    weights.push(0.0)
  }
  if weights.length() > target_count {
    let trimmed : Array[Double] = []
    for index in 0..<target_count {
      trimmed.push(weights[index])
    }
    trimmed
  } else {
    weights
  }
}

///|
fn max_attribute_set_index(
  attributes_object : Map[String, Json],
  prefix : String,
) -> Int {
  let mut max_index = -1
  for pair in attributes_object.to_array() {
    let key = pair.0
    if !key.has_prefix(prefix) {
      continue
    }
    let suffix = key.unsafe_substring(start=prefix.length(), end=key.length())
    let parsed = try? @strconv.parse_int(suffix.view())
    guard parsed is Ok(index) else { continue }
    if index > max_index {
      max_index = index
    }
  }
  max_index
}

///|
fn resolve_relative_asset_path(scene_path : String, uri : String) -> String {
  if uri.has_prefix("/") ||
    uri.contains("://") ||
    uri.to_lower().has_prefix("data:") {
    return uri
  }
  let slash_idx = scene_path.rev_find("/")
  let backslash_idx = scene_path.rev_find("\\")
  let last_sep = match (slash_idx, backslash_idx) {
    (Some(slash), Some(backslash)) =>
      if slash > backslash {
        slash
      } else {
        backslash
      }
    (Some(slash), None) => slash
    (None, Some(backslash)) => backslash
    (None, None) => -1
  }
  if last_sep < 0 {
    uri
  } else {
    scene_path.unsafe_substring(start=0, end=last_sep + 1) + uri
  }
}

///|
fn json_object(value : Json) -> Map[String, Json]? {
  match value {
    Object(object) => Some(object)
    _ => None
  }
}

///|
fn json_array(value : Json) -> Array[Json]? {
  match value {
    Array(array) => Some(array)
    _ => None
  }
}

///|
fn json_string(value : Json) -> String? {
  match value {
    String(text) => Some(text)
    _ => None
  }
}

///|
fn json_number(value : Json) -> Double? {
  match value {
    Number(number, ..) => Some(number)
    _ => None
  }
}

///|
fn json_int(value : Json) -> Int? {
  if json_number(value) is Some(number) {
    Some(number.to_int())
  } else {
    None
  }
}

///|
fn json_bool(value : Json) -> Bool? {
  match value {
    True => Some(true)
    False => Some(false)
    _ => None
  }
}

///|
fn field_json(object : Map[String, Json], key : String) -> Json? {
  object.get(key)
}

///|
fn field_object(object : Map[String, Json], key : String) -> Map[String, Json]? {
  if field_json(object, key) is Some(value) {
    json_object(value)
  } else {
    None
  }
}

///|
fn field_array(object : Map[String, Json], key : String) -> Array[Json]? {
  if field_json(object, key) is Some(value) {
    json_array(value)
  } else {
    None
  }
}

///|
fn field_string(object : Map[String, Json], key : String) -> String? {
  if field_json(object, key) is Some(value) {
    json_string(value)
  } else {
    None
  }
}

///|
fn field_number(object : Map[String, Json], key : String) -> Double? {
  if field_json(object, key) is Some(value) {
    json_number(value)
  } else {
    None
  }
}

///|
fn field_int(object : Map[String, Json], key : String) -> Int? {
  if field_json(object, key) is Some(value) {
    json_int(value)
  } else {
    None
  }
}

///|
fn field_bool(object : Map[String, Json], key : String) -> Bool? {
  if field_json(object, key) is Some(value) {
    json_bool(value)
  } else {
    None
  }
}
