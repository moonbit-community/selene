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
const UI_WIDGET_ZINDEX : Int = @ui.UI_ZINDEX + 1

///|
const UI_CHILD_ZINDEX : Int = @ui.UI_ZINDEX + 2

///|
const LEVELUP_PANEL_TITLE_OFFSET_Y = 20.0

///|
const LEVELUP_PANEL_BUTTON_START_Y = 76.0

///|
const LEVELUP_PANEL_BUTTON_GAP_Y = 20.0

///|
let levelup_buttons : Array[@entity.Entity] = []

///|
let restart_button_ref : Ref[@entity.Entity?] = { val: None }

///|
let ui_interaction_reader : @event.EventReader[@ui.InteractionEvent] = @event.EventReader::new()

///|
fn add_screen_sprite(
  offset : @math.Vec2D,
  sprite : @sprite.Sprite,
) -> @entity.Entity {
  let entity = @ui.add_node(
    @ui.screen_root,
    node=@ui.Node::new(space=@ui.UiSpace::Screen, offset~),
  )
  @sprite.sprites.set(entity, sprite)
  entity
}

///|
fn add_child_sprite(
  parent : @entity.Entity,
  offset : @math.Vec2D,
  sprite : @sprite.Sprite,
) -> @entity.Entity {
  let entity = @ui.add_node(
    parent,
    node=@ui.Node::new(space=@ui.UiSpace::Screen, offset~),
  )
  @sprite.sprites.set(entity, sprite)
  entity
}

///|
fn add_child_sprite_sized(
  parent : @entity.Entity,
  offset : @math.Vec2D,
  size : @math.Vec2D,
  sprite : @sprite.Sprite,
) -> @entity.Entity {
  let entity = @ui.add_node(
    parent,
    node=@ui.Node::new(
      space=@ui.UiSpace::Screen,
      offset~,
      size=@ui.NodeSize::Fixed(size),
    ),
  )
  @sprite.sprites.set(entity, sprite)
  entity
}

///|
fn add_score_box() -> Unit {
  add_screen_sprite(
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 40, 16.0),
    @sprite.Sprite::from_text(game_state.score_box, UI_WIDGET_ZINDEX),
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
  let panel = game_state.level_up_panel.panel_entity
  levelup_buttons.clear()

  add_child_sprite_sized(
    panel,
    @math.Vec2D(8.0, LEVELUP_PANEL_TITLE_OFFSET_Y),
    @math.Vec2D(160.0, 36.0),
    @sprite.Sprite::from_text(
      @sprite.Text::new(
        "LEVEL UP!",
        color="gold",
        font="36px ThaleahFat",
        baseline=Top,
        align=Left,
      ),
      UI_CHILD_ZINDEX,
    ),
  )
  |> ignore

  for i in 0..<3 {
    let button_y = LEVELUP_PANEL_BUTTON_START_Y +
      i.to_double() * (36.0 + LEVELUP_PANEL_BUTTON_GAP_Y)
    let button = add_child_sprite_sized(
      panel,
      @math.Vec2D(0.0, button_y),
      @math.Vec2D(160.0, 36.0),
      @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(
          @math.Vec2D(160.0, 36.0),
          "rgba(13, 167, 170, 1)",
          stroke_color="black",
        ),
        UI_CHILD_ZINDEX,
      ),
    )
    levelup_buttons.push(button)
    @ui.buttons.set(
      button,
      @ui.Button::new(
        trigger=@inputs.MouseButton::Left,
        hit_size=@math.Vec2D(160.0, 36.0),
      ),
    )

    add_child_sprite(
      button,
      @math.Vec2D(6.0, 2.0),
      @sprite.Sprite::from_animation(powerup_range_icon, UI_CHILD_ZINDEX + 1),
    )
    |> ignore

    add_child_sprite(
      button,
      @math.Vec2D(44.0, 10.0),
      @sprite.Sprite::from_text(
        @sprite.Text::new("Default", color="white", font="16px ThaleahFat"),
        UI_CHILD_ZINDEX + 1,
      ),
    )
    |> ignore
  }

  panel.destroy()
}

///|
fn level_up(level : Int) -> Unit {
  @time.set_scale(0.0)
  let panel = game_state.level_up_panel

  panel.available_selections = generate_level_up_selections(level)
  panel.panel_entity.respawn()
  let button_entities = panel.panel_entity.get_children()

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
      let button_background = @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(
          Vec2D(160.0, 36.0),
          "rgba(13, 167, 170, 1)",
          stroke_color="black",
        ),
        UI_ZINDEX + 2,
      )
      @sprite.sprites.set(button_entity, button_background)

      let button_text = @sprite.Text::new(
        powerup.name,
        color="white",
        font="16px ThaleahFat",
      )
      let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 3)
      @sprite.sprites.set(text_entity, button_sprite)

      let icon_animation = get_powerup_icon(powerup.powerup_type)
      let icon_sprite = @sprite.Sprite::from_animation(
        icon_animation,
        UI_ZINDEX + 3,
      )
      @sprite.sprites.set(icon_entity, icon_sprite)
    }
    WeaponSelection(weapon_type) => {
      let button_background = @sprite.Sprite::from_color_rect(
        @sprite.ColorRect::new(
          Vec2D(160.0, 36.0),
          "rgba(255, 140, 0, 1)",
          stroke_color="black",
        ),
        UI_ZINDEX + 2,
      )
      @sprite.sprites.set(button_entity, button_background)

      let button_text = @sprite.Text::new(
        get_weapon_name(weapon_type),
        color="white",
        font="16px ThaleahFat",
      )
      let button_sprite = @sprite.Sprite::from_text(button_text, UI_ZINDEX + 3)
      @sprite.sprites.set(text_entity, button_sprite)

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

  if game_state.pending_level_ups.is_empty() {
    @time.set_scale(1.0)
  } else {
    process_next_level_up()
  }
}

///|
fn add_wave_box() -> Unit {
  add_screen_sprite(
    @math.Vec2D(16.0, 84.0),
    @sprite.Sprite::from_text(game_state.wave_box, UI_WIDGET_ZINDEX),
  )
  |> ignore
}

///|
fn add_exp_box() -> Unit {
  add_screen_sprite(
    @math.Vec2D(16.0, 50.0),
    @sprite.Sprite::from_text(game_state.exp_box, UI_WIDGET_ZINDEX),
  )
  |> ignore
}

///|
fn add_timer_box() -> Unit {
  add_screen_sprite(
    @math.Vec2D(VIEWPORT_WIDTH - 120.0, 16.0),
    @sprite.Sprite::from_text(game_state.timer_box, UI_WIDGET_ZINDEX),
  )
  |> ignore
}

///|
fn setup_game_over_ui() -> Unit {
  let panel = game_state.game_over_panel.panel_entity

  add_child_sprite(
    panel,
    @math.Vec2D(30.0, 18.0),
    @sprite.Sprite::from_text(
      @sprite.Text::new(
        "VICTORY!",
        color="gold",
        font="32px ThaleahFat",
        baseline=Top,
        align=Left,
      ),
      UI_CHILD_ZINDEX,
    ),
  )
  |> ignore

  add_child_sprite(
    panel,
    @math.Vec2D(8.0, 52.0),
    @sprite.Sprite::from_text(game_state.game_over_box, UI_CHILD_ZINDEX),
  )
  |> ignore

  let restart_button = add_child_sprite_sized(
    panel,
    @math.Vec2D(10.0, 74.0),
    @math.Vec2D(180.0, 40.0),
    @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(
        Vec2D(180.0, 40.0),
        "rgba(13, 167, 170, 1)",
        stroke_color="white",
      ),
      UI_CHILD_ZINDEX,
    ),
  )
  @ui.buttons.set(
    restart_button,
    @ui.Button::new(
      trigger=@inputs.MouseButton::Left,
      hit_size=@math.Vec2D(180.0, 40.0),
    ),
  )
  restart_button_ref.val = Some(restart_button)

  add_child_sprite(
    restart_button,
    @math.Vec2D(45.0, 8.0),
    @sprite.Sprite::from_text(
      @sprite.Text::new("RESTART", color="white", font="24px ThaleahFat"),
      UI_CHILD_ZINDEX + 1,
    ),
  )
  |> ignore

  panel.destroy()
}

///|
fn add_game_over_box() -> Unit {
  game_state.game_over_panel.panel_entity.respawn()
}

///|
fn add_level_box() -> Unit {
  add_screen_sprite(
    @math.Vec2D(16.0, 16.0),
    @sprite.Sprite::from_text(game_state.level_box, UI_WIDGET_ZINDEX),
  )
  |> ignore
}

///|
fn survivors_ui_pointer_system(_delta : Double) -> Unit {
  for event in @ui.interaction_event_bus.read(ui_interaction_reader) {
    guard event.current is @ui.Interaction::Pressed else { continue }
    if restart_button_ref.val is Some(restart_button) &&
      event.entity == restart_button {
      restart_game()
      continue
    }
    for index, button in levelup_buttons {
      if event.entity == button {
        select_powerup(index)
        break
      }
    }
  }
}
