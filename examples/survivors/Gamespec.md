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
- **Atk**: Player's attack (default 0.0)
- **Rng**: Player's base range (default 0.0)
- **Spd**: Player's speed (default 150.0)
- **Agi**: Player's attack speed (default 1.0)
- **Pen**: Player's extra penetration (default 0)

### Combat System
- **Automatic attacking**: Player automatically uses all weapons which he has
- **Weapons**: Player can have multiple weapons; and multiple of the same weapon type

### Weapon System
1. **Pistol** (default weapon): 
   - **Bullet Properties**:
     - Speed: 300 units per second
     - Size: 4x4 pixels
     - Color: White
     - Cooldown Rate: 1.5s / Agi 
     - Damage: 1.0 + Atk 
     - Range: 128.0 + Rng 
     - Penetration: 1
   - **Powerup**
     - Spd - 15
   - **Weight**:
     - 10.0 + level * 0.5

2. **Minigun** 
   - **Bullet Properties**:
     - Speed: 600 units per second
     - Size: 4x4 pixels
     - Color: White
     - Cooldown Rate: 0.3s / Agi 
     - Damage: 0.5 + Atk * 0.3
     - Range: 128.0 + Rng 
     - Penetration: 1
   - **Powerup**
     - Spd - 50
   - **Weight**:
     - level * 0.5

1. **Sniper Rifle** 
   - **Bullet Properties**:
     - Speed: 900 units per second
     - Size: 4x4 pixels
     - Color: White
     - Cooldown Rate: 3.0s / Agi 
     - Damage: 2.0 + Atk * 4.0
     - Range: 192.0 + Rng 
     - Penetration: 4
   - **Powerup**
     - Spd - 25
     - Agi - 0.2
   - **Weight**:
     - level * 0.5

### Enemy System

#### Enemy Types
1. **Creeper**
   - Health: 1 HP
   - Speed: 60 units/second
   - Points/XP: 10

2. **Icecream**
   - Health: 2 HP
   - Speed: 90 units/second
   - Points/XP: 20

3. **Orc**
   - Health: 3 HP
   - Speed: 75 units/second
   - Points/XP: 30

4. **Skull**
   - Health: 5 HP
   - Speed: 60 units/second
   - Points/XP: 40

5. **Teleman**
   - Health: 20 HP
   - Speed: 60 units/second
   - Points/XP: 80

6. **Devil**
   - Health: 8 HP
   - Speed: 90 units/second
   - Points/XP: 50
   - **Attack**: Bullet Shooting:
     - Speed: 120 units per second (no range limit, last until colliding with walls/player)
     - Size: 4x4 pixels
     - Color: Red 
     - Cooldown Rate: 5.0s

7. **Pirate**
   - Health: 500 HP
   - Speed: 60 units/second
   - Points/XP: 200

#### Enemy Behavior
- **AI**: Simple pathfinding directly toward player
- **Spawn Rate**: One enemy every second
- **Spawn Locations**: 4 corner positions of the map
- **Wave Progression**: Enemy type distribution changes based on current wave

#### Waves (1 wave per minute)
1. 40 Creeper, 20 Icecream 
2. 30 Creeper, 30 Orc
3. 120 Icecream
4. 60 Creeper, 60 Skull
5. 90 Orc, 90 Skull 
6. 4 Teleman, 56 Orc 
7. 60 Devil, 60 Icecream
8. 40 Devil, 40 Teleman, 40 Orc 
9. 20 Creeper, 20 Icecream, 20 Orc, 20 Skull, 20 Teleman, 20 Devil 
10. 1 Pirate, 59 Teleman

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
- **Benefits**: 
  - Choose a Bonus from 3 random powerups (according to weights) for regular level-ups
  - Choose a Bonus from 2 random powerups and 1 random weapon (according to weights) for times-5 level-ups (level 5, 10, 15, etc)

#### Powerups 
- **Attack Lv1**: Atk + 0.2, weight: 10
- **Attack Lv2**: Atk + 0.3, weight: 1 + level * 0.2
- **Attack Lv3**: Atk + 0.4, weight: level * 0.1
- **Range Lv1**: Rng + 16.0, weight: 10 
- **Range Lv2**: Rng + 32.0, weight: 5 + level * 1.0
- **Speed Lv1**: Spd + 15.0, weight: 10
- **Speed Lv2**: Spd + 30.0, weight: 5 + level * 0.5
- **Cooldown Lv1**: Agi + 0.1, weight: 10
- **Cooldown Lv2**: Agi + 0.2, weight: 1 + level * 0.2
- **Bandana**: Pen + 1, weight: level * 0.1

### Wave System
- **Duration**: 10 minutes total (600 seconds)
- **Wave Count**: 10 waves, each lasting 1 minutes (60 seconds)
- **Progression**: Enemy spawn weights change per wave
- **Current Wave Display**: Shows wave number in UI

### Scoring System
- **Points**: Equal to XP gained from killing enemies
- **Penalty**: Score descreases (250 * wave number, not lower than 0) when player takes damage
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
- **Layers**: Player, enemy, bullet, wall, UI, enemybullet 
- **Detection**: Rectangle-based collision shapes
- **Interactions**: Bullet-enemy, enemy-player, entity-wall, enemybullet-player

### Asset Requirements
- **Sprites**: Character animations for all directions and states
- **Font**: ThaleahFat.ttf for all UI text
- **Map**: 640x640 pixel game world with grass background
- **Viewport**: 480x320 pixel view with 2x zoom

### Performance Specifications
- **Target FPS**: 60 FPS
- **Map Size**: 640x640 pixels
- **Viewport**: 960x640 pixels (480x320 * 2x zoom)
- **Entity Limits**: No hard limits

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
- All enemies eliminated
- Ask the player to restart
- No further gameplay interaction
- Game remains in this state permanently
