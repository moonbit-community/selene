# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Texas Hold'em Poker single-player challenge game** built with MoonBit and the Selene game engine. The game runs in the browser as a static HTML5 game.

**Game Objective**: Maximize profit over exactly 10 poker hands, starting with $1000 in chips and paying a $20 big blind per hand.

## Build & Development Commands

### Build
```bash
moon check          # Type check the code
moon build          # Build the project (compiles to WebAssembly)
moon test           # Run whitebox tests (kind_wbtest.mbt)
```

### Development
- The game is developed in MoonBit language
- Built on top of the Selene game engine (canvas-based 2D game framework)
- Entry point: `index.html` (loads the compiled WebAssembly)
- Main game loop: `main.mbt`

## Code Architecture

### Module Structure

The codebase is organized into focused modules:

1. **game_state.mbt** - Central game state management
   - Defines `GameState` struct with all mutable game state
   - Defines `Player` struct for player data
   - Contains constants: `VIEWPORT_WIDTH`, `VIEWPORT_HEIGHT`, `BIG_BLIND`, `SMALL_BLIND`
   - Enums: `GamePhase` (PreFlop/Flop/Turn/River/Showdown/GameOver)
   - **Important**: All game state is stored in a single global `game_state` instance

2. **kind.mbt** - Poker hand evaluation logic
   - `HandRank` enum: represents all poker hand types (HighCard to StraightFlush)
   - `hand_rank_base_award(rank)`: calculates base payout for each hand type
   - `find_best_hand(cards)`: evaluates best 5-card hand from up to 7 cards
   - `eval_rank(hand)`: evaluates a specific hand's rank
   - **Critical**: Functions are PRIVATE (not `pub fn`) - only accessible via whitebox tests

3. **deck.mbt** - Card representation and deck management
   - `CardNum` and `CardSuit` enums
   - `Card` type alias: `(CardNum, CardSuit)`
   - `create_deck()` and `shuffle_deck()` functions
   - `deal_card()` for dealing from the deck

4. **game_logic.mbt** - Game flow control
   - `start_new_hand()`: initializes a new poker hand, resets magnification to 1
   - `deal_hole_cards()`: deals 2 cards to player
   - `advance_to_next_phase()`: progresses through game phases
   - `handle_showdown()`: evaluates hand and awards payout
   - **Key**: Checks for game-over conditions (chips <= 0, can't afford blind, turns <= 0)

5. **ui.mbt** - User interface and interaction
   - `setup_ui()`: creates all UI widgets (buttons, text displays)
   - `on_fold_click()`, `on_call_click()`, `on_raise_click()`: button handlers
   - `update_ui()`: refreshes all text displays (chips, turns, phase, hand strength)
   - `display_all_cards()` and `display_community_cards()`: render cards
   - **Important**: Uses Selene's `@style` widget system for UI components

6. **sprite.mbt** - Card sprite rendering
   - `Card::to_sprite()`: converts card data to visual sprite representation

7. **main.mbt** - Game initialization and main loop
   - Sets up the game system with Selene engine
   - Initializes UI and starts the first hand

### Key Game Mechanics

**Magnification System**:
- Each hand starts with `magnification = 1`
- Each raise increases magnification by 1
- Payout formula: `base_award × magnification`
- Reset to 1 at the start of each new hand (in `start_new_hand()`)

**Hand Evaluation**:
- Uses `find_best_hand()` to evaluate all C(7,5) = 21 possible 5-card combinations
- Works correctly with 1-7 cards (handles fewer than 5 cards gracefully)
- Base awards use generous formulas (e.g., One Pair = 15 + value×2, Royal Flush = 20000)

**Game State Flow**:
```
start_new_hand() → PreFlop → Flop → Turn → River → Showdown → start_new_hand()
                      ↓        ↓      ↓      ↓
                   (player actions: fold/call/raise)
```

**Turn Management**:
- Total turns: 10
- Folding does NOT consume a turn (allows retry)
- Only completing a hand (reaching showdown without folding) decrements `turns_remaining`

### Important Implementation Details

1. **MoonBit Syntax Notes** (from user's global .claude/CLAUDE.md):
   - Use `let mut` for variables that will mutate
   - `mut` does not indicate object mutability - arrays/objects can be mutated without `let mut`
   - Example: `let array = [1, 2, 3]` is fine, use `array.push(4)` directly

2. **Private Functions**:
   - Functions in `kind.mbt` are intentionally private (NOT `pub fn`)
   - They remain accessible in whitebox tests (`kind_wbtest.mbt`)

3. **Game State Updates**:
   - Always call `update_ui()` after modifying game state
   - Button handlers must call `hide_action_buttons()` after player action

4. **Selene Engine Integration**:
   - Uses ECS-style systems: `@entity`, `@position`, `@sprite`, `@collision`, `@style`
   - Widgets are created via `@style.add_widget()` with functional parameters
   - Card entities must be destroyed and recreated when updating display

## Game Design Specification

The complete game rules and mechanics are documented in `Gamespec.md`. Key highlights:

- **Starting chips**: $1000
- **Big blind**: $20 (doubles every 10 hands)
- **Game length**: 10 completed hands
- **Hand evaluation**: Best 5-card hand from 2 hole cards + 5 community cards
- **Payout multiplier**: Starts at 1×, increases by 1× per raise
- **Win condition**: Maximize chips after 10 hands
- **Loss condition**: Run out of chips before completing 10 hands

## Testing

Whitebox tests are in `kind_wbtest.mbt`:
- Tests `find_best_hand()` with 1-7 cards
- Covers all hand types (HighCard through StraightFlush)
- Tests edge cases like wheel straight (A-2-3-4-5)
- Run with `moon test`
