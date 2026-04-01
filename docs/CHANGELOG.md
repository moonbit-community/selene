# Changelog

## [Unreleased]

### Added

- Added `selene/editor_bridge` built-in component metadata APIs for editor-facing component workflows: `BuiltinComponentKind`, string/enum mapping helpers, category/dependency queries, removability checks, default component factories, and ordered built-in component enumeration.
- Added `docs/bevy-alignment-tracker.md` as the canonical markdown tracker for ongoing Bevy parity work (`BEVY-001...`) with explicit status and queue ownership.
- Added `docs/bevy-rapier3d-parity-matrix.md` as the formal gap matrix for `selene/physics3d` vs `bevy_rapier3d`, with per-area status and explicit remaining closure steps.

### Changed

- Changed `selene/editor_bridge` animation asset model from a single `.anim.json` document to Bevy-style split clip/graph assets (`AnimationClipAssetDocument` + `AnimationGraphAssetDocument`) and updated loader/runtime scene instantiation to resolve graph -> clip -> atlas dependencies.
- Changed `selene-editor` typed protocol and preview payloads to carry separate animation clip/graph resources (`AnimationClipLoad/Save`, `AnimationGraphLoad/Save`, `AnimationMigrate`) instead of the legacy single animation document RPC flow.
- Changed `selene-editor` Animation Graph Inspector from summary-only form fields to node/edge authoring workflow (`add clip/blend/additive node`, `remove node`, `set default node`, clip-path editing, and edge target/weight editing).
- Changed `selene-editor` Entity Inspector animation editing from generic JSON to typed controls for `AnimationPlayer` (`graph_asset_path`, `start_node`, `autoplay`, `repeat_mode`, `speed`) and `AnimationTransitions` (`duration`) with transactional scene edits.
- Changed `selene/editor_bridge` animation repeat semantics from ad-hoc strings to typed `AnimationRepeatModeDoc` (`Never` / `Forever` / `Count`) for component construction and runtime bridge mapping, while keeping canonical on-disk string representation (`never`, `forever`, `count:N`).
- Changed `selene-editor` Animation Graph Inspector preview workflow to include direct playback controls (`play/pause`, `speed`, `seek`), and extended preview bridge/runtime commands to apply those controls to selected animated entities (including negative-speed reverse preview).
- Changed `selene-editor` legacy animation migration UX to a user-confirmed batch workflow: detect `.anim.json`/legacy `animation_asset_path` usage, show modal `Migrate/Cancel`, run sequential `AnimationMigrate` RPCs with progress/failure reporting, and reload project resources automatically after successful completion.
- Changed `selene-editor` animation asset authoring flow to an explicit pipeline (`image -> atlas -> clip -> graph`): atlas creation now produces clip assets only, graph creation is a dedicated action on selected clips, and Assets toolbar now exposes `New Atlas` / `New Clip` / `New Graph` entrypoints bound to current resource selection.
- Changed `selene-editor` Animation Graph Inspector UX by adding a visual graph canvas panel (positioned node view + click-to-set-default) alongside structured node/edge form editing.
- Changed `selene-editor` Animation Graph canvas interaction to support direct node drag repositioning on the visual graph panel, wired end-to-end through typed frontend messages with app-level wbtest coverage.
- Changed `selene-editor` Animation Graph canvas interaction to support direct edge connect drawing (`Alt+click source node -> Alt+click target node`) with stateful source-node highlighting and wbtest coverage.
- Changed `selene-core` and `examples` to use `Milky2018/moon_rapier@0.4.0`.
- Changed `selene-editor` Entity Inspector to a Unity-style component stack with per-component cards, collapse state, card action menus, and an integrated `Add Component` search panel.
- Changed `selene-editor` entity component editing flow to support built-in component add/remove with strong dependency rules (`auto-add required chain` + `block destructive removal`) and transactional undo/redo.
- Changed `selene-editor` custom gameplay component authoring flow to support generic JSON components (`kind + data`) with draft validation and explicit commit to scene state.
- Changed `selene-editor` Assets panel rendering to a Rabbita state-driven tree model: folder expand/collapse now flows through `Model/Msg/update` (`asset_tree_expanded` + `ToggleAssetTreeFolder`) instead of view-only flattening.
- Changed `selene-editor` Assets tree UX to auto-expand ancestor folders on resource selection, force-expand matches while search filtering, and surface full resource paths in the bottom info bar on tree row hover.
- Changed `selene-editor` Assets tree controls to include explicit `Expand All` / `Collapse All` actions for folder visibility management.
- Changed `selene-editor` keyboard UX to add asset-tree folder shortcuts: `]` for expand-all and `[` for collapse-all.
- Changed `selene-editor` asset-tree interaction so double-clicking a resource row inserts the resource into the current scene directly.
- Changed `selene-editor` Assets panel action affordance by adding `Insert Selected` and `Clear` controls and resource-type glyphs (`I/A/N/P`) on tree file rows.
- Changed `selene-editor` keyboard UX to add `I` for inserting the currently selected asset resource into the scene.
- Changed `selene-editor` viewport help copy to document asset-tree shortcuts (`I`, `]`, `[`), reducing hidden-key discoverability issues.
- Changed `selene-editor` Assets panel ergonomics by making selection/search/action controls sticky at panel top while scrolling long asset trees.
- Changed `selene-editor` Assets tree folder rows to publish full folder paths to the bottom info bar on hover (matching file-row discoverability).
- Changed `selene-editor` Assets toolbar to show visible resource counts (`items` / `filtered items`) so filter impact is immediately observable.
- Changed `selene-editor` asset keyboard workflow to support `↑/↓` resource traversal and `Enter` insertion for the current selection, matching the Assets tree ordering and section visibility.
- Changed `selene-editor` keyboard/navigation UX to add global `Esc` selection clear and `Cmd/Ctrl+F` asset-search focus, reducing pointer-only interaction overhead.
- Changed `selene-editor` selection feedback UX so asset/resource selection updates the bottom status bar with current focus context (including keyboard traversal index), improving orientation during keyboard-first editing.
- Changed `selene-editor` keyboard asset navigation to support `Home`/`End` first/last jumps and auto-scroll the Assets tree to keep the current keyboard-selected resource visible.
- Changed `selene-editor` Assets search discoverability by adding `/` quick-focus (in addition to `Cmd/Ctrl+F`) and surfacing both shortcuts in the search placeholder text.
- Changed `selene-editor` Assets search keyboard flow so pressing `Esc` inside the search input clears the filter and blurs the field for immediate return to global editor shortcuts.
- Changed `selene-editor` asset keyboard navigation to add `PageUp/PageDown` stepped traversal and added a dedicated `Clear Filter` control in the Assets toolbar.
- Changed `selene-editor` empty-filter state UX to show a one-click `Reset Filter` action when no assets match the current query.
- Changed `selene-editor` Assets summary line to include per-type counts (`img/atlas/anim/prefab`) for both full and filtered views.
- Changed `selene-editor` resource-selection UX to auto-expand the matching Assets section (`Images`/`Atlases`/`Animations`/`Prefabs`) when selection is driven by editor actions.
- Changed `selene-editor` Assets filter feedback so entering a query updates status with the active filter term, while clearing the query reports `Asset filter cleared`.
- Changed `selene-editor` filtering behavior to automatically clear an asset selection when the selected resource is no longer visible under the active filter, avoiding hidden stale selection state.
- Changed `selene-editor` global `Esc` behavior to close Inspector transient UI (component panel/menu) before clearing entity/resource selection, reducing accidental focus loss.
- Changed `selene-editor` entity selection feedback to surface `Selected entity: ...` in the status bar when selecting from Scene Tree/Viewport.
- Changed `selene-editor` Add Component panel keyboard UX so pressing `Esc` in component search/custom-kind inputs closes the panel immediately.
- Changed `selene-editor` Add Component custom-kind input so pressing `Enter` submits `Add custom component` directly without requiring a button click.
- Changed `selene-editor` filter mode behavior to ignore manual asset-section collapse state (`Images/Atlases/Animations/Prefabs`) so matching results remain visible and keyboard-selectable while filtering.
- Changed `selene-editor` Add Component panel open behavior to autofocus the component search input automatically, reducing pointer-only interaction.
- Changed `selene-editor` Add Component panel UX so existing built-in components render as disabled (`Existing`) entries with explicit hover hints, and added search-result feedback (`matching count` + empty-state message) to reduce no-op clicks and unclear filter outcomes.
- Changed `selene-editor` Scene Browser layout to keep current-scene controls fixed while the scene list scrolls independently, and added an explicit `All Scenes (N)` list header for better orientation in multi-scene projects.
- Changed `selene-editor` top Options UX to make move-snap step first-class: added `- / +` controls with a visible step readout, wired matching keyboard shortcuts (`-` / `+`), and surfaced current snap mode/step in the bottom info bar default text.
- Changed `selene-editor` Scene Tree interaction UX so rows are clearly interactive (`hover`/pointer affordance), publish entity hints to the bottom info bar, and support double-click-to-frame for faster camera navigation.
- Changed `selene-editor` component editing flow to add a direct `C` shortcut for opening the Inspector `Add Component` panel when an entity is selected, and updated button copy to advertise the shortcut.
- Changed `selene-editor` Assets tree context retention to a VSCode-style sticky ancestor overlay: ancestors are derived from the first visible tree row and rendered in a dedicated sticky container, eliminating duplicate pseudo rows and preserving scroll context.
- Changed `selene-editor` Image resource Inspector to render an inline preview image (loaded from `/project/...`) with load/error state handling, instead of text-only metadata.
- Changed `selene-editor` preview bridge payload to carry explicit `scene_path`, and changed preview runtime scene sync to distinguish `scene switch` from `same-scene update` without heuristic fallback.
- Changed `selene-editor` project-load state handling to require typed workspace payloads; missing workspace state is now treated as a protocol failure instead of silently defaulting.
- Changed `selene/physics3d` parity verification coverage by extending 3D wbtests to include `QueryFilter` body-type filtering (`dynamic/fixed/kinematic`), exclude-entity/exclude-sensors/exclude-solids behavior, `cast_shape` filtering behavior, and collision/intersection event-bus mapping.
- Changed `selene/physics3d` joint parity verification coverage by adding 3D wbtests for all joint variants on both `ImpulseJoint` and `MultibodyJoint`, and documenting current rope/spring handle-routing semantics in the parity matrix.
- Changed `selene/physics3d` impulse `Rope/Spring` joint syncing to use generic-joint insertion (Bevy-style handle path), so these variants now expose stable impulse joint handles and share consistent `contacts_enabled` behavior with other impulse joint types.

### Fixed

- Fixed `selene/editor_bridge` project-manifest migration for legacy `animation_index` by mapping legacy `.anim.json` refs to v3 graph paths (`assets/animation_graphs/*.graph.json`) instead of copying invalid legacy paths into `animation_graph_index`.
- Fixed `selene-core` animation runtime reverse-playback behavior by allowing negative speed in `ActiveAnimation::set_speed` and updating playback/repeat/completion logic in `animation_player_system`.
- Fixed `selene-editor` project-open failure regression (`Project open failed. Check browser console for details.`) by completing clip/graph protocol migration across frontend/service/specs and ensuring project state + scene bundle decoding stays consistent.
- Fixed `selene-raylib` fallback text rendering/measurement spacing to use raylib-compatible default spacing (`1.0`) instead of `0.0`, reducing compressed default-font appearance when cosmic text rendering is unavailable.
- Fixed `selene/physics3d` moon_rapier `0.4.0` integration by updating multibody joint conversion to `GenericJoint3DReal` and driving `JointSet3DReal::solve` with `IntegrationParameters.num_solver_iterations`.
- Fixed `selene/collision` moon_rapier `0.4.0` compatibility by switching 2D pipeline CCD solver wiring from `dynamics.CCDSolver` to `dynamics_ccd.CCDSolver`.
- Fixed `selene-editor` selection stability so clicks outside the viewport canvas (for example inside Inspector panels) no longer trigger preview pick clearing and unexpectedly deselect the current entity.
- Fixed `selene-editor` Inspector Add Component UX by rendering the add panel directly below Inspector actions (instead of after the full component stack), so opening the panel is immediately visible even on long component lists.
- Fixed `selene-editor` Assets panel hierarchy readability by replacing the flat card list with a directory-preserving tree view (Explorer-style folder/file indentation), so scrolling no longer destroys path context.
- Fixed `selene-editor` Assets panel overflow regressions by separating the fixed `Filter Assets` toolbar from the scrollable tree viewport and moving ancestor stickiness into a dedicated header layer, eliminating horizontal overdraw into the viewport.
- Fixed `selene-editor` tree-row overflow with long resource names by enforcing truncation-safe flex constraints (`min-width: 0`, ellipsis labels, non-shrinking badges) across asset rows and scene browser rows.
- Fixed `selene-editor` long-name overflow in Assets/Scene trees by enforcing right-boundary ellipsis truncation from container layout constraints (`min-width: 0` + `overflow: hidden` + `text-overflow: ellipsis`) and making row badges shrinkable; also reduced baseline UI text size to improve dense tree readability and prevent boundary overflow under long names.
- Fixed `selene-editor` initial preview camera placement so first scene load aligns scene content to the viewport's top-left instead of leaving positive-coordinate scenes offset toward the center/right-bottom.
- Fixed `selene-editor` initial viewport alignment race by making camera top-left alignment explicit and retryable until required camera/projection state is ready, preventing first-load misalignment when scene data arrives before full preview setup.
- Fixed `selene-editor` workspace loading to stop silently falling back to defaults on invalid `.selene-editor/workspace.json`; project open now reports a deterministic error and preserves invalid-data visibility.

### Removed

- Removed persistent inline instructional hint blocks from `selene-editor` `Viewport` and `Assets` panels; interaction guidance now relies on controls/tooltips and the bottom info bar.
- Removed non-filter controls from `selene-editor` `Assets` toolbar (`Clear Filter`, `Expand All`, `Collapse All`, `Insert Selected`, `Clear`) and removed asset-filter focus shortcuts (`Cmd/Ctrl+F`, `/`) so this area now only exposes a plain `Filter Assets` input.

## [0.30.4] - 2026-03-31

### Added

### Changed

- Changed `selene-raylib` capability fallback log tag from `capability-warning` to `capability-note` to avoid mixing feature-degradation notices with runtime warning diagnostics.

### Fixed

- Fixed Moon package config deprecation warnings by migrating `options("supported-targets": ...)` to `options("supported_targets": ...)` across `selene-core`, `selene-webgpu`, `selene-raylib`, `selene-editor`, and example packages.
- Fixed deprecated parsing and boolean syntax warnings by replacing `@strconv.parse_*` with `@string.parse_*`, adding explicit `moonbitlang/core/string` imports where required, and replacing `not(expr)` with `!expr` in examples.
- Fixed `selene-raylib` texture sampler completeness for 3D materials by moving mipmap generation into texture-preparation (`sync_image_asset` + internal fallback textures), so draw-time sampler application no longer mutates GPU texture state.
- Fixed `selene-raylib` 3D material slot wiring so active maps (`texture0/1/2/4/5`) are driven by one slot table across shader locations, sampler units, and material-map uploads; roughness now consistently samples `metallicRoughnessSample.g` without a separate roughness texture slot.
- Fixed `selene-raylib` issue #23 sampler warning path by removing unconditional roughness-slot usage (`texture3`/`MaterialMapRoughness`), disabling fallback normal-map slot binding when no normal texture exists, and making shadow sampler uniforms bind to active shadow texture units only (fallback to unit `0` when absent), which removes `GLD_TEXTURE_INDEX_2D ... unloadable` warnings in the `cmd/min3dprobe` and `cmd/mooncraft` repro flows.
- Fixed `examples/scene3d` dynamic sphere instability by reducing initial launch velocity and adding damping + CCD to both free and jointed physics balls, preventing energy blow-up that made balls fly erratically.
- Fixed `examples/scene3d` spherical-joint anchor setup for the upper-right ball by correcting child/parent local anchor assignment (`local_anchor1` on child, `local_anchor2` on parent), eliminating large per-step constraint correction that caused visual flicker/jitter.
- Fixed `selene/math::Quat::to_rapier` 3D quaternion component order to match `moon_rapier/core.Quat(x, y, z, w)`, preventing invalid rigid-body rotation writeback that caused transform jitter/flicker in `examples/scene3d` (including the lower-left green sphere parent-child chain).

### Removed

## [0.30.3] - 2026-03-30

### Added

### Changed

- Changed `selene/render3d_types::TriangleMesh3D` and `selene/render3d::triangle_mesh(...)` to carry explicit triangle topology (`TriangleList` / `TriangleStrip` / `TriangleFan`) and optional index buffers, and propagated this data through `scene3d` parsing and animation skin/morph mesh rebinding.
- Changed `selene-webgpu` triangle submission to consume indexed/topology triangle meshes by triangulating index streams before packing vertex payloads.

### Fixed

- Fixed `selene-raylib` lit triangle rendering to support per-texture UV-set selection (`TEXCOORD_0` / `TEXCOORD_1`) instead of forcing all material maps onto one shared UV channel.
- Fixed `selene-raylib` normal mapping path to consume authored tangent attributes when available, with derivative-frame fallback only when tangents are unavailable.
- Fixed `selene-raylib` triangle shadow rendering to use the uploaded mesh path (shared cached triangle meshes) instead of immediate `rl.Triangles`, aligning shadow and main-pass triangle geometry submission.
- Fixed `selene-raylib` sampler-unit initialization robustness on raylib `0.3.1` by uploading `texture0..texture5` and shadow atlas/map slots as `Int` texture-unit uniforms (instead of `Sampler2D`), avoiding backend enum mismatch paths that can surface `GLD_TEXTURE_INDEX_2D ... sampler type (Float)` warnings and broken textured 3D output.

### Removed

## [0.30.2] - 2026-03-30

### Added

### Changed

- Changed `selene-editor` Move snap controls from a hardcoded `16px` modifier into a persistent workspace setting (`.selene-editor/workspace.json`) with explicit toolbar controls for enable/disable and step size (`1/2/4/8/16/32/64`).
- Changed `selene-editor` topbar IA by moving Move Snap out of `Tools` into a dedicated `Options` section with a single explicit enable/disable toggle.

### Fixed

- Fixed `selene-raylib` 3D triangle primitives and truncated cylinders to render through uploaded `Mesh::draw` path (with GPU mesh caching) instead of immediate `rlgl` triangle submission, eliminating sampler-slot instability from the manual multi-texture immediate path.
- Fixed `selene-raylib` lighting shader sampler binding type by switching `texture0..texture5` and shadow sampler uniforms (`shadowMap*`, `spotShadowAtlas`, `pointShadowAtlas`) from integer uniform uploads to `Sampler2D` uploads, resolving sampler type mismatch warnings (`sampler type (Float)` / unloadable texture) in 3D textured materials.
- Fixed `selene-editor` Move tool behavior so `Translate` now supports click-to-place positioning and no longer gets interrupted by per-frame scene reloads during drag.
- Fixed `selene-editor` viewport transform editing history by introducing preview transform gesture start/finish boundaries, so a full drag gesture records as one undoable scene edit.
- Fixed `selene-editor` preview sync granularity by separating view-state sync (`tool`/`selection`) from scene-content sync, avoiding unnecessary `LoadScene` churn on simple selection/tool updates.
- Fixed `selene-editor` Move tool click semantics so clicking another entity now selects it first, while clicking empty space moves the current selection to the cursor position.
- Fixed `selene-editor` topbar action UX by adding disabled states for unavailable operations (`Undo`/`Redo`/`Delete`/`Frame`/scene-add/save when scene is unavailable).
- Fixed `selene-editor` keyboard workflow by adding standard shortcuts for save/tool switching/frame/delete (`Cmd/Ctrl+S`, `V/H/W/E/R`, `F`, `Delete`) with input-focus guards.
- Fixed `selene-editor` viewport affordance feedback by adding tool-aware cursor changes and stronger selection/pivot overlay highlights while hovering/dragging.
- Fixed `selene-editor` Inspector edit history so continuous typing on entity name/transform/text is now coalesced into one undo entry after commit instead of polluting the history stack per keystroke.
- Fixed `selene-editor` Move precision by adding optional 16px grid snapping while holding `Shift` during translate drag/click placement.
- Fixed `selene-editor` Inspector commit flow so pressing `Enter` now commits the current text/transform/name edit transaction immediately.
- Fixed `selene-editor` preview/runtime snap consistency by synchronizing move-snap settings through typed preview commands instead of keeping runtime-only hardcoded grid values.

### Removed

## [0.30.1] - 2026-03-30

### Added

### Changed

- Changed `selene-editor` viewport tooling to introduce explicit `DragCanvas` mode for left-drag camera panning, while keeping middle-drag and touchpad-scroll pan behavior.
- Changed `selene-core` and `examples` to use `Milky2018/moon_rapier@0.3.0` via `moon add`, aligning the workspace with the latest Rapier MoonBit package surface.
- Changed `selene/physics3d` 3D Rapier syncing to wire `Dominance` and `SolverGroups` into both creation and per-frame sync paths (`RigidBodyBuilder3D`/`RigidBody3D`, `ColliderBuilder3D`/`Collider3D`), and implemented `multibody_joints()` -> `MultibodyJointSet3DReal` insertion/handle mapping.

### Fixed

- Fixed `selene-editor` viewport navigation ergonomics by replacing the temporary `Space + left-drag` pan gesture with explicit `Drag Canvas` tool behavior and standard input controls: middle-button drag pan shortcut, touchpad two-finger scroll pan, and `Shift + scroll` zoom.
- Fixed `selene-core` 2D multibody joint syncing against `moon_rapier@0.3.0` by adapting the revolute joint conversion path to the new `GenericJoint`-based insert API.
- Fixed missing 3D alignment coverage for `moon_rapier@0.3.0` by adding whitebox tests for multibody joint handle creation, rigid-body dominance propagation, and collider solver-group propagation.
- Fixed `selene_raylib` 3D lit shader sampler binding initialization by explicitly binding `texture0..texture5` to texture units `0..5`, preventing driver-dependent sampler aliasing in triangle-mesh immediate rendering.

### Removed

- Removed `PreviewPivotMode` and `PreviewCommand::SetPivotMode` from `selene-editor` shared/preview interfaces and deleted the corresponding frontend app state/messages, so pivot switching no longer exists as a configurable editor feature.

## [0.30.0] - 2026-03-28

### Added

- Added scene history undo/redo in `selene-editor` with toolbar actions and keyboard shortcuts (`Cmd/Ctrl+Z`, `Shift+Cmd/Ctrl+Z`, and `Cmd/Ctrl+Y`).
- Added a new `selene/editor_bridge` source+codec+loader stack (`DocumentSource`, typed `decode_*` APIs, and `load_project_bundle(...)`) so project/scene/dependency document loading is unified and runtime-safe across editor and examples.
- Added `examples/pixeladventure/scene_runtime_wbtest.mbt` to verify editor-scene gameplay marker counts, terrain segment generation, and custom gameplay component registration directly from Selene editor scene documents.
- Added a shared `Migration` trait to `selene/editor_bridge` and extended document migration support beyond scenes, with typed probe/migrate status APIs for prefab, atlas, and animation documents.
- Added editable `Atlas Inspector` and `Animation Inspector` flows to `selene-editor`, with field-level editing and save actions mapped directly onto `selene/editor_bridge` atlas and animation asset documents instead of editor-private resource state.
- Added editable `Prefab Inspector` and expanded `Scene Browser` controls to `selene-editor`, so prefab documents can now be renamed/saved from the inspector and the current scene can be renamed, created, deleted, and marked as the startup scene from the workspace UI.
- Added first-class multi-scene, prefab, atlas, animation, and workspace document support to `selene/editor_bridge`, including file IO, validation, versioned schema, and shared runtime instantiation context for Selene-native editor resources.
- Added first-pass Selene-native resource actions to `selene-editor`: selected images can now create atlas documents, selected atlases can now create animation documents, selected entities can now be saved as prefabs, and selected image/atlas/animation/prefab resources can now be inserted into the active scene.
- Added `selene/editor_bridge`, a public scene-document bridge package that owns Selene Editor JSON schema/types, validation, patching, project/scene file IO, and scene-document-to-world runtime instantiation for shared use by editor preview and game/runtime code.
- Added behavior-driven `selene-editor` scenarios with an in-process harness that drives `shared`, `service/core`, `frontend/app`, and the preview bridge without a browser.
- Added a native directory-picker RPC for `selene-editor`, so the browser page can ask the local service to open the system folder chooser and fill the project root field without CLI path arguments.
- Added the first real `selene-editor` scene-authoring workflow for image assets: the editor now lists image files from project `assets/`, lets users select an asset in the sidebar, and supports dragging an asset onto the viewport to place a sprite at the drop position.

### Changed

- Changed `selene/editor_bridge` schema defaults to `v2` and expanded `ProjectManifest` with explicit `scene_index`, `prefab_index`, `atlas_index`, and `animation_index` fields used by the editor/service project state.
- Changed `selene-editor` scene loading flow to return and consume typed `SceneBundle` payloads (scene + referenced atlas/animation documents) instead of piecemeal dependency reads in frontend state.
- Changed `examples/pixeladventure` runtime startup to load `selene.project.json` + startup scene through `Milky2018/selene/editor_bridge`, instantiate scene entities directly, and apply gameplay setup via custom component appliers instead of using `sprite_fusion/map.json` as the runtime placement source.
- Changed `examples/pixeladventure` package metadata to declare `"supported-targets": "all"` after adding the `selene/editor_bridge` dependency.
- Changed `selene-editor` behavior coverage from a single happy-path BDD file into split happy-path, migration/recovery, and error-UX scenario suites, and expanded the supporting frontend/service/shared whitebox tests to cover typed protocol failures, invalid documents, missing files, and user-cancel flows.
- Changed `selene-editor` transport protocol to use shared typed ADTs for all retained `/rpc` requests/responses and `/events` payloads, removing scattered string method names and SSE kind dispatch from the frontend/service boundary.
- Changed `selene-editor` from a single-scene JSON editor toward a Selene-native workspace model: project state now includes scene refs, prefab refs, atlas refs, animation refs, and editor workspace data, and preview loading now carries atlas/animation asset documents into `editor_bridge` instead of instantiating scenes in isolation.
- Changed `selene-editor` UI layout to introduce a real `Scene Browser` beside the `Asset Browser`, and changed asset inspection from image-only cards to Selene-native resource sections for images, atlases, animations, and prefabs.
- Changed `selene-editor` startup UX so the browser opens on a dedicated main menu with the Selene Editor mark and an explicit `Open Project` action; folder selection no longer happens automatically on page load.
- Changed `selene-editor` to a folder-first single-scene workflow: on startup it immediately prompts for a local directory, opens `selene.project.json` if present, otherwise auto-initializes a new project there, and then shows only the scene editing interface.
- Changed `selene/editor_bridge` and `selene-editor` project naming conventions to use the fixed manifest path `selene.project.json` and the fixed startup scene path `scenes/main.scene.json`.
- Changed `selene-editor` frontend asset delivery to serve a concrete `public/editor.js` bundle instead of dynamically mapping `/editor.js` to `_build/.../web.js`; source builds now generate the static runtime asset directly from `just build`.
- Changed `selene-editor` source workflow to use a local `justfile` as the only documented entrypoint for `build`, `run`, `dev`, `check`, and `test`, removing the redundant frontend build shell script.
- Changed `selene-editor` service startup to accept a configurable listening port via `--port`, and wired `just run` / `just dev` to forward an optional custom port argument without requiring users to free the default port first.
- Changed `selene-editor` to import `Milky2018/selene/editor_bridge` for project/scene JSON documents, validation, patching, file IO, and preview scene instantiation instead of keeping its own duplicated scene-loading and scene-compilation logic.
- Changed `selene-editor` preview transform event payloads to carry full `Transform2d` data (`translation`, `rotation`, `scale`), so viewport tool edits no longer need frontend-side scale inference.
- Changed `selene-editor` runtime so it no longer invokes `moon` to build itself or to operate on user projects; the editor now treats projects purely as JSON documents plus referenced assets.
- Changed `selene-editor` viewport editing state to include explicit pivot mode (`Transform Origin` / `Bounds Center`) and synchronize that mode through preview commands.
- Changed `selene-editor` package imports and published module name from `Milky2018/selene-editor` to `Milky2018/selene_editor`, while keeping the workspace directory name unchanged.
- Changed `selene-editor` frontend architecture to split the pure `frontend/app` state machine from the Rabbita/JS adapter.
- Changed `selene-editor` service architecture to expose `service/core` RPC and event entrypoints for integration-style testing.
- Changed `selene-editor` project/scene file naming to use the fixed manifest path `selene.project.json` and the fixed startup scene path `scenes/main.scene.json`, and removed support for the old `selene-editor.json` manifest path.
- Changed `selene-editor` so opening a directory without `selene.project.json` now auto-initializes a new JSON project in that directory.
- Changed `selene-editor`'s single-scene editing shell so project actions, scene actions, and transform tools are split into separate toolbar sections and exposed as icon buttons with hover titles instead of one undifferentiated row of text buttons.

### Fixed

- Fixed `selene-editor` viewport interaction mapping by normalizing mouse position/movement to the runtime viewport size, so viewport picking, transform dragging, and camera pan behave consistently when the canvas is CSS-scaled.
- Fixed `selene-editor` viewport tools so `Rotate` and `Scale` now perform direct drag editing in preview runtime (instead of only toggling button state), and `Translate`/`Rotate`/`Scale` all share a stable drag deadzone model.
- Fixed `selene-editor` preview hit-testing and selection overlay bounds to account for `Transform2d.scale`, improving picking accuracy after scale edits.
- Fixed `selene-editor` rotate tool UX by adding `Shift`-based 15° snapping and a visible pivot marker overlay in the viewport during selection/editing.
- Fixed `selene-editor` camera pan behavior so middle-button click no longer causes an immediate pan jump; panning now starts from an explicit press anchor and only moves while dragging.
- Fixed `selene-editor` camera middle-drag pan direction consistency on both axes in the preview runtime.
- Fixed `selene-editor` viewport rendering distortion by enforcing a stable 16:9 canvas aspect layout instead of stretching the canvas to arbitrary panel proportions.
- Fixed `selene-editor` asset thumbnail URL generation by encoding project-relative path segments, improving image loading reliability for asset paths containing spaces and special characters.
- Fixed `selene-editor` project asset URL encoding to avoid double-encoding already escaped path segments, preventing thumbnail breakage in mixed encoded/unencoded asset paths.
- Fixed unsupported-glyph regressions in `selene-editor` resource/tool icon rendering by switching key icon labels to text-safe glyphs.
- Fixed `selene-editor` toolbar UX by removing top-floating hover tooltip bubbles and routing hover hints into a single bottom info bar shared with status/error messages.
- Fixed `selene-editor` asset browser UX by replacing static empty placeholders with collapsible resource sections and per-section counts (`Images`, `Atlases`, `Animations`, `Prefabs`).
- Fixed `selene-editor` asset browser filtering flow so empty resource groups are hidden and the panel shows a single explicit empty-filter state instead of noisy placeholder rows.
- Fixed `selene-editor` sidebar/inspector panel overflow behavior by rebalancing sidebar row sizing and tightening panel scroll handling to reduce unnecessary scrollbars.
- Fixed `selene-editor` preview mouse interactions by adding movement deadzones for middle-button camera pan and translate-tool dragging, preventing single-click jitter from moving the viewport or entities.
- Fixed `selene-editor` scene browser list sizing by removing forced internal scrolling for small scene sets, aligning with expected desktop panel behavior.
- Fixed `selene-editor` project-open compatibility for legacy `v2` manifests missing index arrays (`scene_index`, `prefab_index`, `atlas_index`, `animation_index`) by auto-migrating and rewriting `selene.project.json` on open.
- Fixed `selene-editor` frontend error UX so low-level decode traces (for example `JsonDecodeError(.../response/...)`) are no longer shown directly in status/log text; detailed diagnostics now go to browser console.
- Fixed `selene-webgpu` synchronous asset byte loading on browser documents: `webgpu_load_file_bytes_sync(...)` now uses `x-user-defined` text mode byte extraction instead of setting `responseType="arraybuffer"` on sync XHR, so `@asset.read_bytes(...)` can load editor/project JSON files on web runtime and `examples/pixeladventure` no longer panics at startup with `MissingDocument`.
- Fixed `examples/pixeladventure` checkpoint-flag rendering so the `PixelAdventureFlag` runtime path now respects the flag strip frame layout (`64x64` frames on a `640x64` sheet) and installs a looping sprite-atlas animation; this removes the strip-compression artifact and restores the expected waving flag animation.
- Fixed `selene/editor_bridge` loader text decoding by switching JSON document parsing from unchecked byte-to-string casts to explicit UTF-8 decoding before JSON parse.
- Fixed `examples/pixeladventure` editor-scene documents to the `v2` manifest/scene shape expected by the new loader (`version: 2` + manifest index fields + optional-field omission rules), and added test-time asset-IO setup so runtime scene-loading wbtests pass across `native/js/wasm`.
- Fixed `examples/pixeladventure` web startup so scene/project/asset document loading now uses `@asset.read_bytes` first and no longer requires Node `fs` on browser runtime.
- Fixed `selene/editor_bridge` scene/prefab validation so custom component kinds are accepted (empty kinds are still rejected), enabling Selene game-specific JSON components to be loaded and instantiated through the custom component registry.
- Fixed `examples/pixeladventure/scenes/main.scene.json` decoding compatibility by removing `null` option fields from the generated scene document payload.
- Fixed the `selene-editor` source workflow so `just run` now rebuilds `public/editor.js` before starting the local service, preventing stale frontend bundles from masking newer RPC and migration behavior.
- Fixed `selene/editor_bridge` and `selene-editor` document loading so unrecoverable project/scene/prefab/atlas/animation JSON errors now surface as stable user-facing invalid-document failures instead of leaking raw decode exceptions, and invalid editor workspace files now fall back to defaults instead of blocking project open.
- Fixed `selene-editor` legacy-scene migration flow to keep migration previews on relative scene paths, so confirming a legacy startup-scene migration now writes back and reloads correctly through the typed `scene.migrate` RPC path.
- Fixed `selene-editor` startup scene loading for legacy scene documents: opening an older `*.scene.json` no longer fails with a raw `JsonDecodeError`; the editor now detects recoverable missing fields, shows a migration confirmation dialog, and writes the migrated scene back only after explicit user confirmation.
- Fixed `selene-editor` image-asset placement so dragged sprites use each asset's resolved image dimensions instead of always forcing new sprite entities to `64x64`.
- Fixed `selene-editor` project asset serving to percent-decode `/project/...` request paths before resolving files on disk, so image assets with spaces and similar URL-escaped characters now load correctly in the asset sidebar.
- Fixed `selene-editor` asset selection behavior so clicking an asset card no longer creates a new scene entity; image assets are now inserted only by dragging them into the viewport.

### Removed

- Removed `selene/editor_bridge` path-based public file APIs (`read_*`, `write_*`, `list_*`, layout helpers) from the public bridge surface in favor of source-based loading + pure codec/migration logic.
- Removed `examples/pixeladventure` legacy tilemap fixtures and SpriteFusion map artifacts (`legacy_*_wbtest.mbt` and `sprite_fusion/*.json`) now that scene documents are the only placement source.
- Removed the draft `prds/selene-editor` product requirements document so `selene-editor` requirements can be driven directly from the live discussion instead of a checked-in PRD.
- Removed the private `selene-editor/shared` document/schema implementation (`documents`, `validation`, `patch`, and `version`) in favor of the shared `selene/editor_bridge` package.
- Removed `selene-editor` build/toolchain RPCs (`build.check`, `build.run_preview`) and the service-side `moon` command execution path; editing and preview now only depend on the editor runtime and JSON project files.

### Added

- Added an initial `selene-editor/` workspace outside the publish pipeline, with shared JSON project/scene document models, RPC/event protocol types, validation helpers, and whitebox coverage for round-tripping editor documents.
- Added a native `selene-editor/service` daemon built on `moonbitlang/async` that serves static editor assets, exposes JSON-RPC and SSE endpoints, manages project/scene load-save flows, indexes/imports assets, watches project files, and runs `moon check` / `moon build` commands for local editor workflows.
- Added a JS `selene-editor/preview` package that boots a Selene 2D preview canvas, compiles `SceneDocument` data into runtime entities, supports viewport selection, camera pan/zoom, frame-selection, and translate-tool drag feedback, and reports preview events back to the editor shell.
- Added a Rabbita-based `selene-editor/frontend` shell with project open/create controls, asset browser, scene tree, inspector, viewport host, log panel, local scene editing for basic 2D entities/components, and live synchronization with the preview/runtime service.
- Added Bevy-style asset lifecycle surface to `selene/asset`: `LoadState`, `AssetEventKind`, `AssetEvent[T]`, `image_asset_events`, `audio_asset_events`, `font_asset_events`, `image_load_state(...)`, `audio_load_state(...)`, `font_load_state(...)`, `reload_image(...)`, `reload_audio(...)`, `reload_font(...)`, `remove_image(...)`, `remove_audio(...)`, and `remove_font(...)`.
- Added Bevy/Rapier-style componentized 3D physics surface to `selene/physics3d`: `RigidBody`, `Velocity`, `Damping`, `GravityScale`, `LockedAxes`, `Ccd`, `Dominance`, `AdditionalMassProperties`, `Collider`, `Sensor`, `Friction`, `Restitution`, `CollisionGroups`, `SolverGroups`, `ContactForceEventThreshold`, `ColliderMassProperties`, `ImpulseJoint`, `MultibodyJoint`, `FixedJoint`, `RevoluteJoint`, `PrismaticJoint`, `RopeJoint`, `SpringJoint`, `SphericalJoint`, `JointAxis`, `JointAxesMask`, `MotorModel`, `KinematicCharacterController`, `KinematicCharacterControllerOutput`, `KinematicCharacterControllerCollisions`, `RapierContext`, `CollisionEvent`, `SensorEvent`, `ContactForceEvent`, `RapierRigidBodyHandle`, `RapierColliderHandle`, `RapierImpulseJointHandle`, and `RapierMultibodyJointHandle`.
- Added Bevy/Rapier-style 3D physics stores and queries: `rigid_bodies()`, `velocities()`, `dampings()`, `gravity_scales()`, `locked_axes()`, `ccds()`, `dominances()`, `additional_mass_properties()`, `colliders()`, `sensors()`, `frictions()`, `restitutions()`, `collision_groups()`, `solver_groups()`, `active_collision_types()`, `active_events()`, `active_hooks()`, `contact_force_event_thresholds()`, `collider_mass_properties()`, `impulse_joints()`, `multibody_joints()`, `kinematic_character_controllers()`, `kinematic_character_controller_outputs()`, `kinematic_character_controller_collisions()`, `context().cast_ray(...)`, `context().cast_shape(...)`, `context().intersections_with_point(...)`, `context().intersections_with_shape(...)`, and `context().project_point(...)`.
- Added extra 3D collider constructors to `@physics3d.Collider`: `capsule_x(...)`, `capsule_y(...)`, `capsule_z(...)`, `cylinder(...)`, `cone(...)`, `round_cylinder(...)`, `halfspace(...)`, `convex_hull(...)`, `trimesh(...)`, and `heightfield(...)`.
- Added 3D rigid-body state accessors `rigid_body_handle(...)`, `collider_handle(...)`, `impulse_joint_handle(...)`, `multibody_joint_handle(...)`, `rigid_body_translation(...)`, `set_rigid_body_translation(...)`, `rigid_body_rotation(...)`, `set_rigid_body_rotation(...)`, `rigid_body_linear_velocity(...)`, `set_rigid_body_linear_velocity(...)`, `rigid_body_angular_velocity(...)`, and `set_rigid_body_angular_velocity(...)`.
- Added `examples/scene3d` coverage for the new 3D physics surface: dynamic rigid body, child collider, impulse joint, kinematic character controller, raycast query, and contact-force HUD feedback.

### Changed

- Changed `selene-editor` to own its local ignore rules via `selene-editor/.gitignore`, mirroring the established MoonBit ignore layout used by `selene-core`, and removed the corresponding MoonBit build-cache entries from the repository root `.gitignore`.
- Changed `publish.py` so `selene-editor` now participates in the release pipeline alongside the core Selene modules, including version rewriting, `moon update`, warning-free quality checks, and ordered `moon publish`.
- Changed `@asset.load_image(...)`, `load_audio(...)`, and `load_font(...)` to own cached handle registration, load-state tracking, and typed lifecycle event dispatch directly instead of splitting those responsibilities across `selene/asset` and `selene/asset2`.
- Changed `scene3d`, `tiled`, `ldtk`, `animation`, built-in plugins, tutorials, and example packages to use the unified `selene/asset` surface for bytes loading, lifecycle events, and typed asset handles.
- Changed `selene/physics3d` from single-descriptor `RigidBody3D` / `Collider3D` storage plus free query helpers into a Bevy/Rapier-style componentized surface centered on `RigidBody`, `Velocity`, `Collider`, `ImpulseJoint`, `KinematicCharacterController`, and `RapierContext`.
- Changed 3D rigid-body sync to read authored world transforms through `@transform.compute_global_transform(...)` and to write Rapier results back into local `Transform` when the rigid body entity is parented.
- Changed 3D collider attachment semantics to follow Bevy Rapier child-collider behavior: colliders now attach to the nearest rigid-body ancestor and use relative transforms instead of only supporting same-entity rigid bodies.
- Changed built-in 3D plugin setup to register `collision_event_bus`, `sensor_event_bus`, and `contact_force_event_bus`, and to run the new component-driven 3D physics pipeline around body/collider/joint/controller synchronization.

### Fixed

- Fixed `selene-editor` web preview boot so the JS bundle now overrides Selene's platform modules with `selene_webgpu/platform_*`, `selene_webgpu` lazily acquires the `#canvas` element instead of panicking before the workspace view exists, and the WebGPU depth-texture setup no longer mutates native `GPUTexture` objects with ad-hoc `width` / `height` fields; editor viewports now initialize WebGPU correctly and render inserted sprites instead of staying black.
- Fixed `selene-editor` folder-picker RPC to use a typed shared response payload and preserved success-payload decode errors in the frontend, so the first-run directory chooser now reports actionable failures instead of a misleading generic `JsonDecodeError`.
- Fixed `selene-editor` project auto-open on existing directories without `selene.project.json`; manifest discovery now checks file existence before probing file kind, so opening an example folder correctly auto-initializes a new editor project instead of raising `OSError(... No such file or directory)`.
- Fixed `selene-editor` project open/create flows so an empty `Project root` no longer triggers filesystem write attempts; the frontend now blocks those actions until a folder is chosen, and the service returns a clear `Project root is required` error for invalid requests.
- Fixed `selene-editor` top toolbar spacing by grouping project actions separately from viewport tools and reserving room for the status text on the right.
- Fixed `examples/survivors` player atlas extraction by restoring the historical `space_x` padding semantics for the local sprite-sheet helper, so `whiteboy` frames are cut at the original x offsets instead of a regressed 64-pixel stride.
- Fixed step-interpolated animation sampling at interior keyframe boundaries so `TextureAtlas.index` and other discrete animation targets switch on the exact next keyframe instead of lingering one frame behind.
- Fixed repeated cached asset loads so they no longer emit duplicate `Added` / `Loaded` events once an asset handle is already in the loaded state.
- Fixed `selene/physics3d` so impulse-joint `contacts_enabled` is now forwarded for fixed/revolute/prismatic/spherical joints, and spherical-joint motor targets are forwarded to Rapier's 3D spherical motor path.
- Fixed same-entity 3D colliders being double-transformed when inserted with a rigid body.
- Fixed parented 3D colliders so scene queries and physics synchronization now respect their relative transform to the owning rigid body.
- Fixed 3D contact-force event collection so explicitly enabled colliders now dispatch `ContactForceEvent` through Selene's message bus.
- Fixed `RapierContext::intersections_with_shape(...)` so ball/cuboid/capsule/cylinder/cone/trimesh/heightfield overlap queries use public Rapier shape-pair contact routines instead of unreliable convex fallback for primitive pairs.

### Removed

- Removed the legacy `selene/asset2` package; asset lifecycle state and typed asset events now live directly in `selene/asset`.
- Removed the legacy 3D physics surface: `RigidBody3D`, `Collider3D`, `Sensor3D`, `LinearVelocity3D`, `AngularVelocity3D`, `CollisionLayers3D`, `SpatialQueryBodyFilter3D`, `SpatialQueryFilter3D`, `raycast3d(...)`, `shape_cast3d(...)`, `intersect_point3d(...)`, `character_controller3d_move(...)`, `contact_event_bus3d`, `trigger_event_bus3d`, and `contact_force_event_bus3d`.

## [0.29.0] - 2026-03-24

### Added

- Added `@math.Vec3::x_axis()`, `@math.Vec3::y_axis()`, and `@math.Vec3::z_axis()` for transform/camera basis construction.
- Added `@math.Quat::inverse()`, `@math.Quat::dot()`, `@math.Quat::nlerp(alpha)`, and `@math.Quat::from_basis(x_axis, y_axis, z_axis)`.
- Added `@math.Affine3` plus `Affine3::identity()`, `Affine3::from_scale_rotation_translation(scale, rotation, translation)`, `Affine3::transform_vector3(vec)`, `Affine3::transform_point3(point)`, `Affine3::inverse()`, and `Affine3` multiplication.
- Added `@transform.compute_global_transform(entity)` as the Bevy-style current-frame world-transform helper for systems that need an up-to-date global transform before the stored `GlobalTransform` propagation pass runs.
- Added `Entity::set_parent(parent)` / `Entity::remove_parent()` plus `@transform.set_parent_in_place(child, parent)` / `@transform.remove_parent_in_place(child)` so hierarchy changes can either preserve local space or preserve world space, matching Bevy-style reparent semantics.
- Added `@camera.Camera` component with `Camera::new(is_active?, order?)`, `Camera::world_to_viewport(camera_transform, projection, world_position)`, and `Camera::viewport_to_world_2d(camera_transform, projection, viewport_position)`.
- Added `@camera.Camera2d` marker component with `Camera2d::new()`.
- Added `@camera.OrthographicProjection` component with `OrthographicProjection::new(scale?, near?, far?)`.
- Added `@camera.cameras()`, `@camera.camera2ds()`, and `@camera.orthographic_projections()` world stores.
- Added `selene/name` with `Name::new(value)`, `@name.names()`, and `@name.name_of(entity)` for stable animation target path resolution.
- Added unified `selene/animation` with `AnimationClip`, `AnimationClipHandle`, `AnimationGraph`, `AnimationGraphHandle`, `AnimationNodeIndex`, `AnimationPlayer`, `ActiveAnimation`, `AnimationTransitions`, `RepeatAnimation`, `AnimationTargetId`, `AnimatedBy`, `AnimationEventContext`, `AnimationEventDescriptorHandle`, `VariableCurve`, `AnimatedField`, and the corresponding world stores/systems.
- Added `@animation.transform_translation_field()`, `transform_rotation_field()`, `transform_scale_field()`, `morph_weights_field()`, and `texture_atlas_index_field()` as the built-in animatable fields for transform, morph, and 2D flipbook playback.
- Added `@animation.register_animation_clip_asset(...)`, `animation_clip_asset(...)`, `update_animation_clip_asset(...)`, `release_animation_clip_asset(...)`, `take_dirty_animation_clip_assets()`, and `take_released_animation_clip_assets()`.
- Added `@animation.register_animation_graph_asset(...)`, `animation_graph_asset(...)`, `update_animation_graph_asset(...)`, `release_animation_graph_asset(...)`, `take_dirty_animation_graph_assets()`, and `take_released_animation_graph_assets()`.
- Added `@animation.animation_clip_asset_events`, `@animation.animation_graph_asset_events`, and `register_animation_event_descriptor(events, build)` for handle-based animation assets and typed clip-event dispatch.
- Added Bevy-style 2D rendering surface types: tuple-struct `@sprite.Anchor(@math.Vec2D)`, `Anchor::as_vec()`, `TextureAtlasLayout`, `TextureAtlasLayoutHandle`, `TextureAtlas`, `SpriteImageMode`, `Sprite::new(...)`, `Sprite::from_image(...)`, `Sprite::from_atlas_image(...)`, `Sprite::from_color(...)`, `texture_atlas_layout(...)`, and `texture_atlas_rect(...)`.
- Added `selene/mesh2d` with `Mesh2dPrimitive`, `Mesh2dAsset`, `Mesh2dHandle`, `Mesh2d`, `mesh2ds()`, `register_mesh2d_asset(...)`, `update_mesh2d_asset(...)`, `release_mesh2d_asset(...)`, `take_dirty_mesh2d_assets()`, `take_released_mesh2d_assets()`, `rectangle(...)`, and `circle(...)`.
- Added `selene/material2d` with `AlphaMode2D`, `ColorMaterial`, `ColorMaterialHandle`, `Material2dHandle`, `MeshMaterial2d`, `MeshMaterial2d::from_color_material(...)`, `mesh_material2ds()`, `register_color_material(...)`, `update_color_material(...)`, `release_color_material(...)`, `take_dirty_color_materials()`, and `take_released_color_materials()`.
- Added `selene/text2d` with `Text2d`, `TextBounds`, `Text2d::new()`, `TextBounds::new(width, height)`, `text2ds()`, `text_bounds()`, `text_anchors()`, and `render_text2d_system(...)` for world-space text extraction independent of `selene/sprite`.
- Added depth-aware world 2D submission helpers in `selene/render2d`: `push_image_with_depth(...)`, `push_text_with_depth(...)`, `push_rect_with_depth(...)`, `push_circle_with_depth(...)`, and `push_gradient_rect_with_depth(...)`.

### Changed

- Changed `@transform.Transform` to Bevy-style TRS storage with `translation : @math.Vec3`, `rotation : @math.Quat`, and `scale : @math.Vec3`.
- Changed `@transform.GlobalTransform` from a position-like 2D helper into affine world-transform storage backed by `@math.Affine3`.
- Changed `@transform.Transform::identity()`, `from_translation(...)`, `from_xyz(...)`, `from_rotation(...)`, `from_scale(...)`, `with_translation(...)`, `with_rotation(...)`, and `with_scale(...)` to operate on the unified 2D/3D transform type.
- Changed `@app.App::run()` fixed-step ordering to match Bevy-style main-loop semantics: fixed schedules now run before frame `Update`/`PostUpdate`, so frame systems observe the latest fixed-step transform results before the single propagation pass.
- Changed transform propagation to write world-space affine globals for both 2D and 3D entity hierarchies.
- Changed `Entity::spawn_child()` to create only the hierarchy relation; child local placement now comes from the child entity's own `@transform.Transform` instead of a separate offset channel.
- Changed `@physics2d` rigid-body translation/rotation sync to read from and write back to `@transform.transforms()` instead of the removed position-only store.
- Changed world-sprite rendering to sample `@transform.GlobalTransform`, apply entity rotation/scale to picture, animation, text, color-rect, and color-circle sprites, and consume active `Camera2d + OrthographicProjection` view transforms when present.
- Changed world 2D sprite depth ordering to come from `Transform.translation.z`; `examples/cards`, `examples/pixeladventure`, `examples/survivors`, LDtk runtime spawns, and Tiled runtime spawns now write depth into entity transforms instead of per-sprite z-index fields.
- Changed `@sprite.Sprite::from_animation(...)`, `from_picture(...)`, `from_text(...)`, `from_color_rect(...)`, and `from_color_circle(...)` to construct only sprite content/visibility; local visual offsets now belong in the picture/animation transform, and render depth belongs in entity `Transform.translation.z`.
- Changed `@scene`, `@scene3d`, `@camera3d`, `@render3d`, `@physics3d`, `@animation3d`, and `examples/scene3d` to read unified `@transform.Transform` / `@transform.GlobalTransform` stores directly instead of the `@transform3d` bridge package.
- Changed `@plugins.default_plugin` and `@plugins.default_3d_plugin` to register unified `@transform.transform_propagate_system` scheduling directly instead of going through the removed `@inherit` bridge.
- Changed `@plugins.default_plugin` and `@plugins.default_3d_plugin` to install the unified animation schedule (`animation_player_system`, `animation_transition_system`, `animation_apply_system`, and `animation_skinning_system`) and to register `@animation.animation_clip_asset_events` / `@animation.animation_graph_asset_events`.
- Changed pickable hit-testing to evaluate rectangle shapes in entity-local space derived from `GlobalTransform`, so rotated colliders follow the rendered sprite transform.
- Changed tiled world chunking and parallax logic to read visible bounds from `Camera::viewport_to_world_2d(...)` instead of the removed global 2D camera singleton.
- Changed `examples/cards`, `examples/pixeladventure`, and `examples/survivors` to write world-space positions through `@transform.Transform::from_xyz(...)`; `pixeladventure` and `survivors` now spawn explicit camera entities and run follow/clamp logic in example systems instead of using engine-global camera helpers.
- Changed `@plugins.default_plugin` to stop installing the removed legacy 2D camera follow system.
- Changed `examples/pixeladventure` to a small pure-ECS example split into `model.mbt`, `spawn.mbt`, and `systems.mbt`, replacing the old module-global `game_state` / `birds` / `apples` / `flags` state and removing the example's dependency on `@state.State`.
- Changed `examples/pixeladventure/assets/pixeladventure` to keep only the runtime assets used by the rewritten example, removing the rest of the unused source art pack from the repository copy.
- Changed `@scene3d.SceneInstance.animations` to expose `@animation.AnimationNodeIndex` values instead of 3D clip handles, and changed scene instantiation so animated roots install `AnimationPlayer + AnimationTransitions + AnimationGraphHandle` without autoplaying the first node.
- Changed glTF scene import to build unified `AnimationClip` assets and per-scene `AnimationGraph` assets, attach `AnimationPlayer + AnimationTransitions` to animated roots, and bind descendants through `Name`-based `AnimationTargetId` / `AnimatedBy`.
- Changed `SpriteType::Animation` to store only the animation asset; frame advancement now comes from `@animation` writing `@sprite.SpriteFrameIndex`.
- Changed `AnimationPlayer` to Bevy-style semantics: `play(node)` no longer restarts active nodes, `start(node)` forces restart, bulk controls (`stop_all`, `pause_all`, `resume_all`, `rewind_all`, `seek_all_by`) operate across all active nodes, and `playing_animations()` / `all_finished()` / `all_paused()` expose current player state.
- Changed `ActiveAnimation` to own per-node playback control (`pause`, `unpause`, `set_speed`, `set_weight`, `set_repeat`, `repeat`, `replay`, `rewind`, `seek_to`, `set_seek_time`) instead of routing those mutations through `AnimationPlayer`.
- Changed `AnimationTransitions::play(...)` to return the active animation and added `AnimationTransitions::get_main_animation()`.
- Changed `AnimationGraph` to Bevy-style construction helpers with `from_clip(...)`, `from_clips(...)`, `add_edge(...)`, `add_blend_with_mask(...)`, `add_additive_blend(...)`, `add_additive_blend_with_mask(...)`, `add_clip_with_mask(...)`, and `add_target_to_mask_group(...)`.
- Changed clip-event dispatch from string names on a global bus to typed descriptor handles registered against explicit `@event.Events[T]` buses.
- Changed Tiled animated tiles, `examples/pixeladventure`, and `examples/survivors` to build local 2D flipbook clip/graph assets explicitly and drive playback through `AnimationPlayer`/`AnimationTransitions`.
- Changed `@plugins.default_plugin` and `@plugins.default_3d_plugin` to keep `@transform.transform_propagate_system` as the single `PostUpdate` world-transform propagation pass, instead of running extra fixed-stage propagation workarounds.
- Changed `@collision.pickable`, `@tiled`, and other pre-propagation camera/view helpers to compute current world transforms through `@transform.compute_global_transform(...)` instead of reading stale stored globals during `Update`.
- Changed `@sprite.Sprite` from a `SpriteType` content enum wrapper into a Bevy-style single component that directly stores `image`, `texture_atlas`, `rect`, `color`, `custom_size`, `anchor`, `flip_x`, `flip_y`, and `image_mode`.
- Changed 2D flipbook playback to animate `TextureAtlas.index`; `pixeladventure`, `survivors`, Tiled animated tiles, and LDtk tile/entity/background visuals now render through `Sprite + TextureAtlas` instead of `SpriteType::Animation`.
- Changed pure-color world rectangles to render as plain `Sprite` quads (`Sprite::from_color(...)` / `Sprite::new(color, custom_size, ...)`) instead of `SpriteType::ColorRect`.
- Changed world-space circles to render through `Mesh2d(circle) + MeshMaterial2d(Material2dHandle::Color(...))` instead of `SpriteType::ColorCircle`.
- Changed `MeshMaterial2d` to wrap a generic-style `Material2dHandle` enum instead of exposing `ColorMaterialHandle` directly on the component.
- Changed world-space text extraction to use shared `@ui.Text / TextFont / TextColor / TextLayout` data plus `@text2d.Text2d`, optional `@text2d.TextBounds`, and optional `@text2d.text_anchors()` instead of `sprite.Text`.
- Changed world-space `Text2d` placement so `Anchor` now controls block anchoring and `TextLayout` only controls alignment within the text block/bounds, matching Bevy's text layout split more closely.
- Changed world 2D sprite visibility to rely solely on `@visibility.Visibility` / inherited visibility propagation, instead of storing per-sprite visibility inside `@sprite.Sprite`.
- Changed `@plugins.default_plugin` and `@plugins.default_3d_plugin` 2D render extraction to run three independent Bevy-style world paths: sprite quads, mesh2d/material2d, and text2d.
- Changed `examples/cards`, `examples/pixeladventure`, and `examples/survivors` to the new Bevy-style 2D surface: static images use `Sprite`, flipbooks use `Sprite + TextureAtlas`, colored quads use `Sprite::from_color(...)`, and world text no longer goes through `selene/sprite`.

### Fixed

- Fixed 2D rigid-body rotation so Rapier body angle changes now reach world picture/animation sprite rendering through the unified `Transform -> GlobalTransform -> sprite` chain.
- Fixed world-space text, colored rectangles, colored circles, and gradient rectangles so they now follow the same affine transform path as image-based world sprites.
- Fixed collision debug drawing and pickable world hit-testing to use transformed world-space shape data instead of raw position-only offsets.
- Fixed Tiled world-child placement after the hierarchy migration so spawned world maps keep their configured local translation instead of snapping back to the origin.
- Fixed `examples/pixeladventure` gameplay flow so player movement, bird stomp-vs-hurt resolution, apple/flag triggers, HUD sync, volume toggling, and camera follow now run through one session-driven ECS state model instead of split global state.
- Fixed `examples/pixeladventure` web runtime stalls caused by rebuilding HUD text and reloading the volume button image every frame; HUD sync now writes only when values actually change and reuses cached UI images.
- Fixed `examples/pixeladventure/index.html` to stop preloading the entire Pixel Adventure asset pack before startup; the page now lets the game load only the assets it actually uses.
- Fixed `examples/preload-assets.js` to preload example assets during browser idle time with limited concurrency instead of issuing one `fetch` per asset through a single `Promise.all(...)`, which previously overwhelmed large examples such as `pixeladventure`.
- Fixed the `selene-webgpu` browser frame scheduler to deliver one accumulated frame delta per animation frame instead of replaying multiple full `game_loop` / `render_loop` iterations inside a single `requestAnimationFrame`, which previously caused severe lag and frame-delta amplification in web examples such as `pixeladventure`.
- Fixed 2D sprite animations so frame advancement, non-loop completion, and state transitions now run through the same unified runtime as 3D animation clips.
- Fixed `examples/pixeladventure` and `examples/survivors` so player/enemy flipbooks no longer restart every frame; state changes now switch graph nodes only when the desired animation actually changes.
- Fixed 2D flipbook animation application so `Sprite.frame_index` is resolved as a discrete animation value instead of a weighted blend during graph transitions.
- Fixed world-space picture and animation sprites to snap their screen-space positions to whole pixels before drawing, reducing continuous shimmer for moving pixel-art characters.
- Fixed `examples/pixeladventure` and `examples/survivors` flipbook state switches to avoid cross-fading sprite-sheet frame indices during character animation changes.
- Fixed `examples/pixeladventure` and `examples/survivors` camera follow systems to run in the frame `Update` phase, after fixed-step physics has already written the latest player transforms and before the unified `PostUpdate` transform propagation pass.
- Fixed `examples/pixeladventure` blue-bird animation bindings so left/right movement now uses the correct visual facing.
- Fixed animation graph mask evaluation so masked nodes now exclude only the target groups registered on the graph, matching Bevy-style graph-owned mask semantics instead of relying on a target-side mask component.
- Fixed scene animation roots so instantiation no longer starts the first imported clip automatically.

### Removed

- Removed `@camera.get_position()`, `@camera.sample_position(alpha)`, `@camera.set_limits(...)`, `@camera.attach_entity(entity, offset)`, `@camera.set_follow_x(follow)`, `@camera.set_follow_y(follow)`, and `@camera.camera_system(delta)`.
- Removed `@system.world_to_screen(world_pos, camera_pos)` and `@system.screen_to_world(screen_pos, camera_pos)`.
- Removed `@transform.positions()`, `@transform.previous_positions()`, and `@transform.sample_position(entity, alpha)` from the unified transform package.
- Removed `@transform.previous_global_transforms()`, `@transform.capture_previous_global_transforms()`, `@transform.capture_previous_global_transforms_system(...)`, `@transform.sample_global_transform(...)`, and `@transform.sample_global_translation(...)`; transform-core interpolation snapshots are no longer part of the Bevy-aligned surface.
- Removed `Entity::spawn_child(offset=...)`, `Entity::set_offset(...)`, and `Entity::get_offset()`; child local offsets are now stored only in the child entity's `@transform.Transform`.
- Removed `Sprite.zindex` and `Sprite.offset`, along with the old `zindex` / `offset` constructor parameters on `Sprite::from_animation(...)`, `from_picture(...)`, `from_text(...)`, `from_color_rect(...)`, and `from_color_circle(...)`.
- Removed `selene/animation3d` and its legacy graph/player API surface (`AnimationGraph3D`, `AnimationPlayer3D`, `animation_players3d()`, `play_clip`, `play_state`, `set_animation_graph`, `trigger_animation`, `attach_animation_player`, `bind_animation_targets`, `animation3d_player_system`, and `animation3d_skinning_system`).
- Removed `@sprite.play_animation(...)`; 2D sprite playback now requires `@animation.AnimationPlayer` / `AnimationTransitions` over `Sprite.frame_index`.
- Removed `@animation.register_animation_clip(...)`, `register_animation_graph(...)`, `register_sprite_animation_clip(...)`, and `attach_sprite_animation_player(...)`; animation setup now goes through explicit clip/graph asset registration and local runtime wiring.
- Removed `@animation.AnimationMask`, `@animation.animation_masks()`, and the old string `@animation.AnimationEvent` bus; graph mask ownership now lives on `AnimationGraph`, and clip events now dispatch through typed descriptor handles.
- Removed `@scene3d.scene_instance_animation(...)` and `@scene.scene_animation(...)`; animation node lookup now goes through `SceneInstance.animations`.
- Removed the `transform3d` package and its alias APIs (`Transform3D`, `GlobalTransform3D`, `transforms3d()`, `global_transforms3d()`, `previous_global_transforms3d()`, `capture_previous_global_transforms3d*`, `sample_global_*3d`, and `transform3d_propagate_system`).
- Removed the `inherit` package and its bridge APIs (`transform_propagate_system` and `inherit_position_system`).
- Removed the `position` package and its legacy 2D position APIs (`Position`, `positions()`, `previous_positions()`, `capture_previous_positions()`, and `sample_position()`).
- Removed `SpriteType::{Picture, Animation, Text, ColorRect, ColorCircle}`, `Sprite::from_picture(...)`, `Sprite::from_animation(...)`, `Sprite::from_text(...)`, `Sprite::from_color_rect(...)`, `Sprite::from_color_circle(...)`, `@sprite.Picture`, `@sprite.Animation`, `@sprite.AnimationFrame`, `@sprite.ColorRect`, `@sprite.ColorCircle`, `@sprite.Text`, `@sprite.frames_from_atlas(...)`, `@sprite.Animation::single_frame(...)`, and `@sprite.Animation::single_frame_from_image(...)`.
- Removed `@sprite.SpriteFrameIndex`, `@sprite.sprite_frame_indices()`, and the old `@animation.sprite_frame_index_field()` surface; 2D animation now targets `TextureAtlas.index`.
- Removed `Sprite.visible` and the `visible?` argument from `Sprite::new(...)`; world-space 2D visibility now comes from `@visibility.visibilities()`.

## [0.28.7] - 2026-03-16

### Added

### Changed

- Changed `docs/tutorial-zh.md` and `docs/tutorial-en.md` to keep pre-`b94e8d44` narrative teaching style while updating all tutorial code/API references to current Selene runtime (`@app.App`, schedule-first `add_system`, `store()` accessors, `@inputs`, `@physics2d`, `@ui`, and wrapper-based backend overrides).

### Fixed

### Removed

## [0.28.6] - 2026-03-13

### Added

### Changed

- Changed local internal dependencies in `selene-webgpu/moon.mod.json`, `selene-raylib/moon.mod.json`, and `examples/moon.mod.json` to `path + version` form, so workspace development keeps local path resolution while enforcing version constraints.
- Changed `publish.py` release manifest rewrite to preserve local `path` and update internal Selene dependency `version` fields (instead of replacing them with plain version strings).
- Changed `publish.py` release flow to sync `examples/moon.mod.json` internal Selene dependency versions during releases.
- Changed `publish.py` post-publish behavior to run final `moon update` sync instead of restoring pre-release dependency snapshots.
- Changed GitHub Actions build workflow to remove OS-specific `moon.mod.json` `sed` rewrites for `selene-webgpu` and use direct `moon update/check/build`.

### Fixed

### Removed

## [0.28.5] - 2026-03-13

### Added

#### `selene/ldtk`

- Added `LdtkEntityInstance.tile : LdtkTilesetRect?`, populated from LDtk entity `__tile`.
- Added `ldtk_entity_tile_sprite(event, zindex?) -> @sprite.Sprite?` to build a placeholder sprite from entity `__tile` metadata and project tilesets.
- Added `insert_ldtk_entity_tile_sprite(event, zindex?) -> Bool` to insert the generated placeholder sprite into `@sprite.sprites()`.
- Added `register_ldtk_entity_tile_sprite_for_layer_optional(layer_identifier?, entity_identifier?, zindex_offset?)`.
- Added `register_ldtk_entity_tile_sprite_for_layer(layer_identifier, entity_identifier, zindex_offset?)`.
- Added `register_ldtk_entity_tile_sprite(entity_identifier, zindex_offset?)`.
- Added `register_default_ldtk_entity_tile_sprite_for_layer(layer_identifier, zindex_offset?)`.
- Added `register_default_ldtk_entity_tile_sprite(zindex_offset?)`.
- Added `add_ldtk_entity_tile_sprite_for_layer_optional(layer_identifier?, entity_identifier?, zindex_offset?)`.
- Added `add_ldtk_entity_tile_sprite_for_layer(layer_identifier, entity_identifier, zindex_offset?)`.
- Added `add_ldtk_entity_tile_sprite(entity_identifier, zindex_offset?)`.
- Added `add_default_ldtk_entity_tile_sprite_for_layer(layer_identifier, zindex_offset?)`.
- Added `add_default_ldtk_entity_tile_sprite(zindex_offset?)`.

#### `selene/app`

- Added `App::add_plugins(plugins : Array[Plugin]) -> App` for in-order plugin batch registration.
- Added `App::add_message(events)` for explicit message bus registration in app build flow.

#### `selene/event`

- Added `Events::register_to_world(world)` for world-scoped event bus registration without module `fn init`.

### Changed

#### `selene/app`

- Changed `Plugin` alias from `(App) -> Unit` to `(App) -> App`.
- Changed `App::add_plugin(plugin)` to apply plugin immediately instead of deferring plugin build to `App::run()`.

#### `selene/event`

- Changed event update and observer dispatch systems to process only buses registered for the current `World`, replacing the previous global bus list behavior.

#### `selene/plugins`

- Changed `default_plugin`, `default_3d_plugin`, and `debug_plugin` to return `App` and compose through chain-style app builders.
- Changed built-in bus registration flow to call `app.add_message(...)`.

### Fixed

#### `selene/ldtk`

- Fixed LDtk entity parsing to preserve `__tile` source rectangle data for runtime registrations and placeholder sprite insertion flows.

### Removed

#### `selene/app` + `selene/event`

- Removed `App::add_event`; use `App::add_message`.
- Removed `Events::register()`; use `Events::register_to_world(world)`.

#### runtime auto-init

- Removed all module-level `fn init { ...event_bus.register()... }` auto-registration blocks from `selene-core`; event bus registration is now explicit at app build time.

## [0.28.4] - 2026-03-13

### Changed

#### struct custom constructor migration

- Changed `selene-core` struct APIs to declare `fn new(...)` constructors in struct bodies (MoonBit custom constructor form) for:
  `SystemSet`, `InputAction`, `World`, `App`, `Vec3`, `Quat`, `Transform`, `ColorRect`, `ColorCircle`, `sprite.Text`, `Picture`, `Animation`, `CollisionGroup`, `CollisionFilter`, `Pickable`, `Collider`, `Area`, `JointLimits`, `JointSoftness`, `AudioPlayer`, `A11y`, `AnimationGraph3D`, `AnimationPlayer3D`, `BackgroundColor`, `BorderColor`, `BorderRadius`, `Outline`, `ShadowStyle`, `BoxShadow`, `UiImage`, `MaterialNode`, `UiGradient`, `UiMaterialContext`, `UiMaterialAsset`, `ui.Text`, `TextFont`, `TextColor`, `TextLayout`, `Button`, `UiRectValues`, `GridLine`, `Node`, `CalculatedClip`, `LayoutConfig`, `ZIndex`, `GlobalZIndex`, `TabIndex`, `Focused`, `Focusable`, `OverrideClip`, `RelativeCursorPosition`, `GamepadButtonInput`, `GamepadAxisInput`, and `Entity`.
- Changed generic constructor declarations to explicit generic constructor form in struct bodies:
  `State[T]::new`, `QueryReader[T]::new`, `EventReader[T]::new`, `EventWriter[T]::new`, `Events[T]::new`.
- Changed `selene-webgpu` backend struct `WebGpuBackend` to declare a struct constructor and use constructor call syntax during singleton initialization.
- Changed `entity.Entity` representation from tuple struct to named-field struct to support struct-constructor declaration while preserving allocation semantics of `Entity::new()` / `Entity::reserve_spawn()`.
- Changed `inputs.Gamepad` representation from tuple struct to named-field struct to support struct-constructor declaration while preserving `Gamepad::new(id)` / `Gamepad::id()` behavior.
- Changed target-specific package metadata to declare `supported-targets` for `selene_webgpu` (`js`), `selene_raylib` (`native`), and the `examples/*/web` main packages (`js`).

## [0.28.3] - 2026-03-12

### Added

#### `selene/time`

- Added `frame_delta()` to read frame-step delta regardless of current running schedule.
- Added `fixed_delta()` to read the currently configured fixed-step delta.
- Added `set_delta(delta)` to set the current schedule delta context explicitly.
- Added `use_frame_delta()` to switch current schedule delta context to frame-step delta.
- Added `use_fixed_delta(delta)` to switch current schedule delta context to fixed-step delta.

#### examples/survivors

- Added `examples/survivors/levelup_wbtest.mbt` regression tests covering level-up panel activation and click-to-resume behavior.

### Changed

#### `selene/app`

- Changed `System` type alias from `(@ecs.World, Double) -> Unit` to `(@ecs.World) -> Unit`.
- Changed `App::add_system(...)` signature to Bevy-style schedule-first form: `add_system(schedule, system, system_name?, in_set?, before?, after?, run_if?)`.
- Changed `App::add_systems(...)` signature to Bevy-style schedule-first form: `add_systems(schedule, systems_to_add, in_set?, before?, after?, run_if?)`.
- Changed `App::run()` stage execution to bind schedule-specific delta context through `selene/time` (`frame` vs `fixed`) before running systems.

#### examples

- Changed `examples/scene3d`, `examples/survivors`, `examples/pixeladventure`, and `examples/cards` to use schedule-first registration style (`add_system` / `add_systems`) with explicit time access.
- Changed registered system function signatures in all example packages from `(Double) -> Unit` to `(@ecs.World) -> Unit` (for example `setup_scene3d` / `game_start` / `player_state_system`), and migrated delta reads to `@time.delta()` inside systems.

### Fixed

#### `selene/ui`

- Fixed UI text alignment drift caused by applying `align/baseline` in both UI layout and renderer draw paths; renderer now draws pre-aligned UI text in top-left local mode to prevent double offsets.
- Fixed default UI hit-testing behavior so non-interactive nodes now pass pointer events by default (`FocusPolicy::Pass`) unless explicitly configured to block.

#### examples/survivors

- Fixed level-up freeze where gameplay paused at upgrade time but the powerup panel never appeared; level-up/game-over overlays now toggle visibility via `@ui.Node.active` and `@ui.Button.enabled` instead of `destroy/respawn`, preserving UI components across runtime cleanup.
- Fixed survivors pause-resume flow so selecting a level-up option consistently restores gameplay after UI interaction.
- Fixed missing level-up option icons after UI migration by restoring powerup/weapon icon rendering on upgrade buttons via `@ui.UiImage`.
- Fixed bullet hit/despawn behavior in `survivors` so projectile sprites are removed immediately on despawn instead of lingering for an extra timeout window.

#### examples/cards

- Fixed cards action buttons not responding to pointer clicks by setting text UI entities to `FocusPolicy::Pass`, so label layers no longer block pointer hit testing for underlying button entities.
- Fixed cards hand-strength multiplier text rendering by replacing unsupported `×` glyph with ASCII `x` for font-compatibility.

### Removed

#### `selene/app`

- Removed `App::add_system(system, schedule?, system_name?, in_set?, before?, after?, run_if?)`.
- Removed `App::add_systems(systems_to_add, schedule?, in_set?, before?, after?, run_if?)`.
- Removed `DeltaSystem` / `WorldDeltaSystem` / `SimpleRunCondition` public type aliases.
- Removed `delta_system(system)` / `world_delta_system(system)` / `simple_run_condition(condition)` public adapters.
- Removed `App::add_delta_system(...)` and `App::add_delta_systems(...)` public registration APIs.

## [0.28.2] - 2026-03-11

### Added

#### `selene/app` bevy-aligned runtime entrypoint package

- Added `System` type alias: `(@ecs.World, Double) -> Unit`.
- Added `RunCondition` type alias: `(@ecs.World) -> Bool`.
- Added `Plugin` type alias: `(App) -> Unit`.
- Added `RegisteredSystem` runtime descriptor (`system`, `schedule`, `name`, `in_set`, `before`, `after`, `run_if`).
- Added `App` public struct in `selene/app` with world-owned runtime configuration and schedule registry.
- Added `App::new()`.
- Added `App::with_world(world)`.
- Added `App::world()`.
- Added `App::with_image_smooth(image_smooth)`.
- Added `App::with_viewport_height(height)`.
- Added `App::with_viewport_width(width)`.
- Added `App::with_fps(fps)`.
- Added `App::with_fixed_hz(fixed_hz)`.
- Added `App::with_max_fixed_steps_per_frame(steps)`.
- Added `App::with_zoom(zoom)`.
- Added `App::add_plugin(plugin)`.
- Added `App::add_system(system, schedule?, system_name?, in_set?, before?, after?, run_if?)`.
- Added `App::add_systems(systems_to_add, schedule?, in_set?, before?, after?, run_if?)`.
- Added `App::run()`.

#### `selene/ecs` world container package

- Added `World` public struct (`pending_commands`, `frame_index`, `fixed_step_index`).
- Added `World::new()`.
- Added `World::queue_command(command)`.
- Added `World::has_pending_commands()`.
- Added `World::flush_commands()`.
- Added `World::advance_frame()`.
- Added `World::advance_fixed_step()`.
- Added `World::frame_index()`.
- Added `World::fixed_step_index()`.
- Added `World::id()`.
- Added `bootstrap_world()`.
- Added `current_world()`.
- Added `require_current_world()`.
- Added `set_current_world(world)`.
- Added `clear_current_world()`.
- Added `docs/bevy-api-mapping.md` to record legacy-to-bevy API mapping for this breaking migration wave.

#### world-scoped runtime helper APIs

- Added `camera3d.get_active_camera3d()`.
- Added `camera3d.set_active_camera3d(camera)`.

#### world-scoped component accessor APIs

- Added `position.positions()`.
- Added `position.previous_positions()`.
- Added `velocity.velocities()`.
- Added `transform.transforms()`.
- Added `transform.positions()`.
- Added `transform.global_transforms()`.
- Added `transform.previous_transforms()`.
- Added `transform.previous_positions()`.
- Added `transform3d.transforms3d()`.
- Added `transform3d.global_transforms3d()`.
- Added `transform3d.previous_global_transforms3d()`.
- Added `physics2d.linear_velocities()`.
- Added `physics2d.velocities()`.
- Added `sprite.sprites()`.
- Added `visibility.visibilities()`.
- Added `visibility.inherited_visibilities()`.
- Added `visibility.view_visibilities()`.
- Added `visibility.render_layers()`.
- Added `collision.rigid_bodies()`.
- Added `collision.colliders()`.
- Added `collision.resolved_velocities()`.
- Added `collision.grounded_entities()`.
- Added `collision.areas()`.
- Added `collision.shapes()`.
- Added `collision.joints()`.
- Added `collision.multibody_joints()`.
- Added `collision.pickables()`.
- Added `physics2d.colliders()`.
- Added `physics2d.rigid_bodies()`.
- Added `physics2d.joints()`.
- Added `physics2d.multibody_joints()`.
- Added `physics2d.sensors()`.
- Added `physics2d.areas()`.
- Added `physics2d.shapes()`.
- Added `physics2d.resolved_velocities()`.
- Added `physics2d.grounded_entities()`.
- Added `physics2d.pickables()`.
- Added `camera3d.cameras3d()`.
- Added `render3d.mesh3d_renderers()`.
- Added `render3d.directional_lights3d()`.
- Added `render3d.point_lights3d()`.
- Added `render3d.spot_lights3d()`.
- Added `physics3d.rigid_bodies3d()`.
- Added `physics3d.colliders3d()`.
- Added `physics3d.sensors3d()`.
- Added `physics3d.linear_velocities3d()`.
- Added `physics3d.angular_velocities3d()`.
- Added `animation3d.animation_players3d()`.
- Added `audio.audio_players()`.
- Added `audio.audio_playback_settings()`.
- Added `audio.audio_sinks()`.
- Added `a11y.a11ys()`.
- Added `inputs.connected_gamepads()`.
- Added `inputs.pressed_gamepad_buttons()`.
- Added `inputs.gamepad_axis_values()`.
- Added `inputs.just_connected_gamepads()`.
- Added `inputs.just_disconnected_gamepads()`.
- Added `inputs.just_pressed_gamepad_buttons()`.
- Added `inputs.just_released_gamepad_buttons()`.
- Added `tiled.tiled_map_instances()`.
- Added `tiled.tiled_layer_instances()`.
- Added `tiled.tiled_tile_instances()`.
- Added `tiled.tiled_object_instances()`.
- Added `tiled.tiled_image_layer_instances()`.
- Added `tiled.tiled_properties()`.
- Added `tiled.tiled_map_storages()`.
- Added `tiled.tiled_parallax_layers()`.
- Added `tiled.tiled_colliders()`.
- Added `tiled.tiled_collider_origins()`.
- Added `tiled.tiled_world_instances()`.
- Added `tiled.tiled_world_map_instances()`.
- Added `ldtk.ldtk_world_instances()`.
- Added `ldtk.ldtk_level_instances()`.
- Added `ldtk.ldtk_layer_metadata()`.
- Added `ldtk.ldtk_level_backgrounds()`.
- Added `ldtk.ldtk_level_iids()`.
- Added `ldtk.ldtk_entity_iids()`.
- Added `ldtk.ldtk_grid_coords()`.
- Added `ldtk.ldtk_int_grid_cells()`.
- Added `ldtk.ldtk_tile_metadata()`.
- Added `ldtk.ldtk_int_grid_colliders()`.
- Added `ldtk.ldtk_worldly_entities()`.
- Added `ldtk.ldtk_respawns()`.
- Added `ldtk.ldtk_spawned_layer_instances()`.
- Added `ldtk.ldtk_spawned_tile_instances()`.
- Added `ldtk.ldtk_spawned_entity_instances()`.
- Added `ldtk.ldtk_spawned_int_grid_cells()`.
- Added `ldtk.ldtk_entity_spawn_hooks()`.
- Added `ldtk.ldtk_entity_layer_spawn_hooks()`.
- Added `ldtk.ldtk_entity_layer_identifier_spawn_hooks()`.
- Added `ldtk.ldtk_entity_default_spawn_hook()`.
- Added `ldtk.ldtk_int_grid_layer_spawn_hooks()`.
- Added `ldtk.ldtk_int_grid_cell_spawn_hooks()`.
- Added `ldtk.ldtk_int_grid_value_spawn_hooks()`.
- Added `ldtk.ldtk_int_grid_default_spawn_hook()`.
- Added `ldtk.ldtk_entity_typed_registrations()`.
- Added `ldtk.ldtk_int_cell_typed_registrations()`.
- Added `ldtk.ldtk_pending_transformed_level_iids()`.
- Added `ui.nodes()`.
- Added `ui.computed_ui_nodes()`.
- Added `ui.global_ui_nodes()`.
- Added `ui.calculated_clips()`.
- Added `ui.layout_configs()`.
- Added `ui.z_indexes()`.
- Added `ui.global_zindexes()`.
- Added `ui.scroll_positions()`.
- Added `ui.tab_indexes()`.
- Added `ui.focus_policies()`.
- Added `ui.focusables()`.
- Added `ui.focuseds()`.
- Added `ui.override_clips()`.
- Added `ui.relative_cursor_positions()`.
- Added `ui.background_colors()`.
- Added `ui.border_colors()`.
- Added `ui.border_radii()`.
- Added `ui.box_shadows()`.
- Added `ui.outlines()`.
- Added `ui.ui_images()`.
- Added `ui.material_nodes()`.
- Added `ui.texts()`.
- Added `ui.text_fonts()`.
- Added `ui.text_colors()`.
- Added `ui.text_layouts()`.
- Added `ui.buttons()`.
- Added `ui.interactions()`.

### Changed

- `selene/commands` was migrated to world-owned deferred execution:
- `commands()` changed to `commands(world)`.
- `Commands::add` changed from `() -> Unit` to `(@ecs.World) -> Unit`.
- `has_pending_commands()` changed to `has_pending_commands(world)`.
- `commands_flush_system(delta)` changed to `commands_flush_system(world, delta)`.
- `selene/plugins` signatures now target the new app package:
- `debug_plugin` changed from `(@system.App) -> Unit` to `(@app.App) -> Unit`.
- `default_plugin` changed from `(@system.App) -> Unit` to `(@app.App) -> Unit`.
- `default_3d_plugin` changed from `(@system.App) -> Unit` to `(@app.App) -> Unit`.
- `selene/query` constructor and reader now require world context:
- `query(storage)` changed to `query(world, storage)`.
- `QueryReader::read(storage)` changed to `QueryReader::read(world, storage)`.
- `selene/entity` runtime storage is now world-scoped (entity lifecycle and hierarchy stores are keyed by active world id instead of a single global singleton store).
- `selene/state` transition runtime is now world-scoped (per-world frame serial and transition callback queues).
- `selene/event` event queues, observer queues, and reader cursors are now world-scoped (isolated by active world id).
- `selene/time` frame timing runtime (`raw_delta`, `delta`, `elapsed_raw`, `elapsed`, `scale`) is now world-scoped.
- `selene/system` display runtime (`viewport_size`, `screen_size`, `zoom`, `render_alpha`) is now world-scoped.
- `selene/camera` 2D camera runtime (`position/previous_position`, follow target, limits, axis-follow flags) is now world-scoped.
- `selene/ui` runtime state is now world-scoped:
- `hovered/pressed/focused` interaction markers moved to per-world runtime storage.
- `UiScaleMode` moved to per-world runtime storage behind `set_ui_scale_mode/get_ui_scale_mode`.
- `selene/render2d` frame command buffers are now world-scoped.
- `selene/render3d` extracted frame and lighting resource state (`ambient_light`, shadow-map settings) are now world-scoped.
- `selene/render3d_pipeline` prepared frame state is now world-scoped.
- `selene/physics3d` rapier runtime world and handle maps are now world-scoped.
- `selene/collision` 2D rapier runtime world, physics config-key caches, and pending force/impulse/joint sync queues are now world-scoped.
- `selene/position` component stores are now world-scoped and resolved via accessor functions.
- `selene/velocity` component store is now world-scoped and resolved via accessor function.
- `selene/transform` 2D transform alias stores are now world-scoped and resolved via accessor functions.
- `selene/transform3d` local/global/previous-global transform stores are now world-scoped and resolved via accessor functions.
- `selene/physics2d` velocity alias exports now resolve via accessor functions bound to the active world.
- `selene/sprite` component store is now world-scoped and resolved via accessor function.
- `selene/visibility` component/render-layer stores are now world-scoped and resolved via accessor functions.
- `selene/collision` authored 2D component stores (body/collider/area/shape/joint/pickable plus resolved/grounded caches) are now world-scoped and resolved via accessor functions.
- `selene/physics2d` collider/body/joint/area/shape/pickable alias exports now resolve through active-world accessor functions.
- `selene/camera3d` camera component store is now world-scoped and resolved via accessor function.
- `selene/render3d` mesh/light component stores are now world-scoped and resolved via accessor functions.
- `selene/physics3d` authored body/collider/sensor/velocity component stores are now world-scoped and resolved via accessor functions.
- `selene/animation3d` player and runtime target/skinning/morph maps are now world-scoped.
- `selene/audio` player/settings/sink component stores are now world-scoped and resolved via accessor functions.
- `selene/a11y` authored accessibility component store is now world-scoped and resolved via accessor function.
- `selene/inputs` gamepad runtime sets/maps (`connected`, `pressed`, axis cache and per-frame diffs) are now world-scoped and resolved via accessor functions.
- `selene/tiled` ECS/physics/world runtime stores are now world-scoped and resolved via accessor functions.
- `selene/ldtk` runtime component maps, spawned-instance maps, spawn-hook registries, typed-registration registries, and pending transformed-level cache are now world-scoped and resolved via accessor functions.
- `selene/ui` model/visual component stores are now world-scoped and resolved via accessor functions.
- `selene-raylib` text rendering now uses `moon_cosmic` first (for shaping/layout/rasterization) and falls back to raylib native `draw_text_ex` when cosmic font bytes are unavailable.
- Example entrypoints and tutorials now construct runtime through `@app.App::new()` and register systems as explicit world-aware closures.

### Removed

- Removed `system.App` and its methods from `selene/system`:
- Removed `App::new`.
- Removed `App::with_image_smooth`.
- Removed `App::with_viewport_height`.
- Removed `App::with_viewport_width`.
- Removed `App::with_fps`.
- Removed `App::with_fixed_hz`.
- Removed `App::with_max_fixed_steps_per_frame`.
- Removed `App::with_zoom`.
- Removed `App::add_plugin`.
- Removed `App::add_system`.
- Removed `App::add_systems`.
- Removed `App::run`.
- Removed ECS runtime type aliases from `selene/system`:
- Removed `type System = (Double) -> Unit`.
- Removed `type RunCondition = () -> Bool`.
- Removed the legacy `Plugin` alias with `Unit` return type.
- Removed snapshot-style query public API from `selene/query`:
- Removed `Snapshot[T]`.
- Removed `Added[T]`.
- Removed `Removed[T]`.
- Removed `Changed[T]`.
- Removed `snapshot_of(storage)`.
- Removed `added_since(snapshot, storage)`.
- Removed `removed_since(snapshot, storage)`.
- Removed `changed_since(snapshot, storage)`.
- Removed `Added::entities()`.
- Removed `Removed::entities()`.
- Removed `Changed::entities()`.
- Removed `camera3d.active_camera3d : Ref[ActiveCamera3D?]`; use `get_active_camera3d()`/`set_active_camera3d(...)`.
- Removed `ui.ui_scale_mode : Ref[UiScaleMode]`; use `get_ui_scale_mode()`/`set_ui_scale_mode(...)`.
- Removed `position.positions : Map[Entity, Position]`; use `position.positions()`.
- Removed `position.previous_positions : Map[Entity, Position]`; use `position.previous_positions()`.
- Removed `velocity.velocities : Map[Entity, Velocity]`; use `velocity.velocities()`.
- Removed `transform.transforms : Map[Entity, Transform]`; use `transform.transforms()`.
- Removed `transform.positions : Map[Entity, Transform]`; use `transform.positions()`.
- Removed `transform.global_transforms : Map[Entity, GlobalTransform]`; use `transform.global_transforms()`.
- Removed `transform.previous_transforms : Map[Entity, Transform]`; use `transform.previous_transforms()`.
- Removed `transform.previous_positions : Map[Entity, Transform]`; use `transform.previous_positions()`.
- Removed `transform3d.transforms3d : Map[Entity, Transform3D]`; use `transform3d.transforms3d()`.
- Removed `transform3d.global_transforms3d : Map[Entity, GlobalTransform3D]`; use `transform3d.global_transforms3d()`.
- Removed `transform3d.previous_global_transforms3d : Map[Entity, GlobalTransform3D]`; use `transform3d.previous_global_transforms3d()`.
- Removed `physics2d.linear_velocities : Map[Entity, LinearVelocity]`; use `physics2d.linear_velocities()`.
- Removed `physics2d.velocities : Map[Entity, Velocity]`; use `physics2d.velocities()`.
- Removed `sprite.sprites : Map[Entity, Sprite]`; use `sprite.sprites()`.
- Removed `visibility.visibilities : Map[Entity, Visibility]`; use `visibility.visibilities()`.
- Removed `visibility.inherited_visibilities : Map[Entity, InheritedVisibility]`; use `visibility.inherited_visibilities()`.
- Removed `visibility.view_visibilities : Map[Entity, ViewVisibility]`; use `visibility.view_visibilities()`.
- Removed `visibility.render_layers : Map[Entity, RenderLayers]`; use `visibility.render_layers()`.
- Removed `collision.rigid_bodies : Map[Entity, RigidBody]`; use `collision.rigid_bodies()`.
- Removed `collision.colliders : Map[Entity, Collider]`; use `collision.colliders()`.
- Removed `collision.resolved_velocities : Map[Entity, Velocity]`; use `collision.resolved_velocities()`.
- Removed `collision.grounded_entities : Set[Entity]`; use `collision.grounded_entities()`.
- Removed `collision.areas : Map[Entity, Area]`; use `collision.areas()`.
- Removed `collision.shapes : Map[Entity, CollisionShape]`; use `collision.shapes()`.
- Removed `collision.joints : Map[Entity, Joint]`; use `collision.joints()`.
- Removed `collision.multibody_joints : Map[Entity, MultibodyJoint]`; use `collision.multibody_joints()`.
- Removed `collision.pickables : Map[Entity, Pickable]`; use `collision.pickables()`.
- Removed `physics2d.colliders : Map[Entity, Collider]`; use `physics2d.colliders()`.
- Removed `physics2d.rigid_bodies : Map[Entity, RigidBody]`; use `physics2d.rigid_bodies()`.
- Removed `physics2d.joints : Map[Entity, Joint]`; use `physics2d.joints()`.
- Removed `physics2d.multibody_joints : Map[Entity, MultibodyJoint]`; use `physics2d.multibody_joints()`.
- Removed `physics2d.sensors : Map[Entity, Sensor]`; use `physics2d.sensors()`.
- Removed `physics2d.areas : Map[Entity, Area]`; use `physics2d.areas()`.
- Removed `physics2d.shapes : Map[Entity, ColliderShape]`; use `physics2d.shapes()`.
- Removed `physics2d.resolved_velocities : Map[Entity, LinearVelocity]`; use `physics2d.resolved_velocities()`.
- Removed `physics2d.grounded_entities : Set[Entity]`; use `physics2d.grounded_entities()`.
- Removed `physics2d.pickables : Map[Entity, Pickable]`; use `physics2d.pickables()`.
- Removed `camera3d.cameras3d : Map[Entity, Camera3DComponent]`; use `camera3d.cameras3d()`.
- Removed `render3d.mesh3d_renderers : Map[Entity, Mesh3DRenderer]`; use `render3d.mesh3d_renderers()`.
- Removed `render3d.directional_lights3d : Map[Entity, DirectionalLight3D]`; use `render3d.directional_lights3d()`.
- Removed `render3d.point_lights3d : Map[Entity, PointLight3D]`; use `render3d.point_lights3d()`.
- Removed `render3d.spot_lights3d : Map[Entity, SpotLight3D]`; use `render3d.spot_lights3d()`.
- Removed `physics3d.rigid_bodies3d : Map[Entity, RigidBody3D]`; use `physics3d.rigid_bodies3d()`.
- Removed `physics3d.colliders3d : Map[Entity, Collider3D]`; use `physics3d.colliders3d()`.
- Removed `physics3d.sensors3d : Map[Entity, Sensor3D]`; use `physics3d.sensors3d()`.
- Removed `physics3d.linear_velocities3d : Map[Entity, LinearVelocity3D]`; use `physics3d.linear_velocities3d()`.
- Removed `physics3d.angular_velocities3d : Map[Entity, AngularVelocity3D]`; use `physics3d.angular_velocities3d()`.
- Removed `animation3d.animation_players3d : Map[Entity, AnimationPlayer3D]`; use `animation3d.animation_players3d()`.
- Removed `audio.audio_players : Map[Entity, AudioPlayer]`; use `audio.audio_players()`.
- Removed `audio.audio_playback_settings : Map[Entity, PlaybackSettings]`; use `audio.audio_playback_settings()`.
- Removed `audio.audio_sinks : Map[Entity, AudioSink]`; use `audio.audio_sinks()`.
- Removed `a11y.a11ys : Map[Entity, A11y]`; use `a11y.a11ys()`.
- Removed `inputs.connected_gamepads : Set[Gamepad]`; use `inputs.connected_gamepads()`.
- Removed `inputs.pressed_gamepad_buttons : Set[GamepadButtonInput]`; use `inputs.pressed_gamepad_buttons()`.
- Removed `inputs.gamepad_axis_values : Map[GamepadAxisInput, Double]`; use `inputs.gamepad_axis_values()`.
- Removed `inputs.just_connected_gamepads : Set[Gamepad]`; use `inputs.just_connected_gamepads()`.
- Removed `inputs.just_disconnected_gamepads : Set[Gamepad]`; use `inputs.just_disconnected_gamepads()`.
- Removed `inputs.just_pressed_gamepad_buttons : Set[GamepadButtonInput]`; use `inputs.just_pressed_gamepad_buttons()`.
- Removed `inputs.just_released_gamepad_buttons : Set[GamepadButtonInput]`; use `inputs.just_released_gamepad_buttons()`.
- Removed `tiled.tiled_map_instances : Map[Entity, TiledMapInstance]`; use `tiled.tiled_map_instances()`.
- Removed `tiled.tiled_layer_instances : Map[Entity, TiledLayerInstance]`; use `tiled.tiled_layer_instances()`.
- Removed `tiled.tiled_tile_instances : Map[Entity, TiledTileInstance]`; use `tiled.tiled_tile_instances()`.
- Removed `tiled.tiled_object_instances : Map[Entity, TiledObjectInstance]`; use `tiled.tiled_object_instances()`.
- Removed `tiled.tiled_image_layer_instances : Map[Entity, TiledImageLayerInstance]`; use `tiled.tiled_image_layer_instances()`.
- Removed `tiled.tiled_properties : Map[Entity, TiledProperties]`; use `tiled.tiled_properties()`.
- Removed `tiled.tiled_map_storages : Map[Entity, TiledMapStorage]`; use `tiled.tiled_map_storages()`.
- Removed `tiled.tiled_parallax_layers : Map[Entity, TiledParallaxLayer]`; use `tiled.tiled_parallax_layers()`.
- Removed `tiled.tiled_colliders : Map[Entity, TiledColliders]`; use `tiled.tiled_colliders()`.
- Removed `tiled.tiled_collider_origins : Map[Entity, TiledColliderOrigin]`; use `tiled.tiled_collider_origins()`.
- Removed `tiled.tiled_world_instances : Map[Entity, TiledWorldInstance]`; use `tiled.tiled_world_instances()`.
- Removed `tiled.tiled_world_map_instances : Map[Entity, TiledWorldMapInstance]`; use `tiled.tiled_world_map_instances()`.
- Removed `ldtk.ldtk_world_instances : Map[Entity, LdtkWorldInstance]`; use `ldtk.ldtk_world_instances()`.
- Removed `ldtk.ldtk_level_instances : Map[Entity, LdtkLevelInstance]`; use `ldtk.ldtk_level_instances()`.
- Removed `ldtk.ldtk_layer_metadata : Map[Entity, LdtkLayerMetadata]`; use `ldtk.ldtk_layer_metadata()`.
- Removed `ldtk.ldtk_level_backgrounds : Map[Entity, LdtkLevelBackground]`; use `ldtk.ldtk_level_backgrounds()`.
- Removed `ldtk.ldtk_level_iids : Map[Entity, LdtkLevelIid]`; use `ldtk.ldtk_level_iids()`.
- Removed `ldtk.ldtk_entity_iids : Map[Entity, LdtkEntityIid]`; use `ldtk.ldtk_entity_iids()`.
- Removed `ldtk.ldtk_grid_coords : Map[Entity, LdtkGridCoords]`; use `ldtk.ldtk_grid_coords()`.
- Removed `ldtk.ldtk_int_grid_cells : Map[Entity, LdtkIntGridCell]`; use `ldtk.ldtk_int_grid_cells()`.
- Removed `ldtk.ldtk_tile_metadata : Map[Entity, LdtkTileMetadata]`; use `ldtk.ldtk_tile_metadata()`.
- Removed `ldtk.ldtk_int_grid_colliders : Map[Entity, LdtkIntGridCollider]`; use `ldtk.ldtk_int_grid_colliders()`.
- Removed `ldtk.ldtk_worldly_entities : Map[Entity, LdtkWorldly]`; use `ldtk.ldtk_worldly_entities()`.
- Removed `ldtk.ldtk_respawns : Map[Entity, LdtkRespawn]`; use `ldtk.ldtk_respawns()`.
- Removed `ldtk.ldtk_spawned_layer_instances : Map[Entity, LdtkSpawnedLayerInstance]`; use `ldtk.ldtk_spawned_layer_instances()`.
- Removed `ldtk.ldtk_spawned_tile_instances : Map[Entity, LdtkSpawnedTileInstance]`; use `ldtk.ldtk_spawned_tile_instances()`.
- Removed `ldtk.ldtk_spawned_entity_instances : Map[Entity, LdtkSpawnedEntityInstance]`; use `ldtk.ldtk_spawned_entity_instances()`.
- Removed `ldtk.ldtk_spawned_int_grid_cells : Map[Entity, LdtkSpawnedIntGridCell]`; use `ldtk.ldtk_spawned_int_grid_cells()`.
- Removed `ldtk.ldtk_entity_spawn_hooks : Map[String, (LdtkEntitySpawnedEvent) -> Unit]`; use `ldtk.ldtk_entity_spawn_hooks()`.
- Removed `ldtk.ldtk_entity_layer_spawn_hooks : Map[String, (LdtkEntitySpawnedEvent) -> Unit]`; use `ldtk.ldtk_entity_layer_spawn_hooks()`.
- Removed `ldtk.ldtk_entity_layer_identifier_spawn_hooks : Map[String, (LdtkEntitySpawnedEvent) -> Unit]`; use `ldtk.ldtk_entity_layer_identifier_spawn_hooks()`.
- Removed `ldtk.ldtk_entity_default_spawn_hook : Ref[((LdtkEntitySpawnedEvent) -> Unit)?]`; use `ldtk.ldtk_entity_default_spawn_hook()`.
- Removed `ldtk.ldtk_int_grid_layer_spawn_hooks : Map[String, (LdtkIntGridCellSpawnedEvent) -> Unit]`; use `ldtk.ldtk_int_grid_layer_spawn_hooks()`.
- Removed `ldtk.ldtk_int_grid_cell_spawn_hooks : Map[String, (LdtkIntGridCellSpawnedEvent) -> Unit]`; use `ldtk.ldtk_int_grid_cell_spawn_hooks()`.
- Removed `ldtk.ldtk_int_grid_value_spawn_hooks : Map[String, (LdtkIntGridCellSpawnedEvent) -> Unit]`; use `ldtk.ldtk_int_grid_value_spawn_hooks()`.
- Removed `ldtk.ldtk_int_grid_default_spawn_hook : Ref[((LdtkIntGridCellSpawnedEvent) -> Unit)?]`; use `ldtk.ldtk_int_grid_default_spawn_hook()`.
- Removed `ldtk.ldtk_entity_typed_registrations : Map[String, (LdtkEntitySpawnedEvent) -> Unit]`; use `ldtk.ldtk_entity_typed_registrations()`.
- Removed `ldtk.ldtk_int_cell_typed_registrations : Map[String, (LdtkIntGridCellSpawnedEvent) -> Unit]`; use `ldtk.ldtk_int_cell_typed_registrations()`.
- Removed `ldtk.ldtk_pending_transformed_level_iids : Map[String, Bool]`; use `ldtk.ldtk_pending_transformed_level_iids()`.
- Removed `ui.nodes : Map[Entity, Node]`; use `ui.nodes()`.
- Removed `ui.computed_ui_nodes : Map[Entity, ComputedUiNode]`; use `ui.computed_ui_nodes()`.
- Removed `ui.global_ui_nodes : Map[Entity, GlobalUiNode]`; use `ui.global_ui_nodes()`.
- Removed `ui.calculated_clips : Map[Entity, CalculatedClip]`; use `ui.calculated_clips()`.
- Removed `ui.layout_configs : Map[Entity, LayoutConfig]`; use `ui.layout_configs()`.
- Removed `ui.z_indexes : Map[Entity, ZIndex]`; use `ui.z_indexes()`.
- Removed `ui.global_zindexes : Map[Entity, GlobalZIndex]`; use `ui.global_zindexes()`.
- Removed `ui.scroll_positions : Map[Entity, ScrollPosition]`; use `ui.scroll_positions()`.
- Removed `ui.tab_indexes : Map[Entity, TabIndex]`; use `ui.tab_indexes()`.
- Removed `ui.focus_policies : Map[Entity, FocusPolicy]`; use `ui.focus_policies()`.
- Removed `ui.focusables : Map[Entity, Focusable]`; use `ui.focusables()`.
- Removed `ui.focuseds : Map[Entity, Focused]`; use `ui.focuseds()`.
- Removed `ui.override_clips : Map[Entity, OverrideClip]`; use `ui.override_clips()`.
- Removed `ui.relative_cursor_positions : Map[Entity, RelativeCursorPosition]`; use `ui.relative_cursor_positions()`.
- Removed `ui.background_colors : Map[Entity, BackgroundColor]`; use `ui.background_colors()`.
- Removed `ui.border_colors : Map[Entity, BorderColor]`; use `ui.border_colors()`.
- Removed `ui.border_radii : Map[Entity, BorderRadius]`; use `ui.border_radii()`.
- Removed `ui.box_shadows : Map[Entity, BoxShadow]`; use `ui.box_shadows()`.
- Removed `ui.outlines : Map[Entity, Outline]`; use `ui.outlines()`.
- Removed `ui.ui_images : Map[Entity, UiImage]`; use `ui.ui_images()`.
- Removed `ui.material_nodes : Map[Entity, MaterialNode]`; use `ui.material_nodes()`.
- Removed `ui.texts : Map[Entity, Text]`; use `ui.texts()`.
- Removed `ui.text_fonts : Map[Entity, TextFont]`; use `ui.text_fonts()`.
- Removed `ui.text_colors : Map[Entity, TextColor]`; use `ui.text_colors()`.
- Removed `ui.text_layouts : Map[Entity, TextLayout]`; use `ui.text_layouts()`.
- Removed `ui.buttons : Map[Entity, Button]`; use `ui.buttons()`.
- Removed `ui.interactions : Map[Entity, Interaction]`; use `ui.interactions()`.

## [0.28.1] - 2026-03-11

### Added

#### `selene/ldtk` typed registration APIs (bevy-style optional scope + priority lookup)

- `ldtk_entity_typed_registrations`: typed LDtk entity registration map keyed by optional `(layer_identifier, entity_identifier)` scope.
- `ldtk_int_cell_typed_registrations`: typed LDtk int-cell registration map keyed by optional `(layer_identifier, value)` scope.
- `register_ldtk_entity_for_layer_optional(layer_identifier?, entity_identifier?, hook)`: registers typed LDtk entity handler with optional layer/entity scope.
- `register_ldtk_entity_for_layer(layer_identifier, entity_identifier, hook)`: registers typed LDtk entity handler for a specific layer+entity scope.
- `register_ldtk_entity(entity_identifier, hook)`: registers typed LDtk entity handler for an entity identifier across layers.
- `register_default_ldtk_entity_for_layer(layer_identifier, hook)`: registers typed LDtk entity handler for all entities on a layer.
- `register_default_ldtk_entity(hook)`: registers typed LDtk entity fallback handler for all layers/entities.
- `unregister_ldtk_entity_for_layer_optional(layer_identifier?, entity_identifier?)`: removes typed LDtk entity handler by optional scope.
- `unregister_ldtk_entity_for_layer(layer_identifier, entity_identifier)`: removes typed LDtk entity handler for a specific layer+entity scope.
- `unregister_ldtk_entity(entity_identifier)`: removes typed LDtk entity handler for an entity identifier across layers.
- `unregister_default_ldtk_entity_for_layer(layer_identifier)`: removes typed LDtk entity layer-default handler.
- `unregister_default_ldtk_entity()`: removes typed LDtk entity global-default handler.
- `clear_ldtk_entity_registrations()`: clears all typed LDtk entity registrations.
- `register_ldtk_int_cell_for_layer_optional(layer_identifier?, value?, hook)`: registers typed LDtk int-cell handler with optional layer/value scope.
- `register_ldtk_int_cell_for_layer(layer_identifier, value, hook)`: registers typed LDtk int-cell handler for a specific layer+value scope.
- `register_ldtk_int_cell(value, hook)`: registers typed LDtk int-cell handler for a value across layers.
- `register_default_ldtk_int_cell_for_layer(layer_identifier, hook)`: registers typed LDtk int-cell handler for all values on a layer.
- `register_default_ldtk_int_cell(hook)`: registers typed LDtk int-cell fallback handler for all layers/values.
- `unregister_ldtk_int_cell_for_layer_optional(layer_identifier?, value?)`: removes typed LDtk int-cell handler by optional scope.
- `unregister_ldtk_int_cell_for_layer(layer_identifier, value)`: removes typed LDtk int-cell handler for a specific layer+value scope.
- `unregister_ldtk_int_cell(value)`: removes typed LDtk int-cell handler for a value across layers.
- `unregister_default_ldtk_int_cell_for_layer(layer_identifier)`: removes typed LDtk int-cell layer-default handler.
- `unregister_default_ldtk_int_cell()`: removes typed LDtk int-cell global-default handler.
- `clear_ldtk_int_cell_registrations()`: clears all typed LDtk int-cell registrations.

#### `selene/ldtk` bundle-like additive registration helpers (derive alternative)

- `add_ldtk_entity_registration_for_layer_optional(layer_identifier?, entity_identifier?, hook)`: appends an entity typed handler for a scope; if the scope already has a handler, both handlers run in registration order.
- `add_ldtk_entity_registration_for_layer(layer_identifier, entity_identifier, hook)`: appends an entity typed handler for a specific layer+entity scope.
- `add_ldtk_entity_registration(entity_identifier, hook)`: appends an entity typed handler for an entity identifier across layers.
- `add_default_ldtk_entity_registration_for_layer(layer_identifier, hook)`: appends an entity typed handler for all entities on a layer.
- `add_default_ldtk_entity_registration(hook)`: appends an entity typed fallback handler for all layers/entities.
- `add_ldtk_entity_component_for_layer_optional(layer_identifier?, entity_identifier?, storage, make)`: appends a scope-matched entity handler that inserts a generated component value into a component map.
- `add_ldtk_entity_component_for_layer(layer_identifier, entity_identifier, storage, make)`: appends component insertion for a specific layer+entity scope.
- `add_ldtk_entity_component(entity_identifier, storage, make)`: appends component insertion for an entity identifier across layers.
- `add_default_ldtk_entity_component_for_layer(layer_identifier, storage, make)`: appends component insertion for all entities on a layer.
- `add_default_ldtk_entity_component(storage, make)`: appends component insertion for all entities/layers.
- `add_ldtk_int_cell_registration_for_layer_optional(layer_identifier?, value?, hook)`: appends an int-cell typed handler for a scope; if the scope already has a handler, both handlers run in registration order.
- `add_ldtk_int_cell_registration_for_layer(layer_identifier, value, hook)`: appends an int-cell typed handler for a specific layer+value scope.
- `add_ldtk_int_cell_registration(value, hook)`: appends an int-cell typed handler for a value across layers.
- `add_default_ldtk_int_cell_registration_for_layer(layer_identifier, hook)`: appends an int-cell typed handler for all values on a layer.
- `add_default_ldtk_int_cell_registration(hook)`: appends an int-cell typed fallback handler for all layers/values.
- `add_ldtk_int_cell_component_for_layer_optional(layer_identifier?, value?, storage, make)`: appends a scope-matched int-cell handler that inserts a generated component value into a component map.
- `add_ldtk_int_cell_component_for_layer(layer_identifier, value, storage, make)`: appends component insertion for a specific layer+value scope.
- `add_ldtk_int_cell_component(value, storage, make)`: appends component insertion for a value across layers.
- `add_default_ldtk_int_cell_component_for_layer(layer_identifier, storage, make)`: appends component insertion for all values on a layer.
- `add_default_ldtk_int_cell_component(storage, make)`: appends component insertion for all values/layers.

### Changed

- `spawn_ldtk_world(...)` typed registration behavior now mirrors bevy optional-scope precedence for both entities and int-cells: `(layer+identifier/value) -> (identifier/value) -> (layer) -> (default)`, with only the highest-priority match executed.
- `spawn_ldtk_world(...)` int-grid tileset rendering now combines `gridTiles` and `autoLayerTiles`, filters out-of-bounds tiles, and renders overlapping tiles in deterministic stacked sublayers (higher sublayer gets higher z-index), aligning with bevy_ecs_ldtk layer splitting behavior.
- `selene/ldtk` documentation now includes a `src/ldtk/README.md` template showing no-derive bundle-like registration with `add_*` and component insertion helpers.

## [0.28.0] - 2026-03-11

### Added

#### `selene/ldtk` project data and selection APIs

- `LdtkLevelIndices`: index locator for LDtk levels (`world`, `level`).
- `LdtkLevelIndices::in_world(world_index, level_index)`: constructs world-scoped level indices.
- `LdtkLevelIndices::in_root(index)`: constructs root-level indices.
- `LdtkLevelIndices::equals(other)`: compares two level-index locators.
- `LdtkLevelSelection`: level selector union (`Identifier`, `Indices`, `Iid`, `Uid`).
- `default_ldtk_level_selection()`: returns default selection (`Indices(in_root(0))`).
- `ldtk_level_selection_iid(iid)`: constructs `LdtkLevelSelection::Iid`.
- `ldtk_level_selection_identifier(identifier)`: constructs `LdtkLevelSelection::Identifier`.
- `ldtk_level_selection_index(level_index)`: constructs root-index selection.
- `ldtk_level_selection_indices(world_index, level_index)`: constructs world+level index selection.
- `ldtk_level_selection_uid(uid)`: constructs `LdtkLevelSelection::Uid`.
- `LdtkLevelSelection::is_match(indices, level)`: tests whether a level matches a selection.
- `LdtkLevelSpawnBehavior`: level transform behavior (`UseZeroTranslation`, `UseWorldTranslation(load_level_neighbors)`).
- `ldtk_level_spawn_behavior_world_translation(load_level_neighbors)`: helper to construct world-translation spawn behavior.
- `LdtkIntGridRendering`: int-grid render policy (`Colorful`, `Invisible`).
- `LdtkSpawnExclusions`: spawn exclusion payload for layer identifiers.
- `default_ldtk_spawn_exclusions()`: returns empty spawn exclusions payload.
- `LdtkSpawnExclusions::excludes_layer(identifier)`: checks whether a layer identifier is excluded from spawning.
- `LdtkIntGridPhysicsSettings`: global int-grid physics spawn settings payload (`enabled`, layer/value filters, sensor mode, collision/sensor filters).
- `default_ldtk_int_grid_physics_settings()`: returns default disabled int-grid physics settings.
- `LdtkIntGridPhysicsSettings::matches(layer_identifier, value)`: checks whether a layer/value pair should spawn int-grid physics.
- `LdtkSettings`: LDtk runtime settings payload.
- `default_ldtk_settings()`: returns default LDtk settings.
- `ldtk_settings`: global LDtk settings ref.
- `ldtk_int_grid_physics_settings`: global int-grid physics settings ref.
- `ldtk_level_selection`: global LDtk selection ref.
- `set_ldtk_settings(settings)`: updates global LDtk settings.
- `set_ldtk_int_grid_physics_settings(settings)`: updates global int-grid physics settings.
- `set_ldtk_level_selection(selection)`: updates global LDtk level selection.
- `LdtkLevelSet`: desired spawned-level IID set payload.
- `empty_ldtk_level_set()`: returns an empty desired level set.
- `ldtk_level_set_from_iids(iids)`: constructs a deduplicated level set from IID list.
- `LdtkLevelSet::contains(iid)`: checks whether an IID is in the level set.
- `LdtkLevelSet::to_array()`: returns level set IIDs as an array.
- `ldtk_level_set_equals(left, right)`: compares two level sets.
- `LdtkNeighbour`: parsed neighbor link payload (`level_iid`, `dir`).
- `LdtkEntityReference`: typed LDtk `EntityRef` payload (`entity_iid`, `level_iid`, `world_iid`, `layer_iid`).
- `empty_ldtk_entity_reference()`: returns an empty `LdtkEntityReference` payload.
- `LdtkTilesetRect`: typed LDtk `Tile` field payload (`tileset_uid`, `x`, `y`, `w`, `h`).
- `empty_ldtk_tileset_rect()`: returns an empty `LdtkTilesetRect` payload.
- `LdtkFieldInstance`: parsed field instance payload (`identifier`, `value_type`, `value`, `def_uid`).
- `LdtkFieldInstance::bool_value()`: decodes field value as `Bool` (supports bool/string/number JSON forms).
- `LdtkFieldInstance::int_value()`: decodes field value as `Int`.
- `LdtkFieldInstance::string_value()`: decodes field value as `String`.
- `LdtkFieldInstance::color_value()`: decodes field value as color string.
- `LdtkFieldInstance::file_path_value()`: decodes field value as file-path string.
- `LdtkFieldInstance::enum_value()`: decodes field value as enum identifier string.
- `LdtkFieldInstance::number_value()`: decodes field value as `Double`.
- `LdtkFieldInstance::vec2_value()`: decodes field value as `Vec2D` from array/object point payloads.
- `LdtkFieldInstance::int_array_value()`: decodes field value as `Array[Int]`.
- `LdtkFieldInstance::number_array_value()`: decodes field value as `Array[Double]`.
- `LdtkFieldInstance::string_array_value()`: decodes field value as `Array[String]`.
- `LdtkFieldInstance::bool_array_value()`: decodes field value as `Array[Bool]`.
- `LdtkFieldInstance::vec2_array_value()`: decodes field value as `Array[Vec2D]`.
- `LdtkFieldInstance::color_array_value()`: decodes field value as color string array.
- `LdtkFieldInstance::file_path_array_value()`: decodes field value as file-path string array.
- `LdtkFieldInstance::enum_array_value()`: decodes field value as enum identifier string array.
- `LdtkFieldInstance::entity_iid_value()`: decodes field value as single entity reference IID.
- `LdtkFieldInstance::entity_iids_value()`: decodes field value as entity reference IID array.
- `LdtkFieldInstance::entity_ref_value()`: decodes field value as typed `LdtkEntityReference`.
- `LdtkFieldInstance::entity_refs_value()`: decodes field value as typed `Array[LdtkEntityReference]`.
- `LdtkFieldInstance::tile_value()`: decodes field value as typed `LdtkTilesetRect`.
- `LdtkFieldInstance::tile_array_value()`: decodes field value as typed `Array[LdtkTilesetRect]`.
- `ldtk_field_instance(field_instances, identifier)`: finds a field instance by identifier.
- `ldtk_field_bool(field_instances, identifier)`: finds and decodes a field value as `Bool`.
- `ldtk_field_int(field_instances, identifier)`: finds and decodes a field value as `Int`.
- `ldtk_field_string(field_instances, identifier)`: finds and decodes a field value as `String`.
- `ldtk_field_color(field_instances, identifier)`: finds and decodes a field value as color string.
- `ldtk_field_file_path(field_instances, identifier)`: finds and decodes a field value as file-path string.
- `ldtk_field_enum(field_instances, identifier)`: finds and decodes a field value as enum identifier string.
- `ldtk_field_number(field_instances, identifier)`: finds and decodes a field value as `Double`.
- `ldtk_field_vec2(field_instances, identifier)`: finds and decodes a field value as `Vec2D`.
- `ldtk_field_int_array(field_instances, identifier)`: finds and decodes a field value as `Array[Int]`.
- `ldtk_field_number_array(field_instances, identifier)`: finds and decodes a field value as `Array[Double]`.
- `ldtk_field_string_array(field_instances, identifier)`: finds and decodes a field value as `Array[String]`.
- `ldtk_field_bool_array(field_instances, identifier)`: finds and decodes a field value as `Array[Bool]`.
- `ldtk_field_vec2_array(field_instances, identifier)`: finds and decodes a field value as `Array[Vec2D]`.
- `ldtk_field_color_array(field_instances, identifier)`: finds and decodes a field value as color string array.
- `ldtk_field_file_path_array(field_instances, identifier)`: finds and decodes a field value as file-path string array.
- `ldtk_field_enum_array(field_instances, identifier)`: finds and decodes a field value as enum identifier string array.
- `ldtk_field_entity_iid(field_instances, identifier)`: finds and decodes a field value as referenced entity IID.
- `ldtk_field_entity_iids(field_instances, identifier)`: finds and decodes a field value as referenced entity IID list.
- `ldtk_field_entity_ref(field_instances, identifier)`: finds and decodes a field value as typed `LdtkEntityReference`.
- `ldtk_field_entity_refs(field_instances, identifier)`: finds and decodes a field value as typed `Array[LdtkEntityReference]`.
- `ldtk_field_tile(field_instances, identifier)`: finds and decodes a field value as typed `LdtkTilesetRect`.
- `ldtk_field_tiles(field_instances, identifier)`: finds and decodes a field value as typed `Array[LdtkTilesetRect]`.
- `LdtkTileInstance`: parsed tile instance payload (`tile_id`, `src`, `px`, flip, alpha, internal `d` data).
- `LdtkEntityInstance`: parsed entity instance payload (including LDtk entity tags from `__tags`/`tags`).
- `LdtkEntityInstance::field(identifier)`: finds an entity field instance by identifier.
- `LdtkEntityInstance::field_bool(identifier)`: reads an entity field as `Bool`.
- `LdtkEntityInstance::field_int(identifier)`: reads an entity field as `Int`.
- `LdtkEntityInstance::field_string(identifier)`: reads an entity field as `String`.
- `LdtkEntityInstance::field_color(identifier)`: reads an entity field as color string.
- `LdtkEntityInstance::field_file_path(identifier)`: reads an entity field as file-path string.
- `LdtkEntityInstance::field_enum(identifier)`: reads an entity field as enum identifier string.
- `LdtkEntityInstance::field_number(identifier)`: reads an entity field as `Double`.
- `LdtkEntityInstance::field_vec2(identifier)`: reads an entity field as `Vec2D`.
- `LdtkEntityInstance::field_int_array(identifier)`: reads an entity field as `Array[Int]`.
- `LdtkEntityInstance::field_number_array(identifier)`: reads an entity field as `Array[Double]`.
- `LdtkEntityInstance::field_string_array(identifier)`: reads an entity field as `Array[String]`.
- `LdtkEntityInstance::field_bool_array(identifier)`: reads an entity field as `Array[Bool]`.
- `LdtkEntityInstance::field_vec2_array(identifier)`: reads an entity field as `Array[Vec2D]`.
- `LdtkEntityInstance::field_color_array(identifier)`: reads an entity field as color string array.
- `LdtkEntityInstance::field_file_path_array(identifier)`: reads an entity field as file-path string array.
- `LdtkEntityInstance::field_enum_array(identifier)`: reads an entity field as enum identifier string array.
- `LdtkEntityInstance::field_entity_iid(identifier)`: reads an entity field as single referenced entity IID.
- `LdtkEntityInstance::field_entity_iids(identifier)`: reads an entity field as referenced entity IID list.
- `LdtkEntityInstance::field_entity_ref(identifier)`: reads an entity field as typed `LdtkEntityReference`.
- `LdtkEntityInstance::field_entity_refs(identifier)`: reads an entity field as typed `Array[LdtkEntityReference]`.
- `LdtkEntityInstance::field_tile(identifier)`: reads an entity field as typed `LdtkTilesetRect`.
- `LdtkEntityInstance::field_tiles(identifier)`: reads an entity field as typed `Array[LdtkTilesetRect]`.
- `LdtkEntityInstance::has_tag(tag)`: checks whether an entity instance includes a specific LDtk tag.
- `LdtkLayerInstance`: parsed layer instance payload.
- `LdtkLevelBackgroundPosition`: parsed level background placement payload (`crop_x`, `crop_y`, `crop_width`, `crop_height`, `scale`, `top_left_px`).
- `LdtkLevel`: parsed level payload (including optional `bg_pos`).
- `LdtkLevel::field(identifier)`: finds a level field instance by identifier.
- `LdtkLevel::field_bool(identifier)`: reads a level field as `Bool`.
- `LdtkLevel::field_int(identifier)`: reads a level field as `Int`.
- `LdtkLevel::field_string(identifier)`: reads a level field as `String`.
- `LdtkLevel::field_color(identifier)`: reads a level field as color string.
- `LdtkLevel::field_file_path(identifier)`: reads a level field as file-path string.
- `LdtkLevel::field_enum(identifier)`: reads a level field as enum identifier string.
- `LdtkLevel::field_number(identifier)`: reads a level field as `Double`.
- `LdtkLevel::field_vec2(identifier)`: reads a level field as `Vec2D`.
- `LdtkLevel::field_int_array(identifier)`: reads a level field as `Array[Int]`.
- `LdtkLevel::field_number_array(identifier)`: reads a level field as `Array[Double]`.
- `LdtkLevel::field_string_array(identifier)`: reads a level field as `Array[String]`.
- `LdtkLevel::field_bool_array(identifier)`: reads a level field as `Array[Bool]`.
- `LdtkLevel::field_vec2_array(identifier)`: reads a level field as `Array[Vec2D]`.
- `LdtkLevel::field_color_array(identifier)`: reads a level field as color string array.
- `LdtkLevel::field_file_path_array(identifier)`: reads a level field as file-path string array.
- `LdtkLevel::field_enum_array(identifier)`: reads a level field as enum identifier string array.
- `LdtkLevel::field_entity_iid(identifier)`: reads a level field as single referenced entity IID.
- `LdtkLevel::field_entity_iids(identifier)`: reads a level field as referenced entity IID list.
- `LdtkLevel::field_entity_ref(identifier)`: reads a level field as typed `LdtkEntityReference`.
- `LdtkLevel::field_entity_refs(identifier)`: reads a level field as typed `Array[LdtkEntityReference]`.
- `LdtkLevel::field_tile(identifier)`: reads a level field as typed `LdtkTilesetRect`.
- `LdtkLevel::field_tiles(identifier)`: reads a level field as typed `Array[LdtkTilesetRect]`.
- `LdtkWorld`: parsed world payload.
- `LdtkTilesetDefinition`: parsed tileset definition payload (atlas metrics + spacing/padding + tileset tags + per-tile custom data + per-tile enum tags metadata).
- `LdtkTilesetCustomData`: parsed per-tile custom metadata payload (`tile_id`, `data`) from tileset `customData`.
- `LdtkTilesetEnumTag`: parsed tileset enum-tag payload (`enum_value_id`, `tile_ids`) from tileset `enumTags`.
- `LdtkIntGridValueDefinition`: parsed int-grid value definition payload (`value`, `color`, `identifier`).
- `LdtkLayerDefinition`: parsed layer-definition payload (`uid`, `identifier`, `type`, `int_grid_values`).
- `LdtkFieldDefinition`: parsed entity-field definition payload (`uid`, `identifier`, field type, nullability, default override).
- `LdtkEntityDefinition`: parsed entity definition payload (`uid`, `identifier`, dimensions, color, tags, field definitions).
- `LdtkEnumValueDefinition`: parsed enum value definition payload (`id`, `color`).
- `LdtkEnumDefinition`: parsed enum definition payload (`uid`, `identifier`, external path, tags, values).
- `LdtkProjectDefinitions`: parsed project definitions payload (tilesets, layers, entities, enums, external enums).
- `LdtkProject`: parsed project payload with source path, defs, root levels, and worlds.
- `LdtkIndexedLevel`: indexed level payload (`indices`, `level`).
- `empty_ldtk_project_definitions()`: returns empty LDtk definitions payload.
- `empty_ldtk_level()`: returns empty LDtk level payload.
- `empty_ldtk_project()`: returns empty LDtk project payload.
- `load_ldtk_project(path)`: loads `.ldtk` project JSON and resolves external levels.
- `load_ldtk_project_raw(path)`: loads `.ldtk` project JSON without resolving external `.ldtkl` payloads.
- `LdtkProject::from_ldtk_json(json)`: parses project payload from JSON value.
- `LdtkProject::resolve_path(path)`: resolves project-relative file paths.
- `LdtkProject::indexed_levels()`: returns flattened root/world level list with indices.
- `LdtkProject::raw_indexed_levels()`: returns flattened root/world level list from raw project JSON (before external-level merge).
- `LdtkProject::level_at_indices(indices)`: returns a level by `LdtkLevelIndices`.
- `LdtkProject::raw_level_at_indices(indices)`: returns a level by `LdtkLevelIndices` from raw project JSON.
- `LdtkProject::find_level_by_selection(selection)`: finds level by `LdtkLevelSelection`.
- `LdtkProject::raw_find_level_by_selection(selection)`: finds level by `LdtkLevelSelection` from raw project JSON.
- `LdtkProject::level_by_iid(iid)`: finds level by level IID.
- `LdtkProject::raw_level_by_iid(iid)`: finds level by level IID from raw project JSON.
- `LdtkProject::level_set_for_selection(selection, behavior)`: computes target level set (including neighbor expansion when enabled).
- `LdtkProject::raw_level_set_for_selection(selection, behavior)`: computes target level set from raw project JSON.
- `LdtkProject::tileset_by_uid(uid)`: resolves a tileset definition by UID.
- `LdtkTilesetDefinition::tile_custom_data(tile_id)`: resolves tileset `customData` payload for a tile ID.
- `LdtkTilesetDefinition::tile_enum_tags(tile_id)`: resolves all enum-tag identifiers attached to a tile ID.
- `LdtkProject::tileset_tile_custom_data(tileset_uid, tile_id)`: resolves tileset custom metadata by `(tileset_uid, tile_id)`.
- `LdtkProject::tileset_tile_enum_tags(tileset_uid, tile_id)`: resolves tileset enum-tag identifiers by `(tileset_uid, tile_id)`.
- `LdtkProject::layer_definition_by_identifier(identifier)`: resolves layer definitions by identifier.
- `LdtkProject::entity_definition_by_identifier(identifier)`: resolves entity definitions by identifier.
- `LdtkProject::entity_definition_by_uid(uid)`: resolves entity definitions by UID.
- `LdtkProject::enum_definition_by_identifier(identifier)`: resolves enum definitions by identifier.
- `LdtkProject::enum_definition_by_uid(uid)`: resolves enum definitions by UID.
- `LdtkProject::external_enum_definition_by_identifier(identifier)`: resolves external enum definitions by identifier.
- `LdtkProject::external_enum_definition_by_uid(uid)`: resolves external enum definitions by UID.
- `LdtkProject::int_grid_color(layer_identifier, value)`: resolves int-grid color by layer identifier and value.

#### `selene/ldtk` world runtime and lifecycle APIs

- `LdtkWorldSpawnSettings`: world spawn configuration (position, selection-following, initial set, spawn behavior override, hooks).
- `LdtkWorldInstance`: runtime world payload (`project`, `settings`, `level_set`, `spawned_levels`).
- `LdtkLevelInstance`: runtime spawned-level payload (`world_entity`, `indices`, `level`).
- `LdtkLayerMetadata`: per-spawned-layer metadata payload mirroring parsed LDtk layer attributes.
- `LdtkLevelBackground`: runtime level background payload for spawned `bgColor/bgRelPath` entities.
- `LdtkLevelIid`: per-spawned-level IID payload.
- `LdtkEntityIid`: per-spawned-entity IID payload.
- `LdtkGridCoords`: grid coordinate payload (`x`, `y`) for spawned tile/entity/int-grid cell entities.
- `LdtkIntGridCell`: int-grid value payload (`value`) for spawned int-grid cell entities.
- `LdtkTileMetadata`: per-spawned-tile metadata payload (`tile_id`, `src`, flip flags, alpha, `custom_data`, `enum_tags`).
- `LdtkIntGridCollider`: marker payload for int-grid cell entities with generated 2D collider/area components.
- `LdtkWorldly`: runtime payload describing a worldly LDtk entity bound to a world root.
- `LdtkRespawn`: respawn marker payload used by `ldtk_world_sync_system`.
- `LdtkSpawnedLayerInstance`: runtime spawned-layer payload.
- `LdtkSpawnedTileInstance`: runtime spawned-tile payload.
- `LdtkSpawnedEntityInstance`: runtime spawned-entity payload.
- `LdtkSpawnedIntGridCell`: runtime spawned int-grid cell payload.
- `ldtk_world_instances`: storage map of `Entity -> LdtkWorldInstance`.
- `ldtk_level_instances`: storage map of `Entity -> LdtkLevelInstance`.
- `ldtk_layer_metadata`: storage map of `Entity -> LdtkLayerMetadata`.
- `ldtk_level_backgrounds`: storage map of `Entity -> LdtkLevelBackground`.
- `ldtk_level_iids`: storage map of `Entity -> LdtkLevelIid`.
- `ldtk_entity_iids`: storage map of `Entity -> LdtkEntityIid`.
- `ldtk_grid_coords`: storage map of `Entity -> LdtkGridCoords`.
- `ldtk_int_grid_cells`: storage map of `Entity -> LdtkIntGridCell`.
- `ldtk_tile_metadata`: storage map of `Entity -> LdtkTileMetadata`.
- `ldtk_int_grid_colliders`: storage map of `Entity -> LdtkIntGridCollider`.
- `ldtk_worldly_entities`: storage map of `Entity -> LdtkWorldly`.
- `ldtk_respawns`: storage map of `Entity -> LdtkRespawn`.
- `ldtk_spawned_layer_instances`: storage map of `Entity -> LdtkSpawnedLayerInstance`.
- `ldtk_spawned_tile_instances`: storage map of `Entity -> LdtkSpawnedTileInstance`.
- `ldtk_spawned_entity_instances`: storage map of `Entity -> LdtkSpawnedEntityInstance`.
- `ldtk_spawned_int_grid_cells`: storage map of `Entity -> LdtkSpawnedIntGridCell`.
- `ldtk_entity_spawn_hooks`: registry map of `Entity identifier -> entity spawn hook`.
- `ldtk_entity_layer_spawn_hooks`: registry map of `Entity layer identifier -> entity spawn hook`.
- `ldtk_entity_layer_identifier_spawn_hooks`: registry map of `(Entity layer identifier, entity identifier) -> entity spawn hook`.
- `ldtk_entity_default_spawn_hook`: optional fallback hook for all spawned LDtk entities.
- `ldtk_int_grid_layer_spawn_hooks`: registry map of `IntGrid layer identifier -> cell spawn hook`.
- `ldtk_int_grid_cell_spawn_hooks`: registry map of `IntGrid (layer,value) -> cell spawn hook`.
- `ldtk_int_grid_value_spawn_hooks`: registry map of `IntGrid value -> cell spawn hook` across layers.
- `ldtk_int_grid_default_spawn_hook`: optional fallback hook for all spawned IntGrid cells.
- `ldtk_pending_transformed_level_iids`: internal pending-transformed queue keyed by level IID for delayed transform events.
- `default_ldtk_world_spawn_settings()`: returns default world spawn settings.
- `mark_ldtk_respawn(entity)`: marks an LDtk world/level entity for respawn on the next sync tick.
- `clear_ldtk_respawn(entity)`: clears a pending respawn mark from an LDtk world/level entity.
- `register_ldtk_entity_spawn_hook(identifier, hook)`: registers/overwrites an entity spawn hook for an LDtk entity identifier.
- `register_ldtk_entity_spawn_hook_optional(layer_identifier?, identifier?, hook)`: routes entity spawn-hook registration to default/identifier/layer/layer+identifier scope by optional matcher.
- `register_ldtk_entity_layer_spawn_hook(layer_identifier, hook)`: registers/overwrites a layer-wide entity spawn hook.
- `register_ldtk_entity_spawn_hook_for_layer(layer_identifier, identifier, hook)`: registers/overwrites an entity spawn hook scoped to a layer+identifier pair.
- `register_ldtk_entity_default_spawn_hook(hook)`: registers/overwrites the fallback entity spawn hook.
- `unregister_ldtk_entity_spawn_hook(identifier)`: removes the entity spawn hook for an LDtk entity identifier.
- `unregister_ldtk_entity_spawn_hook_optional(layer_identifier?, identifier?)`: routes entity spawn-hook unregistration by optional matcher.
- `unregister_ldtk_entity_layer_spawn_hook(layer_identifier)`: removes a layer-wide entity spawn hook.
- `unregister_ldtk_entity_spawn_hook_for_layer(layer_identifier, identifier)`: removes a layer+identifier entity spawn hook.
- `clear_ldtk_entity_default_spawn_hook()`: clears the fallback entity spawn hook.
- `clear_ldtk_entity_spawn_hooks()`: clears all registered LDtk entity spawn hooks.
- `register_ldtk_int_grid_layer_spawn_hook(layer_identifier, hook)`: registers/overwrites a layer-wide IntGrid cell spawn hook.
- `register_ldtk_int_grid_spawn_hook_optional(layer_identifier?, value?, hook)`: routes IntGrid spawn-hook registration to default/value/layer/layer+value scope by optional matcher.
- `register_ldtk_int_grid_value_spawn_hook(value, hook)`: registers/overwrites an IntGrid cell spawn hook by value across layers.
- `register_ldtk_int_grid_default_spawn_hook(hook)`: registers/overwrites the fallback IntGrid cell spawn hook.
- `unregister_ldtk_int_grid_layer_spawn_hook(layer_identifier)`: removes a layer-wide IntGrid cell spawn hook.
- `unregister_ldtk_int_grid_spawn_hook_optional(layer_identifier?, value?)`: routes IntGrid spawn-hook unregistration by optional matcher.
- `unregister_ldtk_int_grid_value_spawn_hook(value)`: removes an IntGrid value-scoped spawn hook.
- `clear_ldtk_int_grid_layer_spawn_hooks()`: clears all registered layer-wide IntGrid cell spawn hooks.
- `register_ldtk_int_grid_cell_spawn_hook(layer_identifier, value, hook)`: registers/overwrites an IntGrid `(layer,value)` spawn hook.
- `unregister_ldtk_int_grid_cell_spawn_hook(layer_identifier, value)`: removes an IntGrid `(layer,value)` spawn hook.
- `clear_ldtk_int_grid_cell_spawn_hooks()`: clears all registered IntGrid `(layer,value)` spawn hooks.
- `clear_ldtk_int_grid_value_spawn_hooks()`: clears all registered IntGrid value-scoped spawn hooks.
- `clear_ldtk_int_grid_default_spawn_hook()`: clears the fallback IntGrid cell spawn hook.
- `load_and_spawn_ldtk_world(path, settings?)`: loads project and spawns world in one call.
- `spawn_ldtk_world(project, settings?)`: spawns LDtk world root and selected levels.
- `spawn_ldtk_world_into_entity(root, project, settings?)`: spawns LDtk world into an existing root entity.
- `respawn_ldtk_world_into_entity(root, project, settings?)`: rebuilds LDtk world subtree in place.
- `set_ldtk_level_set(world_entity, level_set)`: sets explicit per-world desired level set and disables auto-follow.
- `set_ldtk_world_follow_level_selection(world_entity, follow)`: toggles per-world auto-follow of global level selection.
- `ldtk_level_entity(world_entity, level_iid)`: resolves the currently spawned level entity for a world+level IID.
- `ldtk_worldly_entity(world_entity, entity_iid)`: finds the live worldly entity for a given world/entity IID pair.
- `ldtk_entity_by_iid(world_entity, entity_iid)`: resolves the live spawned entity for a world+entity IID pair.
- `ldtk_world_sync_system(delta)`: applies level selection/set changes and performs spawn/despawn sync.
- `despawn_ldtk_tree(root)`: despawns a spawned LDtk subtree and clears LDtk runtime stores.
- `clear_ldtk_children(root)`: clears all LDtk child subtrees beneath a root entity.

#### `selene/ldtk` event APIs

- `LdtkWorldSpawnedEvent`: payload emitted when an LDtk world root is spawned.
- `LdtkLevelSpawnedEvent`: payload emitted when an LDtk level entity is spawned.
- `LdtkLayerSpawnedEvent`: payload emitted when an LDtk layer entity is spawned.
- `LdtkTileSpawnedEvent`: payload emitted when an LDtk tile entity is spawned.
- `LdtkEntitySpawnedEvent`: payload emitted when an LDtk entity-instance entity is spawned.
- `LdtkIntGridCellSpawnedEvent`: payload emitted when an LDtk int-grid cell entity is spawned.
- `LdtkIntGridColliderSpawnedEvent`: payload emitted when int-grid physics generates collider/area components for a spawned cell.
- `LdtkLevelEvent`: level lifecycle event union (`SpawnTriggered`, `Spawned`, `Transformed`, `Despawned`).
- `ldtk_world_spawned_event_bus`: event bus for `LdtkWorldSpawnedEvent`.
- `ldtk_level_spawned_event_bus`: event bus for `LdtkLevelSpawnedEvent`.
- `ldtk_layer_spawned_event_bus`: event bus for `LdtkLayerSpawnedEvent`.
- `ldtk_tile_spawned_event_bus`: event bus for `LdtkTileSpawnedEvent`.
- `ldtk_entity_spawned_event_bus`: event bus for `LdtkEntitySpawnedEvent`.
- `ldtk_int_grid_cell_spawned_event_bus`: event bus for `LdtkIntGridCellSpawnedEvent`.
- `ldtk_int_grid_collider_spawned_event_bus`: event bus for `LdtkIntGridColliderSpawnedEvent`.
- `ldtk_level_event_bus`: event bus for `LdtkLevelEvent`.

### Changed

- `plugins/default_plugin`: added `@ldtk.ldtk_world_sync_system` to the `Update` gameplay stage so LDtk level selection/set changes are applied automatically each frame.
- `spawn_ldtk_world(...)` runtime behavior: level spawn now materializes LDtk layer contents (`Tiles`, `AutoLayer`, `IntGrid`, `Entities`) into Selene entities and sprites, with per-layer z-index stepping and hook dispatch.
- `LdtkLayerInstance` parsed payload now includes LDtk layer-definition metadata fields (`layer_def_uid`, `optional_rules`, `override_tileset_uid`, `px_offset_x`, `px_offset_y`, `seed`) in addition to existing render/runtime offsets.
- `spawn_ldtk_world(...)` runtime behavior: spawned levels/entities/tiles/int-grid cells now also populate dedicated lookup/metadata maps (`ldtk_level_iids`, `ldtk_entity_iids`, `ldtk_tile_metadata`, `ldtk_int_grid_cells`) for direct IID/value queries.
- `spawn_ldtk_world(...)` runtime behavior: when `ldtk_int_grid_physics_settings.enabled` is true, matching int-grid cells now automatically get `physics2d` collider/area+shape components with optional sensor mode and layer/value filtering.
- `spawn_ldtk_world(...)` IntGrid rendering behavior now matches LDtk/bevy semantics: IntGrid layers with tileset/auto-layer data spawn tile visuals from `autoLayerTiles`/`gridTiles`, and colorful fallback rendering is only used for IntGrid layers without tileset visuals.
- `spawn_ldtk_world(...)` runtime behavior: worldly entities (`worldly`/`Worldly` field) now spawn under the world root and persist across individual level respawns; full world respawn recreates worldly entities.
- `ldtk_world_sync_system(...)` runtime behavior: `LdtkLevelEvent::Transformed` is now emitted on the next sync tick after spawn (matching delayed transform timing), rather than in the same spawn tick.
- `LdtkProject::enum_definition_by_identifier(...)` / `LdtkProject::enum_definition_by_uid(...)` now resolve both internal `defs.enums` and `defs.external_enums`.
- `LdtkFieldInstance` parsing now preserves `defUid` into `def_uid` for direct field-definition UID lookups.
- `LdtkProject` now exposes raw-level accessor APIs (`raw_*`) so external-level projects can query pre-merge metadata and resolved runtime data independently.
- `LdtkTileInstance` parsing now preserves LDtk internal tile payload `d` as `LdtkTileInstance.data`.
- `LdtkEntityInstance` parsing now preserves LDtk entity tags from `__tags`/`tags` as `LdtkEntityInstance.tags`.
- `spawn_ldtk_world(...)` tile rendering now resolves sprite-atlas source offsets using LDtk tileset `padding` and `spacing`; this resolved source is also stored in `ldtk_tile_metadata.src`.
- `spawn_ldtk_world(...)` tile metadata now carries LDtk tileset per-tile metadata (`customData` and `enumTags`) into `ldtk_tile_metadata.custom_data` and `ldtk_tile_metadata.enum_tags`.
- `spawn_ldtk_world(...)` tile rendering now applies LDtk tile opacity by multiplying `layer.opacity * tile.alpha` into sprite animation draw alpha.
- `spawn_ldtk_world(...)` level background-image rendering now applies LDtk `__bgPos` crop/scale/offset when present.
- `spawn_ldtk_world(...)` layer z-ordering now follows LDtk display order semantics (`layerInstances[0]` is top-most), matching bevy_ecs_ldtk expectations.
- `spawn_ldtk_world(...)` now runs expanded hook registries (`ldtk_entity_spawn_hooks`, `ldtk_entity_layer_spawn_hooks`, `ldtk_entity_layer_identifier_spawn_hooks`, `ldtk_entity_default_spawn_hook`, `ldtk_int_grid_layer_spawn_hooks`, `ldtk_int_grid_cell_spawn_hooks`, `ldtk_int_grid_value_spawn_hooks`, `ldtk_int_grid_default_spawn_hook`) in addition to per-world spawn hooks.
- `selene/sprite` `Animation` payload now carries per-animation draw color (`color`) instead of always forcing opaque white in render submission.
- `Animation::new(...)` signature now accepts optional `color? : @render.Color`.
- `Animation::single_frame(...)` signature now accepts optional `color? : @render.Color`.
- `Animation::single_frame_from_image(...)` signature now accepts optional `color? : @render.Color`.

### Fixed

- `selene/tiled` world pattern regex capture parsing no longer uses an unnecessary `try!` on substring-to-string conversion, removing the `unused_try` warning in `moon check`.
- `selene/ldtk` lifecycle cleanup now removes pending transformed level IIDs when levels are despawned via generic tree cleanup (`despawn_ldtk_tree`), preventing stale `Transformed` emissions after despawn.
- `selene/ldtk` cleanup paths now also remove `physics2d` collider/area/shape/body components for int-grid physics entities in both tree-despawn and dead-runtime cleanup passes.

## [0.27.0] - 2026-03-10

### Added

#### `selene/tiled` map data APIs

- `TiledPropertyValue`: typed property union for Tiled property values (`String`, `Int`, `Float`, `Bool`, `Color`, `File`, `Object`, `Custom`).
- `TiledProperty`: `name + value` pair for map/layer/object/tileset properties.
- `TiledGid`: decoded global tile ID with flip flags and raw numeric value.
- `TiledChunk`: infinite-map chunk payload (`x`, `y`, `width`, `height`, `data`).
- `TiledCell`: normalized tile cell view (`x`, `y`, `gid`).
- `TiledTileLayer`: parsed tile-layer payload including fixed-grid or chunked data and encoding metadata.
- `TiledPoint`: polygon/polyline point payload (`x`, `y`).
- `TiledText`: text-object payload (text content + style fields).
- `TiledObject`: object-layer object payload (shape/tile/text/properties).
- `TiledObjectLayer`: object layer payload (`draw_order`, `objects`).
- `TiledImageLayer`: image-layer payload (`image`, repeat, transparent color).
- `TiledAnimationFrame`: per-frame animated-tile entry (`tile_id`, `duration_ms`).
- `TiledTileDefinition`: per-tile definition payload from tilesets.
- `TiledTileset`: parsed tileset payload (atlas metadata, tile definitions, properties).
- `TiledLayerKind`: discriminated layer payload (`TileLayer`, `ObjectLayer`, `GroupLayer`, `ImageLayer`, `Unknown`).
- `TiledLayer`: normalized layer metadata + typed payload.
- `TiledMap`: top-level parsed map payload (size, orientation, hex/stagger metadata, layers, tilesets, properties).
- `empty_tiled_gid()`: returns an empty/zero `TiledGid`.
- `decode_tiled_gid(raw)`: decodes Tiled flip bits + tile ID from integer GID.
- `encode_tiled_gid(gid)`: re-encodes typed `TiledGid` to raw integer.
- `TiledGid::is_empty()`: returns whether the GID is the empty tile (`tile_id == 0`).
- `empty_tiled_map()`: returns an empty map object for fallback/error cases.
- `load_tiled_map(path)`: loads TMJ/TMX map file and resolves external tilesets.
- `TiledMap::from_tiled_json(json)`: builds map payload directly from parsed JSON.
- `TiledMap::from_tiled_xml(source)`: builds map payload directly from TMX XML source text.
- `TiledMap::resolve_path(path)`: resolves map-relative asset path to absolute/normalized path.
- `TiledMap::resolve_tileset_asset_path(tileset, path)`: resolves tileset-local asset path, including external tileset directory.
- `TiledMap::layer(name)`: returns a layer by name.
- `TiledMap::layer_by_id(id)`: returns a layer by numeric layer ID.
- `TiledMap::tile_layer(name)`: returns named tile layer payload.
- `TiledMap::object_layer(name)`: returns named object layer payload.
- `TiledMap::tileset_for_gid(global_gid)`: finds tileset owning the given global tile ID.
- `TiledMap::property(name)`: reads map-level property value by name.
- `TiledTileset::tile_definition(local_id)`: reads tileset tile definition by local tile ID.
- `TiledLayer::property(name)`: reads layer-level property value by name.
- `TiledObject::property(name)`: reads object-level property value by name.
- `TiledTileset::property(name)`: reads tileset-level property value by name.
- `TiledObjectLayer::object(name)`: finds object-layer object by name.
- `TiledTileLayer::tile_gid_at(x, y)`: returns tile gid at world tile coordinate (supports chunked maps).
- `TiledTileLayer::tile_cells()`: flattens tile data into `(x, y, gid)` cells.

#### `selene/tiled` ECS spawn APIs

- `TiledSpawnSettings`: controls tiled map spawn behavior (root position/z, visibility policy, per-level hooks).
- `default_tiled_spawn_settings()`: returns default spawn settings for map instantiation.
- `spawn_tiled_map(map, settings?)`: spawns entities from parsed `TiledMap`.
- `spawn_tiled_map_into_entity(root, map, settings?)`: spawns a parsed `TiledMap` into an existing root entity.
- `respawn_tiled_map_into_entity(root, map, settings?)`: clears existing tiled children/state under a root entity and rebuilds the map in place.
- `load_and_spawn_tiled_map(path, settings?)`: loads map from disk and spawns in one call.
- `TiledMapInstance`: runtime component payload for spawned map root entity.
- `TiledLayerInstance`: runtime component payload for spawned layer entity.
- `TiledTileInstance`: runtime component payload for spawned tile entity.
- `TiledObjectInstance`: runtime component payload for spawned object entity.
- `TiledImageLayerInstance`: runtime component payload for spawned image-layer entity.
- `TiledProperties`: runtime property bag populated from map/layer/object/tile definitions.
- `TiledProperties::get(name)`: reads a typed property from runtime property storage.
- `TiledMapStorage`: runtime lookup payload for spawned layers, objects, and tile entities.
- `TiledParallaxLayer`: runtime parallax payload for layers with non-default `parallaxx/parallaxy`.
- `empty_tiled_map_storage()`: returns an empty runtime lookup payload.
- `TiledMapStorage::layer_entity(id)`: resolves a spawned layer entity by Tiled layer ID.
- `TiledMapStorage::object_entity(id)`: resolves a spawned object entity by Tiled object ID.
- `TiledMapStorage::tile_entities(gid)`: resolves spawned tile entities by global tile ID.
- `tiled_map_instances`: storage map of `Entity -> TiledMapInstance`.
- `tiled_layer_instances`: storage map of `Entity -> TiledLayerInstance`.
- `tiled_tile_instances`: storage map of `Entity -> TiledTileInstance`.
- `tiled_object_instances`: storage map of `Entity -> TiledObjectInstance`.
- `tiled_image_layer_instances`: storage map of `Entity -> TiledImageLayerInstance`.
- `tiled_properties`: storage map of `Entity -> TiledProperties`.
- `tiled_map_storages`: storage map of `Entity -> TiledMapStorage`.
- `tiled_parallax_layers`: storage map of `Entity -> TiledParallaxLayer`.
- `tiled_parallax_system(delta)`: camera-driven parallax update for spawned Tiled layers.

#### `selene/tiled` lifecycle helper APIs

- `despawn_tiled_tree(root)`: despawns a spawned tiled subtree and clears all Selene tiled runtime stores for every entity in it.
- `clear_tiled_children(root)`: despawns all live tiled child subtrees beneath an existing root entity without destroying the root itself.

#### `selene/tiled` world APIs

- `TiledWorldMap`: explicit world-map record (`file_name`, world position, optional world size).
- `TiledWorldPattern`: pattern record (`regexp`, multipliers, offsets, optional map size metadata).
- `TiledWorld`: parsed world payload (`only_show_adjacent_maps`, explicit maps, patterns, source path).
- `TiledWorldLoadedMap`: runtime payload describing a resolved world entry, its parsed map, and whether it should spawn.
- `TiledWorldInstance`: runtime payload for spawned world root entity, including loaded world maps, spawn settings, and spawned-map lookup state.
- `TiledWorldMapInstance`: runtime payload for spawned world-map entity and its resolved source path.
- `TiledWorldSpawnSettings`: controls world spawn behavior (position, z stepping, nested map settings, optional focus map, optional chunk margin, hooks).
- `tiled_world_instances`: storage map of `Entity -> TiledWorldInstance`.
- `tiled_world_map_instances`: storage map of `Entity -> TiledWorldMapInstance`.
- `empty_tiled_world()`: returns empty world payload fallback.
- `default_tiled_world_spawn_settings()`: returns default world spawn settings.
- `load_tiled_world(path)`: loads `.world` payload from disk.
- `load_and_spawn_tiled_world(path, settings?)`: loads world and spawns maps in one call.
- `spawn_tiled_world(world, settings?)`: spawns world root + map children from `TiledWorld`.
- `spawn_tiled_world_into_entity(root, world, settings?)`: spawns a parsed `TiledWorld` into an existing root entity.
- `respawn_tiled_world_into_entity(root, world, settings?)`: clears existing tiled children/state under a root entity and rebuilds the world in place.
- `tiled_world_chunking_system(delta)`: camera-driven chunk streaming system that spawns/despawns world maps based on viewport coverage.
- `TiledWorld::resolve_map_path(path)`: resolves world-relative map path.
- `TiledWorld::map(file_name)`: looks up world map entry by file name.

#### `selene/tiled` spawn event APIs

- `TiledWorldSpawnedEvent`: payload emitted when world root entity is spawned.
- `TiledWorldMapSpawnedEvent`: payload emitted when a world map child is spawned.
- `TiledMapSpawnedEvent`: payload emitted when map root is spawned.
- `TiledLayerSpawnedEvent`: payload emitted when a layer entity is spawned.
- `TiledTileSpawnedEvent`: payload emitted when a tile entity is spawned.
- `TiledObjectSpawnedEvent`: payload emitted when an object entity is spawned.
- `TiledImageLayerSpawnedEvent`: payload emitted when an image-layer entity is spawned.
- `tiled_world_spawned_event_bus`: event bus for `TiledWorldSpawnedEvent`.
- `tiled_world_map_spawned_event_bus`: event bus for `TiledWorldMapSpawnedEvent`.
- `tiled_map_spawned_event_bus`: event bus for `TiledMapSpawnedEvent`.
- `tiled_layer_spawned_event_bus`: event bus for `TiledLayerSpawnedEvent`.
- `tiled_tile_spawned_event_bus`: event bus for `TiledTileSpawnedEvent`.
- `tiled_object_spawned_event_bus`: event bus for `TiledObjectSpawnedEvent`.
- `tiled_image_layer_spawned_event_bus`: event bus for `TiledImageLayerSpawnedEvent`.

#### `selene/tiled` physics integration APIs

- `TiledNameFilter`: name-filter enum for selecting tiled objects/layers (`All`, `None`, `Names([...])`).
- `TiledNameFilter::none()`: helper returning the `None` filter variant.
- `TiledNameFilter::names([...])`: helper returning the `Names` filter variant.
- `TiledNameFilter::matches(name)`: evaluates whether a name passes the filter.
- `TiledColliderSourceKind`: source-kind enum for physics collider provenance (`TilesLayer`, `Object`).
- `TiledPhysicsSettings`: tiled physics spawn settings payload (object filter, tile-layer filter, collision/sensor filters, point radius, ellipse tessellation, tile-rect merge toggle, collider hook).
- `TiledColliders`: runtime payload recording physics collider entities spawned from a tiled source entity.
- `TiledColliders::alive_entities()`: returns the live physics collider entities for a tiled source entity.
- `TiledColliderOrigin`: runtime provenance payload mapping a spawned physics collider back to its tiled source entity/layer.
- `TiledColliderSpawnedEvent`: payload emitted when a tiled physics collider entity is spawned.
- `tiled_colliders`: storage map of `Entity -> TiledColliders`.
- `tiled_collider_origins`: storage map of `Entity -> TiledColliderOrigin`.
- `tiled_collider_spawned_event_bus`: event bus for `TiledColliderSpawnedEvent`.
- `default_tiled_physics_settings()`: returns default tiled physics settings with all-name filters and all-collision interaction enabled.

#### `selene/collision` shape and filter APIs

- `RigidBodyType`: explicit 2D rigid-body mode enum (`Dynamic`, `Fixed`, `KinematicPositionBased`, `KinematicVelocityBased`).
- `RigidBody`: explicit 2D rigid-body descriptor (`body_type`, `gravity_scale`, `linear_damping`, `angular_damping`, `ccd_enabled`, `lock_rotation`).
- `RigidBodyHandle`: native Rapier rigid-body handle alias exposed by `selene/collision`.
- `ColliderHandle`: native Rapier collider handle alias exposed by `selene/collision`.
- `RigidBody::dynamic()`: creates default dynamic 2D rigid body config.
- `RigidBody::fixed()`: creates default fixed 2D rigid body config.
- `RigidBody::kinematic_position_based()`: creates default position-driven kinematic 2D rigid body config.
- `RigidBody::kinematic_velocity_based()`: creates default velocity-driven kinematic 2D rigid body config.
- `CollisionFilter::all(group)`: creates a collision filter that can interact with every collision group.
- `CollisionShape::Ball(radius, offset)`: circular collision shape payload.
- `CollisionShape::Polygon(points, offset)`: filled polygon collision shape payload.
- `CollisionShape::Polyline(points, offset, closed)`: polyline/segment-chain collision shape payload.
- `SpatialQueryBodyFilter`: query body-kind enum (`All`, `Dynamic`, `Fixed`, `Kinematic`).
- `SpatialQueryFilter`: spatial-query filter payload (`groups`, `exclude_entity`, `exclude_sensors`, `exclude_solids`, `body_filter`).
- `SpatialQueryFilter::default()`: returns the default unrestricted spatial-query filter.
- `SpatialQueryFilter::only_dynamic()`: returns a spatial-query filter that only matches dynamic rigid bodies.
- `SpatialQueryFilter::only_fixed()`: returns a spatial-query filter that only matches fixed rigid bodies.
- `SpatialQueryFilter::only_kinematic()`: returns a spatial-query filter that only matches kinematic rigid bodies.
- `RaycastHit`: 2D raycast hit payload (`entity`, `toi`, `point`, `normal`).
- `ShapeCastHit`: 2D shape-cast hit payload (`entity`, `toi`, `point`, `normal`).
- `JointMotorModel`: joint motor model enum (`AccelerationBased`, `ForceBased`).
- `JointLimits`: scalar joint-limit payload (`min`, `max`).
- `JointLimits::new(min, max)`: creates scalar joint limits.
- `JointSoftness`: joint softness payload (`damping_ratio`, `natural_frequency`).
- `JointSoftness::new(damping_ratio, natural_frequency)`: creates joint softness coefficients.
- `JointMotor`: revolute-joint motor payload (`Position`, `Velocity`).
- `JointMotor::position(target_position, stiffness, damping, max_force?, model?)`: creates a position motor payload for revolute joints.
- `JointMotor::velocity(target_velocity, damping, max_force?, model?)`: creates a velocity motor payload for revolute joints.
- `JointKind`: 2D joint kind enum (`Fixed`, `Revolute`, `Prismatic`, `Rope`, `Spring`).
- `Joint`: authored 2D joint component (`entity1`, `entity2`, `kind`, `active`, `contacts_enabled`).
- `JointHandle`: native Rapier impulse-joint handle alias exposed by `selene/collision`.
- `MultibodyJointKind`: 2D multibody joint kind enum (`Revolute`).
- `MultibodyJoint`: authored 2D multibody joint component attached to the child rigid-body entity (`parent`, `kind`, `active`).
- `MultibodyJointHandle`: native Rapier multibody-joint handle alias exposed by `selene/collision`.
- `MultibodyLinkId`: native Rapier multibody link identifier alias exposed by `selene/collision`.
- `JointMotorModel::acceleration_based()`: returns the acceleration-based motor model.
- `JointMotorModel::force_based()`: returns the force-based motor model.
- `Joint::fixed(entity1, entity2, ...)`: creates a fixed joint component.
- `Joint::revolute(entity1, entity2, ...)`: creates a revolute joint component with optional limits/motor/softness.
- `Joint::prismatic(entity1, entity2, axis, ...)`: creates a prismatic joint component with optional linear limits.
- `Joint::rope(entity1, entity2, max_distance, ...)`: creates a rope joint component with a maximum distance.
- `Joint::spring(entity1, entity2, rest_length, stiffness, damping, ...)`: creates a spring joint component with optional model override.
- `MultibodyJoint::revolute(parent, ...)`: creates a revolute multibody joint component for the child entity with optional limits/motor/softness.
- `Collider::with_material(filter, friction?, restitution?, active?)`: creates a collider with explicit friction/restitution/active state instead of filter-only defaults.
- `joints`: storage map of `Entity -> Joint`.
- `multibody_joints`: storage map of `Entity -> MultibodyJoint` keyed by the child rigid-body entity.
- `joint_handle(entity)`: resolves the live Rapier impulse-joint handle for a joint entity when one exists.
- `multibody_joint_handle(entity)`: resolves the live Rapier multibody-joint handle for a child rigid-body entity when one exists.
- `multibody_link(entity)`: resolves the live Rapier multibody link identifier for a rigid-body entity when it belongs to a multibody articulation.
- `rigid_bodies`: storage map of `Entity -> RigidBody`.
- `rigid_body_handle(entity)`: resolves the live Rapier body handle for an entity when one exists.
- `collider_handle(entity)`: resolves the live Rapier collider handle for an entity when one exists.
- `raycast(origin, direction, max_toi?, solid?, query_filter?)`: casts a 2D ray against the live Rapier world and returns the first hit.
- `shape_cast(shape, origin, rotation?, direction?, max_toi?, stop_at_penetration?, query_filter?)`: casts a 2D shape sweep against the live Rapier world and returns the first hit.
- `intersect_point(point, query_filter?)`: returns entities whose colliders overlap the queried world-space point.
- `intersect_shape(shape, origin, rotation?, query_filter?)`: returns entities whose colliders overlap the queried world-space shape.
- `rigid_body_translation(entity)`: reads the current world-space body translation (or authored pending translation before spawn).
- `rigid_body_rotation(entity)`: reads the current body rotation in radians (or authored pending rotation before spawn).
- `rigid_body_linear_velocity(entity)`: reads the current body linear velocity in world units.
- `rigid_body_angular_velocity(entity)`: reads the current body angular velocity in radians per second.
- `set_rigid_body_translation(entity, translation)`: teleports or authors a body's world-space translation.
- `set_rigid_body_rotation(entity, rotation)`: updates or authors a body's world-space rotation.
- `set_rigid_body_linear_velocity(entity, linear_velocity)`: updates or authors a body's linear velocity.
- `set_rigid_body_angular_velocity(entity, angular_velocity)`: updates or authors a body's angular velocity.
- `add_force(entity, force, wake_up?)`: applies a continuous world-space force to a body.
- `add_force_at_point(entity, force, point, wake_up?)`: applies a world-space force at an explicit world-space point.
- `add_torque(entity, torque, wake_up?)`: applies a continuous scalar torque to a body.
- `apply_impulse(entity, impulse, wake_up?)`: applies an instantaneous world-space linear impulse to a body.
- `apply_impulse_at_point(entity, impulse, point, wake_up?)`: applies an instantaneous world-space impulse at an explicit world-space point.
- `apply_torque_impulse(entity, impulse, wake_up?)`: applies an instantaneous scalar torque impulse to a body.
- `reset_forces(entity, wake_up?)`: clears accumulated continuous forces queued on a body.
- `reset_torques(entity, wake_up?)`: clears accumulated continuous torques queued on a body.

#### `selene/physics2d` helper APIs

- `all_collision_layers(group)`: creates a `CollisionLayers` filter that can interact with every collision group.
- `RigidBodyType`: re-export of the explicit 2D rigid-body mode enum.
- `RigidBody`: re-export of the explicit 2D rigid-body descriptor.
- `RigidBodyHandle`: re-export of the native Rapier rigid-body handle alias.
- `ColliderHandle`: re-export of the native Rapier collider handle alias.
- `JointMotorModel`: re-export of the authored 2D joint motor model enum.
- `JointLimits`: re-export of the 2D joint-limit payload.
- `JointSoftness`: re-export of the 2D joint-softness payload.
- `JointMotor`: re-export of the revolute-joint motor payload.
- `JointKind`: re-export of the authored 2D joint kind enum.
- `Joint`: re-export of the authored 2D joint component.
- `JointHandle`: re-export of the native Rapier impulse-joint handle alias.
- `MultibodyJointKind`: re-export of the authored 2D multibody joint kind enum.
- `MultibodyJoint`: re-export of the authored 2D multibody joint component.
- `MultibodyJointHandle`: re-export of the native Rapier multibody-joint handle alias.
- `MultibodyLinkId`: re-export of the native Rapier multibody link identifier alias.
- `JointMotorModel::acceleration_based()`: re-exported helper returning the acceleration-based motor model.
- `JointMotorModel::force_based()`: re-exported helper returning the force-based motor model.
- `JointLimits::new(min, max)`: re-exported helper creating scalar joint limits.
- `JointSoftness::new(damping_ratio, natural_frequency)`: re-exported helper creating joint softness coefficients.
- `JointMotor::position(target_position, stiffness, damping, max_force?, model?)`: re-exported helper creating a revolute position motor payload.
- `JointMotor::velocity(target_velocity, damping, max_force?, model?)`: re-exported helper creating a revolute velocity motor payload.
- `Joint::fixed(entity1, entity2, ...)`: re-exported helper creating a fixed joint component.
- `Joint::revolute(entity1, entity2, ...)`: re-exported helper creating a revolute joint component.
- `Joint::prismatic(entity1, entity2, axis, ...)`: re-exported helper creating a prismatic joint component.
- `Joint::rope(entity1, entity2, max_distance, ...)`: re-exported helper creating a rope joint component.
- `Joint::spring(entity1, entity2, rest_length, stiffness, damping, ...)`: re-exported helper creating a spring joint component.
- `MultibodyJoint::revolute(parent, ...)`: re-exported helper creating a child-authored revolute multibody joint component.
- `SpatialQueryBodyFilter`: re-export of the 2D spatial-query body-kind filter enum.
- `SpatialQueryFilter`: re-export of the 2D spatial-query filter payload.
- `RaycastHit`: re-export of the 2D raycast hit payload.
- `ShapeCastHit`: re-export of the 2D shape-cast hit payload.
- `joints`: re-export of the authored 2D joint storage map.
- `multibody_joints`: re-export of the authored 2D multibody joint storage map.
- `rigid_bodies`: re-export of the explicit 2D rigid-body storage map.
- `joint_handle(entity)`: re-export of Rapier impulse-joint handle lookup.
- `multibody_joint_handle(entity)`: re-export of Rapier multibody-joint handle lookup.
- `multibody_link(entity)`: re-export of Rapier multibody link lookup.
- `rigid_body_handle(entity)`: re-export of Rapier rigid-body handle lookup.
- `collider_handle(entity)`: re-export of Rapier collider handle lookup.
- `raycast(origin, direction, max_toi?, solid?, query_filter?)`: re-exported 2D raycast helper against the live physics world.
- `shape_cast(shape, origin, rotation?, direction?, max_toi?, stop_at_penetration?, query_filter?)`: re-exported 2D shape-cast helper against the live physics world.
- `intersect_point(point, query_filter?)`: re-exported point-overlap helper against the live physics world.
- `intersect_shape(shape, origin, rotation?, query_filter?)`: re-exported shape-overlap helper against the live physics world.
- `rigid_body_translation(entity)`: re-exported rigid-body translation getter.
- `rigid_body_rotation(entity)`: re-exported rigid-body rotation getter.
- `rigid_body_linear_velocity(entity)`: re-exported rigid-body linear-velocity getter.
- `rigid_body_angular_velocity(entity)`: re-exported rigid-body angular-velocity getter.
- `set_rigid_body_translation(entity, translation)`: re-exported rigid-body translation setter.
- `set_rigid_body_rotation(entity, rotation)`: re-exported rigid-body rotation setter.
- `set_rigid_body_linear_velocity(entity, linear_velocity)`: re-exported rigid-body linear-velocity setter.
- `set_rigid_body_angular_velocity(entity, angular_velocity)`: re-exported rigid-body angular-velocity setter.
- `add_force(entity, force, wake_up?)`: re-exported continuous force helper.
- `add_force_at_point(entity, force, point, wake_up?)`: re-exported point-force helper.
- `add_torque(entity, torque, wake_up?)`: re-exported torque helper.
- `apply_impulse(entity, impulse, wake_up?)`: re-exported linear-impulse helper.
- `apply_impulse_at_point(entity, impulse, point, wake_up?)`: re-exported point-impulse helper.
- `apply_torque_impulse(entity, impulse, wake_up?)`: re-exported torque-impulse helper.
- `reset_forces(entity, wake_up?)`: re-exported accumulated-force reset helper.
- `reset_torques(entity, wake_up?)`: re-exported accumulated-torque reset helper.

#### `selene/ui` shadow and clipping APIs

- `ShadowStyle`: box-shadow style enum for UI node shadow rendering.
- `BoxShadow`: per-shadow configuration payload for UI node shadows.
- `box_shadows`: storage map of `Entity -> BoxShadow` (or shadow list payload).
- `Overflow::Hidden`: new overflow mode that enables clipping in layout/render/hit test.
- `OverflowClipBox`: enum selecting clip reference box (content/padding/border).
- `OverflowClipMargin`: clip-margin payload extending clip region around selected clip box.
- `OverflowClipMargin::content_box()`: helper returning content-box clip margin preset.
- `OverflowClipMargin::padding_box()`: helper returning padding-box clip margin preset.
- `OverflowClipMargin::border_box()`: helper returning border-box clip margin preset.
- `OverflowClipMargin::with_margin(...)`: helper to build clip-margin with explicit margin value.
- `default_overflow_clip_margin()`: default clip-margin preset used by nodes.
- `Node.overflow_clip_margin`: authored field controlling node clip box + extra clip margin.
- `Node::new(..., overflow_clip_margin?)`: constructor now accepts explicit overflow clip margin.
- `Node::absolute(..., overflow_clip_margin?)`: absolute constructor now accepts explicit overflow clip margin.
- `CalculatedClip`: runtime clip rectangle component.
- `CalculatedClip::new(...)`: helper to create `CalculatedClip`.
- `OverrideClip`: authored override clip component.
- `OverrideClip::new()`: helper to create `OverrideClip`.
- `RelativeCursorPosition`: runtime cursor position relative to node bounds.
- `RelativeCursorPosition::new(...)`: helper to create cursor-position payload.
- `RelativeCursorPosition::mouse_over()`: helper returning whether cursor is currently over visible clipped node area.
- `calculated_clips`: storage map of `Entity -> CalculatedClip`.
- `override_clips`: storage map of `Entity -> OverrideClip`.
- `relative_cursor_positions`: storage map of `Entity -> RelativeCursorPosition`.

#### `selene/ui` layout and stacking APIs

- `LayoutConfig`: layout extraction config payload (including layout rounding policy).
- `LayoutConfig::new(...)`: helper to create `LayoutConfig`.
- `layout_configs`: storage map of `Entity -> LayoutConfig`.
- `ZIndex`: local stacking order component.
- `ZIndex::new(...)`: helper to create `ZIndex`.
- `GlobalZIndex`: global stacking order component that can cross subtree boundaries.
- `GlobalZIndex::new(...)`: helper to create `GlobalZIndex`.
- `z_indexes`: storage map of `Entity -> ZIndex`.
- `global_zindexes`: storage map of `Entity -> GlobalZIndex`.

#### `selene/ui` material-node APIs

- `UiMaterialHandle`: material-asset handle for UI material rendering.
- `MaterialNode`: authored component that binds a UI node to material asset rendering.
- `MaterialNode::new(...)`: helper to create `MaterialNode`.
- `UiGradient`: gradient payload for built-in gradient material rendering.
- `UiGradient::new(...)`: helper to create `UiGradient`.
- `UiMaterialContext`: draw callback context carrying rect/clip/opacity/material draw state.
- `UiMaterialContext::new(...)`: helper to construct material draw context.
- `UiMaterialAsset`: asset payload defining custom or built-in UI material draw behavior.
- `UiMaterialAsset::from_draw(...)`: creates material from custom draw callback.
- `UiMaterialAsset::solid(...)`: creates solid-color material.
- `UiMaterialAsset::gradient(...)`: creates gradient material.
- `UiMaterialAsset::from_ui_image(...)`: creates image material from `UiImage`.
- `UiMaterialAsset::from_image(...)`: creates image material from image handle/path input.
- `UiMaterialAsset::new(...)`: generic constructor for explicit material payload initialization.
- `draw_ui_material_solid(...)`: built-in solid material draw helper.
- `draw_ui_material_gradient(...)`: built-in gradient material draw helper.
- `draw_ui_material_image(...)`: built-in image material draw helper.
- `material_nodes`: storage map of `Entity -> MaterialNode`.
- `register_ui_material_asset(...)`: registers UI material asset and returns handle.
- `ui_material_asset(...)`: reads registered material asset by handle.
- `update_ui_material_asset(...)`: updates registered material asset payload.
- `release_ui_material_asset(...)`: removes registered material asset by handle.

### Changed

- `selene/tiled` replaces the old `selene/tilemap` package path; the published Tiled integration now lives under `Milky2018/selene/tiled`, while the old SpriteFusion parser is no longer part of the core package surface
- `selene/tiled` is now a Tiled Map Editor package instead of a mixed Tiled/SpriteFusion surface: `load_tiled_map(...)` now dispatches between TMJ/TSJ JSON and TMX/TSX XML sources, `load_tiled_world(...)` reads both explicit world maps and `patterns` metadata, and world spawning now evaluates adjacency over the merged map set (including pattern-derived `mapWidth`/`mapHeight` bounds) when `onlyShowAdjacentMaps` is enabled
- `selene/tiled` `TiledSpawnSettings` now carries `map_hook`, `layer_hook`, `tile_hook`, `object_hook`, and `image_layer_hook`, and `TiledWorldSpawnSettings` now carries nested `map_settings`, `world_hook`, and `world_map_hook`, so downstream gameplay code can attach property-driven prefab/component logic without forking the loader
- `selene/tiled` `TiledSpawnSettings` now also carries `physics_settings`, so tiled map/world spawn, respawn, and world chunk streaming can automatically materialize physics colliders from tile collision objects and object layers without a second manual traversal
- `selene/tiled` physics integration now covers the full Tiled 2D collision object set used by `bevy_ecs_tiled`: regular objects, tile objects, tileset collision-editor objects on tile layers, points, ellipses, polygons, and polylines, while merging adjacent simple tile rectangles to reduce collider count
- `selene/collision` filters now support an explicit “match all groups” mode, and the Rapier bridge now synchronizes `Ball`, `Polygon`, and `Polyline` shapes in addition to rectangular colliders
- `selene/collision` 2D physics is no longer limited to the legacy “velocity means kinematic, no velocity means fixed” heuristic: entities can now opt into explicit `RigidBody` descriptors, collider material properties, and native Rapier handle lookup while preserving the old fallback for unchanged call sites
- `selene/collision` now also exposes live Rapier spatial queries plus direct body translation/rotation/velocity/force control, so higher-level systems can query and manipulate 2D rigid bodies without reaching into Rapier internals
- `selene/collision` now also exposes authored 2D impulse joints (`Fixed`, `Revolute`, `Prismatic`, `Rope`, `Spring`) through ECS components and Rapier handle lookup, so physics relationships can be authored without dropping to backend-specific builders
- `selene/collision` now also exposes authored 2D multibody revolute joints as child-attached ECS components with Rapier multibody handle/link lookup, so articulated chains can be authored without dropping to backend-specific multibody APIs
- `selene/tiled` physics spawning now applies authored material/body overrides directly from Tiled properties: `physics_active`, `physics_friction`, `physics_restitution`, `physics_body`, `physics_gravity_scale`, `physics_linear_damping`, `physics_angular_damping`, `physics_ccd`, and `physics_lock_rotation` (with unprefixed fallback names for convenience)
- `examples/pixeladventure` now keeps its old SpriteFusion-style `TileMap` / `TileLayer` / `Tile` parser locally in the example package instead of depending on `selene/tiled`
- `selene/ui` `Node` now exposes Bevy-aligned block/grid layout authoring, including `Display::Block` / `Display::Grid`, reverse flex directions, `align_content` / `align_self` / `justify_items` / `justify_self`, `flex_wrap` / `flex_basis`, `aspect_ratio`, `scrollbar_width`, and grid template/auto-flow/placement helpers, and the UI layout system now applies those fields through `moon_taffy`
- `selene/ui` `BorderRadius` now uses Bevy-style `Val` sizing semantics instead of raw `Double`s: the `top_left` / `top_right` / `bottom_right` / `bottom_left` fields are now `Val`, `BorderRadius::all(...)` now takes `Val`, and `BorderRadius::new(...)` now takes `Val` corners with `Val::px(0.0)` defaults
- `selene/ui` `Outline` now uses Bevy-style `Val` sizing semantics instead of raw `Double`s: `Outline.width` and `Outline.offset` are now `Val`, and `Outline::new(...)` now takes `width : Val` plus `offset? : Val`
- `selene/ui` `UiMaterialAsset` now uses an open draw-callback model through `UiMaterialAsset::from_draw(...)` and `UiMaterialContext` instead of the earlier closed `UiMaterialKind` enum shape, so material nodes can compose custom UI drawing without waiting for new engine-owned variants
- `selene/ui` rendering, hit-testing, and accessibility child ordering now sort by `GlobalZIndex` before local `ZIndex` and tree order, and UI prepare now renders a flat stacking-sorted entity list so global UI stacking can cross subtree boundaries instead of being trapped inside recursive parent draw order
- `selene/ui` `UiImage` now derives `Eq` / `Show`, and `MaterialNode` rendering takes precedence over co-authored legacy `BackgroundColor` and `UiImage` on the same entity so the new material asset path can replace direct node fill/image styling instead of double-drawing both
- `selene/ui` layout extraction now rounds screen-space node rects and clip rects by default through `LayoutConfig { use_rounding: true }`, matching Bevy's default pixel snapping while still allowing subtree opt-out through `layout_configs`

### Fixed

- `selene/tiled` `load_tiled_map(...)` now follows external tileset references from both JSON and XML Tiled maps before returning, so `.tmj` maps using `.tsj` tilesets and `.tmx` maps using `.tsx` tilesets no longer come back with unresolved `source`-only tileset stubs
- `selene/tiled` now decodes compressed `base64` tile layer payloads (`gzip`, `zlib`, `zstd`) in addition to uncompressed `base64` (including empty-string compression markers) and `csv` payloads, for both JSON and TMX sources, instead of silently treating encoded layer data as empty
- `selene/tiled` tile spawning now supports non-orthogonal maps (`isometric`, `hexagonal`, `staggered`) and no longer drops non-orthogonal tile layers during ECS instantiation
- `selene/tiled` animated tiles now use tileset `tiles[].animation` timelines (including per-frame duration expansion) when building sprite animations instead of always rendering a single static frame
- `selene/tiled` isometric tile-object placement now applies the expected horizontal origin offset for tile objects, matching Tiled's isometric object anchoring behavior
- `selene/tiled` in-place map/world respawn now flushes old live child entities before rebuilding under the same root entity, so `respawn_tiled_map_into_entity(...)` and `respawn_tiled_world_into_entity(...)` do not keep previous spawned tiled content alive alongside the new tree
- `selene/tiled` tiled subtree cleanup now also removes auto-generated `physics2d` collider/area/shape state, so despawning or respawning a map no longer leaves stale physics components behind on destroyed collider entities
- `selene/physics2d` explicit `Fixed` bodies now override the legacy velocity heuristic correctly, while `Dynamic` and `KinematicVelocityBased` bodies feed their post-step translation/velocity back into ECS state instead of remaining frozen at their authored positions
- `selene/collision` body sync now preserves authored or runtime rotation/velocity state across resyncs, and queued force/impulse commands now apply correctly even when issued before the Rapier body is instantiated
- `selene/collision` spatial queries now refresh against the current ECS-authored body/collider state before querying, so raycasts and overlap checks do not lag one fixed step behind freshly spawned or teleported bodies
- `selene/collision` impulse joints now rebuild and clean up automatically as endpoint bodies appear, disappear, or change configuration, so authored joint entities do not leave stale Rapier joint handles behind
- `selene/collision` multibody joints now rebuild and clean up automatically as child/parent bodies appear, disappear, or change configuration, so articulated child entities do not leave stale Rapier multibody-joint handles behind
- `selene/collision` joint softness now maps to Rapier `SpringCoefficients` using the correct `(natural_frequency, damping_ratio)` argument order, so authored revolute softness values no longer swap frequency and damping at runtime
- `selene/collision` disabled trigger areas now clear stale overlap membership instead of keeping `contains` entries after the area is deactivated
- `selene/ui` now renders rounded background fills for `BorderRadius` nodes instead of warning and falling back to square-corner backgrounds, and overflow clipping now applies after node decorations so a scrolling/clipped node no longer clips away its own background and border before drawing content
- `selene/ui` now maps `Overflow::Hidden` through `moon_taffy` and uses the authored `overflow_clip_margin` box when computing screen clip rects, so hidden overflow participates in layout correctly and clipped UI content no longer has to be constrained to the content box only
- `selene/ui` outlines now resolve authored `width` / `offset` values into explicit outer fill bands instead of relying on a single stroke rect, so outline thickness and offset match the node's `Val`-resolved geometry more closely
- `selene/ui` now honors `OverrideClip` in layout, hit-testing, and rendering instead of always inheriting ancestor clip rectangles, and `RelativeCursorPosition` now tracks Bevy-style centered normalized cursor coordinates while reporting `mouse_over()` only when the cursor is inside the node's currently visible clipped region

### Removed

- `selene/tilemap` is no longer the published package path; consumers should switch imports to `selene/tiled`
- `selene/tiled` no longer exposes the old SpriteFusion-only `TileMap`, `TileLayer`, `Tile`, `TileMap::from_json(...)`, `TileMap::get_tiles(...)`, or `TileMap::get_tiles_first(...)` API; legacy SpriteFusion parsing is now example-local instead of part of the published core package
- `selene/ui` no longer exposes the old `UiZIndex` / `UiZIndex::new(...)` / `ui_zindexes` naming; consumers should use `ZIndex` / `ZIndex::new(...)` / `z_indexes`, and add `GlobalZIndex` / `global_zindexes` when they need stacking that escapes local subtree ordering
- `selene/ui` no longer exposes the closed `UiMaterialKind` enum shape for material nodes; consumers should author `UiMaterialAsset::from_draw(...)` callbacks directly or use the built-in `solid(...)`, `gradient(...)`, and image helpers

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
