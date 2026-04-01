# Selene Bevy Alignment Tracker

Last updated: 2026-04-01 (Graph node authoring pass)

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| BEVY-001 | internal audit (editor animation UX) | Animation Graph asset editor is still form-only; missing Bevy-style visual node graph editing for node/edge authoring. | IN_PROGRESS | Added node authoring controls (add clip/blend/additive, remove node, set default node, clip path edit) and node list rendering; edge authoring/editing is still pending. |
| BEVY-002 | internal audit (entity inspector parity) | Entity Inspector lacks typed `AnimationPlayer` editing (`graph_asset_path`, `start_node`, `speed`, `repeat_mode`) and still relies on generic JSON editing for animation runtime setup. | TODO | Needs explicit animation component editor and validation against existing graph docs. |
| BEVY-003 | internal audit (animation runtime API) | Animation repeat-mode is stringly typed in document/runtime bridge; not yet aligned to strongly typed repeat semantics. | TODO | Replace string repeat mode with typed document/runtime enum + migration path. |
| BEVY-004 | internal audit (editor preview controls) | No graph-level playback preview controls (play/pause/seek/speed including reverse) in Animation Graph Inspector. | TODO | Reuse preview bridge, add editor-side playback transport and UI controls. |
| BEVY-005 | internal audit (migration UX) | Animation v2->v3 migration flow lacks a complete user-confirmed batch migration path in editor UI for all legacy animation files. | TODO | Wire `AnimationMigrate` into explicit confirmation UX and per-file result reporting. |
| BEVY-006 | internal audit (physics3d bevy_rapier parity) | 3D physics surface parity still needs a formal gap matrix against `bevy_rapier3d` latest stable usage patterns. | TODO | Build parity checklist (components/queries/events/joints/controller) and close remaining deltas iteratively. |
| BEVY-007 | internal audit (asset taxonomy) | Asset browser grouping and creation flows are not fully Bevy-like for animation pipeline (image -> atlas -> clip -> graph). | TODO | Add dedicated creation entrypoints and structured inspector navigation for clip/graph assets. |

## Current work queue

- `BEVY-001` (`IN_PROGRESS`): finish edge authoring/editing and finalize graph canvas interactions.
- `BEVY-002` (`TODO`): typed animation component inspector for entity workflow.
- `BEVY-003` (`TODO`): typed repeat-mode model and migration.
- `BEVY-004` (`TODO`): graph playback controls with reverse speed preview.
- `BEVY-005` (`TODO`): explicit animation migration confirmation and batch execution UX.
- `BEVY-006` (`TODO`): 3D physics parity matrix and follow-up fixes.
- `BEVY-007` (`TODO`): asset browser and creation flow parity refinement.
