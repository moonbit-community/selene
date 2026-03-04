# Changelog

## [0.22.0] - 2026-03-04

### Added

- Bevy-style UI interaction primitives in `selene/ui`: `Node`, `Button`, `Interaction`, and frame-level `interaction_events`
- UI helpers `add_node` / `add_button` and dedicated `ui_layout_system` / `ui_button_system`
- Gamepad input abstraction in `selene/inputs` with backend event registration support
- 3D math types (`Vec3`, `Quat`, `Mat4`) merged into `Milky2018/selene/math`

### Changed

- Migrated examples UI interaction flow (`pixeladventure`, `cards`, `survivors`) from pickable-pointer handling to `selene/ui` button interaction events
- Migrated examples UI construction in `cards` and `survivors` to `selene/ui` node APIs
- Updated render/physics/scene/transform 3D modules to use unified `@math` instead of `@math3d`
- Release script now validates `docs/CHANGELOG.md` for the target version before running the publish pipeline

### Removed

- Removed legacy standalone package `Milky2018/selene/math3d`

## [0.21.2] - 2026-03-03

### Changed

- Release pipeline now publishes only runtime packages (`selene-core`, `selene-webgpu`, `selene-raylib`) and restores local manifests after publish
- `examples` is treated as local project content (excluded from package publish)

### Fixed

- WebGPU dynamic vertex-buffer offset handling for draw commands
- Web `scene3d` rendering visibility and preview-thumbnail capture workflow

## [0.21.1] - 2026-03-03

### Changed

- Updated `selene-raylib` dependency to `tonyfettes/raylib@0.2.3`
- Migrated raylib repeat/transform rendering path from deprecated `@raylib.rl_*` calls to `@rl.*`

## [0.21.0] - 2026-03-03

### Added

- New WebGPU backend package: `Milky2018/selene_webgpu`
- New `scene3d` example using the unified backend 3D API
- Web text rendering integration via `moon_cosmic` + `moon_swash`
- Accessibility synchronization in core via `moon_accesskit`

### Changed

- Renamed backend package from `selene-canvas` to `selene-webgpu`
- Migrated runtime architecture to `transform` + `physics2d` APIs and staged schedule
- Replaced legacy quadtree/layer collision path with Rapier 2D queries and collision filters
- Unified examples asset paths and web build workflow (`build_all.sh`, `_build` web paths)

## [0.20.0] - 2026-03-02

### Added

- `publish.py` versioned release workflow

### Changed

- Refined zoom/display-space semantics and examples UI behavior
- Refreshed tutorials for the updated engine layout

### Fixed

- Fixed Rapier shape-cast no-hit abort
- Fixed movement edge cases in `pixeladventure`
- Fixed raylib texture sampling and image scaling edge cases

## [0.19.0] - 2025-10-27

### Added 

- `@sprite.ColorCircle::new` and corresponding variant `SpriteType::ColorCircle`
- `@backend.draw_color_circle`

### Changed 

- `@sprite.ColorRect::new` add optional argument `stroke_color`
- `@backend.draw_color_rect` add labeled argument `stroke_color`

### Removed 

- `@backend.draw_stroke_rect` now combined in `@backend.draw_color_rect`

## [0.18.3] - 2025-10-27

### Changed 

- `@entity.Entity::get_roots` now only returns live entities 

## [0.18.2] - 2025-10-13

### Added 

- `@backend.get_time_scale`

## [0.18.1] - 2025-10-13

### Added 

- Widget APIs: `@style.add_widget` and `@style.screen_root`

### Changed 

- Add a variant: `@style.SizePlan::FromShape`

## [0.18.0] - 2025-10-11

### Added

- Entity inheritance, including APIs:
  - `fn get_children(Entity) -> Array[Entity]`
  - `fn get_offset(Entity) -> @math.Vec2D`
  - `fn get_parent(Entity) -> Entity?`
  - `fn get_roots() -> Array[Entity]`
  - `fn iter_entities() -> Iter[Entity]`
  - `fn live_entities() -> Iter[Entity]`
  - `fn set_offset(Entity, @math.Vec2D) -> Unit`
  - `fn spawn_child(Entity, offset? : @math.Vec2D) -> Entity`
- Positions and liveness of child entities will be affected by parent entities 
- New experimental subpackage `@style`, including APIs to make UI elements and styles

### Changed 

- New subpackage `@entity`, including APIs about Entities which were placed in `@system`

### Removed

- `@entity.live_entities`

## [0.17.2] - 2025-10-10

### Added 

- `@backend.get_realtime_delta`
- `@math.HAlign` and `@math.VAlign`

### Fixed 

- `@system.realtime_timer_system` bug fixed 

### Changed 

- `@backend.draw_text`: add argument `baseline` and `align`
- `@sprite.Text`: add fields `baseline` and `align`; so as `Text::new`

## [0.17.1] - 2025-09-30

### Added 

- `@backend.load_font`: dynmaically loading fonts

## [0.17.0] - 2025-09-26

### Added

- Update documentations for `@system` and `@input`. 

### Changed

- Function `@system.timeout` argument `pausible` is now optional and `true` by default.
