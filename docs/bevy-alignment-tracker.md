# Selene Bevy Alignment Tracker

Last updated: 2026-04-01 (animation graph canvas node drag pass)

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| BEVY-001 | internal audit (editor animation UX) | Animation Graph asset editor is still form-only; missing Bevy-style visual node graph editing for node/edge authoring. | IN_PROGRESS | Added node+edge authoring controls (add/remove node, set default, clip-path edit, add/remove edge, edge target/weight edit), visual graph canvas panel, and direct canvas node drag repositioning (with app wbtest coverage). Remaining gap: direct edge drawing interaction on the canvas. |
| BEVY-002 | internal audit (entity inspector parity) | Entity Inspector lacks typed `AnimationPlayer` editing (`graph_asset_path`, `start_node`, `speed`, `repeat_mode`) and still relies on generic JSON editing for animation runtime setup. | DONE | Added typed `AnimationPlayer` + `AnimationTransitions` inspector forms (graph path/start node/autoplay/repeat/speed/duration) wired into scene transactions with undo commit coverage in frontend wbtests. |
| BEVY-003 | internal audit (animation runtime API) | Animation repeat-mode is stringly typed in document/runtime bridge; not yet aligned to strongly typed repeat semantics. | DONE | Added `AnimationRepeatModeDoc` (`Never/Forever/Count`), canonical parse/serialize helpers, typed `animation_player_component` construction, runtime mapping to `@animation.RepeatAnimation` (including count), and editor typed repeat controls. |
| BEVY-004 | internal audit (editor preview controls) | No graph-level playback preview controls (play/pause/seek/speed including reverse) in Animation Graph Inspector. | DONE | Added Animation Graph Inspector preview controls (play/pause, speed, seek) wired through typed preview commands; preview runtime now applies pause/resume, speed (including negative for reverse), and seek on selected animated entity. |
| BEVY-005 | internal audit (migration UX) | Animation v2->v3 migration flow lacks a complete user-confirmed batch migration path in editor UI for all legacy animation files. | DONE | Added legacy animation detection (`.anim.json` and scene `animation_asset_path` references), modal confirmation/cancel UX, sequential `AnimationMigrate` batch execution with progress + failure counts, and frontend/spec harness coverage for confirm/cancel/error paths. |
| BEVY-006 | internal audit (physics3d bevy_rapier parity) | 3D physics surface parity still needs a formal gap matrix against `bevy_rapier3d` latest stable usage patterns. | IN_PROGRESS | Added baseline parity matrix at [`docs/bevy-rapier3d-parity-matrix.md`](/Users/zhengyu/Documents/projects/selene/docs/bevy-rapier3d-parity-matrix.md); expanded wbtests for query filters (`dynamic/fixed/kinematic`, `exclude_entity`, `exclude_sensors`, `exclude_solids`, `cast_shape`), collision/intersection event-bus mapping, and all 3D joint variant routing. Remaining work: joint behavior semantics (limits/motor/softness), impulse rope/spring handle parity decision, controller scenarios, and cast-shape sensor/solid query edge cases. |
| BEVY-007 | internal audit (asset taxonomy) | Asset browser grouping and creation flows are not fully Bevy-like for animation pipeline (image -> atlas -> clip -> graph). | DONE | Added explicit creation entrypoints in Assets toolbar (`New Atlas` / `New Clip` / `New Graph`), changed atlas creation flow to generate clip only, added clip->graph creation action in Clip Inspector, and verified pipeline state transitions in frontend app wbtests. |

## Current work queue

- `BEVY-001` (`IN_PROGRESS`): replace form-only editing with visual graph canvas interactions.
- `BEVY-006` (`IN_PROGRESS`): close remaining physics3d parity gaps from the matrix (`joint behavior + impulse rope/spring handle parity`, `character controller scenarios`, `cast-shape sensor/solid edge query scenarios`).
