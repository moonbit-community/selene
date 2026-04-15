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
fn repeat_mode_to_code(repeat : @smath.RepeatMode) -> Int {
  match repeat {
    RepeatX => 0
    RepeatY => 1
    NoRepeat => 2
    Repeat => 3
  }
}

///|
fn h_align_to_code(align : @smath.HAlign) -> Int {
  match align {
    Left => 0
    Center => 1
    Right => 2
  }
}

///|
fn v_align_to_code(align : @smath.VAlign) -> Int {
  match align {
    Top => 0
    Center => 1
    Bottom => 2
  }
}

///|
fn alpha_mode_to_code(alpha_mode : @render.AlphaMode2D) -> Int {
  match alpha_mode {
    Opaque => 0
    Blend => 1
  }
}

///|
fn blend_mode_to_code(blend_mode : @render.BlendMode2D) -> Int {
  match blend_mode {
    Alpha => 0
    Additive => 1
    Multiply => 2
  }
}

///|
fn color_rgba(color : @render.Color) -> (Double, Double, Double, Double) {
  (
    color.r.reinterpret_as_int().to_double(),
    color.g.reinterpret_as_int().to_double(),
    color.b.reinterpret_as_int().to_double(),
    color.a,
  )
}

///|
const MAX_DIRECTIONAL_LIGHTS : Int = 4

///|
const MAX_DIRECTIONAL_CASCADES : Int = 4

///|
const MAX_POINT_LIGHTS : Int = 8

///|
const MAX_SPOT_LIGHTS : Int = 4

///|
let synced_mesh_assets : Map[
  @render3d_types.MeshHandle,
  @render3d_types.MeshAsset,
] = Map::new()

///|
let synced_material_assets : Map[
  @render3d_types.MaterialHandle,
  @render3d_types.StandardMaterial3D,
] = Map::new()

///|
let synced_image_assets : Map[
  @render3d_types.ImageHandle,
  @render3d_types.ImageAsset,
] = Map::new()

///|
priv struct MaterialTextureSource3D {
  path : String
  texcoord_set : Int
  sampler_code : Int
}

///|
priv struct MaterialTextureBundle3D {
  base_source : MaterialTextureSource3D?
  emissive_source : MaterialTextureSource3D?
  metallic_roughness_source : MaterialTextureSource3D?
  occlusion_source : MaterialTextureSource3D?
  normal_source : MaterialTextureSource3D?
  primary_texcoord_set : Int
}

///|
priv struct ResolvedMaterialTextureInput3D {
  path : String
  uvs : Array[@smath.Vec2]
  sampler_code : Int
}

///|
pub fn preload_img(path : String) -> Unit {
  webgpu_preload_img(resolve_asset_path(path))
}

///|
pub fn begin_frame(clear : @render.Color) -> Unit {
  webgpu_begin_frame(
    clear.r.reinterpret_as_int().to_double() / 255.0,
    clear.g.reinterpret_as_int().to_double() / 255.0,
    clear.b.reinterpret_as_int().to_double() / 255.0,
    clear.a,
  )
}

///|
pub fn end_frame() -> Unit {
  webgpu_end_frame()
}

///|
pub fn capture_frame_png() -> Bytes? {
  let raw = webgpu_capture_frame_png_bytes()
  if raw.length() == 0 {
    return None
  }
  Some(
    Bytes::from_iter(raw.iter().map(fn(value) { saturating_file_byte(value) })),
  )
}

///|
pub fn capture_frame_png_to_file(_path : String) -> Bool {
  false
}

///|
pub fn begin_2d_pass(
  viewport : @smath.Rect,
  load_op : @render2d_types.RenderPassLoadOp2D,
  clear_color : @render.Color,
  target : @render2d_types.RenderPassTarget2D,
) -> Unit {
  let target_name = match target {
    Screen => ""
    Offscreen(name) => name
  }
  let (cr, cg, cb, ca) = color_rgba(clear_color)
  webgpu_begin_2d_pass(
    viewport.position[X],
    viewport.position[Y],
    viewport.size[X],
    viewport.size[Y],
    if load_op is @render2d_types.RenderPassLoadOp2D::Clear {
      1
    } else {
      0
    },
    cr,
    cg,
    cb,
    ca,
    target_name,
  )
}

///|
pub fn end_2d_pass() -> Unit {
  webgpu_end_2d_pass()
}

///|
pub fn push_clip_rect(rect : @smath.Rect) -> Unit {
  webgpu_push_clip_rect(
    rect.position[X],
    rect.position[Y],
    rect.size[X],
    rect.size[Y],
  )
}

///|
pub fn pop_clip_rect() -> Unit {
  webgpu_pop_clip_rect()
}

///|
pub fn reset_clip_stack() -> Unit {
  webgpu_reset_clip_stack()
}

///|
pub fn draw_image(
  command : @render2d_types.ImageDrawCommand2D,
  image_path : String,
) -> Unit {
  let transform = command.transform
  let mut source_x = 0.0
  let mut source_y = 0.0
  let mut source_width = 0.0
  let mut source_height = 0.0
  let mut has_source = false
  match command.source {
    Some(source) => {
      source_x = source.position[X]
      source_y = source.position[Y]
      source_width = source.size[X]
      source_height = source.size[Y]
      has_source = true
    }
    None => ()
  }
  let (tr, tg, tb, ta) = color_rgba(command.color)
  let uv_transform = command.uv_transform
  webgpu_draw_image(
    resolve_asset_path(image_path),
    command.destination.position[X],
    command.destination.position[Y],
    command.destination.size[X],
    command.destination.size[Y],
    has_source,
    source_x,
    source_y,
    source_width,
    source_height,
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
    uv_transform.a,
    uv_transform.b,
    uv_transform.c,
    uv_transform.d,
    uv_transform.tx,
    uv_transform.ty,
    repeat_mode_to_code(command.repeat),
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
    tr,
    tg,
    tb,
    ta,
  )
}

///|
pub fn draw_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  if draw_text_with_cosmic(command) {
    return
  }
  let (r, g, b, a) = color_rgba(command.style.color)
  let transform = command.transform
  webgpu_draw_text(
    command.text,
    command.position[X],
    command.position[Y],
    transform.a,
    transform.b,
    transform.c,
    transform.d,
    transform.tx,
    transform.ty,
    command.style.family,
    command.style.size,
    h_align_to_code(command.style.align),
    v_align_to_code(command.style.baseline),
    blend_mode_to_code(command.blend_mode),
    r,
    g,
    b,
    a,
  )
}

///|
pub fn measure_text(
  style : @render2d_types.TextStyle2D,
  text : String,
) -> @smath.Vec2 {
  let measured = webgpu_measure_text(text, style.family, style.size)
  if measured.length() >= 2 {
    @smath.Vec2(measured[0], measured[1])
  } else {
    let width = text.length().to_double() * style.size * 0.6
    let height = if style.size <= 0.0 { 1.0 } else { style.size }
    @smath.Vec2(width, height)
  }
}

///|
pub fn draw_rect(command : @render2d_types.RectDrawCommand2D) -> Unit {
  let (fr, fg, fb, fa) = color_rgba(command.fill_color)
  let mut has_stroke = false
  let mut sr = 0.0
  let mut sg = 0.0
  let mut sb = 0.0
  let mut sa = 1.0
  match command.stroke_color {
    Some(stroke_color) => {
      has_stroke = true
      let (tr, tg, tb, ta) = color_rgba(stroke_color)
      sr = tr
      sg = tg
      sb = tb
      sa = ta
    }
    None => ()
  }
  webgpu_draw_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
    command.transform.a,
    command.transform.b,
    command.transform.c,
    command.transform.d,
    command.transform.tx,
    command.transform.ty,
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
    fr,
    fg,
    fb,
    fa,
    has_stroke,
    sr,
    sg,
    sb,
    sa,
  )
}

///|
pub fn draw_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  let (fr, fg, fb, fa) = color_rgba(command.fill_color)
  let mut has_stroke = false
  let mut sr = 0.0
  let mut sg = 0.0
  let mut sb = 0.0
  let mut sa = 1.0
  match command.stroke_color {
    Some(stroke_color) => {
      has_stroke = true
      let (tr, tg, tb, ta) = color_rgba(stroke_color)
      sr = tr
      sg = tg
      sb = tb
      sa = ta
    }
    None => ()
  }
  webgpu_draw_circle(
    command.center[X],
    command.center[Y],
    command.radius,
    command.transform.a,
    command.transform.b,
    command.transform.c,
    command.transform.d,
    command.transform.tx,
    command.transform.ty,
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
    fr,
    fg,
    fb,
    fa,
    has_stroke,
    sr,
    sg,
    sb,
    sa,
  )
}

///|
pub fn draw_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  let (sr, sg, sb, sa) = color_rgba(command.color_start)
  let (er, eg, eb, ea) = color_rgba(command.color_end)
  webgpu_draw_gradient_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
    command.transform.a,
    command.transform.b,
    command.transform.c,
    command.transform.d,
    command.transform.tx,
    command.transform.ty,
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
    sr,
    sg,
    sb,
    sa,
    er,
    eg,
    eb,
    ea,
  )
}

///|
fn begin_3d(camera : @render3d_types.FrameCamera3D) -> Unit {
  webgpu_begin_3d(
    camera.position.x,
    camera.position.y,
    camera.position.z,
    camera.target.x,
    camera.target.y,
    camera.target.z,
    camera.up.x,
    camera.up.y,
    camera.up.z,
    camera.fov_y,
    camera.near,
    camera.far,
    if camera.projection == Orthographic {
      1.0
    } else {
      0.0
    },
    camera.orthographic_size.map_or(0.0, fn(size) { size[X] }),
    camera.orthographic_size.map_or(0.0, fn(size) { size[Y] }),
  )
}

///|
fn end_3d() -> Unit {
  webgpu_end_3d()
}

///|
pub fn sync_mesh_asset(
  handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.MeshAsset,
) -> Unit {
  synced_mesh_assets.set(handle, mesh)
}

///|
pub fn sync_material_asset(
  handle : @render3d_types.MaterialHandle,
  material : @render3d_types.StandardMaterial3D,
) -> Unit {
  synced_material_assets.set(handle, material)
}

///|
pub fn sync_image_asset(
  handle : @render3d_types.ImageHandle,
  image : @render3d_types.ImageAsset,
) -> Unit {
  synced_image_assets.set(handle, image)
}

///|
pub fn release_mesh_asset(handle : @render3d_types.MeshHandle) -> Unit {
  synced_mesh_assets.remove(handle)
}

///|
pub fn release_material_asset(handle : @render3d_types.MaterialHandle) -> Unit {
  synced_material_assets.remove(handle)
}

///|
pub fn release_image_asset(handle : @render3d_types.ImageHandle) -> Unit {
  synced_image_assets.remove(handle)
}

///|
pub fn render_3d_frame(frame : @render3d_types.RenderFrame3D) -> Unit {
  guard frame.camera is Some(active_camera) else { return }
  configure_scene_lighting(frame)
  begin_3d(active_camera)
  for item in frame.items {
    guard synced_mesh_assets.get(item.mesh) is Some(mesh_asset) else {
      continue
    }
    let material = synced_material_assets
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    let center = item.transform.translation
    let rotation = item.transform.rotation
    let color = effective_material_color(material)
    let (emissive_r, emissive_g, emissive_b) = color_rgb01(
      material.emissive_color,
    )
    let alpha_mode = alpha_mode_code(material.alpha_mode)
    let alpha_cutoff = material.alpha_cutoff
    let unlit = material.unlit
    match mesh_asset.primitive {
      Cube(size) =>
        webgpu_draw_cube_3d(
          center.x,
          center.y,
          center.z,
          size.x * item.transform.scale.x,
          size.y * item.transform.scale.y,
          size.z * item.transform.scale.z,
          rotation.x,
          rotation.y,
          rotation.z,
          rotation.w,
          color.r.reinterpret_as_int().to_double(),
          color.g.reinterpret_as_int().to_double(),
          color.b.reinterpret_as_int().to_double(),
          color.a,
          emissive_r,
          emissive_g,
          emissive_b,
          alpha_mode,
          alpha_cutoff,
          unlit,
          item.cast_shadows,
          item.receive_shadows,
        )
      Sphere(radius) =>
        webgpu_draw_sphere_3d(
          center.x,
          center.y,
          center.z,
          scaled_radius(radius, item.transform.scale),
          rotation.x,
          rotation.y,
          rotation.z,
          rotation.w,
          color.r.reinterpret_as_int().to_double(),
          color.g.reinterpret_as_int().to_double(),
          color.b.reinterpret_as_int().to_double(),
          color.a,
          emissive_r,
          emissive_g,
          emissive_b,
          alpha_mode,
          alpha_cutoff,
          unlit,
          item.cast_shadows,
          item.receive_shadows,
        )
      Cylinder(radius_top, radius_bottom, height, slices) =>
        webgpu_draw_cylinder_3d(
          center.x,
          center.y,
          center.z,
          scaled_radius(radius_top, item.transform.scale),
          scaled_radius(radius_bottom, item.transform.scale),
          height * item.transform.scale.y.abs(),
          slices,
          rotation.x,
          rotation.y,
          rotation.z,
          rotation.w,
          color.r.reinterpret_as_int().to_double(),
          color.g.reinterpret_as_int().to_double(),
          color.b.reinterpret_as_int().to_double(),
          color.a,
          emissive_r,
          emissive_g,
          emissive_b,
          alpha_mode,
          alpha_cutoff,
          unlit,
          item.cast_shadows,
          item.receive_shadows,
        )
      Plane(size) => {
        let scaled = scaled_vec3(size, item.transform.scale)
        let y = if scaled.y.abs() < 0.0001 { 0.02 } else { scaled.y }
        webgpu_draw_cube_3d(
          center.x,
          center.y,
          center.z,
          scaled.x,
          y,
          scaled.z,
          rotation.x,
          rotation.y,
          rotation.z,
          rotation.w,
          color.r.reinterpret_as_int().to_double(),
          color.g.reinterpret_as_int().to_double(),
          color.b.reinterpret_as_int().to_double(),
          color.a,
          emissive_r,
          emissive_g,
          emissive_b,
          alpha_mode,
          alpha_cutoff,
          unlit,
          item.cast_shadows,
          item.receive_shadows,
        )
      }
      Triangles(mesh) =>
        if resolve_triangle_indices(mesh) is Some(triangle_indices) &&
          triangle_indices.length() >= 3 {
          let normals = resolve_mesh_normals(mesh)
          let tangents = resolve_mesh_tangents(mesh)
          match resolve_material_texture_bundle(material) {
            Some(bundle) =>
              match mesh.uv_sets.get(bundle.primary_texcoord_set) {
                Some(primary_uvs) =>
                  if primary_uvs.length() == mesh.positions.length() &&
                    normals.length() == mesh.positions.length() {
                    let base_input = resolve_material_texture_input(
                      mesh,
                      bundle.base_source,
                      primary_uvs,
                      transform_binding=material.base_color_texture,
                    )
                    let emissive_input = resolve_material_texture_input(
                      mesh,
                      bundle.emissive_source,
                      primary_uvs,
                      transform_binding=material.emissive_texture,
                    )
                    let metallic_roughness_input = resolve_material_texture_input(
                      mesh,
                      bundle.metallic_roughness_source,
                      primary_uvs,
                      transform_binding=material.metallic_roughness_texture,
                    )
                    let occlusion_input = resolve_material_texture_input(
                      mesh,
                      bundle.occlusion_source,
                      primary_uvs,
                      transform_binding=material.occlusion_texture,
                    )
                    let normal_input = resolve_material_texture_input(
                      mesh,
                      bundle.normal_source,
                      primary_uvs,
                      transform_binding=material.normal_texture,
                    )
                    webgpu_draw_textured_triangles_3d(
                      base_input.path,
                      emissive_input.path,
                      metallic_roughness_input.path,
                      occlusion_input.path,
                      if tangents.length() == mesh.positions.length() {
                        normal_input.path
                      } else {
                        ""
                      },
                      base_input.sampler_code,
                      emissive_input.sampler_code,
                      metallic_roughness_input.sampler_code,
                      occlusion_input.sampler_code,
                      normal_input.sampler_code,
                      flatten_textured_vertices3d(
                        mesh.positions,
                        triangle_indices,
                        base_input.uvs,
                        emissive_input.uvs,
                        metallic_roughness_input.uvs,
                        occlusion_input.uvs,
                        normal_input.uvs,
                        normals,
                        tangents,
                        mesh.colors,
                        item.transform.scale,
                        material,
                        color,
                        item.receive_shadows,
                      ),
                      center.x,
                      center.y,
                      center.z,
                      rotation.x,
                      rotation.y,
                      rotation.z,
                      rotation.w,
                      material.double_sided,
                      item.cast_shadows,
                      item.receive_shadows,
                    )
                  } else {
                    webgpu_draw_colored_triangles_3d(
                      flatten_colored_vertices3d(
                        mesh.positions,
                        triangle_indices,
                        normals,
                        mesh.colors,
                        item.transform.scale,
                        material,
                        color,
                        item.receive_shadows,
                      ),
                      center.x,
                      center.y,
                      center.z,
                      rotation.x,
                      rotation.y,
                      rotation.z,
                      rotation.w,
                      material.double_sided,
                      item.cast_shadows,
                      item.receive_shadows,
                    )
                  }
                None =>
                  webgpu_draw_colored_triangles_3d(
                    flatten_colored_vertices3d(
                      mesh.positions,
                      triangle_indices,
                      normals,
                      mesh.colors,
                      item.transform.scale,
                      material,
                      color,
                      item.receive_shadows,
                    ),
                    center.x,
                    center.y,
                    center.z,
                    rotation.x,
                    rotation.y,
                    rotation.z,
                    rotation.w,
                    material.double_sided,
                    item.cast_shadows,
                    item.receive_shadows,
                  )
              }
            None =>
              webgpu_draw_colored_triangles_3d(
                flatten_colored_vertices3d(
                  mesh.positions,
                  triangle_indices,
                  normals,
                  mesh.colors,
                  item.transform.scale,
                  material,
                  color,
                  item.receive_shadows,
                ),
                center.x,
                center.y,
                center.z,
                rotation.x,
                rotation.y,
                rotation.z,
                rotation.w,
                material.double_sided,
                item.cast_shadows,
                item.receive_shadows,
              )
          }
        }
    }
  }
  end_3d()
}

///|
fn scaled_vec3(size : @smath.Vec3, scale : @smath.Vec3) -> @smath.Vec3 {
  {
    x: size.x * scale.x.abs(),
    y: size.y * scale.y.abs(),
    z: size.z * scale.z.abs(),
  }
}

///|
fn scaled_radius(radius : Double, scale : @smath.Vec3) -> Double {
  let sx = scale.x.abs()
  let sz = scale.z.abs()
  let max_xz = if sx > sz { sx } else { sz }
  radius * max_xz
}

///|
fn configure_scene_lighting(frame : @render3d_types.RenderFrame3D) -> Unit {
  let has_lighting = frame.ambient_light is Some(_) ||
    frame.directional_lights.length() > 0 ||
    frame.point_lights.length() > 0 ||
    frame.spot_lights.length() > 0
  let ambient = if has_lighting {
    frame.ambient_light.map_or(@smath.Vec3::zero(), fn(light) {
      let (r, g, b) = color_rgb01(light.color)
      @smath.Vec3::new(r, g, b).scalar_mul(light.intensity)
    })
  } else {
    @smath.Vec3::one()
  }
  let directional_data = pack_directional_light_data(frame)
  let point_data = pack_point_light_data(frame)
  let spot_data = pack_spot_light_data(frame)
  webgpu_set_lighting_3d(
    directional_data,
    point_data,
    spot_data,
    ambient.x,
    ambient.y,
    ambient.z,
    frame.directional_shadow_map_size.to_double(),
    frame.point_shadow_map_size.to_double(),
  )
}

///|
fn pack_directional_light_data(
  frame : @render3d_types.RenderFrame3D,
) -> Array[Double] {
  let directional_data : Array[Double] = []
  let directional_count = if frame.directional_lights.length() <
    MAX_DIRECTIONAL_LIGHTS {
    frame.directional_lights.length()
  } else {
    MAX_DIRECTIONAL_LIGHTS
  }
  for idx in 0..<directional_count {
    let light = frame.directional_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3::new(0.0, -1.0, 0.0)
    } else {
      light.direction.normalize()
    }
    let (r, g, b) = color_rgb01(light.color)
    let authored_bounds = light.cascade_shadow_config.bounds
    let cascade_count = if authored_bounds.length() < 1 {
      1
    } else if authored_bounds.length() > MAX_DIRECTIONAL_CASCADES {
      MAX_DIRECTIONAL_CASCADES
    } else {
      authored_bounds.length()
    }
    directional_data.push(direction.x)
    directional_data.push(direction.y)
    directional_data.push(direction.z)
    directional_data.push(light.intensity)
    directional_data.push(r)
    directional_data.push(g)
    directional_data.push(b)
    directional_data.push(if light.shadows { 1.0 } else { 0.0 })
    directional_data.push(light.shadow_depth_bias)
    directional_data.push(light.shadow_normal_bias)
    directional_data.push(cascade_count.to_double())
    directional_data.push(light.cascade_shadow_config.minimum_distance)
    directional_data.push(light.cascade_shadow_config.overlap_proportion)
    let fallback_bound = match authored_bounds.last() {
      Some(bound) => bound
      None => 0.0
    }
    for bound_index in 0..<MAX_DIRECTIONAL_CASCADES {
      directional_data.push(
        authored_bounds.get(bound_index).unwrap_or(fallback_bound),
      )
    }
  }
  directional_data
}

///|
fn pack_point_light_data(
  frame : @render3d_types.RenderFrame3D,
) -> Array[Double] {
  let point_data : Array[Double] = []
  let point_count = if frame.point_lights.length() < MAX_POINT_LIGHTS {
    frame.point_lights.length()
  } else {
    MAX_POINT_LIGHTS
  }
  for idx in 0..<point_count {
    let light = frame.point_lights[idx]
    let (r, g, b) = color_rgb01(light.color)
    point_data.push(light.position.x)
    point_data.push(light.position.y)
    point_data.push(light.position.z)
    point_data.push(light.intensity)
    point_data.push(r)
    point_data.push(g)
    point_data.push(b)
    point_data.push(light.range)
    point_data.push(if light.shadows { 1.0 } else { 0.0 })
    point_data.push(light.shadow_depth_bias)
    point_data.push(light.shadow_normal_bias)
    point_data.push(light.shadow_map_near_z)
  }
  point_data
}

///|
fn pack_spot_light_data(frame : @render3d_types.RenderFrame3D) -> Array[Double] {
  let spot_data : Array[Double] = []
  let spot_count = if frame.spot_lights.length() < MAX_SPOT_LIGHTS {
    frame.spot_lights.length()
  } else {
    MAX_SPOT_LIGHTS
  }
  for idx in 0..<spot_count {
    let light = frame.spot_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3::new(0.0, -1.0, 0.0)
    } else {
      light.direction.normalize()
    }
    let (r, g, b) = color_rgb01(light.color)
    let (inner_angle, outer_angle) = if light.inner_angle <= light.outer_angle {
      (light.inner_angle, light.outer_angle)
    } else {
      (light.outer_angle, light.inner_angle)
    }
    spot_data.push(light.position.x)
    spot_data.push(light.position.y)
    spot_data.push(light.position.z)
    spot_data.push(light.intensity)
    spot_data.push(r)
    spot_data.push(g)
    spot_data.push(b)
    spot_data.push(light.range)
    spot_data.push(direction.x)
    spot_data.push(direction.y)
    spot_data.push(direction.z)
    spot_data.push(@math.cos(inner_angle))
    spot_data.push(@math.cos(outer_angle))
    spot_data.push(if light.shadows { 1.0 } else { 0.0 })
    spot_data.push(light.shadow_depth_bias)
    spot_data.push(light.shadow_normal_bias)
    spot_data.push(light.shadow_map_near_z)
  }
  spot_data
}

///|
fn resolve_mesh_normals(
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[@smath.Vec3] {
  let triangle_indices = resolve_triangle_indices(mesh).unwrap_or([])
  mesh.normals
  .filter(fn(candidates) { candidates.length() == mesh.positions.length() })
  .unwrap_or(compute_vertex_normals(mesh.positions, triangle_indices))
}

///|
fn resolve_triangle_indices(
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[Int]? {
  let base_indices = mesh.indices.unwrap_or(
    default_mesh_indices(mesh.positions.length()),
  )
  if base_indices.length() == 0 {
    return None
  }
  for index in base_indices {
    if index < 0 || index >= mesh.positions.length() {
      return None
    }
  }
  let triangle_indices = triangulate_triangle_indices(
    base_indices,
    mesh.topology,
  )
  if triangle_indices.length() < 3 || triangle_indices.length() % 3 != 0 {
    return None
  }
  Some(triangle_indices)
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
fn triangulate_triangle_indices(
  indices : Array[Int],
  topology : @render3d_types.TriangleTopology3D,
) -> Array[Int] {
  let triangle_indices : Array[Int] = []
  let push_index = fn(index : Int) { triangle_indices.push(index) }
  match topology {
    TriangleList => {
      let tri_count = indices.length() / 3
      for tri in 0..<tri_count {
        let base = tri * 3
        push_index(indices[base])
        push_index(indices[base + 1])
        push_index(indices[base + 2])
      }
    }
    TriangleStrip =>
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
    TriangleFan =>
      if indices.length() >= 3 {
        let head = indices[0]
        for i in 1..<(indices.length() - 1) {
          push_index(head)
          push_index(indices[i])
          push_index(indices[i + 1])
        }
      }
  }
  triangle_indices
}

///|
fn compute_vertex_normals(
  positions : Array[@smath.Vec3],
  triangle_indices : Array[Int],
) -> Array[@smath.Vec3] {
  let normals : Array[@smath.Vec3] = []
  for _ in 0..<positions.length() {
    normals.push(@smath.Vec3::zero())
  }
  let triangle_count = triangle_indices.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let ia = triangle_indices[base]
    let ib = triangle_indices[base + 1]
    let ic = triangle_indices[base + 2]
    if ia < 0 ||
      ia >= positions.length() ||
      ib < 0 ||
      ib >= positions.length() ||
      ic < 0 ||
      ic >= positions.length() {
      continue
    }
    let a = positions[ia]
    let b = positions[ib]
    let c = positions[ic]
    let mut normal = (b - a).cross(c - a)
    if normal.length_squared() <= 0.0000001 {
      normal = @smath.Vec3::new(0.0, 1.0, 0.0)
    }
    normals[ia] = normals[ia] + normal
    normals[ib] = normals[ib] + normal
    normals[ic] = normals[ic] + normal
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    normals[index] = if normal.length_squared() <= 0.0000001 {
      @smath.Vec3::new(0.0, 1.0, 0.0)
    } else {
      normal.normalize()
    }
  }
  normals
}

///|
fn resolve_mesh_tangents(
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[@render3d_types.Tangent3D] {
  match mesh.tangents {
    Some(candidates) if candidates.length() == mesh.positions.length() =>
      candidates
    _ => {
      let tangents : Array[@render3d_types.Tangent3D] = []
      for _ in 0..<mesh.positions.length() {
        tangents.push({ x: 1.0, y: 0.0, z: 0.0, w: 1.0 })
      }
      tangents
    }
  }
}

///|
fn flatten_colored_vertices3d(
  positions : Array[@smath.Vec3],
  triangle_indices : Array[Int],
  normals : Array[@smath.Vec3],
  vertex_colors : Array[@render.Color]?,
  scale : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  base_color : @render.Color,
  receive_shadows : Bool,
) -> Array[Double] {
  let values : Array[Double] = []
  let (emissive_r, emissive_g, emissive_b) = color_rgb01(
    material.emissive_color,
  )
  let alpha_mode = alpha_mode_code(material.alpha_mode)
  let alpha_cutoff = material.alpha_cutoff
  let unlit = material_unlit_code(material)
  for index in triangle_indices {
    let position = positions[index]
    let normal = normals[index]
    let color = resolve_vertex_color(vertex_colors, index, base_color)
    let (r, g, b) = color_rgb01(color)
    let a = color.a
    values.push(position.x * scale.x)
    values.push(position.y * scale.y)
    values.push(position.z * scale.z)
    values.push(normal.x)
    values.push(normal.y)
    values.push(normal.z)
    values.push(r)
    values.push(g)
    values.push(b)
    values.push(a)
    values.push(emissive_r)
    values.push(emissive_g)
    values.push(emissive_b)
    values.push(alpha_mode)
    values.push(alpha_cutoff)
    values.push(unlit)
    values.push(if receive_shadows { 1.0 } else { 0.0 })
  }
  values
}

///|
fn flatten_textured_vertices3d(
  positions : Array[@smath.Vec3],
  triangle_indices : Array[Int],
  base_uvs : Array[@smath.Vec2],
  emissive_uvs : Array[@smath.Vec2],
  metallic_roughness_uvs : Array[@smath.Vec2],
  occlusion_uvs : Array[@smath.Vec2],
  normal_uvs : Array[@smath.Vec2],
  normals : Array[@smath.Vec3],
  tangents : Array[@render3d_types.Tangent3D],
  vertex_colors : Array[@render.Color]?,
  scale : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  base_color : @render.Color,
  receive_shadows : Bool,
) -> Array[Double] {
  let values : Array[Double] = []
  let (emissive_r, emissive_g, emissive_b) = color_rgb01(
    material.emissive_color,
  )
  let alpha_mode = alpha_mode_code(material.alpha_mode)
  let alpha_cutoff = material.alpha_cutoff
  let metallic = material.metallic
  let roughness = material.roughness
  let occlusion_strength = material.occlusion_strength
  let normal_scale = material.normal_scale
  let unlit = material_unlit_code(material)
  for index in triangle_indices {
    let position = positions[index]
    let base_uv = base_uvs[index]
    let emissive_uv = emissive_uvs[index]
    let metallic_roughness_uv = metallic_roughness_uvs[index]
    let occlusion_uv = occlusion_uvs[index]
    let normal_uv = normal_uvs[index]
    let normal = normals[index]
    let tangent = tangents[index]
    let color = resolve_vertex_color(vertex_colors, index, base_color)
    let (r, g, b) = color_rgb01(color)
    let a = color.a
    values.push(position.x * scale.x)
    values.push(position.y * scale.y)
    values.push(position.z * scale.z)
    values.push(normal.x)
    values.push(normal.y)
    values.push(normal.z)
    values.push(base_uv[X])
    values.push(base_uv[Y])
    values.push(emissive_uv[X])
    values.push(emissive_uv[Y])
    values.push(metallic_roughness_uv[X])
    values.push(metallic_roughness_uv[Y])
    values.push(occlusion_uv[X])
    values.push(occlusion_uv[Y])
    values.push(normal_uv[X])
    values.push(normal_uv[Y])
    values.push(r)
    values.push(g)
    values.push(b)
    values.push(a)
    values.push(emissive_r)
    values.push(emissive_g)
    values.push(emissive_b)
    values.push(tangent.x)
    values.push(tangent.y)
    values.push(tangent.z)
    values.push(tangent.w)
    values.push(alpha_mode)
    values.push(alpha_cutoff)
    values.push(metallic)
    values.push(roughness)
    values.push(occlusion_strength)
    values.push(normal_scale)
    values.push(unlit)
    values.push(if receive_shadows { 1.0 } else { 0.0 })
  }
  values
}

///|
fn resolve_material_texture_input(
  mesh : @render3d_types.TriangleMesh3D,
  source : MaterialTextureSource3D?,
  fallback_uvs : Array[@smath.Vec2],
  transform_binding? : @render3d_types.TextureBinding3D? = None,
) -> ResolvedMaterialTextureInput3D {
  match source {
    Some(source) =>
      match mesh.uv_sets.get(source.texcoord_set) {
        Some(uvs) if uvs.length() == mesh.positions.length() =>
          {
            path: source.path,
            uvs: resolve_material_texture_uvs(
              transform_binding,
              source.texcoord_set,
              uvs,
            ),
            sampler_code: source.sampler_code,
          }
        _ => { path: "", uvs: fallback_uvs, sampler_code: 0 }
      }
    None => { path: "", uvs: fallback_uvs, sampler_code: 0 }
  }
}

///|
fn resolve_material_texture_uvs(
  binding : @render3d_types.TextureBinding3D?,
  texcoord_set : Int,
  uvs : Array[@smath.Vec2],
) -> Array[@smath.Vec2] {
  match binding {
    Some(binding) =>
      if binding.texcoord_set == texcoord_set &&
        binding.transform != @render3d_types.default_texture_transform3d() {
        uvs.map(fn(uv) {
          @render3d_types.apply_texture_transform3d(binding.transform, uv)
        })
      } else {
        uvs
      }
    _ => uvs
  }
}

///|
fn color_rgb01(color : @render.Color) -> (Double, Double, Double) {
  (
    color.r.reinterpret_as_int().to_double() / 255.0,
    color.g.reinterpret_as_int().to_double() / 255.0,
    color.b.reinterpret_as_int().to_double() / 255.0,
  )
}

///|
fn alpha_mode_code(mode : @render3d_types.AlphaMode3D) -> Double {
  match mode {
    Opaque => 0.0
    Mask => 1.0
    Blend => 2.0
  }
}

///|
fn material_unlit_code(material : @render3d_types.StandardMaterial3D) -> Double {
  if material.unlit {
    1.0
  } else {
    0.0
  }
}

///|
fn effective_material_color(
  material : @render3d_types.StandardMaterial3D,
) -> @render.Color {
  match material.alpha_mode {
    Opaque => { ..material.base_color, a: 1.0 }
    _ => material.base_color
  }
}

///|
fn resolve_vertex_color(
  vertex_colors : Array[@render.Color]?,
  index : Int,
  base_color : @render.Color,
) -> @render.Color {
  match vertex_colors.bind(fn(values) { values.get(index) }) {
    Some(vertex_color) => multiply_colors(base_color, vertex_color)
    None => base_color
  }
}

///|
fn multiply_colors(lhs : @render.Color, rhs : @render.Color) -> @render.Color {
  {
    r: ((lhs.r.reinterpret_as_int() * rhs.r.reinterpret_as_int() + 127) / 255).reinterpret_as_uint(),
    g: ((lhs.g.reinterpret_as_int() * rhs.g.reinterpret_as_int() + 127) / 255).reinterpret_as_uint(),
    b: ((lhs.b.reinterpret_as_int() * rhs.b.reinterpret_as_int() + 127) / 255).reinterpret_as_uint(),
    a: lhs.a * rhs.a,
  }
}

///|
fn texture_sampler_code(sampler : @render3d_types.TextureSampler3D) -> Int {
  let repeat_u = sampler.wrap_u != ClampToEdge
  let repeat_v = sampler.wrap_v != ClampToEdge
  if repeat_u && repeat_v {
    3
  } else if repeat_u {
    1
  } else if repeat_v {
    2
  } else {
    0
  }
}

///|
fn resolve_texture_source(
  binding : @render3d_types.TextureBinding3D,
) -> MaterialTextureSource3D? {
  match synced_image_assets.get(binding.image) {
    Some(image_asset) =>
      Some({
        path: resolve_asset_path(image_asset.path),
        texcoord_set: binding.texcoord_set,
        sampler_code: texture_sampler_code(binding.sampler),
      })
    None => None
  }
}

///|
fn resolve_material_texture_bundle(
  material : @render3d_types.StandardMaterial3D,
) -> MaterialTextureBundle3D? {
  let base_source = material.base_color_texture.bind(resolve_texture_source)
  let emissive_source = material.emissive_texture.bind(resolve_texture_source)
  let metallic_roughness_source = material.metallic_roughness_texture.bind(
    resolve_texture_source,
  )
  let occlusion_source = material.occlusion_texture.bind(resolve_texture_source)
  let normal_source = material.normal_texture.bind(resolve_texture_source)
  let primary = match base_source {
    Some(base) => Some(base)
    None =>
      match emissive_source {
        Some(emissive) => Some(emissive)
        None =>
          match metallic_roughness_source {
            Some(metallic_roughness) => Some(metallic_roughness)
            None =>
              match occlusion_source {
                Some(occlusion) => Some(occlusion)
                None => normal_source
              }
          }
      }
  }
  match primary {
    Some(primary_source) =>
      Some({
        base_source,
        emissive_source,
        metallic_roughness_source,
        occlusion_source,
        normal_source,
        primary_texcoord_set: primary_source.texcoord_set,
      })
    None => None
  }
}
