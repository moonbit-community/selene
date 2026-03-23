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
  ignore(@asset2.load_font(FONT_PATH, family=FONT_FAMILY))
  @ui.set_ui_scale_mode(@ui.UiScaleMode::Viewport)
  reset_pixeladventure_world_store()

  let session_entity = @entity.Entity::new()
  let player_entity = @entity.Entity::new()
  let camera_entity = @entity.Entity::new()
  let result_box = @entity.Entity::new()
  let score_box = @entity.Entity::new()
  let health_box = @entity.Entity::new()
  let volume_button = @entity.Entity::new()

  spawn_camera(camera_entity)
  spawn_hud(result_box, score_box, health_box, volume_button)
  let world_size = spawn_level(player_entity)

  sessions().set(session_entity, {
    player: player_entity,
    camera: camera_entity,
    result_box,
    score_box,
    health_box,
    volume_button,
    score: 0,
    health: 3,
    volume_on: true,
    result: None,
    world_size,
  })

  hud_sync_system(@ecs.require_current_world())
  pixeladventure_camera_follow_system(@ecs.require_current_world())
}

///|
fn configure_text_box(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  content : String,
  color : String,
  font : String,
  size? : @math.Vec2D = @math.Vec2D(-1.0, -1.0),
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
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 96.0, VIEWPORT_HEIGHT / 2.0 - 32.0),
    "",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2D(192.0, 32.0),
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
  )
  configure_text_box(
    score_box,
    @math.Vec2D(PLAYFIELD_LEFT_INSET, 16.0),
    "Score: 0",
    "white",
    "20px ThaleahFat",
    size=@math.Vec2D(VIEWPORT_WIDTH - PLAYFIELD_LEFT_INSET, 24.0),
    align=@math.HAlign::Center,
  )
  configure_text_box(
    health_box,
    @math.Vec2D(20.0, 16.0),
    "HP: 3",
    "red",
    "20px ThaleahFat",
  )
  @ui.nodes().set(
    volume_button,
    @ui.Node::absolute(
      @math.Vec2D(VIEWPORT_WIDTH - 40.0, 18.0),
      size=@math.Vec2D(21.0, 22.0),
    ),
  )
  @ui.z_indexes().set(volume_button, @ui.ZIndex::new(BUTTON_ZINDEX))
  @ui.buttons().set(volume_button, @ui.Button::new())
  @ui.ui_images().set(volume_button, volume_image(true))
}

///|
fn spawn_camera(camera_entity : @entity.Entity) -> Unit {
  @camera.cameras().set(camera_entity, @camera.Camera::new())
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @camera.orthographic_projections().set(
    camera_entity,
    @camera.OrthographicProjection::new(),
  )
  @transform.transforms().set(
    camera_entity,
    @transform.Transform::from_xyz(
      VIEWPORT_WIDTH / 2.0,
      VIEWPORT_HEIGHT / 2.0,
      0.0,
    ),
  )
}

///|
fn tile_to_vec2d(tile : Tile, tile_size : Int) -> @math.Vec2D {
  @math.Vec2D(
    tile.x.to_double() * tile_size.to_double(),
    tile.y.to_double() * tile_size.to_double(),
  )
}

///|
fn spawn_level(player_entity : @entity.Entity) -> @math.Vec2D {
  let parsed_tilemap = TileMap::from_json(tilemap)
  let world_width = parsed_tilemap.map_width.to_double() *
    parsed_tilemap.tile_size.to_double()
  let world_height = parsed_tilemap.map_height.to_double() *
    parsed_tilemap.tile_size.to_double()
  let world_size = @math.Vec2D(world_width, world_height)

  spawn_background(world_size)

  let player_tile = parsed_tilemap
    .get_tiles_first("MaskDude")
    .get(0)
    .unwrap_or_else(fn() { panic() })
  spawn_player(
    player_entity,
    tile_to_vec2d(player_tile, parsed_tilemap.tile_size),
  )

  let flag_tile = parsed_tilemap
    .get_tiles_first("Flag")
    .get(0)
    .unwrap_or_else(fn() { panic() })
  spawn_flag(
    tile_to_vec2d(flag_tile, parsed_tilemap.tile_size) - @math.Vec2D(16.0, 16.0),
  )

  for apple in parsed_tilemap.get_tiles_first("Apple") {
    spawn_apple(tile_to_vec2d(apple, parsed_tilemap.tile_size))
  }

  let grasses = parsed_tilemap.get_tiles("Grass")
  for grass in grasses {
    spawn_grass_visual(tile_to_vec2d(grass, parsed_tilemap.tile_size), grass.id)
  }
  build_terrain_colliders(
    grasses,
    parsed_tilemap.tile_size,
    parsed_tilemap.map_width,
  )

  for bird in parsed_tilemap.get_tiles_first("Bird") {
    spawn_bird(
      tile_to_vec2d(bird, parsed_tilemap.tile_size) + @math.Vec2D(0.0, 2.0),
    )
  }

  world_size
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
fn spawn_player(entity : @entity.Entity, pos : @math.Vec2D) -> Unit {
  let animation_nodes = build_player_animation_nodes(entity)
  @sprite.sprites().set(
    entity,
    sprite_animation_sprite(player_idle_right_animation),
  )
  @physics2d.linear_velocities().set(entity, @math.Vec2D::zero())
  @transform.transforms().set(
    entity,
    @transform.Transform::from_xyz(pos[X], pos[Y], PLAYER_Z),
  )
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
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
fn spawn_bird(pos : @math.Vec2D) -> Unit {
  let entity = @entity.Entity::new()
  let animation_nodes = build_bird_animation_nodes(entity)
  @sprite.sprites().set(
    entity,
    sprite_animation_sprite(bird_fly_right_animation),
  )
  @physics2d.linear_velocities().set(entity, @math.Vec2D(BIRD_SPEED, 0.0))
  @transform.transforms().set(
    entity,
    @transform.Transform::from_xyz(pos[X], pos[Y], PLAYER_Z),
  )
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
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
fn spawn_background(size : @math.Vec2D) -> Unit {
  let background = @entity.Entity::new()
  @sprite.sprites().set(
    background,
    @sprite.Sprite::new(
      image=Some(
        @asset2.load_image("assets/pixeladventure/Background/Gray.png"),
      ),
      custom_size=Some(size),
      anchor=@sprite.TopLeft,
      image_mode=@sprite.Tiled(Repeat),
    ),
  )
  @transform.transforms().set(
    background,
    @transform.Transform::from_xyz(0.0, 0.0, 0.0),
  )
}

///|
fn spawn_grass_visual(pos : @math.Vec2D, sprite_id : String) -> Unit {
  let src_pos = match sprite_id {
    "15" => @math.Vec2D(96.0, 0.0)
    "9" => @math.Vec2D(112.0, 0.0)
    "16" => @math.Vec2D(128.0, 0.0)
    "11" => @math.Vec2D(96.0, 16.0)
    "13" => @math.Vec2D(112.0, 16.0)
    "10" => @math.Vec2D(128.0, 16.0)
    "14" => @math.Vec2D(96.0, 32.0)
    "8" => @math.Vec2D(112.0, 32.0)
    "12" => @math.Vec2D(128.0, 32.0)
    _ => panic()
  }
  let grass = @entity.Entity::new()
  @sprite.sprites().set(
    grass,
    @sprite.Sprite::new(
      image=Some(
        @asset2.load_image("assets/pixeladventure/Terrain/Terrain (16x16).png"),
      ),
      rect=Some({ position: src_pos, size: @math.Vec2D(16.0, 16.0) }),
      custom_size=Some(@math.Vec2D(16.0, 16.0)),
      anchor=@sprite.TopLeft,
    ),
  )
  @transform.transforms().set(
    grass,
    @transform.Transform::from_xyz(pos[X], pos[Y], PLAYER_Z),
  )
}

///|
fn build_terrain_colliders(
  grasses : Array[Tile],
  tile_size : Int,
  map_width : Int,
) -> Unit {
  let rows : Map[Int, Array[Int]] = Map::new()
  for grass in grasses {
    rows.get_or_init(grass.y, () => []).push(grass.x)
  }
  let tile_size_d = tile_size.to_double()
  for y, columns in rows {
    columns.sort()
    let mut cursor = 0
    while cursor < columns.length() {
      let start_x = columns[cursor]
      let mut end_x = start_x
      cursor += 1
      while cursor < columns.length() && columns[cursor] == end_x + 1 {
        end_x = columns[cursor]
        cursor += 1
      }
      if start_x < map_width {
        spawn_terrain_collider(
          @math.Vec2D(
            start_x.to_double() * tile_size_d,
            y.to_double() * tile_size_d,
          ),
          @math.Vec2D(
            (end_x - start_x + 1).to_double() * tile_size_d,
            tile_size_d,
          ),
        )
      }
    }
  }
}

///|
fn spawn_terrain_collider(pos : @math.Vec2D, size : @math.Vec2D) -> Unit {
  let terrain = @entity.Entity::new()
  @transform.transforms().set(
    terrain,
    @transform.Transform::from_xyz(pos[X], pos[Y], 0.0),
  )
  @physics2d.shapes().set(terrain, Rect(size~, offset=@math.Vec2D::zero()))
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
fn spawn_flag(pos : @math.Vec2D) -> Unit {
  let entity = @entity.Entity::new()
  @sprite.sprites().set(
    entity,
    @sprite.Sprite::new(
      image=Some(
        @asset2.load_image(
          "assets/pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
        ),
      ),
      custom_size=Some(@math.Vec2D(64.0, 64.0)),
      anchor=@sprite.TopLeft,
    ),
  )
  @transform.transforms().set(
    entity,
    @transform.Transform::from_xyz(pos[X], pos[Y], ITEM_Z),
  )
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2D(64.0, 64.0), offset=@math.Vec2D::zero()),
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
fn spawn_apple(pos : @math.Vec2D) -> Unit {
  let entity = @entity.Entity::new()
  @sprite.sprites().set(entity, sprite_animation_sprite(apple_spin_animation))
  ignore(install_sprite_animation_player(entity, apple_spin_animation))
  @transform.transforms().set(
    entity,
    @transform.Transform::from_xyz(pos[X], pos[Y], ITEM_Z),
  )
  @physics2d.shapes().set(
    entity,
    Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
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
