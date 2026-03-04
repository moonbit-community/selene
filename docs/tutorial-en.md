# Selene Tutorial (English)

## 1. Quick Start

### 1.1 Web (Canvas)

```bash
cd examples
moon update
moon build ./pixeladventure/web --target js --target-dir _build --release
python3 -m http.server 8000
```

Open `http://localhost:8000/pixeladventure/`.

### 1.2 Native (raylib) with embedded assets (optional)

This is an optional optimization and packaging flow for native release builds.
By default, you can skip it and load assets from the filesystem.

Install the CLI:

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

Add pre-build to your native game wrapper `moon.pkg`:

```moonbit
options(
  "is-main": true,
  overrides: [ "Milky2018/selene_raylib" ],
  "pre-build": [
    {
      "input": "<assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir $input --pack-out $output --path-prefix <runtime-prefix>",
    },
    {
      "input": "<assets-dir>",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir $input --index-out $output --path-prefix <runtime-prefix> --blob-name embedded_assets_blob --lookup-fn get_embedded_asset",
    },
    {
      "input": "_embedded_assets.pack",
      "output": "embedded_assets_blob.mbt",
      "command": ":embed --binary -i $input -o $output --name embedded_assets_blob",
    },
  ],
)
```

Use the same `<assets-dir>` in both pre-build steps, and set `<runtime-prefix>` to match your runtime asset paths.

When embedding is enabled, call this before `app.run()`:

```moonbit
@asset.set_io(get_embedded_asset)
```

If embedding is not enabled, do not call this API.

## 2. Example Layout

```text
examples/
  pixeladventure/            # game logic + web entry + assets
    assets/pixeladventure/
    web/                     # override selene-webgpu
```

## 3. Backend Wrapper (`moon.pkg`)

### 3.1 Web wrapper

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure",
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
  targets: { "main.mbt": [ "js" ] },
)
```

## 4. App Bootstrap

```moonbit
pub fn run() -> Unit {
  @system.App::new()
  .with_viewport_width(480.0)
  .with_viewport_height(320.0)
  .with_image_smooth(false)
  .with_zoom(2.0)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(gameplay_system)
  .run()
}
```

## 5. System Stages

- Frame: `First -> PreUpdate -> Update -> PostUpdate -> Last`
- Fixed: `FixedFirst -> FixedPreUpdate -> FixedUpdate -> FixedPostUpdate -> FixedLast`
- Render: `RenderExtract -> RenderPrepare -> Render -> RenderCleanup`

## 6. Core Runtime API

### 6.1 Transform + velocity

```moonbit
let player = @entity.Entity::new()
@transform.transforms.set(player, @math.Vec2D(100.0, 100.0))
@physics2d.linear_velocities.set(player, @math.Vec2D::zero())
```

### 6.2 Collision layers + collider

```moonbit
let player_group = @physics2d.CollisionGroup::new()
let terrain_group = @physics2d.CollisionGroup::new()

@physics2d.shapes.set(
  player,
  Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
)
@physics2d.colliders.set(
  player,
  @physics2d.Collider::new(
    @physics2d.CollisionLayers::new(player_group, [terrain_group]),
  ),
)
```

The event examples below assume `Milky2018/selene/event` is imported as `@event`.

### 6.3 Sensor events

```moonbit
let trigger_group = @physics2d.CollisionGroup::new()
let sensor = @physics2d.Sensor::new(
  @physics2d.CollisionLayers::new(trigger_group, [player_group]),
)
@physics2d.sensors.set(apple, sensor)

let trigger_reader : @event.EventReader[@physics2d.TriggerEvent] = @event.EventReader::new()

fn trigger_system(_delta : Double) -> Unit {
  for event in @physics2d.trigger_event_bus.read(trigger_reader) {
    if event.entered && event.area == apple && event.other == player {
      @entity.Entity::destroy(apple)
    }
  }
}
```

### 6.4 Pointer events

```moonbit
@physics2d.pickables.set(button, @physics2d.Pickable::new())

let pointer_reader : @event.EventReader[@physics2d.PointerEvent] = @event.EventReader::new()

fn ui_input_system(_delta : Double) -> Unit {
  for event in @physics2d.pointer_event_bus.read(pointer_reader) {
    if event.entity == button &&
      event.phase is @physics2d.PointerPhase::JustReleased &&
      event.button == @inputs.MouseButton::Left {
      // handle click
    }
  }
}
```

## 7. Web HTML Script Path

```html
<script src="../preload-assets.js"></script>
<script src="../_build/js/release/build/pixeladventure/web/web.js" defer></script>
```

## 8. Common Commands

```bash
# Web
cd examples
moon check ./pixeladventure/web --target js
moon build ./pixeladventure/web --target js --target-dir _build --release

# Build all web examples
moon build --release
```
