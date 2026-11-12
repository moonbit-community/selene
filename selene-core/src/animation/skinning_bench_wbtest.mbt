///|
test "CPU skinning with four joint influences" (b : @bench.T) {
  with_animation_test_world(fn(world) {
    let positions = Array::makei(4096, i => {
      @math.Vec3(
        i.to_double() * 0.13,
        (i % 127).to_double(),
        -(i % 97).to_double(),
      )
    })
    let indices = Some(Array::makei(4095, i => i))
    let target = @ecs.commands(world).spawn(())
    let mesh = @render3d.register_mesh_asset(
      @render3d.triangle_mesh(positions, indices~),
    )
    defer @render3d.release_mesh_asset(mesh)
    let joints = Array::makei(4, i => {
      @ecs.commands(world).spawn1(
        @transform.Spatial({
          translation: Vec3(i.to_double(), 2.0, -1.0),
          rotation: @math.Rotation3::from_axis_angle(
            @math.Vec3::z_axis(),
            i.to_double() * 0.3,
          ),
          scale: Vec3(1.0 + i.to_double(), 2.0, 1.0),
        }),
      )
    })
    try! @ecs.run_schedule(world, _ => ())
    bind_skinned_mesh(target, {
      target_entity: target,
      mesh,
      base_positions: positions,
      indices,
      topology: TriangleList,
      base_normals: Array::make(positions.length(), @math.Vec3::z_axis()),
      uv_sets: [],
      colors: None,
      tangents: None,
      morph_targets: [],
      morph_weights: [],
      influences: Array::make(positions.length(), {
        joint0: 0,
        joint1: 1,
        joint2: 2,
        joint3: 3,
        weight0: 0.1,
        weight1: 0.2,
        weight2: 0.3,
        weight3: 0.4,
      }),
      joint_entities: joints,
      inverse_bind_matrices: [],
    })
    @transform.transform_propagate_system(world~, 0.0)
    b.bench(name="skin/4096/four-joints", () => {
      animation_skinning_system(world~, 0.0)
      b.keep(@render3d.mesh_asset(mesh))
    })
    clear_skinned_mesh(target)
  })
}
