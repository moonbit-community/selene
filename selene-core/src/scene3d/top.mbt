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
  transform : @transform3d.Transform3D
  renderer : @render3d.Mesh3DRenderer?
  children : Array[Int]
}

///|
priv struct SceneTemplate {
  roots : Array[Int]
  nodes : Array[SceneNodeTemplate]
}

///|
priv struct MeshSceneTemplate {
  mesh : @render3d.MeshHandle
  material : @render3d.MaterialHandle
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
    transform: @transform3d.Transform3D::identity(),
    renderer: None,
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
  let root = @entity.Entity::new()
  @transform3d.transforms3d.set(root, root_transform)
  guard scene_templates.get(scene) is Some(template) else { return root }
  for node_index in template.roots {
    instantiate_scene_node(template, node_index, root, 0)
  }
  root
}

///|
fn instantiate_scene_node(
  template : SceneTemplate,
  node_index : Int,
  parent : @entity.Entity,
  depth : Int,
) -> Unit {
  if depth > 512 {
    return
  }
  guard node_index >= 0 && node_index < template.nodes.length() else { return }
  let node = template.nodes[node_index]
  let entity = parent.spawn_child()
  @transform3d.transforms3d.set(entity, node.transform)
  if node.renderer is Some(renderer) {
    @render3d.mesh3d_renderers.set(entity, renderer)
  }
  for child_index in node.children {
    instantiate_scene_node(template, child_index, entity, depth + 1)
  }
}

///|
fn load_scene_template(path : String) -> SceneTemplate {
  guard @backend.get_asset_bytes(path) is Some(bytes) else {
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
  let mesh_templates = parse_mesh_templates(root_object, material_handles)
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
fn parse_mesh_templates(
  root_object : Map[String, Json],
  material_handles : Array[@render3d.MaterialHandle],
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
    let primitive_json = primitives[0]
    guard json_object(primitive_json) is Some(primitive_object) else {
      templates.push(None)
      continue
    }
    let mesh_asset = parse_mesh_asset(mesh_object, primitive_object)
    let mesh_handle = @render3d.register_mesh_asset(mesh_asset)
    let material_handle = match field_int(primitive_object, "material") {
      Some(material_index) =>
        material_handles.get(material_index).unwrap_or(default_material)
      None => default_material
    }
    templates.push(Some({ mesh: mesh_handle, material: material_handle }))
  }
  templates
}

///|
fn parse_mesh_asset(
  mesh_object : Map[String, Json],
  primitive_object : Map[String, Json],
) -> @render3d.MeshAsset {
  let extras = if primitive_object.get("extras") is Some(primitive_extras) {
    Some(primitive_extras)
  } else {
    mesh_object.get("extras")
  }
  guard extras is Some(extras_json) else {
    return @render3d.cube_mesh(@math.Vec3::one())
  }
  guard json_object(extras_json) is Some(extras_object) else {
    return @render3d.cube_mesh(@math.Vec3::one())
  }
  let primitive = field_string(extras_object, "selenePrimitive").map_or(
    "cube",
    fn(name) { name.to_lower() },
  )
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
  }
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
    let renderer = match field_int(node_object, "mesh") {
      Some(mesh_index) =>
        match mesh_templates.get(mesh_index) {
          Some(Some(mesh_template)) =>
            Some(@render3d.Mesh3DRenderer::{
              mesh: mesh_template.mesh,
              material: mesh_template.material,
              visible: true,
            })
          _ => None
        }
      None => None
    }
    templates.push({ transform, renderer, children })
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
