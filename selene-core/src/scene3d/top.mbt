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
  renderers : Array[@render3d.Mesh3DRenderer]
  children : Array[Int]
}

///|
priv struct SceneTemplate {
  roots : Array[Int]
  nodes : Array[SceneNodeTemplate]
}

///|
pub(all) struct SceneInstance {
  root : @entity.Entity
  parts : Map[String, @entity.Entity]
}

///|
priv struct MeshSceneTemplate {
  renderers : Array[@render3d.Mesh3DRenderer]
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
  { roots: [], nodes: [] }
}

///|
fn default_scene_node_template() -> SceneNodeTemplate {
  {
    name: None,
    transform: @transform3d.Transform3D::identity(),
    renderers: [],
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
    return { root, parts }
  }
  for root_order, node_index in template.roots {
    instantiate_scene_node(
      template,
      node_index,
      root,
      parts,
      "root\{root_order}",
      0,
    )
  }
  { root, parts }
}

///|
pub fn scene_instance_part(
  instance : SceneInstance,
  path : String,
) -> @entity.Entity? {
  instance.parts.get(path)
}

///|
fn instantiate_scene_node(
  template : SceneTemplate,
  node_index : Int,
  parent : @entity.Entity,
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
  @transform3d.transforms3d.set(entity, node.transform)
  if node.renderers.length() == 1 {
    @render3d.mesh3d_renderers.set(entity, node.renderers[0])
  } else if node.renderers.length() > 1 {
    for primitive_index, renderer in node.renderers {
      let primitive_entity = entity.spawn_child()
      @transform3d.transforms3d.set(
        primitive_entity,
        @transform3d.Transform3D::identity(),
      )
      @render3d.mesh3d_renderers.set(primitive_entity, renderer)
      parts.set("\{entity_path}/primitive\{primitive_index}", primitive_entity)
    }
  }
  for child_index in node.children {
    instantiate_scene_node(
      template,
      child_index,
      entity,
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
  let mesh_templates = parse_mesh_templates(
    root_object, material_handles, buffers, buffer_views, accessors,
  )
  let nodes = parse_node_templates(root_object, mesh_templates)
  let roots = parse_root_nodes(root_object, nodes.length())
  { roots, nodes }
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
    let renderers : Array[@render3d.Mesh3DRenderer] = []
    for primitive_json in primitives {
      guard json_object(primitive_json) is Some(primitive_object) else {
        continue
      }
      let mesh_asset = parse_mesh_asset(
        mesh_object, primitive_object, buffers, buffer_views, accessors,
      )
      let mesh_handle = @render3d.register_mesh_asset(mesh_asset)
      let material_handle = match field_int(primitive_object, "material") {
        Some(material_index) =>
          material_handles.get(material_index).unwrap_or(default_material)
        None => default_material
      }
      renderers.push({
        mesh: mesh_handle,
        material: material_handle,
        visible: true,
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
) -> @render3d.MeshAsset {
  if parse_triangle_mesh_asset(
      primitive_object, buffers, buffer_views, accessors,
    )
    is Some(triangle_mesh) {
    return triangle_mesh
  }
  if parse_mesh_asset_from_extras(mesh_object, primitive_object) is Some(asset) {
    return asset
  }
  @render3d.cube_mesh(@math.Vec3::one())
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
) -> @render3d.MeshAsset? {
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
  Some(
    @render3d.triangle_mesh(
      triangle_positions,
      uvs=triangle_uvs,
      normals=Some(triangle_normals),
    ),
  )
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
    let renderers = match field_int(node_object, "mesh") {
      Some(mesh_index) =>
        match mesh_templates.get(mesh_index) {
          Some(Some(mesh_template)) => mesh_template.renderers
          _ => []
        }
      None => []
    }
    templates.push({ name, transform, renderers, children })
  }
  templates
}

///|
fn parse_node_transform(
  node_object : Map[String, Json],
) -> @transform3d.Transform3D {
  {
    translation: parse_vec3(node_object.get("translation"), @math.Vec3::zero()),
    rotation: parse_quat(node_object.get("rotation"), @math.Quat::identity()),
    scale: parse_vec3(node_object.get("scale"), @math.Vec3::one()),
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
