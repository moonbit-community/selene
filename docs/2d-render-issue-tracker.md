# Selene 2D Render Issue Tracker

Last updated: 2026-04-15

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| `2D-001` | `visibility`, `sprite`, `text2d`, `mesh2d` audit | `ViewVisibility` is still inherited/global-only; there is no reusable per-camera visibility cache for 2D extraction results. | `DONE` | Added per-camera visible-camera bookkeeping in `visibility`, with renderers populating it after cull. Verified by `moon test selene-core/src/sprite --target native --deny-warn` and cache assertions in `sprite/top_wbtest.mbt`. |
| `2D-002` | `tiled/world`, `tiled/ecs` audit | Tiled chunking and parallax still assume `primary_camera2d_view()`, so split-screen/minimap cameras behave incorrectly. | `DONE` | Switched chunking to union active camera world-bounds and moved parallax to camera-aware `parallax2d` evaluation instead of mutating layer transforms per primary camera. Verified by `moon test selene-core/src/tiled --target native --deny-warn` with new multi-camera chunking coverage. |
| `2D-003` | `collision/pickable` audit | Pickable hit testing is still single-camera and rect-only, without render-layer aware routing. | `DONE` | Added camera-aware layer filtering plus ball/polygon/polyline hit support in `pickable`. Verified by `moon test selene-core/src/collision --target native --deny-warn` with new pickable wbtests. |
| `2D-004` | `camera`, `render2d_types`, `render_pipeline`, backend audit | 2D passes still only target the screen viewport; no offscreen/render-target pass semantics exist for 2D cameras. | `DONE` | Added explicit pass target semantics (`Screen`/`Offscreen(name)`) in `CameraPass2D` + `RenderPass2D`, propagated through `render_submit` frame build with offscreen-local pass coordinates. Both backends now execute real offscreen 2D passes and support `offscreen://<name>` texture sampling. Verified by `moon check selene-core/src selene-raylib/src selene-webgpu/src --target all --deny-warn` and `moon test selene-core/src/render_submit --target native --deny-warn`. |
| `2D-005` | `material2d`, `render2d`, backend audit | 2D material support is minimal: one material type, only opaque/alpha routing, and leftover dead material-sync APIs. | `DONE` | Finalized explicit 2D blend-mode contract across draw commands/material (`Alpha`/`Additive`/`Multiply`) and wired backend execution (`raylib` scoped blend-mode draw, `webgpu` blend-mode pipeline selection + JS bridge parameters). Verified by `moon check selene-webgpu/src selene-raylib/src --target all --deny-warn` and regression suite. |
| `2D-006` | `render2d`, backend audit | 2D submission is still command-by-command with no batching/compaction, so multi-camera scenes scale poorly. | `DONE` | Added engine-level per-pass command batching (`world_batches`/`ui_batches`) with clip barriers and compatible-command grouping, and updated both backends to consume batches. WebGPU still applies extra in-pass compaction for adjacent compatible color/texture commands. Verified by `moon test selene-core/src/render_submit --target native --deny-warn` and `moon check selene-raylib/src selene-webgpu/src --target all --deny-warn`. |
| `2D-007` | `text2d` audit | Text wrapping/truncation/measurement is recomputed every frame, which is wasteful for static or repeated text. | `DONE` | Added text layout cache keyed by layout-affecting inputs with dead-entity cleanup and invalidation on key changes. Verified by new `text2d/top_wbtest.mbt` and `moon test selene-core/src/text2d --target native --deny-warn`. |
| `2D-008` | `render2d` sorting audit | `Sorting2d` still lacks sort groups / more explicit transparent ordering semantics for large content-heavy 2D scenes. | `DONE` | Added `Sorting2d.group` and integrated comparator order (`layer -> alpha bucket -> group -> order -> depth -> insertion`) with wbtest coverage in `render2d/top_wbtest.mbt`. |

## Current work queue

- (empty)
