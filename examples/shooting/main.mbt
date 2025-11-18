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
const VIEWPORT_WIDTH : Double = 800.0

///|
const VIEWPORT_HEIGHT : Double = 600.0

///|
const PLAYER_SPEED : Double = 150.0

///|
const PLAYER_SIZE : Double = 40.0

///|
const GUN_WIDTH : Double = 30.0

///|
const GUN_HEIGHT : Double = 8.0

///|
const GUN_COLOR : String = "gray"

///|
struct GameState {
  mut player_facing_direction : @math.Vec2D
}

///|
let player_entity : @entity.Entity = @entity.Entity::new()

///|
let gun_entity : @entity.Entity = @entity.Entity::new()

///|
let game_state : GameState = { player_facing_direction: @math.Vec2D(1.0, 0.0) }

///|
fn main {
  @system.App::new()
  .with_canvas_width(VIEWPORT_WIDTH)
  .with_canvas_height(VIEWPORT_HEIGHT)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(player_update_system)
  .run()
}

///|
fn game_start(_delta : Double) -> Unit {
  // Create player as a white circle
  @sprite.sprites.set(
    player_entity,
    @sprite.Sprite::from_color_circle(
      @sprite.ColorCircle::new(PLAYER_SIZE, "white"),
      0,
      offset=@math.Vec2D(-(PLAYER_SIZE / 2.0), -(PLAYER_SIZE / 2.0)),
    ),
  )
  @position.positions.set(
    player_entity,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0, VIEWPORT_HEIGHT / 2.0),
  )
  @velocity.velocities.set(player_entity, @math.Vec2D(0.0, 0.0))

  // Create gun as a gray rectangle
  @sprite.sprites.set(
    gun_entity,
    @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(@math.Vec2D(GUN_WIDTH, GUN_HEIGHT), GUN_COLOR),
      1, // z_index above player
      offset=@math.Vec2D(0.0, -(GUN_HEIGHT / 2.0)),
    ),
  )
  @position.positions.set(
    gun_entity,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 + PLAYER_SIZE, VIEWPORT_HEIGHT / 2.0),
  )
}

///|
fn player_update_system(_delta : Double) -> Unit {
  let vel = @inputs.key_vector(KeyW, KeyS, KeyA, KeyD)
    .normalize()
    .scalar_mul(PLAYER_SPEED)
  @velocity.velocities.set(player_entity, vel)

  // Update facing direction if player is moving
  if vel != @math.Vec2D::zero() {
    game_state.player_facing_direction = vel.normalize()
  }

  // Update gun position to follow player
  let player_pos = @position.positions.get(player_entity)
  match player_pos {
    Some(pos) => {
      let gun_base_pos = pos.0 + game_state.player_facing_direction.scalar_mul(PLAYER_SIZE)
      @position.positions.set(gun_entity, gun_base_pos)
    }
    None => ()
  }
}
