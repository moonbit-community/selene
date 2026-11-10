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
#selene.component
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
fn player_animation_controllers() -> @ecs.ComponentStore[
  PlayerAnimationController,
] {
  @ecs.components()
}

///|
fn player_input_vector() -> @math.Vec2 {
  if !game_state().level_up_panel.available_selections.is_empty() {
    return @math.Vec2::zero()
  }
  let input = @math.Vec2(
    @input_action.action_value(survivors_move_right_action()) -
    @input_action.action_value(survivors_move_left_action()),
    @input_action.action_value(survivors_move_down_action()) -
    @input_action.action_value(survivors_move_up_action()),
  )
  if input.distance() > 1.0 {
    input.normalize()
  } else {
    input
  }
}

///|
fn build_sprite_animation_clip_asset(
  animation : SpriteAnimationDef,
) -> @animation.AnimationClipHandle {
  let clip = @animation.AnimationClip(animation.name)
  let keys : Array[@animation.ScalarKeyframe] = []
  let frame_duration = if animation.fps <= 0.0 {
    1.0
  } else {
    1.0 / animation.fps
  }
  let frame_count = @sprite.texture_atlas_layout(animation.layout).map_or(0, fn(
    layout,
  ) {
    layout.rects.length()
  })
  for index in 0..<frame_count {
    keys.push({
      time: index.to_double() * frame_duration,
      value: index.to_double(),
      in_tangent: None,
      out_tangent: None,
    })
  }
  clip.add_curve_to_target(
    AnimationTargetId("self"),
    @animation.VariableCurve::scalar(
      @animation.texture_atlas_index_field(),
      keys,
      interpolation=Step,
    ),
  )
  if frame_count > 0 && !animation.loop_ {
    clip.duration = (frame_count - 1).to_double() * frame_duration
  } else if frame_count > 0 {
    clip.duration = frame_count.to_double() * frame_duration
  }
  @animation.register_animation_clip_asset(clip)
}

///|
fn register_sprite_animation_node(
  graph : @animation.AnimationGraph,
  animation : SpriteAnimationDef,
) -> @animation.AnimationNodeIndex {
  graph.add_clip(build_sprite_animation_clip_asset(animation))
}

///|
fn build_player_animation_controller() -> (
  PlayerAnimationController,
  @animation.AnimationGraphHandle,
) {
  let graph = @animation.AnimationGraph()
  let controller : PlayerAnimationController = {
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
  (controller, @animation.register_animation_graph_asset(graph))
}

///|
fn play_player_animation_state(
  entity : @ecs.Entity,
  animation : SpriteAnimationDef,
  node : @animation.AnimationNodeIndex,
) -> Unit {
  guard player_animation_controllers().get(entity) is Some(controller) else {
    return
  }
  if controller.current == Some(node) {
    return
  }
  @sprite.sprites().set(entity, sprite_animation_sprite(animation))
  let player = @animation.animation_players().get(entity).unwrap()
  let transitions = @animation.animation_transitions().get(entity).unwrap()
  let duration = 0.0
  ignore(transitions.play(player, node, duration))
  controller.current = Some(node)
}

///|
fn spawn_player() -> @ecs.Entity {
  let shape : @physics2d.ColliderShape = Rect(
    size=Vec2(PLAYER_SIZE, PLAYER_SIZE),
    offset=Vec2(-PLAYER_SIZE / 2.0, -PLAYER_SIZE / 2.0),
  )
  let (animation_controller, graph) = build_player_animation_controller()
  let world = @ecs.require_current_world()
  let plan = world.prepare_spawn().combine(world.prepare_spawn())
  let entity = plan.spawn(
    (
      (
        sprite_animation_sprite(player_idle_right_animation),
        @transform.Spatial(
          @transform.Transform::from_xyz(
            MAP_WIDTH / 2.0,
            MAP_HEIGHT / 2.0,
            PLAYER_ZINDEX.to_double(),
          ),
        ),
        @physics2d.Velocity(@math.Vec2::zero()),
        @physics2d.Collider(
          @physics2d.CollisionFilter(player_collision_group, [
            wall_collision_group,
          ]),
        ),
        shape,
      ),
      (
        animation_controller,
        graph,
        @animation.AnimationPlayer(),
        @animation.AnimationTransitions(),
        @animation.AnimationTargetId("self"),
      ),
    ),
  )
  survivors_runtime().entities.push(entity)
  play_player_animation_state(
    entity,
    player_idle_right_animation,
    animation_controller.idle_right,
  )
  entity
}

///|
fn player_update_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  let delta = @time.delta()
  if game.game_over || delta == 0 {
    return
  }
  let entity = game.player_entity
  let speed = if game.player_stats.speed < 0.0 {
    0.0
  } else {
    game.player_stats.speed
  }
  let vel = player_input_vector().normalize().scalar_mul(speed)
  @physics2d.linear_velocities().set(entity, vel)
  if vel[X] > 0.0 {
    game.player_direction = Right
  } else if vel[X] < 0.0 {
    game.player_direction = Left
  } else if vel[Y] > 0.0 {
    game.player_direction = Down
  } else if vel[Y] < 0.0 {
    game.player_direction = Up
  }
  guard player_animation_controllers().get(entity) is Some(animation_controller) else {
    return
  }
  match (vel == @math.Vec2::zero(), game.player_direction) {
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
  let game = game_state()
  let delta = @time.delta()
  if game.game_over {
    return
  }
  guard @transform.local_transform(game.player_entity) is Some(player_transform) else {
    return
  }
  let player_pos = @math.Vec2(
    player_transform.translation.x,
    player_transform.translation.y,
  )

  // Clamp stats to at least 0
  let attack_speed = if game.player_stats.attack_speed < 0.0 {
    0.0
  } else {
    game.player_stats.attack_speed
  }
  let attack = if game.player_stats.attack < 0.0 {
    0.0
  } else {
    game.player_stats.attack
  }
  let range = if game.player_stats.range < 0.0 {
    0.0
  } else {
    game.player_stats.range
  }
  let penetration = if game.player_stats.penetration < 0 {
    0
  } else {
    game.player_stats.penetration
  }
  update_weapon_timers(
    game.player_stats.weapon_instances,
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
  player_pos : @math.Vec2,
  weapon_range : Double,
) -> @math.Vec2? {
  let mut min = weapon_range
  let mut res : @math.Vec2? = None
  for e, _enemy in enemies() {
    guard e.is_alive() else { continue }
    guard @transform.local_transform(e) is Some(enemy_transform) else {
      continue
    }
    let enemy_pos = @math.Vec2(
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
