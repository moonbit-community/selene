///|
priv enum SpawnMode {
  Draft
  Direct
  Prepared
}

///|
fn spawn_sprite_population(
  size : Int32,
  mode : SpawnMode,
  extra_columns : Bool,
) -> @ecs.World {
  let world = @ecs.World()
  let sprite = @sprite.Sprite::from_color(
    { r: 255U, g: 255U, b: 255U, a: 1.0, },
    Vec2(16.0, 16.0),
  )
  let transform = @transform.Transform::from_xyz(4.0, 0.0, 0.0)
  let make_spatial = () => @transform.Spatial(transform)
  let anchor = @sprite.Anchor(Vec2(0.0, 0.0))
  match mode {
    Draft =>
      for _ in 0..<size {
        let draft = world.spawn_draft()
        draft.add(sprite)
        draft.add(make_spatial())
        if extra_columns {
          draft.add(@visibility.Visibility::Visible)
          draft.add(anchor)
        }
        ignore(draft.spawn())
      }
    Direct =>
      if extra_columns {
        for _ in 0..<size {
          ignore(
            world.spawn(
              (
                sprite,
                make_spatial(),
                (Visible : @visibility.Visibility),
                anchor,
              ),
            ),
          )
        }
      } else {
        for _ in 0..<size {
          ignore(world.spawn((sprite, make_spatial())))
        }
      }
    Prepared =>
      if extra_columns {
        let plan : @ecs.SpawnPlan[
          (
            @sprite.Sprite,
            @transform.Spatial,
            @visibility.Visibility,
            @sprite.Anchor,
          ),
        ] = world.prepare_spawn()
        for _ in 0..<size {
          ignore(
            plan.spawn(
              (
                sprite,
                make_spatial(),
                (Visible : @visibility.Visibility),
                anchor,
              ),
            ),
          )
        }
      } else {
        let plan : @ecs.SpawnPlan[(@sprite.Sprite, @transform.Spatial)] = world.prepare_spawn()
        for _ in 0..<size {
          ignore(plan.spawn((sprite, make_spatial())))
        }
      }
  }
  world
}

///|
test "sprite spawn paths" (b : @bench.T) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for (size, columns) in [(1000, 2), (10000, 2), (10000, 4)] {
    let extra_columns = columns == 4
    for
      (mode, name) in [
        (Draft, "draft"),
        (Direct, "direct"),
        (Prepared, "prepared"),
      ] {
      @ecs.set_current_world(spawn_sprite_population(size, mode, extra_columns))
      assert_eq(@ecs.alive_entity_count(), size)
      let mut matched = 0
      @sprite.for_each_sprite_transform((_, _, _) => matched += 1)
      assert_eq(matched, size)
      // Each sample starts with a fresh World, including plan preparation.
      b.bench(name="spawn/\{name}/n=\{size}/columns=\{columns}", count=10, () => {
        b.keep(spawn_sprite_population(size, mode, extra_columns))
      })
    }
  }
}
