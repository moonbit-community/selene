///|
test "render3d extract preserves mesh shadow toggles" {
  let mesh = @render3d_types.MeshHandle(9901U)
  let material = @render3d_types.MaterialHandle(9902U)
  meshes.set(mesh, cube_mesh(Vec3(1.0, 1.0, 1.0)))
  materials.set(material, StandardMaterial3D())
  let entity = @ecs.require_current_world().spawn(
    (
      Mesh3DRenderer::{
        mesh,
        material,
        visible: true,
        cast_shadows: false,
        receive_shadows: false,
      },
      @transform.Spatial(@transform.Transform::identity()),
      @visibility.Visibility::Visible,
    ),
  )
  @visibility.visibility_propagate_system(0.0)
  @transform.transform_propagate_system(0.0)

  render3d_extract_system(0.0)

  let frame = get_extracted_frame3d()
  inspect(frame.items.length(), content="1")
  inspect(frame.items[0].cast_shadows, content="false")
  inspect(frame.items[0].receive_shadows, content="false")

  meshes.remove(mesh)
  materials.remove(material)
  render3d_world_state().extracted_frame = RenderFrame3D()
  ignore(entity.delete())
}

///|
test "render3d camera culling context reuses frame constants" {
  let camera : @render3d_types.FrameCamera3D = {
    position: Vec3(0.0, 0.0, 10.0),
    target: @math.Vec3::zero(),
    up: @math.Vec3::y_axis(),
    fov_y: 60.0,
    projection: Perspective,
    orthographic_size: None,
    near: 0.1,
    far: 100.0,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0, },
  }
  let mesh = cube_mesh(Vec3(1.0, 1.0, 1.0))
  let visible_transform : @transform.Transform = {
    translation: @math.Vec3::zero(),
    rotation: @math.Rotation3::identity(),
    scale: @math.Vec3::one(),
  }
  let hidden_transform : @transform.Transform = {
    translation: Vec3(100.0, 0.0, 0.0),
    rotation: @math.Rotation3::identity(),
    scale: @math.Vec3::one(),
  }
  let context = camera_culling_context(camera)
  inspect(
    is_visible_in_camera_culling_context(
      context,
      mesh,
      visible_transform.compute_affine(),
    ),
    content="true",
  )
  inspect(
    is_visible_in_camera_culling_context(
      context,
      mesh,
      hidden_transform.compute_affine(),
    ),
    content="false",
  )
  inspect(
    _is_visible_in_camera_frustum(
      camera,
      mesh,
      visible_transform.compute_affine(),
    ),
    content="true",
  )
}

///|
test "render3d point and spot defaults include Bevy-aligned shadow settings" {
  let point = PointLight3D()
  inspect(point.shadows, content="false")
  inspect(point.shadow_depth_bias == 0.08, content="true")
  inspect(point.shadow_normal_bias == 0.6, content="true")
  inspect(point.shadow_map_near_z == 0.1, content="true")

  let spot = SpotLight3D()
  inspect(spot.shadows, content="false")
  inspect(spot.shadow_depth_bias == 0.02, content="true")
  inspect(spot.shadow_normal_bias == 1.8, content="true")
  inspect(spot.shadow_map_near_z == 0.1, content="true")
}

///|
test "render3d directional defaults include Bevy-aligned cascade config" {
  let builder = CascadeShadowConfigBuilder3D()
  inspect(builder.num_cascades, content="4")
  inspect(builder.minimum_distance == 0.1, content="true")
  inspect(builder.maximum_distance == 150.0, content="true")
  inspect(builder.first_cascade_far_bound == 10.0, content="true")
  inspect(builder.overlap_proportion == 0.2, content="true")

  let config = DirectionalLight3D().cascade_shadow_config
  inspect(config.minimum_distance == 0.1, content="true")
  inspect(config.overlap_proportion == 0.2, content="true")
  inspect(config.bounds.length(), content="4")
  inspect(config.bounds[0] == 10.0, content="true")
  inspect(
    (config.bounds[1] - 24.662120743304698).abs() < 0.000001,
    content="true",
  )
  inspect(
    (config.bounds[2] - 60.82201995573399).abs() < 0.000001,
    content="true",
  )
  inspect((config.bounds[3] - 150.0).abs() < 0.000001, content="true")
}

///|
test "render3d extract preserves shadow map size resources" {
  set_directional_light_shadow_map3d({ size: 1536, })
  set_point_light_shadow_map3d({ size: 768, })

  render3d_extract_system(0.0)

  let frame = get_extracted_frame3d()
  inspect(frame.directional_shadow_map_size, content="1536")
  inspect(frame.point_shadow_map_size, content="768")

  set_directional_light_shadow_map3d(DirectionalLightShadowMap3D())
  set_point_light_shadow_map3d(PointLightShadowMap3D())
  render3d_world_state().extracted_frame = RenderFrame3D()
}

///|
test "render3d cubemap assets participate in dirty and release sync" {
  let px = register_image_asset({ path: "sky/px.png", })
  let nx = register_image_asset({ path: "sky/nx.png", })
  let py = register_image_asset({ path: "sky/py.png", })
  let ny = register_image_asset({ path: "sky/ny.png", })
  let pz = register_image_asset({ path: "sky/pz.png", })
  let nz = register_image_asset({ path: "sky/nz.png", })
  ignore(take_dirty_image_assets())

  let cubemap = register_cubemap_asset(
    cubemap_asset_six_faces(CubemapFaces3D(px, nx, py, ny, pz, nz)),
  )
  let dirty = take_dirty_cubemap_assets()
  inspect(dirty.length(), content="1")
  inspect(dirty[0].0 == cubemap, content="true")

  update_cubemap_asset(
    cubemap,
    cubemap_asset_six_faces(CubemapFaces3D(nx, px, py, ny, pz, nz)),
  )
  inspect(take_dirty_cubemap_assets().length(), content="1")

  release_cubemap_asset(cubemap)
  inspect(take_released_cubemap_assets().length(), content="1")
  inspect(cubemap_asset(cubemap) is None, content="true")
  release_image_asset(px)
  release_image_asset(nx)
  release_image_asset(py)
  release_image_asset(ny)
  release_image_asset(pz)
  release_image_asset(nz)
  ignore(take_released_image_assets())
}

///|
test "render3d extracts skybox from active camera" {
  let px = register_image_asset({ path: "sky/px.png", })
  let nx = register_image_asset({ path: "sky/nx.png", })
  let py = register_image_asset({ path: "sky/py.png", })
  let ny = register_image_asset({ path: "sky/ny.png", })
  let pz = register_image_asset({ path: "sky/pz.png", })
  let nz = register_image_asset({ path: "sky/nz.png", })
  let cubemap = register_cubemap_asset(
    cubemap_asset_six_faces(CubemapFaces3D(px, nx, py, ny, pz, nz)),
  )
  let skybox = Skybox3D(cubemap, brightness=0.75)
  let camera_entity = @ecs.require_current_world().spawn1(skybox)
  @camera3d.set_active_camera3d(
    Some({
      entity: camera_entity,
      camera: {
        position: Vec3(0.0, 0.0, 10.0),
        target: @math.Vec3::zero(),
        up: @math.Vec3::y_axis(),
        fov_y: 60.0,
        projection: Perspective,
        orthographic_size: None,
        near: 0.1,
        far: 100.0,
        clear_color: { r: 8U, g: 9U, b: 10U, a: 1.0, },
      },
    }),
  )

  render3d_extract_system(0.0)

  let frame = get_extracted_frame3d()
  inspect(frame.clear_color.r, content="8")
  match frame.skybox {
    Some(extracted) => {
      inspect(extracted.cubemap == cubemap, content="true")
      inspect(extracted.brightness == 0.75, content="true")
    }
    None => inspect("missing", content="skybox")
  }

  @camera3d.set_active_camera3d(None)
  render3d_world_state().extracted_frame = RenderFrame3D()
  release_cubemap_asset(cubemap)
  release_image_asset(px)
  release_image_asset(nx)
  release_image_asset(py)
  release_image_asset(ny)
  release_image_asset(pz)
  release_image_asset(nz)
  ignore(take_dirty_image_assets())
  ignore(take_dirty_cubemap_assets())
  ignore(take_released_image_assets())
  ignore(take_released_cubemap_assets())
  ignore(camera_entity.delete())
}

///|
test "render3d cascade config builder clamps invalid ranges" {
  let config = build_cascade_shadow_config3d({
    num_cascades: 0,
    minimum_distance: -3.0,
    maximum_distance: 0.0,
    first_cascade_far_bound: -2.0,
    overlap_proportion: 2.0,
  })
  inspect(config.minimum_distance == 0.0, content="true")
  inspect(config.overlap_proportion == 1.0, content="true")
  inspect(config.bounds.length(), content="1")
  inspect(config.bounds[0] == 1.0, content="true")
}

///|
test "orthographic culling retains a cube whose shear reaches into the viewport" {
  let camera : @render3d_types.FrameCamera3D = {
    position: Vec3(0.0, 0.0, 10.0),
    target: @math.Vec3::zero(),
    up: @math.Vec3::y_axis(),
    fov_y: 60.0,
    projection: Orthographic,
    orthographic_size: Some(Vec2(2.0, 2.0)),
    near: 0.1,
    far: 100.0,
    clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0, },
  }
  let transform : @math.Affine3 = {
    ..@math.Affine3::identity(),
    translation: Vec3(1.95, 0.0, 0.0),
    y_axis: Vec3(1.0, 0.1, 0.0),
  }
  assert_true(
    _is_visible_in_camera_frustum(
      camera,
      cube_mesh(Vec3(1.0, 1.0, 1.0)),
      transform,
    ),
  )
}
