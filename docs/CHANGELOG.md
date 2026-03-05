# Changelog

## [0.24.0] - 2026-03-05

### Added

- Bevy-aligned core runtime modules:
  - `selene/state` (`State`, `NextState`, `in_state`, `on_enter`, `on_exit`)
  - `selene/system_set` (`SystemSet`, `in_set`, `before`, `after`)
  - `selene/commands` (queued structural/world changes with frame/fixed flush)
  - `selene/query` (`Query`, `With`, `Without`, `Added`, `Removed`, `Changed`)
  - `selene/input_action` (action map + action event bus)
  - `selene/visibility` (`Visibility`, `InheritedVisibility`, `ViewVisibility`, `RenderLayers`)
  - `selene/asset2` (`AssetState`, typed asset lifecycle events)
  - `selene/scene` (`SceneSpawner`, `SceneInstanceReadyEvent`, scene-level animation helpers)
- New `selene/animation3d` module with clip/player/graph workflow:
  - clip registration (`register_animation_clip`)
  - player control (`play_clip`, `play_state`, `set_animation_graph`, `trigger_animation`)
  - runtime systems (`animation3d_player_system`, `animation3d_skinning_system`)

### Changed

- `system.App` scheduler now supports Bevy-style stage gating and ordering:
  - `OnEnter` / `OnExit` schedule matching
  - `run_if` conditions
  - set-based ordering (`in_set/before/after`) with per-stage sorting
  - command/entity flush integrated into both frame and fixed loops
- Default plugins now wire `input_action`, state transition flow, visibility propagation, scene cleanup, and 3D animation+skinning systems
- `scene3d` glTF pipeline now parses and instantiates animation/skin data:
  - animation samplers/channels (translation/rotation/scale)
  - skin joints + inverse bind matrices
  - JOINTS_0/WEIGHTS_0 vertex influences and runtime CPU skinning updates
- `render3d_extract_system` now honors visibility/render layers and applies perspective frustum culling (`fov/aspect/near/far`) during extraction
- `platform_render` now exposes `capability_warning(feature, fallback)` and raylib backend emits explicit downgrade warnings for unsupported features
- `commands.spawn()` now follows deferred structural-change semantics (reserved entity id + flush activation) via entity lifecycle `PendingSpawn`
- `query` now provides reader/cursor-based delta consumption (`QueryReader`, `QueryDelta`) for `added/removed/changed` semantics
- `scene3d`/`tilemap` runtime bytes loading moved to `asset2.read_bytes`, and examples direct asset loads are migrated to `asset2` APIs
- `scene3d` example now uses `selene/scene` entry APIs instead of direct `scene3d` calls

### Fixed

- 2D frame submission is now split into world and overlay passes; UI overlay commands render after 3D on both webgpu and raylib backends
- raylib 3D shading now consumes scene lighting fields (`ambient` / `directional` / `point` / `spot`) instead of rendering purely with raw material base color
- Web pointer lock now only requests capture when mouse lock is explicitly enabled; default canvas clicks no longer force pointer capture
- Disabling mouse lock now actively exits browser pointer-lock state
- Web keyboard input now ignores browser key-repeat keydown events to preserve stable `just_pressed` semantics
- `pixeladventure` jump SFX trigger migrated to player-state enter (`Jump`) semantics, preventing repeated jump audio during a single jump action
- Legacy `backend.request_close` path removed from core backend surface (window close control remains in `system.exit` / `platform_window`)

## [0.23.2] - 2026-03-05

### Added

- New typed event module `Milky2018/selene/event` with `Events<T>`, `EventReader<T>`, `EventWriter<T>`, `Trigger<T>`, and observer APIs (`observe_global`, `observe_entity`, `unobserve`)
- Tiled (`.tmj`) map support in `selene/tilemap`, including:
  - `load_tiled_map` and `TiledMap::from_tiled_json`
  - Layer/object/tileset typed data model and lookup helpers
  - Global tile ID flip-flag decode/encode (`decode_tiled_gid`, `encode_tiled_gid`)
- Standard input event channels in `selene/inputs`:
  - `key_input_event_bus`
  - `mouse_button_event_bus`
  - `mouse_motion_event_bus`
  - `gamepad_connection_event_bus`
  - `gamepad_button_event_bus`
  - `gamepad_axis_event_bus`
- Bevy-style runtime `AudioSink` control methods in `selene/audio`:
  - `AudioSink::set_volume`, `AudioSink::set_speed`
  - `AudioSink::set_paused`, `AudioSink::set_muted`
  - `AudioSink::pause`, `AudioSink::play`, `AudioSink::stop`
  - `AudioSink::mode`, `AudioSink::volume`, `AudioSink::speed`, `AudioSink::paused`, `AudioSink::muted`, `AudioSink::stopped`, `AudioSink::finished`

### Changed

- `selene/ui` interaction events migrated to event bus form: `interaction_event_bus`
- `selene/physics2d` collision/trigger/pointer events migrated to event bus form:
  - `contact_event_bus`
  - `trigger_event_bus`
  - `pointer_event_bus`
- `selene/physics3d` contact/trigger events migrated to event bus form:
  - `contact_event_bus3d`
  - `trigger_event_bus3d`
- `cards`, `pixeladventure`, and `survivors` examples migrated to reader-based event consumption
- `selene/audio` playback flow now follows Bevy-style semantics:
  - `PlaybackSettings` is applied when creating a sink
  - runtime playback state is controlled via `AudioSink`
  - `audio_playback_system` no longer re-applies `PlaybackSettings` every frame to active sinks

### Fixed

- Web audio one-shot replay loop caused by re-playing ended instances
- `pixeladventure` jump tuning (`JUMP_V` reduced from `680.0` to `560.0`) to avoid over-high jump arcs

### Removed

- `@system.defer_event` and `@system.deferred_event_system`
- Array-pull event APIs removed in favor of typed event buses:
  - `@ui.interaction_events()`
  - `@physics2d.contact_events()`
  - `@physics2d.trigger_events()`
  - `@physics2d.sensor_events()`
  - `@physics2d.pointer_events()`
  - `@physics2d.collision_events()`
  - `@physics3d.contact_events3d()`
  - `@physics3d.trigger_events3d()`

## [0.23.1] - 2026-03-04

### Added

- Bevy-style ECS audio model in `selene/audio`: `AudioPlayer`, `PlaybackSettings`, `PlaybackMode`, `AudioSink`
- Audio playback lifecycle APIs: `attach_audio`, `spawn_audio`, `restart_audio`, `stop_audio`, `set_global_volume`

### Changed

- `platform_audio` interface migrated to instance-based control (`play_audio -> AudioInstance`, plus `set_volume/set_speed/set_loop/set_paused/stop/is_finished/tick`)
- `selene-webgpu` and `selene-raylib` audio implementations now support per-instance runtime playback control
- `pixeladventure` sound triggers migrated from direct `@audio.play_audio(...)` calls to explicit `AudioHandle + spawn_audio(...)` usage

## [0.23.0] - 2026-03-04

### Added

- Platform-layer interface packages: `platform_window`, `platform_input`, `platform_render`, `platform_audio`, `platform_asset_io`
- Shared runtime config package `platform_runtime` (`WindowConfig`, `RunnerCallbacks`)
- Core runtime modules: `time`, `asset`, `asset_types`, `render2d`, `render2d_types`, `render_pipeline`, `render_submit`, `system.exit`
- Handle-based 2D frame command model (`ImageDrawCommand2D`, `TextDrawCommand2D`, `TextStyle2D`, shape commands)
- Pull-based input snapshot path in core (`inputs.apply_input_snapshot`)

### Changed

- Unified render submission to a single frame object (`RenderFrame`) combining 2D/3D extraction output
- `App::run` loop migrated to platform poll + submit flow (window/input/render/audio split responsibilities)
- 2D render commands migrated to asset-handle-driven types (`ImageHandle` / `FontHandle`) instead of direct backend draw payloads
- `scene3d`/examples runtime APIs migrated from backend-facing calls to `asset` / `time` / `render2d` paths
- Style/text layout sizing path now uses backend/platform text measurement

### Removed

- Legacy high-level backend usage path from core gameplay flow (`draw_*`, backend-side time/asset/font control semantics)
- Legacy 2D draw command structs from `selene/render` (kept as color semantics only)

## [0.22.2] - 2026-03-04

### Changed

- Roll-forward release for the latest engine/runtime updates shipped in `0.22.1`

### Added

- `ShiftLeft` keyboard input mapping across core/web/raylib input paths
- UI alignment controls in `selene/ui` (`MainAxisAlign`, `CrossAxisAlign`)
- Scene part indexing APIs in `scene3d` (`SceneInstance`, `instantiate_scene_instance`, `scene_instance_part`)

### Fixed

- 3D frame clear-color synchronization between extracted render frame and backend submission
- Raylib textured triangle runtime tint/alpha handling for material-driven rendering

## [0.22.1] - 2026-03-04

### Added

- Triangle mesh path for `render3d` assets with optional UV/normal payloads
- Frame-space spotlight data extraction (`FrameSpotLight3D`) and world-space light transform handling
- WebGPU lit-triangle pipelines with multi-light uniforms (directional + point + spot)
- `Code::ShiftLeft` keyboard input support across backend mappings
- UI layout alignment controls in `selene/ui` (`MainAxisAlign` + `CrossAxisAlign`)
- `scene3d` scene instance APIs for part-level indexing (`SceneInstance`, `instantiate_scene_instance`, `scene_instance_part`)

### Changed

- `scene3d` glTF loading path now parses mesh primitives with accessor/buffer data, including normals/UVs
- `scene3d` example updated to a dynamic spotlight demo and sharper cube shading for clearer edge perception
- `render3d_extract_system` now emits frame-local point/spot light data including world position and direction
- 3D frame clear-color submission is now unified from extracted frame data for both web and raylib backends
- Raylib triangle-mesh render path now uses material texture + tint in runtime rendering

### Fixed

- WebGPU lighting submission protocol mismatch between MoonBit and JS runtime (array-packed light data)
- 3D textured/colored triangle rendering sync for normals-aware shading in the unified backend path
- Missing `KeyZ` conversion branch in `Code::from_string`
- Missing runtime `tint/alpha` application on textured triangle meshes in raylib backend
- 3D background clear mismatch where extracted camera clear color was not consistently applied

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
