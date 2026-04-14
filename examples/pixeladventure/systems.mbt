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
priv enum BirdContactOutcome {
  None
  Stomp
  Hurt
}

///|
fn play_sfx(sound : @audio.AudioHandle, enabled : Bool) -> Unit {
  if enabled {
    @audio.send_audio_event(sound, settings=@audio.PlaybackSettings::remove())
  }
}

///|
fn player_is_frozen(result : GameResult?) -> Bool {
  result is Some(_)
}

///|
fn set_ui_text(entity : @entity.Entity, content : String) -> Unit {
  let text = @ui.texts().get_or_init(entity, fn() { @ui.Text::new(content) })
  if text.content != content {
    text.content = content
  }
}

///|
fn set_ui_text_color(entity : @entity.Entity, color : String) -> Unit {
  let next_color = @ui.TextColor::from_css(color)
  if @ui.text_colors().get(entity) is Some(current) {
    if current.color != next_color.color {
      current.color = next_color.color
    }
  } else {
    @ui.text_colors().set(entity, next_color)
  }
}

///|
fn set_ui_image(entity : @entity.Entity, image : @ui.UiImage) -> Unit {
  if @ui.ui_images().get(entity) is Some(current) {
    if current != image {
      @ui.ui_images().set(entity, image)
    }
  } else {
    @ui.ui_images().set(entity, image)
  }
}

///|
fn result_text(result : GameResult?) -> String {
  match result {
    Some(Win) => "You Win!"
    Some(GameOver) => "Game Over!"
    None => ""
  }
}

///|
fn result_color(result : GameResult?) -> String {
  match result {
    Some(Win) => "green"
    Some(GameOver) => "red"
    None => "white"
  }
}

///|
fn volume_image(volume_on : Bool) -> @ui.UiImage {
  if volume_on {
    volume_on_ui_image
  } else {
    volume_off_ui_image
  }
}

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
}

///|
fn build_sprite_animation_clip_asset(
  animation : SpriteAnimationDef,
) -> @animation.AnimationClipHandle {
  let clip = @animation.AnimationClip::new(animation.name)
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
    @animation.AnimationTargetId::new("self"),
    @animation.VariableCurve::scalar(
      @animation.texture_atlas_index_field(),
      keys,
      interpolation=@animation.ChannelInterpolation::Step,
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
fn install_sprite_animation_player(
  entity : @entity.Entity,
  animation : SpriteAnimationDef,
  repeat? : @animation.RepeatAnimation = @animation.RepeatAnimation::Forever,
) -> (@animation.AnimationGraphHandle, @animation.AnimationNodeIndex) {
  ensure_sprite_animation_binding(entity)
  let (graph, nodes) = @animation.AnimationGraph::from_clips([
    build_sprite_animation_clip_asset(animation),
  ])
  let node = nodes[0]
  let graph_handle = @animation.register_animation_graph_asset(graph)
  @animation.animation_graph_handles().set(entity, graph_handle)
  ignore(
    @animation.animation_players().get(entity).unwrap().play(node, repeat~),
  )
  (graph_handle, node)
}

///|
fn play_player_animation(
  entity : @entity.Entity,
  controller : PlayerController,
) -> Unit {
  let (key, node, animation, repeat) = match
    (controller.state, controller.facing) {
    (Idle, Left) =>
      (
        IdleLeft,
        controller.animations.idle_left,
        player_idle_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Idle, Right) =>
      (
        IdleRight,
        controller.animations.idle_right,
        player_idle_right_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Run, Left) =>
      (
        RunLeft,
        controller.animations.run_left,
        player_run_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Run, Right) =>
      (
        RunRight,
        controller.animations.run_right,
        player_run_right_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Jump, Left) =>
      (
        JumpLeft,
        controller.animations.jump_left,
        player_jump_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Jump, Right) =>
      (
        JumpRight,
        controller.animations.jump_right,
        player_jump_right_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Fall, Left) =>
      (
        FallLeft,
        controller.animations.fall_left,
        player_fall_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Fall, Right) =>
      (
        FallRight,
        controller.animations.fall_right,
        player_fall_right_animation,
        @animation.RepeatAnimation::Forever,
      )
    (Hit, Left) =>
      (
        HitLeft,
        controller.animations.hit_left,
        player_hit_left_animation,
        @animation.RepeatAnimation::Never,
      )
    (Hit, Right) =>
      (
        HitRight,
        controller.animations.hit_right,
        player_hit_right_animation,
        @animation.RepeatAnimation::Never,
      )
  }
  if controller.active_animation == Some(key) {
    return
  }
  ensure_sprite_animation_binding(entity)
  @sprite.sprites().set(entity, sprite_animation_sprite(animation))
  let player = @animation.animation_players().get(entity).unwrap()
  let transitions = @animation.animation_transitions().get(entity).unwrap()
  let duration = 0.0
  ignore(transitions.play(player, node, duration, repeat~))
  controller.active_animation = Some(key)
}

///|
fn play_bird_animation(entity : @entity.Entity, bird : BirdController) -> Unit {
  let (key, node, animation, repeat) = match (bird.is_hurt, bird.direction) {
    (false, Left) =>
      (
        FlyLeft,
        bird.animations.fly_left,
        bird_fly_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (false, Right) =>
      (
        FlyRight,
        bird.animations.fly_right,
        bird_fly_right_animation,
        @animation.RepeatAnimation::Forever,
      )
    (true, Left) =>
      (
        HitLeft,
        bird.animations.hit_left,
        bird_hit_left_animation,
        @animation.RepeatAnimation::Never,
      )
    (true, Right) =>
      (
        HitRight,
        bird.animations.hit_right,
        bird_hit_right_animation,
        @animation.RepeatAnimation::Never,
      )
  }
  if bird.active_animation == Some(key) {
    return
  }
  ensure_sprite_animation_binding(entity)
  @sprite.sprites().set(entity, sprite_animation_sprite(animation))
  let player = @animation.animation_players().get(entity).unwrap()
  let transitions = @animation.animation_transitions().get(entity).unwrap()
  let duration = 0.0
  ignore(transitions.play(player, node, duration, repeat~))
  bird.active_animation = Some(key)
}

///|
fn sprite_animation_finished(entity : @entity.Entity) -> Bool {
  @animation.animation_players()
  .get(entity)
  .map_or(false, fn(player) { player.all_finished() })
}

///|
fn entity_rect(entity : @entity.Entity) -> @math.Rect? {
  guard @transform.transforms().get(entity) is Some(transform) else {
    return None
  }
  guard @physics2d.shapes().get(entity) is Some(shape) else { return None }
  let position = @math.Vec2(transform.translation.x, transform.translation.y)
  match shape {
    Rect(size~, offset~) =>
      Some(@math.Rect::{ position: position + offset, size })
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
    position: @math.Vec2(left, top),
    size: @math.Vec2(right - left, bottom - top),
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
fn apply_stomp_bounce(
  player_entity : @entity.Entity,
  controller : PlayerController,
  player_rect : @math.Rect,
  bird_rect : @math.Rect,
) -> Unit {
  let snap_delta_y = bird_rect.position[Y] -
    (player_rect.position[Y] + player_rect.size[Y])
  if snap_delta_y < 0.0 {
    guard @transform.transforms().get(player_entity) is Some(player_transform)
    @transform.transforms().set(
      player_entity,
      player_transform.with_translation(
        @math.Vec3::new(
          player_transform.translation.x,
          player_transform.translation.y + snap_delta_y,
          player_transform.translation.z,
        ),
      ),
    )
  }
  controller.pending_bounce_velocity_y = Some(-BUMP_V)
  let bounce_velocity = @physics2d.linear_velocities()
    .get(player_entity)
    .map_or(@math.Vec2(0.0, -BUMP_V), fn(velocity) {
      velocity.0.update(Y, -BUMP_V)
    })
  @physics2d.linear_velocities().set(player_entity, bounce_velocity)
}

///|
fn player_motion_base_velocity(
  resolved_velocity : @math.Vec2,
  pending_bounce_velocity_y : Double?,
) -> @math.Vec2 {
  match pending_bounce_velocity_y {
    Some(bounce_velocity_y) => resolved_velocity.update(Y, bounce_velocity_y)
    None => resolved_velocity
  }
}

///|
fn hurt_player(session : GameSession, controller : PlayerController) -> Unit {
  if controller.hurt_cooldown > 0.0 || player_is_frozen(session.result) {
    return
  }
  let knockback = match controller.facing {
    Left => @math.Vec2(ATTACK_V, 0.0)
    Right => @math.Vec2(-ATTACK_V, 0.0)
  }
  @physics2d.linear_velocities().set(session.player, knockback)
  controller.state = Hit
  controller.hurt_cooldown = HURT_COOLDOWN
  session.health -= 1
  if session.health <= 0 {
    session.result = Some(GameOver)
  }
  play_sfx(hurt_sound, session.volume_on)
}

///|
fn player_controller_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  guard players().get(session.player) is Some(controller) else { return }

  let delta = @time.delta()
  if controller.hurt_cooldown > 0.0 {
    controller.hurt_cooldown -= delta
    if controller.hurt_cooldown < 0.0 {
      controller.hurt_cooldown = 0.0
    }
  }

  if player_is_frozen(session.result) {
    @physics2d.linear_velocities().set(session.player, @math.Vec2::zero())
    match session.result {
      Some(Win) => controller.state = Idle
      Some(GameOver) => controller.state = Hit
      None => ()
    }
    play_player_animation(session.player, controller)
    return
  }

  let resolved_velocity = @physics2d.resolved_velocities()
    .get(session.player)
    .map_or(@math.Vec2::zero(), fn(velocity) { velocity.0 })
  let grounded = @physics2d.is_grounded(session.player)
  let velocity = player_motion_base_velocity(
    resolved_velocity,
    controller.pending_bounce_velocity_y,
  )
  controller.pending_bounce_velocity_y = None

  let mut new_velocity_x = velocity[X]
  let mut new_velocity_y = velocity[Y]

  if controller.state is Hit {
    if grounded {
      new_velocity_x = 0.0
    }
    if sprite_animation_finished(session.player) {
      controller.state = if grounded {
        Idle
      } else if velocity[Y] > 0.0 {
        Fall
      } else {
        Jump
      }
    }
  } else {
    if @inputs.is_pressed(@inputs.ArrowLeft) {
      new_velocity_x -= RUN_ACC * delta
      if new_velocity_x < -MAX_RUN_V {
        new_velocity_x = -MAX_RUN_V
      }
      controller.facing = Left
    } else if @inputs.is_pressed(@inputs.ArrowRight) {
      new_velocity_x += RUN_ACC * delta
      if new_velocity_x > MAX_RUN_V {
        new_velocity_x = MAX_RUN_V
      }
      controller.facing = Right
    } else {
      new_velocity_x = 0.0
    }

    if grounded && @inputs.is_just_pressed(@inputs.ArrowUp) {
      new_velocity_y = -JUMP_V
      controller.state = Jump
      play_sfx(jump_sound, session.volume_on)
    } else if !grounded {
      controller.state = if velocity[Y] > 0.0 { Fall } else { Jump }
    } else if new_velocity_x != 0.0 {
      controller.state = Run
    } else {
      controller.state = Idle
    }
  }

  new_velocity_y += GRAVITY * delta
  if new_velocity_y > MAX_FALL_V {
    new_velocity_y = MAX_FALL_V
  }
  @physics2d.linear_velocities().set(
    session.player,
    @math.Vec2(new_velocity_x, new_velocity_y),
  )
  play_player_animation(session.player, controller)
}

///|
fn player_bird_contact_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  if player_is_frozen(session.result) {
    return
  }
  guard players().get(session.player) is Some(controller) else { return }
  guard entity_rect(session.player) is Some(player_rect) else { return }

  let fixed_delta = @time.fixed_delta()
  let player_resolved_velocity = @physics2d.resolved_velocities()
    .get(session.player)
    .map_or(@math.Vec2::zero(), fn(v) { v.0 })
  let player_prev_rect = player_rect.shift(
    player_resolved_velocity.scalar_mul(-fixed_delta),
  )

  for pair in birds().to_array() {
    let bird_entity = pair.0
    if !bird_entity.is_alive() {
      birds().remove(bird_entity)
      continue
    }
    guard birds().get(bird_entity) is Some(bird) else { continue }
    if bird.is_hurt {
      continue
    }
    guard entity_rect(bird_entity) is Some(bird_rect) else { continue }
    let bird_resolved_velocity = @physics2d.resolved_velocities()
      .get(bird_entity)
      .map_or(@math.Vec2::zero(), fn(v) { v.0 })
    let bird_prev_rect = bird_rect.shift(
      bird_resolved_velocity.scalar_mul(-fixed_delta),
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
        controller.state = Jump
        apply_stomp_bounce(session.player, controller, player_rect, bird_rect)
      }
      BirdContactOutcome::Hurt => hurt_player(session, controller)
    }
    break
  }
}

///|
fn bird_patrol_system(_world : @ecs.World) -> Unit {
  for pair in birds().to_array() {
    let bird_entity = pair.0
    if !bird_entity.is_alive() {
      birds().remove(bird_entity)
      continue
    }
    guard birds().get(bird_entity) is Some(bird) else { continue }
    if bird.is_hurt {
      @physics2d.linear_velocities().set(bird_entity, @math.Vec2::zero())
      if @physics2d.colliders().get(bird_entity) is Some(collider) {
        collider.active = false
      }
      play_bird_animation(bird_entity, bird)
      if sprite_animation_finished(bird_entity) {
        bird_entity.destroy()
        birds().remove(bird_entity)
      }
      continue
    }

    let resolved_x = @physics2d.resolved_velocities()
      .get(bird_entity)
      .map_or(0.0, fn(v) { v.0[X] })
    let blocked = match bird.direction {
      Left => resolved_x > -BIRD_SPEED * 0.5
      Right => resolved_x < BIRD_SPEED * 0.5
    }
    if blocked {
      bird.direction = match bird.direction {
        Left => Right
        Right => Left
      }
    }

    match bird.direction {
      Left =>
        @physics2d.linear_velocities().set(
          bird_entity,
          @math.Vec2(-BIRD_SPEED, 0.0),
        )
      Right =>
        @physics2d.linear_velocities().set(
          bird_entity,
          @math.Vec2(BIRD_SPEED, 0.0),
        )
    }
    play_bird_animation(bird_entity, bird)
  }
}

///|
fn trigger_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  if player_is_frozen(session.result) {
    return
  }

  for pair in flags().to_array() {
    let flag_entity = pair.0
    if !flag_entity.is_alive() {
      flags().remove(flag_entity)
      continue
    }
    if @physics2d.get_contains(flag_entity).contains(session.player) {
      session.score += 100
      session.result = Some(Win)
      flag_entity.destroy()
      flags().remove(flag_entity)
    }
  }

  for pair in apples().to_array() {
    let apple_entity = pair.0
    if !apple_entity.is_alive() {
      apples().remove(apple_entity)
      continue
    }
    if @physics2d.get_contains(apple_entity).contains(session.player) {
      session.score += 10
      play_sfx(coin_sound, session.volume_on)
      apple_entity.destroy()
      apples().remove(apple_entity)
    }
  }
}

///|
fn volume_button_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  for event in @ui.click_event_bus.read(ui_click_reader()) {
    if event.entity == session.volume_button {
      session.volume_on = !session.volume_on
    }
  }
}

///|
fn pixeladventure_camera_follow_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  guard @transform.transforms().get(session.player) is Some(player_transform)
  let half_width = VIEWPORT_WIDTH * 0.5
  let half_height = VIEWPORT_HEIGHT * 0.5
  let target_x = player_transform.translation.x + 16.0
  let target_y = player_transform.translation.y + 16.0
  let world_width = session.world_size[X]
  let world_height = session.world_size[Y]
  let center_x = if world_width <= VIEWPORT_WIDTH {
    world_width * 0.5
  } else if target_x < half_width {
    half_width
  } else if target_x > world_width - half_width {
    world_width - half_width
  } else {
    target_x
  }
  let center_y = if world_height <= VIEWPORT_HEIGHT {
    world_height * 0.5
  } else if target_y < half_height {
    half_height
  } else if target_y > world_height - half_height {
    world_height - half_height
  } else {
    target_y
  }
  @transform.transforms().set(
    session.camera,
    @transform.Transform::from_xyz(center_x, center_y, 0.0),
  )
}

///|
fn hud_sync_system(_world : @ecs.World) -> Unit {
  guard active_session_entity() is Some(session_entity) else { return }
  guard sessions().get(session_entity) is Some(session) else { return }
  set_ui_text(session.result_box, result_text(session.result))
  set_ui_text_color(session.result_box, result_color(session.result))
  set_ui_text(session.score_box, "Score: " + session.score.to_string())
  set_ui_text(session.health_box, "HP: " + session.health.to_string())
  set_ui_image(session.volume_button, volume_image(session.volume_on))
}
