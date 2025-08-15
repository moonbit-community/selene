# Selene Tutorial (English)

This tutorial will help you quickly experience the Selene game engine.

## Understanding Selene

Selene is an experimental engine that encourages users to unleash creativity based on the most fundamental features of programming.

Selene has the following characteristics:

- Free and open source
- Simple: Very streamlined code, implemented in pure MoonBit (except for the Backend), easy to use
- Modular: Almost no coupling, you can import only the functionality you need
- Efficient: With the performance advantages of MoonBit itself and ECS architecture, it runs very fast

The shortcomings are that currently (version 0.10.x) Selene lacks many advanced features that industrial-grade engines have, such as convex polygon collision detection, 3D object rendering, gamepad support, etc. Contributions are very welcome.

## Running the Example

Make sure you have installed the [MoonBit toolchain](https://www.moonbitlang.com/download/) and learned the basics of using it.

Clone this repository:

```shell 
git clone https://github.com/Milky2018/selene.git
```

Enter the example directory:

```shell
cd example
```

Build the project using the `moon` CLI tool:

```shell
moon build --target js
```

Run with any web server, for example Python:

```shell
python -m http.server 8000
```

Or Node.js:

```shell 
npx serve .
```

After successful execution, open your browser and visit `localhost:8000` (or other port you specified) to start playing.

Next, you can try modifying some code in the source, such as adjusting the game screen size and frame rate, then rebuild and run. Soon you'll have a basic understanding of this example game and the Selene engine.

## Making Your First Game

This chapter will introduce how to use the Selene game engine to create a complete platform jumping game. Through the actual development process, learn the core functionality and development techniques of the game engine.

### Example Game Showcase

The game we will create is as follows:

![](../example/screenshot.png)

We will demonstrate how to create the following in the upcoming process:

- Green grass tiles
- A controllable character
- A movable camera
- Collectible apple items
- Score display box
- Volume control button

Players can use arrow keys to control character movement and jumping, with sound effects playing during jumps. Collecting apples increases the score. The volume button can control the game's sound on/off state.

To run the example game, enter the example directory, use `moon build` to build the project, then use any web server (such as `python -m http.server 8000`) to access it in a browser.

### Project Creation and Configuration

First download and install the MoonBit CLI tool. If using VS Code, it's recommended to install the MoonBit plugin, which will automatically prompt to download the relevant toolchain.

Use the `moon new` command to create a new project, select runnable project mode, and set project name and license information.

### Asset Preparation

The image and audio assets needed for the game can be downloaded for free: [Image assets](https://pixelfrog-assets.itch.io/pixel-adventure-1) contain character animation sequences and terrain elements, [Audio assets](https://brackeysgames.itch.io/brackeys-platformer-bundle) contain jump and collection sound effects. Copy the downloaded asset folders to the project root directory.

### Engine Dependency Installation

Add Selene engine dependencies to the project:

```bash
moon add Milky2018/selene@0.10.3
moon add Milky2018/selene-canvas@0.10.3
```

> You can also get the latest version to enjoy more new features, but the following process may not run properly and you'll need to debug it yourself.

Import the required engine modules in `moon.pkg.json`:

```json
{
  "import": [
    "Milky2018/selene/system",
    "Milky2018/selene/math",
    "Milky2018/selene/sprite",
    "Milky2018/selene/position",
    "Milky2018/selene/velocity",
    "Milky2018/selene/collision",
    "Milky2018/selene/input",
    "Milky2018/selene/plugins",
    "Milky2018/selene/camera",
    "Milky2018/selene/audio",
    "Milky2018/selene/tilemap",
    { "path": "Milky2018/selene-canvas", "alias": "canvas" }
  ]
}
```

The core of a Selene project is the App object. You need to create a basic game application in the `main` function:

```moonbit
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(480.0)
  .with_canvas_height(320.0)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .run()
}
```

A backend called `CanvasBackend` is used to run the game. Selene supports modular backends. When using the `CanvasBackend` backend, the game will be built as a JavaScript file describing a Canvas2D canvas.

The game cyclically executes system functions at a fixed frame rate (such as 60FPS). Each system is responsible for specific functionality, such as rendering, entity movement, or input processing. Specific game functionality needs to be implemented through various systems.

### Game State Management

Global game state contains player references, scores, volume settings, etc. You can use a global variable to save the game state:

```moonbit
struct GameState {
  player : @system.Entity
  mut score : Int
  mut volume_on : Bool
  mut player_state : PlayerState
  score_box : @sprite.Text
}

let game_state : GameState = {
  ...
}
```

The various fields contained will be introduced in the following content.

### Entities and Components

Objects in the game are represented through entities (Entity) and components (Component). Entities are unique identifiers, and components store specific data. Example of creating a player entity:

```moonbit
let player = @system.Entity::new()
@position.positions.set(player, @math.Vec2D::new(100.0, 100.0))
@velocity.velocities.set(player, @math.Vec2D::zero())
```

The above code does the following:

1. Generate a new Entity;
3. Set the new Entity's position to (100, 100);
2. Set the new Entity's velocity to (0, 0);

Entity is like a reference, all components belonging to an entity are associated together through the `Map[K, V]::set` method. Both `@position.positions` and `@sprite.sprites` are hash map type data structures that store the corresponding components for each entity.

Components are managed through global mapping tables, and systems process related entities by querying these mapping tables. For example, after setting velocity and position attributes for an entity, the entity's position will move according to velocity each frame.

Such behavior of adding a player entity needs to be placed in an initializer:

```moonbit
app.add_initializer(add_player)
```

Initializers are executed once when the game starts.

### Player Character Implementation

The player character needs multiple animation states: idle, running, jumping, and falling. Each state corresponds to different sprite animations. Taking the idle animation as an example:

```moonbit
let player_idle_animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
  loop_=true, max_frame=11, height=32.0, width=32.0
)
```

The `loop_` parameter indicates whether the animation will loop; `max_frame` indicates how many animation frames this image contains in total.

Play animation for an entity by calling `@sprite.play_animation`:

```moonbit
@sprite.play_animation(player, player_idle_animation)
```

The player state machine switches between different states based on velocity and ground contact. You can use a state machine to implement state switching and playing different animations:

```moonbit
enum PlayerState {
  Idle
  Jump
  Fall
} derive(Show)

match player_state {
  Idle => ...
  Jump => ...
  Fall => ...
}
```

Players also need to control character movement based on keyboard input. You can use `@system.is_pressed` or `@system.is_just_pressed` to detect whether a key is pressed. The difference is that the former returns true as long as the key is pressed, while the latter only returns true when the key is just pressed. You can use these two functions to control left-right movement and jumping respectively:

```moonbit
if @system.is_pressed(ArrowLeft) {
  velocity_x = -5.0
} else if @system.is_pressed(ArrowRight) {
  velocity_x = 5.0
} else {
  velocity_x = 0.0
}

if @system.is_just_pressed(ArrowUp) && @collision.is_on_floor(game_state.player) {
  velocity_y = 10.0
}
```

Here, `@collision.is_on_floor` is used to determine whether the character is standing on a platform.

### Obstacles and Collision

To prevent players from moving through obstacles, collision layers and collision bodies need to be set for both players and obstacles:

```moonbit
let terrain_collision_layer = @collision.CollisionLayer::new()
let player_collision_layer = @collision.CollisionLayer::new()

@collision.collides.set(game_state.player, @collision.Collide::{
  shape: Rect(size=@math.Vec2D::new(24.0, 32.0), offset=@math.Vec2D::zero()),
  layer: player_collision_layer,
  mask: @collision.CollisionMask::new([terrain_collision_layer]),
})

@collision.collides.set(grass, @collision.Collide::{
  shape: Rect(size=@math.Vec2D::new(16.0, 16.0), offset=@math.Vec2D::zero()),
  layer: terrain_collision_layer,
  mask: @collision.CollisionMask::empty(),
})
```

The above code sets rectangular collision bodies for the player and grass respectively. Collision only occurs when one entity's collision mask contains another entity's collision layer.

### Tile Map Creation

Drawing a complete map directly with code is not convenient. Selene supports using external tools like [Sprite Fusion](https://www.spritefusion.com/) to design maps and export them in JSON format.

The JSON output by Sprite Fusion contains the tile pixel size of the map, map dimensions, and information for each layer. It looks roughly like this:

```json
{
  "tileSize": 16,
  "mapWidth": 75,
  "mapHeight": 51,
  "layers": [
    {
      "name": "Grass",
      "tiles": [
        { "id": "0", "x": 8, "y": 46 },
        { "id": "1", "x": 9, "y": 46 },
        { "id": "2", "x": 8, "y": 47 },
        { "id": "3", "x": 9, "y": 47 },
      ],
      "collider": false
    }
    ...
  ]
}
```

Use `@tilemap.TileMap::from_json` to parse map data and generate corresponding game entities:

```moonbit
fn generate_map(backend : &@system.Backend) -> Unit {
  let tilemap = @tilemap.TileMap::from_json(tilemap_data)
  let grasses = tilemap.get_tiles("Grass")
  for grass in grasses {
    add_grass(tile_to_vec2d(grass, tilemap.tile_size))
  }
}
```

### Camera

When the game map is much larger than the canvas size, to allow players to see the character they control, the camera needs to follow the player and set boundary limits to prevent displaying blank areas:

```moonbit
@camera.camera.attached_entity = Some(player)
@camera.camera.limit_left = Some(0.0)
@camera.camera.limit_right = Some(world_width)
@camera.camera.limit_top = Some(0.0)
@camera.camera.limit_bottom = Some(world_height)
```

Since the player position is at the top-left corner of the player image, to make the camera closer to the center of the player character, you can also set the `offset` property to half the player's size:

```moonbit
@camera.camera.offset = @math.Vec2D::new(16.0, 16.0)
```

### Areas and Audio

Apples are different from terrain - they don't affect player movement and collision, but trigger events when touching the player: the apple disappears and the game score increases. This functionality is implemented by setting an area component for the apple entity:

```moonbit
let area = @collision.Area::new(
  Rect(size=@math.Vec2D::new(32.0, 32.0), offset=@math.Vec2D::zero()),
  non_collide_layer,
  @collision.CollisionMask::new([player_collision_layer]),
)
@collision.areas.set(apple, area)
area.on_enter(fn(e) {
  if e == game_state.player {
    set_score(game_state.score + 10)
    if game_state.volume_on {
      @audio.play_audio(backend, "sounds/coin.wav")
    }
    @system.Entity::destroy(apple)
  }
})
```

Set a rectangular collision body for the area. Use the `Area::on_enter` method to add a callback for the area. When an entity enters the area, it triggers score increase and plays sound effects.

### User Interface

Create score display boxes using regular `Sprite` components and UI components. UI elements use high z-index values to ensure they display above game content:

```moonbit
fn add_score_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(box, @math.Vec2D::new(240.0, 40.0))
  let text = @sprite.Sprite::new_text(game_state.score_box, 100)
  @camera.uis.set(box, @camera.Ui::new())
  @sprite.sprites.set(box, text)
}
```

Reminder: Forgetting to set the UI component will cause the entity to move with the camera instead of being fixed at a certain position on the screen.

The volume button switches audio on/off state through mouse click events. Mouse button callbacks can be set through the area component's `Area::on_just_released`. In this example, the volume button state is only toggled when the left mouse button is released.

```moonbit
let area = @collision.Area::new(
  @collision.CollisionShape::Rect(
    size=@math.Vec2D::new(21.0, 22.0),
    offset=@math.Vec2D::zero(),
  ),
  non_collide_layer,
  @collision.CollisionMask::new([]),
  monitoring_mouse=true,
)
area.on_just_released(fn(mouse_button) {
  if mouse_button == Left {
    game_state.volume_on = !game_state.volume_on
    if game_state.volume_on {
      @sprite.sprites.set(button, volume_on)
    } else {
      @sprite.sprites.set(button, volumn_off)
    }
  }
})
```

### Compilation & Playing

Build command:

```shell 
moon build --target js --watch
```

After successful building, you'll get a target directory containing the compilation artifacts. To display this canvas, we need an HTML file. Create an `index.html` file in the project root directory and fill it with the following content:

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>My Game</title>
    <script src="/target/js/release/build/main/main.js" defer></script>
</head>

<body>
    <canvas id="canvas" style="display: block; margin: 0 auto;" height="32" width="32"></canvas>
</body>

</html>
```

Then use a web server to run:

```shell
python3 -m http.server 8000
```

Use a browser to visit localhost:8000 to play.

Complete game source code: [Selene Example](https://github.com/moonbit-community/selene/tree/3a27062f3f95ae505b317116be457b6bd026f4f8/example)