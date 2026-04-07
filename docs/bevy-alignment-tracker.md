# Selene Bevy Alignment Tracker

Last updated: 2026-04-07 (SNF v1 scene cutover completed)

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| BEVY-001 | internal audit (editor animation UX) | Animation Graph asset editor is still form-only; missing Bevy-style visual node graph editing for node/edge authoring. | DONE | Added node+edge authoring controls (add/remove node, set default, clip-path edit, add/remove edge, edge target/weight edit), visual graph canvas panel, direct canvas node drag repositioning, and direct canvas edge connect workflow (`Alt+click source -> Alt+click target`) with app wbtest coverage. |
| BEVY-002 | internal audit (entity inspector parity) | Entity Inspector lacks typed `AnimationPlayer` editing (`graph_asset_path`, `start_node`, `speed`, `repeat_mode`) and still relies on generic JSON editing for animation runtime setup. | DONE | Added typed `AnimationPlayer` + `AnimationTransitions` inspector forms (graph path/start node/autoplay/repeat/speed/duration) wired into scene transactions with undo commit coverage in frontend wbtests. |
| BEVY-003 | internal audit (animation runtime API) | Animation repeat-mode is stringly typed in document/runtime bridge; not yet aligned to strongly typed repeat semantics. | DONE | Added `AnimationRepeatModeDoc` (`Never/Forever/Count`), canonical parse/serialize helpers, typed `animation_player_component` construction, runtime mapping to `@animation.RepeatAnimation` (including count), and editor typed repeat controls. |
| BEVY-004 | internal audit (editor preview controls) | No graph-level playback preview controls (play/pause/seek/speed including reverse) in Animation Graph Inspector. | DONE | Added Animation Graph Inspector preview controls (play/pause, speed, seek) wired through typed preview commands; preview runtime now applies pause/resume, speed (including negative for reverse), and seek on selected animated entity. |
| BEVY-005 | internal audit (migration UX) | Animation v2->v3 migration flow lacks a complete user-confirmed batch migration path in editor UI for all legacy animation files. | DONE | Added legacy animation detection (`.anim.json` and scene `animation_asset_path` references), modal confirmation/cancel UX, sequential `AnimationMigrate` batch execution with progress + failure counts, and frontend/spec harness coverage for confirm/cancel/error paths. |
| BEVY-006 | internal audit (physics3d bevy_rapier parity) | 3D physics surface parity still needs a formal gap matrix against `bevy_rapier3d` latest stable usage patterns. | IN_PROGRESS | Added baseline parity matrix at [`docs/bevy-rapier3d-parity-matrix.md`](/Users/zhengyu/Documents/projects/selene/docs/bevy-rapier3d-parity-matrix.md); expanded wbtests for query filters (`dynamic/fixed/kinematic`, `exclude_entity`, `exclude_sensors`, `exclude_solids`, `cast_shape`), collision/intersection/contact-force mapping (including threshold activation), and all 3D joint variant routing. Added joint behavior assertions for revolute/prismatic limits and motor state, plus internal conversion coverage for revolute `motor_model`/`softness`. Remaining work: character controller scenario assertions. |
| BEVY-007 | internal audit (asset taxonomy) | Asset browser grouping and creation flows are not fully Bevy-like for animation pipeline (image -> atlas -> clip -> graph). | DONE | Added explicit creation entrypoints in Assets toolbar (`New Atlas` / `New Clip` / `New Graph`), changed atlas creation flow to generate clip only, added clip->graph creation action in Clip Inspector, and verified pipeline state transitions in frontend app wbtests. |
| BEVY-008 | moon_rapier 3d-real backend audit | `GenericJoint3DReal` round-trip currently drops `motor_model` and `softness`, so Selene can map these fields at conversion time but cannot preserve them through the current 3D real backend representation. | BLOCKED | Added revolute/prismatic behavior wbtests for limits + motor state and added internal `revolute_joint_to_generic` mapping coverage for `motor_model`/`softness`. Verified backend limitation by checking the `GenericJoint3DReal` conversion path in `moon_rapier` (`joint_set3d_real.mbt`) where motor-model/softness are not serialized in the 3D-real state. |
| BEVY-009 | product architecture (editor format) | Introduce Selene-native `SNF` (Scene Notation Format) as the textual scene notation layer and make `selene-editor` consume it through `editor_bridge`, without dual source-of-truth drift. | DONE | Implemented `Scene` SNF v1 as canonical JSON (`scene.version=3`) with dedicated codec APIs (`decode_scene_snf*`, `encode_scene_snf`, `migrate_scene_to_snf`), `v2->v3` migration confirmation path in editor/service, canonical scene save path, and runtime/example consumption via `editor_bridge` loader. |

## Current work queue

- `BEVY-006` (`IN_PROGRESS`): close remaining physics3d parity gaps from the matrix (`character controller scenarios`).
- `BEVY-008` (`BLOCKED`): wait for `moon_rapier` 3D-real joint state to preserve `motor_model`/`softness`.
