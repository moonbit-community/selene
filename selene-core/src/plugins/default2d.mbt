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
pub fn default_plugin(app : @app.App) -> @app.App {
  let app = register_builtin_messages(app)
  let input = @app.SystemSet("input")
  let pointer_input = @app.SystemSet("pointer_input")
  let ui_input = @app.SystemSet("ui_input")
  let touch_controls = @app.SystemSet("touch_controls")
  let physics = @app.SystemSet("physics")
  let gameplay = @app.SystemSet("gameplay")
  let audio = @app.SystemSet("audio")
  let time = @app.SystemSet("time")
  let animation = @app.SystemSet("animation")
  let transform = @app.SystemSet("transform")
  let ui = @app.SystemSet("ui")
  let render_extract = @app.SystemSet("render_extract")
  let render_prepare = @app.SystemSet("render_prepare")
  let touch_controls_render = @app.SystemSet("touch_controls_render")
  let render_submit = @app.SystemSet("render_submit")

  let app = add_system(
    app,
    _ => @inputs.advanced_key_system(@time.delta()),
    PreUpdate,
    "Advanced Key System",
    in_set=input,
  )
  let app = add_system(
    app,
    _ => @inputs.advanced_mouse_system(@time.delta()),
    PreUpdate,
    "Advanced Mouse System",
    in_set=input,
  )
  let app = add_system(
    app,
    _ => @inputs.advanced_touch_system(@time.delta()),
    PreUpdate,
    "Advanced Touch System",
    in_set=input,
  )
  let app = add_system(
    app,
    _ => @inputs.advanced_gamepad_system(@time.delta()),
    PreUpdate,
    "Advanced Gamepad System",
    in_set=input,
  )
  let app = add_system(
    app,
    _ => @inputs.advanced_pointer_system(@time.delta()),
    PreUpdate,
    "Advanced Pointer System",
    in_set=pointer_input,
    after=[input],
  )
  let app = add_system(
    app,
    world => @ui.ui_input_capture_system(world~, @time.delta()),
    PreUpdate,
    "UI Input Capture System",
    in_set=ui_input,
    after=[pointer_input],
  )
  let app = add_system(
    app,
    _ => @touch_controls.touch_controls_system(@time.delta()),
    PreUpdate,
    "Touch Controls System",
    in_set=touch_controls,
    after=[ui_input],
  )
  let app = add_system(
    app,
    _ => @input_action.input_action_system(@time.delta()),
    PreUpdate,
    "Input Action System",
    after=[touch_controls],
  )
  let app = add_system(
    app,
    _ => @window.sync_mouse_lock_system(@time.delta()),
    PreUpdate,
    "Sync Mouse Lock",
    after=[input],
  )
  let app = add_system(
    app,
    world => @physics2d.physics_step_system(world~, @time.delta()),
    FixedUpdate,
    "Physics2D Step System",
    in_set=physics,
  )
  let app = add_system(
    app,
    world => @physics2d.pickable_click_system(world~, @time.delta()),
    Update,
    "Pickable Click System",
    in_set=gameplay,
  )
  let app = add_system(
    app,
    world => @ldtk.ldtk_world_sync_system(world~, @time.delta()),
    Update,
    "LDtk World Sync System",
    in_set=gameplay,
  )
  let app = add_system(
    app,
    world => @tiled.tiled_world_chunking_system(world~, @time.delta()),
    Update,
    "Tiled World Chunking System",
    in_set=gameplay,
  )
  let app = add_system(
    app,
    _ => @audio.audio_event_playback_system(@time.delta()),
    PostUpdate,
    "Audio Event Playback System",
    in_set=audio,
    after=[gameplay],
  )
  let app = add_system(
    app,
    world => @audio.audio_playback_system(world~, @time.delta()),
    PostUpdate,
    "Audio Playback System",
    in_set=audio,
    after=[gameplay],
  )
  let app = add_system(
    app,
    _ => @time.timers_system(@time.delta()),
    PostUpdate,
    "Timer System",
    in_set=time,
    after=[gameplay],
  )
  let app = add_system(
    app,
    world => @animation.animation_player_system(world~, @time.delta()),
    PostUpdate,
    "Animation Player System",
    in_set=animation,
    after=[gameplay],
  )
  let app = app.add_query_system(
    PostUpdate,
    query => @animation.animation_transition_system(query, @time.delta()),
    system_name="Animation Transition System",
    in_set=animation,
    after=[animation],
  )
  let app = add_system(
    app,
    world => @animation.animation_apply_system(world~, @time.delta()),
    PostUpdate,
    "Animation Apply System",
    in_set=animation,
    after=[animation],
  )
  let app = add_system(
    app,
    world => @transform.transform_propagate_system(world~, @time.delta()),
    PostUpdate,
    "Transform Propagation System",
    in_set=transform,
    after=[animation],
  )
  let app = add_system(
    app,
    world => @visibility.visibility_propagate_system(world~, @time.delta()),
    PostUpdate,
    "Visibility Propagation System",
    in_set=transform,
    after=[transform],
  )
  let app = add_system(
    app,
    _ => @scene.scene_spawner_cleanup_system(@time.delta()),
    PostUpdate,
    "Scene Spawner Cleanup System",
    in_set=transform,
    after=[transform],
  )
  let app = add_system(
    app,
    world => @ui.ui_layout_system(world~, @time.delta()),
    PostUpdate,
    "UI Layout System",
    in_set=ui,
    after=[transform],
  )
  let app = add_system(
    app,
    world => @ui.ui_interaction_system(world~, @time.delta()),
    PostUpdate,
    "UI Interaction System",
    in_set=ui,
    after=[ui],
  )
  let app = add_system(
    app,
    world => @a11y.a11y_sync_system(world~, @time.delta()),
    PostUpdate,
    "A11y Sync System",
    in_set=ui,
    after=[ui],
  )
  let app = add_system(
    app,
    _ => @render2d.begin_frame2d_system(@time.delta()),
    RenderExtract,
    "Render2D Begin Frame",
    in_set=render_extract,
  )
  let app = add_system(
    app,
    _ => @ui.ui_extract_system(@time.delta()),
    RenderExtract,
    "UI Extract",
    in_set=render_extract,
  )
  let app = add_system(
    app,
    world => @sprite.render_sprite_system(world~, @time.delta()),
    RenderPrepare,
    "Render Sprite System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_system(
    app,
    world => @mesh2d.render_mesh2d_system(world~, @time.delta()),
    RenderPrepare,
    "Render Mesh2d System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_system(
    app,
    world => @text2d.render_text2d_system(world~, @time.delta()),
    RenderPrepare,
    "Render Text2d System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_system(
    app,
    _ => @touch_controls.touch_controls_render_system(@time.delta()),
    RenderPrepare,
    "Touch Controls Prepare",
    in_set=touch_controls_render,
    after=[render_extract],
  )
  let app = add_system(
    app,
    world => @ui.ui_prepare_system(world~, @time.delta()),
    RenderPrepare,
    "UI Prepare",
    in_set=render_prepare,
    after=[touch_controls_render],
  )
  add_system(
    app,
    world => @render_submit.render_submit_system(world~, @time.delta()),
    Render,
    "Render Submit",
    in_set=render_submit,
    after=[render_prepare],
  )
}
