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
/// Constants
const VIEWPORT_WIDTH : Double = 480.0

///|
const VIEWPORT_HEIGHT : Double = 320.0

///|
const SMALL_BLIND : Int = 10

///|
const BIG_BLIND : Int = 20

///|
/// Game phases
enum GamePhase {
  PreFlop
  Flop
  Turn
  River
  Showdown
  GameOver
} derive(Eq)

///|
/// Player information
priv struct Player {
  mut chips : Int
  hole_cards : Array[Card]
  mut current_bet : Int
  mut has_folded : Bool
  position : @math.Vec2D // Position for display
}

///|
/// Game state
priv struct GameState {
  rand : @random.Rand
  mut deck : Array[Card]
  player : Player // Single player
  mut phase : GamePhase
  mut current_bet : Int // Current bet to match
  community_cards : Array[Card]
  mut hand_number : Int
  mut small_blind : Int
  mut big_blind : Int
  mut turns_remaining : Int // 10 turns total
  starting_chips : Int // Track starting amount
  mut magnification : Int // Payout multiplier, starts at 1, increases with raises
  // UI elements
  blind_label : @entity.Entity // Display current blind
  chips_label : @entity.Entity
  phase_label : @entity.Entity
  fold_button_label : @entity.Entity
  call_button_label : @entity.Entity
  raise_button_label : @entity.Entity
  turns_label : @entity.Entity
  action_label : @entity.Entity // Last action feedback
  hand_strength_label : @entity.Entity // Current hand strength
  fold_button : @entity.Entity
  call_button : @entity.Entity
  raise_button : @entity.Entity
  mut waiting_for_player : Bool
  // Card entities for cleanup
  hole_card_entities : Array[@entity.Entity]
  community_card_entities : Array[@entity.Entity]
}

///|
/// Global game state
let game_state : GameState = {
  rand: @random.Rand::new(),
  deck: [],
  player: {
    chips: 1000,
    hole_cards: [],
    current_bet: 0,
    has_folded: false,
    position: @math.Vec2D(VIEWPORT_WIDTH / 2.0, VIEWPORT_HEIGHT - 80.0),
  },
  phase: PreFlop,
  current_bet: 0,
  community_cards: [],
  hand_number: 0,
  small_blind: SMALL_BLIND,
  big_blind: BIG_BLIND,
  turns_remaining: 10,
  starting_chips: 1000,
  magnification: 1,
  blind_label: @entity.Entity::new(),
  chips_label: @entity.Entity::new(),
  phase_label: @entity.Entity::new(),
  fold_button_label: @entity.Entity::new(),
  call_button_label: @entity.Entity::new(),
  raise_button_label: @entity.Entity::new(),
  turns_label: @entity.Entity::new(),
  action_label: @entity.Entity::new(),
  hand_strength_label: @entity.Entity::new(),
  fold_button: @entity.Entity::new(),
  call_button: @entity.Entity::new(),
  raise_button: @entity.Entity::new(),
  waiting_for_player: false,
  hole_card_entities: [],
  community_card_entities: [],
}
