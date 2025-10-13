# Survivors Game Specification

## Overview
A vampire survivor-like top-down 2D survival game where the player must survive waves of enemies for 10 minutes while gaining experience and leveling up. The game features automatic shooting, enemy AI, a progression system, and level-up pause mechanics.

## Core Gameplay

### Objective
- Survive for 10 minutes (600 seconds) against increasingly difficult waves of enemies
- Score points by killing enemies
- Gain experience to level up and become stronger

### Controls
- **WASD**: Move player character
- **Mouse**: Click Resume button during level-up pause
- **No manual shooting**: Weapons fire automatically at nearest enemies

## Game Systems

### Player Character
- **Size**: 16x16 pixels
- **Speed**: 150 units per second
- **Health**: No traditional health system - uses invincibility frames
- **Invincibility**: 1 second after taking damage
- **Animations**: Idle and running animations for 4 directions (up, down, left, right)

### Stats 
- **Atk**: Player's attack (default 1.0)
- **Rng**: Player's base range (default 0.0)
- **Spd**: Player's speed (default 150.0)
- **Def**: Player's attack speed (default 1.0)

### Combat System
- **Automatic attacking**: Player automatically uses all weapons which he has

### Weapon System
1. **Pistol** (Default weapon): 
   - **Bullet Properties**:
   - Speed: 300 units per second
   - Size: 4x4 pixels
   - Color: White
   - Cooldown Rate: 1.5s / Def 
   - Damage: 1.0 + Atk 
   - Range: 128.0 + Rng 

2. **Minigun** 
   - **Bullet Properties**:
   - Speed: 600 units per second
   - Size: 4x4 pixels
   - Color: White
   - Cooldown Rate: 0.3s / Def 
   - Damage: 0.2 + Atk * 0.5
   - Range: 192.0 + Rng 

### Enemy System

#### Enemy Types
1. **Creeper**
   - Health: 1 HP
   - Speed: 60 units/second
   - Points/XP: 10
   - Most common in early waves

2. **Icecream**
   - Health: 2 HP
   - Speed: 60 units/second
   - Points/XP: 25
   - Peak frequency in mid waves

3. **Orc**
   - Health: 3 HP
   - Speed: 75 units/second
   - Points/XP: 50
   - Increases in later waves

4. **Skull**
   - Health: 4 HP
   - Speed: 90 units/second
   - Points/XP: 100
   - Only appears in waves 4-5

#### Enemy Behavior
- **AI**: Simple pathfinding directly toward player
- **Spawn Rate**: One enemy every second
- **Spawn Locations**: 4 corner positions of the map
- **Wave Progression**: Enemy type distribution changes based on current wave

### Level Progression System

#### Experience (XP) Formula
```
XP required for level n = n * (2 * n * n + 21 * n + 73) / 6
```

#### Level-Up Mechanics
- **Trigger**: Automatically when sufficient XP is gained
- **Pause**: Game pauses completely
- **UI**: Shows "LEVEL UP!" text and "RESUME" button
- **Resume**: Click button to continue 
- **Benefits**: Choose a Powerup from 3 random powerups

#### Powerups 
- **Attack**: Atk + 0.2
- **Range**: Rng + 16.0
- **Speed**: Spd + 15.0
- **Cooldown**: Def + 0.1

### Wave System
- **Duration**: 10 minutes total (600 seconds)
- **Wave Count**: 5 waves, each lasting 2 minutes (120 seconds)
- **Progression**: Enemy spawn weights change per wave
- **Current Wave Display**: Shows wave number in UI

### Scoring System
- **Points**: Equal to XP gained from killing enemies
- **Penalty**: Score halved when player takes damage
- **Final Score**: Displayed when time expires

## User Interface

### HUD Elements
- **Level**: Current player level (top-left, yellow)
- **EXP**: Progress to next level in "current/needed" format (top-left, cyan)
- **Wave**: Current wave number (top-left, orange)
- **Score**: Current score (top-center, white)
- **Timer**: Remaining time in MM:SS format (top-right, white)

### Level-Up Screen
- **Background**: Game paused (all movement stops)
- **Title**: "LEVEL UP!" text (center, gold, 36px font)
- **Button**: "RESUME" clickable button (center, white, 24px font)
- **Interaction**: Click to resume normal gameplay

### Game Over Screen
- **Trigger**: When timer reaches 0:00
- **Message**: "TIME'S UP! Final Score: [score]" (center, red, 32px font)
- **State**: Game remains paused permanently

## Technical Architecture

### Entity Component System
- **Entities**: Player, enemies, bullets, UI elements
- **Components**: Position, velocity, sprite, collision, UI
- **Systems**: Player update, shooting, enemy AI, collision, timer

### Collision System
- **Layers**: Player, enemy, bullet, wall, UI
- **Detection**: Rectangle-based collision shapes
- **Interactions**: Bullet-enemy, enemy-player, entity-wall

### Asset Requirements
- **Sprites**: Character animations for all directions and states
- **Font**: ThaleahFat.ttf for all UI text
- **Map**: 640x640 pixel game world with grass background
- **Viewport**: 480x320 pixel view with 2x zoom

### Performance Specifications
- **Target FPS**: 60 FPS
- **Map Size**: 640x640 pixels
- **Viewport**: 960x640 pixels (480x320 * 2x zoom)
- **Entity Limits**: No hard limits, but spawns 1 enemy per second

## Game States

### Playing State
- Player can move and shoot
- Enemies spawn and move toward player
- Timer counts down
- XP and score can be gained

### Level-Up Pause State
- All game time stops (delta = 0)
- Level-up UI visible and interactive
- Player input limited to resume button
- Enemies and bullets frozen

### Game Over State
- Timer expired
- Final score displayed
- No further gameplay interaction
- Game remains in this state permanently
