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
/// Debug plugin for development. Provides FPS display.
/// Usage:
/// ```notest
/// app.add_plugin(@plugins.debug_plugin)
/// ```
/// Shows FPS counter in top-left corner.
pub fn debug_plugin(app : @system.App) -> Unit {
  app.systems
  ..push(
    (
      @debug.debug_info_display_system,
      UpdateTime(1.0),
      "Debug Info Display System",
    ),
  )
  ..push((@collision.debug_collide_system, Render(-10), "Debug Collide System"))
  ..push(
    (
      @collision.quadtree_render_system,
      Render(-11),
      "Debug Quadtree Render System",
    ),
  )
}

///|
/// Default plugin for the Selene engine.
/// Usage:
/// ```notest
/// app.add_plugin(@plugins.default_plugin)
/// ```
pub fn default_plugin(app : @system.App) -> Unit {
  app.systems
  ..push((@collision.move_system, Update, "Move System"))
  ..push((@system.advanced_key_system, Update, "Advanced Key System"))
  ..push((@system.advanced_mouse_system, Update, "Advanced Mouse System"))
  ..push((@collision.quadtree_clear_system, Update, "Quadtree Clear System"))
  ..push((@collision.pickable_click_system, Update, "Pickable Click System"))
  ..push((@collision.area_collide_system, Update, "Area Collide System"))
  ..push((@system.deferred_event_system, Update, "Deferred Event System"))
  ..push((@sprite.render_sprite_system, Render(0), "Render Sprite System"))
  ..push((@camera.camera_system, Update, "Camera System"))
}
