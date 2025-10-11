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
/// Panel
/// - LevelUpText
/// - Button1
///   - Icon1 | Text1
/// - Button2 
///   - Icon2 | Text2 
/// - Button3
///   - Icon3 | Text3
/// 
fn setup_level_up_ui() -> Unit {
  let panel = game_state.level_up_panel
  let root_entity = panel.root_entity

  // Set up main panel root entity with centered position
  @position.positions.set(
    root_entity,
    @position.Position(
      @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 80, VIEWPORT_HEIGHT / 2.0 - 120),
    ),
  )
  @ui.uis.set(panel.root_entity, @ui.Ui::new())
  @style.styles.set(
    root_entity,
    @style.Style::new(size_plan=FromChildren, flex=Vertical, v_padding=20.0),
  )
  let level_up_text_entity = root_entity.spawn_child()

  // Set up title text sprite on the root entity
  @sprite.sprites.set(
    level_up_text_entity,
    @sprite.Sprite::from_text(
      @sprite.Text::new(
        "LEVEL UP!",
        color="gold",
        font="36px ThaleahFat",
        baseline=Top,
        align=Left,
      ),
      UI_ZINDEX + 2,
    ),
  )
  @style.styles.set(
    level_up_text_entity,
    @style.Style::new(size_plan=Sized(Vec2D(160.0, 36.0))),
  )
  @ui.uis.set(level_up_text_entity, @ui.Ui::new())

  // Create 3 powerup buttons as children during setup
  for i in 0..<3 {
    // Create button entity as child
    let button_entity = root_entity.spawn_child()
    @ui.uis.set(button_entity, @ui.Ui::new())
    @style.styles.set(
      button_entity,
      @style.Style::new(
        size_plan=FromSprite,
        flex=Horizontal,
        h_padding=2.0,
        v_padding=2.0,
      ),
    )
    @sprite.sprites.set(
      button_entity,
      @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(Vec2D(160.0, 36.0), "rgba(13, 167, 170, 1)"),
        UI_ZINDEX + 1,
      ),
    )
    @collision.shapes.set(
      button_entity,
      @collision.CollisionShape::Rect(
        size=@math.Vec2D(160.0, 36.0),
        offset=@math.Vec2D::zero(),
      ),
    )
    let pickable = @collision.Pickable::new()
    pickable.on_just_pressed(fn(_button) { select_powerup(i) })
    @collision.pickables.set(button_entity, pickable)

    // Icon
    let icon_entity = button_entity.spawn_child()
    @ui.uis.set(icon_entity, @ui.Ui::new())
    let default_icon = powerup_range_icon
    let icon_sprite = @sprite.Sprite::from_animation(
      default_icon,
      UI_ZINDEX + 2,
      // offset=@math.Vec2D(-16.0, -16.0),
    )
    @sprite.sprites.set(icon_entity, icon_sprite)
    @style.styles.set(icon_entity, @style.Style::new())

    // Text
    let text_entity = button_entity.spawn_child()
    @ui.uis.set(text_entity, @ui.Ui::new())
    let default_text = @sprite.Text::new(
      "Default",
      color="white",
      font="16px ThaleahFat",
    )
    @sprite.sprites.set(
      text_entity,
      @sprite.Sprite::from_text(default_text, UI_ZINDEX + 2),
    )
    @style.styles.set(text_entity, @style.Style::new())
  }

  // Initially destroy the root panel (all children will be destroyed too)
  root_entity.destroy()
}

///|
fn level_up() -> Unit {
  @backend.set_time_scale(0.0)
  let panel = game_state.level_up_panel

  // Generate 3 random powerups
  panel.available_powerups = generate_random_powerups()

  // Respawn the main panel (this will respawn all children automatically)
  panel.root_entity.respawn()
  let button_entities = panel.root_entity.get_children()

  // Update button text and icons with powerup information
  for i in 0..<3 {
    update_powerup_display(panel.available_powerups[i], button_entities[i + 1])
  }
}

///|
fn update_powerup_display(
  powerup : Powerup,
  button_entity : @entity.Entity,
) -> Unit {
  let children = button_entity.get_children()
  let icon_entity = children[0]
  let text_entity = children[1]

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
    // offset=@math.Vec2D(-16.0, -16.0),
  )
  @sprite.sprites.set(icon_entity, icon_sprite)
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
  // Hide only the root panel - all children will be destroyed automatically
  panel.root_entity.destroy()
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
