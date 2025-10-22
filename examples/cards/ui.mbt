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
/// Setup UI elements
fn setup_ui() -> Unit {
  // Create green poker table background (game entity, not UI)
  let table_entity = @entity.Entity::new()
  @position.positions.set(table_entity, @math.Vec2D(0.0, 0.0))
  @sprite.sprites.set(
    table_entity,
    @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(
        @math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT),
        "#2d5016", // Poker table green
      ),
      0, // Background at z-index 0
    ),
  )

  // Create blind display (center top)
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.blind_text, zindex),
    h_offset=VIEWPORT_WIDTH / 2.0 - 40,
    v_offset=20.0,
  )
  |> ignore

  // Create chips display (under blind)
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.chips_text, zindex),
    h_offset=VIEWPORT_WIDTH / 2.0 - 40,
    v_offset=40.0,
  )
  |> ignore

  // Create phase display (top left)
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.phase_text, zindex),
    h_offset=20.0,
    v_offset=20.0,
  )
  |> ignore

  // Create turns display (top right)
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(game_state.turns_text, zindex),
    h_offset=VIEWPORT_WIDTH - 90.0,
    v_offset=20.0,
  )
  |> ignore

  // Create hand strength display (center, above community cards)
  @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_text(
      game_state.hand_strength_text,
      zindex,
    ),
    h_offset=VIEWPORT_WIDTH / 2.0 - 60.0,
    v_offset=VIEWPORT_HEIGHT / 2.0 - 80.0,
  )
  |> ignore

  // Create action buttons
  create_action_buttons()
}

///|
/// Create action buttons for player
fn create_action_buttons() -> Unit {
  let button_y = VIEWPORT_HEIGHT - 35.0
  let button_width = 70.0
  let button_height = 25.0

  // Fold button
  let fold_button = @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(
        @math.Vec2D(button_width, button_height),
        "#cc0000",
      ),
      zindex,
    ),
    h_offset=VIEWPORT_WIDTH / 2.0 - 85.0 - button_width / 2.0,
    v_offset=button_y,
    shape=@collision.CollisionShape::Rect(
      size=@math.Vec2D(button_width, button_height),
      offset=@math.Vec2D::zero(),
    ),
    on_just_pressed=fn(_button) { on_fold_click() },
  )
  game_state.fold_button = fold_button

  // Fold button text
  @style.add_widget(
    fold_button,
    sprite=zindex => @sprite.Sprite::from_text(
      @sprite.Text::new("Fold", color="white", font="16px ThaleahFat"),
      zindex,
    ),
    h_offset=button_width / 2.0 - 15.0,
    v_offset=button_height / 2.0 - 8.0,
  )
  |> ignore

  // Call button
  let call_button = @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(
        @math.Vec2D(button_width, button_height),
        "#00aa00",
      ),
      zindex,
    ),
    h_offset=VIEWPORT_WIDTH / 2.0 - button_width / 2.0,
    v_offset=button_y,
    shape=@collision.CollisionShape::Rect(
      size=@math.Vec2D(button_width, button_height),
      offset=@math.Vec2D::zero(),
    ),
    on_just_pressed=fn(_button) { on_call_click() },
  )
  game_state.call_button = call_button

  // Call button text
  @style.add_widget(
    call_button,
    sprite=zindex => @sprite.Sprite::from_text(
      game_state.call_button_text,
      zindex,
    ),
    h_offset=button_width / 2.0 - 15.0,
    v_offset=button_height / 2.0 - 8.0,
  )
  |> ignore

  // Raise button
  let raise_button = @style.add_widget(
    @style.screen_root,
    sprite=zindex => @sprite.Sprite::from_color_rect(
      @sprite.ColorRect::new(
        @math.Vec2D(button_width, button_height),
        "#0066cc",
      ),
      zindex,
    ),
    h_offset=VIEWPORT_WIDTH / 2.0 + 85.0 - button_width / 2.0,
    v_offset=button_y,
    shape=@collision.CollisionShape::Rect(
      size=@math.Vec2D(button_width, button_height),
      offset=@math.Vec2D::zero(),
    ),
    on_just_pressed=fn(_button) { on_raise_click() },
  )
  game_state.raise_button = raise_button

  // Raise button text
  @style.add_widget(
    raise_button,
    sprite=zindex => @sprite.Sprite::from_text(
      @sprite.Text::new("Raise", color="white", font="16px ThaleahFat"),
      zindex,
    ),
    h_offset=button_width / 2.0 - 18.0,
    v_offset=button_height / 2.0 - 8.0,
  )
  |> ignore
  hide_action_buttons()
}

///|
/// Show action buttons
fn show_action_buttons() -> Unit {
  game_state.waiting_for_player = true
  // Respawn buttons if they were hidden
  // At River phase, only show Call/Check button (no Fold or Raise)
  if game_state.phase != River {
    game_state.fold_button.respawn()
  }
  game_state.call_button.respawn()
  if game_state.phase != River {
    game_state.raise_button.respawn()
  }
  // Update call button text
  let call_amount = game_state.current_bet - game_state.player.current_bet
  if call_amount == 0 {
    game_state.call_button_text.content = "Check"
  } else {
    game_state.call_button_text.content = "Call $" + call_amount.to_string()
  }
}

///|
/// Hide action buttons
fn hide_action_buttons() -> Unit {
  game_state.waiting_for_player = false
  game_state.fold_button.destroy()
  game_state.call_button.destroy()
  game_state.raise_button.destroy()
}

///|
/// Handle fold button click
fn on_fold_click() -> Unit {
  let human = game_state.player
  human.has_folded = true
  game_state.action_text.content = "You folded"
  hide_action_buttons()
  // Go straight to showdown when folding
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
    game_state.action_text.content = "You went All-In!"
  } else if call_amount == 0 {
    game_state.action_text.content = "You checked"
  } else {
    game_state.action_text.content = "You called $" + actual_amount.to_string()
  }
  hide_action_buttons()
  // Advance to next phase after call/check
  advance_to_next_phase()
  update_ui()
}

///|
/// Handle raise button click
fn on_raise_click() -> Unit {
  let human = game_state.player
  let min_raise = game_state.big_blind // Raise by one blind increment
  let raise_amount = min_raise.min(human.chips)
  human.chips -= raise_amount
  human.current_bet += raise_amount
  game_state.current_bet = human.current_bet
  game_state.magnification += 1 // Increase magnification by 1
  if human.chips == 0 {
    game_state.action_text.content = "You went All-In!"
  } else {
    game_state.action_text.content = "You raised $" + raise_amount.to_string()
  }
  hide_action_buttons()
  // Advance to next phase after raise
  advance_to_next_phase()
  update_ui()
}

///|
/// Display all players' cards
fn display_all_cards() -> Unit {
  // Clean up old card entities
  for entity in game_state.hole_card_entities {
    entity.destroy()
  }
  game_state.hole_card_entities.clear()
  for entity in game_state.community_card_entities {
    entity.destroy()
  }
  game_state.community_card_entities.clear()

  // Display player's hole cards
  let player = game_state.player
  let pos = player.position
  let x_base = pos.0
  let y_base = pos.1 - 40.0 // Move cards up by 40

  // Display hole cards side by side
  for j, card in player.hole_cards {
    let card_x = x_base + (j.to_double() - 0.5) * 30.0 - 30
    let card_entity = @entity.Entity::new()
    @position.positions.set(card_entity, @math.Vec2D(card_x, y_base))
    @sprite.sprites.set(card_entity, card.to_sprite(j))
    game_state.hole_card_entities.push(card_entity)
  }

  // Display community cards in center
  display_community_cards()
}

///|
/// Display community cards
fn display_community_cards() -> Unit {
  // Clean up old community card entities (in case called separately)
  for entity in game_state.community_card_entities {
    entity.destroy()
  }
  game_state.community_card_entities.clear()
  let center_x = VIEWPORT_WIDTH / 2.0
  let center_y = VIEWPORT_HEIGHT / 2.0 - 60.0 // Move cards up by 40
  for i, card in game_state.community_cards {
    let card_x = center_x + (i.to_double() - 2.5) * 30.0 - 15
    let card_entity = @entity.Entity::new()
    @position.positions.set(card_entity, @math.Vec2D(card_x, center_y))
    @sprite.sprites.set(card_entity, card.to_sprite(10 + i))
    game_state.community_card_entities.push(card_entity)
  }
}

///|
/// Update UI displays
fn update_ui() -> Unit {
  game_state.blind_text.content = "Blind: $" + game_state.big_blind.to_string()
  game_state.chips_text.content = "Chips: $" +
    game_state.player.chips.to_string()
  game_state.phase_text.content = match game_state.phase {
    PreFlop => "Pre-Flop"
    Flop => "Flop"
    Turn => "Turn"
    River => "River"
    Showdown => "Showdown"
    GameOver => "GAME OVER"
  }
  game_state.turns_text.content = "Turns: " +
    game_state.turns_remaining.to_string() +
    "/10"

  // Update hand strength display
  update_hand_strength()

  // Show game over info if game is over
  if game_state.phase == GameOver {
    let player = game_state.player
    let profit = player.chips - game_state.starting_chips
    let profit_text = if profit >= 0 {
      "Profit: +$" + profit.to_string()
    } else {
      "Loss: $" + profit.to_string()
    }
    game_state.hand_strength_text.content = profit_text
  }
}

///|
/// Update hand strength display based on current cards
fn update_hand_strength() -> Unit {
  let player = game_state.player

  // Can only evaluate hand if we have at least 5 cards total
  if player.hole_cards.length() + game_state.community_cards.length() < 5 {
    game_state.hand_strength_text.content = ""
    return
  }

  // Build full hand
  let hand = []
  for card in player.hole_cards {
    hand.push(card)
  }
  for card in game_state.community_cards {
    hand.push(card)
  }

  // Evaluate best 5-card hand from all available cards
  if hand.length() >= 5 {
    let rank = find_best_hand(hand)
    let hand_name = rank.hand_rank_to_string()
    let magnification = game_state.magnification
    game_state.hand_strength_text.content = "Hand: " +
      hand_name +
      " × " +
      magnification.to_string()
  }
}
