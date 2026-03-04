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
pub fn preload_img(path : String) -> Unit {
  webgpu_preload_img(resolve_asset_path(path))
}

///|
pub fn draw_image(command : @render.ImageDrawCommand) -> Unit {
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
  webgpu_draw_image(
    resolve_asset_path(command.path),
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
    repeat_mode_to_code(command.repeat),
  )
}

///|
pub fn draw_text(command : @render.TextDrawCommand) -> Unit {
  if draw_text_with_cosmic(command) {
    return
  }
  let (r, g, b, a) = color_rgba(command.style.color)
  webgpu_draw_text(
    command.text,
    command.position[X],
    command.position[Y],
    command.style.family,
    command.style.size,
    h_align_to_code(command.style.align),
    v_align_to_code(command.style.baseline),
    r,
    g,
    b,
    a,
  )
}

///|
pub fn measure_text(style : @render.TextStyle, text : String) -> @smath.Vec2D {
  let measured = webgpu_measure_text(text, style.family, style.size)
  if measured.length() >= 2 {
    @smath.Vec2D(measured[0], measured[1])
  } else {
    let width = text.length().to_double() * style.size * 0.6
    let height = if style.size <= 0.0 { 1.0 } else { style.size }
    @smath.Vec2D(width, height)
  }
}

///|
pub fn draw_rect(command : @render.RectDrawCommand) -> Unit {
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
pub fn draw_circle(command : @render.CircleDrawCommand) -> Unit {
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
pub fn draw_gradient_rect(command : @render.GradientRectDrawCommand) -> Unit {
  let (sr, sg, sb, sa) = color_rgba(command.color_start)
  let (er, eg, eb, ea) = color_rgba(command.color_end)
  webgpu_draw_gradient_rect(
    command.rect.position[X],
    command.rect.position[Y],
    command.rect.size[X],
    command.rect.size[Y],
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
pub fn begin_3d(camera : @render.Camera3D) -> Unit {
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
    camera.fovy,
  )
}

///|
pub fn end_3d() -> Unit {
  webgpu_end_3d()
}

///|
pub fn draw_cube_3d(command : @render.CubeDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cube_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.size.x,
    command.size.y,
    command.size.z,
    0.0,
    0.0,
    0.0,
    1.0,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_cube_wires_3d(command : @render.CubeDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cube_wires_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.size.x,
    command.size.y,
    command.size.z,
    0.0,
    0.0,
    0.0,
    1.0,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_sphere_3d(command : @render.SphereDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_sphere_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.radius,
    0.0,
    0.0,
    0.0,
    1.0,
    r,
    g,
    b,
    a,
  )
}

///|
pub fn draw_cylinder_3d(command : @render.CylinderDrawCommand3D) -> Unit {
  let (r, g, b, a) = color_rgba(command.color)
  webgpu_draw_cylinder_3d(
    command.center.x,
    command.center.y,
    command.center.z,
    command.radius_top,
    command.radius_bottom,
    command.height,
    command.slices,
    0.0,
    0.0,
    0.0,
    1.0,
    r,
    g,
    b,
    a,
  )
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
  begin_3d({
    position: to_render_vec3(active_camera.position),
    target: to_render_vec3(active_camera.target),
    up: to_render_vec3(active_camera.up),
    fovy: active_camera.fov_y,
  })
  for item in frame.items {
    guard synced_mesh_assets.get(item.mesh) is Some(mesh_asset) else {
      continue
    }
    let material = synced_material_assets
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    let center = to_render_vec3(item.transform.translation)
    let rotation = item.transform.rotation
    let color = material.base_color
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
        )
      }
      Triangles(mesh) =>
        if mesh.positions.length() >= 3 {
          let normals = resolve_mesh_normals(mesh)
          match (mesh.uvs, resolve_material_texture_path(material)) {
            (Some(uvs), Some(texture_path)) =>
              if uvs.length() == mesh.positions.length() &&
                normals.length() == mesh.positions.length() {
                webgpu_draw_textured_triangles_3d(
                  texture_path,
                  flatten_textured_vertices3d(
                    mesh.positions,
                    uvs,
                    normals,
                    item.transform.scale,
                    color,
                  ),
                  center.x,
                  center.y,
                  center.z,
                  rotation.x,
                  rotation.y,
                  rotation.z,
                  rotation.w,
                )
              } else {
                webgpu_draw_colored_triangles_3d(
                  flatten_colored_vertices3d(
                    mesh.positions,
                    normals,
                    item.transform.scale,
                    color,
                  ),
                  center.x,
                  center.y,
                  center.z,
                  rotation.x,
                  rotation.y,
                  rotation.z,
                  rotation.w,
                )
              }
            _ =>
              webgpu_draw_colored_triangles_3d(
                flatten_colored_vertices3d(
                  mesh.positions,
                  normals,
                  item.transform.scale,
                  color,
                ),
                center.x,
                center.y,
                center.z,
                rotation.x,
                rotation.y,
                rotation.z,
                rotation.w,
              )
          }
        }
    }
  }
  end_3d()
}

///|
fn to_render_vec3(value : @smath.Vec3) -> @render.Vec3 {
  { x: value.x, y: value.y, z: value.z }
}

///|
fn scaled_vec3(size : @smath.Vec3, scale : @smath.Vec3) -> @render.Vec3 {
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
    directional_data.push(direction.x)
    directional_data.push(direction.y)
    directional_data.push(direction.z)
    directional_data.push(light.intensity)
    directional_data.push(r)
    directional_data.push(g)
    directional_data.push(b)
  }
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
  }
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
  }
  webgpu_set_lighting_3d(
    directional_data,
    point_data,
    spot_data,
    ambient.x,
    ambient.y,
    ambient.z,
  )
}

///|
fn resolve_mesh_normals(
  mesh : @render3d_types.TriangleMesh3D,
) -> Array[@smath.Vec3] {
  mesh.normals
  .filter(fn(candidates) { candidates.length() == mesh.positions.length() })
  .unwrap_or(compute_flat_triangle_normals(mesh.positions))
}

///|
fn compute_flat_triangle_normals(
  positions : Array[@smath.Vec3],
) -> Array[@smath.Vec3] {
  let normals : Array[@smath.Vec3] = []
  let triangle_count = positions.length() / 3
  for triangle in 0..<triangle_count {
    let base = triangle * 3
    let a = positions[base]
    let b = positions[base + 1]
    let c = positions[base + 2]
    let mut normal = (b - a).cross(c - a)
    if normal.length_squared() <= 0.0000001 {
      normal = @smath.Vec3::new(0.0, 1.0, 0.0)
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
fn flatten_colored_vertices3d(
  positions : Array[@smath.Vec3],
  normals : Array[@smath.Vec3],
  scale : @smath.Vec3,
  base_color : @render.Color,
) -> Array[Double] {
  let values : Array[Double] = []
  let (r, g, b) = color_rgb01(base_color)
  let a = base_color.a
  for index in 0..<positions.length() {
    let position = positions[index]
    let normal = normals[index]
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
  }
  values
}

///|
fn flatten_textured_vertices3d(
  positions : Array[@smath.Vec3],
  uvs : Array[@smath.Vec2D],
  normals : Array[@smath.Vec3],
  scale : @smath.Vec3,
  base_color : @render.Color,
) -> Array[Double] {
  let values : Array[Double] = []
  let (r, g, b) = color_rgb01(base_color)
  let a = base_color.a
  for index in 0..<positions.length() {
    let position = positions[index]
    let uv = uvs[index]
    let normal = normals[index]
    values.push(position.x * scale.x)
    values.push(position.y * scale.y)
    values.push(position.z * scale.z)
    values.push(normal.x)
    values.push(normal.y)
    values.push(normal.z)
    values.push(uv[X])
    values.push(uv[Y])
    values.push(r)
    values.push(g)
    values.push(b)
    values.push(a)
  }
  values
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
fn resolve_material_texture_path(
  material : @render3d_types.StandardMaterial3D,
) -> String? {
  match material.base_color_texture {
    Some(image_handle) =>
      match synced_image_assets.get(image_handle) {
        Some(image_asset) => Some(resolve_asset_path(image_asset.path))
        None => None
      }
    None => None
  }
}
