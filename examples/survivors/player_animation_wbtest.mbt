///|
test "player animation controller remembers current node" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(@ecs.require_current_world())
  reset_survivors_runtime()
  let entity = spawn_player(world~)
  flush_test_commands(world)
  let controller = (
      world.query() : @ecs.Query[@ecs.Single[PlayerAnimationController]])
    .get(entity)
    .map(value => value.0)
    .unwrap()

  play_player_animation_state(
    world.query(),
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  inspect(
    (world.query() : @ecs.Query[@ecs.Single[PlayerAnimationController]])
    .get(entity)
    .map(value => value.0)
    .unwrap().current ==
    Some(controller.idle_right),
    content="true",
  )
}

///|
test "replaying same player animation state does not reset atlas index" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(@ecs.require_current_world())
  reset_survivors_runtime()
  let entity = spawn_player(world~)
  flush_test_commands(world)
  let controller = (
      world.query() : @ecs.Query[@ecs.Single[PlayerAnimationController]])
    .get(entity)
    .map(value => value.0)
    .unwrap()

  play_player_animation_state(
    world.query(),
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  let sprite = (world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]])
    .get(entity)
    .map(value => value.0)
    .unwrap()
  let atlas = sprite.texture_atlas.unwrap()
  atlas.index = 2
  world.set_component(entity, (sprite : @sprite.Sprite))

  play_player_animation_state(
    world.query(),
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  inspect(
    (world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]])
    .get(entity)
    .map(value => value.0)
    .unwrap().texture_atlas.unwrap().index,
    content="2",
  )
}

///|
test "player run animation advances atlas indices in order" {
  let world = @ecs.World()
  @ecs.set_current_world(world)
  @time.initialize(@ecs.require_current_world())
  reset_survivors_runtime()
  let entity = spawn_player(world~)
  flush_test_commands(world)
  let controller = (
      world.query() : @ecs.Query[@ecs.Single[PlayerAnimationController]])
    .get(entity)
    .map(value => value.0)
    .unwrap()

  play_player_animation_state(
    world.query(),
    entity,
    player_run_right_animation,
    controller.run_right,
  )

  let indices : Array[Int32] = []
  indices.push(
    (world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]])
    .get(entity)
    .map(value => value.0)
    .unwrap().texture_atlas.unwrap().index,
  )
  let step = 1.0 / player_run_right_animation.fps
  for _ in 0..<4 {
    let time = @time.Time(world)
    time.set_delta(step)
    @animation.animation_player_system(
      world.query(),
      AnimationTargets(world),
      time,
    )
    @animation.animation_transition_system(world.query(), time, Entities(world))
    @animation.animation_apply_system(world~)
    indices.push(
      (world.query() : @ecs.Query[@ecs.Single[@sprite.Sprite]])
      .get(entity)
      .map(value => value.0)
      .unwrap().texture_atlas.unwrap().index,
    )
  }

  inspect(indices.length(), content="5")
  inspect(indices[0], content="0")
  inspect(indices[1], content="1")
  inspect(indices[2], content="2")
  inspect(indices[3], content="3")
  inspect(indices[4], content="4")
}
