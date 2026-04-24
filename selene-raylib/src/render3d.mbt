///|
pub fn sync_image_asset(
  handle : @render3d_types.ImageHandle,
  image : @render3d_types.ImageAsset,
) -> Unit {
  backend.images3d.set(handle, image)
  if image_handle_requires_mipmaps(handle) {
    ensure_texture_mipmaps(get_texture(image.path))
  }
}

///|
pub fn release_mesh_asset(handle : @render3d_types.MeshHandle) -> Unit {
  clear_triangle_mesh_cache_for_handle(handle)
  backend.meshes3d.remove(handle)
}

///|
pub fn release_material_asset(handle : @render3d_types.MaterialHandle) -> Unit {
  backend.materials3d.remove(handle)
}

///|
pub fn release_image_asset(handle : @render3d_types.ImageHandle) -> Unit {
  backend.images3d.remove(handle)
}

///|
pub fn render3d_submit(frame : @render3d_types.RenderFrame3D) -> Unit {
  guard frame.camera is Some(active_camera) else { return }
  let shadow_state = render_directional_shadow_map(frame, active_camera)
  if !backend.frame_has_draw_commands {
    @raylib.clear_background(to_ray_color(frame.clear_color))
  }
  mark_frame_drawn()
  begin_3d(active_camera)
  for item in frame.items {
    guard backend.meshes3d.get(item.mesh) is Some(mesh_asset) else { continue }
    let material = backend.materials3d
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    draw_mesh3d_instance(
      item.mesh,
      mesh_asset,
      material,
      item.transform,
      frame,
      active_camera.position,
      item.receive_shadows,
      shadow_state,
    )
  }
  end_3d()
}

///|
fn draw_mesh3d_instance(
  mesh_handle : @render3d_types.MeshHandle,
  mesh_asset : @render3d_types.MeshAsset,
  material : @render3d_types.StandardMaterial3D,
  transform : @render3d_types.FrameTransform3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  @rl.push_matrix()
  @rl.translatef(
    to_float(transform.translation.x),
    to_float(transform.translation.y),
    to_float(transform.translation.z),
  )
  apply_quat_rotation(transform.rotation)
  @rl.scalef(
    to_float(transform.scale.x),
    to_float(transform.scale.y),
    to_float(transform.scale.z),
  )
  let texture_bundle = resolve_material_texture_bundle(material)
  match mesh_asset.primitive {
    Cube(size) =>
      draw_lit_cuboid(
        size, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    Sphere(radius) =>
      draw_lit_sphere(
        radius, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    Cylinder(radius_top, radius_bottom, height, slices) =>
      draw_lit_cylinder(
        radius_top, radius_bottom, height, slices, material, frame, camera_position,
        texture_bundle, receive_shadows, shadow_state,
      )
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
      let cuboid = @smath.Vec3(size.x, thickness, size.z)
      draw_lit_cuboid(
        cuboid, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
    }
    Triangles(mesh) =>
      draw_triangle_mesh(
        mesh_handle, mesh, material, frame, camera_position, texture_bundle, receive_shadows,
        shadow_state,
      )
  }
  @rl.pop_matrix()
}

///|
const TEXTURED_SPHERE_STACKS : Int = 16

///|
const TEXTURED_SPHERE_SLICES : Int = 24

///|
fn draw_lit_cuboid(
  size : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let key = "cube:\{size.x}:\{size.y}:\{size.z}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_cube(to_float(size.x), to_float(size.y), to_float(size.z))
  })
  draw_lit_mesh_with_material(
    mesh, frame, camera_position, material, texture_bundle, false, receive_shadows,
    shadow_state,
  )
}

///|
fn draw_lit_sphere(
  radius : Double,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let key = "sphere:\{radius}:\{TEXTURED_SPHERE_SLICES}:\{TEXTURED_SPHERE_STACKS}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_sphere(
      to_float(radius),
      TEXTURED_SPHERE_SLICES,
      TEXTURED_SPHERE_STACKS,
    )
  })
  draw_lit_mesh_with_material(
    mesh, frame, camera_position, material, texture_bundle, false, receive_shadows,
    shadow_state,
  )
}

///|
fn draw_lit_cylinder(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  material : @render3d_types.StandardMaterial3D,
  frame : @render3d_types.RenderFrame3D,
  camera_position : @smath.Vec3,
  texture_bundle : MaterialTextureBundle3D?,
  receive_shadows : Bool,
  shadow_state : FrameShadowState?,
) -> Unit {
  let safe_slices = @cmp.maximum(3, slices)
  if (radius_top - radius_bottom).abs() <= 0.000001 {
    let key = "cylinder:\{radius_top}:\{height}:\{safe_slices}"
    let mesh = get_or_create_primitive_mesh(key, fn() {
      @raylib.gen_mesh_cylinder(
        to_float(radius_top),
        to_float(height),
        safe_slices,
      )
    })
    draw_lit_mesh_with_material(
      mesh, frame, camera_position, material, texture_bundle, false, receive_shadows,
      shadow_state,
    )
    return
  }
  let key = "truncated_cylinder:\{radius_top}:\{radius_bottom}:\{height}:\{safe_slices}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    let (vertices, uvs, normals) = build_cylinder_mesh(
      radius_top, radius_bottom, height, safe_slices,
    )
    create_uploaded_triangle_mesh(
      vertices,
      Some(uvs),
      None,
      normals,
      None,
      None,
    ).unwrap_or(
      @raylib.gen_mesh_cylinder(
        to_float(radius_bottom),
        to_float(height),
        safe_slices,
      ),
    )
  })
  draw_lit_mesh_with_material(
    mesh, frame, camera_position, material, texture_bundle, false, receive_shadows,
    shadow_state,
  )
}

///|
fn resolve_material_texture_source(
  binding : @render3d_types.TextureBinding3D,
) -> MaterialTextureSource3D? {
  guard backend.images3d.get(binding.image) is Some(image_asset) else {
    warn_texture_issue(
      "missing_image_handle:\{image_handle_text(binding.image)}",
      "material texture handle \{image_handle_text(binding.image)} is not synced; fallback to default texture",
    )
    return None
  }
  let texture = get_texture(image_asset.path)
  apply_texture_sampler(texture, binding.sampler)
  let texture_id = @raylib.get_texture_id(texture)
  let width = @raylib.get_texture_width(texture)
  let height = @raylib.get_texture_height(texture)
  if texture_id <= 0 || width <= 0 || height <= 0 {
    warn_texture_issue(
      "invalid_texture:\{image_asset.path}",
      "failed to load texture '\{image_asset.path}' (id=\{texture_id}, size=\{width}x\{height}); fallback to base_color",
    )
    return None
  }
  Some({
    texture,
    texcoord_set: binding.texcoord_set,
    transform: binding.transform,
  })
}

///|
fn resolve_material_texture_bundle(
  material : @render3d_types.StandardMaterial3D,
) -> MaterialTextureBundle3D? {
  let base_source = material.base_color_texture.bind(
    resolve_material_texture_source,
  )
  let emissive_source = material.emissive_texture.bind(
    resolve_material_texture_source,
  )
  let metallic_roughness_source = material.metallic_roughness_texture.bind(
    resolve_material_texture_source,
  )
  let occlusion_source = material.occlusion_texture.bind(
    resolve_material_texture_source,
  )
  let normal_source = material.normal_texture.bind(
    resolve_material_texture_source,
  )
  if base_source is None &&
    emissive_source is None &&
    metallic_roughness_source is None &&
    occlusion_source is None &&
    normal_source is None {
    return None
  }
  let default_transform = @render3d_types.default_texture_transform3d()
  Some({
    base_texture: base_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    emissive_texture: emissive_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    metallic_roughness_texture: metallic_roughness_source.map_or(
      get_white_texture(),
      fn(source) { source.texture },
    ),
    occlusion_texture: occlusion_source.map_or(get_white_texture(), fn(source) {
      source.texture
    }),
    normal_texture: normal_source.map_or(null_texture(), fn(source) {
      source.texture
    }),
    has_base_texture: base_source is Some(_),
    has_emissive_texture: emissive_source is Some(_),
    has_metallic_roughness_texture: metallic_roughness_source is Some(_),
    has_occlusion_texture: occlusion_source is Some(_),
    has_normal_texture: normal_source is Some(_),
    base_transform: base_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    emissive_transform: emissive_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    metallic_roughness_transform: metallic_roughness_source.map_or(
      default_transform,
      fn(source) { source.transform },
    ),
    occlusion_transform: occlusion_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    normal_transform: normal_source.map_or(default_transform, fn(source) {
      source.transform
    }),
    base_texcoord_set: base_source.map_or(0, fn(source) { source.texcoord_set }),
    emissive_texcoord_set: emissive_source.map_or(0, fn(source) {
      source.texcoord_set
    }),
    metallic_roughness_texcoord_set: metallic_roughness_source.map_or(0, fn(
      source,
    ) {
      source.texcoord_set
    }),
    occlusion_texcoord_set: occlusion_source.map_or(0, fn(source) {
      source.texcoord_set
    }),
    normal_texcoord_set: normal_source.map_or(0, fn(source) {
      source.texcoord_set
    }),
  })
}

///|
fn texture_wrap_to_raylib(wrap : @render3d_types.TextureWrap3D) -> Int {
  match wrap {
    ClampToEdge => @raylib.TextureWrapClamp
    MirroredRepeat => @raylib.TextureWrapMirrorRepeat
    Repeat => @raylib.TextureWrapRepeat
  }
}

///|
fn texture_filter_to_raylib(sampler : @render3d_types.TextureSampler3D) -> Int {
  let nearest = sampler.mag_filter == Nearest || sampler.min_filter == Nearest
  match sampler.mipmap_filter {
    Some(_) =>
      if nearest {
        @raylib.TextureFilterPoint
      } else {
        @raylib.TextureFilterTrilinear
      }
    None =>
      if nearest {
        @raylib.TextureFilterPoint
      } else {
        @raylib.TextureFilterBilinear
      }
  }
}

///|
fn sampler_requests_generated_mipmaps(
  sampler : @render3d_types.TextureSampler3D,
) -> Bool {
  sampler.mipmap_filter is Some(_) &&
  texture_filter_to_raylib(sampler) == @raylib.TextureFilterTrilinear
}

///|
fn maybe_ensure_binding_mipmaps(
  binding : @render3d_types.TextureBinding3D,
) -> Unit {
  if !sampler_requests_generated_mipmaps(binding.sampler) {
    return
  }
  if backend.images3d.get(binding.image) is Some(image_asset) {
    ensure_texture_mipmaps(get_texture(image_asset.path))
  }
}

///|
fn ensure_material_mipmaps(
  material : @render3d_types.StandardMaterial3D,
) -> Unit {
  if material.base_color_texture is Some(binding) {
    maybe_ensure_binding_mipmaps(binding)
  }
  if material.normal_texture is Some(binding) {
    maybe_ensure_binding_mipmaps(binding)
  }
  if material.emissive_texture is Some(binding) {
    maybe_ensure_binding_mipmaps(binding)
  }
  if material.metallic_roughness_texture is Some(binding) {
    maybe_ensure_binding_mipmaps(binding)
  }
  if material.occlusion_texture is Some(binding) {
    maybe_ensure_binding_mipmaps(binding)
  }
}

///|
fn material_uses_image_with_mipmaps(
  material : @render3d_types.StandardMaterial3D,
  image : @render3d_types.ImageHandle,
) -> Bool {
  let binding_matches = fn(binding : @render3d_types.TextureBinding3D) -> Bool {
    binding.image == image &&
    sampler_requests_generated_mipmaps(binding.sampler)
  }
  let uses_base = match material.base_color_texture {
    Some(binding) => binding_matches(binding)
    None => false
  }
  let uses_normal = match material.normal_texture {
    Some(binding) => binding_matches(binding)
    None => false
  }
  let uses_emissive = match material.emissive_texture {
    Some(binding) => binding_matches(binding)
    None => false
  }
  let uses_metallic_roughness = match material.metallic_roughness_texture {
    Some(binding) => binding_matches(binding)
    None => false
  }
  let uses_occlusion = match material.occlusion_texture {
    Some(binding) => binding_matches(binding)
    None => false
  }
  uses_base ||
  uses_normal ||
  uses_emissive ||
  uses_metallic_roughness ||
  uses_occlusion
}

///|
fn image_handle_requires_mipmaps(image : @render3d_types.ImageHandle) -> Bool {
  for material_handle, material in backend.materials3d {
    ignore(material_handle)
    if material_uses_image_with_mipmaps(material, image) {
      return true
    }
  }
  false
}

///|
fn apply_texture_sampler(
  texture : @raylib.Texture,
  sampler : @render3d_types.TextureSampler3D,
) -> Unit {
  @raylib.set_texture_wrap(texture, texture_wrap_to_raylib(sampler.wrap_u))
  @raylib.set_texture_filter(texture, texture_filter_to_raylib(sampler))
}

///|
fn build_cylinder_mesh(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
) -> (Array[@smath.Vec3], Array[@smath.Vec2], Array[@smath.Vec3]) {
  let vertices : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2] = []
  let normals : Array[@smath.Vec3] = []
  let segment_count = if slices < 3 { 3 } else { slices }
  let half_h = height / 2.0
  let slope_y = if height.abs() < 0.000001 {
    0.0
  } else {
    (radius_bottom - radius_top) / height
  }
  for segment in 0..<segment_count {
    let u0 = segment.to_double() / segment_count.to_double()
    let u1 = (segment + 1).to_double() / segment_count.to_double()
    let phi0 = u0 * 2.0 * @cmath.PI
    let phi1 = u1 * 2.0 * @cmath.PI
    let top0 = @smath.Vec3(
      radius_top * @cmath.cos(phi0),
      half_h,
      radius_top * @cmath.sin(phi0),
    )
    let top1 = @smath.Vec3(
      radius_top * @cmath.cos(phi1),
      half_h,
      radius_top * @cmath.sin(phi1),
    )
    let bot0 = @smath.Vec3(
      radius_bottom * @cmath.cos(phi0),
      -half_h,
      radius_bottom * @cmath.sin(phi0),
    )
    let bot1 = @smath.Vec3(
      radius_bottom * @cmath.cos(phi1),
      -half_h,
      radius_bottom * @cmath.sin(phi1),
    )
    let side_normal0 = @smath.Vec3(@cmath.cos(phi0), slope_y, @cmath.sin(phi0)).normalize()
    let side_normal1 = @smath.Vec3(@cmath.cos(phi1), slope_y, @cmath.sin(phi1)).normalize()
    push_textured_triangle(
      vertices,
      uvs,
      normals,
      top0,
      bot0,
      bot1,
      @smath.Vec2(u0, 0.0),
      @smath.Vec2(u0, 1.0),
      @smath.Vec2(u1, 1.0),
      side_normal0,
      side_normal0,
      side_normal1,
    )
    push_textured_triangle(
      vertices,
      uvs,
      normals,
      top0,
      bot1,
      top1,
      @smath.Vec2(u0, 0.0),
      @smath.Vec2(u1, 1.0),
      @smath.Vec2(u1, 0.0),
      side_normal0,
      side_normal1,
      side_normal1,
    )
    if radius_top.abs() > 0.000001 {
      let top_center = @smath.Vec3(0.0, half_h, 0.0)
      let top_normal = @smath.Vec3(0.0, 1.0, 0.0)
      push_textured_triangle(
        vertices,
        uvs,
        normals,
        top_center,
        top1,
        top0,
        @smath.Vec2(0.5, 0.5),
        @smath.Vec2(0.5 + 0.5 * @cmath.cos(phi1), 0.5 + 0.5 * @cmath.sin(phi1)),
        @smath.Vec2(0.5 + 0.5 * @cmath.cos(phi0), 0.5 + 0.5 * @cmath.sin(phi0)),
        top_normal,
        top_normal,
        top_normal,
      )
    }
    if radius_bottom.abs() > 0.000001 {
      let bottom_center = @smath.Vec3(0.0, -half_h, 0.0)
      let bottom_normal = @smath.Vec3(0.0, -1.0, 0.0)
      push_textured_triangle(
        vertices,
        uvs,
        normals,
        bottom_center,
        bot0,
        bot1,
        @smath.Vec2(0.5, 0.5),
        @smath.Vec2(0.5 + 0.5 * @cmath.cos(phi0), 0.5 + 0.5 * @cmath.sin(phi0)),
        @smath.Vec2(0.5 + 0.5 * @cmath.cos(phi1), 0.5 + 0.5 * @cmath.sin(phi1)),
        bottom_normal,
        bottom_normal,
        bottom_normal,
      )
    }
  }
  (vertices, uvs, normals)
}

///|
fn push_textured_triangle(
  vertices : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2],
  normals : Array[@smath.Vec3],
  a : @smath.Vec3,
  b : @smath.Vec3,
  c : @smath.Vec3,
  uv_a : @smath.Vec2,
  uv_b : @smath.Vec2,
  uv_c : @smath.Vec2,
  n_a : @smath.Vec3,
  n_b : @smath.Vec3,
  n_c : @smath.Vec3,
) -> Unit {
  vertices.push(a)
  vertices.push(b)
  vertices.push(c)
  uvs.push(uv_a)
  uvs.push(uv_b)
  uvs.push(uv_c)
  normals.push(n_a)
  normals.push(n_b)
  normals.push(n_c)
}
