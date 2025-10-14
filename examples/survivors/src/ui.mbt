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
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.score_box, zindex),
    h_offset=VIEWPORT_WIDTH / 2.0 - 40,
    v_offset=16,
  )
  |> ignore
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
  // Set up main panel root entity with centered position
  let panel = game_state.level_up_panel.panel_entity

  // Set up title text sprite on the root entity
  @style.add_widget(
    panel,
    sprite=zindex => @sprite.Sprite::from_text(
      @sprite.Text::new(
        "LEVEL UP!",
        color="gold",
        font="36px ThaleahFat",
        baseline=Top,
        align=Left,
      ),
      zindex,
    ),
    size_plan=Sized(Vec2D(160.0, 36.0)),
    h_offset=8.0,
  )
  |> ignore

  // Create 3 powerup buttons as children during setup
  for i in 0..<3 {
    // Create button entity as child
    let button = @style.add_widget(
      panel,
      sprite=zindex => @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(
          Vec2D(160.0, 36.0),
          "rgba(13, 167, 170, 1)",
          stroke_color="black",
        ),
        zindex,
      ),
      flex=Horizontal,
      size_plan=FromSprite,
      h_padding=2.0,
      v_padding=2.0,
      shape=@collision.CollisionShape::Rect(
        size=@math.Vec2D(160.0, 36.0),
        offset=@math.Vec2D::zero(),
      ),
      on_just_pressed=fn(_button) { select_powerup(i) },
    )

    // Icon
    @style.add_widget(button, sprite=zindex => @sprite.Sprite::from_animation(
      powerup_range_icon, zindex,
    ))
    |> ignore

    // Text
    @style.add_widget(button, sprite=zindex => @sprite.Sprite::from_text(
      @sprite.Text::new("Default", color="white", font="16px ThaleahFat"),
      zindex,
    ))
    |> ignore
  }

  // Initially destroy the root panel (all children will be destroyed too)
  panel.destroy()
}

///|
fn level_up(level : Int) -> Unit {
  @backend.set_time_scale(0.0)
  let panel = game_state.level_up_panel

  // Generate selections based on the level being processed
  panel.available_selections = generate_level_up_selections(level)

  // Respawn the main panel (this will respawn all children automatically)
  panel.panel_entity.respawn()
  let button_entities = panel.panel_entity.get_children()

  // Update button text and icons with selection information
  for i in 0..<3 {
    update_selection_display(
      panel.available_selections[i],
      button_entities[i + 1],
    )
  }
}

///|
fn update_selection_display(
  selection : LevelUpSelection,
  button_entity : @entity.Entity,
) -> Unit {
  let children = button_entity.get_children()
  let icon_entity = children[0]
  let text_entity = children[1]
  match selection {
    PowerupSelection(powerup) => {
      // Update text
      let button_text = @sprite.Text::new(
        powerup.name,
        color="white",
        font="16px ThaleahFat",
      )
      let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 3)
      @sprite.sprites.set(text_entity, button_sprite)

      // Update icon
      let icon_animation = get_powerup_icon(powerup.powerup_type)
      let icon_sprite = @sprite.Sprite::from_animation(
        icon_animation,
        UI_ZINDEX + 3,
      )
      @sprite.sprites.set(icon_entity, icon_sprite)
    }
    WeaponSelection(weapon_type) => {
      // Update text
      let button_text = @sprite.Text::new(
        get_weapon_name(weapon_type),
        color="white",
        font="16px ThaleahFat",
      )
      let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 3)
      @sprite.sprites.set(text_entity, button_sprite)

      // Update icon
      let icon_animation = get_weapon_icon(weapon_type)
      let icon_sprite = @sprite.Sprite::from_animation(
        icon_animation,
        UI_ZINDEX + 3,
      )
      @sprite.sprites.set(icon_entity, icon_sprite)
    }
  }
}

///|
fn select_powerup(index : Int) -> Unit {
  let panel = game_state.level_up_panel
  if index < panel.available_selections.length() {
    let selection = panel.available_selections[index]
    apply_selection(selection)
  }
  resume_game()
}

///|
fn resume_game() -> Unit {
  game_state.level_up_panel.panel_entity.destroy()

  // Check if there are more pending level-ups
  if game_state.pending_level_ups.is_empty() {
    @backend.set_time_scale(1.0)
  } else {
    process_next_level_up()
  }
}

///|
fn add_wave_box() -> Unit {
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.wave_box, zindex),
    h_offset=16.0,
    v_offset=84.0,
  )
  |> ignore
}

///|
fn add_exp_box() -> Unit {
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.exp_box, zindex),
    h_offset=16.0,
    v_offset=50.0,
  )
  |> ignore
}

///|
fn add_timer_box() -> Unit {
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.timer_box, zindex),
    h_offset=VIEWPORT_WIDTH - 120,
    v_offset=16.0,
  )
  |> ignore
}

///|
/// TODO: change to `game_over`
/// 
fn add_game_over_box() -> Unit {
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.game_over_box, zindex),
    h_offset=VIEWPORT_WIDTH / 2.0 - 160,
    v_offset=VIEWPORT_HEIGHT / 2.0,
  )
  |> ignore
}

///|
fn add_level_box() -> Unit {
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.level_box, zindex),
    h_offset=16.0,
    v_offset=16.0,
  )
  |> ignore
}
