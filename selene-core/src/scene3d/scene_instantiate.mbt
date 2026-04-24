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
    @animation.bind_skinned_mesh(pending.entity, {
      target_entity: pending.target_entity,
      mesh: pending.mesh,
      base_positions: pending.skinned.base_positions,
      indices: pending.skinned.indices,
      topology: pending.skinned.topology,
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
) -> Array[@animation.MorphTargetBinding3D] {
  let output : Array[@animation.MorphTargetBinding3D] = []
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
  @animation.bind_morph_mesh(entity, {
    target_entity,
    mesh,
    base_positions: binding.base_positions,
    indices: binding.indices,
    topology: binding.topology,
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
  root_entity : @entity.Entity,
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
  let entity_name = if parts.contains(path_base) {
    "\{base_name}#\{node_index}"
  } else {
    base_name
  }
  let entity_path = if parts.contains(path_base) {
    "\{parent_path}/\{entity_name}"
  } else {
    path_base
  }
  parts.set(entity_path, entity)
  node_entities.set(node_index, entity)
  @name.names().set(entity, @name.Name(entity_name))
  @animation.animation_target_ids().set(
    entity,
    @animation.AnimationTargetId(entity_path),
  )
  @animation.animated_bys().set(entity, @animation.AnimatedBy(root_entity))
  @transform.transforms().set(entity, node.transform)
  if node.camera is Some(camera) {
    @camera3d.cameras3d().set(entity, camera)
  }
  if node.directional_light is Some(light) {
    @render3d.directional_lights3d().set(entity, light)
  }
  if node.point_light is Some(light) {
    @render3d.point_lights3d().set(entity, light)
  }
  if node.spot_light is Some(light) {
    @render3d.spot_lights3d().set(entity, light)
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
    @render3d.mesh3d_renderers().set(entity, renderer)
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
      @transform.transforms().set(primitive_entity, {
        translation: @math.Vec3::zero(),
        rotation: @math.Quat::identity(),
        scale: @math.Vec3::one(),
      })
      let renderer = match template_renderer.skinned {
        Some(_) =>
          {
            ..template_renderer.renderer,
            mesh: clone_mesh_handle(template_renderer.renderer.mesh),
          }
        None => template_renderer.renderer
      }
      @render3d.mesh3d_renderers().set(primitive_entity, renderer)
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
      root_entity,
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
  guard @asset.read_bytes(path) is Some(bytes) else {
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
    root_object, buffers, buffer_views, accessors, nodes, roots,
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
fn assign_scene_node_target_ids(
  nodes : Array[SceneNodeTemplate],
  node_index : Int,
  parent_path : String,
  seen_paths : Set[String],
  output : Map[Int, @animation.AnimationTargetId],
  depth : Int,
) -> Unit {
  if depth > 512 || node_index < 0 || node_index >= nodes.length() {
    return
  }
  let node = nodes[node_index]
  let base_name = node.name.unwrap_or("node\{node_index}")
  let path_base = "\{parent_path}/\{base_name}"
  let path = if seen_paths.contains(path_base) {
    "\{path_base}#\{node_index}"
  } else {
    path_base
  }
  seen_paths.add(path)
  output.set(node_index, @animation.AnimationTargetId(path))
  for child_index in node.children {
    assign_scene_node_target_ids(
      nodes,
      child_index,
      path,
      seen_paths,
      output,
      depth + 1,
    )
  }
}

///|
fn compute_scene_node_target_ids(
  nodes : Array[SceneNodeTemplate],
  roots : Array[Int],
) -> Map[Int, @animation.AnimationTargetId] {
  let output : Map[Int, @animation.AnimationTargetId] = Map::new()
  let seen_paths : Set[String] = Set::new()
  for root_order, node_index in roots {
    assign_scene_node_target_ids(
      nodes,
      node_index,
      "root\{root_order}",
      seen_paths,
      output,
      0,
    )
  }
  output
}

///|
fn parse_animation_clips(
  root_object : Map[String, Json],
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
  nodes : Array[SceneNodeTemplate],
  roots : Array[Int],
) -> Map[String, @animation.AnimationClipHandle] {
  let animations : Map[String, @animation.AnimationClipHandle] = Map::new()
  guard root_object.get("animations") is Some(animations_json) else {
    return animations
  }
  guard json_array(animations_json) is Some(animation_items) else {
    return animations
  }
  let target_ids = compute_scene_node_target_ids(nodes, roots)
  for animation_index, animation_json in animation_items {
    guard json_object(animation_json) is Some(animation_object) else {
      continue
    }
    let channels = parse_animation_channels(
      animation_object, buffers, buffer_views, accessors, target_ids,
    )
    if channels.length() == 0 {
      continue
    }
    let name = field_string(animation_object, "name").unwrap_or(
      "animation_\{animation_index}",
    )
    let clip = @animation.AnimationClip(name)
    for channel in channels {
      if channel.translations.length() > 0 {
        clip.add_curve_to_target(
          channel.target,
          @animation.VariableCurve::vec3(
            @animation.transform_translation_field(),
            channel.translations,
            interpolation=channel.interpolation,
          ),
        )
      }
      if channel.rotations.length() > 0 {
        clip.add_curve_to_target(
          channel.target,
          @animation.VariableCurve::quat(
            @animation.transform_rotation_field(),
            channel.rotations,
            interpolation=channel.interpolation,
          ),
        )
      }
      if channel.scales.length() > 0 {
        clip.add_curve_to_target(
          channel.target,
          @animation.VariableCurve::vec3(
            @animation.transform_scale_field(),
            channel.scales,
            interpolation=channel.interpolation,
          ),
        )
      }
      if channel.weights.length() > 0 {
        clip.add_curve_to_target(
          channel.target,
          @animation.VariableCurve::weights(
            @animation.morph_weights_field(),
            channel.weights,
            interpolation=channel.interpolation,
          ),
        )
      }
    }
    let clip_handle = @animation.register_animation_clip_asset(clip)
    animations.set(name, clip_handle)
  }
  animations
}
