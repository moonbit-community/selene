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
fn start_new_hand(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let player = game.player

  // Check if player has run out of chips (loses)
  if player.chips <= 0 {
    game.phase = GameOver
    update_ui(ctx~)
    return
  }

  // Check if game is over (no turns remaining)
  if game.turns_remaining <= 0 {
    game.phase = GameOver
    update_ui(ctx~)
    return
  }

  // Check if player can afford the blind
  if player.chips < game.big_blind {
    // Not enough chips for the blind - game over
    game.phase = GameOver
    update_ui(ctx~)
    return
  }
  game.hand_number += 1
  game.phase = PreFlop
  game.current_bet = game.big_blind
  game.community_cards.clear()
  set_text(ctx~, game.action_label, "")
  game.magnification = 1 // Reset magnification to 1 for new hand

  // Update blinds every 10 hands
  if game.hand_number % 10 == 1 && game.hand_number > 1 {
    game.small_blind = game.small_blind * 2
    game.big_blind = game.big_blind * 2
  }

  // Reset player
  player.hole_cards.clear()
  player.current_bet = game.big_blind
  player.has_folded = false

  // Deduct big blind from player chips
  let blind_amount = game.big_blind.min(player.chips)
  player.chips -= blind_amount

  // Create and shuffle deck
  game.deck = create_deck()
  shuffle_deck(game.deck, game.rand)

  // Deal hole cards
  deal_hole_cards(ctx~)
  update_ui(ctx~)
}

///|
/// Deal 2 hole cards to player
fn deal_hole_cards(ctx~ : CardsGame) -> Unit {
  for _ in 0..<2 {
    match ctx.game().deck.pop() {
      Some(card) => ctx.game().player.hole_cards.push(card)
      None => ()
    }
  }
  // Display cards after dealing
  display_all_cards(ctx~)
}

///|
/// Handle a betting round - single player just chooses action
fn handle_betting_round(ctx~ : CardsGame) -> Unit {
  // Show buttons for player to make choice
  if !ctx.game().waiting_for_player {
    show_action_buttons(ctx~)
  }
}

///|
/// Advance to next game phase
fn advance_to_next_phase(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  match game.phase {
    PreFlop => {
      // Deal flop (3 cards)
      for _ in 0..<3 {
        match ctx.game().deck.pop() {
          Some(card) => game.community_cards.push(card)
          None => ()
        }
      }
      game.phase = Flop
      reset_betting_round(ctx~)
      display_community_cards(ctx~)
    }
    Flop => {
      // Deal turn (1 card)
      match ctx.game().deck.pop() {
        Some(card) => game.community_cards.push(card)
        None => ()
      }
      game.phase = Turn
      reset_betting_round(ctx~)
      display_community_cards(ctx~)
    }
    Turn => {
      // Deal river (1 card)
      match ctx.game().deck.pop() {
        Some(card) => game.community_cards.push(card)
        None => ()
      }
      game.phase = River
      reset_betting_round(ctx~)
      display_community_cards(ctx~)
    }
    River => game.phase = Showdown
    _ => ()
  }
  update_ui(ctx~)
}

///|
/// Reset betting for new round
fn reset_betting_round(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  game.current_bet = 0
  game.player.current_bet = 0
}

///|
/// Handle showdown phase
fn handle_showdown(ctx~ : CardsGame) -> Unit {
  let game = ctx.game()
  let player = game.player
  if !player.has_folded {
    // Evaluate player's hand
    let hand = []
    for card in player.hole_cards {
      hand.push(card)
    }
    for card in game.community_cards {
      hand.push(card)
    }

    // Evaluate best 5-card hand from all 7 available cards
    if hand.length() >= 5 {
      let rank = find_best_hand(hand)

      // Calculate payout based on hand rank
      let base_award = hand_rank_base_award(rank)
      let magnification = game.magnification
      let payout = base_award * magnification

      // Award payout to player
      player.chips += payout
    }

    // Decrease turns remaining only if didn't fold
    game.turns_remaining -= 1
  }
  update_ui(ctx~)

  // Small delay before next hand
  // For now, just start next hand immediately
  start_new_hand(ctx~)
}
