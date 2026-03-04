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
/// Debug plugin for development.
/// 
/// Example:
/// 
/// ```moonbit nocheck
/// let app = @system.App::new()
/// app.add_plugin(@plugins.debug_plugin).run()
/// ```
/// 
pub fn debug_plugin(app : @system.App) -> Unit {
  app.systems.push(
    (@physics2d.debug_colliders_system, RenderPrepare, "Debug Collide System"),
  )
}

///|
/// Configures an application with essential game engine systems in their
/// default execution order.
///
/// Parameters:
///
/// * `app` : The application instance to configure with systems.
///
/// Example:
///
/// ```moonbit nocheck
/// let app = @system.App::new()
/// @plugins.default_plugin(app)
/// app.run()
/// ```
///
pub fn default_plugin(app : @system.App) -> Unit {
  app.systems
  ..push((@inputs.advanced_key_system, PreUpdate, "Advanced Key System"))
  ..push((@inputs.advanced_mouse_system, PreUpdate, "Advanced Mouse System"))
  ..push(
    (@inputs.advanced_gamepad_system, PreUpdate, "Advanced Gamepad System"),
  )
  ..push((@system.sync_mouse_lock_system, PreUpdate, "Sync Mouse Lock"))
  ..push((@physics2d.physics_step_system, FixedUpdate, "Physics2D Step System"))
  ..push((@camera.camera_system, FixedPostUpdate, "Camera System"))
  ..push((@physics2d.pickable_click_system, Update, "Pickable Click System"))
  ..push((@system.deferred_event_system, PostUpdate, "Deferred Event System"))
  ..push((@system.timer_system, PostUpdate, "Timer System"))
  ..push((@system.realtime_timer_system, PostUpdate, "Realtime Timer System"))
  ..push(
    (
      @inherit.transform_propagate_system,
      PostUpdate,
      "Transform Propagation System",
    ),
  )
  ..push((@style.style_system, PostUpdate, "Style System"))
  ..push((@ui.ui_layout_system, PostUpdate, "UI Layout System"))
  ..push(
    (
      @inherit.transform_propagate_system,
      PostUpdate,
      "Transform Propagation System (UI)",
    ),
  )
  ..push((@ui.ui_button_system, PostUpdate, "UI Button System"))
  ..push((@a11y.a11y_sync_system, PostUpdate, "A11y Sync System"))
  ..push(
    (@render2d.begin_frame2d_system, RenderExtract, "Render2D Begin Frame"),
  )
  ..push((@sprite.render_sprite_system, RenderPrepare, "Render Sprite System"))
  .push((@render_submit.render_submit_system, Render, "Render Submit"))
}

///|
/// Configures a 3D-first pipeline:
/// transform propagation, camera extraction, render extraction/prepare/submit,
/// and ECS-driven 3D physics.
pub fn default_3d_plugin(app : @system.App) -> Unit {
  app.systems
  ..push((@inputs.advanced_key_system, PreUpdate, "Advanced Key System"))
  ..push((@inputs.advanced_mouse_system, PreUpdate, "Advanced Mouse System"))
  ..push(
    (@inputs.advanced_gamepad_system, PreUpdate, "Advanced Gamepad System"),
  )
  ..push((@system.sync_mouse_lock_system, PreUpdate, "Sync Mouse Lock"))
  ..push((@physics3d.physics_step_system, FixedUpdate, "Physics3D Step System"))
  ..push(
    (
      @transform3d.capture_previous_global_transforms3d_system,
      FixedFirst,
      "Capture Previous Transform3D System",
    ),
  )
  ..push(
    (
      @transform3d.transform3d_propagate_system,
      FixedPostUpdate,
      "Transform3D Propagation System",
    ),
  )
  ..push(
    (
      @transform3d.transform3d_propagate_system,
      PostUpdate,
      "Transform3D Propagation System (Frame)",
    ),
  )
  ..push(
    (@render2d.begin_frame2d_system, RenderExtract, "Render2D Begin Frame"),
  )
  ..push((@camera3d.camera3d_extract_system, RenderExtract, "Camera3D Extract"))
  ..push((@render3d.render3d_extract_system, RenderExtract, "Render3D Extract"))
  ..push(
    (
      @render3d_pipeline.render3d_prepare_system,
      RenderPrepare,
      "Render3D Prepare",
    ),
  )
  ..push((@sprite.render_sprite_system, RenderPrepare, "Render Sprite System"))
  ..push((@render_submit.render_submit_system, Render, "Render Submit"))
  ..push((@system.deferred_event_system, PostUpdate, "Deferred Event System"))
  ..push((@system.timer_system, PostUpdate, "Timer System"))
  .push((@system.realtime_timer_system, PostUpdate, "Realtime Timer System"))
}
