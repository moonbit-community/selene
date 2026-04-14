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
fn game_start(_world : @ecs.World) -> Unit {
  ignore(@asset.load_font(FONT_PATH, family=FONT_FAMILY))
  @ui.set_ui_scale_mode(@ui.UiScaleMode::Viewport)
  reset_pixeladventure_world_store()
  let loaded_level = load_level_scene()

  let session_entity = @entity.Entity::new()
  let result_box = @entity.Entity::new()
  let score_box = @entity.Entity::new()
  let health_box = @entity.Entity::new()
  let volume_button = @entity.Entity::new()

  spawn_background(loaded_level.world_size)
  spawn_hud(result_box, score_box, health_box, volume_button)

  sessions().set(session_entity, {
    player: loaded_level.player_entity,
    camera: loaded_level.camera_entity,
    result_box,
    score_box,
    health_box,
    volume_button,
    score: 0,
    health: 3,
    volume_on: true,
    result: None,
    world_size: loaded_level.world_size,
  })

  hud_sync_system(@ecs.require_current_world())
  pixeladventure_camera_follow_system(@ecs.require_current_world())
}

///|
fn configure_text_box(
  entity : @entity.Entity,
  offset : @math.Vec2,
  content : String,
  color : String,
  font : String,
  size? : @math.Vec2 = @math.Vec2(-1.0, -1.0),
  align? : @math.HAlign = @math.HAlign::Left,
  baseline? : @math.VAlign = @math.VAlign::Top,
) -> Unit {
  @ui.nodes().set(entity, @ui.Node::absolute(offset, size~))
  @ui.z_indexes().set(entity, @ui.ZIndex::new(HUD_ZINDEX))
  set_ui_text(entity, content)
  @ui.text_fonts().set(entity, @ui.TextFont::from_css(font))
  set_ui_text_color(entity, color)
  @ui.text_layouts().set(entity, @ui.TextLayout::new(align~, baseline~))
}

///|
fn spawn_hud(
  result_box : @entity.Entity,
  score_box : @entity.Entity,
  health_box : @entity.Entity,
  volume_button : @entity.Entity,
) -> Unit {
  configure_text_box(
    result_box,
    @math.Vec2(VIEWPORT_WIDTH / 2.0 - 96.0, VIEWPORT_HEIGHT / 2.0 - 32.0),
    "",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2(192.0, 32.0),
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
  )
  configure_text_box(
    score_box,
    @math.Vec2(PLAYFIELD_LEFT_INSET, 16.0),
    "Score: 0",
    "white",
    "20px ThaleahFat",
    size=@math.Vec2(VIEWPORT_WIDTH - PLAYFIELD_LEFT_INSET, 24.0),
    align=@math.HAlign::Center,
  )
  configure_text_box(
    health_box,
    @math.Vec2(20.0, 16.0),
    "HP: 3",
    "red",
    "20px ThaleahFat",
  )
  @ui.nodes().set(
    volume_button,
    @ui.Node::absolute(
      @math.Vec2(VIEWPORT_WIDTH - 40.0, 18.0),
      size=@math.Vec2(21.0, 22.0),
    ),
  )
  @ui.z_indexes().set(volume_button, @ui.ZIndex::new(BUTTON_ZINDEX))
  @ui.buttons().set(volume_button, @ui.Button::new())
  @ui.ui_images().set(volume_button, volume_image(true))
}

///|
fn register_sprite_animation_node(
  graph : @animation.AnimationGraph,
  animation : SpriteAnimationDef,
) -> @animation.AnimationNodeIndex {
  graph.add_clip(build_sprite_animation_clip_asset(animation))
}

///|
fn build_player_animation_nodes(
  entity : @entity.Entity,
) -> PlayerAnimationNodes {
  let graph = @animation.AnimationGraph::new()
  let nodes = {
    idle_left: register_sprite_animation_node(graph, player_idle_left_animation),
    idle_right: register_sprite_animation_node(
      graph, player_idle_right_animation,
    ),
    run_left: register_sprite_animation_node(graph, player_run_left_animation),
    run_right: register_sprite_animation_node(graph, player_run_right_animation),
    fall_left: register_sprite_animation_node(graph, player_fall_left_animation),
    fall_right: register_sprite_animation_node(
      graph, player_fall_right_animation,
    ),
    jump_left: register_sprite_animation_node(graph, player_jump_left_animation),
    jump_right: register_sprite_animation_node(
      graph, player_jump_right_animation,
    ),
    hit_left: register_sprite_animation_node(graph, player_hit_left_animation),
    hit_right: register_sprite_animation_node(graph, player_hit_right_animation),
  }
  let graph_handle = @animation.register_animation_graph_asset(graph)
  ensure_sprite_animation_binding(entity)
  @animation.animation_graph_handles().set(entity, graph_handle)
  nodes
}

///|
fn build_bird_animation_nodes(entity : @entity.Entity) -> BirdAnimationNodes {
  let graph = @animation.AnimationGraph::new()
  let nodes = {
    fly_left: register_sprite_animation_node(graph, bird_fly_left_animation),
    fly_right: register_sprite_animation_node(graph, bird_fly_right_animation),
    hit_left: register_sprite_animation_node(graph, bird_hit_left_animation),
    hit_right: register_sprite_animation_node(graph, bird_hit_right_animation),
  }
  let graph_handle = @animation.register_animation_graph_asset(graph)
  ensure_sprite_animation_binding(entity)
  @animation.animation_graph_handles().set(entity, graph_handle)
  nodes
}

///|
fn configure_player_entity(entity : @entity.Entity) -> Unit {
  let animation_nodes = build_player_animation_nodes(entity)
  @sprite.sprites().set(
    entity,
    sprite_animation_sprite(player_idle_right_animation),
  )
  set_entity_z(entity, PLAYER_Z)
  @physics2d.linear_velocities().set(entity, @math.Vec2::zero())
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2(24.0, 32.0), offset=@math.Vec2(4.0, 0.0)),
  )
  @physics2d.colliders().set(
    entity,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(player_collision_group, [
        terrain_collision_group, trigger_collision_group,
      ]),
    ),
  )
  players().set(entity, {
    facing: Right,
    state: Idle,
    hurt_cooldown: 0.0,
    pending_bounce_velocity_y: None,
    animations: animation_nodes,
    active_animation: None,
  })
  guard players().get(entity) is Some(controller)
  play_player_animation(entity, controller)
}

///|
fn configure_bird_entity(entity : @entity.Entity) -> Unit {
  let animation_nodes = build_bird_animation_nodes(entity)
  @sprite.sprites().set(
    entity,
    sprite_animation_sprite(bird_fly_right_animation),
  )
  @physics2d.linear_velocities().set(entity, @math.Vec2(BIRD_SPEED, 0.0))
  set_entity_z(entity, PLAYER_Z)
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2(32.0, 32.0), offset=@math.Vec2::zero()),
  )
  @physics2d.colliders().set(
    entity,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(enemy_collision_group, [
        terrain_collision_group,
      ]),
    ),
  )
  birds().set(entity, {
    direction: Right,
    is_hurt: false,
    animations: animation_nodes,
    active_animation: None,
  })
  guard birds().get(entity) is Some(bird)
  play_bird_animation(entity, bird)
}

///|
fn spawn_background(size : @math.Vec2) -> Unit {
  let background = @entity.Entity::new()
  @sprite.sprites().set(
    background,
    @sprite.Sprite::new(
      image=Some(@asset.load_image("assets/pixeladventure/Background/Gray.png")),
      custom_size=Some(size),
      anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
      image_mode=@sprite.Tiled(Repeat),
    ),
  )
  @transform.transforms().set(
    background,
    @transform.Transform::from_xyz(0.0, 0.0, -100.0),
  )
}

///|
fn spawn_terrain_collider(pos : @math.Vec2, size : @math.Vec2) -> Unit {
  let terrain = @entity.Entity::new()
  @transform.transforms().set(
    terrain,
    @transform.Transform::from_xyz(pos[X], pos[Y], 0.0),
  )
  @physics2d.shapes().set(terrain, Rect(size~, offset=@math.Vec2::zero()))
  @physics2d.colliders().set(
    terrain,
    @physics2d.Collider::new(
      @physics2d.CollisionFilter::new(terrain_collision_group, [
        player_collision_group, enemy_collision_group,
      ]),
    ),
  )
}

///|
let flag_idle_frame_size : @math.Vec2 = @math.Vec2(64.0, 64.0)

///|
fn flag_idle_frame_rect() -> @math.Rect {
  { position: @math.Vec2::zero(), size: flag_idle_frame_size }
}

///|
fn default_flag_sprite() -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(@asset.load_image(FLAG_IDLE_PATH)),
    rect=Some(flag_idle_frame_rect()),
    custom_size=Some(flag_idle_frame_size),
    anchor=@sprite.Anchor(@math.Vec2(-0.5, 0.5)),
  )
}

///|
fn normalized_flag_sprite(sprite : @sprite.Sprite) -> @sprite.Sprite {
  let resolved_image = match sprite.image {
    Some(image) => Some(image)
    None => Some(@asset.load_image(FLAG_IDLE_PATH))
  }
  // Checkpoint flag asset is a horizontal strip (640x64). If no rect is set,
  // force the first 64x64 frame so we do not sample the entire strip.
  let resolved_rect = match sprite.rect {
    Some(rect) => Some(rect)
    None =>
      match resolved_image.bind(@asset.image_path) {
        Some(path) if path == FLAG_IDLE_PATH => Some(flag_idle_frame_rect())
        _ => None
      }
  }
  let resolved_custom_size = match sprite.custom_size {
    Some(size) => Some(size)
    None => Some(flag_idle_frame_size)
  }
  @sprite.Sprite::new(
    image=resolved_image,
    texture_atlas=sprite.texture_atlas,
    rect=resolved_rect,
    color=sprite.color,
    custom_size=resolved_custom_size,
    anchor=sprite.anchor,
    flip_x=sprite.flip_x,
    flip_y=sprite.flip_y,
    image_mode=sprite.image_mode,
  )
}

///|
fn configure_flag_entity(entity : @entity.Entity) -> Unit {
  let flag_sprite = match @sprite.sprites().get(entity) {
    Some(sprite) => normalized_flag_sprite(sprite)
    None => default_flag_sprite()
  }
  @sprite.sprites().set(entity, flag_sprite)
  if flag_sprite.image.bind(@asset.image_path) == Some(FLAG_IDLE_PATH) {
    @sprite.sprites().set(entity, sprite_animation_sprite(flag_idle_animation))
    ignore(install_sprite_animation_player(entity, flag_idle_animation))
  }
  set_entity_z(entity, ITEM_Z)
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2(64.0, 64.0), offset=@math.Vec2::zero()),
  )
  @physics2d.areas().set(
    entity,
    @physics2d.Area::new(
      @physics2d.CollisionFilter::new(trigger_collision_group, [
        player_collision_group,
      ]),
    ),
  )
  flags().set(entity, ())
}

///|
fn configure_apple_entity(entity : @entity.Entity) -> Unit {
  @sprite.sprites().set(entity, sprite_animation_sprite(apple_spin_animation))
  ignore(install_sprite_animation_player(entity, apple_spin_animation))
  set_entity_z(entity, ITEM_Z)
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2(32.0, 32.0), offset=@math.Vec2::zero()),
  )
  @physics2d.areas().set(
    entity,
    @physics2d.Area::new(
      @physics2d.CollisionFilter::new(trigger_collision_group, [
        player_collision_group,
      ]),
    ),
  )
  apples().set(entity, ())
}
