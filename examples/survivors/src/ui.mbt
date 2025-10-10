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
  let entity = @entity.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.score_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn setup_level_up_ui() -> Unit {
  let panel = game_state.level_up_panel

  // Set up level up text entity
  let level_up_sprite = @sprite.Sprite::from_text(
    panel.title_text,
    UI_ZINDEX + 2,
  )
  @sprite.sprites.set(panel.title_entity, level_up_sprite)
  let level_up_position = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0,
    VIEWPORT_HEIGHT / 2.0 - 120,
  )
  @position.positions.set(
    panel.title_entity,
    @position.Position(level_up_position),
  )
  @ui.uis.set(panel.title_entity, @ui.Ui::new())

  // Set up powerup button entities with backgrounds and icons
  setup_powerup_button_with_background(
    panel.button1_entity,
    panel.icon1_entity,
    panel.bg1_entity,
    0
  )
  setup_powerup_button_with_background(
    panel.button2_entity,
    panel.icon2_entity,
    panel.bg2_entity,
    1
  )
  setup_powerup_button_with_background(
    panel.button3_entity,
    panel.icon3_entity,
    panel.bg3_entity,
    2
  )

  // Initially destroy all entities (they'll be respawned when needed)
  panel.title_entity.destroy()
  panel.button1_entity.destroy()
  panel.button2_entity.destroy()
  panel.button3_entity.destroy()
  panel.icon1_entity.destroy()
  panel.icon2_entity.destroy()
  panel.icon3_entity.destroy()
  panel.bg1_entity.destroy()
  panel.bg2_entity.destroy()
  panel.bg3_entity.destroy()
}

///|
fn setup_powerup_button_with_background(
  button_entity : @entity.Entity,
  icon_entity : @entity.Entity,
  bg_entity : @entity.Entity,
  index : Int
) -> Unit {
  // Position buttons vertically with more spacing
  let button_y = VIEWPORT_HEIGHT / 2.0 - 60.0 + index.to_double() * 50.0
  let button_position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40, button_y)

  // Set up blue background rectangle (render first, lowest z-index)
  let bg_sprite = @sprite.Sprite::from_color_rect(
    @sprite.ColorRect::new(Vec2D(240.0, 35.0), "blue"),
    UI_ZINDEX + 1,
  )
  @sprite.sprites.set(bg_entity, bg_sprite)
  let bg_position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 120, button_y - 2.0)
  @position.positions.set(bg_entity, @position.Position(bg_position))
  @ui.uis.set(bg_entity, @ui.Ui::new())

  // Set up text button (render on top of background)
  @position.positions.set(button_entity, @position.Position(button_position))
  @ui.uis.set(button_entity, @ui.Ui::new())

  // Set up icon (positioned to the left of the text)
  let icon_position = @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 120, button_y - 2.0)
  @position.positions.set(icon_entity, @position.Position(icon_position))
  @ui.uis.set(icon_entity, @ui.Ui::new())

  // Add clickable area for the button (covers the entire blue background)
  @collision.shapes.set(
    button_entity,
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(240.0, 35.0),
      offset=@math.Vec2D(-60.0, -2.0),
    ),
  )

  // Create pickable component for button
  let pickable = @collision.Pickable::new()
  pickable.on_just_pressed(fn(_button) { select_powerup(index) })
  @collision.pickables[button_entity] = pickable
}

///|
fn level_up() -> Unit {
  @backend.set_time_scale(0.0)

  let panel = game_state.level_up_panel

  // Generate 3 random powerups
  panel.available_powerups = generate_random_powerups()

  // Update button text and icons with powerup information
  update_powerup_display(panel.button1_entity, panel.icon1_entity, 0)
  update_powerup_display(panel.button2_entity, panel.icon2_entity, 1)
  update_powerup_display(panel.button3_entity, panel.icon3_entity, 2)

  // Respawn all level-up UI entities (backgrounds first for proper layering)
  panel.bg1_entity.respawn()
  panel.bg2_entity.respawn()
  panel.bg3_entity.respawn()
  panel.title_entity.respawn()
  panel.button1_entity.respawn()
  panel.button2_entity.respawn()
  panel.button3_entity.respawn()
  panel.icon1_entity.respawn()
  panel.icon2_entity.respawn()
  panel.icon3_entity.respawn()
}

///|
fn update_powerup_display(text_entity : @entity.Entity, icon_entity : @entity.Entity, index : Int) -> Unit {
  let panel = game_state.level_up_panel
  if index < panel.available_powerups.length() {
    let powerup = panel.available_powerups[index]

    // Update text
    let button_text = @sprite.Text::new(
      powerup.name,
      color="white",
      font="16px ThaleahFat",
    )
    let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 2)
    @sprite.sprites.set(text_entity, button_sprite)

    // Update icon
    let icon_animation = get_powerup_icon(powerup.powerup_type)
    let icon_sprite = @sprite.Sprite::from_animation(
      icon_animation,
      UI_ZINDEX + 2,
      offset=@math.Vec2D(-16.0, -16.0),
    )
    @sprite.sprites.set(icon_entity, icon_sprite)
  }
}

///|
fn select_powerup(index : Int) -> Unit {
  let panel = game_state.level_up_panel
  if index < panel.available_powerups.length() {
    let powerup = panel.available_powerups[index]
    apply_powerup(powerup)
  }
  resume_game()
}

///|
fn resume_game() -> Unit {
  @backend.set_time_scale(1.0)

  let panel = game_state.level_up_panel
  // Hide all level-up UI entities
  panel.title_entity.destroy()
  panel.button1_entity.destroy()
  panel.button2_entity.destroy()
  panel.button3_entity.destroy()
  panel.icon1_entity.destroy()
  panel.icon2_entity.destroy()
  panel.icon3_entity.destroy()
  panel.bg1_entity.destroy()
  panel.bg2_entity.destroy()
  panel.bg3_entity.destroy()
}

///|
fn add_wave_box() -> Unit {
  let entity = @entity.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.wave_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 84.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_exp_box() -> Unit {
  let entity = @entity.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.exp_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 50.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_timer_box() -> Unit {
  let entity = @entity.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.timer_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(VIEWPORT_WIDTH - 120, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}

///|
fn add_game_over_box() -> Unit {
  let entity = @entity.Entity::new()
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
  let entity = @entity.Entity::new()
  let sprite = @sprite.Sprite::from_text(game_state.level_box, UI_ZINDEX)
  @sprite.sprites.set(entity, sprite)
  let position = @math.Vec2D(16.0, 16.0)
  @position.positions.set(entity, @position.Position(position))
  @ui.uis.set(entity, @ui.Ui::new())
}
