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
priv struct ShadowAtlasRect {
  offset : @smath.Vec2D
  scale : @smath.Vec2D
}

///|
priv struct FrameSpotShadowState {
  light_view_projection : @raylib.Matrix
  atlas_rect : ShadowAtlasRect
  depth_bias : Double
  normal_bias : Double
}

///|
priv struct FramePointShadowState {
  face_matrices : Array[@raylib.Matrix]
  face_rects : Array[ShadowAtlasRect]
  depth_bias : Double
  normal_bias : Double
}

///|
const SPOT_SHADOW_TEXTURE_SLOT : Int = 10

///|
const POINT_SHADOW_TEXTURE_SLOT : Int = 11

///|
const SPOT_SHADOW_ATLAS_COLUMNS : Int = 2

///|
const SPOT_SHADOW_ATLAS_ROWS : Int = 2

///|
const POINT_SHADOW_FACE_COUNT : Int = 6

///|
const POINT_SHADOW_ATLAS_COLUMNS : Int = 8

///|
const POINT_SHADOW_ATLAS_ROWS : Int = 6

///|
const LOCAL_SHADOW_NEAR_MIN : Double = 0.01

///|
fn make_shadow_atlas_rect(
  slot : Int,
  columns : Int,
  tile_size : Int,
  atlas_width : Int,
  atlas_height : Int,
) -> ShadowAtlasRect {
  let column = slot % columns
  let row = slot / columns
  let tile_width = tile_size.to_double() / atlas_width.to_double()
  let tile_height = tile_size.to_double() / atlas_height.to_double()
  {
    offset: @smath.Vec2D(
      column.to_double() * tile_width,
      row.to_double() * tile_height,
    ),
    scale: @smath.Vec2D(tile_width, tile_height),
  }
}

///|
fn uniform_shadow_atlas_rect(
  rect : ShadowAtlasRect,
) -> @raylib.ShaderUniformData {
  @raylib.ShaderUniformData::Vec4(
    @raylib.Vector4::new(
      to_float(rect.offset[X]),
      to_float(rect.offset[Y]),
      to_float(rect.scale[X]),
      to_float(rect.scale[Y]),
    ),
  )
}

///|
fn point_shadow_texel_size(face_size : Int) -> @smath.Vec2D {
  let inv = 1.0 / @cmp.maximum(1, face_size).to_double()
  @smath.Vec2D(inv, inv)
}

///|
fn spot_shadow_texel_size(shadow_map_size : Int) -> @smath.Vec2D {
  let inv = 1.0 / @cmp.maximum(1, shadow_map_size).to_double()
  @smath.Vec2D(inv, inv)
}

///|
fn shadow_map_near_z(near_z : Double) -> Double {
  @cmp.maximum(LOCAL_SHADOW_NEAR_MIN, near_z)
}

///|
fn build_spot_shadow_setup(
  light : @render3d_types.FrameSpotLight3D,
) -> DirectionalShadowSetup {
  let direction = normalize_or(
    light.direction,
    @smath.Vec3::new(0.0, -1.0, 0.0),
  )
  let target = light.position + direction
  let near_plane = shadow_map_near_z(light.shadow_map_near_z)
  let far_plane = @cmp.maximum(near_plane + 1.0, light.range)
  let light_view = @raylib.Matrix::look_at(
    to_ray_vector3_smath(light.position),
    to_ray_vector3_smath(target),
    to_ray_vector3_smath(choose_shadow_up(direction)),
  )
  let light_projection = @raylib.Matrix::perspective(
    @cmp.maximum(light.outer_angle * 2.0, 0.017453292519943295),
    1.0,
    near_plane,
    far_plane,
  )
  {
    light_view_projection: @raylib.Matrix::multiply(
      light_view, light_projection,
    ),
    half_extent: 0.0,
    near_plane,
    far_plane,
    near_bound: near_plane,
    far_bound: far_plane,
  }
}

///|
fn point_shadow_face(index : Int) -> (@smath.Vec3, @smath.Vec3) {
  match index {
    0 => (@smath.Vec3::new(1.0, 0.0, 0.0), @smath.Vec3::new(0.0, -1.0, 0.0))
    1 => (@smath.Vec3::new(-1.0, 0.0, 0.0), @smath.Vec3::new(0.0, -1.0, 0.0))
    2 => (@smath.Vec3::new(0.0, 1.0, 0.0), @smath.Vec3::new(0.0, 0.0, 1.0))
    3 => (@smath.Vec3::new(0.0, -1.0, 0.0), @smath.Vec3::new(0.0, 0.0, -1.0))
    4 => (@smath.Vec3::new(0.0, 0.0, 1.0), @smath.Vec3::new(0.0, -1.0, 0.0))
    _ => (@smath.Vec3::new(0.0, 0.0, -1.0), @smath.Vec3::new(0.0, -1.0, 0.0))
  }
}

///|
fn build_point_shadow_face_setup(
  light : @render3d_types.FramePointLight3D,
  face_index : Int,
) -> DirectionalShadowSetup {
  let (direction, up) = point_shadow_face(face_index)
  let near_plane = shadow_map_near_z(light.shadow_map_near_z)
  let far_plane = @cmp.maximum(near_plane + 1.0, light.range)
  let light_view = @raylib.Matrix::look_at(
    to_ray_vector3_smath(light.position),
    to_ray_vector3_smath(light.position + direction),
    to_ray_vector3_smath(up),
  )
  let light_projection = @raylib.Matrix::perspective(
    1.5707963267948966, 1.0, near_plane, far_plane,
  )
  {
    light_view_projection: @raylib.Matrix::multiply(
      light_view, light_projection,
    ),
    half_extent: 0.0,
    near_plane,
    far_plane,
    near_bound: near_plane,
    far_bound: far_plane,
  }
}

///|
fn get_spot_shadow_render_texture(
  shadow_map_size : Int,
) -> @raylib.RenderTexture? {
  let shadow_map_size = @cmp.maximum(1, shadow_map_size)
  if backend.spot_shadow_map_size != shadow_map_size {
    if backend.spot_shadow_render_texture is Some(render_texture) {
      render_texture.unload()
    }
    backend.spot_shadow_render_texture = None
    backend.spot_shadow_map_size = shadow_map_size
  }
  if backend.spot_shadow_render_texture is Some(existing) {
    if existing.id() > 0U && @raylib.get_render_texture_depth_id(existing) > 0U {
      return Some(existing)
    }
    return None
  }
  let width = shadow_map_size * SPOT_SHADOW_ATLAS_COLUMNS
  let height = shadow_map_size * SPOT_SHADOW_ATLAS_ROWS
  let fbo_id = @rl.load_framebuffer()
  let depth_tex_id = @rl.load_texture_depth(width, height, false)
  @rl.framebuffer_attach(fbo_id, depth_tex_id, 100, 100, 0)
  ignore(@rl.framebuffer_complete(fbo_id))
  let render_texture = @raylib.RenderTexture::new(
    fbo_id,
    @raylib.Texture::new(0U, width, height, 1, 7),
    @raylib.Texture::new(depth_tex_id, width, height, 1, 19),
  )
  let depth_id = @raylib.get_render_texture_depth_id(render_texture)
  if render_texture.id() == 0U || depth_id == 0U {
    warn_texture_issue(
      "spot_shadow_atlas_unavailable", "raylib spot-light shadow atlas framebuffer could not be created; spot shadows are disabled",
    )
    render_texture.unload()
    return None
  }
  let depth_texture = @raylib.Texture::new(
    depth_id,
    width,
    height,
    1,
    @raylib.PixelformatUncompressedR8g8b8a8,
  )
  @raylib.set_texture_filter(depth_texture, @raylib.TextureFilterPoint)
  @raylib.set_texture_wrap(depth_texture, @raylib.TextureWrapClamp)
  backend.spot_shadow_render_texture = Some(render_texture)
  Some(render_texture)
}

///|
fn get_point_shadow_render_texture(face_size : Int) -> @raylib.RenderTexture? {
  let face_size = @cmp.maximum(1, face_size)
  if backend.point_shadow_map_size != face_size {
    if backend.point_shadow_render_texture is Some(render_texture) {
      render_texture.unload()
    }
    backend.point_shadow_render_texture = None
    backend.point_shadow_map_size = face_size
  }
  if backend.point_shadow_render_texture is Some(existing) {
    if existing.id() > 0U && @raylib.get_render_texture_depth_id(existing) > 0U {
      return Some(existing)
    }
    return None
  }
  let width = face_size * POINT_SHADOW_ATLAS_COLUMNS
  let height = face_size * POINT_SHADOW_ATLAS_ROWS
  let fbo_id = @rl.load_framebuffer()
  let depth_tex_id = @rl.load_texture_depth(width, height, false)
  @rl.framebuffer_attach(fbo_id, depth_tex_id, 100, 100, 0)
  ignore(@rl.framebuffer_complete(fbo_id))
  let render_texture = @raylib.RenderTexture::new(
    fbo_id,
    @raylib.Texture::new(0U, width, height, 1, 7),
    @raylib.Texture::new(depth_tex_id, width, height, 1, 19),
  )
  let depth_id = @raylib.get_render_texture_depth_id(render_texture)
  if render_texture.id() == 0U || depth_id == 0U {
    warn_texture_issue(
      "point_shadow_atlas_unavailable", "raylib point-light shadow atlas framebuffer could not be created; point shadows are disabled",
    )
    render_texture.unload()
    return None
  }
  let depth_texture = @raylib.Texture::new(
    depth_id,
    width,
    height,
    1,
    @raylib.PixelformatUncompressedR8g8b8a8,
  )
  @raylib.set_texture_filter(depth_texture, @raylib.TextureFilterPoint)
  @raylib.set_texture_wrap(depth_texture, @raylib.TextureWrapClamp)
  backend.point_shadow_render_texture = Some(render_texture)
  Some(render_texture)
}

///|
fn shadow_caster_items(
  frame : @render3d_types.RenderFrame3D,
) -> Array[@render3d_types.RenderItem3D] {
  let items : Array[@render3d_types.RenderItem3D] = []
  for item in frame.items {
    if item.cast_shadows {
      items.push(item)
    }
  }
  items
}

///|
fn render_shadow_casters_for_setup(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
  setup : DirectionalShadowSetup,
) -> Unit {
  begin_3d(camera)
  for item in shadow_caster_items(frame) {
    guard backend.meshes3d.get(item.mesh) is Some(mesh_asset) else { continue }
    let material = backend.materials3d
      .get(item.material)
      .unwrap_or(@render3d_types.default_standard_material3d())
    draw_shadow_mesh3d_instance(mesh_asset, material, item.transform, setup)
  }
  end_3d()
}

///|
fn render_spot_shadow_map(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
) -> (Map[Int, FrameSpotShadowState], UInt?, @smath.Vec2D) {
  let spot_shadows : Map[Int, FrameSpotShadowState] = Map::new()
  let spot_count = @cmp.minimum(frame.spot_lights.length(), MAX_SPOT_LIGHTS)
  let shadow_map_size = @cmp.maximum(1, frame.directional_shadow_map_size)
  if spot_count == 0 {
    return (spot_shadows, None, @smath.Vec2D(0.0, 0.0))
  }
  guard get_spot_shadow_render_texture(shadow_map_size) is Some(render_texture) else {
    return (spot_shadows, None, @smath.Vec2D(0.0, 0.0))
  }
  let atlas_width = shadow_map_size * SPOT_SHADOW_ATLAS_COLUMNS
  let atlas_height = shadow_map_size * SPOT_SHADOW_ATLAS_ROWS
  @raylib.begin_texture_mode(render_texture)
  @raylib.clear_background(to_ray_color(white_render_color()))
  for light_index in 0..<spot_count {
    let light = frame.spot_lights[light_index]
    if !light.shadows {
      continue
    }
    let rect = make_shadow_atlas_rect(
      light_index,
      SPOT_SHADOW_ATLAS_COLUMNS,
      shadow_map_size,
      atlas_width,
      atlas_height,
    )
    let setup = build_spot_shadow_setup(light)
    @rl.viewport(
      (rect.offset[X] * atlas_width.to_double()).to_int(),
      (rect.offset[Y] * atlas_height.to_double()).to_int(),
      shadow_map_size,
      shadow_map_size,
    )
    render_shadow_casters_for_setup(frame, camera, setup)
    spot_shadows.set(light_index, {
      light_view_projection: setup.light_view_projection,
      atlas_rect: rect,
      depth_bias: @cmp.maximum(0.0, light.shadow_depth_bias),
      normal_bias: @cmp.maximum(0.0, light.shadow_normal_bias),
    })
  }
  @raylib.end_texture_mode()
  (
    spot_shadows,
    Some(@raylib.get_render_texture_depth_id(render_texture)),
    spot_shadow_texel_size(shadow_map_size),
  )
}

///|
fn render_point_shadow_map(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
) -> (Map[Int, FramePointShadowState], UInt?, @smath.Vec2D) {
  let point_shadows : Map[Int, FramePointShadowState] = Map::new()
  let point_count = @cmp.minimum(frame.point_lights.length(), MAX_POINT_LIGHTS)
  let face_size = @cmp.maximum(1, frame.point_shadow_map_size)
  if point_count == 0 {
    return (point_shadows, None, @smath.Vec2D(0.0, 0.0))
  }
  guard get_point_shadow_render_texture(face_size) is Some(render_texture) else {
    return (point_shadows, None, @smath.Vec2D(0.0, 0.0))
  }
  let atlas_width = face_size * POINT_SHADOW_ATLAS_COLUMNS
  let atlas_height = face_size * POINT_SHADOW_ATLAS_ROWS
  @raylib.begin_texture_mode(render_texture)
  @raylib.clear_background(to_ray_color(white_render_color()))
  for light_index in 0..<point_count {
    let light = frame.point_lights[light_index]
    if !light.shadows {
      continue
    }
    let face_matrices : Array[@raylib.Matrix] = []
    let face_rects : Array[ShadowAtlasRect] = []
    for face_index in 0..<POINT_SHADOW_FACE_COUNT {
      let atlas_slot = light_index * POINT_SHADOW_FACE_COUNT + face_index
      let rect = make_shadow_atlas_rect(
        atlas_slot,
        POINT_SHADOW_ATLAS_COLUMNS,
        face_size,
        atlas_width,
        atlas_height,
      )
      let setup = build_point_shadow_face_setup(light, face_index)
      @rl.viewport(
        (rect.offset[X] * atlas_width.to_double()).to_int(),
        (rect.offset[Y] * atlas_height.to_double()).to_int(),
        face_size,
        face_size,
      )
      render_shadow_casters_for_setup(frame, camera, setup)
      face_matrices.push(setup.light_view_projection)
      face_rects.push(rect)
    }
    point_shadows.set(light_index, {
      face_matrices,
      face_rects,
      depth_bias: @cmp.maximum(0.0, light.shadow_depth_bias),
      normal_bias: @cmp.maximum(0.0, light.shadow_normal_bias),
    })
  }
  @raylib.end_texture_mode()
  (
    point_shadows,
    Some(@raylib.get_render_texture_depth_id(render_texture)),
    point_shadow_texel_size(face_size),
  )
}
