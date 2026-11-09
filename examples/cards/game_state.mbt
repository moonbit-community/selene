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
const SMALL_BLIND : Int32 = 10

///|
const BIG_BLIND : Int32 = 20

///|
/// Game phases
#derive(Eq)
enum GamePhase {
  PreFlop
  Flop
  Turn
  River
  Showdown
  GameOver
}

///|
/// Player information
priv struct Player {
  mut chips : Int32
  hole_cards : Array[Card]
  mut current_bet : Int32
  mut has_folded : Bool
  position : @math.Vec2 // Position for display
}

///|
/// Game state
priv struct GameState {
  rand : @random.Rand
  mut deck : Array[Card]
  player : Player // Single player
  mut phase : GamePhase
  mut current_bet : Int32 // Current bet to match
  community_cards : Array[Card]
  mut hand_number : Int32
  mut small_blind : Int32
  mut big_blind : Int32
  mut turns_remaining : Int32 // 10 turns total
  starting_chips : Int32 // Track starting amount
  mut magnification : Int32 // Payout multiplier, starts at 1, increases with raises
  // UI elements
  blind_label : @ecs.Entity // Display current blind
  chips_label : @ecs.Entity
  phase_label : @ecs.Entity
  fold_button_label : @ecs.Entity
  call_button_label : @ecs.Entity
  raise_button_label : @ecs.Entity
  turns_label : @ecs.Entity
  action_label : @ecs.Entity // Last action feedback
  hand_strength_label : @ecs.Entity // Current hand strength
  fold_button : @ecs.Entity
  call_button : @ecs.Entity
  raise_button : @ecs.Entity
  mut waiting_for_player : Bool
  // Card entities for cleanup
  hole_card_entities : Array[@ecs.Entity]
  community_card_entities : Array[@ecs.Entity]
}

///|
#selene.resource
priv struct CardsRuntime {
  entities : Array[@ecs.Entity]
  mut game : GameState?
  click_reader : @event.EventReader[@ui.UiClickEvent]
}

///|
fn new_cards_runtime() -> CardsRuntime {
  { entities: [], game: None, click_reader: EventReader(), }
}

///|
fn cards_runtime() -> CardsRuntime {
  @ecs.require_current_world().resource()
}

///|
fn spawn_cards_entity() -> @ecs.Entity {
  let entity = @ecs.Entity()
  cards_runtime().entities.push(entity)
  entity
}

///|
fn reset_cards_runtime() -> Unit {
  let world = @ecs.require_current_world()
  let previous : CardsRuntime? = world.get_resource()
  if previous is Some(state) {
    for entity in state.entities {
      ignore(entity.delete())
    }
  }
  world.insert_resource(new_cards_runtime())
}

///|
fn game_state() -> GameState {
  let runtime = cards_runtime()
  if runtime.game is Some(state) {
    return state
  }
  let state = new_game_state()
  runtime.game = Some(state)
  state
}

///|
fn new_game_state() -> GameState {
  {
    rand: Rand(),
    deck: [],
    player: {
      chips: 1000,
      hole_cards: [],
      current_bet: 0,
      has_folded: false,
      position: Vec2(VIEWPORT_WIDTH / 2.0, VIEWPORT_HEIGHT - 80.0),
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
    blind_label: spawn_cards_entity(),
    chips_label: spawn_cards_entity(),
    phase_label: spawn_cards_entity(),
    fold_button_label: spawn_cards_entity(),
    call_button_label: spawn_cards_entity(),
    raise_button_label: spawn_cards_entity(),
    turns_label: spawn_cards_entity(),
    action_label: spawn_cards_entity(),
    hand_strength_label: spawn_cards_entity(),
    fold_button: spawn_cards_entity(),
    call_button: spawn_cards_entity(),
    raise_button: spawn_cards_entity(),
    waiting_for_player: false,
    hole_card_entities: [],
    community_card_entities: [],
  }
}
