///|
test "raylib directional shadow helper chooses a stable up axis" {
  inspect(
    choose_shadow_up(@smath.Vec3::new(0.0, -1.0, 0.0)) ==
    @smath.Vec3::new(0.0, 0.0, 1.0),
    content="true",
  )
  inspect(
    choose_shadow_up(@smath.Vec3::new(1.0, -1.0, 0.0)) ==
    @smath.Vec3::new(0.0, 1.0, 0.0),
    content="true",
  )
}

///|
test "raylib directional shadow helper picks enabled lights in frame order" {
  let frame = @render3d_types.empty_render_frame3d()
  frame.directional_lights = [
    {
      ..@render3d_types.default_directional_light3d(),
      direction: @smath.Vec3::new(0.0, -1.0, 0.0),
      color: white_render_color(),
      intensity: 1.0,
      shadows: false,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      direction: @smath.Vec3::new(1.0, -1.0, 0.0),
      color: white_render_color(),
      intensity: 2.0,
      shadows: true,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      direction: @smath.Vec3::new(-1.0, -1.0, 0.0),
      color: white_render_color(),
      intensity: 3.0,
      shadows: true,
    },
  ]
  inspect(shadowed_directional_light_indices(frame), content="[1, 2]")
}

///|
test "raylib directional shadow helper keeps enabled light order within the shader limit" {
  let frame = @render3d_types.empty_render_frame3d()
  frame.directional_lights = [
    {
      ..@render3d_types.default_directional_light3d(),
      shadows: false,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      shadows: true,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      shadows: true,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      shadows: false,
    },
    {
      ..@render3d_types.default_directional_light3d(),
      shadows: true,
    },
  ]
  inspect(shadowed_directional_light_indices(frame), content="[1, 2]")
}

///|
test "raylib directional shadow helper clamps negative bias values" {
  let light : @render3d_types.DirectionalLight3D = {
    ..@render3d_types.default_directional_light3d(),
    shadows: true,
    shadow_depth_bias: -0.5,
    shadow_normal_bias: -2.0,
  }
  inspect(shadow_depth_bias(light), content="0")
  inspect(shadow_normal_bias(light), content="0")
}

///|
test "raylib directional shadow helper builds Bevy-aligned cascade bounds" {
  let light = {
    ..@render3d_types.default_directional_light3d(),
    shadows: true,
  }
  let camera : @render3d_types.FrameCamera3D = {
    position: @smath.Vec3::new(0.0, 2.0, 8.0),
    target: @smath.Vec3::new(0.0, 1.0, 0.0),
    up: @smath.Vec3::new(0.0, 1.0, 0.0),
    fov_y: 60.0,
    projection: Perspective,
    orthographic_size: None,
    near: 0.1,
    far: 120.0,
    clear_color: white_render_color(),
  }
  let bounds = directional_shadow_bounds(light, camera)
  inspect(bounds.length(), content="4")
  inspect(bounds[0].0 == 0.1, content="true")
  inspect(bounds[0].1 == 10.0, content="true")
  inspect(bounds[1].0 == 8.0, content="true")
  inspect((bounds[1].1 - 24.662120743304698).abs() < 0.000001, content="true")
  inspect(bounds[2].0 > bounds[1].0, content="true")
  inspect(bounds[3].1 == 120.0, content="true")
}

///|
test "raylib directional shadow helper builds cascade atlas states" {
  let frame = @render3d_types.empty_render_frame3d()
  frame.directional_lights = [
    {
      ..@render3d_types.default_directional_light3d(),
      direction: @smath.Vec3::new(1.0, -2.0, -0.5),
      color: white_render_color(),
      intensity: 1.0,
      shadows: true,
    },
  ]
  let camera : @render3d_types.FrameCamera3D = {
    position: @smath.Vec3::new(0.0, 3.0, 9.0),
    target: @smath.Vec3::new(0.0, 1.0, 0.0),
    up: @smath.Vec3::new(0.0, 1.0, 0.0),
    fov_y: 55.0,
    projection: Perspective,
    orthographic_size: None,
    near: 0.1,
    far: 80.0,
    clear_color: white_render_color(),
  }
  let cascades = build_directional_shadow_cascades_for_light(frame, 0, camera, 1024)
  inspect(cascades.length(), content="4")
  inspect(cascades[0].near_bound == 0.1, content="true")
  inspect(cascades[0].far_bound == 10.0, content="true")
  inspect(cascades[0].atlas_rect.offset == @smath.Vec2D(0.0, 0.0), content="true")
  inspect(cascades[0].atlas_rect.scale == @smath.Vec2D(0.5, 0.5), content="true")
  inspect(cascades[3].atlas_rect.offset == @smath.Vec2D(0.5, 0.5), content="true")
  inspect(cascades[3].atlas_rect.scale == @smath.Vec2D(0.5, 0.5), content="true")
}

///|
test "raylib local shadow helper keeps only shadow casters" {
  let mesh = @render3d_types.MeshHandle(9101U)
  let material = @render3d_types.MaterialHandle(9102U)
  let frame = @render3d_types.empty_render_frame3d()
  frame.items = [
    {
      transform: {
        translation: @smath.Vec3::new(0.0, 0.0, 0.0),
        rotation: @smath.Quat::identity(),
        scale: @smath.Vec3::new(1.0, 1.0, 1.0),
      },
      mesh,
      material,
      cast_shadows: false,
      receive_shadows: true,
    },
    {
      transform: {
        translation: @smath.Vec3::new(1.0, 2.0, 3.0),
        rotation: @smath.Quat::identity(),
        scale: @smath.Vec3::new(1.0, 1.0, 1.0),
      },
      mesh,
      material,
      cast_shadows: true,
      receive_shadows: false,
    },
  ]
  let casters = shadow_caster_items(frame)
  inspect(casters.length(), content="1")
  inspect(casters[0].cast_shadows, content="true")
  inspect(casters[0].receive_shadows, content="false")
}

///|
test "raylib local shadow helpers build clamped projected setups" {
  let spot_setup = build_spot_shadow_setup({
    position: @smath.Vec3::new(0.0, 4.0, 2.0),
    direction: @smath.Vec3::new(0.0, -1.0, 0.0),
    color: white_render_color(),
    intensity: 1.0,
    range: 12.0,
    shadows: true,
    shadow_depth_bias: 0.02,
    shadow_normal_bias: 1.8,
    shadow_map_near_z: -1.0,
    inner_angle: 0.2,
    outer_angle: 0.6,
  })
  inspect(spot_setup.near_plane == LOCAL_SHADOW_NEAR_MIN, content="true")
  inspect(spot_setup.far_plane == 12.0, content="true")

  let point_setup = build_point_shadow_face_setup(
    {
      position: @smath.Vec3::new(1.0, 2.0, 3.0),
      color: white_render_color(),
      intensity: 1.0,
      range: 8.0,
      shadows: true,
      shadow_depth_bias: 0.08,
      shadow_normal_bias: 0.6,
      shadow_map_near_z: 0.001,
    },
    2,
  )
  let face_size = 384
  let atlas_rect = make_shadow_atlas_rect(
    5,
    POINT_SHADOW_ATLAS_COLUMNS,
    face_size,
    face_size * POINT_SHADOW_ATLAS_COLUMNS,
    face_size * POINT_SHADOW_ATLAS_ROWS,
  )
  inspect(point_setup.near_plane == LOCAL_SHADOW_NEAR_MIN, content="true")
  inspect(point_setup.far_plane == 8.0, content="true")
  inspect(atlas_rect.offset[X] == 0.625, content="true")
  inspect(atlas_rect.offset[Y] == 0.0, content="true")
  inspect(atlas_rect.scale[X] == 0.125, content="true")
  inspect(atlas_rect.scale[Y] == 1.0 / POINT_SHADOW_ATLAS_ROWS.to_double(), content="true")
  inspect(spot_shadow_texel_size(1536)[X] == 1.0 / 1536.0, content="true")
  inspect(point_shadow_texel_size(768)[Y] == 1.0 / 768.0, content="true")
}
