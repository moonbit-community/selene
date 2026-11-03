///|
fn sprite_transform_checksum(
  lookup : (@entity.Entity) -> @transform.GlobalTransform?,
) -> Int32 {
  let mut checksum = 0
  for entity, sprite in @sprite.sprites() {
    if lookup(entity) is Some(transform) {
      checksum += sprite.color.r.reinterpret_as_int() +
        transform.translation().x.to_int()
    }
  }
  checksum
}

///|
test "sprite transform join and CPU extraction" (b : @bench.T) {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  for size in [1000, 10000] {
    @ecs.set_current_world(World())
    @system.configure_display(960.0, 540.0, 1.0)
    let transforms = @transform.global_transforms()
    let sprites = @sprite.sprites()
    let rows = FixedArray::make(size, -1)
    let dense = []
    let sprite = @sprite.Sprite::from_color(
      { r: 255U, g: 255U, b: 255U, a: 1.0, },
      Vec2(16.0, 16.0),
    )
    for i in 0..<size {
      let entity = @entity.Entity()
      sprites.set(entity, sprite)
      if i % 4 != 0 {
        let transform = @transform.GlobalTransform::from_transform(
          @transform.Transform::from_xyz(i.to_double(), 0.0, 0.0),
        )
        transforms.set(entity, transform)
        rows[entity.id().reinterpret_as_int()] = dense.length()
        dense.push(transform)
      }
    }
    let resolve_each = entity => @transform.global_transforms().get(entity)
    let resolve_once = entity => transforms.get(entity)
    // This read-only layout estimates lookup cost with dense values and sparse
    // row indexes. It does not measure the cost of maintaining a sparse set.
    let resolve_dense = (entity : @entity.Entity) => {
      let row = rows[entity.id().reinterpret_as_int()]
      if row < 0 {
        None
      } else {
        Some(dense[row])
      }
    }
    let expected = sprite_transform_checksum(resolve_once)
    assert_eq(sprite_transform_checksum(resolve_each), expected)
    assert_eq(sprite_transform_checksum(resolve_dense), expected)
    b.bench(name="sprite-join/per-entity-store/n=\{size}", count=10, () => {
      b.keep(sprite_transform_checksum(resolve_each))
    })
    b.bench(name="sprite-join/bound-store/n=\{size}", count=10, () => {
      b.keep(sprite_transform_checksum(resolve_once))
    })
    b.bench(name="sprite-join/dense-index/n=\{size}", count=10, () => {
      b.keep(sprite_transform_checksum(resolve_dense))
    })
    @render2d.begin_frame2d_system(0.0)
    @sprite.render_sprite_system(0.0)
    assert_eq(
      @render2d.get_screen_world_commands_with_depth().length(),
      size - size / 4,
    )
    b.bench(name="sprite-extract/n=\{size}", count=10, () => {
      @render2d.begin_frame2d_system(0.0)
      @sprite.render_sprite_system(0.0)
    })
  }
}
