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
  let input = @ecs.SystemSet("input")
  let pointer_input = @ecs.SystemSet("pointer_input")
  let ui_input = @ecs.SystemSet("ui_input")
  let touch_controls = @ecs.SystemSet("touch_controls")
  let physics = @ecs.SystemSet("physics")
  let gameplay = @ecs.SystemSet("gameplay")
  let audio = @ecs.SystemSet("audio")
  let time = @ecs.SystemSet("time")
  let animation = @ecs.SystemSet("animation")
  let transform = @ecs.SystemSet("transform")
  let ui = @ecs.SystemSet("ui")
  let render_extract = @ecs.SystemSet("render_extract")
  let render_prepare = @ecs.SystemSet("render_prepare")
  let touch_controls_render = @ecs.SystemSet("touch_controls_render")
  let render_submit = @ecs.SystemSet("render_submit")

  let app = add_system(
    app,
    @ecs.args0(@inputs.advanced_key_system),
    PreUpdate,
    "Advanced Key System",
    in_set=input,
  )
  let app = add_system(
    app,
    @ecs.args0(@inputs.advanced_mouse_system),
    PreUpdate,
    "Advanced Mouse System",
    in_set=input,
  )
  let app = add_system(
    app,
    fn(time : @time.Time) { @inputs.advanced_touch_system(time.delta()) },
    PreUpdate,
    "Advanced Touch System",
    in_set=input,
  )
  let app = add_system(
    app,
    @ecs.args0(@inputs.advanced_gamepad_system),
    PreUpdate,
    "Advanced Gamepad System",
    in_set=input,
  )
  let app = add_system(
    app,
    @ecs.args0(@inputs.advanced_pointer_system),
    PreUpdate,
    "Advanced Pointer System",
    in_set=pointer_input,
    after=[input],
  )
  let app = add_exclusive_system(
    app,
    world => @ui.ui_input_capture_system(world~, @time.delta()),
    PreUpdate,
    "UI Input Capture System",
    in_set=ui_input,
    after=[pointer_input],
  )
  let app = add_system(
    app,
    @ecs.args0(@touch_controls.touch_controls_system),
    PreUpdate,
    "Touch Controls System",
    in_set=touch_controls,
    after=[ui_input],
  )
  let app = add_system(
    app,
    @ecs.args0(@input_action.input_action_system),
    PreUpdate,
    "Input Action System",
    after=[touch_controls],
  )
  let app = add_system(
    app,
    @ecs.args0(@window.sync_mouse_lock_system),
    PreUpdate,
    "Sync Mouse Lock",
    after=[input],
  )
  let app = add_exclusive_system(
    app,
    world => @physics2d.physics_step_system(world~, @time.delta()),
    FixedUpdate,
    "Physics2D Step System",
    in_set=physics,
  )
  let app = add_exclusive_system(
    app,
    world => @physics2d.pickable_click_system(world~, @time.delta()),
    Update,
    "Pickable Click System",
    in_set=gameplay,
  )
  let app = add_exclusive_system(
    app,
    world => @ldtk.ldtk_world_sync_system(world~, @time.delta()),
    Update,
    "LDtk World Sync System",
    in_set=gameplay,
  )
  let app = add_exclusive_system(
    app,
    world => @tiled.tiled_world_chunking_system(world~, @time.delta()),
    Update,
    "Tiled World Chunking System",
    in_set=gameplay,
  )
  let app = add_system(
    app,
    @ecs.args0(@audio.audio_event_playback_system),
    PostUpdate,
    "Audio Event Playback System",
    in_set=audio,
    after=[gameplay],
  )
  let app = add_system(
    app,
    @ecs.args2(@audio.audio_playback_system),
    PostUpdate,
    "Audio Playback System",
    in_set=audio,
    after=[gameplay],
  )
  let app = add_system(
    app,
    fn(time : @time.Time) { @time.timers_system(time.delta()) },
    PostUpdate,
    "Timer System",
    in_set=time,
    after=[gameplay],
  )
  let app = add_exclusive_system(
    app,
    world => @animation.animation_player_system(world~, @time.delta()),
    PostUpdate,
    "Animation Player System",
    in_set=animation,
    after=[gameplay],
  )
  let app = app.add_system(
    PostUpdate,
    @ecs.args2(fn(
      query : @ecs.Query[
        (@animation.AnimationTransitions, @animation.AnimationPlayer),
      ],
      time : @time.Time,
    ) {
      @animation.animation_transition_system(query, time.delta())
    }),
    system_name="Animation Transition System",
    in_set=animation,
    after=[animation],
  )
  let app = add_exclusive_system(
    app,
    world => @animation.animation_apply_system(world~, @time.delta()),
    PostUpdate,
    "Animation Apply System",
    in_set=animation,
    after=[animation],
  )
  let app = add_exclusive_system(
    app,
    world => @transform.transform_propagate_system(world~, @time.delta()),
    PostUpdate,
    "Transform Propagation System",
    in_set=transform,
    after=[animation],
  )
  let app = add_exclusive_system(
    app,
    world => @visibility.visibility_propagate_system(world~, @time.delta()),
    PostUpdate,
    "Visibility Propagation System",
    in_set=transform,
    after=[transform],
  )
  let app = add_system(
    app,
    @ecs.args0(@scene.scene_spawner_cleanup_system),
    PostUpdate,
    "Scene Spawner Cleanup System",
    in_set=transform,
    after=[transform],
  )
  let app = add_exclusive_system(
    app,
    world => @ui.ui_layout_system(world~, @time.delta()),
    PostUpdate,
    "UI Layout System",
    in_set=ui,
    after=[transform],
  )
  let app = add_exclusive_system(
    app,
    world => @ui.ui_interaction_system(world~, @time.delta()),
    PostUpdate,
    "UI Interaction System",
    in_set=ui,
    after=[ui],
  )
  let app = add_exclusive_system(
    app,
    world => @a11y.a11y_sync_system(world~, @time.delta()),
    PostUpdate,
    "A11y Sync System",
    in_set=ui,
    after=[ui],
  )
  let app = add_system(
    app,
    @ecs.args0(@render2d.begin_frame2d_system),
    RenderExtract,
    "Render2D Begin Frame",
    in_set=render_extract,
  )
  let app = add_system(
    app,
    @ecs.args0(@ui.ui_extract_system),
    RenderExtract,
    "UI Extract",
    in_set=render_extract,
  )
  let app = add_exclusive_system(
    app,
    world => @sprite.render_sprite_system(world~, @time.delta()),
    RenderPrepare,
    "Render Sprite System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_exclusive_system(
    app,
    world => @mesh2d.render_mesh2d_system(world~, @time.delta()),
    RenderPrepare,
    "Render Mesh2d System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_exclusive_system(
    app,
    world => @text2d.render_text2d_system(world~, @time.delta()),
    RenderPrepare,
    "Render Text2d System",
    in_set=render_prepare,
    after=[render_extract],
  )
  let app = add_system(
    app,
    @ecs.args0(@touch_controls.touch_controls_render_system),
    RenderPrepare,
    "Touch Controls Prepare",
    in_set=touch_controls_render,
    after=[render_extract],
  )
  let app = add_exclusive_system(
    app,
    world => @ui.ui_prepare_system(world~, @time.delta()),
    RenderPrepare,
    "UI Prepare",
    in_set=render_prepare,
    after=[touch_controls_render],
  )
  add_exclusive_system(
    app,
    world => @render_submit.render_submit_system(world~, @time.delta()),
    Render,
    "Render Submit",
    in_set=render_submit,
    after=[render_prepare],
  )
}
