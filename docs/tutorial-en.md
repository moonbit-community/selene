# Selene Tutorial (English)

This tutorial is aligned with the current Selene codebase in this repository.

## 1. What Selene Looks Like Today

Selene is split into a core engine and pluggable backends:

- `Milky2018/selene`: ECS engine core
- `Milky2018/selene-canvas`: web backend (Canvas2D)
- `Milky2018/selene_raylib`: native backend (raylib)

The game logic package is backend-agnostic. Backend selection is done by package `overrides`.

## 2. Run Existing Examples

### 2.1 Web Example (Canvas)

```bash
cd examples
moon update
moon build ./web/pixeladventure --target js --target-dir _build --release
python3 -m http.server 8000
```

Open:

- `http://localhost:8000/web/pixeladventure/`

### 2.2 Native Example (raylib)

```bash
cd examples
moon update
moon run ./native/pixeladventure --target native
```

## 3. Current Example Layout

Selene examples use a shared-logic + wrapper structure:

```text
examples/
  assets/                    # centralized assets
  pixeladventure/            # shared game logic
  web/pixeladventure/        # web entry (override selene-canvas) + index.html
  native/pixeladventure/     # native entry (override selene_raylib)
```

This keeps gameplay code reusable across backends.

## 4. Backend Selection with `overrides`

Web wrapper (`examples/web/pixeladventure/moon.pkg` style):

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure",
}

options(
  "is-main": true,
  overrides: [ "Milky2018/selene-canvas" ],
  targets: { "main.mbt": [ "js" ] },
)
```

Native wrapper (`examples/native/pixeladventure/moon.pkg` style):

```moonbit
import {
  "Milky2018/selene-examples/pixeladventure",
}

options(
  "is-main": true,
  overrides: [ "Milky2018/selene_raylib" ],
  targets: { "main.mbt": [ "native" ] },
)
```

## 5. Core Game Bootstrap API

Current bootstrap (from `examples/pixeladventure/main.mbt`) uses `App::new()` without backend constructor arguments:

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

Use `schedule=Startup` for one-time initialization.

## 6. ECS and Common Systems

### 6.1 Entity + Components

```moonbit
let player = @entity.Entity::new()
@position.positions.set(player, @math.Vec2D(100.0, 100.0))
@velocity.velocities.set(player, @math.Vec2D::zero())
```

### 6.2 Input

Use `Milky2018/selene/inputs`:

```moonbit
if @inputs.is_pressed(@inputs.ArrowLeft) {
  // move left
}

if @inputs.is_just_pressed(ArrowUp) {
  // jump
}
```

### 6.3 Collision + Trigger Areas

```moonbit
let player_group = @collision.CollisionGroup::new()
let terrain_group = @collision.CollisionGroup::new()
let trigger_group = @collision.CollisionGroup::new()

@collision.shapes.set(
  player,
  Rect(size=@math.Vec2D(24.0, 32.0), offset=@math.Vec2D(4.0, 0.0)),
)
@collision.colliders.set(
  player,
  @collision.Collider::new(
    @collision.CollisionFilter::new(player_group, [terrain_group]),
  ),
)

let wall = @entity.Entity::new()
@collision.shapes.set(
  wall,
  Rect(size=@math.Vec2D(16.0, 16.0), offset=@math.Vec2D::zero()),
)
@collision.colliders.set(
  wall,
  @collision.Collider::new(@collision.CollisionFilter::empty(terrain_group)),
)

let apple = @entity.Entity::new()
@collision.shapes.set(
  apple,
  Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
)
let area = @collision.Area::new(
  @collision.CollisionFilter::new(trigger_group, [player_group]),
)
@collision.areas.set(apple, area)
fn trigger_system(_delta : Double) -> Unit {
  for event in @collision.trigger_events() {
    if event.entered && event.area == apple && event.other == player {
      @entity.Entity::destroy(apple)
    }
  }
}
```

### 6.4 Camera and UI

```moonbit
@camera.set_limits(top=0.0, bottom=world_h, left=0.0, right=world_w)
@camera.attach_entity(player, @math.Vec2D(16.0, 16.0))

let label = @entity.Entity::new()
@ui.uis.set(label, @ui.Ui::new())
```

### 6.5 Mouse Interaction

Use `Pickable` with frame events:

```moonbit
@collision.pickables.set(button, @collision.Pickable::new())

fn ui_input_system(_delta : Double) -> Unit {
  for event in @collision.pointer_events() {
    if event.entity == button &&
      event.phase is @collision.PointerPhase::JustReleased &&
      event.button == @inputs.MouseButton::Left {
      // handle click
    }
  }
}
```

## 7. Web HTML and Build Output

Use `_build` paths in `index.html`, for example:

```html
<script src="../../preload-assets.js"></script>
<script src="../../_build/js/release/build/web/pixeladventure/pixeladventure.js" defer></script>
```

## 8. Build Commands You Will Use Most

```bash
# Web check/build
cd examples
moon check ./web/pixeladventure --target js
moon build ./web/pixeladventure --target js --target-dir _build --release

# Native check/run
moon check ./native/pixeladventure --target native
moon run ./native/pixeladventure --target native
```

## 9. Practical Notes

- Use `@system.App::new()` to bootstrap apps.
- Use `Milky2018/selene/inputs` for input.
- Use `@entity.Entity` as the entity type.
- Prefer `schedule=Startup` for one-time initialization.
- Use `CollisionGroup` + `CollisionFilter` for collision filtering.
- For static blockers, add a collider with `CollisionFilter::empty(group)`.
- Use `_build/...` paths in HTML.

## 10. Next Step

If you want to create a new cross-backend game, copy the three-package pattern from `pixeladventure`:

- One shared logic package: `examples/<game>`
- One web wrapper: `examples/web/<game>`
- One native wrapper: `examples/native/<game>`

Then only backend-specific parts stay in wrappers, and gameplay code remains shared.
