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
const HUD_LAYER_ZINDEX : Int32 = HUD_ZINDEX + 1

///|
const PANEL_LAYER_ZINDEX : Int32 = HUD_ZINDEX + 2

///|
const PANEL_TEXT_ZINDEX : Int32 = HUD_ZINDEX + 3

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
fn set_ui_text(entity : @ecs.Entity, content : String) -> Unit {
  guard @ui.texts().get(entity) is Some(text) else { return }
  text.content = content
}

///|
fn set_ui_text_color(entity : @ecs.Entity, color : String) -> Unit {
  @ui.text_colors().set(entity, @ui.TextColor::from_css(color))
}

///|
fn spawn_text_entity(
  offset : @math.Vec2,
  content : String,
  color : String,
  font : String,
  size~ : @math.Vec2 = Vec2(-1.0, -1.0),
  align~ : @math.HAlign = Left,
  baseline~ : @math.VAlign = Top,
  zindex~ : Int32 = HUD_LAYER_ZINDEX,
) -> @ecs.Entity {
  spawn_survivors_entity(
    (
      @ui.Node::absolute(offset, size~, border=@ui.UiRectValues::all(1.0)),
      @ui.ZIndex(zindex),
      @ui.Text(content),
      @ui.TextFont::from_css(font),
      @ui.TextColor::from_css(color),
      @ui.TextLayout(align~, baseline~),
    ),
  )
}

///|
fn spawn_panel_box(
  offset : @math.Vec2,
  size : @math.Vec2,
  background : String,
  border : String,
) -> @ecs.Entity {
  spawn_survivors_entity(
    (
      @ui.Node::absolute(offset, size~, border=@ui.UiRectValues::all(1.0)),
      @ui.ZIndex(PANEL_LAYER_ZINDEX),
      @ui.BackgroundColor::from_css(background),
      @ui.BorderColor::from_css(border),
      @ui.BorderRadius::all(@ui.Val::px(10.0)),
    ),
  )
}

///|
fn spawn_panel_button(
  offset : @math.Vec2,
  size : @math.Vec2,
  background : String,
  border : String,
  label : String,
  tab_index : Int32,
  font~ : String = "16px ThaleahFat",
) -> @ecs.Entity {
  let world = @ecs.require_current_world()
  let plan = world.prepare_spawn().combine(world.prepare_spawn())
  let entity = plan.spawn(
    (
      (
        @ui.Node::absolute(offset, size~),
        @ui.ZIndex(PANEL_TEXT_ZINDEX),
        @ui.BackgroundColor::from_css(background),
        @ui.BorderColor::from_css(border),
        @ui.BorderRadius::all(@ui.Val::px(8.0)),
        @ui.Button(),
        @ui.TabIndex(tab_index),
      ),
      (
        @ui.Text(label),
        @ui.TextFont::from_css(font),
        @ui.TextColor::from_css("white"),
        @ui.TextLayout(align=Center, baseline=Center),
      ),
    ),
  )
  survivors_runtime().entities.push(entity)
  entity
}

///|
fn levelup_panel_origin() -> @math.Vec2 {
  Vec2(VIEWPORT_WIDTH / 2.0 - 80.0, VIEWPORT_HEIGHT / 2.0 - 120.0)
}

///|
fn game_over_panel_origin() -> @math.Vec2 {
  Vec2(VIEWPORT_WIDTH / 2.0 - 100.0, VIEWPORT_HEIGHT / 2.0 - 60.0)
}

///|
fn set_ui_active(entity : @ecs.Entity, active : Bool) -> Unit {
  if @ui.nodes().get(entity) is Some(node) {
    @ui.nodes().set(entity, { ..node, active, })
  }
}

///|
fn set_button_enabled(entity : @ecs.Entity, enabled : Bool) -> Unit {
  if @ui.buttons().get(entity) is Some(_) {
    @ui.buttons().set(entity, Button(enabled~))
  }
}

///|
fn set_icon_image(entity : @ecs.Entity, path : String) -> Unit {
  @ui.ui_images().set(
    entity,
    UiImage(
      Vec2(LEVELUP_BUTTON_ICON_SIZE, LEVELUP_BUTTON_ICON_SIZE),
      path,
      fit=Contain,
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
  let runtime = survivors_runtime()
  set_ui_active(game_state().level_up_panel.panel_entity, false)
  if runtime.levelup_title is Some(title) {
    set_ui_active(title, false)
  }
  for button in runtime.levelup_buttons {
    set_ui_active(button, false)
    set_button_enabled(button, false)
  }
  for icon in runtime.levelup_button_icons {
    set_ui_active(icon, false)
  }
}

///|
fn show_level_up_ui() -> Unit {
  let runtime = survivors_runtime()
  set_ui_active(game_state().level_up_panel.panel_entity, true)
  if runtime.levelup_title is Some(title) {
    set_ui_active(title, true)
  }
  for button in runtime.levelup_buttons {
    set_ui_active(button, true)
    set_button_enabled(button, true)
  }
  for icon in runtime.levelup_button_icons {
    set_ui_active(icon, true)
  }
}

///|
fn hide_game_over_ui() -> Unit {
  let runtime = survivors_runtime()
  let game = game_state()
  set_ui_active(game.game_over_panel.panel_entity, false)
  set_ui_active(game.game_over_box, false)
  if runtime.game_over_title is Some(title) {
    set_ui_active(title, false)
  }
  if runtime.restart_button is Some(button) {
    set_ui_active(button, false)
    set_button_enabled(button, false)
  }
}

///|
fn show_game_over_ui() -> Unit {
  let runtime = survivors_runtime()
  let game = game_state()
  set_ui_active(game.game_over_panel.panel_entity, true)
  set_ui_active(game.game_over_box, true)
  if runtime.game_over_title is Some(title) {
    set_ui_active(title, true)
  }
  if runtime.restart_button is Some(button) {
    set_ui_active(button, true)
    set_button_enabled(button, true)
  }
}

///|
fn setup_level_up_ui() -> Unit {
  let runtime = survivors_runtime()
  runtime.levelup_buttons.clear()
  runtime.levelup_button_icons.clear()
  let title = spawn_text_entity(
    levelup_panel_origin() + Vec2(8.0, LEVELUP_PANEL_TITLE_OFFSET_Y),
    "LEVEL UP!",
    "gold",
    "36px ThaleahFat",
    size=Vec2(144.0, 36.0),
    align=Center,
    zindex=PANEL_TEXT_ZINDEX,
  )

  runtime.levelup_title = Some(title)

  for i in 0..<3 {
    let button_y = LEVELUP_PANEL_BUTTON_START_Y +
      i.to_double() * (36.0 + LEVELUP_PANEL_BUTTON_GAP_Y)
    let button = spawn_panel_button(
      levelup_panel_origin() + Vec2(0.0, button_y),
      Vec2(160.0, 36.0),
      "rgba(13, 167, 170, 1)",
      "black",
      "Default",
      i,
    )
    runtime.levelup_buttons.push(button)

    let icon = @ecs.require_current_world().spawn(
      (
        @ui.Node::absolute(
          Vec2(LEVELUP_BUTTON_ICON_OFFSET_X, LEVELUP_BUTTON_ICON_OFFSET_Y),
          size=Vec2(LEVELUP_BUTTON_ICON_SIZE, LEVELUP_BUTTON_ICON_SIZE),
        ),
        @ui.ZIndex(PANEL_TEXT_ZINDEX),
        @ui.UiImage(
          Vec2(LEVELUP_BUTTON_ICON_SIZE, LEVELUP_BUTTON_ICON_SIZE),
          POWERUP_RANGE_ICON_PATH,
          fit=Contain,
        ),
      ),
      parent=button,
    )
    runtime.levelup_button_icons.push(icon)
  }

  hide_level_up_ui()
}

///|
fn level_up(level : Int32) -> Unit {
  let runtime = survivors_runtime()
  @time.set_scale(0.0)
  let panel = game_state().level_up_panel

  panel.available_selections = generate_level_up_selections(level)
  show_level_up_ui()

  for i in 0..<3 {
    update_selection_display(
      panel.available_selections[i],
      runtime.levelup_buttons[i],
      runtime.levelup_button_icons[i],
    )
  }
}

///|
fn update_selection_display(
  selection : LevelUpSelection,
  button_entity : @ecs.Entity,
  icon_entity : @ecs.Entity,
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
fn select_powerup(index : Int32) -> Unit {
  let panel = game_state().level_up_panel
  if index < panel.available_selections.length() {
    let selection = panel.available_selections[index]
    apply_selection(selection)
  }
  resume_game()
}

///|
fn resume_game() -> Unit {
  hide_level_up_ui()

  if game_state().pending_level_ups.is_empty() {
    @time.set_scale(1.0)
  } else {
    process_next_level_up()
  }
}

///|
fn setup_game_over_ui() -> Unit {
  let runtime = survivors_runtime()
  let title = spawn_text_entity(
    game_over_panel_origin() + Vec2(10.0, 18.0),
    "VICTORY!",
    "gold",
    "32px ThaleahFat",
    size=Vec2(180.0, 30.0),
    align=Center,
    zindex=PANEL_TEXT_ZINDEX,
  )

  runtime.game_over_title = Some(title)
  let restart_button = spawn_panel_button(
    game_over_panel_origin() + Vec2(10.0, 74.0),
    Vec2(180.0, 40.0),
    "rgba(13, 167, 170, 1)",
    "white",
    "RESTART",
    10,
    font="24px ThaleahFat",
  )
  runtime.restart_button = Some(restart_button)

  hide_game_over_ui()
}

///|
fn add_game_over_box() -> Unit {
  show_game_over_ui()
}

///|
fn survivors_ui_pointer_system(_world : @ecs.World) -> Unit {
  let runtime = survivors_runtime()
  for event in @ui.click_event_bus.read(runtime.ui_click_reader) {
    if runtime.restart_button is Some(restart_button) &&
      event.entity == restart_button {
      restart_game()
      continue
    }
    for index, button in runtime.levelup_buttons {
      if event.entity == button {
        select_powerup(index)
        break
      }
    }
  }
}
