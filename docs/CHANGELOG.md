# Changelog

## [Unreleased]

## [0.26.2] - 2026-03-09

### Fixed

- `selene-raylib` now gates lit textured sampling per material texture slot instead of treating any texture as a full textured stack, so materials with only `base_color_texture` no longer run the normal-map path through the flat fallback normal texture
- `examples/pixeladventure` now keeps birds out of the player's physics collision mask, resolves player/bird hits with a fixed-step swept contact classifier, and preserves stomp bounce velocity into the next player update, so birds no longer act like moving platforms and stomps recover their natural rebound
- `examples/pixeladventure` now runs bird contact handling after each fixed physics step and centers the `Score` HUD within the visible playfield instead of the full canvas, so player/bird collisions use fresh physics results and the score label no longer sits left of the gameplay centerline
- `selene-raylib` shutdown cleanup now resets cached lit/shadow materials back to raylib's default material state before unloading them, so `cleanup_resources()` no longer double-unloads shared custom shaders or material-map textures on app exit

## [0.26.1] - 2026-03-08

### Fixed

- `selene-raylib` lit `StandardMaterial3D` rendering now binds white fallback maps / a flat normal map and keeps shader-side scalar-factor fallbacks when a material has no textures at all, so pure-color 3D materials preserve `base_color` / `roughness` / `metallic` / `emissive_color` instead of rendering black from unbound secondary texture samples

## [0.26.0] - 2026-03-08

### Added

- `scene3d` glTF importing now accepts binary `.glb` containers, bufferView-backed embedded images, glTF texture sampler metadata, imported camera nodes, and `KHR_lights_punctual` node lights
- `scene3d` glTF importing now reads additional core mesh/animation data: multiple `TEXCOORD_n` sets, `COLOR_0`, `TANGENT`, `JOINTS_1` / `WEIGHTS_1`, morph targets, morph-weight animation channels, and plain `.gltf` `data:` asset URIs
- `scene3d` animation importing now parses glTF `CUBICSPLINE` samplers into keyed in/out tangents instead of collapsing them to linear interpolation
- `scene3d` glTF importing now supports sparse accessors, including sparse-only accessors without a base `bufferView` and sparse overrides layered over base vertex/index payloads
- `scene3d` glTF importing now parses `KHR_texture_transform` for glTF material texture slots and carries the authored UV transform into triangle-mesh rendering backends
- `scene3d` glTF importing now parses `KHR_materials_unlit`, and imported unlit materials bypass PBR lighting in both `selene-webgpu` and `selene-raylib`

### Changed

- `render3d` now exposes richer glTF-facing 3D asset types: `TextureWrap3D`, `TextureFilter3D`, `TextureSampler3D`, `TextureBinding3D`, extended `StandardMaterial3D` texture/factor fields, and orthographic camera size data in `FrameCamera3D` / `Camera3DComponent`
- `render3d`'s public helper surface now also exports `TextureTransform3D`, `Tangent3D`, `DirectionalLightShadowMap3D`, `PointLightShadowMap3D`, `CascadeShadowConfigBuilder3D`, and `CascadeShadowConfig3D`, plus the constructor/config helpers `default_texture_sampler3d`, `default_texture_transform3d`, `apply_texture_transform3d`, `texture_binding3d`, `default_directional_light3d`, `default_point_light3d`, `default_spot_light3d`, `default_directional_light_shadow_map3d`, `default_point_light_shadow_map3d`, `default_cascade_shadow_config_builder3d`, `build_cascade_shadow_config3d`, `default_cascade_shadow_config3d`, `set_directional_light_shadow_map3d`, `get_directional_light_shadow_map3d`, `set_point_light_shadow_map3d`, `get_point_light_shadow_map3d`, and `mesh_asset`
- `render3d` mesh/material/light data models changed in place: `TriangleMesh3D` now stores `uv_sets`, `tangents`, and `colors` instead of a single optional `uvs`; `triangle_mesh(...)` now accepts `tangents`, `colors`, and `uv_sets`; `StandardMaterial3D` texture fields now use `TextureBinding3D?` instead of raw `ImageHandle?` and add `normal_scale`, `metallic_roughness_texture`, `occlusion_texture`, `occlusion_strength`, `alpha_cutoff`, `double_sided`, and `unlit`; `DirectionalLight3D` adds `shadow_depth_bias`, `shadow_normal_bias`, and `cascade_shadow_config`; `PointLight3D` / `SpotLight3D` add `shadows`, `shadow_depth_bias`, `shadow_normal_bias`, and `shadow_map_near_z`; `Mesh3DRenderer` adds `cast_shadows` / `receive_shadows`; `RenderItem3D`, `RenderFrame3D`, `FramePointLight3D`, `FrameSpotLight3D`, and `FrameCamera3D` now carry the corresponding extracted shadow/camera state
- `render3d` directional lights now expose Bevy-aligned shadow bias tuning (`shadow_depth_bias`, `shadow_normal_bias`) plus `default_directional_light3d()` for constructing updated light values
- `render3d` point and spot lights now mirror Bevy-style shadow controls with `shadows`, `shadow_depth_bias`, `shadow_normal_bias`, `shadow_map_near_z`, plus `default_point_light3d()` / `default_spot_light3d()` helper constructors; `scene3d` glTF light import and the `scene3d` example now build lights through those defaults
- `render3d` now exposes Bevy-style global shadow-map resources through `DirectionalLightShadowMap3D` / `PointLightShadowMap3D`, along with `set_*` / `get_*` helpers, so backends can configure directional/spot and point shadow resolution without editing backend constants
- `render3d` directional lights now carry Bevy-style cascaded shadow configuration through `CascadeShadowConfigBuilder3D` / `CascadeShadowConfig3D`, plus `build_*` / `default_*` helpers for matching Bevy's default cascade split and overlap behavior
- `render3d` mesh renderers and extracted 3D render items now carry Bevy-style `cast_shadows` / `receive_shadows` toggles so backends can skip shadow casting and receiving per object instead of treating every visible mesh the same
- triangle-mesh data now keeps full authored UV/color/tangent payloads (`uv_sets`, `colors`, `tangents`) so glTF vertex attributes survive import, skinning, morphing, and backend submission instead of collapsing to a single optional UV stream
- `animation3d`'s public API now includes `ChannelInterpolation3D::CubicSpline`, `WeightKeyframe3D`, `MorphTargetBinding3D`, `MorphMeshBinding3D`, `bind_morph_mesh(...)`, and `clear_morph_mesh(...)`; `AnimationChannel3D` now carries `weights`, `Vec3Keyframe3D` / `QuatKeyframe3D` now expose optional `in_tangent` / `out_tangent`, and `SkinnedMeshBinding3D` now tracks `target_entity`, `uv_sets`, `colors`, `tangents`, `morph_targets`, and `morph_weights`
- `animation3d` deformable-mesh bindings now track `target_entity`, morph targets, morph weights, UV sets, tangents, and vertex colors so glTF node-weight animation and per-instance deformation stay aligned with the imported scene graph
- `animation3d` keyframe types and runtime sampling now preserve cubic Hermite tangents for translation, rotation, scale, and morph-weight channels instead of treating every non-step glTF sampler as linear
- `camera3d.Camera3DComponent` and extracted `FrameCamera3D` now include `orthographic_size`, so orthographic scene import and backend submission no longer depend on fixed backend defaults
- `render.Color` now derives `Eq` and `Show`, so the richer 3D/animation structs embedding colors remain comparable and inspectable through the public MoonBit API
- `selene-raylib` triangle-mesh rendering now consumes selected glTF UV sets and imported vertex colors instead of forcing `TEXCOORD_0` + white vertex color for every imported triangle mesh
- `selene-webgpu` lit 3D triangle rendering now carries imported vertex colors, selected glTF UV sets, emissive color, and alpha-mode metadata into the shader path instead of flattening everything down to base color plus one implicit UV stream
- `selene-raylib` directional shadow filtering now uses per-light shadow bias tuning and weighted PCF sampling to reduce acne and hard-edged aliasing on shadowed surfaces
- the `examples/scene3d` demo now uses elevated casters, a dedicated shadow receiver wall, and brighter lighting balance so WebGPU and raylib shadow behavior is easier to verify visually

### Fixed

- imported glTF orthographic cameras now render through both `selene-webgpu` and `selene-raylib` instead of collapsing to the old perspective-only path
- extracted directional lights now respect their entity/global rotation when building render frames, so authored and imported light nodes no longer keep using stale local-space directions
- orthographic 3D cameras now use their authored orthographic extents for visibility testing instead of treating orthographic views as effectively unbounded during extraction
- `selene-raylib` now loads embedded glTF image data from data URIs and applies glTF wrap/filter sampler settings to base-color textures
- `selene-raylib` alpha-mask materials now honor `alphaCutoff` in shader instead of warning and falling back to plain alpha blending
- imported glTF vertex colors, alternate UV sets, normalized integer UV/color accessors, morph targets, and 8-influence skinning data now reach runtime meshes instead of being dropped during import
- scene-instantiated skinned and morphed meshes now clone their mesh assets per instance before deformation, fixing shared-mesh corruption when the same glTF scene is instantiated multiple times
- `selene-webgpu` lit 3D shaders now honor glTF `alphaMode=Mask` / `alphaCutoff` and add scalar emissive color on imported triangle meshes instead of treating every textured material as plain alpha-blended Lambert shading
- `selene-webgpu` imported triangle meshes now consume `emissiveTexture` and shared-UV repeat/clamp sampler behavior when the material texture stack shares one UV set, bringing common glTF emissive materials closer to authored output
- `selene-webgpu` imported triangle materials now keep independent glTF UV channels per texture map instead of collapsing the whole material to the primary texture's `TEXCOORD_n`
- `selene-webgpu` imported triangle materials now preserve glTF wrap/clamp sampler selection per texture map instead of forcing the whole material stack onto one shared sampler
- `selene-raylib` now binds glTF `emissiveTexture`, `metallicRoughnessTexture`, `occlusionTexture`, and `normalTexture` through its lit-material path instead of only consuming `baseColorTexture`
- single-sided glTF materials now honor `doubleSided=false` in both `selene-webgpu` and `selene-raylib` instead of rendering every imported triangle mesh as effectively double-sided
- non-base glTF texture slots now honor `KHR_texture_transform` in `scene3d` import and `selene-webgpu`; `selene-raylib` now also honors per-texture transforms when the material texture stack shares one UV set instead of dropping secondary textures with different transforms
- `selene-raylib` directional lights with `shadows = true` now render and sample shadow maps for every supported directional light slot instead of only shadowing the first enabled light; primitives, triangle meshes, and alpha-mask casters all participate
- `selene-raylib` now renders Bevy-style shadowed point and spot lights through local shadow atlases, and all directional/point/spot shadow passes now respect per-object `cast_shadows` / `receive_shadows` flags instead of forcing every visible mesh to both cast and receive shadows
- `selene-raylib` shadow passes now size directional/spot and point shadow maps from extracted `render3d` shadow-map resources instead of baking 2048/1024-sized shadow targets into backend constants
- `selene-raylib` directional shadows now render Bevy-style cascades into per-light atlases and blend overlap regions in the lighting shader instead of projecting the whole camera range through one directional shadow matrix
- `selene-webgpu` now renders Bevy-style directional cascades plus point and spot shadow maps, honoring extracted shadow-map sizes and per-object `cast_shadows` / `receive_shadows` flags instead of treating all WebGPU 3D lighting as unshadowed direct light
- `selene-webgpu` primitive meshes (`Cube` / `Sphere` / `Cylinder` / `Plane`) now submit through the lit 3D pipeline with corrected face winding and material metadata instead of bypassing lighting and shadow receiving via the unlit color-triangle path
- `selene-webgpu` shadow atlas sampling now uses WebGPU-correct texture-space coordinates, fixing browser runs where generated shadow maps still produced inverted or fully black receivers

## [0.25.1] - 2026-03-06

### Changed

- pointer-capture mode now stays opt-in but starts unlocked; games that call `@system.lock_mouse()` will capture the pointer only after the player clicks inside the game window

### Fixed

- raylib apps no longer let the engine quit through raylib's default `Escape` exit key; pressing `Escape` now releases active mouse capture instead of closing the game window

## [0.25.0] - 2026-03-06

### Added

- release and CI now include a `check_no_legacy_ui` guard that rejects legacy `style`, legacy UI helper APIs, and sprite overlay UI paths
- `selene/ui` now exports Bevy-aligned UI component/state maps: `background_colors`, `border_colors`, `border_radii`, `buttons`, `computed_ui_nodes`, `focus_policies`, `focusables`, `focuseds`, `global_ui_nodes`, `interactions`, `nodes`, `outlines`, `scroll_positions`, `tab_indexes`, `text_colors`, `text_fonts`, `text_layouts`, `texts`, `ui_images`, `ui_scale_mode`, and `ui_zindexes`
- `selene/ui` now exports typed UI event buses and focus helpers: `click_event_bus`, `focus_in_event_bus`, `focus_out_event_bus`, `navigation_event_bus`, `pointer_enter_event_bus`, `pointer_leave_event_bus`, `pointer_down_event_bus`, `pointer_up_event_bus`, `focus`, `focused_entity`, `hovered_entity`, `is_ui_entity`, `get_ui_scale_mode`, and `set_ui_scale_mode`
- `selene/ui` now exports Bevy-style authored types and constructors: `BackgroundColor`, `BorderColor`, `BorderRadius`, `ComputedUiNode`, `Display`, `FlexDirection`, `FocusPolicy`, `Focusable`, `Focused`, `GlobalUiNode`, `ImageFit`, `Outline`, `Overflow`, `PositionType`, `ScrollPosition`, `TabIndex`, `Text`, `TextColor`, `TextFont`, `TextLayout`, `TextOverflow`, `TextWrap`, `UiClickEvent`, `UiFocusInEvent`, `UiFocusOutEvent`, `UiImage`, `UiInsets`, `UiNavigationDirection`, `UiNavigationEvent`, `UiPointerDownEvent`, `UiPointerEnterEvent`, `UiPointerLeaveEvent`, `UiPointerUpEvent`, `UiRectValues`, `UiScaleMode`, `UiZIndex`, and `Val`
- `selene/ui` now splits the runtime into `ui_layout_system`, `ui_interaction_system`, `ui_extract_system`, and `ui_prepare_system`, and UI submission now flows through `frame2d.ui_commands`
- `selene/ui` now exposes UI utility helpers `parse_color`, `rgba`, `transparent`, and `blur`

### Changed

- `Node` was redesigned from the old `NodeSize` / `LayoutDirection` / `UiSpace` / `offset` model into a Bevy-style box model with `width`, `height`, `min_width`, `min_height`, `max_width`, `max_height`, `left`, `right`, `top`, `bottom`, `margin`, `padding`, `border`, `display`, `position_type`, `flex_direction`, `justify_content`, `align_items`, `row_gap`, `column_gap`, `overflow_x`, `overflow_y`, `flex_grow`, `flex_shrink`, and `active`; `Node::new` and `Node::absolute` now follow that layout model
- `Button` changed from `enabled + trigger + hit_size` to a lightweight interactive marker with `Button::new(enabled?)`; hit testing and click generation now come from the unified UI interaction pipeline instead of button-local mouse settings
- `Interaction` still uses `None | Hovered | Pressed`, but it now represents current state only; the old `InteractionEvent` stream was replaced by typed pointer, focus, click, and navigation events
- text authoring changed from the old single-style flow to `Text` + `TextFont` + `TextColor` + `TextLayout`; image authoring changed from sprite/overlay usage to `UiImage`; layout outputs changed from `layout_sizes` to `computed_ui_nodes` and `global_ui_nodes`
- `FocusPolicy` now controls pointer hit propagation (`Block | Pass`), while focus participation and ordering moved to `Focusable`, `Focused`, and `TabIndex`
- the exported `nodes`, `buttons`, and `interactions` maps still exist but now store the new Bevy-aligned semantics instead of the old helper-driven `Ui` / root-space model
- examples, docs, and engine wiring now target the unified UI node tree instead of mixed `style` + old `ui` + sprite overlay semantics
- `selene-raylib` capability warnings now describe the 3D backend as a non-PBR Blinn-Phong lighting path and no longer claim that spot lights collapse to point lights

### Fixed

- `selene-raylib` 3D lighting now runs through a shared shader-based per-pixel path for primitives and triangle meshes, restoring directional, point, and spot light shaping instead of the previous per-instance tint approximation
- top-level absolute UI nodes now layout against an internal implicit root, fixing migrated HUD examples such as `pixeladventure` rendering at the top-left instead of their intended viewport positions
- viewport-scaled UI text now applies the same overall zoom factor during measurement and submission, restoring readable HUD/menu font sizes across examples

### Removed

- deleted the legacy `selene/style` package and all of its public APIs: `add_widget`, `layout_sizes`, `screen_pixel_root`, `screen_root`, `style_system`, `styles`, `Flex`, `SizePlan`, and `Style::new`
- removed the old `selene/ui` helper/root API surface: `UI_ZINDEX`, `add_node`, `add_button`, `interaction_event_bus`, `layout_sizes`, `screen_root`, `virtual_root`, `uis`, `ui_button_system`, `Ui`, `UiSpace`, `NodeSize`, `LayoutDirection`, `MainAxisAlign`, `CrossAxisAlign`, and `InteractionEvent`
- removed the documented legacy UI workflow built around `style`, public UI roots, and sprite-overlay authoring; the supported path is now the unified `selene/ui` node tree only

## [0.24.4] - 2026-03-06

### Added

- `selene/sprite` now provides explicit overlay helpers for non-`@ui` HUD migration: `set_overlay_space(entity, space=Virtual)` and `clear_overlay_space(entity)`

### Fixed

- raylib textured primitive rendering now routes `Cube`/`Plane`/`Sphere` through raylib mesh+material draw calls, restoring visible `base_color_texture` details in single-run 3D scenes
- docs now explicitly describe world-vs-overlay submission semantics for 2D over 3D composition and the non-`@ui` overlay opt-in path

## [0.24.3] - 2026-03-06

### Fixed

- raylib runtime cleanup now clears cached texture/sound/font and 3D synced-asset maps after unload, preventing stale resource handles from causing white/missing textures across multiple `App::run()` sessions

## [0.24.2] - 2026-03-06

### Fixed

- raylib backend now emits one-shot `texture-warning` diagnostics for 3D texture fallback cases (`base_color_texture` handle missing, texture load failure, or triangle UV mismatch/missing), making white-material fallbacks directly debuggable

## [0.24.1] - 2026-03-05

### Fixed

- `scene3d` example overlay label now uses the overlay 2D pass, so 3D content no longer covers HUD text
- Rapier 2D interaction-group matching switched to `Or` semantics to restore Selene collision-filter expectations for one-sided mask declarations
- `survivors` bullets now keep a brief render window on hit/despawn and use a clearer visual sprite offset, avoiding "firing without visible projectile" frames
- raylib 3D primitive rendering (`Cube`/`Plane`/`Sphere`/`Cylinder`) now samples `base_color_texture` when present instead of falling back to flat base-color shading
- raylib backend now emits a capability warning when `StandardMaterial3D.alpha_mode` is `Mask`, clarifying the current fallback to alpha blending

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
