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
const HUD_LAYER_ZINDEX : Int = HUD_ZINDEX + 1

///|
const PANEL_LAYER_ZINDEX : Int = HUD_ZINDEX + 2

///|
const PANEL_TEXT_ZINDEX : Int = HUD_ZINDEX + 3

///|
const LEVELUP_PANEL_TITLE_OFFSET_Y = 20.0

///|
const LEVELUP_PANEL_BUTTON_START_Y = 76.0

///|
const LEVELUP_PANEL_BUTTON_GAP_Y = 20.0

///|
const LEVELUP_BUTTON_ICON_SIZE = 24.0

///|
const LEVELUP_BUTTON_ICON_OFFSET_X = 8.0

///|
const LEVELUP_BUTTON_ICON_OFFSET_Y = 6.0

///|
const POWERUP_ATTACK_ICON_PATH = "assets/survivors/icon/powerup_attack.png"

///|
const POWERUP_RANGE_ICON_PATH = "assets/survivors/icon/powerup_range.png"

///|
const POWERUP_SPEED_ICON_PATH = "assets/survivors/icon/powerup_speed.png"

///|
const POWERUP_COOLDOWN_ICON_PATH = "assets/survivors/icon/powerup_cooldown.png"

///|
const POWERUP_BANDANA_ICON_PATH = "assets/survivors/icon/powerup_bandana.png"

///|
const WEAPON_PISTOL_ICON_PATH = "assets/survivors/icon/weapon_pistol.png"

///|
const WEAPON_MINIGUN_ICON_PATH = "assets/survivors/icon/weapon_minigun.png"

///|
const WEAPON_SNIPERRIFLE_ICON_PATH = "assets/survivors/icon/weapon_sniperrifle.png"

///|
const WEAPON_SWORD_ICON_PATH = "assets/survivors/icon/weapon_sword.png"

///|
let levelup_buttons : Array[@entity.Entity] = []

///|
let levelup_button_icons : Array[@entity.Entity] = []

///|
let levelup_title_ref : Ref[@entity.Entity?] = { val: None }

///|
let game_over_title_ref : Ref[@entity.Entity?] = { val: None }

///|
let restart_button_ref : Ref[@entity.Entity?] = { val: None }

///|
let ui_click_reader : @event.EventReader[@ui.UiClickEvent] = @event.EventReader::new()

///|
fn set_ui_text(entity : @entity.Entity, content : String) -> Unit {
  let text = @ui.texts().get_or_init(entity, fn() { @ui.Text::new(content) })
  text.content = content
}

///|
fn set_ui_text_color(entity : @entity.Entity, color : String) -> Unit {
  @ui.text_colors().set(entity, @ui.TextColor::from_css(color))
}

///|
fn configure_text_entity(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  content : String,
  color : String,
  font : String,
  size? : @math.Vec2D = @math.Vec2D(-1.0, -1.0),
  align? : @math.HAlign = @math.HAlign::Left,
  baseline? : @math.VAlign = @math.VAlign::Top,
  zindex? : Int = HUD_LAYER_ZINDEX,
) -> Unit {
  @ui.nodes().set(
    entity,
    @ui.Node::absolute(offset, size~, border=@ui.UiRectValues::all(1.0)),
  )
  @ui.z_indexes().set(entity, @ui.ZIndex::new(zindex))
  set_ui_text(entity, content)
  @ui.text_fonts().set(entity, @ui.TextFont::from_css(font))
  set_ui_text_color(entity, color)
  @ui.text_layouts().set(entity, @ui.TextLayout::new(align~, baseline~))
}

///|
fn configure_panel_box(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  size : @math.Vec2D,
  background : String,
  border : String,
) -> Unit {
  @ui.nodes().set(
    entity,
    @ui.Node::absolute(offset, size~, border=@ui.UiRectValues::all(1.0)),
  )
  @ui.z_indexes().set(entity, @ui.ZIndex::new(PANEL_LAYER_ZINDEX))
  @ui.background_colors().set(entity, @ui.BackgroundColor::from_css(background))
  @ui.border_colors().set(entity, @ui.BorderColor::from_css(border))
  @ui.border_radii().set(entity, @ui.BorderRadius::all(@ui.Val::px(10.0)))
}

///|
fn configure_panel_button(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  size : @math.Vec2D,
  background : String,
  border : String,
  label : String,
  tab_index : Int,
) -> Unit {
  @ui.nodes().set(entity, @ui.Node::absolute(offset, size~))
  @ui.z_indexes().set(entity, @ui.ZIndex::new(PANEL_TEXT_ZINDEX))
  @ui.background_colors().set(entity, @ui.BackgroundColor::from_css(background))
  @ui.border_colors().set(entity, @ui.BorderColor::from_css(border))
  @ui.border_radii().set(entity, @ui.BorderRadius::all(@ui.Val::px(8.0)))
  @ui.buttons().set(entity, @ui.Button::new())
  @ui.tab_indexes().set(entity, @ui.TabIndex::new(tab_index))
  set_ui_text(entity, label)
  @ui.text_fonts().set(entity, @ui.TextFont::from_css("16px ThaleahFat"))
  set_ui_text_color(entity, "white")
  @ui.text_layouts().set(
    entity,
    @ui.TextLayout::new(
      align=@math.HAlign::Center,
      baseline=@math.VAlign::Center,
    ),
  )
}

///|
fn levelup_panel_origin() -> @math.Vec2D {
  @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 80.0, VIEWPORT_HEIGHT / 2.0 - 120.0)
}

///|
fn game_over_panel_origin() -> @math.Vec2D {
  @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 100.0, VIEWPORT_HEIGHT / 2.0 - 60.0)
}

///|
fn set_ui_active(entity : @entity.Entity, active : Bool) -> Unit {
  if @ui.nodes().get(entity) is Some(node) {
    @ui.nodes().set(entity, { ..node, active })
  }
}

///|
fn set_button_enabled(entity : @entity.Entity, enabled : Bool) -> Unit {
  if @ui.buttons().get(entity) is Some(_) {
    @ui.buttons().set(entity, @ui.Button::new(enabled~))
  }
}

///|
fn set_icon_image(entity : @entity.Entity, path : String) -> Unit {
  @ui.ui_images().set(
    entity,
    @ui.UiImage::new(
      @math.Vec2D(LEVELUP_BUTTON_ICON_SIZE, LEVELUP_BUTTON_ICON_SIZE),
      path,
      fit=@ui.ImageFit::Contain,
    ),
  )
}

///|
fn powerup_icon_path(powerup_type : PowerupType) -> String {
  match powerup_type {
    AttackLv1 | AttackLv2 | AttackLv3 => POWERUP_ATTACK_ICON_PATH
    RangeLv1 | RangeLv2 => POWERUP_RANGE_ICON_PATH
    SpeedLv1 | SpeedLv2 => POWERUP_SPEED_ICON_PATH
    CooldownLv1 | CooldownLv2 => POWERUP_COOLDOWN_ICON_PATH
    Bandana => POWERUP_BANDANA_ICON_PATH
  }
}

///|
fn weapon_icon_path(weapon_type : WeaponType) -> String {
  match weapon_type {
    Pistol => WEAPON_PISTOL_ICON_PATH
    Minigun => WEAPON_MINIGUN_ICON_PATH
    SniperRifle => WEAPON_SNIPERRIFLE_ICON_PATH
    Sword => WEAPON_SWORD_ICON_PATH
  }
}

///|
fn hide_level_up_ui() -> Unit {
  set_ui_active(game_state.level_up_panel.panel_entity, false)
  if levelup_title_ref.val is Some(title) {
    set_ui_active(title, false)
  }
  for button in levelup_buttons {
    set_ui_active(button, false)
    set_button_enabled(button, false)
  }
  for icon in levelup_button_icons {
    set_ui_active(icon, false)
  }
}

///|
fn show_level_up_ui() -> Unit {
  set_ui_active(game_state.level_up_panel.panel_entity, true)
  if levelup_title_ref.val is Some(title) {
    set_ui_active(title, true)
  }
  for button in levelup_buttons {
    set_ui_active(button, true)
    set_button_enabled(button, true)
  }
  for icon in levelup_button_icons {
    set_ui_active(icon, true)
  }
}

///|
fn hide_game_over_ui() -> Unit {
  set_ui_active(game_state.game_over_panel.panel_entity, false)
  set_ui_active(game_state.game_over_box, false)
  if game_over_title_ref.val is Some(title) {
    set_ui_active(title, false)
  }
  if restart_button_ref.val is Some(button) {
    set_ui_active(button, false)
    set_button_enabled(button, false)
  }
}

///|
fn show_game_over_ui() -> Unit {
  set_ui_active(game_state.game_over_panel.panel_entity, true)
  set_ui_active(game_state.game_over_box, true)
  if game_over_title_ref.val is Some(title) {
    set_ui_active(title, true)
  }
  if restart_button_ref.val is Some(button) {
    set_ui_active(button, true)
    set_button_enabled(button, true)
  }
}

///|
fn add_score_box() -> Unit {
  configure_text_entity(
    game_state.score_box,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 100.0, 16.0),
    "Score: 0",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2D(200.0, 28.0),
    align=@math.HAlign::Center,
  )
}

///|
fn setup_level_up_ui() -> Unit {
  levelup_buttons.clear()
  levelup_button_icons.clear()
  configure_panel_box(
    game_state.level_up_panel.panel_entity,
    levelup_panel_origin(),
    @math.Vec2D(160.0, 250.0),
    "rgba(13, 170, 26, 1)",
    "black",
  )

  let title = @entity.Entity::new()
  levelup_title_ref.val = Some(title)
  configure_text_entity(
    title,
    levelup_panel_origin() + @math.Vec2D(8.0, LEVELUP_PANEL_TITLE_OFFSET_Y),
    "LEVEL UP!",
    "gold",
    "36px ThaleahFat",
    size=@math.Vec2D(144.0, 36.0),
    align=@math.HAlign::Center,
    zindex=PANEL_TEXT_ZINDEX,
  )

  for i in 0..<3 {
    let button_y = LEVELUP_PANEL_BUTTON_START_Y +
      i.to_double() * (36.0 + LEVELUP_PANEL_BUTTON_GAP_Y)
    let button = @entity.Entity::new()
    configure_panel_button(
      button,
      levelup_panel_origin() + @math.Vec2D(0.0, button_y),
      @math.Vec2D(160.0, 36.0),
      "rgba(13, 167, 170, 1)",
      "black",
      "Default",
      i,
    )
    levelup_buttons.push(button)

    let icon = @entity.Entity::new()
    @ui.nodes().set(
      icon,
      @ui.Node::absolute(
        levelup_panel_origin() +
        @math.Vec2D(
          LEVELUP_BUTTON_ICON_OFFSET_X,
          button_y + LEVELUP_BUTTON_ICON_OFFSET_Y,
        ),
        size=@math.Vec2D(LEVELUP_BUTTON_ICON_SIZE, LEVELUP_BUTTON_ICON_SIZE),
      ),
    )
    @ui.z_indexes().set(icon, @ui.ZIndex::new(PANEL_TEXT_ZINDEX))
    set_icon_image(icon, POWERUP_RANGE_ICON_PATH)
    levelup_button_icons.push(icon)
  }

  hide_level_up_ui()
}

///|
fn level_up(level : Int) -> Unit {
  @time.set_scale(0.0)
  let panel = game_state.level_up_panel

  panel.available_selections = generate_level_up_selections(level)
  show_level_up_ui()

  for i in 0..<3 {
    update_selection_display(
      panel.available_selections[i],
      levelup_buttons[i],
      levelup_button_icons[i],
    )
  }
}

///|
fn update_selection_display(
  selection : LevelUpSelection,
  button_entity : @entity.Entity,
  icon_entity : @entity.Entity,
) -> Unit {
  match selection {
    PowerupSelection(powerup) => {
      @ui.background_colors().set(
        button_entity,
        @ui.BackgroundColor::from_css("rgba(13, 167, 170, 1)"),
      )
      set_ui_text(button_entity, powerup.name)
      set_icon_image(icon_entity, powerup_icon_path(powerup.powerup_type))
    }
    WeaponSelection(weapon_type) => {
      @ui.background_colors().set(
        button_entity,
        @ui.BackgroundColor::from_css("rgba(255, 140, 0, 1)"),
      )
      set_ui_text(button_entity, get_weapon_name(weapon_type))
      set_icon_image(icon_entity, weapon_icon_path(weapon_type))
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
  hide_level_up_ui()

  if game_state.pending_level_ups.is_empty() {
    @time.set_scale(1.0)
  } else {
    process_next_level_up()
  }
}

///|
fn add_wave_box() -> Unit {
  configure_text_entity(
    game_state.wave_box,
    @math.Vec2D(16.0, 84.0),
    "Wave: 1",
    "orange",
    "24px ThaleahFat",
  )
}

///|
fn add_exp_box() -> Unit {
  configure_text_entity(
    game_state.exp_box,
    @math.Vec2D(16.0, 50.0),
    "EXP: 0/16",
    "cyan",
    "24px ThaleahFat",
  )
}

///|
fn add_timer_box() -> Unit {
  configure_text_entity(
    game_state.timer_box,
    @math.Vec2D(VIEWPORT_WIDTH - 140.0, 16.0),
    "Time: 10:00",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2D(124.0, 28.0),
    align=@math.HAlign::Right,
  )
}

///|
fn setup_game_over_ui() -> Unit {
  configure_panel_box(
    game_state.game_over_panel.panel_entity,
    game_over_panel_origin(),
    @math.Vec2D(200.0, 120.0),
    "rgba(0, 0, 0, 0.8)",
    "white",
  )

  let title = @entity.Entity::new()
  game_over_title_ref.val = Some(title)
  configure_text_entity(
    title,
    game_over_panel_origin() + @math.Vec2D(10.0, 18.0),
    "VICTORY!",
    "gold",
    "32px ThaleahFat",
    size=@math.Vec2D(180.0, 30.0),
    align=@math.HAlign::Center,
    zindex=PANEL_TEXT_ZINDEX,
  )

  configure_text_entity(
    game_state.game_over_box,
    game_over_panel_origin() + @math.Vec2D(8.0, 52.0),
    "Final Score: 0",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2D(184.0, 22.0),
    align=@math.HAlign::Center,
    zindex=PANEL_TEXT_ZINDEX,
  )

  let restart_button = @entity.Entity::new()
  restart_button_ref.val = Some(restart_button)
  configure_panel_button(
    restart_button,
    game_over_panel_origin() + @math.Vec2D(10.0, 74.0),
    @math.Vec2D(180.0, 40.0),
    "rgba(13, 167, 170, 1)",
    "white",
    "RESTART",
    10,
  )
  @ui.text_fonts().set(
    restart_button,
    @ui.TextFont::from_css("24px ThaleahFat"),
  )

  hide_game_over_ui()
}

///|
fn add_game_over_box() -> Unit {
  show_game_over_ui()
}

///|
fn add_level_box() -> Unit {
  configure_text_entity(
    game_state.level_box,
    @math.Vec2D(16.0, 16.0),
    "Level: 1",
    "yellow",
    "24px ThaleahFat",
  )
}

///|
fn survivors_ui_pointer_system(_world : @ecs.World) -> Unit {
  for event in @ui.click_event_bus.read(ui_click_reader) {
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
