///|
fn webgpu_test_handle(id : Int) -> @render3d_types.ImageHandle {
  @render3d_types.ImageHandle(id.reinterpret_as_uint())
}

///|
fn webgpu_test_sync_image(
  handle : @render3d_types.ImageHandle,
  path : String,
) -> Unit {
  synced_image_assets.set(handle, { path, })
}

///|
fn webgpu_test_uv(x : Double, y : Double) -> @smath.Vec2 {
  @smath.Vec2(x, y)
}

///|
fn webgpu_test_mesh(
  uv_sets : Array[Array[@smath.Vec2]],
) -> @render3d_types.TriangleMesh3D {
  {
    positions: [
      @smath.Vec3::new(0.0, 0.0, 0.0),
      @smath.Vec3::new(1.0, 0.0, 0.0),
      @smath.Vec3::new(0.0, 1.0, 0.0),
    ],
    indices: None,
    topology: TriangleList,
    uv_sets,
    normals: None,
    tangents: None,
    colors: None,
  }
}

///|
test "pack_directional_light_data includes shadow metadata and cascade bounds" {
  let frame = @render3d_types.empty_render_frame3d()
  frame.directional_lights = [
    {
      direction: @smath.Vec3::new(0.0, -2.0, 0.0),
      color: { r: 64U, g: 128U, b: 255U, a: 1.0 },
      intensity: 1.5,
      shadows: true,
      shadow_depth_bias: 0.02,
      shadow_normal_bias: 1.1,
      cascade_shadow_config: {
        bounds: [8.0, 24.0],
        minimum_distance: 0.5,
        overlap_proportion: 0.25,
      },
    },
  ]
  let packed = pack_directional_light_data(frame)
  inspect(packed.length(), content="17")
  inspect(packed[0], content="0")
  inspect(packed[1], content="-1")
  inspect(packed[2], content="0")
  inspect(packed[3], content="1.5")
  inspect((packed[4] - 64.0 / 255.0).abs() < 0.000001, content="true")
  inspect((packed[5] - 128.0 / 255.0).abs() < 0.000001, content="true")
  inspect(packed[6], content="1")
  inspect(packed[7], content="1")
  inspect(packed[8], content="0.02")
  inspect(packed[9], content="1.1")
  inspect(packed[10], content="2")
  inspect(packed[11], content="0.5")
  inspect(packed[12], content="0.25")
  inspect(packed[13], content="8")
  inspect(packed[14], content="24")
  inspect(packed[15], content="24")
  inspect(packed[16], content="24")
}

///|
test "pack_point_light_data and pack_spot_light_data include shadow metadata" {
  let frame = @render3d_types.empty_render_frame3d()
  frame.point_lights = [
    {
      position: @smath.Vec3::new(1.0, 2.0, 3.0),
      color: { r: 255U, g: 64U, b: 32U, a: 1.0 },
      intensity: 2.0,
      range: 12.5,
      shadows: true,
      shadow_depth_bias: 0.03,
      shadow_normal_bias: 0.8,
      shadow_map_near_z: 0.15,
    },
  ]
  frame.spot_lights = [
    {
      position: @smath.Vec3::new(4.0, 5.0, 6.0),
      direction: @smath.Vec3::new(0.0, -2.0, 0.0),
      color: { r: 32U, g: 160U, b: 255U, a: 1.0 },
      intensity: 3.0,
      range: 16.0,
      shadows: true,
      shadow_depth_bias: 0.04,
      shadow_normal_bias: 0.9,
      shadow_map_near_z: 0.2,
      inner_angle: 0.25,
      outer_angle: 0.5,
    },
  ]
  let point_packed = pack_point_light_data(frame)
  inspect(point_packed.length(), content="12")
  inspect(point_packed[7], content="12.5")
  inspect(point_packed[8], content="1")
  inspect(point_packed[9], content="0.03")
  inspect(point_packed[10], content="0.8")
  inspect(point_packed[11], content="0.15")

  let spot_packed = pack_spot_light_data(frame)
  inspect(spot_packed.length(), content="17")
  inspect(spot_packed[8], content="0")
  inspect(spot_packed[9], content="-1")
  inspect(spot_packed[10], content="0")
  inspect((spot_packed[11] - @math.cos(0.25)).abs() < 0.000001, content="true")
  inspect((spot_packed[12] - @math.cos(0.5)).abs() < 0.000001, content="true")
  inspect(spot_packed[13], content="1")
  inspect(spot_packed[14], content="0.04")
  inspect(spot_packed[15], content="0.9")
  inspect(spot_packed[16], content="0.2")
}

///|
test "resolve_material_texture_bundle keeps independent UV channels when samplers match" {
  let sampler = @render3d_types.default_texture_sampler3d()
  let base_handle = webgpu_test_handle(9000)
  let emissive_handle = webgpu_test_handle(9001)
  let occlusion_handle = webgpu_test_handle(9002)
  webgpu_test_sync_image(base_handle, "wbtest://base")
  webgpu_test_sync_image(emissive_handle, "wbtest://emissive")
  webgpu_test_sync_image(occlusion_handle, "wbtest://occlusion")
  let material = {
    ..@render3d_types.default_standard_material3d(),
    base_color_texture: Some(
      @render3d_types.texture_binding3d(base_handle, texcoord_set=1, sampler~),
    ),
    emissive_texture: Some(
      @render3d_types.texture_binding3d(
        emissive_handle,
        texcoord_set=3,
        sampler~,
      ),
    ),
    occlusion_texture: Some(
      @render3d_types.texture_binding3d(
        occlusion_handle,
        texcoord_set=5,
        sampler~,
      ),
    ),
  }
  let bundle = resolve_material_texture_bundle(material).unwrap()
  inspect(bundle.primary_texcoord_set, content="1")
  inspect(bundle.base_source.unwrap().texcoord_set, content="1")
  inspect(bundle.base_source.unwrap().sampler_code, content="3")
  inspect(bundle.emissive_source.unwrap().texcoord_set, content="3")
  inspect(bundle.emissive_source.unwrap().sampler_code, content="3")
  inspect(bundle.occlusion_source.unwrap().texcoord_set, content="5")
  inspect(bundle.occlusion_source.unwrap().sampler_code, content="3")
}

///|
test "resolve_material_texture_bundle keeps textures with independent sampler codes" {
  let repeat_sampler = @render3d_types.default_texture_sampler3d()
  let clamp_sampler = {
    ..repeat_sampler,
    wrap_u: @render3d_types.TextureWrap3D::ClampToEdge,
    wrap_v: @render3d_types.TextureWrap3D::ClampToEdge,
  }
  let base_handle = webgpu_test_handle(9010)
  let emissive_handle = webgpu_test_handle(9011)
  webgpu_test_sync_image(base_handle, "wbtest://base-repeat")
  webgpu_test_sync_image(emissive_handle, "wbtest://emissive-clamp")
  let material = {
    ..@render3d_types.default_standard_material3d(),
    base_color_texture: Some(
      @render3d_types.texture_binding3d(
        base_handle,
        texcoord_set=0,
        sampler=repeat_sampler,
      ),
    ),
    emissive_texture: Some(
      @render3d_types.texture_binding3d(
        emissive_handle,
        texcoord_set=1,
        sampler=clamp_sampler,
      ),
    ),
  }
  let bundle = resolve_material_texture_bundle(material).unwrap()
  inspect(bundle.base_source is Some(_), content="true")
  inspect(bundle.emissive_source is Some(_), content="true")
  inspect(bundle.base_source.unwrap().sampler_code, content="3")
  inspect(bundle.emissive_source.unwrap().sampler_code, content="0")
}

///|
test "resolve_material_texture_input applies bound texture transforms and falls back on missing UV sets" {
  let mesh = webgpu_test_mesh([
    [
      webgpu_test_uv(0.0, 0.0),
      webgpu_test_uv(1.0, 0.0),
      webgpu_test_uv(0.0, 1.0),
    ],
    [
      webgpu_test_uv(0.5, 0.5),
      webgpu_test_uv(0.75, 0.5),
      webgpu_test_uv(0.5, 0.75),
    ],
  ])
  let fallback_uvs = mesh.uv_sets[0]
  let transformed_input = resolve_material_texture_input(
    mesh,
    Some({ path: "wbtest://emissive", texcoord_set: 1, sampler_code: 3 }),
    fallback_uvs,
    transform_binding=Some({
      ..@render3d_types.texture_binding3d(
        webgpu_test_handle(9020),
        texcoord_set=1,
      ),
      transform: {
        offset: webgpu_test_uv(0.25, 0.5),
        scale: webgpu_test_uv(2.0, 1.0),
        rotation: 0.0,
      },
    }),
  )
  inspect(transformed_input.path, content="wbtest://emissive")
  inspect(transformed_input.sampler_code, content="3")
  inspect(transformed_input.uvs[0][X], content="1.25")
  inspect(transformed_input.uvs[0][Y], content="1")
  let fallback_input = resolve_material_texture_input(
    mesh,
    Some({ path: "wbtest://missing", texcoord_set: 4, sampler_code: 3 }),
    fallback_uvs,
  )
  inspect(fallback_input.path, content="")
  inspect(fallback_input.sampler_code, content="0")
  inspect(fallback_input.uvs[1][X], content="1")
  inspect(fallback_input.uvs[1][Y], content="0")
}

///|
test "flatten_colored_vertices3d packs unlit material metadata" {
  let mesh = webgpu_test_mesh([
    [
      webgpu_test_uv(0.0, 0.0),
      webgpu_test_uv(1.0, 0.0),
      webgpu_test_uv(0.0, 1.0),
    ],
  ])
  let values = flatten_colored_vertices3d(
    mesh.positions,
    [0, 1, 2],
    [
      @smath.Vec3::new(0.0, 0.0, 1.0),
      @smath.Vec3::new(0.0, 0.0, 1.0),
      @smath.Vec3::new(0.0, 0.0, 1.0),
    ],
    None,
    @smath.Vec3::new(1.0, 1.0, 1.0),
    {
      ..@render3d_types.default_standard_material3d(),
      alpha_mode: @render3d_types.AlphaMode3D::Mask,
      alpha_cutoff: 0.25,
      unlit: true,
    },
    { r: 255U, g: 128U, b: 64U, a: 0.75 },
    true,
  )
  inspect(values.length(), content="51")
  inspect(values[13], content="1")
  inspect(values[14], content="0.25")
  inspect(values[15], content="1")
  inspect(values[16], content="1")
}

///|
test "flatten_textured_vertices3d packs unlit surface metadata" {
  let mesh = webgpu_test_mesh([
    [
      webgpu_test_uv(0.0, 0.0),
      webgpu_test_uv(1.0, 0.0),
      webgpu_test_uv(0.0, 1.0),
    ],
  ])
  let values = flatten_textured_vertices3d(
    mesh.positions,
    [0, 1, 2],
    mesh.uv_sets[0],
    mesh.uv_sets[0],
    mesh.uv_sets[0],
    mesh.uv_sets[0],
    mesh.uv_sets[0],
    [
      @smath.Vec3::new(0.0, 0.0, 1.0),
      @smath.Vec3::new(0.0, 0.0, 1.0),
      @smath.Vec3::new(0.0, 0.0, 1.0),
    ],
    [
      { x: 1.0, y: 0.0, z: 0.0, w: 1.0 },
      { x: 1.0, y: 0.0, z: 0.0, w: 1.0 },
      { x: 1.0, y: 0.0, z: 0.0, w: 1.0 },
    ],
    None,
    @smath.Vec3::new(1.0, 1.0, 1.0),
    {
      ..@render3d_types.default_standard_material3d(),
      occlusion_strength: 0.5,
      normal_scale: 0.75,
      unlit: true,
    },
    { r: 255U, g: 255U, b: 255U, a: 1.0 },
    false,
  )
  inspect(values.length(), content="105")
  inspect(values[31], content="0.5")
  inspect(values[32], content="0.75")
  inspect(values[33], content="1")
  inspect(values[34], content="0")
}

///|
test "resolve_triangle_indices supports strip and fan topology" {
  let mesh : @render3d_types.TriangleMesh3D = {
    positions: [
      @smath.Vec3::new(0.0, 0.0, 0.0),
      @smath.Vec3::new(1.0, 0.0, 0.0),
      @smath.Vec3::new(0.0, 1.0, 0.0),
      @smath.Vec3::new(1.0, 1.0, 0.0),
    ],
    indices: Some([0, 1, 2, 3]),
    topology: TriangleStrip,
    uv_sets: [],
    normals: None,
    tangents: None,
    colors: None,
  }
  inspect(resolve_triangle_indices(mesh), content="Some([0, 1, 2, 2, 1, 3])")
  inspect(
    resolve_triangle_indices({ ..mesh, topology: TriangleFan }),
    content="Some([0, 1, 2, 0, 2, 3])",
  )
}

///|
test "textured primitive mesh builders provide aligned position/uv/normal streams" {
  let cuboid = build_cuboid_triangle_mesh3d(2.0, 4.0, 6.0)
  inspect(cuboid.positions.length(), content="36")
  inspect(cuboid.uv_sets.length(), content="1")
  inspect(cuboid.uv_sets[0].length(), content="36")
  inspect(cuboid.normals.unwrap().length(), content="36")

  let sphere = build_sphere_triangle_mesh3d(1.0, 8, 6)
  inspect(sphere.positions.length() > 0, content="true")
  inspect(
    sphere.positions.length() == sphere.uv_sets[0].length(),
    content="true",
  )
  inspect(
    sphere.positions.length() == sphere.normals.unwrap().length(),
    content="true",
  )

  let cylinder = build_cylinder_triangle_mesh3d(0.75, 1.0, 2.0, 12)
  inspect(cylinder.positions.length() > 0, content="true")
  inspect(
    cylinder.positions.length() == cylinder.uv_sets[0].length(),
    content="true",
  )
  inspect(
    cylinder.positions.length() == cylinder.normals.unwrap().length(),
    content="true",
  )
}
