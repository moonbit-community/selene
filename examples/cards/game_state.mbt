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
pub extend GamePhase with Eq::{not_equal, equal}

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
fn CardsRuntime::CardsRuntime() -> CardsRuntime {
  { entities: [], game: None, click_reader: EventReader(), }
}

///|
fn cards_runtime() -> CardsRuntime {
  @ecs.require_current_world().resource()
}

///|
fn[T : @ecs.Bundle] spawn_cards_entity(values : T) -> @ecs.Entity {
  let entity = @ecs.commands(@ecs.require_current_world()).spawn(values)
  cards_runtime().entities.push(entity)
  entity
}

///|
fn reset_cards_runtime() -> Unit {
  let world = @ecs.require_current_world()
  let previous : CardsRuntime? = world.get_resource()
  if previous is Some(state) {
    for entity in state.entities {
      @ecs.commands(@ecs.require_current_world()).delete(entity)
    }
  }
  world.insert_resource(CardsRuntime())
}

///|
fn game_state() -> GameState {
  let runtime = cards_runtime()
  if runtime.game is Some(state) {
    return state
  }
  let state = GameState()
  runtime.game = Some(state)
  state
}

///|
fn GameState::GameState() -> GameState {
  let button_y = VIEWPORT_HEIGHT - 35.0
  let button_size = @math.Vec2(70.0, 25.0)
  let button_x = VIEWPORT_WIDTH / 2.0 - button_size.x / 2.0
  let fold_offset = @math.Vec2(button_x - 85.0, button_y)
  let call_offset = @math.Vec2(button_x, button_y)
  let raise_offset = @math.Vec2(button_x + 85.0, button_y)
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
    blind_label: spawn_text(
      Vec2(VIEWPORT_WIDTH / 2.0 - 80.0, 20.0),
      "Blind: $20",
      "gold",
      "20px ThaleahFat",
      size=Vec2(160.0, 24.0),
      align=Center,
    ),
    chips_label: spawn_text(
      Vec2(VIEWPORT_WIDTH / 2.0 - 80.0, 42.0),
      "Chips: $1000",
      "lightgreen",
      "18px ThaleahFat",
      size=Vec2(160.0, 22.0),
      align=Center,
    ),
    phase_label: spawn_text(
      Vec2(20.0, 20.0),
      "Pre-Flop",
      "white",
      "18px ThaleahFat",
    ),
    fold_button_label: spawn_text(
      fold_offset,
      "Fold",
      "white",
      "16px ThaleahFat",
      size=button_size,
      align=Center,
      baseline=Center,
      zindex=BUTTON_LABEL_ZINDEX,
    ),
    call_button_label: spawn_text(
      call_offset,
      "Call",
      "white",
      "16px ThaleahFat",
      size=button_size,
      align=Center,
      baseline=Center,
      zindex=BUTTON_LABEL_ZINDEX,
    ),
    raise_button_label: spawn_text(
      raise_offset,
      "Raise",
      "white",
      "16px ThaleahFat",
      size=button_size,
      align=Center,
      baseline=Center,
      zindex=BUTTON_LABEL_ZINDEX,
    ),
    turns_label: spawn_text(
      Vec2(VIEWPORT_WIDTH - 110.0, 20.0),
      "Turns: 10/10",
      "white",
      "18px ThaleahFat",
      size=Vec2(90.0, 22.0),
      align=Right,
    ),
    action_label: spawn_text(
      Vec2(VIEWPORT_WIDTH / 2.0 - 110.0, VIEWPORT_HEIGHT - 64.0),
      "",
      "yellow",
      "16px ThaleahFat",
      size=Vec2(220.0, 20.0),
      align=Center,
    ),
    hand_strength_label: spawn_text(
      Vec2(VIEWPORT_WIDTH / 2.0 - 100.0, VIEWPORT_HEIGHT / 2.0 - 82.0),
      "",
      "cyan",
      "16px ThaleahFat",
      size=Vec2(200.0, 20.0),
      align=Center,
    ),
    fold_button: spawn_button(fold_offset, button_size, "#cc0000", 0),
    call_button: spawn_button(call_offset, button_size, "#00aa00", 1),
    raise_button: spawn_button(raise_offset, button_size, "#0066cc", 2),
    waiting_for_player: false,
    hole_card_entities: [],
    community_card_entities: [],
  }
}

///|
priv struct CardsGame {
  consumption : @ui.PointerConsumption
  display : @window.Display
  clicks : @event.EventReaderView[@ui.UiClickEvent]
  runtime : CardsRuntime
  texts : @ecs.Query[@ecs.Single[@ui.Text]]
  nodes : @ecs.Query[@ecs.Single[@ui.Node]]
  commands : @ecs.Commands
}

///|
fn CardsGame::CardsGame(world : @ecs.World) -> CardsGame {
  {
    consumption: PointerConsumption(world),
    display: Display(world),
    clicks: (world.resource() : CardsRuntime).click_reader.bind(
      world, @ui.click_event_bus,
    ),
    runtime: world.resource(),
    texts: world.query1(),
    nodes: world.query1(),
    commands: @ecs.commands(world),
  }
}

///|
impl @ecs.SystemParam for CardsGame with fn prepare(world) {
  let consumption = @ui.PointerConsumption(world)
  let display = @window.Display(world)
  let fetch : (@ecs.World) -> (
    @ecs.Res[CardsRuntime],
    @ecs.Query[@ecs.Single[@ui.Text]],
    @ecs.Query[@ecs.Single[@ui.Node]],
    @ecs.Commands,
  ) = @ecs.SystemParam::prepare(world)
  world => {
    let (runtime, texts, nodes, commands) = fetch(world)
    {
      consumption,
      display,
      runtime: runtime.get(),
      texts,
      nodes,
      commands,
      clicks: runtime.get().click_reader.bind(world, @ui.click_event_bus),
    }
  }
}

///|
fn CardsGame::game(self : CardsGame) -> GameState {
  self.runtime.game.unwrap()
}

///|
fn[T : @ecs.Bundle] CardsGame::spawn(
  self : CardsGame,
  values : T,
) -> @ecs.Entity {
  let entity = self.commands.spawn(values)
  self.runtime.entities.push(entity)
  entity
}
