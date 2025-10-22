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
/// Start a new hand
fn start_new_hand() -> Unit {
  let player = game_state.player

  // Check if player has run out of chips (loses)
  if player.chips <= 0 {
    game_state.phase = GameOver
    update_ui()
    return
  }

  // Check if game is over (no turns remaining)
  if game_state.turns_remaining <= 0 {
    game_state.phase = GameOver
    update_ui()
    return
  }

  // Check if player can afford the blind
  if player.chips < game_state.big_blind {
    // Not enough chips for the blind - game over
    game_state.phase = GameOver
    update_ui()
    return
  }

  game_state.hand_number += 1
  game_state.phase = PreFlop
  game_state.current_bet = game_state.big_blind
  game_state.community_cards.clear()
  game_state.action_text.content = "" // Clear previous action
  game_state.magnification = 1 // Reset magnification to 1 for new hand

  // Update blinds every 10 hands
  if game_state.hand_number % 10 == 1 && game_state.hand_number > 1 {
    game_state.small_blind = game_state.small_blind * 2
    game_state.big_blind = game_state.big_blind * 2
  }

  // Reset player
  player.hole_cards.clear()
  player.current_bet = game_state.big_blind
  player.has_folded = false
  player.is_all_in = false

  // Deduct big blind from player chips
  let blind_amount = game_state.big_blind.min(player.chips)
  player.chips -= blind_amount
  game_state.pot = blind_amount

  // Create and shuffle deck
  game_state.deck = create_deck()
  shuffle_deck(game_state.deck, game_state.rand)

  // Deal hole cards
  deal_hole_cards()
  update_ui()
}

///|
/// Deal 2 hole cards to player
fn deal_hole_cards() -> Unit {
  for _ in 0..<2 {
    match deal_card() {
      Some(card) => game_state.player.hole_cards.push(card)
      None => ()
    }
  }
  // Display cards after dealing
  display_all_cards()
}

///|
/// Handle a betting round - single player just chooses action
fn handle_betting_round() -> Unit {
  // Show buttons for player to make choice
  if not(game_state.waiting_for_player) {
    show_action_buttons()
  }
}

///|
/// Advance to next game phase
fn advance_to_next_phase() -> Unit {
  match game_state.phase {
    PreFlop => {
      // Deal flop (3 cards)
      for _ in 0..<3 {
        match deal_card() {
          Some(card) => game_state.community_cards.push(card)
          None => ()
        }
      }
      game_state.phase = Flop
      reset_betting_round()
      display_community_cards()
    }
    Flop => {
      // Deal turn (1 card)
      match deal_card() {
        Some(card) => game_state.community_cards.push(card)
        None => ()
      }
      game_state.phase = Turn
      reset_betting_round()
      display_community_cards()
    }
    Turn => {
      // Deal river (1 card)
      match deal_card() {
        Some(card) => game_state.community_cards.push(card)
        None => ()
      }
      game_state.phase = River
      reset_betting_round()
      display_community_cards()
    }
    River => game_state.phase = Showdown
    _ => ()
  }
  update_ui()
}

///|
/// Reset betting for new round
fn reset_betting_round() -> Unit {
  game_state.current_bet = 0
  game_state.player.current_bet = 0
}

///|
/// Handle showdown phase
fn handle_showdown() -> Unit {
  let player = game_state.player
  if player.has_folded {
    // Player folded - lose the pot, but don't count as a turn used
    game_state.pot = 0
    game_state.best_hand_name = "Folded"
    // Don't decrease turns_remaining when folding
  } else {
    // Evaluate player's hand
    let hand = []
    for card in player.hole_cards {
      hand.push(card)
    }
    for card in game_state.community_cards {
      hand.push(card)
    }

    // Evaluate best 5-card hand from all 7 available cards
    if hand.length() >= 5 {
      let rank = find_best_hand(hand)
      game_state.best_hand_name = rank.hand_rank_to_string()

      // Calculate payout based on hand rank
      let base_award = hand_rank_base_award(rank)
      let magnification = game_state.magnification
      let payout = base_award * magnification

      // Award payout to player
      player.chips += payout
      game_state.pot = 0
    } else {
      game_state.best_hand_name = "Incomplete Hand"
      game_state.pot = 0
    }

    // Decrease turns remaining only if didn't fold
    game_state.turns_remaining -= 1
  }
  update_ui()

  // Small delay before next hand
  // For now, just start next hand immediately
  start_new_hand()
}

