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
const BULLET_SPEED : Double = 5.0

///|
const BULLET_SIZE : Double = 4.0

///|
const BULLET_DURATION : Double = SHOOTING_RANGE / BULLET_SPEED

///|
fn shoot_bullet(player_pos : @math.Vec2D, target_pos : @math.Vec2D) -> Unit {
  let entity = @system.Entity::new()
  @sprite.sprites.set(
    entity,
    @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(Vec2D(BULLET_SIZE, BULLET_SIZE), "white"),
      BULLET_ZINDEX,
    ),
  )
  @position.positions.set(entity, player_pos)
  let vel = (target_pos - player_pos).normalize().scalar_mul(BULLET_SPEED)
  @velocity.velocities.set(entity, vel)
  @collision.collision_layers.set(entity, bullet_collision_layer)
  @collision.shapes.set(
    entity,
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(BULLET_SIZE, BULLET_SIZE),
      offset=@math.Vec2D(-BULLET_SIZE / 2.0, -BULLET_SIZE / 2.0),
    ),
  )
  let area = @collision.Area::new(
    @collision.CollisionMask::new([enemy_collision_layer, wall_collision_layer]),
  )
  let mut bullet_alive = true
  area.on_enter(fn(e) {
    guard enemies.get(e) is Some(enemy) else {
      bullet_alive = false
      entity.destroy()
    }
    guard bullet_alive else { return }
    enemy.health -= 1
    if enemy.health <= 0 {
      bullet_alive = false
      e.destroy()
      entity.destroy()
      set_score(game_state.score + 10)
    }
  })
  @collision.areas.set(entity, area)
  @system.timeout_with_frames(BULLET_DURATION.to_int(), fn() {
    bullet_alive = false
    entity.destroy()
  })
}
