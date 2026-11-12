///|
fn make_sprite_fixture(size : Int32) -> Array[@ecs.Entity] {
  @window.configure_display(960.0, 540.0, 1.0)
  let world = @ecs.require_current_world()
  let plan : @ecs.SpawnPlan[(@sprite.Sprite, @transform.Spatial)] = world.prepare_spawn()
  let entities = []
  let sprite = @sprite.Sprite::from_color(
    { r: 255U, g: 255U, b: 255U, a: 1.0, },
    Vec2(16.0, 16.0),
  )
  let pose = @transform.Transform::from_xyz(4.0, 0.0, 0.0)
  for i in 0..<size {
    let entity = if i % 4 == 0 {
      @ecs.commands(world).spawn1(sprite)
    } else {
      @ecs.commands(world).spawn_prepared(plan, (sprite, Spatial(pose)))
    }
    entities.push(entity)
  }
  try! @ecs.run_schedule(world, _ => ())
  entities
}

///|
test "sprite CPU extraction and transform propagation" (b : @bench.T) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for size in [1000, 10000] {
    let world = @ecs.World()
    @ecs.set_current_world(world)
    ignore(make_sprite_fixture(size))
    @render2d.begin_frame2d_system(0.0)
    @sprite.render_sprite_system(world~, 0.0)
    assert_eq(
      @render2d.get_screen_world_commands_with_depth().length(),
      size - size / 4,
    )
    b.bench(name="sprite-extract/n=\{size}", count=10, () => {
      @render2d.begin_frame2d_system(0.0)
      @sprite.render_sprite_system(world~, 0.0)
    })
    @transform.transform_propagate_system(world~, 0.0)
    b.bench(name="transform-propagate/n=\{size}", count=10, () => {
      @transform.transform_propagate_system(world~, 0.0)
    })
  }
}

///|
test "sprite archetype join" (b : @bench.T) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for size in [1000, 10000] {
    let world = @ecs.World()
    @ecs.set_current_world(world)
    ignore(make_sprite_fixture(size))
    let archetype_checksum = () => {
      let mut checksum = 0
      @sprite.for_each_sprite_transform(world~, (_, sprite, transform) => {
        checksum += sprite.color.r.reinterpret_as_int() +
          transform.translation().x.to_int()
      })
      checksum
    }
    assert_eq(archetype_checksum(), (size - size / 4) * (255 + 4))
    b.bench(name="sprite-join/archetype/n=\{size}", count=10, () => {
      b.keep(archetype_checksum())
    })
  }
}
