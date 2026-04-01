# Selene Bevy Alignment Tracker

Last updated: 2026-04-01 (animation migration confirmation pass)

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| BEVY-001 | internal audit (editor animation UX) | Animation Graph asset editor is still form-only; missing Bevy-style visual node graph editing for node/edge authoring. | IN_PROGRESS | Added node+edge authoring controls (add/remove node, set default, clip-path edit, add/remove edge, edge target/weight edit) in inspector form flow; visual graph canvas is still pending. |
| BEVY-002 | internal audit (entity inspector parity) | Entity Inspector lacks typed `AnimationPlayer` editing (`graph_asset_path`, `start_node`, `speed`, `repeat_mode`) and still relies on generic JSON editing for animation runtime setup. | DONE | Added typed `AnimationPlayer` + `AnimationTransitions` inspector forms (graph path/start node/autoplay/repeat/speed/duration) wired into scene transactions with undo commit coverage in frontend wbtests. |
| BEVY-003 | internal audit (animation runtime API) | Animation repeat-mode is stringly typed in document/runtime bridge; not yet aligned to strongly typed repeat semantics. | DONE | Added `AnimationRepeatModeDoc` (`Never/Forever/Count`), canonical parse/serialize helpers, typed `animation_player_component` construction, runtime mapping to `@animation.RepeatAnimation` (including count), and editor typed repeat controls. |
| BEVY-004 | internal audit (editor preview controls) | No graph-level playback preview controls (play/pause/seek/speed including reverse) in Animation Graph Inspector. | DONE | Added Animation Graph Inspector preview controls (play/pause, speed, seek) wired through typed preview commands; preview runtime now applies pause/resume, speed (including negative for reverse), and seek on selected animated entity. |
| BEVY-005 | internal audit (migration UX) | Animation v2->v3 migration flow lacks a complete user-confirmed batch migration path in editor UI for all legacy animation files. | DONE | Added legacy animation detection (`.anim.json` and scene `animation_asset_path` references), modal confirmation/cancel UX, sequential `AnimationMigrate` batch execution with progress + failure counts, and frontend/spec harness coverage for confirm/cancel/error paths. |
| BEVY-006 | internal audit (physics3d bevy_rapier parity) | 3D physics surface parity still needs a formal gap matrix against `bevy_rapier3d` latest stable usage patterns. | TODO | Build parity checklist (components/queries/events/joints/controller) and close remaining deltas iteratively. |
| BEVY-007 | internal audit (asset taxonomy) | Asset browser grouping and creation flows are not fully Bevy-like for animation pipeline (image -> atlas -> clip -> graph). | TODO | Add dedicated creation entrypoints and structured inspector navigation for clip/graph assets. |

## Current work queue

- `BEVY-001` (`IN_PROGRESS`): replace form-only editing with visual graph canvas interactions.
- `BEVY-006` (`TODO`): 3D physics parity matrix and follow-up fixes.
- `BEVY-007` (`TODO`): asset browser and creation flow parity refinement.
