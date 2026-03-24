///|
test "player animation controller remembers current node" {
  @ecs.set_current_world(@ecs.bootstrap_world())
  let entity = @entity.Entity::new()
  let controller = create_player_animation_controller(entity)
  player_animation_controllers.set(entity, controller)

  play_player_animation_state(
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  inspect(
    player_animation_controllers.get(entity).unwrap().current ==
    Some(controller.idle_right),
    content="true",
  )
}

///|
test "replaying same player animation state does not reset atlas index" {
  @ecs.set_current_world(@ecs.bootstrap_world())
  let entity = @entity.Entity::new()
  let controller = create_player_animation_controller(entity)
  player_animation_controllers.set(entity, controller)

  play_player_animation_state(
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  let sprite = @sprite.sprites().get(entity).unwrap()
  let atlas = sprite.texture_atlas.unwrap()
  atlas.index = 2
  @sprite.sprites().set(entity, sprite)

  play_player_animation_state(
    entity,
    player_idle_right_animation,
    controller.idle_right,
  )

  inspect(
    @sprite.sprites().get(entity).unwrap().texture_atlas.unwrap().index,
    content="2",
  )
}

///|
test "player run animation advances atlas indices in order" {
  @ecs.set_current_world(@ecs.bootstrap_world())
  let entity = @entity.Entity::new()
  let controller = create_player_animation_controller(entity)
  player_animation_controllers.set(entity, controller)

  play_player_animation_state(
    entity,
    player_run_right_animation,
    controller.run_right,
  )

  let indices : Array[Int] = []
  indices.push(
    @sprite.sprites().get(entity).unwrap().texture_atlas.unwrap().index,
  )
  let step = 1.0 / player_run_right_animation.fps
  for _ in 0..<4 {
    @animation.animation_player_system(step)
    @animation.animation_transition_system(step)
    @animation.animation_apply_system(0.0)
    indices.push(
      @sprite.sprites().get(entity).unwrap().texture_atlas.unwrap().index,
    )
  }

  inspect(indices, content="[0, 1, 2, 3, 4]")
}
