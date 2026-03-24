# Selene Tutorial (English)

This tutorial helps you quickly experience the Selene game engine.

## Understanding Selene

Selene is an experimental engine that encourages users to unleash creativity based on fundamental programming building blocks.

Selene has the following characteristics:

- Free and open source
- Simple: streamlined core code, implemented in MoonBit (platform backends provided by backend modules)
- Modular: import only what you need, select backend through wrapper packages
- Efficient: benefits from MoonBit performance and ECS architecture

Selene already supports 2D/3D rendering, input, UI, physics, and Tiled/LDtk integration, and contributions are always welcome.

## Running the Example

Make sure you have installed the [MoonBit toolchain](https://www.moonbitlang.com/download/) and learned basic usage.

Clone this repository:

```shell
git clone https://github.com/moonbit-community/selene.git
```

Enter the examples directory and build the web sample:

```shell
cd examples
moon update
moon build ./pixeladventure/web --target js --target-dir _build --release
```

Run with any web server, for example Python:

```shell
python -m http.server 8000
```

After startup, open `http://localhost:8000/pixeladventure/` in your browser.

Next, try changing a few source values (viewport size, zoom, FPS), then rebuild and rerun. This gives a quick practical understanding of both the sample and the engine.

## Making Your First Game

This chapter shows how to build a complete platformer-style game with Selene and learn the core workflow through real implementation steps.

### Example Game Showcase

The game we will build looks like this:

![](../examples/pixeladventure/screenshot.png)

In the following process, we will build:

- Green grass tiles
- A controllable character
- A camera that follows the player
- Collectible apples
- A score display
- A volume toggle button

Players use arrow keys to move and jump. Collecting apples increases score. The volume button toggles game audio.

### Project Creation and Configuration

First install MoonBit CLI. If you use VS Code, install the MoonBit extension for better diagnostics and navigation.

After creating a new project with `moon new`, use a structure similar to `examples/pixeladventure`:

- `pixeladventure`: shared gameplay package
- `pixeladventure/web`: web wrapper package (selects webgpu backend by overrides)

### Asset Preparation

The image and audio assets can be downloaded from:

- [Image assets](https://pixelfrog-assets.itch.io/pixel-adventure-1)
- [Audio assets](https://brackeysgames.itch.io/brackeys-platformer-bundle)

Place assets under paths such as `assets/pixeladventure/...`.

### Engine Dependency Installation

Add Selene dependencies:

```bash
moon add Milky2018/selene
moon add Milky2018/selene_webgpu
```

If you also need native backend:

```bash
moon add Milky2018/selene_raylib
```

Core gameplay package imports are module-based. Example from `examples/pixeladventure/moon.pkg`:

```moonbit
import {
  "Milky2018/selene/app",
  "Milky2018/selene/audio",
  "Milky2018/selene/system",
  "Milky2018/selene/state",
  "Milky2018/selene/ecs",
  "Milky2018/selene/entity",
  "Milky2018/selene/math",
  "Milky2018/selene/sprite",
  "Milky2018/selene/physics2d",
  "Milky2018/selene/plugins",
  "Milky2018/selene/time",
  "Milky2018/selene/transform",
  "Milky2018/selene/camera",
  "Milky2018/selene/ui",
  "Milky2018/selene/event",
  "Milky2018/selene/inputs",
  "Milky2018/selene/asset",
  "moonbitlang/core/json",
  "moonbitlang/core/random",
  "moonbitlang/core/set",
}
```

Web wrapper example (`examples/pixeladventure/web/moon.pkg`):

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure" @pixeladventure_game,
}

options(
  "is-main": true,
  overrides: [
    "Milky2018/selene_webgpu/platform_window",
    "Milky2018/selene_webgpu/platform_input",
    "Milky2018/selene_webgpu/platform_render",
    "Milky2018/selene_webgpu/platform_audio",
    "Milky2018/selene_webgpu/platform_asset_io",
  ],
  "supported-targets": "js",
  targets: { "main.mbt": [ "js" ] },
)
```

Web wrapper `main.mbt`:

```moonbit
fn main {
  @pixeladventure_game.run()
}
```

The App object is the runtime entrypoint. Example app bootstrap:

```moonbit
pub fn run() -> Unit {
  @app.App::new()
  .with_viewport_width(480.0)
  .with_viewport_height(320.0)
  .with_image_smooth(false)
  .with_zoom(2.0)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .add_system(Startup, game_start)
  .add_system(Update, player_state_system)
  .add_system(FixedPostUpdate, player_collision_system)
  .add_system(Update, map_trigger_system)
  .run()
}
```

Systems are executed by schedule, and each system owns a specific responsibility (input, collision, UI, rendering, etc).

### Game State Management

Global game state can store player references, score, volume status, and UI entities:

```moonbit
struct GameState {
  player : @entity.Entity
  mut direction : Direction2
  mut score : Int
  result_box : @entity.Entity
  score_box : @entity.Entity
  health_box : @entity.Entity
  volume_button : @entity.Entity
  mut volume_on : Bool
  mut health : Int
  mut hurt_timer : Double
  mut pending_bounce_velocity_y : Double?
}
```

### Entities and Components

Game objects are represented by Entity + Component data. Example:

```moonbit
let player = @entity.Entity::new()
@transform.transforms().set(player, @transform.Transform::from_xyz(100.0, 100.0, 0.0))
@physics2d.linear_velocities().set(player, @math.Vec2D::zero())
```

This does three things:

1. Create an entity
2. Attach position
3. Attach velocity

Components are stored in maps such as `@transform.transforms()` and `@sprite.sprites()`, keyed by entity ID.

Initialization behavior should run once in `Startup` systems.

### Player Character Implementation

Player usually has multiple animation states (idle/run/jump/fall). Idle example:

```moonbit
let player_idle_layout = @sprite.register_texture_atlas_layout(
  @sprite.TextureAtlasLayout::from_grid(@math.Vec2D(32.0, 32.0), 11, 1),
)
let player_idle_image = @asset.load_image(
  "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png",
)
```

`TextureAtlasLayout` describes where each frame lives in the atlas, while runtime playback updates `TextureAtlas.index`.

Build a clip/graph pair and attach an animation player with:

```moonbit
@sprite.sprites().set(
  game_state.player,
  @sprite.Sprite::from_atlas_image(
    player_idle_image,
    @sprite.TextureAtlas::new(player_idle_layout),
  ),
)
let clip = @animation.AnimationClip::new("player_idle")
let frame_keys : Array[@animation.ScalarKeyframe] = []
for index in 0..<11 {
  frame_keys.push({
    time: index.to_double() / 12.0,
    value: index.to_double(),
    in_tangent: None,
    out_tangent: None,
  })
}
clip.add_curve_to_target(
  @animation.AnimationTargetId::new("self"),
  @animation.VariableCurve::scalar(
    @animation.texture_atlas_index_field(),
    frame_keys,
    interpolation=@animation.ChannelInterpolation::Step,
  ),
)
let (graph, nodes) = @animation.AnimationGraph::from_clips([
  @animation.register_animation_clip_asset(clip),
])
@animation.animation_graph_handles().set(
  game_state.player,
  @animation.register_animation_graph_asset(graph),
)
@animation.animation_players().set(
  game_state.player,
  @animation.AnimationPlayer::new(),
)
@animation.animation_target_ids().set(
  game_state.player,
  @animation.AnimationTargetId::new("self"),
)
@animation.animated_bys().set(
  game_state.player,
  @animation.AnimatedBy::new(game_state.player),
)
ignore(@animation.animation_players().get(game_state.player).unwrap().play(nodes[0]))
```

Input handling uses `@inputs`:

```moonbit
if @inputs.is_pressed(@inputs.ArrowLeft) {
  // move left
} else if @inputs.is_pressed(@inputs.ArrowRight) {
  // move right
}

if @inputs.is_just_pressed(ArrowUp) && @physics2d.is_grounded(game_state.player) {
  // jump
}
```

`is_pressed` is continuous; `is_just_pressed` is edge-triggered.

### Obstacles and Collision

Configure collision groups, shape, and collider to block terrain penetration:

```moonbit
let terrain_collision_group = @physics2d.CollisionGroup::new()
let player_collision_group = @physics2d.CollisionGroup::new()

@physics2d.shapes().set(
  game_state.player,
  Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
)
@physics2d.colliders().set(
  game_state.player,
  @physics2d.Collider::new(
    @physics2d.CollisionFilter::new(player_collision_group, [
      terrain_collision_group,
    ]),
  ),
)
```

Only allowed collision-filter pairs will interact.

### Tile Map Creation

Writing full maps directly in code is inconvenient. You can design maps in [Sprite Fusion](https://www.spritefusion.com/) and export JSON.

The example defines local `TileMap` parsing in `spritefusion_tilemap.mbt`, then spawns entities in `generate_map`:

```moonbit
fn generate_map() -> Unit {
  let tile_map = TileMap::from_json(tilemap)
  let grasses = tile_map.get_tiles("Grass")
  for grass in grasses {
    add_grass_visual(tile_to_vec2d(grass, tile_map.tile_size), grass.id)
  }
}
```

### Camera

When world size is larger than viewport, set camera limits and follow target:

```moonbit
@camera.set_limits(top=0.0, bottom=world_height, left=0.0, right=world_width)
@camera.attach_entity(game_state.player, @math.Vec2D(16.0, 16.0))
```

The attach offset is typically near the player center.

### Areas and Audio

Apples should not block movement, but should trigger collection behavior. Add `Area` and detect contain state in system:

```moonbit
let area = @physics2d.Area::new(
  @physics2d.CollisionFilter::new(trigger_collision_group, [
    player_collision_group,
  ]),
)
@physics2d.areas().set(apple, area)

fn map_trigger_system(_world : @ecs.World) -> Unit {
  for apple in apples.to_array() {
    if @physics2d.get_contains(apple).contains(game_state.player) {
      set_score(game_state.score + 10)
      if game_state.volume_on {
        play_sfx(coin_sound)
      }
      apple.destroy()
      apples.remove(apple)
    }
  }
}
```

Sound effects are sent as audio events:

```moonbit
fn play_sfx(sound : @audio.AudioHandle) -> Unit {
  @audio.send_audio_event(sound, settings=@audio.PlaybackSettings::remove())
}
```

### User Interface

Current UI uses `@ui` component stores for text/buttons/images. Example score text:

```moonbit
fn add_score_box() -> Unit {
  @ui.nodes().set(
    game_state.score_box,
    @ui.Node::absolute(
      @math.Vec2D(48.0, 16.0),
      size=@math.Vec2D(432.0, 24.0),
    ),
  )
  @ui.z_indexes().set(game_state.score_box, @ui.ZIndex::new(100))
  @ui.texts().set(game_state.score_box, @ui.Text::new("Score: 0"))
  @ui.text_fonts().set(game_state.score_box, @ui.TextFont::from_css("20px ThaleahFat"))
}
```

Volume button click handling:

```moonbit
let ui_click_reader : @event.EventReader[@ui.UiClickEvent] = @event.EventReader::new()

fn volume_button_input_system(_world : @ecs.World) -> Unit {
  for event in @ui.click_event_bus.read(ui_click_reader) {
    guard event.entity == game_state.volume_button else { continue }
    game_state.volume_on = !game_state.volume_on
  }
}
```

### Build & Play

Build command:

```shell
cd examples
moon build ./pixeladventure/web --target js --target-dir _build --release
```

Then use `examples/pixeladventure/index.html`, which references:

```html
<script src="../preload-assets.js"></script>
<script src="../_build/js/release/build/pixeladventure/web/web.js" defer></script>
```

Run local server:

```shell
python3 -m http.server 8000
```

Open `http://localhost:8000/pixeladventure/` to play.

Complete source: [Selene Example](https://github.com/moonbit-community/selene/tree/main/examples/pixeladventure)

## Next Steps

Congratulations on completing your first Selene game. You now have the core workflow in place. Next, you can:

- Extend gameplay: add more levels, enemies, items, or mechanics
- Improve game feel: polish animation, audio, and visual feedback
- Contribute to the community: report issues or submit improvements on [GitHub](https://github.com/moonbit-community/selene)
- Build original projects: apply this architecture to your own game ideas

Selene can be used not only for games, but also for graphical interactive applications. Build something great with MoonBit and Selene.
