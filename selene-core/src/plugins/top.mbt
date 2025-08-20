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
  ..push((@collision.area_click_system, Update, "Area Click System"))
  ..push((@collision.area_collide_system, Update, "Area Collide System"))
  ..push((@system.deferred_event_system, Update, "Deferred Event System"))
  ..push((@sprite.render_sprite_system, Render(0), "Render Sprite System"))
  ..push((@camera.camera_system, Update, "Camera System"))
}

///|
/// Physics plugin for 2D physics simulation.
/// Provides gravity, forces, velocity integration, and basic collision detection.
/// 
/// Usage:
/// ```notest
/// @system.App::new(backend)
///   .add_plugin(@plugins.physics_plugin)
///   .run()
/// ```
/// 
/// Then create physics entities:
/// ```notest
/// let entity = @system.Entity::new()
/// @physics.create_physics_entity(entity, @math.Vec2D(100.0, 50.0), @physics.Dynamic, 2.0)
/// @physics.apply_force_to_entity(entity, @math.Vec2D(0.0, -100.0))
/// ```
/// 
/// Systems included:
/// - Physics integration system (gravity, forces, velocity, damping)
/// - Physics-to-velocity synchronization for compatibility
/// - Velocity-to-physics synchronization for kinematic bodies
/// 
/// Body types supported:
/// - Static: Immovable objects (mass = 0)
/// - Kinematic: User-controlled movement (mass = 0, user sets velocity)
/// - Dynamic: Physics-controlled movement (mass > 0, affected by forces)
/// 
/// Available functions:
/// - `@physics.create_physics_entity(entity, position, body_type, mass)`
/// - `@physics.apply_force_to_entity(entity, force)` - Continuous force
/// - `@physics.apply_impulse_to_entity(entity, impulse)` - Instant velocity change
/// - `@physics.set_physics_velocity(entity, velocity)` - Direct velocity control
/// - `@physics.get_physics_velocity(entity)` - Get current velocity
/// 
/// Note: This plugin provides physics integration but not collision detection
/// between objects. Objects will pass through each other unless you implement
/// additional collision systems.
pub fn physics_plugin(app : @system.App) -> Unit {
  app.systems
  ..push(
    (
      @physics.sync_velocity_to_physics_system,
      Update,
      "Sync Velocity to Physics System",
    ),
  )
  ..push(
    (@physics.physics_integration_system, Update, "Physics Integration System"),
  )
  ..push(
    (
      @physics.sync_physics_to_velocity_system,
      Update,
      "Sync Physics to Velocity System",
    ),
  )
}
