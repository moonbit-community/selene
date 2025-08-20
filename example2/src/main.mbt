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

///| Constants for the physics example
const ZOOM : Double = 3.0
const VIEWPORT_WIDTH : Double = 320.0
const VIEWPORT_HEIGHT : Double = 240.0
const REAL_VIEWPORT_WIDTH : Double = VIEWPORT_WIDTH * ZOOM
const REAL_VIEWPORT_HEIGHT : Double = VIEWPORT_HEIGHT * ZOOM

///| Main entry point
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(REAL_VIEWPORT_WIDTH)
  .with_canvas_height(REAL_VIEWPORT_HEIGHT)
  .with_image_smooth(false)
  .with_zoom(ZOOM)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin) // Includes sprite rendering, mouse/keyboard, etc.
  .add_plugin(@plugins.physics_plugin) // Adds complete physics system
  .add_system(setup_physics_world, schedule=Startup)
  .add_system(setup_ui, schedule=Startup)
  .add_system(boundary_collision_system) // Simple collision with screen edges
  .add_system(input_system)
  .run()
}

///| Setup the physics world with some objects
fn setup_physics_world(_backend : &@system.Backend) -> Unit {
  // Create some static platforms (gray objects)
  let platform1 = @system.Entity::new()
  @physics.create_physics_entity(platform1, @math.Vec2D(160.0, 180.0), @physics.Static, 0.0)
  create_color_rect_sprite(platform1, @math.Vec2D(60.0, 16.0), "gray", 1)
  
  let platform2 = @system.Entity::new()
  @physics.create_physics_entity(platform2, @math.Vec2D(80.0, 140.0), @physics.Static, 0.0)
  create_color_rect_sprite(platform2, @math.Vec2D(40.0, 16.0), "gray", 1)
  
  let platform3 = @system.Entity::new()
  @physics.create_physics_entity(platform3, @math.Vec2D(240.0, 140.0), @physics.Static, 0.0)
  create_color_rect_sprite(platform3, @math.Vec2D(50.0, 16.0), "gray", 1)
  
  // Create some falling balls
  for i in 0..<5 {
    let ball = @system.Entity::new()
    let x = 50.0 + i.to_double() * 40.0
    let y = 20.0 + i.to_double() * 15.0
    @physics.create_physics_entity(ball, @math.Vec2D(x, y), @physics.Dynamic, 1.0)
    create_color_rect_sprite(ball, @math.Vec2D(16.0, 16.0), "red", 2)
    
    // Give each ball a different initial velocity
    @physics.apply_impulse_to_entity(ball, @math.Vec2D((i.to_double() - 2.0) * 10.0, 0.0))
  }
  
  // Create some boxes
  for i in 0..<3 {
    let box = @system.Entity::new()
    let x = 80.0 + i.to_double() * 60.0
    let y = 40.0
    @physics.create_physics_entity(box, @math.Vec2D(x, y), @physics.Dynamic, 2.0)
    create_color_rect_sprite(box, @math.Vec2D(16.0, 16.0), "blue", 2)
  }
}

///| Helper function to create a colored rectangle sprite for an entity
fn create_color_rect_sprite(
  entity : @system.Entity,
  size : @math.Vec2D,
  color : String,
  zindex : Int,
) -> Unit {
  let color_rect = @sprite.ColorRect::new(size, color)
  let sprite = @sprite.Sprite::new_color_rect(color_rect, zindex, offset=@math.Vec2D(-size[X] / 2.0, -size[Y] / 2.0))
  @sprite.sprites.set(entity, sprite)
}

///| Simple boundary collision system (prevents objects from leaving screen)
fn boundary_collision_system(_backend : &@system.Backend) -> Unit {
  let margin = 10.0
  let bounce_damping = 0.8
  
  for entity, _rigid_body in @physics.rigid_bodies {
    match @position.positions.get(entity) {
      Some(position) => {
        let pos = position.inner()
        let mut new_pos = pos
        let mut velocity_changed = false
        
        match @physics.get_physics_velocity(entity) {
          Some(velocity) => {
            let mut new_velocity = velocity
            
            // Left boundary
            if pos[X] < margin {
              new_pos = @math.Vec2D(margin, pos[Y])
              if velocity[X] < 0.0 {
                new_velocity = @math.Vec2D(-velocity[X] * bounce_damping, velocity[Y])
                velocity_changed = true
              }
            }
            
            // Right boundary  
            if pos[X] > VIEWPORT_WIDTH - margin {
              new_pos = @math.Vec2D(VIEWPORT_WIDTH - margin, pos[Y])
              if velocity[X] > 0.0 {
                new_velocity = @math.Vec2D(-velocity[X] * bounce_damping, velocity[Y])
                velocity_changed = true
              }
            }
            
            // Top boundary
            if pos[Y] < margin {
              new_pos = @math.Vec2D(new_pos[X], margin)
              if velocity[Y] < 0.0 {
                new_velocity = @math.Vec2D(new_velocity[X], -velocity[Y] * bounce_damping)
                velocity_changed = true
              }
            }
            
            // Bottom boundary (ground)
            if pos[Y] > VIEWPORT_HEIGHT - margin {
              new_pos = @math.Vec2D(new_pos[X], VIEWPORT_HEIGHT - margin)
              if velocity[Y] > 0.0 {
                new_velocity = @math.Vec2D(new_velocity[X], -velocity[Y] * bounce_damping)
                velocity_changed = true
              }
            }
            
            // Update position if changed
            if new_pos[X] != pos[X] || new_pos[Y] != pos[Y] {
              @position.positions.set(entity, @position.Position(new_pos))
            }
            
            // Update velocity if changed
            if velocity_changed {
              @physics.set_physics_velocity(entity, new_velocity)
            }
          }
          None => continue
        }
      }
      None => continue
    }
  }
}

///| Setup UI elements using UI entities with Text and ColorRect sprites
fn setup_ui(_backend : &@system.Backend) -> Unit {
  // Create world background entity
  let world_background = @system.Entity::new()
  @position.positions.set(world_background, @position.Position(@math.Vec2D(0.0, 0.0)))
  @ui.uis.set(world_background, @ui.Ui::new())
  let world_bg_rect = @sprite.ColorRect::new(@math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT), "black")
  let world_bg_sprite = @sprite.Sprite::new_color_rect(world_bg_rect, 0) // Lowest z-index for background
  @sprite.sprites.set(world_background, world_bg_sprite)
  
  // Create UI panel background
  let panel_width = 300.0
  let panel_height = 100.0
  let panel_x = 5.0
  let panel_y = 5.0
  
  let ui_panel = @system.Entity::new()
  @position.positions.set(ui_panel, @position.Position(@math.Vec2D(panel_x, panel_y)))
  @ui.uis.set(ui_panel, @ui.Ui::new())
  let panel_rect = @sprite.ColorRect::new(@math.Vec2D(panel_width, panel_height), "rgba(0, 0, 50, 0.8)")
  let panel_sprite = @sprite.Sprite::new_color_rect(panel_rect, @ui.UI_ZINDEX)
  @sprite.sprites.set(ui_panel, panel_sprite)
  
  // Create title text entity
  create_ui_text("Physics Example with Sprites & UI", panel_x + 8.0, panel_y + 8.0, "white", "14px Arial")
  
  // Create instruction text entities
  create_ui_text("🔴 Red = Light objects (mass: 1.0)", panel_x + 8.0, panel_y + 28.0, "white", "11px Arial")
  create_ui_text("🔵 Blue = Heavy objects (mass: 2.0)", panel_x + 8.0, panel_y + 42.0, "white", "11px Arial")
  create_ui_text("🟫 Gray = Static platforms", panel_x + 8.0, panel_y + 56.0, "white", "11px Arial")
  create_ui_text("Click anywhere to add blue boxes!", panel_x + 8.0, panel_y + 76.0, "yellow", "11px Arial")
}

///| Helper function to create UI text entities
fn create_ui_text(content : String, x : Double, y : Double, color : String, font : String) -> Unit {
  let text_entity = @system.Entity::new()
  @position.positions.set(text_entity, @position.Position(@math.Vec2D(x, y)))
  @ui.uis.set(text_entity, @ui.Ui::new())
  let text = @sprite.Text::new(content, color=color, font=font)
  let sprite = @sprite.Sprite::new_text(text, @ui.UI_ZINDEX + 1)
  @sprite.sprites.set(text_entity, sprite)
}

///| Handle user input to add new objects
fn input_system(_backend : &@system.Backend) -> Unit {
  // Add a new box when mouse is clicked
  if @system.is_mouse_just_pressed(@system.Left) {
    let mouse_pos = @system.mouse.pos
    
    // Convert screen coordinates to world coordinates
    let world_x = mouse_pos[X] / ZOOM
    let world_y = mouse_pos[Y] / ZOOM
    
    // Create a new dynamic box at mouse position
    let new_box = @system.Entity::new()
    @physics.create_physics_entity(new_box, @math.Vec2D(world_x, world_y), @physics.Dynamic, 1.5)
    @physics.add_physics_shape_to_entity(new_box, @physics.ShapeDef::Box(12.0, 12.0, @math.Vec2D(0.0, 0.0), 0.0))
    create_color_rect_sprite(new_box, @math.Vec2D(12.0, 12.0), "blue", 2)
    
    // Give it a small random impulse
    let impulse_x = (world_x - VIEWPORT_WIDTH / 2.0) * 0.1
    let impulse_y = -20.0
    @physics.apply_impulse_to_entity(new_box, @math.Vec2D(impulse_x, impulse_y))
  }
}