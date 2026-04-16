///|
fn resolve_texture_binding(
  texture_object : Map[String, Json],
  texture_sources : Array[TextureSourceTemplate?],
  texture_transform? : Bool = false,
) -> @render3d.TextureBinding3D? {
  guard field_int(texture_object, "index") is Some(texture_index) else {
    return None
  }
  guard texture_sources.get(texture_index) is Some(Some(source)) else {
    return None
  }
  guard source.image is Some(image_handle) else { return None }
  let base_texcoord_set = field_int(texture_object, "texCoord").unwrap_or(0)
  let (texcoord_set, transform) = if texture_transform {
    resolve_texture_transform(texture_object, base_texcoord_set)
  } else {
    (base_texcoord_set, @render3d.default_texture_transform3d())
  }
  Some(
    @render3d.texture_binding3d(
      image_handle,
      texcoord_set~,
      sampler=source.sampler,
      transform~,
    ),
  )
}

///|
fn resolve_texture_transform(
  texture_object : Map[String, Json],
  fallback_texcoord_set : Int,
) -> (Int, @render3d.TextureTransform3D) {
  guard field_object(texture_object, "extensions") is Some(extensions) else {
    return (fallback_texcoord_set, @render3d.default_texture_transform3d())
  }
  guard field_object(extensions, "KHR_texture_transform")
    is Some(transform_object) else {
    return (fallback_texcoord_set, @render3d.default_texture_transform3d())
  }
  (
    field_int(transform_object, "texCoord").unwrap_or(fallback_texcoord_set),
    {
      offset: parse_texture_transform_vec2(
        field_array(transform_object, "offset"),
        @math.Vec2::zero(),
      ),
      scale: parse_texture_transform_vec2(
        field_array(transform_object, "scale"),
        @math.Vec2(1.0, 1.0),
      ),
      rotation: field_number(transform_object, "rotation").unwrap_or(0.0),
    },
  )
}

///|
fn parse_texture_transform_vec2(
  values : Array[Json]?,
  fallback : @math.Vec2,
) -> @math.Vec2 {
  match values {
    Some(items) if items.length() >= 2 =>
      @math.Vec2(
        json_number(items[0]).unwrap_or(fallback[X]),
        json_number(items[1]).unwrap_or(fallback[Y]),
      )
    _ => fallback
  }
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
        blobs.push(@asset.read_bytes(resolved))
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
          cast_shadows: true,
          receive_shadows: true,
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
  let mode = field_int(primitive_object, "mode").unwrap_or(4)
  guard triangle_topology_from_gltf_mode(mode) is Some(topology) else {
    return None
  }
  let explicit_indices = match field_int(primitive_object, "indices") {
    Some(indices_accessor_index) =>
      read_accessor_indices(
        indices_accessor_index, buffers, buffer_views, accessors,
      )
    None => None
  }
  let indices = explicit_indices.unwrap_or(
    default_mesh_indices(positions.length()),
  )
  if !indices_in_bounds(indices, positions.length()) {
    return None
  }
  let triangle_indices = triangulate_triangle_indices(indices, topology)
  if triangle_indices.length() < 3 {
    return None
  }
  let triangle_normals = match field_int(attributes_object, "NORMAL") {
    Some(normal_accessor_index) =>
      match
        read_accessor_vec3(
          normal_accessor_index, buffers, buffer_views, accessors,
        ) {
        Some(normals) if normals.length() == positions.length() => normals
        _ => compute_vertex_normals(positions, indices, topology)
      }
    None => compute_vertex_normals(positions, indices, topology)
  }
  let triangle_uv_sets = parse_triangle_uv_sets(
    attributes_object,
    positions.length(),
    buffers,
    buffer_views,
    accessors,
  )
  let triangle_colors = parse_triangle_colors(
    attributes_object,
    positions.length(),
    buffers,
    buffer_views,
    accessors,
  )
  let triangle_tangents = parse_triangle_tangents(
    attributes_object,
    positions.length(),
    buffers,
    buffer_views,
    accessors,
  )
  let skinned = parse_triangle_binding(
    primitive_object, attributes_object, positions, explicit_indices, topology, triangle_normals,
    triangle_uv_sets, triangle_colors, triangle_tangents, buffers, buffer_views,
    accessors,
  )
  let mesh_indices = match (explicit_indices, topology) {
    (Some(explicit), _) => Some(explicit)
    (None, TriangleList) => None
    (None, _) => Some(indices)
  }
  Some({
    mesh: @render3d.triangle_mesh(
      positions,
      uv_sets=triangle_uv_sets,
      normals=Some(triangle_normals),
      tangents=triangle_tangents,
      colors=triangle_colors,
      indices=mesh_indices,
      topology~,
    ),
    skinned,
  })
}

///|
fn parse_triangle_binding(
  primitive_object : Map[String, Json],
  attributes_object : Map[String, Json],
  positions : Array[@math.Vec3],
  indices : Array[Int]?,
  topology : @render3d.TriangleTopology3D,
  triangle_normals : Array[@math.Vec3],
  triangle_uv_sets : Array[Array[@math.Vec2]],
  triangle_colors : Array[@render.Color]?,
  triangle_tangents : Array[@render3d.Tangent3D]?,
  buffers : Array[Bytes?],
  buffer_views : Array[BufferViewTemplate?],
  accessors : Array[AccessorTemplate?],
) -> SkinnedPrimitiveTemplate? {
  let triangle_influences = parse_triangle_influences(
    attributes_object,
    positions.length(),
    buffers,
    buffer_views,
    accessors,
  )
  let morph_targets = parse_triangle_morph_targets(
    primitive_object,
    positions.length(),
    buffers,
    buffer_views,
    accessors,
  )
  if triangle_influences is None && morph_targets.length() == 0 {
    return None
  }
  let influences : Array[@animation.SkinVertexInfluence3D] = []
  if triangle_influences is Some(mapped_influences) {
    for influence in mapped_influences {
      influences.push(influence)
    }
  }
  Some({
    base_positions: positions,
    indices,
    topology,
    base_normals: triangle_normals,
    uv_sets: triangle_uv_sets,
    colors: triangle_colors,
    tangents: triangle_tangents,
    morph_targets,
    morph_weights: [],
    influences,
  })
}
