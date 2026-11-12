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
fn game_start(world : @ecs.World) -> Unit {
  ignore(@asset.load_font(FONT_PATH, family=FONT_FAMILY))
  @ui.set_ui_scale_mode(Viewport)
  configure_pixeladventure_input()
  reset_pixeladventure_world_store()
  let loaded_level = load_level_scene(world~)

  let result_box = spawn_text_box(
    Vec2(VIEWPORT_WIDTH / 2.0 - 96.0, VIEWPORT_HEIGHT / 2.0 - 32.0),
    "",
    "white",
    "24px ThaleahFat",
    size=Vec2(192.0, 32.0),
    align=Center,
    baseline=Center,
  )
  let score_box = spawn_text_box(
    Vec2(PLAYFIELD_LEFT_INSET, 16.0),
    "Score: 0",
    "white",
    "20px ThaleahFat",
    size=Vec2(VIEWPORT_WIDTH - PLAYFIELD_LEFT_INSET, 24.0),
    align=Center,
  )
  let health_box = spawn_text_box(
    Vec2(20.0, 16.0),
    "HP: 3",
    "red",
    "20px ThaleahFat",
  )
  let volume_button = spawn_game_entity(
    (
      @ui.Node::absolute(
        Vec2(VIEWPORT_WIDTH - 40.0, 18.0),
        size=Vec2(21.0, 22.0),
      ),
      @ui.ZIndex(BUTTON_ZINDEX),
      @ui.Button(),
      volume_image(true),
    ),
  )
  spawn_background(loaded_level.world_size)

  world.insert_resource(GameSession::{
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

  hud_sync_system(world)
  pixeladventure_camera_follow_system(world)
}

///|
fn spawn_text_box(
  offset : @math.Vec2,
  content : String,
  color : String,
  font : String,
  size~ : @math.Vec2 = Vec2(-1.0, -1.0),
  align~ : @render2d_types.HAlign = Left,
  baseline~ : @render2d_types.VAlign = Top,
) -> @ecs.Entity {
  spawn_game_entity(
    (
      @ui.Node::absolute(offset, size~),
      @ui.ZIndex(HUD_ZINDEX),
      @ui.Text(content),
      @ui.TextFont::from_css(font),
      @ui.TextColor::from_css(color),
      @ui.TextLayout(align~, baseline~),
    ),
  )
}

///|
fn register_sprite_animation_node(
  graph : @animation.AnimationGraph,
  animation : SpriteAnimationDef,
) -> @animation.AnimationNodeIndex {
  graph.add_clip(build_sprite_animation_clip_asset(animation))
}

///|
fn build_player_animation_nodes() -> (
  PlayerAnimationNodes,
  @animation.AnimationGraphHandle,
) {
  let graph = @animation.AnimationGraph()
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
  (nodes, @animation.register_animation_graph_asset(graph))
}

///|
fn build_bird_animation_nodes() -> (
  BirdAnimationNodes,
  @animation.AnimationGraphHandle,
) {
  let graph = @animation.AnimationGraph()
  let nodes = {
    fly_left: register_sprite_animation_node(graph, bird_fly_left_animation),
    fly_right: register_sprite_animation_node(graph, bird_fly_right_animation),
    hit_left: register_sprite_animation_node(graph, bird_hit_left_animation),
    hit_right: register_sprite_animation_node(graph, bird_hit_right_animation),
  }
  (nodes, @animation.register_animation_graph_asset(graph))
}

///|
fn spawn_player_entity(
  world~ : @ecs.World,
  x : Double,
  y : Double,
) -> @ecs.Entity {
  let (animations, graph) = build_player_animation_nodes()
  let shape : @physics2d.ColliderShape = Rect(
    size=Vec2(24.0, 32.0),
    offset=Vec2(4.0, 0.0),
  )
  let controller : PlayerController = {
    facing: Right,
    state: Idle,
    hurt_cooldown: 0.0,
    pending_bounce_velocity_y: None,
    move_direction: None,
    jump_requested: false,
    animations,
    active_animation: None,
  }
  let plan = @ecs.commands(world)
    .prepare_spawn()
    .combine(@ecs.commands(world).prepare_spawn())
  let entity = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
    plan,
    (
      (
        @transform.Spatial(@transform.Transform::from_xyz(x, y, PLAYER_Z)),
        sprite_animation_sprite(player_idle_right_animation),
        @physics2d.Velocity(@math.Vec2::zero()),
        shape,
        @physics2d.Collider(
          CollisionFilter(player_collision_group, [
            terrain_collision_group, trigger_collision_group,
          ]),
        ),
        controller,
      ),
      (
        graph,
        @animation.AnimationPlayer(),
        @animation.AnimationTransitions(),
        @animation.AnimationTargetId("self"),
      ),
    ),
  )
  pixeladventure_world_state().entities.push(entity)
  @ecs.commands(world).add(world => {
    play_player_animation(world~, entity, controller)
  })
  entity
}

///|
fn spawn_bird_entity(world~ : @ecs.World, x : Double, y : Double) -> Unit {
  let (animations, graph) = build_bird_animation_nodes()
  let shape : @physics2d.ColliderShape = Rect(
    size=Vec2(32.0, 32.0),
    offset=@math.Vec2::zero(),
  )
  let bird : BirdController = {
    direction: Right,
    is_hurt: false,
    animations,
    active_animation: None,
  }
  let plan = @ecs.commands(world)
    .prepare_spawn()
    .combine(@ecs.commands(world).prepare_spawn())
  let entity = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
    plan,
    (
      (
        @transform.Spatial(@transform.Transform::from_xyz(x, y, PLAYER_Z)),
        sprite_animation_sprite(bird_fly_right_animation),
        @physics2d.Velocity(Vec2(BIRD_SPEED, 0.0)),
        shape,
        @physics2d.Collider(
          CollisionFilter(enemy_collision_group, [terrain_collision_group]),
        ),
        bird,
      ),
      (
        graph,
        @animation.AnimationPlayer(),
        @animation.AnimationTransitions(),
        @animation.AnimationTargetId("self"),
      ),
    ),
  )
  pixeladventure_world_state().entities.push(entity)
  @ecs.commands(world).add(world => play_bird_animation(world~, entity, bird))
}

///|
fn spawn_background(size : @math.Vec2) -> Unit {
  ignore(
    spawn_game_entity(
      (
        @sprite.Sprite(
          image=Some(
            @asset.load_image("assets/pixeladventure/Background/Gray.png"),
          ),
          custom_size=Some(size),
          anchor=Anchor(Vec2(-0.5, 0.5)),
          image_mode=Tiled(Repeat),
        ),
        @transform.Spatial(@transform.Transform::from_xyz(0.0, 0.0, -100.0)),
      ),
    ),
  )
}

///|
type TerrainSpawnPlan = @ecs.SpawnPlan[
  (@transform.Spatial, @physics2d.ColliderShape, @physics2d.Collider),
]

///|
fn spawn_terrain_collider(
  plan : TerrainSpawnPlan,
  pos : @math.Vec2,
  size : @math.Vec2,
) -> Unit {
  let shape : @physics2d.ColliderShape = Rect(size~, offset=@math.Vec2::zero())
  let terrain = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
    plan,
    (
      Spatial(@transform.Transform::from_xyz(pos.x, pos.y, 0.0)),
      shape,
      Collider(
        CollisionFilter(terrain_collision_group, [
          player_collision_group, enemy_collision_group,
        ]),
      ),
    ),
  )
  pixeladventure_world_state().entities.push(terrain)
}

///|
fn spawn_flag_entity(world~ : @ecs.World, x : Double, y : Double) -> Unit {
  spawn_animated_item(world~, x, y, Vec2(64.0, 64.0), flag_idle_animation, FlagTag::{
  })
}

///|
fn spawn_apple_entity(world~ : @ecs.World, x : Double, y : Double) -> Unit {
  spawn_animated_item(world~, x, y, Vec2(32.0, 32.0), apple_spin_animation, AppleTag::{
  })
}

///|
fn[T : @ecs.Component] spawn_animated_item(
  world~ : @ecs.World,
  x : Double,
  y : Double,
  size : @math.Vec2,
  animation : SpriteAnimationDef,
  tag : T,
) -> Unit {
  let (graph, nodes) = @animation.AnimationGraph::from_clips([
    build_sprite_animation_clip_asset(animation),
  ])
  let graph_handle = @animation.register_animation_graph_asset(graph)
  let player = @animation.AnimationPlayer()
  ignore(player.play(nodes[0], repeat=Forever))
  let shape : @physics2d.ColliderShape = Rect(size~, offset=@math.Vec2::zero())
  let plan = @ecs.commands(world)
    .prepare_spawn()
    .combine(@ecs.commands(world).prepare_spawn())
  let entity = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
    plan,
    (
      (
        @transform.Spatial(@transform.Transform::from_xyz(x, y, ITEM_Z)),
        sprite_animation_sprite(animation),
        shape,
        @physics2d.Area(
          CollisionFilter(trigger_collision_group, [player_collision_group]),
        ),
        tag,
        graph_handle,
        player,
      ),
      (@animation.AnimationTransitions(), @animation.AnimationTargetId("self")),
    ),
  )
  pixeladventure_world_state().entities.push(entity)
}
