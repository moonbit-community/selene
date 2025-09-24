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
    VIEWPORT_HEIGHT / 2.0 - 60,
  )
  @position.positions.set(
    game_state.level_up_entity,
    @position.Position(level_up_position),
  )
  @ui.uis.set(game_state.level_up_entity, @ui.Ui::new())

  // Set up resume button entity
  let button_text = @sprite.Text::new(
    "RESUME",
    color="white",
    font="24px ThaleahFat",
  )
  let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 2)
  @sprite.sprites.set(game_state.resume_button_entity, button_sprite)
  let button_position = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0 - 40,
    VIEWPORT_HEIGHT / 2.0,
  )
  @position.positions.set(
    game_state.resume_button_entity,
    @position.Position(button_position),
  )
  @ui.uis.set(game_state.resume_button_entity, @ui.Ui::new())

  // Add clickable area for the button
  @collision.shapes.set(
    game_state.resume_button_entity,
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 24.0),
      offset=@math.Vec2D(-4.0, -16.0),
    ),
  )

  // Create pickable component for button
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_button) { resume_game() })
  @collision.pickables[game_state.resume_button_entity] = pickable

  // Initially destroy both entities (they'll be respawned when needed)
  game_state.level_up_entity.destroy()
  game_state.resume_button_entity.destroy()
}

///|
fn level_up() -> Unit {
  @backend.set_time_scale(0.0)

  // Respawn the level-up UI entities
  game_state.level_up_entity.respawn()
  game_state.resume_button_entity.respawn()
}

///|
fn resume_game() -> Unit {
  @backend.set_time_scale(1.0)

  // Hide level-up UI entities
  game_state.level_up_entity.destroy()
  game_state.resume_button_entity.destroy()
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
