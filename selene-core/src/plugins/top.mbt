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
fn add_system(
  app : @app.App,
  system : (Double) -> Unit,
  schedule : @system.Schedule,
  name : String,
  in_set? : @system_set.SystemSet,
  before? : Array[@system_set.SystemSet] = [],
  after? : Array[@system_set.SystemSet] = [],
) -> Unit {
  app.systems.push({
    system: fn(_world) { system(@time.delta()) },
    schedule,
    name,
    in_set,
    before,
    after,
    run_if: None,
  })
}

///|
fn register_builtin_events(app : @app.App) -> @app.App {
  app
  .add_event(@inputs.key_input_event_bus)
  .add_event(@inputs.mouse_button_event_bus)
  .add_event(@inputs.mouse_motion_event_bus)
  .add_event(@inputs.mouse_wheel_event_bus)
  .add_event(@inputs.gamepad_connection_event_bus)
  .add_event(@inputs.gamepad_button_event_bus)
  .add_event(@inputs.gamepad_axis_event_bus)
  .add_event(@input_action.input_action_event_bus)
  .add_event(@audio.audio_event_bus)
  .add_event(@scene.scene_instance_ready_events)
  .add_event(@collision.contact_event_bus)
  .add_event(@collision.trigger_event_bus)
  .add_event(@collision.pointer_event_bus)
  .add_event(@physics3d.contact_event_bus3d)
  .add_event(@physics3d.trigger_event_bus3d)
  .add_event(@ui.pointer_enter_event_bus)
  .add_event(@ui.pointer_leave_event_bus)
  .add_event(@ui.pointer_down_event_bus)
  .add_event(@ui.pointer_up_event_bus)
  .add_event(@ui.click_event_bus)
  .add_event(@ui.navigation_event_bus)
  .add_event(@ui.focus_in_event_bus)
  .add_event(@ui.focus_out_event_bus)
  .add_event(@ldtk.ldtk_world_spawned_event_bus)
  .add_event(@ldtk.ldtk_level_spawned_event_bus)
  .add_event(@ldtk.ldtk_layer_spawned_event_bus)
  .add_event(@ldtk.ldtk_tile_spawned_event_bus)
  .add_event(@ldtk.ldtk_entity_spawned_event_bus)
  .add_event(@ldtk.ldtk_int_grid_cell_spawned_event_bus)
  .add_event(@ldtk.ldtk_int_grid_collider_spawned_event_bus)
  .add_event(@ldtk.ldtk_level_event_bus)
  .add_event(@tiled.tiled_world_spawned_event_bus)
  .add_event(@tiled.tiled_world_map_spawned_event_bus)
  .add_event(@tiled.tiled_map_spawned_event_bus)
  .add_event(@tiled.tiled_layer_spawned_event_bus)
  .add_event(@tiled.tiled_tile_spawned_event_bus)
  .add_event(@tiled.tiled_object_spawned_event_bus)
  .add_event(@tiled.tiled_image_layer_spawned_event_bus)
  .add_event(@tiled.tiled_collider_spawned_event_bus)
  .add_event(@asset2.image_asset_events)
  .add_event(@asset2.audio_asset_events)
  .add_event(@asset2.font_asset_events)
}

///|
pub fn debug_plugin(app : @app.App) -> Unit {
  let render_prepare = @system_set.named("render_prepare")
  add_system(
    app,
    @physics2d.debug_colliders_system,
    RenderPrepare,
    "Debug Collide System",
    in_set=render_prepare,
  )
}

///|
pub fn default_plugin(app : @app.App) -> Unit {
  let app = register_builtin_events(app)
  let input = @system_set.named("input")
  let physics = @system_set.named("physics")
  let gameplay = @system_set.named("gameplay")
  let audio = @system_set.named("audio")
  let time = @system_set.named("time")
  let transform = @system_set.named("transform")
  let ui = @system_set.named("ui")
  let render_extract = @system_set.named("render_extract")
  let render_prepare = @system_set.named("render_prepare")
  let render_submit = @system_set.named("render_submit")

  add_system(
    app,
    @inputs.advanced_key_system,
    PreUpdate,
    "Advanced Key System",
    in_set=input,
  )
  add_system(
    app,
    @inputs.advanced_mouse_system,
    PreUpdate,
    "Advanced Mouse System",
    in_set=input,
  )
  add_system(
    app,
    @inputs.advanced_gamepad_system,
    PreUpdate,
    "Advanced Gamepad System",
    in_set=input,
  )
  add_system(
    app,
    @input_action.input_action_system,
    PreUpdate,
    "Input Action System",
    in_set=input,
  )
  add_system(
    app,
    @system.sync_mouse_lock_system,
    PreUpdate,
    "Sync Mouse Lock",
    after=[input],
  )
  add_system(
    app,
    @physics2d.physics_step_system,
    FixedUpdate,
    "Physics2D Step System",
    in_set=physics,
  )
  add_system(app, @camera.camera_system, FixedPostUpdate, "Camera System", after=[
    physics,
  ])
  add_system(
    app,
    @physics2d.pickable_click_system,
    Update,
    "Pickable Click System",
    in_set=gameplay,
  )
  add_system(
    app,
    @ldtk.ldtk_world_sync_system,
    Update,
    "LDtk World Sync System",
    in_set=gameplay,
  )
  add_system(
    app,
    @tiled.tiled_world_chunking_system,
    Update,
    "Tiled World Chunking System",
    in_set=gameplay,
  )
  add_system(
    app,
    @tiled.tiled_parallax_system,
    Update,
    "Tiled Parallax System",
    in_set=gameplay,
  )
  add_system(
    app,
    @audio.audio_event_playback_system,
    PostUpdate,
    "Audio Event Playback System",
    in_set=audio,
    after=[gameplay],
  )
  add_system(
    app,
    @audio.audio_playback_system,
    PostUpdate,
    "Audio Playback System",
    in_set=audio,
    after=[gameplay],
  )
  add_system(
    app,
    @system.timer_system,
    PostUpdate,
    "Timer System",
    in_set=time,
    after=[gameplay],
  )
  add_system(
    app,
    @system.realtime_timer_system,
    PostUpdate,
    "Realtime Timer System",
    in_set=time,
    after=[gameplay],
  )
  add_system(
    app,
    @inherit.transform_propagate_system,
    PostUpdate,
    "Transform Propagation System",
    in_set=transform,
    after=[gameplay],
  )
  add_system(
    app,
    @visibility.visibility_propagate_system,
    PostUpdate,
    "Visibility Propagation System",
    in_set=transform,
    after=[transform],
  )
  add_system(
    app,
    @scene.scene_spawner_cleanup_system,
    PostUpdate,
    "Scene Spawner Cleanup System",
    in_set=transform,
    after=[transform],
  )
  add_system(
    app,
    @ui.ui_layout_system,
    PostUpdate,
    "UI Layout System",
    in_set=ui,
    after=[transform],
  )
  add_system(
    app,
    @inherit.transform_propagate_system,
    PostUpdate,
    "Transform Propagation System (UI)",
    in_set=ui,
    after=[ui],
  )
  add_system(
    app,
    @ui.ui_interaction_system,
    PostUpdate,
    "UI Interaction System",
    in_set=ui,
    after=[ui],
  )
  add_system(
    app,
    @a11y.a11y_sync_system,
    PostUpdate,
    "A11y Sync System",
    in_set=ui,
    after=[ui],
  )
  add_system(
    app,
    @render2d.begin_frame2d_system,
    RenderExtract,
    "Render2D Begin Frame",
    in_set=render_extract,
  )
  add_system(
    app,
    @ui.ui_extract_system,
    RenderExtract,
    "UI Extract",
    in_set=render_extract,
  )
  add_system(
    app,
    @sprite.render_sprite_system,
    RenderPrepare,
    "Render Sprite System",
    in_set=render_prepare,
    after=[render_extract],
  )
  add_system(
    app,
    @ui.ui_prepare_system,
    RenderPrepare,
    "UI Prepare",
    in_set=render_prepare,
    after=[render_extract],
  )
  add_system(
    app,
    @render_submit.render_submit_system,
    Render,
    "Render Submit",
    in_set=render_submit,
    after=[render_prepare],
  )
}

///|
pub fn default_3d_plugin(app : @app.App) -> Unit {
  let app = register_builtin_events(app)
  let input = @system_set.named("input")
  let physics = @system_set.named("physics3d")
  let transform = @system_set.named("transform3d")
  let render_extract = @system_set.named("render_extract")
  let render_prepare = @system_set.named("render_prepare")
  let render_submit = @system_set.named("render_submit")
  let audio = @system_set.named("audio")
  let time = @system_set.named("time")

  add_system(
    app,
    @inputs.advanced_key_system,
    PreUpdate,
    "Advanced Key System",
    in_set=input,
  )
  add_system(
    app,
    @inputs.advanced_mouse_system,
    PreUpdate,
    "Advanced Mouse System",
    in_set=input,
  )
  add_system(
    app,
    @inputs.advanced_gamepad_system,
    PreUpdate,
    "Advanced Gamepad System",
    in_set=input,
  )
  add_system(
    app,
    @input_action.input_action_system,
    PreUpdate,
    "Input Action System",
    in_set=input,
  )
  add_system(
    app,
    @system.sync_mouse_lock_system,
    PreUpdate,
    "Sync Mouse Lock",
    after=[input],
  )
  add_system(
    app,
    @physics3d.physics_step_system,
    FixedUpdate,
    "Physics3D Step System",
    in_set=physics,
  )
  add_system(
    app,
    @transform3d.capture_previous_global_transforms3d_system,
    FixedFirst,
    "Capture Previous Transform3D System",
    in_set=transform,
  )
  add_system(
    app,
    @transform3d.transform3d_propagate_system,
    FixedPostUpdate,
    "Transform3D Propagation System",
    in_set=transform,
    after=[physics],
  )
  add_system(
    app,
    @animation3d.animation3d_player_system,
    PostUpdate,
    "Animation3D Player System",
    in_set=transform,
  )
  add_system(
    app,
    @transform3d.transform3d_propagate_system,
    PostUpdate,
    "Transform3D Propagation System (Frame)",
    in_set=transform,
    after=[transform],
  )
  add_system(
    app,
    @animation3d.animation3d_skinning_system,
    PostUpdate,
    "Animation3D Skinning System",
    in_set=transform,
    after=[transform],
  )
  add_system(
    app,
    @visibility.visibility_propagate_system,
    PostUpdate,
    "Visibility Propagation System",
    in_set=transform,
    after=[transform],
  )
  add_system(
    app,
    @render2d.begin_frame2d_system,
    RenderExtract,
    "Render2D Begin Frame",
    in_set=render_extract,
  )
  add_system(
    app,
    @ui.ui_extract_system,
    RenderExtract,
    "UI Extract",
    in_set=render_extract,
  )
  add_system(
    app,
    @camera3d.camera3d_extract_system,
    RenderExtract,
    "Camera3D Extract",
    in_set=render_extract,
  )
  add_system(
    app,
    @render3d.render3d_extract_system,
    RenderExtract,
    "Render3D Extract",
    in_set=render_extract,
  )
  add_system(
    app,
    @audio.audio_event_playback_system,
    PostUpdate,
    "Audio Event Playback System",
    in_set=audio,
  )
  add_system(
    app,
    @audio.audio_playback_system,
    PostUpdate,
    "Audio Playback System",
    in_set=audio,
  )
  add_system(
    app,
    @render3d_pipeline.render3d_prepare_system,
    RenderPrepare,
    "Render3D Prepare",
    in_set=render_prepare,
    after=[render_extract],
  )
  add_system(
    app,
    @sprite.render_sprite_system,
    RenderPrepare,
    "Render Sprite System",
    in_set=render_prepare,
    after=[render_extract],
  )
  add_system(
    app,
    @ui.ui_prepare_system,
    RenderPrepare,
    "UI Prepare",
    in_set=render_prepare,
    after=[render_extract],
  )
  add_system(
    app,
    @render_submit.render_submit_system,
    Render,
    "Render Submit",
    in_set=render_submit,
    after=[render_prepare],
  )
  add_system(app, @system.timer_system, PostUpdate, "Timer System", in_set=time)
  add_system(
    app,
    @system.realtime_timer_system,
    PostUpdate,
    "Realtime Timer System",
    in_set=time,
  )
}
