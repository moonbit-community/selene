///|
test "render3d extract preserves mesh shadow toggles" {
  let entity = @entity.Entity::new()
  let mesh = @render3d_types.MeshHandle(9901U)
  let material = @render3d_types.MaterialHandle(9902U)
  meshes.set(mesh, cube_mesh(@math.Vec3::new(1.0, 1.0, 1.0)))
  materials.set(material, default_standard_material3d())
  mesh3d_renderers.set(entity, {
    mesh,
    material,
    visible: true,
    cast_shadows: false,
    receive_shadows: false,
  })
  @transform3d.transforms3d.set(entity, @transform3d.Transform3D::identity())
  @visibility.visibilities.set(entity, Visible)
  @visibility.inherited_visibilities.set(entity, { visible: true })
  @visibility.view_visibilities.set(entity, { visible: true })

  render3d_extract_system(0.0)

  let frame = get_extracted_frame3d()
  inspect(frame.items.length(), content="1")
  inspect(frame.items[0].cast_shadows, content="false")
  inspect(frame.items[0].receive_shadows, content="false")

  mesh3d_renderers.remove(entity)
  @transform3d.transforms3d.remove(entity)
  @transform3d.global_transforms3d.remove(entity)
  @visibility.visibilities.remove(entity)
  @visibility.inherited_visibilities.remove(entity)
  @visibility.view_visibilities.remove(entity)
  meshes.remove(mesh)
  materials.remove(material)
  extracted_frame3d.val = empty_render_frame3d()
  entity.destroy()
}

///|
test "render3d point and spot defaults include Bevy-aligned shadow settings" {
  let point = default_point_light3d()
  inspect(point.shadows, content="false")
  inspect(point.shadow_depth_bias == 0.08, content="true")
  inspect(point.shadow_normal_bias == 0.6, content="true")
  inspect(point.shadow_map_near_z == 0.1, content="true")

  let spot = default_spot_light3d()
  inspect(spot.shadows, content="false")
  inspect(spot.shadow_depth_bias == 0.02, content="true")
  inspect(spot.shadow_normal_bias == 1.8, content="true")
  inspect(spot.shadow_map_near_z == 0.1, content="true")
}

///|
test "render3d directional defaults include Bevy-aligned cascade config" {
  let builder = default_cascade_shadow_config_builder3d()
  inspect(builder.num_cascades, content="4")
  inspect(builder.minimum_distance == 0.1, content="true")
  inspect(builder.maximum_distance == 150.0, content="true")
  inspect(builder.first_cascade_far_bound == 10.0, content="true")
  inspect(builder.overlap_proportion == 0.2, content="true")

  let config = default_directional_light3d().cascade_shadow_config
  inspect(config.minimum_distance == 0.1, content="true")
  inspect(config.overlap_proportion == 0.2, content="true")
  inspect(config.bounds.length(), content="4")
  inspect(config.bounds[0] == 10.0, content="true")
  inspect((config.bounds[1] - 24.662120743304698).abs() < 0.000001, content="true")
  inspect((config.bounds[2] - 60.82201995573399).abs() < 0.000001, content="true")
  inspect((config.bounds[3] - 150.0).abs() < 0.000001, content="true")
}

///|
test "render3d extract preserves shadow map size resources" {
  set_directional_light_shadow_map3d({ size: 1536 })
  set_point_light_shadow_map3d({ size: 768 })

  render3d_extract_system(0.0)

  let frame = get_extracted_frame3d()
  inspect(frame.directional_shadow_map_size, content="1536")
  inspect(frame.point_shadow_map_size, content="768")

  set_directional_light_shadow_map3d(default_directional_light_shadow_map3d())
  set_point_light_shadow_map3d(default_point_light_shadow_map3d())
  extracted_frame3d.val = empty_render_frame3d()
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
