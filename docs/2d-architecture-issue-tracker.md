# Selene 2D Architecture Issue Tracker

Last updated: 2026-04-17

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| `S2D-001` | 2D architecture audit (2026-04-17) | Sprite/Text2D/Mesh2D each duplicate camera-candidate + layer/culling extraction logic, causing semantic drift risk. | `DONE` | Added `culling2d.CameraExtract2dContext` and migrated `sprite/text2d/mesh2d` to shared `camera_views_for_bounds(...)`. Verified by `moon check --target all --deny-warn` and package tests. |
| `S2D-002` | 2D architecture audit (2026-04-17) | UI rendering depends on mutable global target state (`set_ui_camera_target`) instead of explicit per-call target routing. | `DONE` | Removed ambient target setter from render2d state; added explicit `push_ui_*_to_camera`, `push_ui_clip_for_camera`, `pop_ui_clip_for_camera`; threaded camera target through UI render/material context. Verified by `moon test selene-core/src/ui --target native --deny-warn`. |
| `S2D-003` | 2D architecture audit (2026-04-17) | `mesh2d/material2d` expose dirty/release asset-sync APIs that are not consumed by any submit/backend path. | `DONE` | Removed unused pseudo-sync storage/APIs (`take_dirty_*`, `take_released_*`) from `mesh2d/material2d` and kept the pipeline command-driven. Verified by `moon check --target all --deny-warn`. |
| `S2D-004` | 2D architecture audit (2026-04-17) | Pickable filtering depends on renderer-populated per-camera visibility sets, coupling input behavior to render extraction side effects. | `DONE` | Removed pickable dependency on camera visibility cache and removed visibility module camera visibility cache APIs/state; renderers no longer write side-effect visibility sets. Verified by `moon test selene-core/src/collision --target native --deny-warn` and sprite/render/UI tests. |
| `S2D-005` | 2D architecture audit (2026-04-17) | Flattened debug command aggregation in `render2d` uses camera-entity-id order, which can diverge from pass order semantics. | `DONE` | Added pass-order-aware camera ID sort (`sorted_camera_entity_ids_by_pass_order`) and changed flattened world/UI aggregation to camera-pass-first, screen-last ordering to match submit semantics. Verified by `moon test selene-core/src/render_submit --target native --deny-warn`. |
| `S2D-006` | 2D architecture audit (2026-04-17) | World sort key mixes authoring order semantics with alpha-state optimization (`alpha_mode` in comparator). | `DONE` | Removed `alpha_mode` from world sorting comparator and internal ordered-command state so ordering is driven by layer/group/order/depth/insertion only. Verified by `moon check --target all --deny-warn` and `moon test selene-core/src/render_submit --target native --deny-warn`. |

## Current work queue

- (none; all tracked issues are `DONE`)
