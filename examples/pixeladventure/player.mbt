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
let player_idle_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png",
    11,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_run_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Run (32x32).png",
    12,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_fall_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_jump_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Jump (32x32).png",
    1,
    width=32.0,
    height=32.0,
  ),
  loop_=true,
  fps=12,
)

///|
let player_hit_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/pixeladventure/Main Characters/Mask Dude/Hit (32x32).png",
    7,
    width=32.0,
    height=32.0,
  ),
  loop_=false,
  fps=12,
)

///|
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::from_animation(player_idle_animation, 10)
  @sprite.sprites().set(game_state.player, player_sprite)
  @physics2d.linear_velocities().set(game_state.player, @math.Vec2D::zero())
  @transform.positions().set(game_state.player, pos)
  @physics2d.shapes().set(
    game_state.player,
    Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
  )
  @physics2d.colliders().set(
    game_state.player,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(player_collision_group, [
        terrain_collision_group, trigger_collision_group,
      ]),
    ),
  )
  @camera.attach_entity(game_state.player, @math.Vec2D(16.0, 16.0))
}

///|
enum PlayerState {
  Idle
  Jump
  Fall
  Hit
} derive(Eq, Show)

///|
let player_state_machine : @state.State[PlayerState] = @state.State::new(
  PlayerState::Idle,
)

///|
const GRAVITY = 1800.0

///|
const MAX_RUN_V = 240.0

///|
const JUMP_V = 680.0

///|
const MAX_FALL_V = 900.0

///|
const RUN_ACC = 3600.0

///|
const BUMP_V : Double = JUMP_V / 2.0

///|
priv enum BirdContactOutcome {
  None
  Stomp
  Hurt
}

///|
fn entity_rect(entity : @entity.Entity) -> @math.Rect? {
  guard @transform.positions().get(entity) is Some(position) else {
    return None
  }
  guard @physics2d.shapes().get(entity) is Some(shape) else { return None }
  match shape {
    Rect(size~, offset~) =>
      Some(@math.Rect::{ position: position.0 + offset, size })
    _ => None
  }
}

///|
fn rects_touch_or_intersect(a : @math.Rect, b : @math.Rect) -> Bool {
  a.position[X] <= b.position[X] + b.size[X] &&
  a.position[X] + a.size[X] >= b.position[X] &&
  a.position[Y] <= b.position[Y] + b.size[Y] &&
  a.position[Y] + a.size[Y] >= b.position[Y]
}

///|
fn sweep_rect(from : @math.Rect, to : @math.Rect) -> @math.Rect {
  let left = if from.position[X] < to.position[X] {
    from.position[X]
  } else {
    to.position[X]
  }
  let top = if from.position[Y] < to.position[Y] {
    from.position[Y]
  } else {
    to.position[Y]
  }
  let right_from = from.position[X] + from.size[X]
  let right_to = to.position[X] + to.size[X]
  let right = if right_from > right_to { right_from } else { right_to }
  let bottom_from = from.position[Y] + from.size[Y]
  let bottom_to = to.position[Y] + to.size[Y]
  let bottom = if bottom_from > bottom_to { bottom_from } else { bottom_to }
  {
    position: @math.Vec2D(left, top),
    size: @math.Vec2D(right - left, bottom - top),
  }
}

///|
fn classify_bird_contact(
  player_prev_rect : @math.Rect,
  player_rect : @math.Rect,
  bird_prev_rect : @math.Rect,
  bird_rect : @math.Rect,
  player_resolved_vy : Double,
) -> BirdContactOutcome {
  let player_sweep = sweep_rect(player_prev_rect, player_rect)
  let bird_sweep = sweep_rect(bird_prev_rect, bird_rect)
  if !rects_touch_or_intersect(player_sweep, bird_sweep) {
    return BirdContactOutcome::None
  }
  let player_bottom_prev = player_prev_rect.position[Y] +
    player_prev_rect.size[Y]
  let player_bottom = player_rect.position[Y] + player_rect.size[Y]
  let bird_top = bird_rect.position[Y]
  let bird_mid_y = bird_rect.position[Y] + bird_rect.size[Y] * 0.5
  if player_resolved_vy > 0.0 &&
    player_bottom_prev <= bird_mid_y &&
    player_bottom >= bird_top {
    BirdContactOutcome::Stomp
  } else {
    BirdContactOutcome::Hurt
  }
}

///|
fn apply_stomp_bounce(player_rect : @math.Rect, bird_rect : @math.Rect) -> Unit {
  let snap_delta_y = bird_rect.position[Y] -
    (player_rect.position[Y] + player_rect.size[Y])
  if snap_delta_y < 0.0 {
    guard @transform.positions().get(game_state.player) is Some(player_position)
    @transform.positions()[game_state.player] = player_position.0.update(
      Y,
      player_position.0[Y] + snap_delta_y,
    )
  }
  game_state.pending_bounce_velocity_y = Some(-BUMP_V)
  let bounce_velocity = @physics2d.linear_velocities()
    .get(game_state.player)
    .map_or(@math.Vec2D(0.0, -BUMP_V), fn(velocity) {
      velocity.0.update(Y, -BUMP_V)
    })
  @physics2d.linear_velocities()[game_state.player] = bounce_velocity
}

///|
fn player_motion_base_velocity(
  resolved_velocity : @math.Vec2D,
  pending_bounce_velocity_y : Double?,
) -> @math.Vec2D {
  match pending_bounce_velocity_y {
    Some(bounce_velocity_y) => resolved_velocity.update(Y, bounce_velocity_y)
    None => resolved_velocity
  }
}

///|
fn player_collision_system(delta : Double) -> Unit {
  if game_state.hurt_timer > 0.0 {
    game_state.hurt_timer -= 1.0
  }
  guard entity_rect(game_state.player) is Some(player_rect) else { return }
  let player_resolved_velocity = @physics2d.resolved_velocities()
    .get(game_state.player)
    .map_or(@math.Vec2D::zero(), fn(v) { v.0 })
  let player_prev_rect = player_rect.shift(
    player_resolved_velocity.scalar_mul(-delta),
  )
  for bird_entity, bird in birds {
    guard bird_entity.is_alive() else { continue }
    guard !bird.is_hurt else { continue }
    guard entity_rect(bird_entity) is Some(bird_rect) else { continue }
    let bird_resolved_velocity = @physics2d.resolved_velocities()
      .get(bird_entity)
      .map_or(@math.Vec2D::zero(), fn(v) { v.0 })
    let bird_prev_rect = bird_rect.shift(
      bird_resolved_velocity.scalar_mul(-delta),
    )
    match
      classify_bird_contact(
        player_prev_rect,
        player_rect,
        bird_prev_rect,
        bird_rect,
        player_resolved_velocity[Y],
      ) {
      BirdContactOutcome::None => continue
      BirdContactOutcome::Stomp => {
        bird.is_hurt = true
        set_player_state(PlayerState::Jump)
        apply_stomp_bounce(player_rect, bird_rect)
      }
      BirdContactOutcome::Hurt => hurt_player()
    }
    break
  }
}

///|
fn player_state_system(delta : Double) -> Unit {
  let player_state = player_state_machine.get()
  let resolved_velocity = @physics2d.resolved_velocities()
    .get(game_state.player)
    .unwrap_or(@math.Vec2D::zero())
  let velocity = player_motion_base_velocity(
    resolved_velocity.0,
    game_state.pending_bounce_velocity_y,
  )
  if game_state.pending_bounce_velocity_y is Some(_) {
    game_state.pending_bounce_velocity_y = None
  }
  let grounded = @physics2d.is_grounded(game_state.player)
  let mut new_velocity_x = velocity[X]
  let mut new_velocity_y = velocity[Y]
  if !(player_state is Hit) {
    if @inputs.is_pressed(@inputs.ArrowLeft) {
      new_velocity_x -= RUN_ACC * delta
      if new_velocity_x < -MAX_RUN_V {
        new_velocity_x = -MAX_RUN_V
      }
      game_state.direction = Direction2::Left
    } else if @inputs.is_pressed(@inputs.ArrowRight) {
      new_velocity_x += RUN_ACC * delta
      if new_velocity_x > MAX_RUN_V {
        new_velocity_x = MAX_RUN_V
      }
      game_state.direction = Direction2::Right
    } else {
      new_velocity_x = 0.0
    }
  }
  let transform = match game_state.direction {
    Direction2::Left => @math.Transform::flip_x(32.0)
    Direction2::Right => @math.Transform::new()
  }
  match player_state {
    Idle => {
      if velocity[X] == 0.0 {
        @sprite.play_animation(
          game_state.player,
          player_idle_animation,
          transform~,
        )
      } else {
        @sprite.play_animation(
          game_state.player,
          player_run_animation,
          transform~,
        )
      }
      if !grounded && velocity[Y] > 0.0 {
        set_player_state(PlayerState::Fall)
      }
      if @inputs.is_just_pressed(ArrowUp) && grounded {
        new_velocity_y = -JUMP_V
        set_player_state(PlayerState::Jump)
      }
    }
    Fall => {
      @sprite.play_animation(
        game_state.player,
        player_fall_animation,
        transform~,
      )
      if @physics2d.is_grounded(game_state.player) {
        set_player_state(PlayerState::Idle)
      }
    }
    Jump => {
      @sprite.play_animation(
        game_state.player,
        player_jump_animation,
        transform~,
      )
      if velocity[Y] > 0.0 {
        set_player_state(PlayerState::Fall)
      }
    }
    Hit => {
      @sprite.play_animation(
        game_state.player,
        player_hit_animation,
        transform~,
      )
      if @physics2d.is_grounded(game_state.player) {
        new_velocity_x = 0.0
      }
      if @sprite.is_animation_finished(game_state.player) {
        if @physics2d.is_grounded(game_state.player) {
          set_player_state(PlayerState::Idle)
        } else if velocity[Y] < 0.0 {
          set_player_state(PlayerState::Fall)
        } else {
          set_player_state(PlayerState::Jump)
        }
      }
    }
  }
  new_velocity_y += GRAVITY * delta
  if new_velocity_y > MAX_FALL_V {
    new_velocity_y = MAX_FALL_V
  }
  @physics2d.linear_velocities()[game_state.player] = @math.Vec2D(
    new_velocity_x, new_velocity_y,
  )
}
