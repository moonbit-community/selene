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
}

///|
priv struct MeshRendererTemplate {
  renderer : @render3d.Mesh3DRenderer
  skinned : SkinnedPrimitiveTemplate?
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
  uvs : Array[@math.Vec2D]?
  influences : Array[@animation3d.SkinVertexInfluence3D]
}

///|
priv struct PendingSkinBinding {
  entity : @entity.Entity
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
priv struct BufferViewTemplate {
  buffer : Int
  byte_offset : Int
  byte_length : Int
  byte_stride : Int?
}

///|
priv struct AccessorTemplate {
  buffer_view : Int
  byte_offset : Int
  component_type : Int
  count : Int
  type_name : String
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
      mesh: pending.mesh,
      base_positions: pending.skinned.base_positions,
      base_normals: pending.skinned.base_normals,
      uvs: pending.skinned.uvs,
      influences: pending.skinned.influences,
      joint_entities,
      inverse_bind_matrices: skin.inverse_bind_matrices,
    })
  }
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
  if node.renderers.length() == 1 {
    let template_renderer = node.renderers[0]
    @render3d.mesh3d_renderers.set(entity, template_renderer.renderer)
    if node.skin_index is Some(skin_index) &&
      template_renderer.skinned is Some(skinned) {
      pending_skin_bindings.push({
        entity,
        mesh: template_renderer.renderer.mesh,
        skin_index,
        skinned,
      })
    }
  } else if node.renderers.length() > 1 {
    for primitive_index, template_renderer in node.renderers {
      let primitive_entity = entity.spawn_child()
      @transform3d.transforms3d.set(
        primitive_entity,
        @transform3d.Transform3D::identity(),
      )
      @render3d.mesh3d_renderers.set(
        primitive_entity,
        template_renderer.renderer,
      )
      parts.set("\{entity_path}/primitive\{primitive_index}", primitive_entity)
      if node.skin_index is Some(skin_index) &&
        template_renderer.skinned is Some(skinned) {
        pending_skin_bindings.push({
          entity: primitive_entity,
          mesh: template_renderer.renderer.mesh,
          skin_index,
          skinned,
        })
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
fn load_scene_template(path : String) -> SceneTemplate {
  guard @asset.read_bytes(path) is Some(bytes) else {
    return empty_scene_template()
  }
  let source = bytes.to_unchecked_string()
  let parsed : Result[Json, @json.ParseError] = try? @json.parse(source.view())
  match parsed {
    Ok(document) => parse_scene_template(path, document)
    Err(_) => empty_scene_template()
  }
}

///|
fn parse_scene_template(path : String, document : Json) -> SceneTemplate {
  guard json_object(document) is Some(root_object) else {
    return empty_scene_template()
  }
  let image_handles = parse_image_handles(path, root_object)
  let texture_sources = parse_texture_sources(root_object)
  let material_handles = parse_material_handles(
    root_object, texture_sources, image_handles,
  )
  let buffers = parse_buffer_blobs(path, root_object)
  let buffer_views = parse_buffer_views(root_object)
  let accessors = parse_accessors(root_object)
  let skins = parse_skin_templates(
    root_object, buffers, buffer_views, accessors,
  )
  let mesh_templates = parse_mesh_templates(
    root_object, material_handles, buffers, buffer_views, accessors,
  )
  let nodes = parse_node_templates(root_object, mesh_templates)
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
    match path {
      "translation" =>
        if read_accessor_vec3(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          let count = if times.length() < values.length() {
            times.length()
          } else {
            values.length()
          }
          for index in 0..<count {
            translations.push({ time: times[index], value: values[index] })
          }
        }
      "rotation" =>
        if read_accessor_quat(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          let count = if times.length() < values.length() {
            times.length()
          } else {
            values.length()
          }
          for index in 0..<count {
            rotations.push({ time: times[index], value: values[index] })
          }
        }
      "scale" =>
        if read_accessor_vec3(output_accessor, buffers, buffer_views, accessors)
          is Some(values) {
          let count = if times.length() < values.length() {
            times.length()
          } else {
            values.length()
          }
          for index in 0..<count {
            scales.push({ time: times[index], value: values[index] })
          }
        }
      _ => ()
    }
    if translations.length() == 0 &&
      rotations.length() == 0 &&
      scales.length() == 0 {
      continue
    }
    output.push({
      node: node_index,
      translations,
      rotations,
      scales,
      interpolation,
    })
  }
  output
}

///|
fn parse_image_handles(
  scene_path : String,
  root_object : Map[String, Json],
) -> Array[@render3d.ImageHandle?] {
  guard root_object.get("images") is Some(images_json) else { return [] }
  guard json_array(images_json) is Some(images) else { return [] }
  let handles : Array[@render3d.ImageHandle?] = []
  for image_json in images {
    guard json_object(image_json) is Some(image_object) else {
      handles.push(None)
      continue
    }
    guard image_object.get("uri") is Some(uri_json) else {
      handles.push(None)
      continue
    }
    guard json_string(uri_json) is Some(uri) else {
      handles.push(None)
      continue
    }
    let resolved = resolve_relative_asset_path(scene_path, uri)
    handles.push(Some(@render3d.register_image_asset({ path: resolved })))
  }
  handles
}

///|
fn parse_texture_sources(root_object : Map[String, Json]) -> Array[Int?] {
  guard root_object.get("textures") is Some(textures_json) else { return [] }
  guard json_array(textures_json) is Some(textures) else { return [] }
  let sources : Array[Int?] = []
  for texture_json in textures {
    guard json_object(texture_json) is Some(texture_object) else {
      sources.push(None)
      continue
    }
    sources.push(field_int(texture_object, "source"))
  }
  sources
}

///|
fn parse_material_handles(
  root_object : Map[String, Json],
  texture_sources : Array[Int?],
  image_handles : Array[@render3d.ImageHandle?],
) -> Array[@render3d.MaterialHandle] {
  guard root_object.get("materials") is Some(materials_json) else { return [] }
  guard json_array(materials_json) is Some(materials) else { return [] }
  let handles : Array[@render3d.MaterialHandle] = []
  for material_json in materials {
    let material = parse_material_asset(
      material_json, texture_sources, image_handles,
    )
    handles.push(@render3d.register_material_asset(material))
  }
  handles
}

///|
fn parse_material_asset(
  material_json : Json,
  texture_sources : Array[Int?],
  image_handles : Array[@render3d.ImageHandle?],
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
  material = match field_object(material_object, "pbrMetallicRoughness") {
    Some(pbr_object) =>
      parse_pbr_material(material, pbr_object, texture_sources, image_handles)
    None => material
  }
  material
}

///|
fn parse_pbr_material(
  material : @render3d.StandardMaterial3D,
  pbr_object : Map[String, Json],
  texture_sources : Array[Int?],
  image_handles : Array[@render3d.ImageHandle?],
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
      match field_int(base_texture, "index") {
        Some(texture_index) =>
          match texture_sources.get(texture_index) {
            Some(Some(image_index)) =>
              match image_handles.get(image_index) {
                Some(Some(image_handle)) =>
                  { ..output, base_color_texture: Some(image_handle) }
                _ => output
              }
            _ => output
          }
        None => output
      }
    None => output
  }
  output
}

///|
fn parse_buffer_blobs(
  scene_path : String,
  root_object : Map[String, Json],
) -> Array[Bytes?] {
  guard root_object.get("buffers") is Some(buffers_json) else { return [] }
  guard json_array(buffers_json) is Some(buffers) else { return [] }
  let blobs : Array[Bytes?] = []
  for buffer_json in buffers {
    guard json_object(buffer_json) is Some(buffer_object) else {
      blobs.push(None)
      continue
    }
    guard field_string(buffer_object, "uri") is Some(uri) else {
      blobs.push(None)
      continue
    }
    if uri.to_lower().has_prefix("data:") {
      blobs.push(decode_data_uri_base64(uri))
    } else {
      let resolved = resolve_relative_asset_path(scene_path, uri)
      blobs.push(@asset.read_bytes(resolved))
    }
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
fn parse_accessors(root_object : Map[String, Json]) -> Array[AccessorTemplate?] {
  guard root_object.get("accessors") is Some(accessors_json) else { return [] }
  guard json_array(accessors_json) is Some(accessors) else { return [] }
  let templates : Array[AccessorTemplate?] = []
  for accessor_json in accessors {
    guard json_object(accessor_json) is Some(accessor_object) else {
      templates.push(None)
      continue
    }
    guard field_int(accessor_object, "bufferView") is Some(buffer_view) else {
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
    if buffer_view < 0 || count <= 0 {
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
      }),
    )
  }
  templates
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
        skinned: parsed_asset.skinned,
      })
    }
    if renderers.length() == 0 {
      templates.push(None)
      continue
    }
    templates.push(Some({ renderers, }))
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
  let triangle_uvs = match field_int(attributes_object, "TEXCOORD_0") {
    Some(uv_accessor_index) =>
      match
        read_accessor_vec2(uv_accessor_index, buffers, buffer_views, accessors) {
        Some(uvs) => map_indices_vec2(uvs, triangle_indices)
        None => None
      }
    None => None
  }
  let skinned = parse_triangle_skinning(
    attributes_object, triangle_indices, triangle_positions, triangle_normals, triangle_uvs,
    buffers, buffer_views, accessors,
  )
  Some({
    mesh: @render3d.triangle_mesh(
      triangle_positions,
      uvs=triangle_uvs,
      normals=Some(triangle_normals),
    ),
    skinned,
  })
}

///|
fn parse_triangle_skinning(
  attributes_object : Map[String, Json],
  triangle_indices : Array[Int],
  triangle_positions : Array[@math.Vec3],
  triangle_normals : Array[@math.Vec3],
  triangle_uvs : Array[@math.Vec2D]?,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> SkinnedPrimitiveTemplate? {
  guard field_int(attributes_object, "JOINTS_0") is Some(joints_accessor) else {
    return None
  }
  guard field_int(attributes_object, "WEIGHTS_0") is Some(weights_accessor) else {
    return None
  }
  guard read_accessor_joint4(joints_accessor, buffers, buffer_views, accessors)
    is Some(joints) else {
    return None
  }
  guard read_accessor_weight4(
      weights_accessor, buffers, buffer_views, accessors,
    )
    is Some(weights) else {
    return None
  }
  if joints.length() == 0 || weights.length() == 0 {
    return None
  }
  guard map_indices_joint4(joints, triangle_indices) is Some(triangle_joints) else {
    return None
  }
  guard map_indices_weight4(weights, triangle_indices) is Some(triangle_weights) else {
    return None
  }
  let influences : Array[@animation3d.SkinVertexInfluence3D] = []
  for index in 0..<triangle_joints.length() {
    let joints4 = triangle_joints[index]
    let weights4 = triangle_weights[index]
    influences.push({
      joint0: joints4.0,
      joint1: joints4.1,
      joint2: joints4.2,
      joint3: joints4.3,
      weight0: weights4.0,
      weight1: weights4.1,
      weight2: weights4.2,
      weight3: weights4.3,
    })
  }
  Some({
    base_positions: triangle_positions,
    base_normals: triangle_normals,
    uvs: triangle_uvs,
    influences,
  })
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
  if accessor.type_name != "VEC3" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = 12
  }
  if step < 12 {
    return None
  }
  let required_end = base_offset + (accessor.count - 1) * step + 12
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[@math.Vec3] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let x = read_f32_le(bytes, pos)
    let y = read_f32_le(bytes, pos + 4)
    let z = read_f32_le(bytes, pos + 8)
    guard (x, y, z) is (Some(px), Some(py), Some(pz)) else { return None }
    output.push(@math.Vec3::new(px, py, pz))
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
  if accessor.type_name != "VEC2" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = 8
  }
  if step < 8 {
    return None
  }
  let required_end = base_offset + (accessor.count - 1) * step + 8
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[@math.Vec2D] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let x = read_f32_le(bytes, pos)
    let y = read_f32_le(bytes, pos + 4)
    guard (x, y) is (Some(px), Some(py)) else { return None }
    output.push(@math.Vec2D(px, py))
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
  if accessor.type_name != "VEC4" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = 16
  }
  if step < 16 {
    return None
  }
  let required_end = base_offset + (accessor.count - 1) * step + 16
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[@math.Quat] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let x = read_f32_le(bytes, pos)
    let y = read_f32_le(bytes, pos + 4)
    let z = read_f32_le(bytes, pos + 8)
    let w = read_f32_le(bytes, pos + 12)
    guard (x, y, z, w) is (Some(px), Some(py), Some(pz), Some(pw)) else {
      return None
    }
    output.push(@math.Quat::new(px, py, pz, pw).normalize())
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
  if accessor.type_name != "SCALAR" ||
    accessor.component_type != 5126 ||
    accessor.count <= 0 {
    return None
  }
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
    is Some((bytes, base_offset, stride, view_end)) else {
    return None
  }
  let mut step = stride
  if step <= 0 {
    step = 4
  }
  if step < 4 {
    return None
  }
  let required_end = base_offset + (accessor.count - 1) * step + 4
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[Double] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    guard read_f32_le(bytes, pos) is Some(value) else { return None }
    output.push(value)
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
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
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
  let required_end = base_offset + (accessor.count - 1) * step + 64
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[@math.Mat4] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let values : Array[Double] = []
    for lane in 0..<16 {
      guard read_f32_le(bytes, pos + lane * 4) is Some(value) else {
        return None
      }
      values.push(value)
    }
    output.push({
      // glTF matrix is column-major; convert to row-major Mat4.
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
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
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
    (accessor.count - 1) * step +
    component_size * 4
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[(Int, Int, Int, Int)] = []
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
    output.push((j0, j1, j2, j3))
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
  let component_size = match accessor.component_type {
    5121 => 1
    5123 => 2
    5126 => 4
    _ => 0
  }
  if component_size == 0 {
    return None
  }
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
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
    (accessor.count - 1) * step +
    component_size * 4
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let output : Array[(Double, Double, Double, Double)] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let c0 = read_component_double(bytes, pos, accessor.component_type)
    let c1 = read_component_double(
      bytes,
      pos + component_size,
      accessor.component_type,
    )
    let c2 = read_component_double(
      bytes,
      pos + component_size * 2,
      accessor.component_type,
    )
    let c3 = read_component_double(
      bytes,
      pos + component_size * 3,
      accessor.component_type,
    )
    guard (c0, c1, c2, c3) is (Some(w0), Some(w1), Some(w2), Some(w3)) else {
      return None
    }
    output.push((w0, w1, w2, w3))
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
  guard resolve_accessor_bytes(accessor, buffers, buffer_views)
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
  let required_end = base_offset + (accessor.count - 1) * step + component_size
  if required_end > view_end || required_end > bytes.length() {
    return None
  }
  let indices : Array[Int] = []
  for idx in 0..<accessor.count {
    let pos = base_offset + idx * step
    let value = match accessor.component_type {
      5121 => bytes.get(pos).map_or(None, fn(v) { Some(v.to_int()) })
      5123 => read_u16_le(bytes, pos)
      5125 => read_u32_le(bytes, pos)
      _ => None
    }
    guard value is Some(index_value) else { return None }
    indices.push(index_value)
  }
  Some(indices)
}

///|
fn resolve_accessor_bytes(
  accessor : AccessorTemplate,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
) -> (Bytes, Int, Int, Int)? {
  guard buffer_views.get(accessor.buffer_view) is Some(Some(view)) else {
    return None
  }
  if view.buffer < 0 || view.byte_offset < 0 || accessor.byte_offset < 0 {
    return None
  }
  guard buffers.get(view.buffer) is Some(Some(bytes)) else { return None }
  let total_offset = view.byte_offset + accessor.byte_offset
  let view_end = view.byte_offset + view.byte_length
  if total_offset < view.byte_offset || total_offset >= view_end {
    return None
  }
  if total_offset < 0 || total_offset >= bytes.length() {
    return None
  }
  let stride = view.byte_stride.unwrap_or(0)
  Some((bytes, total_offset, stride, view_end))
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
fn read_u16_le(bytes : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 1 >= bytes.length() {
    return None
  }
  Some(bytes.unsafe_read_uint16_le(offset).to_int())
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
) -> Double? {
  match component_type {
    5126 => read_f32_le(bytes, offset)
    5121 =>
      if offset < 0 || offset >= bytes.length() {
        None
      } else {
        Some(bytes.unsafe_get(offset).to_int().to_double() / 255.0)
      }
    5123 =>
      match read_u16_le(bytes, offset) {
        Some(value) => Some(value.to_double() / 65535.0)
        None => None
      }
    _ => None
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
fn parse_node_templates(
  root_object : Map[String, Json],
  mesh_templates : Array[MeshSceneTemplate?],
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
    let renderers = match field_int(node_object, "mesh") {
      Some(mesh_index) =>
        match mesh_templates.get(mesh_index) {
          Some(Some(mesh_template)) => mesh_template.renderers.copy()
          _ => []
        }
      None => []
    }
    templates.push({ name, transform, renderers, skin_index, children })
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
fn resolve_relative_asset_path(scene_path : String, uri : String) -> String {
  if uri.has_prefix("/") || uri.contains("://") {
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
