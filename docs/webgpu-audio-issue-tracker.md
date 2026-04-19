# Selene WebGPU Audio Issue Tracker

Last updated: 2026-04-19

## Status Legend

- `TODO`: not started
- `IN_PROGRESS`: currently being fixed
- `BLOCKED`: blocked by platform/public API limitations or external dependency constraints
- `DONE`: fixed and verified locally

## Issues

| ID | Source | Problem | Status | Notes |
| --- | --- | --- | --- | --- |
| WGAUDIO-001 | `selene-webgpu/src/audio.mbt`, `selene-webgpu/src/js_render3d.mbt` | `HTMLAudioElement.play()` failures are ignored, so blocked/failed playbacks can stay alive forever and core sinks never observe terminal failure. | `DONE` | Added tracked web play-state handling (`blocked` vs `failed`) and made `is_finished()`/`tick_audio()` terminate unrecoverable failures. Verified with `moon test selene-webgpu/src --target js --deny-warn` and `moon check --target all --deny-warn`. |
| WGAUDIO-002 | `selene-webgpu/src/audio.mbt`, `selene-webgpu/src/js_canvas_api.mbt` | Web playback uses URL resolution directly instead of the asset-byte path used by `asset.load_audio`, so embedded/path-rewritten assets can load in core but fail at browser playback time. | `DONE` | Asset-backed audio now resolves through cached byte-backed blob URLs, with runtime reset hooks on embedded-asset changes/close. Verified with `moon test selene-webgpu/src --target js --deny-warn` and `moon check --target all --deny-warn`. |
| WGAUDIO-003 | `selene-webgpu/src/audio.mbt`, `selene-core/src/asset/top.mbt` | `preload_audio()` is effectively a shell today and is not wired into the shared asset loading path, so first-play latency and duplicate fetch/decode remain. | `DONE` | Turned preload into a cached template/source path and wired shared audio asset load/reload through `platform_audio.preload()`. Verified with `moon test selene-core/src/asset --target native --deny-warn`, `moon test selene-webgpu/src --target js --deny-warn`, and `moon test selene-raylib/src --target native --deny-warn`. |
| WGAUDIO-004 | `selene-webgpu/src/audio.mbt`, `selene-webgpu/src/keycode.mbt`, `selene-webgpu/src/mouse.mbt` | Autoplay-blocked web audio is never retried after trusted user activation, so startup BGM or early SFX can remain silent until manually re-triggered. | `DONE` | Added user-activation epoch tracking from keyboard/mouse/touch input and retry logic that only restarts blocked playback after a new trusted activation. Verified with new whitebox retry tests and `moon check --target all --deny-warn`. |

## Current work queue

- None.
