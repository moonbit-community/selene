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
priv struct ShadowShaderState {
  shader : @raylib.Shader
  light_view_projection_loc : Int
  material_has_texture_loc : Int
  material_alpha_mode_loc : Int
  material_alpha_cutoff_loc : Int
  base_uv_offset_scale_loc : Int
  base_uv_rotation_loc : Int
  base_uv_set_loc : Int
}

///|
priv struct Bounds3D {
  min : @smath.Vec3
  max : @smath.Vec3
}

///|
priv struct BoundingSphere3D {
  center : @smath.Vec3
  radius : Double
}

///|
priv struct DirectionalShadowSetup {
  light_view_projection : @raylib.Matrix
  half_extent : Double
  near_plane : Double
  far_plane : Double
  near_bound : Double
  far_bound : Double
}

///|
priv struct DirectionalShadowCascadeState {
  light_view_projection : @raylib.Matrix
  atlas_rect : ShadowAtlasRect
  near_bound : Double
  far_bound : Double
}

///|
priv struct FrameDirectionalShadowState {
  depth_texture_id : UInt
  cascades : Array[DirectionalShadowCascadeState]
  depth_bias : Double
  normal_bias : Double
}

///|
priv struct FrameShadowState {
  directional_shadows : Map[Int, FrameDirectionalShadowState]
  spot_shadows : Map[Int, FrameSpotShadowState]
  point_shadows : Map[Int, FramePointShadowState]
  spot_shadow_atlas_id : UInt?
  point_shadow_atlas_id : UInt?
  directional_texel_size : @smath.Vec2
  spot_texel_size : @smath.Vec2
  point_texel_size : @smath.Vec2
}

///|
const SHADOW_MAP_TEXTURE_SLOT_BASE : Int = 6

///|
const SHADOW_CAMERA_MARGIN_SCALE : Double = 0.15

///|
const SHADOW_CAMERA_MARGIN_MIN : Double = 2.0

///|
const SHADOW_CAMERA_DISTANCE_SCALE : Double = 2.0

///|
const SHADOW_CAMERA_DISTANCE_MIN : Double = 10.0

///|
const SHADOW_CAMERA_NEAR_MIN : Double = 0.01

///|
fn shadow_texture_slot(index : Int) -> Int {
  SHADOW_MAP_TEXTURE_SLOT_BASE + index
}

///|
let raylib_shadow_vertex_shader : String = "#version 330\n" +
  "in vec3 vertexPosition;\n" +
  "in vec2 vertexTexCoord;\n" +
  "in vec2 vertexTexCoord2;\n" +
  "uniform mat4 matModel;\n" +
  "uniform mat4 lightViewProjection;\n" +
  "out vec2 fragTexCoord;\n" +
  "out vec2 fragTexCoord2;\n" +
  "void main() {\n" +
  "  vec4 worldPosition = matModel * vec4(vertexPosition, 1.0);\n" +
  "  fragTexCoord = vertexTexCoord;\n" +
  "  fragTexCoord2 = vertexTexCoord2;\n" +
  "  gl_Position = lightViewProjection * worldPosition;\n" +
  "}\n"

///|
let raylib_shadow_fragment_shader : String = "#version 330\n" +
  "in vec2 fragTexCoord;\n" +
  "in vec2 fragTexCoord2;\n" +
  "uniform sampler2D texture0;\n" +
  "uniform int materialHasTexture;\n" +
  "uniform int materialAlphaMode;\n" +
  "uniform float materialAlphaCutoff;\n" +
  "uniform vec4 baseUvOffsetScale;\n" +
  "uniform vec2 baseUvRotation;\n" +
  "uniform int baseUvSet;\n" +
  "vec2 selectUv(int setIndex) {\n" +
  "  if (setIndex == 1) return fragTexCoord2;\n" +
  "  return fragTexCoord;\n" +
  "}\n" +
  "vec2 applyTextureTransform(vec2 uv, vec4 offsetScale, vec2 rotationSinCos) {\n" +
  "  vec2 scaled = uv * offsetScale.zw;\n" +
  "  return vec2(\n" +
  "    scaled.x * rotationSinCos.y - scaled.y * rotationSinCos.x + offsetScale.x,\n" +
  "    scaled.x * rotationSinCos.x + scaled.y * rotationSinCos.y + offsetScale.y\n" +
  "  );\n" +
  "}\n" +
  "void main() {\n" +
  "  if (materialAlphaMode == 2) discard;\n" +
  "  if (materialAlphaMode == 1 && materialHasTexture != 0) {\n" +
  "    vec2 uv = applyTextureTransform(selectUv(baseUvSet), baseUvOffsetScale, baseUvRotation);\n" +
  "    if (texture(texture0, uv).a < materialAlphaCutoff) discard;\n" +
  "  }\n" +
  "}\n"

///|
fn normalize_shadow_map_size(size : Int) -> Int {
  @cmp.maximum(1, size)
}

///|
fn shadow_texel_size(size : Int) -> @smath.Vec2 {
  let inv = 1.0 / normalize_shadow_map_size(size).to_double()
  @smath.Vec2(inv, inv)
}

///|
fn vec3_min(lhs : @smath.Vec3, rhs : @smath.Vec3) -> @smath.Vec3 {
  @smath.Vec3(
    @cmp.minimum(lhs.x, rhs.x),
    @cmp.minimum(lhs.y, rhs.y),
    @cmp.minimum(lhs.z, rhs.z),
  )
}

///|
fn vec3_max(lhs : @smath.Vec3, rhs : @smath.Vec3) -> @smath.Vec3 {
  @smath.Vec3(
    @cmp.maximum(lhs.x, rhs.x),
    @cmp.maximum(lhs.y, rhs.y),
    @cmp.maximum(lhs.z, rhs.z),
  )
}

///|
fn vec3_midpoint(lhs : @smath.Vec3, rhs : @smath.Vec3) -> @smath.Vec3 {
  @smath.Vec3(
    (lhs.x + rhs.x) * 0.5,
    (lhs.y + rhs.y) * 0.5,
    (lhs.z + rhs.z) * 0.5,
  )
}

///|
fn choose_shadow_up(light_direction : @smath.Vec3) -> @smath.Vec3 {
  let normalized = normalize_or(light_direction, @smath.Vec3(0.0, -1.0, 0.0))
  let world_up = @smath.Vec3(0.0, 1.0, 0.0)
  if normalized.cross(world_up).length_squared() <= 0.0001 {
    @smath.Vec3(0.0, 0.0, 1.0)
  } else {
    world_up
  }
}

///|
fn directional_shadow_cascade_count(
  light : @render3d_types.DirectionalLight3D,
) -> Int {
  let count = light.cascade_shadow_config.bounds.length()
  if count < 1 {
    1
  } else if count > MAX_DIRECTIONAL_CASCADES {
    MAX_DIRECTIONAL_CASCADES
  } else {
    count
  }
}

///|
fn directional_shadow_atlas_layout(cascade_count : Int) -> (Int, Int) {
  if cascade_count <= 1 {
    (1, 1)
  } else if cascade_count == 2 {
    (2, 1)
  } else {
    (2, 2)
  }
}

///|
fn camera_basis(
  camera : @render3d_types.FrameCamera3D,
) -> (@smath.Vec3, @smath.Vec3, @smath.Vec3) {
  let forward = normalize_or(
    camera.target - camera.position,
    @smath.Vec3(0.0, 0.0, -1.0),
  )
  let up = normalize_or(camera.up, @smath.Vec3(0.0, 1.0, 0.0))
  let right = normalize_or(forward.cross(up), @smath.Vec3(1.0, 0.0, 0.0))
  let corrected_up = normalize_or(
    right.cross(forward),
    @smath.Vec3(0.0, 1.0, 0.0),
  )
  (forward, right, corrected_up)
}

///|
fn camera_aspect_ratio() -> Double {
  if !@raylib.is_window_ready() {
    return 1.0
  }
  let height = @raylib.get_render_height()
  if height <= 0 {
    1.0
  } else {
    @raylib.get_render_width().to_double() / height.to_double()
  }
}

///|
fn camera_frustum_slice_corners(
  camera : @render3d_types.FrameCamera3D,
  near_bound : Double,
  far_bound : Double,
) -> Array[@smath.Vec3] {
  let (forward, right, up) = camera_basis(camera)
  let corners : Array[@smath.Vec3] = []
  match camera.projection {
    Perspective => {
      let aspect = camera_aspect_ratio()
      let tan_half_y = @cmath.tan(camera.fov_y * 0.5 * @cmath.PI / 180.0)
      let near_height = near_bound * tan_half_y
      let near_width = near_height * aspect
      let far_height = far_bound * tan_half_y
      let far_width = far_height * aspect
      let near_center = camera.position + forward.scalar_mul(near_bound)
      let far_center = camera.position + forward.scalar_mul(far_bound)
      corners.push(
        near_center - right.scalar_mul(near_width) - up.scalar_mul(near_height),
      )
      corners.push(
        near_center + right.scalar_mul(near_width) - up.scalar_mul(near_height),
      )
      corners.push(
        near_center + right.scalar_mul(near_width) + up.scalar_mul(near_height),
      )
      corners.push(
        near_center - right.scalar_mul(near_width) + up.scalar_mul(near_height),
      )
      corners.push(
        far_center - right.scalar_mul(far_width) - up.scalar_mul(far_height),
      )
      corners.push(
        far_center + right.scalar_mul(far_width) - up.scalar_mul(far_height),
      )
      corners.push(
        far_center + right.scalar_mul(far_width) + up.scalar_mul(far_height),
      )
      corners.push(
        far_center - right.scalar_mul(far_width) + up.scalar_mul(far_height),
      )
    }
    Orthographic => {
      let ortho_size = camera.orthographic_size.unwrap_or(
        @smath.Vec2(20.0, 20.0),
      )
      let half_width = ortho_size[X].abs() * 0.5
      let half_height = ortho_size[Y].abs() * 0.5
      let near_center = camera.position + forward.scalar_mul(near_bound)
      let far_center = camera.position + forward.scalar_mul(far_bound)
      corners.push(
        near_center - right.scalar_mul(half_width) - up.scalar_mul(half_height),
      )
      corners.push(
        near_center + right.scalar_mul(half_width) - up.scalar_mul(half_height),
      )
      corners.push(
        near_center + right.scalar_mul(half_width) + up.scalar_mul(half_height),
      )
      corners.push(
        near_center - right.scalar_mul(half_width) + up.scalar_mul(half_height),
      )
      corners.push(
        far_center - right.scalar_mul(half_width) - up.scalar_mul(half_height),
      )
      corners.push(
        far_center + right.scalar_mul(half_width) - up.scalar_mul(half_height),
      )
      corners.push(
        far_center + right.scalar_mul(half_width) + up.scalar_mul(half_height),
      )
      corners.push(
        far_center - right.scalar_mul(half_width) + up.scalar_mul(half_height),
      )
    }
  }
  corners
}

///|
fn directional_shadow_bounds(
  light : @render3d_types.DirectionalLight3D,
  camera : @render3d_types.FrameCamera3D,
) -> Array[(Double, Double)] {
  let config = light.cascade_shadow_config
  let minimum_distance = @cmp.maximum(
    camera.near,
    @cmp.maximum(0.0, config.minimum_distance),
  )
  if camera.far <= minimum_distance {
    return []
  }
  let overlap_proportion = @cmp.maximum(
    0.0,
    @cmp.minimum(1.0, config.overlap_proportion),
  )
  let bounds : Array[(Double, Double)] = []
  let cascade_count = directional_shadow_cascade_count(light)
  let mut previous_far = minimum_distance
  for index in 0..<cascade_count {
    let authored_far = config.bounds.get(index).unwrap_or(camera.far)
    let far_bound = @cmp.minimum(camera.far, authored_far)
    let near_bound = if index == 0 {
      minimum_distance
    } else {
      @cmp.maximum(minimum_distance, previous_far * (1.0 - overlap_proportion))
    }
    if far_bound <= near_bound {
      previous_far = far_bound
      continue
    }
    bounds.push((near_bound, far_bound))
    previous_far = far_bound
    if far_bound >= camera.far {
      break
    }
  }
  bounds
}

///|
fn build_directional_shadow_cascades_for_light(
  frame : @render3d_types.RenderFrame3D,
  light_index : Int,
  camera : @render3d_types.FrameCamera3D,
  shadow_map_size : Int,
) -> Array[DirectionalShadowCascadeState] {
  if light_index < 0 || light_index >= frame.directional_lights.length() {
    return []
  }
  let light = frame.directional_lights[light_index]
  let bounds = directional_shadow_bounds(light, camera)
  if bounds.length() == 0 {
    return []
  }
  let light_direction = normalize_or(
    light.direction,
    @smath.Vec3(0.0, -1.0, 0.0),
  )
  let light_view = @raylib.Matrix::look_at(
    @raylib.Vector3::zero(),
    to_ray_vector3_smath(light_direction),
    to_ray_vector3_smath(choose_shadow_up(light_direction)),
  )
  let tile_size = normalize_shadow_map_size(shadow_map_size)
  let (atlas_columns, atlas_rows) = directional_shadow_atlas_layout(
    bounds.length(),
  )
  let atlas_width = tile_size * atlas_columns
  let atlas_height = tile_size * atlas_rows
  let cascades : Array[DirectionalShadowCascadeState] = []
  for cascade_index in 0..<bounds.length() {
    let near_bound = bounds[cascade_index].0
    let far_bound = bounds[cascade_index].1
    let corners = camera_frustum_slice_corners(camera, near_bound, far_bound)
    guard corners.length() >= 8 else { continue }
    let mut min_corner = transform_shadow_point(light_view, corners[0])
    let mut max_corner = min_corner
    for index in 1..<corners.length() {
      let corner = transform_shadow_point(light_view, corners[index])
      min_corner = vec3_min(min_corner, corner)
      max_corner = vec3_max(max_corner, corner)
    }
    let body_diagonal = (corners[0] - corners[6]).length_squared()
    let far_plane_diagonal = (corners[4] - corners[6]).length_squared()
    let diameter = @cmp.maximum(
      1.0,
      @cmath.ceil(
        @cmath.pow(@cmp.maximum(body_diagonal, far_plane_diagonal), 0.5),
      ),
    )
    let texel_size = diameter / tile_size.to_double()
    let center_x = @cmath.floor(
        (min_corner.x + max_corner.x) * 0.5 / texel_size,
      ) *
      texel_size
    let center_y = @cmath.floor(
        (min_corner.y + max_corner.y) * 0.5 / texel_size,
      ) *
      texel_size
    let half_extent = diameter * 0.5
    let near_plane = SHADOW_CAMERA_NEAR_MIN
    let far_plane = @cmp.maximum(
      near_plane + 1.0,
      max_corner.z - min_corner.z + near_plane,
    )
    let cascade_view = @raylib.Matrix::multiply(
      light_view,
      @raylib.Matrix::translate(
        Float::from_double(-center_x),
        Float::from_double(-center_y),
        Float::from_double(-(max_corner.z + near_plane)),
      ),
    )
    let cascade_projection = @raylib.Matrix::ortho(
      -half_extent,
      half_extent,
      -half_extent,
      half_extent,
      near_plane,
      far_plane,
    )
    let atlas_rect = make_shadow_atlas_rect(
      cascade_index, atlas_columns, tile_size, atlas_width, atlas_height,
    )
    cascades.push({
      light_view_projection: @raylib.Matrix::multiply(
        cascade_view, cascade_projection,
      ),
      atlas_rect,
      near_bound,
      far_bound,
    })
  }
  cascades
}

///|
fn shadowed_directional_light_indices(
  frame : @render3d_types.RenderFrame3D,
) -> Array[Int] {
  let indices : Array[Int] = []
  let directional_count = @cmp.minimum(
    frame.directional_lights.length(),
    MAX_DIRECTIONAL_LIGHTS,
  )
  for index in 0..<directional_count {
    if frame.directional_lights[index].shadows {
      indices.push(index)
    }
  }
  indices
}

///|
fn shadow_depth_bias(light : @render3d_types.DirectionalLight3D) -> Double {
  @cmp.maximum(0.0, light.shadow_depth_bias)
}

///|
fn shadow_normal_bias(light : @render3d_types.DirectionalLight3D) -> Double {
  @cmp.maximum(0.0, light.shadow_normal_bias)
}

///|
fn bounds_corners(bounds : Bounds3D) -> Array[@smath.Vec3] {
  let min = bounds.min
  let max = bounds.max
  [
    @smath.Vec3(min.x, min.y, min.z),
    @smath.Vec3(min.x, min.y, max.z),
    @smath.Vec3(min.x, max.y, min.z),
    @smath.Vec3(min.x, max.y, max.z),
    @smath.Vec3(max.x, min.y, min.z),
    @smath.Vec3(max.x, min.y, max.z),
    @smath.Vec3(max.x, max.y, min.z),
    @smath.Vec3(max.x, max.y, max.z),
  ]
}

///|
fn transform_shadow_point(
  matrix : @raylib.Matrix,
  point : @smath.Vec3,
) -> @smath.Vec3 {
  let transformed = @raylib.Vector3::transform(
    @raylib.Vector3::new(
      to_float(point.x),
      to_float(point.y),
      to_float(point.z),
    ),
    matrix,
  )
  @smath.Vec3(
    transformed.x.to_double(),
    transformed.y.to_double(),
    transformed.z.to_double(),
  )
}

///|
fn triangle_mesh_local_bounds(
  mesh : @render3d_types.TriangleMesh3D,
) -> Bounds3D? {
  guard mesh.positions.length() > 0 else { return None }
  let mut min = mesh.positions[0]
  let mut max = mesh.positions[0]
  for index in 1..<mesh.positions.length() {
    let position = mesh.positions[index]
    min = vec3_min(min, position)
    max = vec3_max(max, position)
  }
  Some({ min, max })
}

///|
fn primitive_local_bounding_sphere(
  primitive : @render3d_types.MeshPrimitive3D,
) -> BoundingSphere3D? {
  match primitive {
    Cube(size) => {
      let half_extents = @smath.Vec3(
        size.x.abs() * 0.5,
        size.y.abs() * 0.5,
        size.z.abs() * 0.5,
      )
      Some({ center: @smath.Vec3::zero(), radius: half_extents.length() })
    }
    Sphere(radius) =>
      Some({ center: @smath.Vec3::zero(), radius: radius.abs() })
    Cylinder(radius_top, radius_bottom, height, _slices) => {
      let max_radius = @cmp.maximum(radius_top.abs(), radius_bottom.abs())
      let half_extents = @smath.Vec3(max_radius, height.abs() * 0.5, max_radius)
      Some({ center: @smath.Vec3::zero(), radius: half_extents.length() })
    }
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y.abs() }
      let half_extents = @smath.Vec3(
        size.x.abs() * 0.5,
        thickness * 0.5,
        size.z.abs() * 0.5,
      )
      Some({ center: @smath.Vec3::zero(), radius: half_extents.length() })
    }
    Triangles(mesh) =>
      triangle_mesh_local_bounds(mesh).map(fn(bounds) {
        let center = vec3_midpoint(bounds.min, bounds.max)
        { center, radius: (bounds.max - center).length() }
      })
  }
}

///|
fn world_bounding_sphere(
  mesh_asset : @render3d_types.MeshAsset,
  transform : @render3d_types.FrameTransform3D,
) -> BoundingSphere3D? {
  primitive_local_bounding_sphere(mesh_asset.primitive).map(fn(local_sphere) {
    let scaled_center = @smath.Vec3(
      local_sphere.center.x * transform.scale.x,
      local_sphere.center.y * transform.scale.y,
      local_sphere.center.z * transform.scale.z,
    )
    let max_scale = @cmp.maximum(
      transform.scale.x.abs(),
      @cmp.maximum(transform.scale.y.abs(), transform.scale.z.abs()),
    )
    {
      center: transform.translation +
      transform.rotation.rotate_vec3(scaled_center),
      radius: local_sphere.radius * max_scale,
    }
  })
}

///|
fn scene_shadow_bounds(frame : @render3d_types.RenderFrame3D) -> Bounds3D? {
  let mut bounds : Bounds3D? = None
  for item in frame.items {
    guard backend.meshes3d.get(item.mesh) is Some(mesh_asset) else { continue }
    guard world_bounding_sphere(mesh_asset, item.transform) is Some(sphere) else {
      continue
    }
    let extent = @smath.Vec3(sphere.radius, sphere.radius, sphere.radius)
    let item_bounds : Bounds3D = {
      min: sphere.center - extent,
      max: sphere.center + extent,
    }
    bounds = Some(
      match bounds {
        Some(existing) =>
          {
            min: vec3_min(existing.min, item_bounds.min),
            max: vec3_max(existing.max, item_bounds.max),
          }
        None => item_bounds
      },
    )
  }
  bounds
}

///|
fn build_directional_shadow_setup_for_light(
  frame : @render3d_types.RenderFrame3D,
  light_index : Int,
) -> DirectionalShadowSetup? {
  guard scene_shadow_bounds(frame) is Some(bounds) else { return None }
  guard light_index >= 0 && light_index < frame.directional_lights.length() else {
    return None
  }
  let light = frame.directional_lights[light_index]
  let light_direction = normalize_or(
    light.direction,
    @smath.Vec3(0.0, -1.0, 0.0),
  )
  let center = vec3_midpoint(bounds.min, bounds.max)
  let extent = bounds.max - center
  let radius = @cmp.maximum(extent.length(), 1.0)
  let margin = @cmp.maximum(
    radius * SHADOW_CAMERA_MARGIN_SCALE,
    SHADOW_CAMERA_MARGIN_MIN,
  )
  let distance = @cmp.maximum(
    radius * SHADOW_CAMERA_DISTANCE_SCALE + margin,
    SHADOW_CAMERA_DISTANCE_MIN,
  )
  let light_position = center -
    @smath.Vec3(
      light_direction.x * distance,
      light_direction.y * distance,
      light_direction.z * distance,
    )
  let light_view = @raylib.Matrix::look_at(
    to_ray_vector3_smath(light_position),
    to_ray_vector3_smath(center),
    to_ray_vector3_smath(choose_shadow_up(light_direction)),
  )
  let mut half_extent = 1.0
  let mut min_z = 0.0
  let mut max_z = 0.0
  let corners = bounds_corners(bounds)
  if corners.length() > 0 {
    let first = transform_shadow_point(light_view, corners[0])
    half_extent = @cmp.maximum(first.x.abs(), first.y.abs())
    min_z = first.z
    max_z = first.z
    for index in 1..<corners.length() {
      let point = transform_shadow_point(light_view, corners[index])
      half_extent = @cmp.maximum(
        half_extent,
        @cmp.maximum(point.x.abs(), point.y.abs()),
      )
      min_z = @cmp.minimum(min_z, point.z)
      max_z = @cmp.maximum(max_z, point.z)
    }
  }
  half_extent += margin
  let near_plane = @cmp.maximum(SHADOW_CAMERA_NEAR_MIN, -max_z - margin)
  let far_plane = @cmp.maximum(near_plane + 1.0, -min_z + margin)
  let light_projection = @raylib.Matrix::ortho(
    -half_extent,
    half_extent,
    -half_extent,
    half_extent,
    near_plane,
    far_plane,
  )
  Some({
    light_view_projection: @raylib.Matrix::multiply(
      light_view, light_projection,
    ),
    half_extent,
    near_plane,
    far_plane,
    near_bound: SHADOW_CAMERA_NEAR_MIN,
    far_bound: SHADOW_CAMERA_NEAR_MIN + far_plane,
  })
}

///|
fn configure_shadow_shader_locations(shader : @raylib.Shader) -> Unit {
  shader.set_locs(
    @raylib.ShaderLocVertexPosition,
    @raylib.get_shader_location_attrib(shader, "vertexPosition"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexTexcoord01,
    @raylib.get_shader_location_attrib(shader, "vertexTexCoord"),
  )
  shader.set_locs(
    @raylib.ShaderLocVertexTexcoord02,
    @raylib.get_shader_location_attrib(shader, "vertexTexCoord2"),
  )
  shader.set_locs(
    @raylib.ShaderLocMatrixModel,
    @raylib.get_shader_location(shader, "matModel"),
  )
  shader.set_locs(
    @raylib.ShaderLocMapAlbedo,
    @raylib.get_shader_location(shader, "texture0"),
  )
}

///|
fn create_shadow_shader_state() -> ShadowShaderState {
  let shader = @raylib.load_shader_from_memory(
    raylib_shadow_vertex_shader, raylib_shadow_fragment_shader,
  )
  configure_shadow_shader_locations(shader)
  {
    shader,
    light_view_projection_loc: @raylib.get_shader_location(
      shader, "lightViewProjection",
    ),
    material_has_texture_loc: @raylib.get_shader_location(
      shader, "materialHasTexture",
    ),
    material_alpha_mode_loc: @raylib.get_shader_location(
      shader, "materialAlphaMode",
    ),
    material_alpha_cutoff_loc: @raylib.get_shader_location(
      shader, "materialAlphaCutoff",
    ),
    base_uv_offset_scale_loc: @raylib.get_shader_location(
      shader, "baseUvOffsetScale",
    ),
    base_uv_rotation_loc: @raylib.get_shader_location(shader, "baseUvRotation"),
    base_uv_set_loc: @raylib.get_shader_location(shader, "baseUvSet"),
  }
}

///|
fn get_shadow_shader_state() -> ShadowShaderState {
  if backend.shadow_shader is Some(state) {
    return state
  }
  let state = create_shadow_shader_state()
  backend.shadow_shader = Some(state)
  state
}

///|
fn get_shadow_material() -> @raylib.Material {
  if backend.shadow_material is Some(material) {
    return material
  }
  let material = @raylib.Material::default()
  @raylib.set_material_shader(material, get_shadow_shader_state().shader)
  @raylib.set_material_map_color(
    material,
    @raylib.MaterialMapAlbedo,
    to_ray_color(white_render_color()),
  )
  backend.shadow_material = Some(material)
  material
}

///|
fn create_directional_shadow_render_texture(
  tile_size : Int,
  atlas_columns : Int,
  atlas_rows : Int,
  warn_key : String,
) -> @raylib.RenderTexture? {
  let width = tile_size * atlas_columns
  let height = tile_size * atlas_rows
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
      warn_key, "raylib shadow-map framebuffer could not be created; directional cascaded shadows are disabled for one light",
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
  Some(render_texture)
}

///|
fn get_shadow_render_texture(
  index : Int,
  shadow_map_size : Int,
  cascade_count : Int,
) -> @raylib.RenderTexture? {
  guard index >= 0 && index < MAX_DIRECTIONAL_LIGHTS else { return None }
  let tile_size = normalize_shadow_map_size(shadow_map_size)
  let cascade_count = @cmp.maximum(
    1,
    @cmp.minimum(MAX_DIRECTIONAL_CASCADES, cascade_count),
  )
  let (atlas_columns, atlas_rows) = directional_shadow_atlas_layout(
    cascade_count,
  )
  while backend.shadow_render_textures.length() <= index {
    let slot = backend.shadow_render_textures.length()
    guard create_directional_shadow_render_texture(
        tile_size,
        atlas_columns,
        atlas_rows,
        "shadowmap_unavailable:\{slot}",
      )
      is Some(render_texture) else {
      return None
    }
    backend.shadow_render_textures.push(render_texture)
    backend.directional_shadow_tile_sizes.push(tile_size)
    backend.directional_shadow_atlas_columns.push(atlas_columns)
    backend.directional_shadow_atlas_rows.push(atlas_rows)
  }
  guard backend.shadow_render_textures.get(index) is Some(existing) else {
    return None
  }
  let existing_tile_size = backend.directional_shadow_tile_sizes
    .get(index)
    .unwrap_or(0)
  let existing_columns = backend.directional_shadow_atlas_columns
    .get(index)
    .unwrap_or(0)
  let existing_rows = backend.directional_shadow_atlas_rows
    .get(index)
    .unwrap_or(0)
  let needs_recreate = existing_tile_size != tile_size ||
    existing_columns != atlas_columns ||
    existing_rows != atlas_rows ||
    existing.id() == 0U ||
    @raylib.get_render_texture_depth_id(existing) == 0U
  if needs_recreate {
    existing.unload()
    guard create_directional_shadow_render_texture(
        tile_size,
        atlas_columns,
        atlas_rows,
        "shadowmap_unavailable:\{index}",
      )
      is Some(render_texture) else {
      return None
    }
    backend.shadow_render_textures[index] = render_texture
    backend.directional_shadow_tile_sizes[index] = tile_size
    backend.directional_shadow_atlas_columns[index] = atlas_columns
    backend.directional_shadow_atlas_rows[index] = atlas_rows
    return Some(render_texture)
  }
  Some(existing)
}

///|
fn upload_shadow_uniforms(
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  base_uv_set : Int,
  setup : DirectionalShadowSetup,
) -> ShadowShaderState {
  ignore(setup.half_extent)
  ignore(setup.near_plane)
  ignore(setup.far_plane)
  ignore(setup.near_bound)
  ignore(setup.far_bound)
  let state = get_shadow_shader_state()
  let shader = state.shader
  @raylib.set_shader_value_matrix(
    shader,
    state.light_view_projection_loc,
    setup.light_view_projection,
  )
  set_shader_uniform(
    shader,
    state.material_has_texture_loc,
    uniform_int(if base_source is Some(_) { 1 } else { 0 }),
  )
  set_shader_uniform(
    shader,
    state.material_alpha_mode_loc,
    uniform_int(alpha_mode_to_int(material.alpha_mode)),
  )
  set_shader_uniform(
    shader,
    state.material_alpha_cutoff_loc,
    uniform_float(material.alpha_cutoff),
  )
  let transform = base_source.map_or(
    @render3d_types.default_texture_transform3d(),
    fn(source) { source.transform },
  )
  upload_texture_transform_uniforms(
    shader,
    state.base_uv_offset_scale_loc,
    state.base_uv_rotation_loc,
    transform,
  )
  set_shader_uniform(shader, state.base_uv_set_loc, uniform_int(base_uv_set))
  state
}

///|
fn draw_shadow_mesh_with_material(
  mesh : @raylib.Mesh,
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  base_uv_set : Int,
  setup : DirectionalShadowSetup,
) -> Unit {
  if material.alpha_mode == Blend {
    return
  }
  ignore(upload_shadow_uniforms(material, base_source, base_uv_set, setup))
  let shadow_material = get_shadow_material()
  @raylib.set_material_texture(
    shadow_material,
    @raylib.MaterialMapAlbedo,
    base_source.map_or(get_white_texture(), fn(source) { source.texture }),
  )
  if material.double_sided {
    @rl.disable_backface_culling()
  } else {
    @rl.enable_backface_culling()
  }
  @raylib.draw_mesh(mesh, shadow_material, @raylib.Matrix::identity())
  @rl.disable_backface_culling()
}

///|
fn shadow_base_uv_set(base_source : MaterialTextureSource3D?) -> Int {
  match base_source {
    Some(source) => if source.texcoord_set == 1 { 1 } else { 0 }
    None => 0
  }
}

///|
fn draw_shadow_cuboid(
  size : @smath.Vec3,
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  setup : DirectionalShadowSetup,
) -> Unit {
  let key = "cube:\{size.x}:\{size.y}:\{size.z}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_cube(to_float(size.x), to_float(size.y), to_float(size.z))
  })
  draw_shadow_mesh_with_material(
    mesh,
    material,
    base_source,
    shadow_base_uv_set(base_source),
    setup,
  )
}

///|
fn draw_shadow_sphere(
  radius : Double,
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  setup : DirectionalShadowSetup,
) -> Unit {
  let key = "sphere:\{radius}:\{TEXTURED_SPHERE_SLICES}:\{TEXTURED_SPHERE_STACKS}"
  let mesh = get_or_create_primitive_mesh(key, fn() {
    @raylib.gen_mesh_sphere(
      to_float(radius),
      TEXTURED_SPHERE_SLICES,
      TEXTURED_SPHERE_STACKS,
    )
  })
  draw_shadow_mesh_with_material(
    mesh,
    material,
    base_source,
    shadow_base_uv_set(base_source),
    setup,
  )
}

///|
fn draw_shadow_cylinder(
  mesh_handle : @render3d_types.MeshHandle,
  radius_top : Double,
  radius_bottom : Double,
  height : Double,
  slices : Int,
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  setup : DirectionalShadowSetup,
) -> Unit {
  if (radius_top - radius_bottom).abs() <= 0.000001 {
    let key = "cylinder:\{radius_top}:\{height}:\{slices}"
    let mesh = get_or_create_primitive_mesh(key, fn() {
      @raylib.gen_mesh_cylinder(to_float(radius_top), to_float(height), slices)
    })
    draw_shadow_mesh_with_material(
      mesh,
      material,
      base_source,
      shadow_base_uv_set(base_source),
      setup,
    )
    return
  }
  let (vertices, uvs, _normals) = build_cylinder_mesh(
    radius_top, radius_bottom, height, slices,
  )
  draw_shadow_triangle_mesh(
    mesh_handle,
    {
      positions: vertices,
      indices: None,
      topology: TriangleList,
      uv_sets: [uvs],
      normals: None,
      tangents: None,
      colors: None,
    },
    material,
    base_source,
    setup,
  )
}

///|
fn draw_shadow_triangle_mesh(
  mesh_handle : @render3d_types.MeshHandle,
  mesh : @render3d_types.TriangleMesh3D,
  material : @render3d_types.StandardMaterial3D,
  base_source : MaterialTextureSource3D?,
  setup : DirectionalShadowSetup,
) -> Unit {
  if material.alpha_mode == Blend || mesh.positions.length() < 3 {
    return
  }
  guard resolve_triangle_indices(mesh_handle, mesh) is Some(triangle_indices) else {
    return
  }
  guard expand_vec3_with_indices(mesh.positions, triangle_indices)
    is Some(expanded_vertices) else {
    return
  }
  let normals = resolve_triangle_normals(mesh, triangle_indices)
  guard expand_vec3_with_indices(normals, triangle_indices)
    is Some(expanded_normals) else {
    return
  }
  let uv0 = mesh.uv_sets
    .get(0)
    .filter(fn(values) { values.length() == mesh.positions.length() })
  let uv1 = mesh.uv_sets
    .get(1)
    .filter(fn(values) { values.length() == mesh.positions.length() })
  let expanded_uv0 = uv0.bind(fn(values) {
    expand_vec2_with_indices(values, triangle_indices)
  })
  let expanded_uv1 = uv1.bind(fn(values) {
    expand_vec2_with_indices(values, triangle_indices)
  })
  let expanded_colors = mesh.colors.bind(fn(values) {
    if values.length() != mesh.positions.length() {
      None
    } else {
      expand_color_with_indices(values, triangle_indices)
    }
  })
  let expanded_tangents = mesh.tangents.bind(fn(values) {
    if values.length() != mesh.positions.length() {
      None
    } else {
      expand_tangent_with_indices(values, triangle_indices)
    }
  })
  let cache_key = triangle_mesh_cache_key(mesh_handle)
  let ray_mesh = if backend.triangle_mesh_cache.get(cache_key) is Some(cached) {
    cached
  } else {
    guard create_uploaded_triangle_mesh(
        expanded_vertices, expanded_uv0, expanded_uv1, expanded_normals, expanded_tangents,
        expanded_colors,
      )
      is Some(created) else {
      return
    }
    backend.triangle_mesh_cache.set(cache_key, created)
    created
  }
  let base_uv_set = match base_source {
    Some(source) => if source.texcoord_set == 1 { 1 } else { 0 }
    None => 0
  }
  let effective_base_source = match base_source {
    Some(source) =>
      if base_uv_set == 1 && expanded_uv1 is None {
        None
      } else if base_uv_set == 0 && expanded_uv0 is None {
        None
      } else {
        Some(source)
      }
    None => None
  }
  draw_shadow_mesh_with_material(
    ray_mesh, material, effective_base_source, base_uv_set, setup,
  )
}

///|
fn draw_shadow_mesh3d_instance(
  mesh_handle : @render3d_types.MeshHandle,
  mesh_asset : @render3d_types.MeshAsset,
  material : @render3d_types.StandardMaterial3D,
  transform : @render3d_types.FrameTransform3D,
  setup : DirectionalShadowSetup,
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
  let base_source = material.base_color_texture.bind(
    resolve_material_texture_source,
  )
  match mesh_asset.primitive {
    Cube(size) => draw_shadow_cuboid(size, material, base_source, setup)
    Sphere(radius) => draw_shadow_sphere(radius, material, base_source, setup)
    Cylinder(radius_top, radius_bottom, height, slices) =>
      draw_shadow_cylinder(
        mesh_handle, radius_top, radius_bottom, height, slices, material, base_source,
        setup,
      )
    Plane(size) => {
      let thickness = if size.y.abs() < 0.0001 { 0.02 } else { size.y }
      draw_shadow_cuboid(
        @smath.Vec3(size.x, thickness, size.z),
        material,
        base_source,
        setup,
      )
    }
    Triangles(mesh) =>
      draw_shadow_triangle_mesh(mesh_handle, mesh, material, base_source, setup)
  }
  @rl.pop_matrix()
}

///|
fn render_directional_shadow_map(
  frame : @render3d_types.RenderFrame3D,
  camera : @render3d_types.FrameCamera3D,
) -> FrameShadowState? {
  let shadow_map_size = normalize_shadow_map_size(
    frame.directional_shadow_map_size,
  )
  let directional_shadows : Map[Int, FrameDirectionalShadowState] = Map::new()
  for light_index in shadowed_directional_light_indices(frame) {
    let mut cascades = build_directional_shadow_cascades_for_light(
      frame, light_index, camera, shadow_map_size,
    )
    if cascades.length() == 0 {
      if build_directional_shadow_setup_for_light(frame, light_index)
        is Some(setup) {
        cascades = [
          {
            light_view_projection: setup.light_view_projection,
            atlas_rect: make_shadow_atlas_rect(
              0, 1, shadow_map_size, shadow_map_size, shadow_map_size,
            ),
            near_bound: setup.near_bound,
            far_bound: setup.far_bound,
          },
        ]
      } else {
        continue
      }
    }
    guard get_shadow_render_texture(
        light_index,
        shadow_map_size,
        cascades.length(),
      )
      is Some(render_texture) else {
      continue
    }
    let (atlas_columns, atlas_rows) = directional_shadow_atlas_layout(
      cascades.length(),
    )
    let atlas_width = shadow_map_size * atlas_columns
    let atlas_height = shadow_map_size * atlas_rows
    @raylib.begin_texture_mode(render_texture)
    @raylib.clear_background(to_ray_color(white_render_color()))
    for cascade in cascades {
      @rl.viewport(
        (cascade.atlas_rect.offset[X] * atlas_width.to_double()).to_int(),
        (cascade.atlas_rect.offset[Y] * atlas_height.to_double()).to_int(),
        shadow_map_size,
        shadow_map_size,
      )
      render_shadow_casters_for_setup(frame, camera, {
        light_view_projection: cascade.light_view_projection,
        half_extent: 0.0,
        near_plane: SHADOW_CAMERA_NEAR_MIN,
        far_plane: SHADOW_CAMERA_NEAR_MIN + 1.0,
        near_bound: cascade.near_bound,
        far_bound: cascade.far_bound,
      })
    }
    @raylib.end_texture_mode()
    let light = frame.directional_lights[light_index]
    directional_shadows.set(light_index, {
      depth_texture_id: @raylib.get_render_texture_depth_id(render_texture),
      cascades,
      depth_bias: shadow_depth_bias(light),
      normal_bias: shadow_normal_bias(light),
    })
  }
  let (spot_shadows, spot_shadow_atlas_id, spot_texel_size) = render_spot_shadow_map(
    frame, camera,
  )
  let (point_shadows, point_shadow_atlas_id, point_texel_size) = render_point_shadow_map(
    frame, camera,
  )
  if directional_shadows.length() == 0 &&
    spot_shadows.length() == 0 &&
    point_shadows.length() == 0 {
    None
  } else {
    Some({
      directional_shadows,
      spot_shadows,
      point_shadows,
      spot_shadow_atlas_id,
      point_shadow_atlas_id,
      directional_texel_size: shadow_texel_size(shadow_map_size),
      spot_texel_size,
      point_texel_size,
    })
  }
}
