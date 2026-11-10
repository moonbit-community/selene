///|
priv enum SpawnMode {
  Sequential
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
  let global = @transform.GlobalTransform::from_transform(transform)
  let anchor = @sprite.Anchor(Vec2(0.0, 0.0))
  match mode {
    Sequential => {
      let sprites : @ecs.ComponentStore[@sprite.Sprite] = @ecs.components_in(
        world,
      )
      let globals : @ecs.ComponentStore[@transform.GlobalTransform] = @ecs.components_in(
        world,
      )
      let transforms : @ecs.ComponentStore[@transform.Transform] = @ecs.components_in(
        world,
      )
      let anchors : @ecs.ComponentStore[@sprite.Anchor] = @ecs.components_in(
        world,
      )
      for _ in 0..<size {
        let entity = world.spawn(())
        sprites.set(entity, sprite)
        globals.set(entity, global)
        if extra_columns {
          transforms.set(entity, transform)
          anchors.set(entity, anchor)
        }
      }
    }
    Direct =>
      if extra_columns {
        for _ in 0..<size {
          ignore(world.spawn((sprite, global, transform, anchor)))
        }
      } else {
        for _ in 0..<size {
          ignore(world.spawn((sprite, global)))
        }
      }
    Prepared =>
      if extra_columns {
        let plan : @ecs.SpawnPlan[
          (
            @sprite.Sprite,
            @transform.GlobalTransform,
            @transform.Transform,
            @sprite.Anchor,
          ),
        ] = world.prepare_spawn()
        for _ in 0..<size {
          ignore(plan.spawn((sprite, global, transform, anchor)))
        }
      } else {
        let plan : @ecs.SpawnPlan[(@sprite.Sprite, @transform.GlobalTransform)] = world.prepare_spawn()
        for _ in 0..<size {
          ignore(plan.spawn((sprite, global)))
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
        (Sequential, "set"),
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
