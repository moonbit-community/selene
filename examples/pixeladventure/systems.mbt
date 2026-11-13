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
type SpriteAnimations = @ecs.Query[
  (@sprite.Sprite, @animation.AnimationPlayer, @animation.AnimationTransitions),
]

///|
fn play_sfx(
  audio : GameAudio,
  sound : @audio.AudioHandle,
  enabled : Bool,
) -> Unit {
  if enabled {
    audio.events.send({
      source: sound,
      settings: @audio.PlaybackSettings::despawn(),
      target: None,
    })
  }
}

///|
fn player_is_frozen(result : GameResult?) -> Bool {
  result is Some(_)
}

///|
fn set_ui_text(
  texts : @ecs.Query[@ecs.Single[@ui.Text]],
  entity : @ecs.Entity,
  content : String,
) -> Unit {
  guard texts.get(entity) is Some(Single(text)) else { return }
  if text.content != content {
    text.content = content
  }
}

///|
fn set_ui_text_color(
  colors : @ecs.Query[@ecs.Single[@ui.TextColor]],
  entity : @ecs.Entity,
  color : String,
) -> Unit {
  let next_color = @ui.TextColor::from_css(color)
  if colors.get(entity) is Some(Single(current)) {
    if current.color != next_color.color {
      current.color = next_color.color
    }
  }
}

///|
fn set_ui_image(
  images : @ecs.Query[@ecs.Single[@ui.UiImage]],
  entity : @ecs.Entity,
  image : @ui.UiImage,
) -> Unit {
  if images.get(entity) is Some(Single(current)) && current != image {
    images.set(entity, Single(image))
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
    volume_on_ui_image()
  } else {
    volume_off_ui_image()
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
fn play_player_animation(
  animations : SpriteAnimations,
  entity : @ecs.Entity,
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
        Forever,
      )
    (Run, Left) =>
      (
        RunLeft,
        controller.animations.run_left,
        player_run_left_animation,
        Forever,
      )
    (Run, Right) =>
      (
        RunRight,
        controller.animations.run_right,
        player_run_right_animation,
        Forever,
      )
    (Jump, Left) =>
      (
        JumpLeft,
        controller.animations.jump_left,
        player_jump_left_animation,
        Forever,
      )
    (Jump, Right) =>
      (
        JumpRight,
        controller.animations.jump_right,
        player_jump_right_animation,
        Forever,
      )
    (Fall, Left) =>
      (
        FallLeft,
        controller.animations.fall_left,
        player_fall_left_animation,
        Forever,
      )
    (Fall, Right) =>
      (
        FallRight,
        controller.animations.fall_right,
        player_fall_right_animation,
        Forever,
      )
    (Hit, Left) =>
      (
        HitLeft,
        controller.animations.hit_left,
        player_hit_left_animation,
        Never,
      )
    (Hit, Right) =>
      (
        HitRight,
        controller.animations.hit_right,
        player_hit_right_animation,
        Never,
      )
  }
  if controller.active_animation == Some(key) {
    return
  }
  let (_, player, transitions) = animations.get(entity).unwrap()
  animations.set(
    entity,
    (sprite_animation_sprite(animation), player, transitions),
  )
  let duration = 0.0
  ignore(transitions.play(player, node, duration, repeat~))
  controller.active_animation = Some(key)
}

///|
fn play_bird_animation(
  animations : SpriteAnimations,
  entity : @ecs.Entity,
  bird : BirdController,
) -> Unit {
  let (key, node, animation, repeat) = match (bird.is_hurt, bird.direction) {
    (false, Left) =>
      (
        FlyLeft,
        bird.animations.fly_left,
        bird_fly_left_animation,
        @animation.RepeatAnimation::Forever,
      )
    (false, Right) =>
      (FlyRight, bird.animations.fly_right, bird_fly_right_animation, Forever)
    (true, Left) =>
      (HitLeft, bird.animations.hit_left, bird_hit_left_animation, Never)
    (true, Right) =>
      (HitRight, bird.animations.hit_right, bird_hit_right_animation, Never)
  }
  if bird.active_animation == Some(key) {
    return
  }
  let (_, player, transitions) = animations.get(entity).unwrap()
  animations.set(
    entity,
    (sprite_animation_sprite(animation), player, transitions),
  )
  let duration = 0.0
  ignore(transitions.play(player, node, duration, repeat~))
  bird.active_animation = Some(key)
}

///|
fn sprite_animation_finished(
  animations : SpriteAnimations,
  entity : @ecs.Entity,
) -> Bool {
  animations.get(entity).map_or(false, value => value.1.all_finished())
}

///|
fn entity_rect(
  spatial : @transform.Spatial,
  shape : @physics2d.ColliderShape,
) -> @math.Rect? {
  let transform = spatial.pose()
  let position = @math.Vec2(transform.translation.x, transform.translation.y)
  match shape {
    Rect(size~, offset~) => Some({ position: position + offset, size, })
    _ => None
  }
}

///|
fn rects_touch_or_intersect(a : @math.Rect, b : @math.Rect) -> Bool {
  a.position.x <= b.position.x + b.size.x &&
  a.position.x + a.size.x >= b.position.x &&
  a.position.y <= b.position.y + b.size.y &&
  a.position.y + a.size.y >= b.position.y
}

///|
fn sweep_rect(from : @math.Rect, to : @math.Rect) -> @math.Rect {
  let left = if from.position.x < to.position.x {
    from.position.x
  } else {
    to.position.x
  }
  let top = if from.position.y < to.position.y {
    from.position.y
  } else {
    to.position.y
  }
  let right_from = from.position.x + from.size.x
  let right_to = to.position.x + to.size.x
  let right = if right_from > right_to { right_from } else { right_to }
  let bottom_from = from.position.y + from.size.y
  let bottom_to = to.position.y + to.size.y
  let bottom = if bottom_from > bottom_to { bottom_from } else { bottom_to }
  { position: Vec2(left, top), size: Vec2(right - left, bottom - top), }
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
    return None
  }
  let player_bottom_prev = player_prev_rect.position.y + player_prev_rect.size.y
  let player_bottom = player_rect.position.y + player_rect.size.y
  let bird_top = bird_rect.position.y
  let bird_mid_y = bird_rect.position.y + bird_rect.size.y * 0.5
  if player_resolved_vy > 0.0 &&
    player_bottom_prev <= bird_mid_y &&
    player_bottom >= bird_top {
    Stomp
  } else {
    Hurt
  }
}

///|
fn apply_stomp_bounce(
  spatial : @transform.Spatial,
  velocity : @physics2d.LinearVelocity,
  controller : PlayerController,
  player_rect : @math.Rect,
  bird_rect : @math.Rect,
) -> @physics2d.LinearVelocity {
  let snap_delta_y = bird_rect.position.y -
    (player_rect.position.y + player_rect.size.y)
  if snap_delta_y < 0.0 {
    let transform = spatial.pose()
    spatial.set_local(
      transform.with_translation(
        Vec3(
          transform.translation.x,
          transform.translation.y + snap_delta_y,
          transform.translation.z,
        ),
      ),
    )
  }
  controller.pending_bounce_velocity_y = Some(-BUMP_V)
  Vec2(velocity.0.x, -BUMP_V)
}

///|
fn player_motion_base_velocity(
  resolved_velocity : @math.Vec2,
  pending_bounce_velocity_y : Double?,
) -> @math.Vec2 {
  match pending_bounce_velocity_y {
    Some(bounce_velocity_y) => Vec2(resolved_velocity.x, bounce_velocity_y)
    None => resolved_velocity
  }
}

///|
fn hurt_player(
  audio : GameAudio,
  session : GameSession,
  controller : PlayerController,
) -> @physics2d.LinearVelocity? {
  if controller.hurt_cooldown > 0.0 || player_is_frozen(session.result) {
    return None
  }
  let knockback = match controller.facing {
    Left => @math.Vec2(ATTACK_V, 0.0)
    Right => Vec2(-ATTACK_V, 0.0)
  }
  controller.state = Hit
  controller.hurt_cooldown = HURT_COOLDOWN
  session.health -= 1
  if session.health <= 0 {
    session.result = Some(GameOver)
  }
  play_sfx(audio, hurt_sound, session.volume_on)
  Some(knockback)
}

///|
fn player_input_system(
  players : @ecs.Query[@ecs.Single[PlayerController]],
  session_resource : @ecs.Res[GameSession]?,
) -> Unit {
  guard session_resource is Some(resource) else { return }
  let session = resource.get()
  guard players.get(session.player) is Some(Single(controller)) else { return }
  controller.move_direction = if @input_action.action_pressed(
      pixel_move_left_action(),
    ) {
    Some(Left)
  } else if @input_action.action_pressed(pixel_move_right_action()) {
    Some(Right)
  } else {
    None
  }
  controller.jump_requested = controller.jump_requested ||
    @input_action.action_just_pressed(pixel_jump_action())
}

///|
fn player_controller_system(
  players : @ecs.Query[(PlayerController, @physics2d.LinearVelocity)],
  animations : SpriteAnimations,
  session_resource : @ecs.Res[GameSession]?,
  time : @time.Time,
  motion : @physics2d.PhysicsMotion,
  audio : GameAudio,
) -> Unit {
  guard session_resource is Some(resource) else { return }
  let session = resource.get()
  guard players.get(session.player) is Some((controller, _)) else { return }
  let jump_requested = controller.jump_requested
  controller.jump_requested = false

  let delta = time.delta()
  if controller.hurt_cooldown > 0.0 {
    controller.hurt_cooldown -= delta
    if controller.hurt_cooldown < 0.0 {
      controller.hurt_cooldown = 0.0
    }
  }

  if player_is_frozen(session.result) {
    players.set(session.player, (controller, Velocity(@math.Vec2::zero())))
    match session.result {
      Some(Win) => controller.state = Idle
      Some(GameOver) => controller.state = Hit
      None => ()
    }
    play_player_animation(animations, session.player, controller)
    return
  }

  let resolved_velocity = motion
    .resolved_velocity(session.player)
    .map_or(@math.Vec2::zero(), fn(velocity) { velocity.0 })
  let grounded = motion.is_grounded(session.player)
  let velocity = player_motion_base_velocity(
    resolved_velocity,
    controller.pending_bounce_velocity_y,
  )
  controller.pending_bounce_velocity_y = None

  let mut new_velocity_x = velocity.x
  let mut new_velocity_y = velocity.y

  if controller.state is Hit {
    if grounded {
      new_velocity_x = 0.0
    }
    if sprite_animation_finished(animations, session.player) {
      controller.state = if grounded {
        Idle
      } else if velocity.y > 0.0 {
        Fall
      } else {
        Jump
      }
    }
  } else {
    if controller.move_direction is Some(Left) {
      new_velocity_x -= RUN_ACC * delta
      if new_velocity_x < -MAX_RUN_V {
        new_velocity_x = -MAX_RUN_V
      }
      controller.facing = Left
    } else if controller.move_direction is Some(Right) {
      new_velocity_x += RUN_ACC * delta
      if new_velocity_x > MAX_RUN_V {
        new_velocity_x = MAX_RUN_V
      }
      controller.facing = Right
    } else {
      new_velocity_x = 0.0
    }

    if grounded && jump_requested {
      new_velocity_y = -JUMP_V
      controller.state = Jump
      play_sfx(audio, jump_sound, session.volume_on)
    } else if !grounded {
      controller.state = if velocity.y > 0.0 { Fall } else { Jump }
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
  players.set(
    session.player,
    (controller, Velocity(Vec2(new_velocity_x, new_velocity_y))),
  )
  play_player_animation(animations, session.player, controller)
}

///|
fn player_bird_contact_system(
  players : @ecs.Query[
    (
      PlayerController,
      @transform.Spatial,
      @physics2d.ColliderShape,
      @physics2d.LinearVelocity,
    ),
  ],
  birds : @ecs.Query[
    (BirdController, @transform.Spatial, @physics2d.ColliderShape),
  ],
  session_resource : @ecs.Res[GameSession]?,
  time : @time.Time,
  entities : @ecs.Entities,
  motion : @physics2d.PhysicsMotion,
  audio : GameAudio,
) -> Unit {
  guard session_resource is Some(resource) else { return }
  let session = resource.get()
  if player_is_frozen(session.result) {
    return
  }
  guard players.get(session.player)
    is Some((controller, spatial, shape, velocity)) else {
    return
  }
  guard entity_rect(spatial, shape) is Some(player_rect) else { return }
  let fixed_delta = time.fixed_delta()
  let player_resolved_velocity = motion
    .resolved_velocity(session.player)
    .map_or(@math.Vec2::zero(), fn(v) { v.0 })
  let player_prev_rect = player_rect.shift(
    player_resolved_velocity.scalar_mul(-fixed_delta),
  )

  for bird_entity, (bird, bird_spatial, bird_shape) in birds {
    if !entities.is_alive(bird_entity) {
      continue
    }
    if bird.is_hurt {
      continue
    }
    guard entity_rect(bird_spatial, bird_shape) is Some(bird_rect) else {
      continue
    }
    let bird_resolved_velocity = motion
      .resolved_velocity(bird_entity)
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
        player_resolved_velocity.y,
      ) {
      None => continue
      Stomp => {
        bird.is_hurt = true
        controller.state = Jump
        let bounce = apply_stomp_bounce(
          spatial, velocity, controller, player_rect, bird_rect,
        )
        players.set(session.player, (controller, spatial, shape, bounce))
      }
      Hurt =>
        if hurt_player(audio, session, controller) is Some(knockback) {
          players.set(session.player, (controller, spatial, shape, knockback))
        }
    }
    break
  }
}

///|
fn bird_patrol_system(
  birds : @ecs.Query[(BirdController, @physics2d.LinearVelocity)],
  colliders : @ecs.Query[@ecs.Single[@physics2d.Collider]],
  animations : SpriteAnimations,
  commands : @ecs.Commands,
  entities : @ecs.Entities,
  motion : @physics2d.PhysicsMotion,
) -> Unit {
  for bird_entity, (bird, _) in birds {
    if !entities.is_alive(bird_entity) {
      continue
    }
    if bird.is_hurt {
      birds.set(bird_entity, (bird, Velocity(@math.Vec2::zero())))
      if colliders.get(bird_entity).map(value => value.0) is Some(collider) {
        collider.active = false
      }
      play_bird_animation(animations, bird_entity, bird)
      if sprite_animation_finished(animations, bird_entity) {
        commands.delete(bird_entity)
      }
      continue
    }

    let resolved_x = motion
      .resolved_velocity(bird_entity)
      .map_or(0.0, fn(v) { v.0.x })
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

    let speed = match bird.direction {
      Left => -BIRD_SPEED
      Right => BIRD_SPEED
    }
    birds.set(bird_entity, (bird, Velocity(Vec2(speed, 0.0))))
    play_bird_animation(animations, bird_entity, bird)
  }
}

///|
fn trigger_system(
  flags : @ecs.Query[(FlagTag, @physics2d.Area)],
  apples : @ecs.Query[(AppleTag, @physics2d.Area)],
  session_resource : @ecs.Res[GameSession]?,
  commands : @ecs.Commands,
  entities : @ecs.Entities,
  audio : GameAudio,
) -> Unit {
  guard session_resource is Some(resource) else { return }
  let session = resource.get()
  if player_is_frozen(session.result) {
    return
  }

  for flag_entity, (_, area) in flags {
    if !entities.is_alive(flag_entity) {
      continue
    }
    if area.contains.contains(session.player) {
      session.score += 100
      session.result = Some(Win)
      commands.delete(flag_entity)
    }
  }

  for apple_entity, (_, area) in apples {
    if !entities.is_alive(apple_entity) {
      continue
    }
    if area.contains.contains(session.player) {
      session.score += 10
      play_sfx(audio, coin_sound, session.volume_on)
      commands.delete(apple_entity)
    }
  }
}

///|
fn volume_button_system(
  session_resource : @ecs.Res[GameSession]?,
  clicks : UiClicks,
) -> Unit {
  guard session_resource is Some(resource) else { return }
  let session = resource.get()
  for event in clicks.events.read() {
    if event.entity == session.volume_button {
      session.volume_on = !session.volume_on
    }
  }
}

///|
fn pixeladventure_camera_follow_system(
  spatials : @ecs.Query[@ecs.Single[@transform.Spatial]],
  session_resource : @ecs.Res[GameSession]?,
) -> Unit {
  if session_resource is Some(resource) {
    update_camera(spatials, resource.get())
  }
}

///|
fn update_camera(
  spatials : @ecs.Query[@ecs.Single[@transform.Spatial]],
  session : GameSession,
) -> Unit {
  guard spatials.get(session.player) is Some(Single(player)) else { return }
  let player_transform = player.pose()
  let half_width = VIEWPORT_WIDTH * 0.5
  let half_height = VIEWPORT_HEIGHT * 0.5
  let target_x = player_transform.translation.x + 16.0
  let target_y = player_transform.translation.y + 16.0
  let world_width = session.world_size.x
  let world_height = session.world_size.y
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
  guard spatials.get(session.camera) is Some(Single(camera)) else { return }
  camera.set_local(@transform.Transform::from_xyz(center_x, center_y, 0.0))
}

///|
fn hud_sync_system(
  texts : @ecs.Query[@ecs.Single[@ui.Text]],
  colors : @ecs.Query[@ecs.Single[@ui.TextColor]],
  images : @ecs.Query[@ecs.Single[@ui.UiImage]],
  session_resource : @ecs.Res[GameSession]?,
) -> Unit {
  if session_resource is Some(resource) {
    sync_hud(texts, colors, images, resource.get())
  }
}

///|
fn sync_hud(
  texts : @ecs.Query[@ecs.Single[@ui.Text]],
  colors : @ecs.Query[@ecs.Single[@ui.TextColor]],
  images : @ecs.Query[@ecs.Single[@ui.UiImage]],
  session : GameSession,
) -> Unit {
  set_ui_text(texts, session.result_box, result_text(session.result))
  set_ui_text_color(colors, session.result_box, result_color(session.result))
  set_ui_text(texts, session.score_box, "Score: " + session.score.to_string())
  set_ui_text(texts, session.health_box, "HP: " + session.health.to_string())
  set_ui_image(images, session.volume_button, volume_image(session.volume_on))
}

///|
priv struct GameAudio {
  events : @event.EventWriter[@audio.AudioEvent]
}

///|
impl @ecs.SystemParam for GameAudio with fn prepare(world) {
  let audio : GameAudio = { events: @audio.audio_event_bus.writer(world~), }
  _ => audio
}
