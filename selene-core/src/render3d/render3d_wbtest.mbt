///|
test "render3d extract preserves mesh shadow toggles" {
  let world = @ecs.require_current_world()
  let mesh = @render3d_types.MeshHandle(9901U)
  let material = @render3d_types.MaterialHandle(9902U)
  meshes.set(mesh, cube_mesh(Vec3(1.0, 1.0, 1.0)))
  materials.set(material, StandardMaterial3D())
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
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
  @visibility.visibility_propagate_system(
    Entities(world),
    Hierarchy(world),
    world.query(),
    VisibilityState(world),
  )
  @transform.transform_propagate_system(
    Entities(world),
    Hierarchy(world),
    world.query(),
  )

  render3d_extract_system(
    Render3DQueries(world),
    ExtractedFrame3D(world),
    Camera3DState(world),
    VisibilityState(world),
  )

  let frame = get_extracted_frame3d()
  inspect(frame.items.length(), content="1")
  inspect(frame.items[0].cast_shadows, content="false")
  inspect(frame.items[0].receive_shadows, content="false")

  meshes.remove(mesh)
  materials.remove(material)
  render3d_world_state().extracted_frame = RenderFrame3D()
  ignore(@ecs_test.delete(entity))
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
  let world = @ecs.require_current_world()
  set_directional_light_shadow_map3d({ size: 1536, })
  set_point_light_shadow_map3d({ size: 768, })

  render3d_extract_system(
    Render3DQueries(world),
    ExtractedFrame3D(world),
    Camera3DState(world),
    VisibilityState(world),
  )

  let frame = get_extracted_frame3d()
  inspect(frame.directional_shadow_map_size, content="1536")
  inspect(frame.point_shadow_map_size, content="768")

  set_directional_light_shadow_map3d(DirectionalLightShadowMap3D())
  set_point_light_shadow_map3d(PointLightShadowMap3D())
  render3d_world_state().extracted_frame = RenderFrame3D()
}

///|
test "render3d cubemap assets participate in dirty and release sync" {
  let px = @asset.images.add(@asset.Image::from_bytes(b"sky/px.png"))
  let nx = @asset.images.add(@asset.Image::from_bytes(b"sky/nx.png"))
  let py = @asset.images.add(@asset.Image::from_bytes(b"sky/py.png"))
  let ny = @asset.images.add(@asset.Image::from_bytes(b"sky/ny.png"))
  let pz = @asset.images.add(@asset.Image::from_bytes(b"sky/pz.png"))
  let nz = @asset.images.add(@asset.Image::from_bytes(b"sky/nz.png"))

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
  ignore(@asset.images.remove(px))
  ignore(@asset.images.remove(nx))
  ignore(@asset.images.remove(py))
  ignore(@asset.images.remove(ny))
  ignore(@asset.images.remove(pz))
  ignore(@asset.images.remove(nz))
}

///|
test "render3d extracts skybox from active camera" {
  let world = @ecs.require_current_world()
  let px = @asset.images.add(@asset.Image::from_bytes(b"sky/px.png"))
  let nx = @asset.images.add(@asset.Image::from_bytes(b"sky/nx.png"))
  let py = @asset.images.add(@asset.Image::from_bytes(b"sky/py.png"))
  let ny = @asset.images.add(@asset.Image::from_bytes(b"sky/ny.png"))
  let pz = @asset.images.add(@asset.Image::from_bytes(b"sky/pz.png"))
  let nz = @asset.images.add(@asset.Image::from_bytes(b"sky/nz.png"))
  let cubemap = register_cubemap_asset(
    cubemap_asset_six_faces(CubemapFaces3D(px, nx, py, ny, pz, nz)),
  )
  let skybox = Skybox3D(cubemap, brightness=0.75)
  let camera_entity = @ecs_test.spawn1(@ecs.require_current_world(), skybox)
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

  render3d_extract_system(
    Render3DQueries(world),
    ExtractedFrame3D(world),
    Camera3DState(world),
    VisibilityState(world),
  )

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
  ignore(@asset.images.remove(px))
  ignore(@asset.images.remove(nx))
  ignore(@asset.images.remove(py))
  ignore(@asset.images.remove(ny))
  ignore(@asset.images.remove(pz))
  ignore(@asset.images.remove(nz))
  ignore(take_dirty_cubemap_assets())
  ignore(take_released_cubemap_assets())
  ignore(@ecs_test.delete(camera_entity))
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
