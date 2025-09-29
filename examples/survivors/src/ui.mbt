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
fn add_score_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.score_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn setup_level_up_ui() -> Unit {
  // Set up level up text entity
  let level_up_sprite = @sprite.Sprite::from_text(
    game_state.level_up_box,
    UI_ZINDEX + 2,
  )
  @sprite.sprites.set(game_state.level_up_entity, level_up_sprite)
  let level_up_position = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0 - 80,
    VIEWPORT_HEIGHT / 2.0 - 100,
  )
  @position.positions.set(
    game_state.level_up_entity,
    @position.Position(level_up_position),
  )
  @ui.uis.set(game_state.level_up_entity, @ui.Ui::new())

  // Set up powerup button entities
  setup_powerup_button(game_state.powerup_button1_entity, 0)
  setup_powerup_button(game_state.powerup_button2_entity, 1)
  setup_powerup_button(game_state.powerup_button3_entity, 2)

  // Initially destroy all entities (they'll be respawned when needed)
  game_state.level_up_entity.destroy()
  game_state.powerup_button1_entity.destroy()
  game_state.powerup_button2_entity.destroy()
  game_state.powerup_button3_entity.destroy()
}

///|
fn setup_powerup_button(entity : @system.Entity, index : Int) -> Unit {
  // Position buttons vertically
  let button_y = VIEWPORT_HEIGHT / 2.0 - 40.0 + index.to_double() * 40.0
  let button_position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 100, button_y)

  @position.positions.set(entity, @position.Position(button_position))
  @ui.uis.set(entity, @ui.Ui::new())

  // Add clickable area for the button
  @collision.shapes.set(
    entity,
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(200.0, 35.0),
      offset=@math.Vec2D(0.0, 0.0),
    ),
  )

  // Create pickable component for button
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_button) { select_powerup(index) })
  @collision.pickables[entity] = pickable
}

///|
fn level_up() -> Unit {
  @backend.set_time_scale(0.0)

  // Generate 3 random powerups
  game_state.available_powerups = generate_random_powerups()

  // Update button text with powerup names
  update_powerup_button_text(game_state.powerup_button1_entity, 0)
  update_powerup_button_text(game_state.powerup_button2_entity, 1)
  update_powerup_button_text(game_state.powerup_button3_entity, 2)

  // Respawn the level-up UI entities
  game_state.level_up_entity.respawn()
  game_state.powerup_button1_entity.respawn()
  game_state.powerup_button2_entity.respawn()
  game_state.powerup_button3_entity.respawn()
}

///|
fn update_powerup_button_text(entity : @system.Entity, index : Int) -> Unit {
  if index < game_state.available_powerups.length() {
    let powerup = game_state.available_powerups[index]
    let button_text = @sprite.Text::new(
      powerup.name + ": " + powerup.description,
      color="white",
      font="18px ThaleahFat",
    )
    let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 2)
    @sprite.sprites.set(entity, button_sprite)
  }
}

///|
fn select_powerup(index : Int) -> Unit {
  if index < game_state.available_powerups.length() {
    let powerup = game_state.available_powerups[index]
    apply_powerup(powerup)
  }
  resume_game()
}

///|
fn resume_game() -> Unit {
  @backend.set_time_scale(1.0)

  // Hide level-up UI entities
  game_state.level_up_entity.destroy()
  game_state.powerup_button1_entity.destroy()
  game_state.powerup_button2_entity.destroy()
  game_state.powerup_button3_entity.destroy()
}

///|
fn add_wave_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.wave_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 84.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_exp_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.exp_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 50.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_timer_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.timer_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH - 120, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_game_over_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(
    game_state.game_over_box,
    UI_ZINDEX + 1,
  )
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 160, VIEWPORT_HEIGHT / 2.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_level_box() -> Unit {
  let entity = @system.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.level_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}
