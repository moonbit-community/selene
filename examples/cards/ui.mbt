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
const HUD_ZINDEX : Int = 100

///|
const BUTTON_ZINDEX : Int = 110

///|
const BUTTON_LABEL_ZINDEX : Int = 111

///|
let ui_click_reader : @event.EventReader[@ui.UiClickEvent] = @event.EventReader::new()

///|
fn set_text(entity : @entity.Entity, content : String) -> Unit {
  let text = @ui.texts().get_or_init(entity, fn() { @ui.Text::new(content) })
  text.content = content
}

///|
fn with_display(node : @ui.Node, display : @ui.Display) -> @ui.Node {
  @ui.Node::new(
    width=node.width,
    height=node.height,
    min_width=node.min_width,
    min_height=node.min_height,
    max_width=node.max_width,
    max_height=node.max_height,
    left=node.left,
    right=node.right,
    top=node.top,
    bottom=node.bottom,
    margin=node.margin,
    padding=node.padding,
    border=node.border,
    display~,
    position_type=node.position_type,
    flex_direction=node.flex_direction,
    justify_content=node.justify_content,
    align_items=node.align_items,
    row_gap=node.row_gap,
    column_gap=node.column_gap,
    overflow_x=node.overflow_x,
    overflow_y=node.overflow_y,
    flex_grow=node.flex_grow,
    flex_shrink=node.flex_shrink,
    active=node.active,
  )
}

///|
fn set_display(entity : @entity.Entity, display : @ui.Display) -> Unit {
  match @ui.nodes().get(entity) {
    Some(node) => @ui.nodes().set(entity, with_display(node, display))
    None => @ui.nodes().set(entity, @ui.Node::new(display~))
  }
}

///|
fn configure_text(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  content : String,
  color : String,
  font : String,
  size? : @math.Vec2D = @math.Vec2D(-1.0, -1.0),
  align? : @math.HAlign = @math.HAlign::Left,
  baseline? : @math.VAlign = @math.VAlign::Top,
  zindex? : Int = HUD_ZINDEX,
) -> Unit {
  @ui.nodes().set(entity, @ui.Node::absolute(offset, size~))
  @ui.z_indexes().set(entity, @ui.ZIndex::new(zindex))
  set_text(entity, content)
  @ui.text_fonts().set(entity, @ui.TextFont::from_css(font))
  @ui.text_colors().set(entity, @ui.TextColor::from_css(color))
  @ui.text_layouts().set(entity, @ui.TextLayout::new(align~, baseline~))
}

///|
fn configure_button(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  size : @math.Vec2D,
  background : String,
  tab_index : Int,
) -> Unit {
  @ui.nodes().set(entity, @ui.Node::absolute(offset, size~))
  @ui.z_indexes().set(entity, @ui.ZIndex::new(BUTTON_ZINDEX))
  @ui.background_colors().set(entity, @ui.BackgroundColor::from_css(background))
  @ui.border_radii().set(entity, @ui.BorderRadius::all(@ui.Val::px(6.0)))
  @ui.buttons().set(entity, @ui.Button::new())
  @ui.tab_indexes().set(entity, @ui.TabIndex::new(tab_index))
}

///|
/// Setup UI elements
fn setup_ui() -> Unit {
  let table_entity = @entity.Entity::new()
  @transform.transforms().set(
    table_entity,
    @transform.Transform::from_xyz(0.0, 0.0, 0.0),
  )
  @sprite.sprites().set(
    table_entity,
    @sprite.Sprite::new(
      color=@sprite.color_from_css("#2d5016"),
      custom_size=Some(@math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)),
      anchor=@sprite.Anchor(@math.Vec2D(-0.5, 0.5)),
    ),
  )

  configure_text(
    game_state.blind_label,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 80.0, 20.0),
    "Blind: $20",
    "gold",
    "20px ThaleahFat",
    size=@math.Vec2D(160.0, 24.0),
    align=@math.HAlign::Center,
  )
  configure_text(
    game_state.chips_label,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 80.0, 42.0),
    "Chips: $1000",
    "lightgreen",
    "18px ThaleahFat",
    size=@math.Vec2D(160.0, 22.0),
    align=@math.HAlign::Center,
  )
  configure_text(
    game_state.phase_label,
    @math.Vec2D(20.0, 20.0),
    "Pre-Flop",
    "white",
    "18px ThaleahFat",
  )
  configure_text(
    game_state.turns_label,
    @math.Vec2D(VIEWPORT_WIDTH - 110.0, 20.0),
    "Turns: 10/10",
    "white",
    "18px ThaleahFat",
    size=@math.Vec2D(90.0, 22.0),
    align=@math.HAlign::Right,
  )
  configure_text(
    game_state.hand_strength_label,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 100.0, VIEWPORT_HEIGHT / 2.0 - 82.0),
    "",
    "cyan",
    "16px ThaleahFat",
    size=@math.Vec2D(200.0, 20.0),
    align=@math.HAlign::Center,
  )
  configure_text(
    game_state.action_label,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 110.0, VIEWPORT_HEIGHT - 64.0),
    "",
    "yellow",
    "16px ThaleahFat",
    size=@math.Vec2D(220.0, 20.0),
    align=@math.HAlign::Center,
  )

  create_action_buttons()
}

///|
/// Create action buttons for player
fn create_action_buttons() -> Unit {
  let button_y = VIEWPORT_HEIGHT - 35.0
  let button_width = 70.0
  let button_height = 25.0
  let button_size = @math.Vec2D(button_width, button_height)
  let fold_offset = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0 - 85.0 - button_width / 2.0,
    button_y,
  )
  let call_offset = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0 - button_width / 2.0,
    button_y,
  )
  let raise_offset = @math.Vec2D(
    VIEWPORT_WIDTH / 2.0 + 85.0 - button_width / 2.0,
    button_y,
  )

  configure_button(
    game_state.fold_button,
    fold_offset,
    button_size,
    "#cc0000",
    0,
  )
  configure_text(
    game_state.fold_button_label,
    fold_offset,
    "Fold",
    "white",
    "16px ThaleahFat",
    size=button_size,
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
    zindex=BUTTON_LABEL_ZINDEX,
  )

  configure_button(
    game_state.call_button,
    call_offset,
    button_size,
    "#00aa00",
    1,
  )
  configure_text(
    game_state.call_button_label,
    call_offset,
    "Call",
    "white",
    "16px ThaleahFat",
    size=button_size,
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
    zindex=BUTTON_LABEL_ZINDEX,
  )

  configure_button(
    game_state.raise_button,
    raise_offset,
    button_size,
    "#0066cc",
    2,
  )
  configure_text(
    game_state.raise_button_label,
    raise_offset,
    "Raise",
    "white",
    "16px ThaleahFat",
    size=button_size,
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
    zindex=BUTTON_LABEL_ZINDEX,
  )

  hide_action_buttons()
}

///|
/// Show action buttons
fn show_action_buttons() -> Unit {
  game_state.waiting_for_player = true
  let show_fold_and_raise = game_state.phase != River
  set_display(game_state.call_button, @ui.Display::Flex)
  set_display(game_state.call_button_label, @ui.Display::Flex)
  set_display(
    game_state.fold_button,
    if show_fold_and_raise {
      @ui.Display::Flex
    } else {
      @ui.Display::None
    },
  )
  set_display(
    game_state.fold_button_label,
    if show_fold_and_raise {
      @ui.Display::Flex
    } else {
      @ui.Display::None
    },
  )
  set_display(
    game_state.raise_button,
    if show_fold_and_raise {
      @ui.Display::Flex
    } else {
      @ui.Display::None
    },
  )
  set_display(
    game_state.raise_button_label,
    if show_fold_and_raise {
      @ui.Display::Flex
    } else {
      @ui.Display::None
    },
  )

  let call_amount = game_state.current_bet - game_state.player.current_bet
  if call_amount == 0 {
    set_text(game_state.call_button_label, "Check")
  } else {
    set_text(game_state.call_button_label, "Call $" + call_amount.to_string())
  }
}

///|
/// Hide action buttons
fn hide_action_buttons() -> Unit {
  game_state.waiting_for_player = false
  for
    entity in [
      game_state.fold_button,
      game_state.fold_button_label,
      game_state.call_button,
      game_state.call_button_label,
      game_state.raise_button,
      game_state.raise_button_label,
    ] {
    set_display(entity, @ui.Display::None)
  }
}

///|
/// Handle fold button click
fn on_fold_click() -> Unit {
  let human = game_state.player
  human.has_folded = true
  set_text(game_state.action_label, "You folded")
  hide_action_buttons()
  game_state.phase = Showdown
}

///|
/// Handle call button click
fn on_call_click() -> Unit {
  let human = game_state.player
  let call_amount = game_state.current_bet - human.current_bet
  let actual_amount = call_amount.min(human.chips)
  human.chips -= actual_amount
  human.current_bet += actual_amount
  if human.chips == 0 {
    set_text(game_state.action_label, "You went All-In!")
  } else if call_amount == 0 {
    set_text(game_state.action_label, "You checked")
  } else {
    set_text(
      game_state.action_label,
      "You called $" + actual_amount.to_string(),
    )
  }
  hide_action_buttons()
  advance_to_next_phase()
  update_ui()
}

///|
/// Handle raise button click
fn on_raise_click() -> Unit {
  let human = game_state.player
  let min_raise = game_state.big_blind
  let raise_amount = min_raise.min(human.chips)
  human.chips -= raise_amount
  human.current_bet += raise_amount
  game_state.current_bet = human.current_bet
  game_state.magnification += 1
  if human.chips == 0 {
    set_text(game_state.action_label, "You went All-In!")
  } else {
    set_text(game_state.action_label, "You raised $" + raise_amount.to_string())
  }
  hide_action_buttons()
  advance_to_next_phase()
  update_ui()
}

///|
fn cards_ui_pointer_system(_world : @ecs.World) -> Unit {
  for event in @ui.click_event_bus.read(ui_click_reader) {
    if event.entity == game_state.fold_button {
      on_fold_click()
      continue
    }
    if event.entity == game_state.call_button {
      on_call_click()
      continue
    }
    if event.entity == game_state.raise_button {
      on_raise_click()
      continue
    }
  }
}

///|
/// Display all players' cards
fn display_all_cards() -> Unit {
  for entity in game_state.hole_card_entities {
    entity.destroy()
  }
  game_state.hole_card_entities.clear()
  for entity in game_state.community_card_entities {
    entity.destroy()
  }
  game_state.community_card_entities.clear()

  let player = game_state.player
  let pos = player.position
  let x_base = pos.0
  let y_base = pos.1 - 40.0

  for j, card in player.hole_cards {
    let card_x = x_base + (j.to_double() - 0.5) * 30.0 - 30
    let card_entity = @entity.Entity::new()
    @transform.transforms().set(
      card_entity,
      @transform.Transform::from_xyz(card_x, y_base, j.to_double()),
    )
    @sprite.sprites().set(card_entity, card.to_sprite())
    game_state.hole_card_entities.push(card_entity)
  }

  display_community_cards()
}

///|
/// Display community cards
fn display_community_cards() -> Unit {
  for entity in game_state.community_card_entities {
    entity.destroy()
  }
  game_state.community_card_entities.clear()
  let center_x = VIEWPORT_WIDTH / 2.0
  let center_y = VIEWPORT_HEIGHT / 2.0 - 60.0
  for i, card in game_state.community_cards {
    let card_x = center_x + (i.to_double() - 2.5) * 30.0 - 15
    let card_entity = @entity.Entity::new()
    @transform.transforms().set(
      card_entity,
      @transform.Transform::from_xyz(card_x, center_y, (10 + i).to_double()),
    )
    @sprite.sprites().set(card_entity, card.to_sprite())
    game_state.community_card_entities.push(card_entity)
  }
}

///|
/// Update UI displays
fn update_ui() -> Unit {
  set_text(
    game_state.blind_label,
    "Blind: $" + game_state.big_blind.to_string(),
  )
  set_text(
    game_state.chips_label,
    "Chips: $" + game_state.player.chips.to_string(),
  )
  set_text(
    game_state.phase_label,
    match game_state.phase {
      PreFlop => "Pre-Flop"
      Flop => "Flop"
      Turn => "Turn"
      River => "River"
      Showdown => "Showdown"
      GameOver => "GAME OVER"
    },
  )
  set_text(
    game_state.turns_label,
    "Turns: " + game_state.turns_remaining.to_string() + "/10",
  )

  update_hand_strength()

  if game_state.phase == GameOver {
    let player = game_state.player
    let profit = player.chips - game_state.starting_chips
    let profit_text = if profit >= 0 {
      "Profit: +$" + profit.to_string()
    } else {
      "Loss: $" + profit.to_string()
    }
    set_text(game_state.hand_strength_label, profit_text)
  }
}

///|
/// Update hand strength display based on current cards
fn update_hand_strength() -> Unit {
  let player = game_state.player

  if player.hole_cards.length() + game_state.community_cards.length() < 5 {
    set_text(game_state.hand_strength_label, "")
    return
  }

  let hand = []
  for card in player.hole_cards {
    hand.push(card)
  }
  for card in game_state.community_cards {
    hand.push(card)
  }

  if hand.length() >= 5 {
    let rank = find_best_hand(hand)
    let hand_name = rank.hand_rank_to_string()
    let magnification = game_state.magnification
    set_text(
      game_state.hand_strength_label,
      "Hand: " + hand_name + " x " + magnification.to_string(),
    )
  }
}
