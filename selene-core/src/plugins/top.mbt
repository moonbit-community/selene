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

let fps_box : @sprite.Text = @sprite.Text::new("FPS: 0", color="green", font="16px monospace")

///|
fn debug_initializer(_backend : &@system.Backend) -> Unit {
  // Create FPS text entity
  let entity = @system.Entity::new()
  @position.positions.set(entity, @position.Position(@math.Vec2D(10.0, 25.0)))
  let sprite = @sprite.Sprite::new_text(fps_box, @camera.UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  
  // Add to UI entities so it's not affected by camera movement
  @camera.uis.set(entity, @camera.Ui::new())
}

///|
fn fps_display_system(backend : &@system.Backend) -> Unit {
  let fps = backend.get_fps()
  let fps_text = "FPS: " + fps.to_string()
  fps_box.content = fps_text
}

///|
/// Debug plugin for development. Provides FPS display.
/// Usage:
/// ```notest
/// app.add_plugin(@plugins.debug_plugin)
/// ```
/// Shows FPS counter in top-left corner.
pub fn debug_plugin(app : @system.App) -> Unit {
  app.initializers.push((debug_initializer, 0))
  app.systems.push((fps_display_system, 300))
}

///|
/// Default plugin for the Selene engine.
/// Usage:
/// ```notest
/// app.add_plugin(@plugins.default_plugin)
/// ```
pub fn default_plugin(app : @system.App) -> Unit {
  app.systems
  ..push((@collision.move_system, 50))
  ..push((@system.advanced_key_system, 100))
  ..push((@system.advanced_mouse_system, 105))
  ..push((@collision.area_click_system, 45))
  ..push((@collision.area_collide_system, 40))
  ..push((@system.deferred_event_system, -100))
  ..push((@sprite.render_sprite_system, 0))
  ..push((@camera.camera_system, 30))
}
