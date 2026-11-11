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
priv struct EnemyData {
  health : Double
  speed : Double
  points : Int32
  right_animation : SpriteAnimationDef
  left_animation : SpriteAnimationDef
}

///|
priv struct WaveSpawnPlan {
  creeper_count : Int32
  icecream_count : Int32
  orc_count : Int32
  skull_count : Int32
  teleman_count : Int32
  devil_count : Int32
  pirate_count : Int32
  spawn_interval : Double // Time in seconds between spawns
}

///|
let wave_spawn_plans : Array[WaveSpawnPlan] = [
  // Wave 1: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 40,
    icecream_count: 20,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 2: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 30,
    icecream_count: 0,
    orc_count: 30,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 3: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 120,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 4: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 60,
    icecream_count: 0,
    orc_count: 0,
    skull_count: 60,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 5: 180 enemies over 60s = 0.333s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 90,
    skull_count: 90,
    teleman_count: 0,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 0.333,
  },
  // Wave 6: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 56,
    skull_count: 0,
    teleman_count: 4,
    devil_count: 0,
    pirate_count: 0,
    spawn_interval: 1.0,
  },
  // Wave 7: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 60,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 0,
    devil_count: 60,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 8: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 40,
    skull_count: 0,
    teleman_count: 40,
    devil_count: 40,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 9: 120 enemies over 60s = 0.5s interval
  {
    creeper_count: 20,
    icecream_count: 20,
    orc_count: 20,
    skull_count: 20,
    teleman_count: 20,
    devil_count: 20,
    pirate_count: 0,
    spawn_interval: 0.5,
  },
  // Wave 10: 60 enemies over 60s = 1.0s interval
  {
    creeper_count: 0,
    icecream_count: 0,
    orc_count: 0,
    skull_count: 0,
    teleman_count: 59,
    devil_count: 0,
    pirate_count: 1,
    spawn_interval: 1.0,
  },
]

///|
#selene.resource
priv struct WaveState {
  mut creeper_spawned : Int32
  mut icecream_spawned : Int32
  mut orc_spawned : Int32
  mut skull_spawned : Int32
  mut teleman_spawned : Int32
  mut devil_spawned : Int32
  mut pirate_spawned : Int32
}

///|
fn WaveState::WaveState() -> WaveState {
  {
    creeper_spawned: 0,
    icecream_spawned: 0,
    orc_spawned: 0,
    skull_spawned: 0,
    teleman_spawned: 0,
    devil_spawned: 0,
    pirate_spawned: 0,
  }
}

///|
fn wave_state() -> WaveState {
  @ecs.require_current_world().resource()
}

///|
fn reset_wave_state() -> Unit {
  @ecs.require_current_world().insert_resource(WaveState())
}

///|
let creeper_data : EnemyData = {
  health: 1.0,
  speed: 60.0,
  points: 10,
  right_animation: creeper_right_animation,
  left_animation: creeper_left_animation,
}

///|
let icecream_data : EnemyData = {
  health: 2.0,
  speed: 90.0,
  points: 20,
  right_animation: icecream_right_animation,
  left_animation: icecream_left_animation,
}

///|
let orc_data : EnemyData = {
  health: 3.0,
  speed: 75,
  points: 30,
  right_animation: orc_right_animation,
  left_animation: orc_left_animation,
}

///|
let skull_data : EnemyData = {
  health: 5.0,
  speed: 60.0,
  points: 40,
  right_animation: skull_right_animation,
  left_animation: skull_left_animation,
}

///|
let teleman_data : EnemyData = {
  health: 20.0,
  speed: 60.0,
  points: 80,
  right_animation: teleman_right_animation,
  left_animation: teleman_left_animation,
}

///|
let devil_data : EnemyData = {
  health: 8.0,
  speed: 90.0,
  points: 50,
  right_animation: devil_right_animation,
  left_animation: devil_left_animation,
}

///|
let pirate_data : EnemyData = {
  health: 500.0,
  speed: 60.0,
  points: 200,
  right_animation: pirate_right_animation,
  left_animation: pirate_left_animation,
}

///|
let spawners : Array[@math.Vec2] = [
  Vec2(16.0, 16.0),
  Vec2(MAP_WIDTH - 16.0, 16.0),
  Vec2(16.0, MAP_HEIGHT - 16.0),
  Vec2(MAP_WIDTH - 16.0, MAP_HEIGHT - 16.0),
]

///|
fn spawn_enemy_system(_world : @ecs.World) -> Unit {
  fn spawn_enemy() -> Unit {
    let game = game_state()
    if !is_playing(@ecs.require_current_world()) {
      return
    }
    let rand = game.rand

    // Get spawn interval for current wave
    let wave = game.current_wave
    let spawn_interval = if wave >= 1 && wave <= 10 {
      wave_spawn_plans[wave - 1].spawn_interval
    } else {
      1.0 // Fallback interval
    }

    // Try to select an enemy type for the current wave
    match select_enemy_type_for_wave(rand) {
      Some(enemy_type) => {
        let pos = spawners[rand.int(limit=spawners.length())]
        let data = get_enemy_data(enemy_type)
        let (left_node, right_node, graph) = create_enemy_animation_nodes(data)
        let enemy_state : Enemy = {
          enemy_type,
          speed: data.speed,
          health: data.health,
          shoot_timer: 0.0,
          left_node,
          right_node,
          current_node: None,
        }
        let shape : @physics2d.ColliderShape = Rect(
          size=Vec2(8.0, 8.0),
          offset=Vec2(-4.0, -4.0),
        )
        let runtime = survivors_runtime()
        let enemy = runtime.enemy_plan.spawn(
          (
            (
              Spatial(
                @transform.Transform::from_xyz(
                  pos.x,
                  pos.y,
                  ENEMY_ZINDEX.to_double(),
                ),
              ),
              Velocity(@math.Vec2::zero()),
              sprite_animation_sprite(data.right_animation),
              shape,
              Collider(
                CollisionFilter(enemy_collision_group, [
                  enemy_collision_group, wall_collision_group,
                ]),
              ),
              enemy_state,
            ),
            (
              graph,
              AnimationPlayer(),
              AnimationTransitions(),
              AnimationTargetId("self"),
            ),
          ),
        )
        runtime.entities.push(enemy)
        play_enemy_animation_state(
          enemy,
          enemy_state,
          data.right_animation,
          right_node,
        )
      }
      None => () // No more enemies to spawn in this wave
    }
    survivors_timeout(spawn_interval, spawn_enemy)
  }

  spawn_enemy()
}

///|
#selene.component
priv struct Enemy {
  enemy_type : EnemyType
  speed : Double
  mut health : Double
  mut shoot_timer : Double // Timer for Devil shooting
  left_node : @animation.AnimationNodeIndex
  right_node : @animation.AnimationNodeIndex
  mut current_node : @animation.AnimationNodeIndex?
}

///|
#derive(Eq)
enum EnemyType {
  Creeper
  Icecream
  Orc
  Skull
  Teleman
  Devil
  Pirate
}

///|
pub extend EnemyType with Eq::{not_equal, equal}

///|
fn enemies() -> @ecs.ComponentStore[Enemy] {
  @ecs.components()
}

///|
fn create_enemy_animation_nodes(
  data : EnemyData,
) -> (
  @animation.AnimationNodeIndex,
  @animation.AnimationNodeIndex,
  @animation.AnimationGraphHandle,
) {
  let graph = @animation.AnimationGraph()
  let right_node = register_sprite_animation_node(graph, data.right_animation)
  let left_node = register_sprite_animation_node(graph, data.left_animation)
  (left_node, right_node, @animation.register_animation_graph_asset(graph))
}

///|
fn play_enemy_animation_state(
  entity : @ecs.Entity,
  state : Enemy,
  animation : SpriteAnimationDef,
  node : @animation.AnimationNodeIndex,
) -> Unit {
  if state.current_node == Some(node) {
    return
  }
  @sprite.sprites().set(entity, sprite_animation_sprite(animation))
  let player = @animation.animation_players().get(entity).unwrap()
  let transitions = @animation.animation_transitions().get(entity).unwrap()
  let duration = 0.0
  ignore(transitions.play(player, node, duration))
  state.current_node = Some(node)
}

///|
fn get_enemy_data(enemy_type : EnemyType) -> EnemyData {
  match enemy_type {
    Creeper => creeper_data
    Icecream => icecream_data
    Orc => orc_data
    Skull => skull_data
    Teleman => teleman_data
    Devil => devil_data
    Pirate => pirate_data
  }
}

///|
fn select_enemy_type_for_wave(rand : @random.Rand) -> EnemyType? {
  let state = wave_state()
  let wave = game_state().current_wave
  if wave < 1 || wave > 10 {
    return None
  }
  let plan = wave_spawn_plans[wave - 1]
  let available_types = []

  // Build list of available enemy types based on what hasn't been fully spawned
  if state.creeper_spawned < plan.creeper_count {
    available_types.push(Creeper)
  }
  if state.icecream_spawned < plan.icecream_count {
    available_types.push(Icecream)
  }
  if state.orc_spawned < plan.orc_count {
    available_types.push(Orc)
  }
  if state.skull_spawned < plan.skull_count {
    available_types.push(Skull)
  }
  if state.teleman_spawned < plan.teleman_count {
    available_types.push(Teleman)
  }
  if state.devil_spawned < plan.devil_count {
    available_types.push(Devil)
  }
  if state.pirate_spawned < plan.pirate_count {
    available_types.push(Pirate)
  }

  // If no enemies left to spawn, return None
  if available_types.length() == 0 {
    return None
  }

  // Randomly select from available types
  let index = rand.int(limit=available_types.length())
  let enemy_type = available_types[index]

  // Increment the counter for the selected type
  match enemy_type {
    Creeper => state.creeper_spawned += 1
    Icecream => state.icecream_spawned += 1
    Orc => state.orc_spawned += 1
    Skull => state.skull_spawned += 1
    Teleman => state.teleman_spawned += 1
    Devil => state.devil_spawned += 1
    Pirate => state.pirate_spawned += 1
  }
  Some(enemy_type)
}

///|
fn enemy_ai_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  for e, state in enemies() {
    guard e.is_alive() else { continue }
    guard @transform.local_transform(game.player_entity)
      is Some(player_transform) else {
      return
    }
    guard @transform.local_transform(e) is Some(enemy_transform) else {
      continue
    }
    let data = get_enemy_data(state.enemy_type)
    let player_position = @math.Vec2(
      player_transform.translation.x,
      player_transform.translation.y,
    )
    let position = @math.Vec2(
      enemy_transform.translation.x,
      enemy_transform.translation.y,
    )
    let dir = player_position - position
    let vel = dir.normalize_or_zero().scalar_mul(state.speed)
    @physics2d.linear_velocities().set(e, vel)

    // Use the appropriate animation based on direction
    if vel.x >= 0.0 {
      play_enemy_animation_state(
        e,
        state,
        data.right_animation,
        state.right_node,
      )
    } else {
      play_enemy_animation_state(e, state, data.left_animation, state.left_node)
    }
  }
}

///|
fn devil_shooting_system(_world : @ecs.World) -> Unit {
  let game = game_state()
  let delta = @time.delta()
  for e, state in enemies() {
    guard e.is_alive() else { continue }
    // Only Devil enemies shoot
    if state.enemy_type != Devil {
      continue
    }
    guard @transform.local_transform(e) is Some(enemy_transform) else {
      continue
    }
    guard @transform.local_transform(game.player_entity)
      is Some(player_transform) else {
      return
    }
    let enemy_pos = @math.Vec2(
      enemy_transform.translation.x,
      enemy_transform.translation.y,
    )
    let player_pos = @math.Vec2(
      player_transform.translation.x,
      player_transform.translation.y,
    )

    // Update shoot timer
    if state.shoot_timer > 0.0 {
      state.shoot_timer -= delta
    }

    // Shoot when timer expires
    if state.shoot_timer <= 0.0 {
      state.shoot_timer = 5.0 // Reset cooldown
      shoot_enemy_bullet(enemy_pos, player_pos)
    }
  }
}

///|
type EnemySpawnPlan = @ecs.SpawnPlan[
  (
    (
      @transform.Spatial,
      @physics2d.Velocity,
      @sprite.Sprite,
      @physics2d.ColliderShape,
      @physics2d.Collider,
      Enemy,
    ),
    (
      @animation.AnimationGraphHandle,
      @animation.AnimationPlayer,
      @animation.AnimationTransitions,
      @animation.AnimationTargetId,
    ),
  ),
]

///|
type EnemyBulletSpawnPlan = @ecs.SpawnPlan[
  (
    @sprite.Sprite,
    @transform.Spatial,
    @physics2d.Velocity,
    @physics2d.ColliderShape,
    @physics2d.Area,
  ),
]

///|
fn shoot_enemy_bullet(enemy_pos : @math.Vec2, player_pos : @math.Vec2) -> Unit {
  let runtime = survivors_runtime()
  let velocity = @physics2d.Velocity(
    (player_pos - enemy_pos).normalize_or_zero().scalar_mul(120.0),
  )
  let shape : @physics2d.ColliderShape = Rect(
    size=Vec2(4.0, 4.0),
    offset=Vec2(-2.0, -2.0),
  )
  let area = @physics2d.Area(
    CollisionFilter(enemybullet_collision_group, [
      player_collision_group, wall_collision_group,
    ]),
  )
  let bullet_entity = runtime.enemy_bullet_plan.spawn(
    (
      Sprite(
        color=@sprite.color_from_css("red"),
        custom_size=Some(Vec2(4.0, 4.0)),
      ),
      Spatial(
        @transform.Transform::from_xyz(
          enemy_pos.x,
          enemy_pos.y,
          BULLET_ZINDEX.to_double(),
        ),
      ),
      velocity,
      shape,
      area,
    ),
  )
  runtime.entities.push(bullet_entity)
  runtime.enemy_bullets.add(bullet_entity)
  survivors_timeout(5.0, fn() {
    ignore(bullet_entity.delete())
    runtime.enemy_bullets.remove(bullet_entity)
  })
}

///|
fn apply_player_damage() -> Unit {
  let game = game_state()
  if game.invincible {
    return
  }
  game.invincible = true
  let penalty = 250 * game.current_wave
  let new_score = (game.score - penalty).max(0)
  set_score(new_score)
  trigger_damage_effect()
  survivors_timeout(INVINCIBLE_TIME, fn() { game.invincible = false })
}

///|
fn enemy_collision_system(_world : @ecs.World) -> Unit {
  let runtime = survivors_runtime()
  let game = game_state()
  for
    event in @physics2d.contact_event_bus.read(
      runtime.enemy_contact_event_reader,
    ) {
    guard event.started else { continue }
    guard event.entity == game.player_entity else { continue }
    if enemies().contains(event.other) {
      apply_player_damage()
    }
  }
  for
    event in @physics2d.trigger_event_bus.read(
      runtime.enemy_trigger_event_reader,
    ) {
    guard event.entered else { continue }
    guard runtime.enemy_bullets.contains(event.area) else { continue }
    if event.other == game.player_entity {
      apply_player_damage()
    }
    ignore(event.area.delete())
    runtime.enemy_bullets.remove(event.area)
  }
}

///|
fn check_victory_system(_world : @ecs.World) -> Unit {
  let game = game_state()

  // Only check after timer has reached 0 (all 10 waves completed)
  if game.game_timer > 0.0 {
    return
  }

  // Count alive enemies
  let mut alive_count = 0
  for e, _state in enemies() {
    if e.is_alive() {
      alive_count += 1
    }
  }

  // If no enemies left, trigger victory
  if alive_count == 0 {
    GamePhase::set(GameOver)
  }
}
