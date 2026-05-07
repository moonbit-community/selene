///|
fn raylib_test_apply_shader_texture_transform(
  transform : @render3d_types.TextureTransform3D,
  uv : @smath.Vec2,
) -> @smath.Vec2 {
  let (offset_x, offset_y, scale_x, scale_y) = texture_transform_offset_scale(
    transform,
  )
  let rotation = texture_transform_rotation_sin_cos(transform)
  let scaled = @smath.Vec2(uv[X] * scale_x, uv[Y] * scale_y)
  @smath.Vec2(
    scaled[X] * rotation[Y] - scaled[Y] * rotation[X] + offset_x,
    scaled[X] * rotation[X] + scaled[Y] * rotation[Y] + offset_y,
  )
}

///|
test "raylib shader texture transform helpers match render3d apply_texture_transform3d" {
  let transform : @render3d_types.TextureTransform3D = {
    offset: @smath.Vec2(0.25, 0.5),
    scale: @smath.Vec2(0.75, 0.125),
    rotation: 0.7853981633974483,
  }
  let uv = @smath.Vec2(0.2, 0.8)
  inspect(
    raylib_test_apply_shader_texture_transform(transform, uv) ==
    @render3d_types.apply_texture_transform3d(transform, uv),
    content="true",
  )
}

///|
test "raylib shader texture transform helpers preserve default identity uniforms" {
  let transform = @render3d_types.default_texture_transform3d()
  let (offset_x, offset_y, scale_x, scale_y) = texture_transform_offset_scale(
    transform,
  )
  let rotation = texture_transform_rotation_sin_cos(transform)
  inspect(offset_x, content="0")
  inspect(offset_y, content="0")
  inspect(scale_x, content="1")
  inspect(scale_y, content="1")
  inspect(rotation[X], content="0")
  inspect(rotation[Y], content="1")
}

///|
test "raylib lighting shader falls back to scalar factors when no textures are bound" {
  inspect(
    raylib_lighting_fragment_shader.contains("vec4 albedoSample = vec4(1.0);"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "if (materialHasBaseTexture != 0) albedoSample = texture(texture0, baseUv);",
    ),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "vec4 metallicRoughnessSample = vec4(1.0);",
    ),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "if (materialHasMetallicRoughnessTexture != 0) {",
    ),
    content="true",
  )
  inspect(
    !raylib_lighting_fragment_shader.contains("uniform sampler2D texture3;"),
    content="true",
  )
  inspect(
    !raylib_lighting_fragment_shader.contains("materialHasRoughnessTexture"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "float roughness = clamp(materialRoughness * metallicRoughnessSample.g, 0.089, 1.0);",
    ),
    content="true",
  )
  inspect(
    !raylib_lighting_fragment_shader.contains("roughnessUv"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "if (materialHasNormalTexture != 0) normal = applyNormalMap(normal, fragPosition, normalUv);",
    ),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains("float occlusion = 1.0;"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "if (materialHasOcclusionTexture != 0) {",
    ),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "vec3 emissive = materialEmissiveColor;",
    ),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains(
      "if (materialHasEmissiveTexture != 0) {",
    ),
    content="true",
  )
}

///|
test "raylib lighting texture units upload as int uniforms for raylib compatibility" {
  let data = uniform_texture_unit(3)
  match data {
    @raylib.ShaderUniformData::Int(slot) => inspect(slot, content="3")
    _ => fail("expected int uniform data for texture unit")
  }
}

///|
test "raylib material texture slot bindings stay complete for active maps" {
  let bindings = material_texture_slot_bindings()
  inspect(bindings.length(), content="5")
  inspect(bindings[0].uniform_name, content="texture0")
  inspect(bindings[0].slot, content="0")
  inspect(bindings[0].shader_loc == @raylib.ShaderLocMapAlbedo, content="true")
  inspect(bindings[0].material_map == @raylib.MaterialMapAlbedo, content="true")
  inspect(bindings[1].uniform_name, content="texture1")
  inspect(bindings[1].slot, content="1")
  inspect(
    bindings[1].shader_loc == @raylib.ShaderLocMapMetalness,
    content="true",
  )
  inspect(
    bindings[1].material_map == @raylib.MaterialMapMetalness,
    content="true",
  )
  inspect(bindings[2].uniform_name, content="texture2")
  inspect(bindings[2].slot, content="2")
  inspect(bindings[2].shader_loc == @raylib.ShaderLocMapNormal, content="true")
  inspect(bindings[2].material_map == @raylib.MaterialMapNormal, content="true")
  inspect(bindings[3].uniform_name, content="texture4")
  inspect(bindings[3].slot, content="4")
  inspect(
    bindings[3].shader_loc == @raylib.ShaderLocMapOcclusion,
    content="true",
  )
  inspect(
    bindings[3].material_map == @raylib.MaterialMapOcclusion,
    content="true",
  )
  inspect(bindings[4].uniform_name, content="texture5")
  inspect(bindings[4].slot, content="5")
  inspect(
    bindings[4].shader_loc == @raylib.ShaderLocMapEmission,
    content="true",
  )
  inspect(
    bindings[4].material_map == @raylib.MaterialMapEmission,
    content="true",
  )
}

///|
test "raylib triangle topology indices resolve strip and fan to triangle list" {
  let strip_mesh : @render3d_types.TriangleMesh3D = {
    positions: [
      @smath.Vec3(0.0, 0.0, 0.0),
      @smath.Vec3(1.0, 0.0, 0.0),
      @smath.Vec3(0.0, 1.0, 0.0),
      @smath.Vec3(1.0, 1.0, 0.0),
    ],
    indices: Some([0, 1, 2, 3]),
    topology: TriangleStrip,
    uv_sets: [],
    normals: None,
    tangents: None,
    colors: None,
  }
  let fan_mesh : @render3d_types.TriangleMesh3D = {
    ..strip_mesh,
    topology: TriangleFan,
  }
  debug_inspect(
    resolve_triangle_indices(@render3d_types.MeshHandle(1U), strip_mesh),
    content="Some([0, 1, 2, 2, 1, 3])",
  )
  debug_inspect(
    resolve_triangle_indices(@render3d_types.MeshHandle(2U), fan_mesh),
    content="Some([0, 1, 2, 0, 2, 3])",
  )
}

///|
test "raylib lighting shader exposes secondary uv and tangent controls" {
  inspect(
    raylib_lighting_vertex_shader.contains("in vec2 vertexTexCoord2;"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains("uniform int materialHasTangents;"),
    content="true",
  )
  inspect(
    raylib_lighting_fragment_shader.contains("vec2 selectUv(int setIndex) {"),
    content="true",
  )
}

///|
test "raylib text fallback measurement matches default spacing behavior" {
  inspect(RAYLIB_DEFAULT_TEXT_SPACING, content="1")
}
