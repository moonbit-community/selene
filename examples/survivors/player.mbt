// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
const PLAYER_SIZE : Double = 16.0

///|
const PLAYER_SPEED : Double = 150

///|
const INVINCIBLE_TIME : Double = 1.0

///|
priv struct PlayerAnimationController {
  idle_left : @animation.AnimationNodeIndex
  idle_right : @animation.AnimationNodeIndex
  idle_up : @animation.AnimationNodeIndex
  idle_down : @animation.AnimationNodeIndex
  run_left : @animation.AnimationNodeIndex
  run_right : @animation.AnimationNodeIndex
  run_up : @animation.AnimationNodeIndex
  run_down : @animation.AnimationNodeIndex
  mut current : @animation.AnimationNodeIndex?
}

///|
let player_animation_controllers : Map[
  @entity.Entity,
  PlayerAnimationController,
] = Map::new()

///|
fn ensure_sprite_animation_binding(entity : @entity.Entity) -> Unit {
  ignore(
    @animation.animation_players().get_or_init(entity, fn() {
      @animation.AnimationPlayer::new()
    }),
  )
  ignore(
    @animation.animation_transitions().get_or_init(entity, fn() {
      @animation.AnimationTransitions::new()
    }),
  )
  @animation.animation_target_ids().set(
    entity,
    @animation.AnimationTargetId::new("self"),
  )
  @animation.animated_bys().set(entity, @animation.AnimatedBy::new(entity))
  ignore(
    @sprite.sprite_frame_indices().get_or_init(entity, fn() { { frame: 0.0 } }),
  )
}

///|
fn register_sprite_animation_node(
  graph : @animation.AnimationGraph,
  animation : @sprite.Animation,
) -> @animation.AnimationNodeIndex {
  graph.add_clip(@animation.register_sprite_animation_clip(animation))
}

///|
fn create_player_animation_controller(
  entity : @entity.Entity,
) -> PlayerAnimationController {
  let graph = @animation.AnimationGraph::new()
  let controller = {
    idle_left: register_sprite_animation_node(graph, player_idle_left_animation),
    idle_right: register_sprite_animation_node(
      graph, player_idle_right_animation,
    ),
    idle_up: register_sprite_animation_node(graph, player_idle_up_animation),
    idle_down: register_sprite_animation_node(graph, player_idle_down_animation),
    run_left: register_sprite_animation_node(graph, player_run_left_animation),
    run_right: register_sprite_animation_node(graph, player_run_right_animation),
    run_up: register_sprite_animation_node(graph, player_run_up_animation),
    run_down: register_sprite_animation_node(graph, player_run_down_animation),
    current: None,
  }
  ensure_sprite_animation_binding(entity)
  @animation.animation_graph_handles().set(
    entity,
    @animation.register_animation_graph(graph),
  )
  controller
}

///|
fn play_player_animation_state(
  entity : @entity.Entity,
  animation : @sprite.Animation,
  node : @animation.AnimationNodeIndex,
) -> Unit {
  guard player_animation_controllers.get(entity) is Some(controller) else {
    return
  }
  if controller.current == Some(node) {
    return
  }
  @sprite.sprites().set(entity, @sprite.Sprite::from_animation(animation))
  let player = @animation.animation_players().get(entity).unwrap()
  let transitions = @animation.animation_transitions().get(entity).unwrap()
  let duration = if controller.current is Some(_) { 0.05 } else { 0.0 }
  transitions.play(player, node, duration)
  controller.current = Some(node)
}

///|
fn add_player() -> Unit {
  let entity = game_state.player_entity
  let animation_controller = create_player_animation_controller(entity)
  player_animation_controllers.set(entity, animation_controller)
  @sprite.sprites().set(
    entity,
    @sprite.Sprite::from_animation(player_idle_right_animation),
  )
  @transform.transforms().set(
    entity,
    @transform.Transform::from_xyz(
      MAP_WIDTH / 2.0,
      MAP_HEIGHT / 2.0,
      PLAYER_ZINDEX.to_double(),
    ),
  )
  @physics2d.linear_velocities().set(entity, Vec2D(0.0, 0.0))
  @physics2d.colliders().set(
    entity,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(player_collision_group, [
        wall_collision_group,
      ]),
    ),
  )
  @physics2d.shapes().set(
    entity,
    @physics2d.CollisionShape::Rect(
      size=Vec2D(PLAYER_SIZE, PLAYER_SIZE),
      offset=Vec2D(-PLAYER_SIZE / 2.0, -PLAYER_SIZE / 2.0),
    ),
  )
  play_player_animation_state(
    entity,
    player_idle_right_animation,
    animation_controller.idle_right,
  )
}

///|
fn player_update_system(_world : @ecs.World) -> Unit {
  let delta = @time.delta()
  if game_state.game_over || delta == 0 {
    return
  }
  let entity = game_state.player_entity
  let speed = if game_state.player_stats.speed < 0.0 {
    0.0
  } else {
    game_state.player_stats.speed
  }
  let vel = @inputs.key_vector(KeyW, KeyS, KeyA, KeyD)
    .normalize()
    .scalar_mul(speed)
  @physics2d.linear_velocities().set(entity, vel)
  if vel[X] > 0.0 {
    game_state.player_direction = Right
  } else if vel[X] < 0.0 {
    game_state.player_direction = Left
  } else if vel[Y] > 0.0 {
    game_state.player_direction = Down
  } else if vel[Y] < 0.0 {
    game_state.player_direction = Up
  }
  guard player_animation_controllers.get(entity) is Some(animation_controller) else {
    return
  }
  match (vel == @math.Vec2D::zero(), game_state.player_direction) {
    (true, Left) =>
      play_player_animation_state(
        entity,
        player_idle_left_animation,
        animation_controller.idle_left,
      )
    (true, Right) =>
      play_player_animation_state(
        entity,
        player_idle_right_animation,
        animation_controller.idle_right,
      )
    (true, Up) =>
      play_player_animation_state(
        entity,
        player_idle_up_animation,
        animation_controller.idle_up,
      )
    (true, Down) =>
      play_player_animation_state(
        entity,
        player_idle_down_animation,
        animation_controller.idle_down,
      )
    (false, Left) =>
      play_player_animation_state(
        entity,
        player_run_left_animation,
        animation_controller.run_left,
      )
    (false, Right) =>
      play_player_animation_state(
        entity,
        player_run_right_animation,
        animation_controller.run_right,
      )
    (false, Up) =>
      play_player_animation_state(
        entity,
        player_run_up_animation,
        animation_controller.run_up,
      )
    (false, Down) =>
      play_player_animation_state(
        entity,
        player_run_down_animation,
        animation_controller.run_down,
      )
  }
}

///|
fn player_shooting_system(_world : @ecs.World) -> Unit {
  let delta = @time.delta()
  if game_state.game_over {
    return
  }
  guard @transform.transforms().get(game_state.player_entity)
    is Some(player_transform)
  let player_pos = @math.Vec2D(
    player_transform.translation.x,
    player_transform.translation.y,
  )

  // Clamp stats to at least 0
  let attack_speed = if game_state.player_stats.attack_speed < 0.0 {
    0.0
  } else {
    game_state.player_stats.attack_speed
  }
  let attack = if game_state.player_stats.attack < 0.0 {
    0.0
  } else {
    game_state.player_stats.attack
  }
  let range = if game_state.player_stats.range < 0.0 {
    0.0
  } else {
    game_state.player_stats.range
  }
  let penetration = if game_state.player_stats.penetration < 0 {
    0
  } else {
    game_state.player_stats.penetration
  }
  update_weapon_timers(
    game_state.player_stats.weapon_instances,
    delta,
    attack_speed,
    attack,
    range,
    penetration,
    player_pos,
  )
}

///|
fn find_nearest_enemy_in_range(
  player_pos : @math.Vec2D,
  weapon_range : Double,
) -> @math.Vec2D? {
  let mut min = weapon_range
  let mut res : @math.Vec2D? = None
  for e, _enemy in enemies {
    guard e.is_alive() else { continue }
    guard @transform.transforms().get(e) is Some(enemy_transform)
    let enemy_pos = @math.Vec2D(
      enemy_transform.translation.x,
      enemy_transform.translation.y,
    )
    let dist = player_pos.distance_to(enemy_pos)
    if dist < min {
      min = dist
      res = Some(enemy_pos)
    }
  }
  res
}
