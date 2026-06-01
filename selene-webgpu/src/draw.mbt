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
const TEXTURED_SPHERE_SLICES : Int = 24

///|
const TEXTURED_SPHERE_STACKS : Int = 16

///|
const WEBGPU_PRIMITIVE_MESH_RESOURCE_TTL_FRAMES : Int = 120

///|
pub(all) enum Render3DLightingMode {
  Full
  Cheap
  Unlit
} derive(Eq, Debug)

///|
let synced_mesh_assets : Map[
  @render3d_types.MeshHandle,
  @render3d_types.MeshAsset,
] = Map([])

///|
let synced_material_assets : Map[
  @render3d_types.MaterialHandle,
  @render3d_types.StandardMaterial3D,
] = Map([])

///|
let synced_image_assets : Map[
  @render3d_types.ImageHandle,
  @render3d_types.ImageAsset,
] = Map([])

///|
let textured_primitive_mesh_cache : Map[String, @render3d_types.TriangleMesh3D] = Map([],
)

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
priv struct Render3DSubmissionStats {
  mut sections : Int
  mut submitted_items : Int
  mut skipped_items : Int
  mut command_groups : Int
  mut draw_commands : Int
  mut lit_triangle_commands : Int
  mut textured_triangle_commands : Int
  mut uploaded_vertex_bytes : Int
  mut render_bind_group_creations : Int
}

///|
priv struct LitPrimitiveMeshBatchAccumulator {
  order : Array[String]
  resource_keys : Map[String, String]
  instances : Map[String, Array[Double]]
  double_sided : Map[String, Bool]
  cast_shadows : Map[String, Bool]
  receive_shadows : Map[String, Bool]
}

///|
let last_render3d_submission_stats : Ref[Render3DSubmissionStats] = Ref(
  empty_render3d_submission_stats(),
)

///|
let last_render3d_submission_stats_checksum : Ref[Int] = Ref(0)

///|
let retained_render3d_instance_last_seen : Map[String, Int] = Map([])

///|
let current_render3d_lighting_mode : Ref[Render3DLightingMode] = Ref(Full)

///|
let webgpu_resource_frame : Ref[Int] = Ref(0)

///|
let primitive_mesh_resource_last_seen : Map[String, Int] = Map([])

///|
let uploaded_primitive_mesh_resources : Map[String, Bool] = Map([])

///|
fn empty_render3d_submission_stats() -> Render3DSubmissionStats {
  {
    sections: 0,
    submitted_items: 0,
    skipped_items: 0,
    command_groups: 0,
    draw_commands: 0,
    lit_triangle_commands: 0,
    textured_triangle_commands: 0,
    uploaded_vertex_bytes: 0,
    render_bind_group_creations: 0,
  }
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
pub fn frame_begin(clear : @render.Color) -> Unit {
  webgpu_begin_frame(
    clear.r.reinterpret_as_int().to_double() / 255.0,
    clear.g.reinterpret_as_int().to_double() / 255.0,
    clear.b.reinterpret_as_int().to_double() / 255.0,
    clear.a,
  )
}

///|
pub fn frame_end() -> Unit {
  webgpu_end_frame()
}

///|
pub fn set_render3d_lighting_mode(mode : Render3DLightingMode) -> Unit {
  current_render3d_lighting_mode.val = mode
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
pub fn render2d_begin_pass(
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
  if load_op is @render2d_types.RenderPassLoadOp2D::Clear {
    let clear_viewport = match target {
      Screen => viewport
      Offscreen(_) => { position: @smath.Vec2::zero(), size: viewport.size }
    }
    webgpu_push_color_vertices_2d(
      "triangle",
      pack_rect_fill_vertices2d(clear_viewport, @smath.Transform(), clear_color),
      if clear_color.a >= 0.999999 {
        0
      } else {
        1
      },
      0,
    )
  }
}

///|
pub fn render2d_end_pass() -> Unit {
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
  let path = resolve_asset_path(image_path)
  let dimensions = webgpu_image_dimensions(path)
  if dimensions.length() < 3 ||
    dimensions[0] < 0.5 ||
    dimensions[1] <= 0.0 ||
    dimensions[2] <= 0.0 {
    return
  }
  let packed = pack_image_vertices2d(command, dimensions[1], dimensions[2])
  webgpu_push_texture_vertices_2d(
    path,
    packed.sampler_code,
    packed.vertices,
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
  )
}

///|
pub fn draw_text(command : @render2d_types.TextDrawCommand2D) -> Unit {
  if draw_text_with_cosmic(command) {
    return
  }
  let (r, g, b, a) = color_rgba(command.style.color)
  let dimensions = webgpu_text_texture_dimensions(
    command.text,
    command.style.family,
    command.style.size,
    r,
    g,
    b,
    a,
  )
  if dimensions.length() < 3 ||
    dimensions[0] < 0.5 ||
    dimensions[1] <= 0.0 ||
    dimensions[2] <= 0.0 {
    return
  }
  webgpu_push_text_vertices_2d(
    command.text,
    command.style.family,
    command.style.size,
    r,
    g,
    b,
    a,
    pack_text_vertices2d(command, dimensions[1], dimensions[2]),
    blend_mode_to_code(command.blend_mode),
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
  webgpu_push_color_vertices_2d(
    "triangle",
    pack_rect_fill_vertices2d(
      command.rect,
      command.transform,
      command.fill_color,
    ),
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
  )
  match command.stroke_color {
    Some(stroke_color) =>
      webgpu_push_color_vertices_2d(
        "line",
        pack_rect_stroke_vertices2d(
          command.rect,
          command.transform,
          stroke_color,
        ),
        alpha_mode_to_code(command.alpha_mode),
        blend_mode_to_code(command.blend_mode),
      )
    None => ()
  }
}

///|
pub fn draw_circle(command : @render2d_types.CircleDrawCommand2D) -> Unit {
  webgpu_push_color_vertices_2d(
    "triangle",
    pack_circle_fill_vertices2d(
      command.center,
      command.radius,
      command.transform,
      command.fill_color,
    ),
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
  )
  match command.stroke_color {
    Some(stroke_color) =>
      webgpu_push_color_vertices_2d(
        "line",
        pack_circle_stroke_vertices2d(
          command.center,
          command.radius,
          command.transform,
          stroke_color,
        ),
        alpha_mode_to_code(command.alpha_mode),
        blend_mode_to_code(command.blend_mode),
      )
    None => ()
  }
}

///|
pub fn draw_gradient_rect(
  command : @render2d_types.GradientRectDrawCommand2D,
) -> Unit {
  webgpu_push_color_vertices_2d(
    "triangle",
    pack_gradient_rect_vertices2d(
      command.rect,
      command.transform,
      command.color_start,
      command.color_end,
    ),
    alpha_mode_to_code(command.alpha_mode),
    blend_mode_to_code(command.blend_mode),
  )
}

///|
fn begin_3d(camera : @render3d_types.FrameCamera3D, aspect : Double) -> Unit {
  webgpu_begin_3d(
    pack_camera_view_projection3d(camera, aspect),
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
pub fn render3d_submit(frame : @render3d_types.RenderFrame3D) -> Unit {
  begin_webgpu_resource_frame()
  let stats = collect_render3d_submission_stats(frame)
  last_render3d_submission_stats.val = stats
  last_render3d_submission_stats_checksum.val = render3d_submission_stats_checksum(
    stats,
  )
  guard frame.camera is Some(active_camera) else {
    prune_stale_primitive_mesh_resources()
    prune_stale_retained_instance_buffers3d()
    return
  }
  let aspect = webgpu_canvas_aspect_ratio()
  configure_scene_lighting(frame, active_camera, aspect)
  begin_3d(active_camera, aspect)
  let lit_primitive_batches = new_lit_primitive_mesh_batch_accumulator()
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
    let texture_bundle = resolve_material_texture_bundle(material)
    match mesh_asset.primitive {
      Cube(size) =>
        match texture_bundle {
          Some(bundle) =>
            draw_triangle_mesh_instance(
              cached_cuboid_triangle_mesh3d(
                size.x,
                size.y,
                size.z,
                required_primitive_uv_set_count(bundle),
              ),
              material,
              Some(bundle),
              color,
              center,
              rotation,
              item.transform.scale,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          None => {
            let primitive_mesh = cached_cuboid_triangle_mesh3d(
              size.x,
              size.y,
              size.z,
              1,
            )
            enqueue_lit_primitive_mesh_batch(
              lit_primitive_batches,
              ensure_lit_primitive_mesh_resource(
                lit_primitive_mesh_resource_key(
                  "lit-cube",
                  [size.x, size.y, size.z],
                  color,
                  emissive_r,
                  emissive_g,
                  emissive_b,
                  alpha_mode,
                  alpha_cutoff,
                  unlit,
                ),
                primitive_mesh,
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
              item.transform.scale.x,
              item.transform.scale.y,
              item.transform.scale.z,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          }
        }
      Sphere(radius) =>
        match texture_bundle {
          Some(bundle) =>
            draw_triangle_mesh_instance(
              cached_sphere_triangle_mesh3d(
                radius,
                TEXTURED_SPHERE_SLICES,
                TEXTURED_SPHERE_STACKS,
                required_primitive_uv_set_count(bundle),
              ),
              material,
              Some(bundle),
              color,
              center,
              rotation,
              item.transform.scale,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          None => {
            let primitive_mesh = cached_sphere_triangle_mesh3d(
              radius,
              TEXTURED_SPHERE_SLICES,
              TEXTURED_SPHERE_STACKS,
              1,
            )
            enqueue_lit_primitive_mesh_batch(
              lit_primitive_batches,
              ensure_lit_primitive_mesh_resource(
                lit_primitive_mesh_resource_key(
                  "lit-sphere",
                  [radius],
                  color,
                  emissive_r,
                  emissive_g,
                  emissive_b,
                  alpha_mode,
                  alpha_cutoff,
                  unlit,
                ),
                primitive_mesh,
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
              item.transform.scale.x,
              item.transform.scale.y,
              item.transform.scale.z,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          }
        }
      Cylinder(radius_top, radius_bottom, height, slices) =>
        match texture_bundle {
          Some(bundle) =>
            draw_triangle_mesh_instance(
              cached_cylinder_triangle_mesh3d(
                radius_top,
                radius_bottom,
                height,
                slices,
                required_primitive_uv_set_count(bundle),
              ),
              material,
              Some(bundle),
              color,
              center,
              rotation,
              item.transform.scale,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          None => {
            let primitive_mesh = cached_cylinder_triangle_mesh3d(
              radius_top, radius_bottom, height, slices, 1,
            )
            enqueue_lit_primitive_mesh_batch(
              lit_primitive_batches,
              ensure_lit_primitive_mesh_resource(
                lit_primitive_mesh_resource_key(
                  "lit-cylinder",
                  [
                    radius_top,
                    radius_bottom,
                    height,
                    safe_cylinder_slices(slices).to_double(),
                  ],
                  color,
                  emissive_r,
                  emissive_g,
                  emissive_b,
                  alpha_mode,
                  alpha_cutoff,
                  unlit,
                ),
                primitive_mesh,
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
              item.transform.scale.x,
              item.transform.scale.y,
              item.transform.scale.z,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          }
        }
      Plane(size) => {
        let y = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
        match texture_bundle {
          Some(bundle) =>
            draw_triangle_mesh_instance(
              cached_cuboid_triangle_mesh3d(
                size.x,
                y,
                size.z,
                required_primitive_uv_set_count(bundle),
              ),
              material,
              Some(bundle),
              color,
              center,
              rotation,
              item.transform.scale,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          None => {
            let primitive_mesh = cached_cuboid_triangle_mesh3d(
              size.x,
              y,
              size.z,
              1,
            )
            enqueue_lit_primitive_mesh_batch(
              lit_primitive_batches,
              ensure_lit_primitive_mesh_resource(
                lit_primitive_mesh_resource_key(
                  "lit-cube",
                  [size.x, y, size.z],
                  color,
                  emissive_r,
                  emissive_g,
                  emissive_b,
                  alpha_mode,
                  alpha_cutoff,
                  unlit,
                ),
                primitive_mesh,
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
              item.transform.scale.x,
              item.transform.scale.y,
              item.transform.scale.z,
              material.double_sided,
              item.cast_shadows,
              item.receive_shadows,
            )
          }
        }
      }
      Triangles(mesh) =>
        draw_triangle_mesh_instance(
          mesh,
          material,
          texture_bundle,
          color,
          center,
          rotation,
          item.transform.scale,
          material.double_sided,
          item.cast_shadows,
          item.receive_shadows,
        )
    }
  }
  flush_lit_primitive_mesh_batches(lit_primitive_batches)
  end_3d()
  prune_stale_primitive_mesh_resources()
  prune_stale_retained_instance_buffers3d()
}

///|
fn render3d_submission_stats_checksum(stats : Render3DSubmissionStats) -> Int {
  stats.sections +
  stats.submitted_items +
  stats.skipped_items +
  stats.command_groups +
  stats.draw_commands +
  stats.lit_triangle_commands +
  stats.textured_triangle_commands +
  stats.uploaded_vertex_bytes +
  stats.render_bind_group_creations
}

///|
fn begin_webgpu_resource_frame() -> Unit {
  webgpu_resource_frame.val += 1
}

///|
fn new_lit_primitive_mesh_batch_accumulator() -> LitPrimitiveMeshBatchAccumulator {
  {
    order: [],
    resource_keys: Map([]),
    instances: Map([]),
    double_sided: Map([]),
    cast_shadows: Map([]),
    receive_shadows: Map([]),
  }
}

///|
fn enqueue_lit_primitive_mesh_batch(
  batches : LitPrimitiveMeshBatchAccumulator,
  resource_key : String,
  center_x : Double,
  center_y : Double,
  center_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  scale_x : Double,
  scale_y : Double,
  scale_z : Double,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit {
  let batch_key = lit_primitive_mesh_batch_key(
    resource_key, double_sided, cast_shadows, receive_shadows,
  )
  if !batches.instances.contains(batch_key) {
    batches.order.push(batch_key)
    batches.resource_keys.set(batch_key, resource_key)
    batches.instances.set(batch_key, [])
    batches.double_sided.set(batch_key, double_sided)
    batches.cast_shadows.set(batch_key, cast_shadows)
    batches.receive_shadows.set(batch_key, receive_shadows)
  }
  if batches.instances.get(batch_key) is Some(instances) {
    push_lit_primitive_instance_values(
      instances, center_x, center_y, center_z, rotation_x, rotation_y, rotation_z,
      rotation_w, scale_x, scale_y, scale_z, receive_shadows,
    )
  }
}

///|
fn flush_lit_primitive_mesh_batches(
  batches : LitPrimitiveMeshBatchAccumulator,
) -> Unit {
  for batch_key in batches.order {
    guard batches.resource_keys.get(batch_key) is Some(resource_key) else {
      continue
    }
    guard batches.instances.get(batch_key) is Some(instances) else { continue }
    if instances.length() == 0 {
      continue
    }
    let retained_key = mark_retained_instance_buffer_key(
      retained_lit_primitive_instance_key(batch_key, instances),
    )
    webgpu_draw_lit_primitive_mesh_batch_3d(
      resource_key,
      retained_key,
      instances,
      batches.double_sided.get(batch_key).unwrap_or(false),
      batches.cast_shadows.get(batch_key).unwrap_or(false),
    )
  }
}

///|
fn lit_primitive_mesh_batch_key(
  resource_key : String,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> String {
  resource_key +
  "|" +
  (if double_sided { "double" } else { "single" }) +
  "|" +
  (if cast_shadows { "cast" } else { "no-cast" }) +
  "|" +
  (if receive_shadows { "receive" } else { "no-receive" })
}

///|
fn push_lit_primitive_instance_values(
  instances : Array[Double],
  center_x : Double,
  center_y : Double,
  center_z : Double,
  rotation_x : Double,
  rotation_y : Double,
  rotation_z : Double,
  rotation_w : Double,
  scale_x : Double,
  scale_y : Double,
  scale_z : Double,
  receive_shadows : Bool,
) -> Unit {
  instances.push(center_x)
  instances.push(center_y)
  instances.push(center_z)
  instances.push(rotation_x)
  instances.push(rotation_y)
  instances.push(rotation_z)
  instances.push(rotation_w)
  instances.push(scale_x)
  instances.push(scale_y)
  instances.push(scale_z)
  instances.push(if receive_shadows { 1.0 } else { 0.0 })
}

///|
fn retained_lit_primitive_instance_key(
  batch_key : String,
  instances : Array[Double],
) -> String {
  let mut key = batch_key
  for value in instances {
    key = key + "|" + value.to_string()
  }
  key
}

///|
fn mark_primitive_mesh_resource_key(key : String) -> String {
  primitive_mesh_resource_last_seen.set(key, webgpu_resource_frame.val)
  key
}

///|
fn ensure_lit_primitive_mesh_resource(
  key : String,
  mesh : @render3d_types.TriangleMesh3D,
  material : @render3d_types.StandardMaterial3D,
  color : @render.Color,
  receive_shadows : Bool,
) -> String {
  let marked_key = mark_primitive_mesh_resource_key(key)
  if !uploaded_primitive_mesh_resources.contains(marked_key) {
    let vertices = flatten_colored_vertices3d(
      mesh.positions,
      resolve_triangle_indices(mesh).unwrap_or([]),
      resolve_mesh_normals(mesh),
      mesh.colors,
      @smath.Vec3::one(),
      material,
      color,
      receive_shadows,
    )
    webgpu_upload_lit_primitive_mesh_resource(marked_key, vertices)
    uploaded_primitive_mesh_resources.set(marked_key, true)
  }
  marked_key
}

///|
fn prune_stale_primitive_mesh_resources() -> Unit {
  let min_live_frame = webgpu_resource_frame.val -
    WEBGPU_PRIMITIVE_MESH_RESOURCE_TTL_FRAMES
  for pair in primitive_mesh_resource_last_seen.to_array() {
    if pair.1 < min_live_frame {
      ignore(primitive_mesh_resource_last_seen.remove(pair.0))
      ignore(uploaded_primitive_mesh_resources.remove(pair.0))
      webgpu_release_primitive_mesh_resource(pair.0)
    }
  }
}

///|
fn mark_retained_instance_buffer_key(key : String) -> String {
  retained_render3d_instance_last_seen.set(key, webgpu_resource_frame.val)
  key
}

///|
fn prune_stale_retained_instance_buffers3d() -> Unit {
  let min_live_frame = webgpu_resource_frame.val -
    WEBGPU_PRIMITIVE_MESH_RESOURCE_TTL_FRAMES
  for pair in retained_render3d_instance_last_seen.to_array() {
    if pair.1 < min_live_frame {
      ignore(retained_render3d_instance_last_seen.remove(pair.0))
      webgpu_release_retained_instance_buffer_3d(pair.0)
    }
  }
}

///|
fn lit_primitive_mesh_resource_key(
  prefix : String,
  dimensions : Array[Double],
  color : @render.Color,
  emissive_r : Double,
  emissive_g : Double,
  emissive_b : Double,
  alpha_mode : Double,
  alpha_cutoff : Double,
  unlit : Bool,
) -> String {
  let mut key = prefix
  for dimension in dimensions {
    key = key + "|" + webgpu_resource_float_key(dimension)
  }
  key +
  "|" +
  webgpu_resource_color_key(color) +
  "|" +
  webgpu_resource_float_key(emissive_r) +
  "," +
  webgpu_resource_float_key(emissive_g) +
  "," +
  webgpu_resource_float_key(emissive_b) +
  "|" +
  webgpu_resource_float_key(alpha_mode) +
  "|" +
  webgpu_resource_float_key(alpha_cutoff) +
  "|" +
  (if unlit { "1" } else { "0" })
}

///|
fn webgpu_resource_color_key(color : @render.Color) -> String {
  color.r.to_string() +
  "," +
  color.g.to_string() +
  "," +
  color.b.to_string() +
  "," +
  webgpu_resource_float_key(color.a)
}

///|
fn webgpu_resource_float_key(value : Double) -> String {
  value.to_string()
}

///|
fn safe_cylinder_slices(slices : Int) -> Int {
  if slices < 3 {
    3
  } else {
    slices
  }
}

///|
fn collect_render3d_submission_stats(
  frame : @render3d_types.RenderFrame3D,
) -> Render3DSubmissionStats {
  let stats = empty_render3d_submission_stats()
  let instanced_lit_buckets : Map[String, Bool] = Map([])
  let instanced_lit_signatures : Map[String, String] = Map([])
  let instanced_lit_counts : Map[String, Int] = Map([])
  guard frame.camera is Some(_) else { return stats }
  stats.sections = 1
  for item in frame.items {
    guard synced_mesh_assets.get(item.mesh) is Some(mesh_asset) else {
      stats.skipped_items += 1
      continue
    }
    let material = synced_material_assets
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    let texture_bundle = resolve_material_texture_bundle(material)
    let vertex_count = render3d_item_vertex_count(mesh_asset.primitive)
    if vertex_count <= 0 {
      stats.skipped_items += 1
      continue
    }
    stats.submitted_items += 1
    let textured = texture_bundle is Some(_) &&
      render3d_item_can_use_textured_path(mesh_asset.primitive, texture_bundle)
    if textured {
      stats.textured_triangle_commands += 1
      stats.uploaded_vertex_bytes += vertex_count * 35 * 4
    } else if render3d_item_can_use_instanced_lit_path(mesh_asset.primitive) {
      let key = render3d_lit_instance_bucket_key(item)
      if !instanced_lit_buckets.contains(key) {
        instanced_lit_buckets.set(key, true)
        stats.lit_triangle_commands += 1
      }
      instanced_lit_counts.set(
        key,
        instanced_lit_counts.get(key).unwrap_or(0) + 1,
      )
      let signature = instanced_lit_signatures
        .get(key)
        .map_or(key, fn(previous) { previous }) +
        "|" +
        render3d_primitive_signature(mesh_asset.primitive) +
        "|" +
        render3d_item_instance_signature(item)
      instanced_lit_signatures.set(key, signature)
    } else {
      stats.lit_triangle_commands += 1
      stats.uploaded_vertex_bytes += vertex_count * 17 * 4
    }
  }
  for key, signature in instanced_lit_signatures {
    if !retained_render3d_instance_last_seen.contains(signature) {
      stats.uploaded_vertex_bytes += instanced_lit_counts.get(key).unwrap_or(0) *
        11 *
        4
    }
    ignore(mark_retained_instance_buffer_key(signature))
  }
  if stats.lit_triangle_commands > 0 {
    stats.command_groups += 1
    stats.render_bind_group_creations += 1
  }
  if stats.textured_triangle_commands > 0 {
    stats.command_groups += 1
    stats.render_bind_group_creations += stats.textured_triangle_commands
  }
  stats.draw_commands = stats.lit_triangle_commands +
    stats.textured_triangle_commands
  stats
}

///|
fn render3d_item_can_use_instanced_lit_path(
  primitive : @render3d_types.MeshPrimitive3D,
) -> Bool {
  match primitive {
    Cube(_) | Sphere(_) | Cylinder(_, _, _, _) | Plane(_) => true
    Triangles(_) => false
  }
}

///|
fn render3d_lit_instance_bucket_key(
  item : @render3d_types.RenderItem3D,
) -> String {
  item.mesh.0.to_string() +
  "|" +
  item.material.0.to_string() +
  "|" +
  (if item.cast_shadows { "cast" } else { "no-cast" }) +
  "|" +
  (if item.receive_shadows { "receive" } else { "no-receive" })
}

///|
fn render3d_item_instance_signature(
  item : @render3d_types.RenderItem3D,
) -> String {
  let transform = item.transform
  let translation = transform.translation
  let rotation = transform.rotation
  let scale = transform.scale
  translation.x.to_string() +
  "," +
  translation.y.to_string() +
  "," +
  translation.z.to_string() +
  "," +
  rotation.x.to_string() +
  "," +
  rotation.y.to_string() +
  "," +
  rotation.z.to_string() +
  "," +
  rotation.w.to_string() +
  "," +
  scale.x.to_string() +
  "," +
  scale.y.to_string() +
  "," +
  scale.z.to_string()
}

///|
fn render3d_primitive_signature(
  primitive : @render3d_types.MeshPrimitive3D,
) -> String {
  match primitive {
    Cube(size) =>
      "cube:" +
      size.x.to_string() +
      "," +
      size.y.to_string() +
      "," +
      size.z.to_string()
    Sphere(radius) => "sphere:" + radius.to_string()
    Cylinder(radius_top, radius_bottom, height, slices) =>
      "cylinder:" +
      radius_top.to_string() +
      "," +
      radius_bottom.to_string() +
      "," +
      height.to_string() +
      "," +
      slices.to_string()
    Plane(size) =>
      "plane:" +
      size.x.to_string() +
      "," +
      size.y.to_string() +
      "," +
      size.z.to_string()
    Triangles(_) => "triangles"
  }
}

///|
fn render3d_item_can_use_textured_path(
  primitive : @render3d_types.MeshPrimitive3D,
  texture_bundle : MaterialTextureBundle3D?,
) -> Bool {
  guard texture_bundle is Some(bundle) else { return false }
  match primitive {
    Cube(_) | Sphere(_) | Cylinder(_, _, _, _) | Plane(_) => true
    Triangles(mesh) => textured_triangle_mesh_vertex_count(mesh, bundle) > 0
  }
}

///|
fn render3d_item_vertex_count(
  primitive : @render3d_types.MeshPrimitive3D,
) -> Int {
  match primitive {
    Cube(_) => cuboid_triangle_vertex_count()
    Sphere(_) =>
      sphere_triangle_vertex_count(
        TEXTURED_SPHERE_SLICES,
        TEXTURED_SPHERE_STACKS,
      )
    Cylinder(radius_top, radius_bottom, _, slices) =>
      cylinder_triangle_vertex_count(radius_top, radius_bottom, slices)
    Plane(_) => cuboid_triangle_vertex_count()
    Triangles(mesh) =>
      resolve_triangle_indices(mesh).map_or(0, fn(indices) { indices.length() })
  }
}

///|
fn cuboid_triangle_vertex_count() -> Int {
  36
}

///|
fn sphere_triangle_vertex_count(slices : Int, stacks : Int) -> Int {
  let safe_slices = if slices < 3 { 3 } else { slices }
  let safe_stacks = if stacks < 2 { 2 } else { stacks }
  safe_slices * (safe_stacks - 1) * 6
}

///|
fn cylinder_triangle_vertex_count(
  radius_top : Double,
  radius_bottom : Double,
  slices : Int,
) -> Int {
  let safe_slices = if slices < 3 { 3 } else { slices }
  let cap_vertices = (if radius_top.abs() > 0.000001 { 3 } else { 0 }) +
    (if radius_bottom.abs() > 0.000001 { 3 } else { 0 })
  safe_slices * (6 + cap_vertices)
}

///|
fn textured_triangle_mesh_vertex_count(
  mesh : @render3d_types.TriangleMesh3D,
  bundle : MaterialTextureBundle3D,
) -> Int {
  guard resolve_triangle_indices(mesh) is Some(triangle_indices) else {
    return 0
  }
  let normals = resolve_mesh_normals(mesh)
  match mesh.uv_sets.get(bundle.primary_texcoord_set) {
    Some(primary_uvs) if primary_uvs.length() == mesh.positions.length() &&
      normals.length() == mesh.positions.length() => triangle_indices.length()
    _ => 0
  }
}

///|
fn draw_triangle_mesh_instance(
  mesh : @render3d_types.TriangleMesh3D,
  material : @render3d_types.StandardMaterial3D,
  texture_bundle : MaterialTextureBundle3D?,
  color : @render.Color,
  translation : @smath.Vec3,
  rotation : @smath.Quat,
  scale : @smath.Vec3,
  double_sided : Bool,
  cast_shadows : Bool,
  receive_shadows : Bool,
) -> Unit {
  if resolve_triangle_indices(mesh) is Some(triangle_indices) &&
    triangle_indices.length() >= 3 {
    let normals = resolve_mesh_normals(mesh)
    let tangents = resolve_mesh_tangents(mesh)
    let transformed_positions = transform_positions3d(
      mesh.positions,
      translation,
      rotation,
      scale,
    )
    let transformed_normals = rotate_normals3d(normals, rotation, scale)
    let draw_colored = fn() {
      webgpu_draw_colored_triangles_3d(
        flatten_colored_vertices3d(
          transformed_positions,
          triangle_indices,
          transformed_normals,
          mesh.colors,
          @smath.Vec3::one(),
          material,
          color,
          receive_shadows,
        ),
        double_sided,
        cast_shadows,
      )
    }
    match texture_bundle {
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
                  transformed_positions,
                  triangle_indices,
                  base_input.uvs,
                  emissive_input.uvs,
                  metallic_roughness_input.uvs,
                  occlusion_input.uvs,
                  normal_input.uvs,
                  transformed_normals,
                  rotate_tangents3d(tangents, rotation, scale),
                  mesh.colors,
                  @smath.Vec3::one(),
                  material,
                  color,
                  receive_shadows,
                ),
                double_sided,
                cast_shadows,
              )
            } else {
              draw_colored()
            }
          None => draw_colored()
        }
      None => draw_colored()
    }
  }
}

///|
fn cached_textured_primitive_mesh3d(
  key : String,
  build : () -> @render3d_types.TriangleMesh3D,
) -> @render3d_types.TriangleMesh3D {
  textured_primitive_mesh_cache.get_or_init(key, build)
}

///|
fn textured_primitive_cache_key(
  prefix : String,
  values : Array[String],
) -> String {
  let mut key = prefix
  for value in values {
    key = key + "|" + value
  }
  key
}

///|
fn cached_cuboid_triangle_mesh3d(
  size_x : Double,
  size_y : Double,
  size_z : Double,
  uv_set_count : Int,
) -> @render3d_types.TriangleMesh3D {
  cached_textured_primitive_mesh3d(
    textured_primitive_cache_key("cuboid", [
      size_x.to_string(),
      size_y.to_string(),
      size_z.to_string(),
      uv_set_count.to_string(),
    ]),
    fn() { build_cuboid_triangle_mesh3d(size_x, size_y, size_z, uv_set_count~) },
  )
}

///|
fn cached_sphere_triangle_mesh3d(
  radius : Double,
  slices : Int,
  stacks : Int,
  uv_set_count : Int,
) -> @render3d_types.TriangleMesh3D {
  cached_textured_primitive_mesh3d(
    textured_primitive_cache_key("sphere", [
      radius.to_string(),
      slices.to_string(),
      stacks.to_string(),
      uv_set_count.to_string(),
    ]),
    fn() { build_sphere_triangle_mesh3d(radius, slices, stacks, uv_set_count~) },
  )
}

///|
fn cached_cylinder_triangle_mesh3d(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  uv_set_count : Int,
) -> @render3d_types.TriangleMesh3D {
  cached_textured_primitive_mesh3d(
    textured_primitive_cache_key("cylinder", [
      radius_top.to_string(),
      radius_bottom.to_string(),
      height.to_string(),
      slices.to_string(),
      uv_set_count.to_string(),
    ]),
    fn() {
      build_cylinder_triangle_mesh3d(
        radius_top,
        radius_bottom,
        height,
        slices,
        uv_set_count~,
      )
    },
  )
}

///|
fn build_cuboid_triangle_mesh3d(
  size_x : Double,
  size_y : Double,
  size_z : Double,
  uv_set_count? : Int = 1,
) -> @render3d_types.TriangleMesh3D {
  let positions : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2] = []
  let normals : Array[@smath.Vec3] = []
  let half_x = size_x / 2.0
  let half_y = size_y / 2.0
  let half_z = size_z / 2.0
  let p000 = @smath.Vec3(-half_x, -half_y, -half_z)
  let p001 = @smath.Vec3(-half_x, -half_y, half_z)
  let p010 = @smath.Vec3(-half_x, half_y, -half_z)
  let p011 = @smath.Vec3(-half_x, half_y, half_z)
  let p100 = @smath.Vec3(half_x, -half_y, -half_z)
  let p101 = @smath.Vec3(half_x, -half_y, half_z)
  let p110 = @smath.Vec3(half_x, half_y, -half_z)
  let p111 = @smath.Vec3(half_x, half_y, half_z)
  let uv00 = @smath.Vec2(0.0, 0.0)
  let uv10 = @smath.Vec2(1.0, 0.0)
  let uv01 = @smath.Vec2(0.0, 1.0)
  let uv11 = @smath.Vec2(1.0, 1.0)
  let normal_front = @smath.Vec3(0.0, 0.0, 1.0)
  push_textured_triangle3d(
    positions, uvs, normals, p001, p101, p111, uv01, uv11, uv10, normal_front, normal_front,
    normal_front,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p001, p111, p011, uv01, uv10, uv00, normal_front, normal_front,
    normal_front,
  )
  let normal_back = @smath.Vec3(0.0, 0.0, -1.0)
  push_textured_triangle3d(
    positions, uvs, normals, p100, p000, p010, uv01, uv11, uv10, normal_back, normal_back,
    normal_back,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p100, p010, p110, uv01, uv10, uv00, normal_back, normal_back,
    normal_back,
  )
  let normal_right = @smath.Vec3(1.0, 0.0, 0.0)
  push_textured_triangle3d(
    positions, uvs, normals, p101, p100, p110, uv01, uv11, uv10, normal_right, normal_right,
    normal_right,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p101, p110, p111, uv01, uv10, uv00, normal_right, normal_right,
    normal_right,
  )
  let normal_left = @smath.Vec3(-1.0, 0.0, 0.0)
  push_textured_triangle3d(
    positions, uvs, normals, p000, p001, p011, uv01, uv11, uv10, normal_left, normal_left,
    normal_left,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p000, p011, p010, uv01, uv10, uv00, normal_left, normal_left,
    normal_left,
  )
  let normal_top = @smath.Vec3(0.0, 1.0, 0.0)
  push_textured_triangle3d(
    positions, uvs, normals, p011, p111, p110, uv01, uv11, uv10, normal_top, normal_top,
    normal_top,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p011, p110, p010, uv01, uv10, uv00, normal_top, normal_top,
    normal_top,
  )
  let normal_bottom = @smath.Vec3(0.0, -1.0, 0.0)
  push_textured_triangle3d(
    positions, uvs, normals, p000, p100, p101, uv01, uv11, uv10, normal_bottom, normal_bottom,
    normal_bottom,
  )
  push_textured_triangle3d(
    positions, uvs, normals, p000, p101, p001, uv01, uv10, uv00, normal_bottom, normal_bottom,
    normal_bottom,
  )
  build_textured_triangle_mesh3d(positions, uvs, normals, uv_set_count~)
}

///|
fn build_sphere_triangle_mesh3d(
  radius : Double,
  slices : Int,
  stacks : Int,
  uv_set_count? : Int = 1,
) -> @render3d_types.TriangleMesh3D {
  let positions : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2] = []
  let normals : Array[@smath.Vec3] = []
  let safe_slices = if slices < 3 { 3 } else { slices }
  let safe_stacks = if stacks < 2 { 2 } else { stacks }
  for stack in 0..<safe_stacks {
    let v0 = stack.to_double() / safe_stacks.to_double()
    let v1 = (stack + 1).to_double() / safe_stacks.to_double()
    let theta0 = v0 * @math.PI
    let theta1 = v1 * @math.PI
    let y0 = radius * @math.cos(theta0)
    let y1 = radius * @math.cos(theta1)
    let ring0 = radius * @math.sin(theta0)
    let ring1 = radius * @math.sin(theta1)
    for segment in 0..<safe_slices {
      let u0 = segment.to_double() / safe_slices.to_double()
      let u1 = (segment + 1).to_double() / safe_slices.to_double()
      let phi0 = u0 * 2.0 * @math.PI
      let phi1 = u1 * 2.0 * @math.PI
      let p00 = @smath.Vec3(
        ring0 * @math.cos(phi0),
        y0,
        ring0 * @math.sin(phi0),
      )
      let p01 = @smath.Vec3(
        ring0 * @math.cos(phi1),
        y0,
        ring0 * @math.sin(phi1),
      )
      let p10 = @smath.Vec3(
        ring1 * @math.cos(phi0),
        y1,
        ring1 * @math.sin(phi0),
      )
      let p11 = @smath.Vec3(
        ring1 * @math.cos(phi1),
        y1,
        ring1 * @math.sin(phi1),
      )
      let uv00 = @smath.Vec2(u0, v0)
      let uv01 = @smath.Vec2(u1, v0)
      let uv10 = @smath.Vec2(u0, v1)
      let uv11 = @smath.Vec2(u1, v1)
      let n00 = sphere_vertex_normal(p00)
      let n01 = sphere_vertex_normal(p01)
      let n10 = sphere_vertex_normal(p10)
      let n11 = sphere_vertex_normal(p11)
      if stack == 0 {
        push_textured_triangle3d(
          positions, uvs, normals, p00, p11, p10, uv00, uv11, uv10, n00, n11, n10,
        )
      } else if stack == safe_stacks - 1 {
        push_textured_triangle3d(
          positions, uvs, normals, p00, p01, p10, uv00, uv01, uv10, n00, n01, n10,
        )
      } else {
        push_textured_triangle3d(
          positions, uvs, normals, p00, p11, p10, uv00, uv11, uv10, n00, n11, n10,
        )
        push_textured_triangle3d(
          positions, uvs, normals, p00, p01, p11, uv00, uv01, uv11, n00, n01, n11,
        )
      }
    }
  }
  build_textured_triangle_mesh3d(positions, uvs, normals, uv_set_count~)
}

///|
fn build_cylinder_triangle_mesh3d(
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  uv_set_count? : Int = 1,
) -> @render3d_types.TriangleMesh3D {
  let positions : Array[@smath.Vec3] = []
  let uvs : Array[@smath.Vec2] = []
  let normals : Array[@smath.Vec3] = []
  let safe_slices = if slices < 3 { 3 } else { slices }
  let half_height = height / 2.0
  let slope_y = if height.abs() < 0.000001 {
    0.0
  } else {
    (radius_bottom - radius_top) / height
  }
  for segment in 0..<safe_slices {
    let u0 = segment.to_double() / safe_slices.to_double()
    let u1 = (segment + 1).to_double() / safe_slices.to_double()
    let phi0 = u0 * 2.0 * @math.PI
    let phi1 = u1 * 2.0 * @math.PI
    let top0 = @smath.Vec3(
      radius_top * @math.cos(phi0),
      half_height,
      radius_top * @math.sin(phi0),
    )
    let top1 = @smath.Vec3(
      radius_top * @math.cos(phi1),
      half_height,
      radius_top * @math.sin(phi1),
    )
    let bottom0 = @smath.Vec3(
      radius_bottom * @math.cos(phi0),
      -half_height,
      radius_bottom * @math.sin(phi0),
    )
    let bottom1 = @smath.Vec3(
      radius_bottom * @math.cos(phi1),
      -half_height,
      radius_bottom * @math.sin(phi1),
    )
    let side_normal0 = @smath.Vec3(@math.cos(phi0), slope_y, @math.sin(phi0)).normalize()
    let side_normal1 = @smath.Vec3(@math.cos(phi1), slope_y, @math.sin(phi1)).normalize()
    push_textured_triangle3d(
      positions,
      uvs,
      normals,
      top0,
      bottom1,
      bottom0,
      @smath.Vec2(u0, 0.0),
      @smath.Vec2(u1, 1.0),
      @smath.Vec2(u0, 1.0),
      side_normal0,
      side_normal1,
      side_normal0,
    )
    push_textured_triangle3d(
      positions,
      uvs,
      normals,
      top0,
      top1,
      bottom1,
      @smath.Vec2(u0, 0.0),
      @smath.Vec2(u1, 0.0),
      @smath.Vec2(u1, 1.0),
      side_normal0,
      side_normal1,
      side_normal1,
    )
    if radius_top.abs() > 0.000001 {
      let top_center = @smath.Vec3(0.0, half_height, 0.0)
      let top_normal = @smath.Vec3(0.0, 1.0, 0.0)
      push_textured_triangle3d(
        positions,
        uvs,
        normals,
        top_center,
        top1,
        top0,
        @smath.Vec2(0.5, 0.5),
        @smath.Vec2(0.5 + 0.5 * @math.cos(phi1), 0.5 + 0.5 * @math.sin(phi1)),
        @smath.Vec2(0.5 + 0.5 * @math.cos(phi0), 0.5 + 0.5 * @math.sin(phi0)),
        top_normal,
        top_normal,
        top_normal,
      )
    }
    if radius_bottom.abs() > 0.000001 {
      let bottom_center = @smath.Vec3(0.0, -half_height, 0.0)
      let bottom_normal = @smath.Vec3(0.0, -1.0, 0.0)
      push_textured_triangle3d(
        positions,
        uvs,
        normals,
        bottom_center,
        bottom0,
        bottom1,
        @smath.Vec2(0.5, 0.5),
        @smath.Vec2(0.5 + 0.5 * @math.cos(phi0), 0.5 + 0.5 * @math.sin(phi0)),
        @smath.Vec2(0.5 + 0.5 * @math.cos(phi1), 0.5 + 0.5 * @math.sin(phi1)),
        bottom_normal,
        bottom_normal,
        bottom_normal,
      )
    }
  }
  build_textured_triangle_mesh3d(positions, uvs, normals, uv_set_count~)
}

///|
fn build_textured_triangle_mesh3d(
  positions : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2],
  normals : Array[@smath.Vec3],
  uv_set_count? : Int = 1,
) -> @render3d_types.TriangleMesh3D {
  let safe_uv_set_count = if uv_set_count < 1 { 1 } else { uv_set_count }
  let uv_sets : Array[Array[@smath.Vec2]] = []
  for _ in 0..<safe_uv_set_count {
    uv_sets.push(uvs.copy())
  }
  {
    positions,
    indices: None,
    topology: TriangleList,
    uv_sets,
    normals: Some(normals),
    tangents: None,
    colors: None,
  }
}

///|
fn transform_positions3d(
  positions : Array[@smath.Vec3],
  translation : @smath.Vec3,
  rotation : @smath.Quat,
  scale : @smath.Vec3,
) -> Array[@smath.Vec3] {
  let transformed : Array[@smath.Vec3] = []
  for position in positions {
    transformed.push(
      translation +
      rotation.rotate_vec3(
        @smath.Vec3(
          position.x * scale.x,
          position.y * scale.y,
          position.z * scale.z,
        ),
      ),
    )
  }
  transformed
}

///|
fn rotate_normals3d(
  normals : Array[@smath.Vec3],
  rotation : @smath.Quat,
  scale : @smath.Vec3,
) -> Array[@smath.Vec3] {
  let transformed : Array[@smath.Vec3] = []
  for normal in normals {
    let rotated = rotation
      .rotate_vec3(inverse_scale_direction3d(normal, scale))
      .normalize()
    transformed.push(
      if rotated.length_squared() <= 0.00000001 {
        @smath.Vec3(0.0, 1.0, 0.0)
      } else {
        rotated
      },
    )
  }
  transformed
}

///|
fn rotate_tangents3d(
  tangents : Array[@render3d_types.Tangent3D],
  rotation : @smath.Quat,
  scale : @smath.Vec3,
) -> Array[@render3d_types.Tangent3D] {
  let transformed : Array[@render3d_types.Tangent3D] = []
  for tangent in tangents {
    let rotated = rotation
      .rotate_vec3(
        inverse_scale_direction3d(
          @smath.Vec3(tangent.x, tangent.y, tangent.z),
          scale,
        ),
      )
      .normalize()
    let safe = if rotated.length_squared() <= 0.00000001 {
      @smath.Vec3(1.0, 0.0, 0.0)
    } else {
      rotated
    }
    transformed.push({ x: safe.x, y: safe.y, z: safe.z, w: tangent.w })
  }
  transformed
}

///|
fn inverse_scale_direction3d(
  direction : @smath.Vec3,
  scale : @smath.Vec3,
) -> @smath.Vec3 {
  @smath.Vec3(
    if scale.x.abs() > 0.00000001 {
      direction.x / scale.x
    } else {
      direction.x
    },
    if scale.y.abs() > 0.00000001 {
      direction.y / scale.y
    } else {
      direction.y
    },
    if scale.z.abs() > 0.00000001 {
      direction.z / scale.z
    } else {
      direction.z
    },
  )
}

///|
fn required_primitive_uv_set_count(bundle : MaterialTextureBundle3D) -> Int {
  let mut max_set = bundle.primary_texcoord_set
  let track = fn(source : MaterialTextureSource3D?) {
    match source {
      Some(source) =>
        if source.texcoord_set > max_set {
          max_set = source.texcoord_set
        }
      None => ()
    }
  }
  track(bundle.base_source)
  track(bundle.emissive_source)
  track(bundle.metallic_roughness_source)
  track(bundle.occlusion_source)
  track(bundle.normal_source)
  if max_set < 0 {
    1
  } else {
    max_set + 1
  }
}

///|
fn sphere_vertex_normal(position : @smath.Vec3) -> @smath.Vec3 {
  if position.length_squared() <= 0.0000001 {
    @smath.Vec3(0.0, 1.0, 0.0)
  } else {
    position.normalize()
  }
}

///|
fn push_textured_triangle3d(
  positions : Array[@smath.Vec3],
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
  positions.push(a)
  positions.push(b)
  positions.push(c)
  uvs.push(uv_a)
  uvs.push(uv_b)
  uvs.push(uv_c)
  normals.push(n_a)
  normals.push(n_b)
  normals.push(n_c)
}

///|
fn configure_scene_lighting(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
  aspect : Double,
) -> Unit {
  let has_lighting = frame.ambient_light is Some(_) ||
    frame.directional_lights.length() > 0 ||
    frame.point_lights.length() > 0 ||
    frame.spot_lights.length() > 0
  let ambient = if has_lighting {
    frame.ambient_light.map_or(@smath.Vec3::zero(), fn(light) {
      let (r, g, b) = color_rgb01(light.color)
      @smath.Vec3(r, g, b).scalar_mul(light.intensity)
    })
  } else {
    @smath.Vec3::one()
  }
  let mode = current_render3d_lighting_mode.val
  let directional_data = pack_directional_light_data(frame, mode~)
  let point_data = pack_point_light_data(frame, mode~)
  let spot_data = pack_spot_light_data(frame, mode~)
  let light_uniform = pack_light_uniform_data(frame, camera, ambient, mode~)
  webgpu_set_lighting_3d(
    directional_data,
    point_data,
    spot_data,
    light_uniform,
    ambient.x,
    ambient.y,
    ambient.z,
    frame.directional_shadow_map_size.to_double(),
    frame.point_shadow_map_size.to_double(),
  )
  webgpu_set_shadow_view_projection_3d(
    pack_directional_shadow_cascade_data(frame, aspect, mode~),
    pack_spot_shadow_view_projection_data(frame, mode~),
    pack_point_shadow_view_projection_data(frame, mode~),
  )
}

///|
fn pack_directional_light_data(
  frame : @render3d_types.RenderFrame3D,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let directional_data : Array[Double] = []
  let max_lights = max_directional_lights_for_mode(mode)
  let directional_count = if frame.directional_lights.length() < max_lights {
    frame.directional_lights.length()
  } else {
    max_lights
  }
  for idx in 0..<directional_count {
    let light = frame.directional_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, -1.0, 0.0)
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
fn max_directional_lights_for_mode(mode : Render3DLightingMode) -> Int {
  match mode {
    Full => MAX_DIRECTIONAL_LIGHTS
    Cheap => 1
    Unlit => 0
  }
}

///|
fn max_point_lights_for_mode(mode : Render3DLightingMode) -> Int {
  match mode {
    Full => MAX_POINT_LIGHTS
    Cheap | Unlit => 0
  }
}

///|
fn max_spot_lights_for_mode(mode : Render3DLightingMode) -> Int {
  match mode {
    Full => MAX_SPOT_LIGHTS
    Cheap | Unlit => 0
  }
}

///|
fn pack_light_uniform_data(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
  ambient : @smath.Vec3,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let values : Array[Double] = []
  for _ in 0..<176 {
    values.push(0.0)
  }
  let directional_count = min_int(
    frame.directional_lights.length(),
    max_directional_lights_for_mode(mode),
  )
  let point_count = min_int(
    frame.point_lights.length(),
    max_point_lights_for_mode(mode),
  )
  let spot_count = min_int(
    frame.spot_lights.length(),
    max_spot_lights_for_mode(mode),
  )
  values[0] = clamp01_double(ambient.x)
  values[1] = clamp01_double(ambient.y)
  values[2] = clamp01_double(ambient.z)
  values[3] = directional_count.to_double()
  values[4] = point_count.to_double()
  values[5] = spot_count.to_double()
  values[8] = camera.position.x
  values[9] = camera.position.y
  values[10] = camera.position.z
  let forward = camera_forward3d(camera)
  values[12] = forward.x
  values[13] = forward.y
  values[14] = forward.z
  for idx in 0..<directional_count {
    let light = frame.directional_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, -1.0, 0.0)
    } else {
      light.direction.normalize()
    }
    let (r, g, b) = color_rgb01(light.color)
    let base = 16 + idx * 8
    values[base] = direction.x
    values[base + 1] = direction.y
    values[base + 2] = direction.z
    values[base + 3] = if light.intensity < 0.0 { 0.0 } else { light.intensity }
    values[base + 4] = clamp01_double(r)
    values[base + 5] = clamp01_double(g)
    values[base + 6] = clamp01_double(b)
  }
  for idx in 0..<point_count {
    let light = frame.point_lights[idx]
    let (r, g, b) = color_rgb01(light.color)
    let base = 48 + idx * 8
    values[base] = light.position.x
    values[base + 1] = light.position.y
    values[base + 2] = light.position.z
    values[base + 3] = if light.intensity < 0.0 { 0.0 } else { light.intensity }
    values[base + 4] = clamp01_double(r)
    values[base + 5] = clamp01_double(g)
    values[base + 6] = clamp01_double(b)
    values[base + 7] = if light.range < 0.0001 { 0.0001 } else { light.range }
  }
  for idx in 0..<spot_count {
    let light = frame.spot_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, -1.0, 0.0)
    } else {
      light.direction.normalize()
    }
    let (r, g, b) = color_rgb01(light.color)
    let (inner_angle, outer_angle) = if light.inner_angle <= light.outer_angle {
      (light.inner_angle, light.outer_angle)
    } else {
      (light.outer_angle, light.inner_angle)
    }
    let base = 112 + idx * 16
    values[base] = light.position.x
    values[base + 1] = light.position.y
    values[base + 2] = light.position.z
    values[base + 3] = if light.intensity < 0.0 { 0.0 } else { light.intensity }
    values[base + 4] = clamp01_double(r)
    values[base + 5] = clamp01_double(g)
    values[base + 6] = clamp01_double(b)
    values[base + 7] = if light.range < 0.0001 { 0.0001 } else { light.range }
    values[base + 8] = direction.x
    values[base + 9] = direction.y
    values[base + 10] = direction.z
    values[base + 11] = @math.cos(inner_angle)
    values[base + 12] = @math.cos(outer_angle)
  }
  values
}

///|
fn camera_forward3d(camera : @render3d_types.FrameCamera3D) -> @smath.Vec3 {
  let forward = camera.target - camera.position
  if forward.length_squared() <= 0.0000001 {
    @smath.Vec3(0.0, 0.0, -1.0)
  } else {
    forward.normalize()
  }
}

///|
fn clamp01_double(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn min_int(lhs : Int, rhs : Int) -> Int {
  if lhs < rhs {
    lhs
  } else {
    rhs
  }
}

///|
fn pack_point_light_data(
  frame : @render3d_types.RenderFrame3D,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let point_data : Array[Double] = []
  let max_lights = max_point_lights_for_mode(mode)
  let point_count = if frame.point_lights.length() < max_lights {
    frame.point_lights.length()
  } else {
    max_lights
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
fn pack_spot_light_data(
  frame : @render3d_types.RenderFrame3D,
  mode? : Render3DLightingMode = Full,
) -> Array[Double] {
  let spot_data : Array[Double] = []
  let max_lights = max_spot_lights_for_mode(mode)
  let spot_count = if frame.spot_lights.length() < max_lights {
    frame.spot_lights.length()
  } else {
    max_lights
  }
  for idx in 0..<spot_count {
    let light = frame.spot_lights[idx]
    let direction = if light.direction.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, -1.0, 0.0)
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
      normal = @smath.Vec3(0.0, 1.0, 0.0)
    }
    normals[ia] = normals[ia] + normal
    normals[ib] = normals[ib] + normal
    normals[ic] = normals[ic] + normal
  }
  for index in 0..<normals.length() {
    let normal = normals[index]
    normals[index] = if normal.length_squared() <= 0.0000001 {
      @smath.Vec3(0.0, 1.0, 0.0)
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
