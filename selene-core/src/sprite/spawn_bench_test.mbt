///|
fn spawn_sprite_population(
  size : Int32,
  bundled : Bool,
  extra_columns : Bool,
) -> @ecs.World {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let sprites = @sprite.sprites()
  let globals = @transform.global_transforms()
  let sprite = @sprite.Sprite::from_color(
    { r: 255U, g: 255U, b: 255U, a: 1.0, },
    Vec2(16.0, 16.0),
  )
  let global = @transform.GlobalTransform::from_transform(
    @transform.Transform::from_xyz(4.0, 0.0, 0.0),
  )
  if extra_columns {
    let a : @ecs.ComponentStore[Int32] = ComponentStore(world)
    let b : @ecs.ComponentStore[Int32] = ComponentStore(world)
    if bundled {
      let bundle = sprites
        .spawn_bundle()
        .combine(globals.spawn_bundle())
        .combine(a.spawn_bundle().combine(b.spawn_bundle()))
      for i in 0..<size {
        ignore(bundle.spawn(world, ((sprite, global), (i, i + 1))))
      }
    } else {
      for i in 0..<size {
        let entity = @ecs.Entity()
        sprites.set(entity, sprite)
        globals.set(entity, global)
        a.set(entity, i)
        b.set(entity, i + 1)
      }
    }
  } else if bundled {
    let bundle = sprites.spawn_bundle().combine(globals.spawn_bundle())
    for _ in 0..<size {
      ignore(bundle.spawn(world, (sprite, global)))
    }
  } else {
    for _ in 0..<size {
      let entity = @ecs.Entity()
      sprites.set(entity, sprite)
      globals.set(entity, global)
    }
  }
  world
}

///|
test "initial sprite archetype placement with and without a bundle" (
  b : @bench.T,
) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for (size, columns) in [(1000, 2), (10000, 2), (10000, 4)] {
    let extra_columns = columns == 4
    for bundled in [false, true] {
      ignore(spawn_sprite_population(size, bundled, extra_columns))
      assert_eq(@ecs.alive_entity_count(), size)
      let mut matched = 0
      @sprite.for_each_sprite_transform((_, _, _) => matched += 1)
      assert_eq(matched, size)
      let mode = if bundled { "bundle" } else { "set" }
      // Each measured sample starts with a fresh World, including plan creation.
      b.bench(name="spawn/\{mode}/n=\{size}/columns=\{columns}", count=10, () => {
        b.keep(spawn_sprite_population(size, bundled, extra_columns))
      })
    }
  }
}
