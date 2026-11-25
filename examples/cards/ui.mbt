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
const HUD_ZINDEX : Int32 = 100

///|
const BUTTON_ZINDEX : Int32 = 110

///|
const BUTTON_LABEL_ZINDEX : Int32 = 111

///|
priv enum TouchAction {
  TouchFold
  TouchCall
  TouchRaise
}

///|
fn set_text(ctx~ : CardsGame, entity : @ecs.Entity, content : String) -> Unit {
  guard ctx.texts.get(entity) is Some(Single(text)) else { return }
  text.content = content
}

///|
fn set_display(
  ctx~ : CardsGame,
  entity : @ecs.Entity,
  display : @ui.Display,
) -> Unit {
  match ctx.nodes.get(entity) {
    Some(Single(node)) => ctx.nodes.set(entity, Single({ ..node, display, }))
    None => ()
  }
}

///|
fn spawn_text(
  offset : @math.Vec2,
  content : String,
  color : String,
  font : String,
  size~ : @math.Vec2 = Vec2(-1.0, -1.0),
  align~ : @render2d_types.HAlign = Left,
  baseline~ : @render2d_types.VAlign = Top,
  zindex~ : Int32 = HUD_ZINDEX,
) -> @ecs.Entity {
  spawn_cards_entity(
    (
      @ui.Node::absolute(offset, size~),
      @ui.ZIndex(zindex),
      @ui.Text(content),
      game_text_font(font),
      @ui.TextColor::from_css(color),
      @ui.TextLayout(align~, baseline~),
    ),
  )
}

///|
fn spawn_button(
  offset : @math.Vec2,
  size : @math.Vec2,
  background : String,
  tab_index : Int32,
) -> @ecs.Entity {
  spawn_cards_entity(
    (
      @ui.Node::absolute(offset, size~),
      @ui.ZIndex(BUTTON_ZINDEX),
      @ui.BackgroundColor::from_css(background),
      @ui.BorderRadius::all(@ui.Val::px(6.0)),
      @ui.Button(),
      @ui.TabIndex(tab_index),
    ),
  )
}

///|
/// Setup UI elements
fn setup_ui(ctx~ : CardsGame) -> Unit {
  ignore(
    ctx.spawn(
      (
        @transform.Spatial(@transform.Transform::from_xyz(0.0, 0.0, 0.0)),
        @sprite.Sprite(
          color=@sprite.color_from_css("#2d5016"),
          custom_size=Some(Vec2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)),
          anchor=Anchor(Vec2(-0.5, 0.5)),
        ),
      ),
    ),
  )

  ctx.commands.add(_ => hide_action_buttons(ctx~))
}

///|
/// Show action buttons
fn show_action_buttons(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  game.waiting_for_player = true
  let show_fold_and_raise = game.phase != River
  set_display(ctx~, game.call_button, Flex)
  set_display(ctx~, game.call_button_label, Flex)
  set_display(
    ctx~,
    game.fold_button,
    if show_fold_and_raise {
      Flex
    } else {
      None
    },
  )
  set_display(
    ctx~,
    game.fold_button_label,
    if show_fold_and_raise {
      Flex
    } else {
      None
    },
  )
  set_display(
    ctx~,
    game.raise_button,
    if show_fold_and_raise {
      Flex
    } else {
      None
    },
  )
  set_display(
    ctx~,
    game.raise_button_label,
    if show_fold_and_raise {
      Flex
    } else {
      None
    },
  )

  let call_amount = game.current_bet - game.player.current_bet
  if call_amount == 0 {
    set_text(ctx~, game.call_button_label, "Check")
  } else {
    set_text(ctx~, game.call_button_label, "Call $" + call_amount.to_string())
  }
}

///|
/// Hide action buttons
fn hide_action_buttons(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  game.waiting_for_player = false
  for
    entity in [
      game.fold_button,
      game.fold_button_label,
      game.call_button,
      game.call_button_label,
      game.raise_button,
      game.raise_button_label,
    ] {
    set_display(ctx~, entity, None)
  }
}

///|
/// Handle fold button click
fn on_fold_click(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let human = game.player
  human.has_folded = true
  set_text(ctx~, game.action_label, "You folded")
  hide_action_buttons(ctx~)
  game.phase = Showdown
}

///|
/// Handle call button click
fn on_call_click(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let human = game.player
  let call_amount = game.current_bet - human.current_bet
  let actual_amount = call_amount.min(human.chips)
  human.chips -= actual_amount
  human.current_bet += actual_amount
  if human.chips == 0 {
    set_text(ctx~, game.action_label, "You went All-In!")
  } else if call_amount == 0 {
    set_text(ctx~, game.action_label, "You checked")
  } else {
    set_text(
      ctx~,
      game.action_label,
      "You called $" + actual_amount.to_string(),
    )
  }
  hide_action_buttons(ctx~)
  advance_to_next_phase(ctx~)
  update_ui(ctx~)
}

///|
/// Handle raise button click
fn on_raise_click(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let human = game.player
  let min_raise = game.big_blind
  let raise_amount = min_raise.min(human.chips)
  human.chips -= raise_amount
  human.current_bet += raise_amount
  game.current_bet = human.current_bet
  game.magnification += 1
  if human.chips == 0 {
    set_text(ctx~, game.action_label, "You went All-In!")
  } else {
    set_text(ctx~, game.action_label, "You raised $" + raise_amount.to_string())
  }
  hide_action_buttons(ctx~)
  advance_to_next_phase(ctx~)
  update_ui(ctx~)
}

///|
fn touch_action_at(position : @math.Vec2, screen : @math.Vec2) -> TouchAction? {
  if position.y < screen.y * 0.72 {
    return None
  }
  if position.x < screen.x / 3.0 {
    Some(TouchFold)
  } else if position.x < screen.x * 2.0 / 3.0 {
    Some(TouchCall)
  } else {
    Some(TouchRaise)
  }
}

///|
fn apply_touch_action(ctx~ : CardsGame, action : TouchAction) -> Unit {
  let game = ctx.game()
  match action {
    TouchFold => if game.phase != River { on_fold_click(ctx~) }
    TouchCall => on_call_click(ctx~)
    TouchRaise => if game.phase != River { on_raise_click(ctx~) }
  }
}

///|
fn handle_cards_touch_shortcuts(ctx~ : CardsGame) -> Bool {
  if !ctx.game().waiting_for_player {
    return false
  }
  let screen = ctx.display.screen_size()
  for event in ctx.consumption.unconsumed_touch_changes() {
    if event.primary && event.phase == Ended {
      match touch_action_at(event.position, screen) {
        Some(action) => {
          apply_touch_action(ctx~, action)
          return true
        }
        None => ()
      }
    }
  }
  false
}

///|
fn cards_ui_pointer_system(ctx : CardsGame) -> Unit {
  let game = ctx.game()
  let mut handled_ui_click = false
  for event in ctx.clicks.read() {
    if event.entity == game.fold_button {
      on_fold_click(ctx~)
      handled_ui_click = true
      continue
    }
    if event.entity == game.call_button {
      on_call_click(ctx~)
      handled_ui_click = true
      continue
    }
    if event.entity == game.raise_button {
      on_raise_click(ctx~)
      handled_ui_click = true
      continue
    }
  }
  if !handled_ui_click {
    ignore(handle_cards_touch_shortcuts(ctx~))
  }
}

///|
/// Display all players' cards
fn display_all_cards(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  for entity in game.hole_card_entities {
    ctx.commands.despawn(entity)
  }
  game.hole_card_entities.clear()
  for entity in game.community_card_entities {
    ctx.commands.despawn(entity)
  }
  game.community_card_entities.clear()

  let player = game.player
  let pos = player.position
  let x_base = pos.x
  let y_base = pos.y - 40.0

  let plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)] = ctx.commands.prepare_spawn()
  for j, card in player.hole_cards {
    let card_x = x_base + (j.to_double() - 0.5) * 30.0 - 30
    let card_entity = ctx.commands.spawn_prepared(
      plan,
      (
        Spatial(@transform.Transform::from_xyz(card_x, y_base, j.to_double())),
        card.to_sprite(),
      ),
    )
    ctx.runtime.entities.push(card_entity)
    game.hole_card_entities.push(card_entity)
  }

  display_community_cards(ctx~)
}

///|
/// Display community cards
fn display_community_cards(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  for entity in game.community_card_entities {
    ctx.commands.despawn(entity)
  }
  game.community_card_entities.clear()
  let center_x = VIEWPORT_WIDTH / 2.0
  let center_y = VIEWPORT_HEIGHT / 2.0 - 60.0
  let plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)] = ctx.commands.prepare_spawn()
  for i, card in game.community_cards {
    let card_x = center_x + (i.to_double() - 2.5) * 30.0 - 15
    let card_entity = ctx.commands.spawn_prepared(
      plan,
      (
        Spatial(
          @transform.Transform::from_xyz(card_x, center_y, (10 + i).to_double()),
        ),
        card.to_sprite(),
      ),
    )
    ctx.runtime.entities.push(card_entity)
    game.community_card_entities.push(card_entity)
  }
}

///|
/// Update UI displays
fn update_ui(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  set_text(ctx~, game.blind_label, "Blind: $" + game.big_blind.to_string())
  set_text(ctx~, game.chips_label, "Chips: $" + game.player.chips.to_string())
  set_text(
    ctx~,
    game.phase_label,
    match game.phase {
      PreFlop => "Pre-Flop"
      Flop => "Flop"
      Turn => "Turn"
      River => "River"
      Showdown => "Showdown"
      GameOver => "GAME OVER"
    },
  )
  set_text(
    ctx~,
    game.turns_label,
    "Turns: " + game.turns_remaining.to_string() + "/10",
  )

  update_hand_strength(ctx~)

  if game.phase == GameOver {
    let player = game.player
    let profit = player.chips - game.starting_chips
    let profit_text = if profit >= 0 {
      "Profit: +$" + profit.to_string()
    } else {
      "Loss: $" + profit.to_string()
    }
    set_text(ctx~, game.hand_strength_label, profit_text)
  }
}

///|
/// Update hand strength display based on current cards
fn update_hand_strength(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let player = game.player

  if player.hole_cards.length() + game.community_cards.length() < 5 {
    set_text(ctx~, game.hand_strength_label, "")
    return
  }

  let hand = []
  for card in player.hole_cards {
    hand.push(card)
  }
  for card in game.community_cards {
    hand.push(card)
  }

  if hand.length() >= 5 {
    let rank = find_best_hand(hand)
    let hand_name = rank.hand_rank_to_string()
    let magnification = game.magnification
    set_text(
      ctx~,
      game.hand_strength_label,
      "Hand: " + hand_name + " x " + magnification.to_string(),
    )
  }
}
