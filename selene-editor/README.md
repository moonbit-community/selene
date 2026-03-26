# selene-editor

`selene-editor` is a browser-hosted 2D editor for Selene-only game projects.

The current architecture is:

- `Milky2018/selene/editor_bridge` as the only project/resource/scene bridge
- multi-scene Selene projects rooted at `selene.project.json`
- dedicated Selene-native asset documents for atlases and animations
- a browser editor shell plus a real Selene preview runtime
- a local MoonBit async service for file IO, RPC, and static hosting

## Run

```bash
just run
```

`just run` now rebuilds `public/editor.js` before starting the local service, so the browser cannot accidentally boot against a stale frontend bundle after source changes.

To use a different port:

```bash
just run 48143
```

The service hosts the editor on `http://127.0.0.1:47142` and tries to open the browser automatically. The frontend bundle is generated into `public/editor.js`, and the service serves that static file directly.

## Project Layout

`selene-editor` now works with this Selene-native project layout:

```text
<project-root>/
  selene.project.json
  scenes/
    *.scene.json
  prefabs/
    *.prefab.json
  assets/
    images/**
    audio/**
    fonts/**
    atlases/**/*.atlas.json
    animations/**/*.anim.json
  .selene-editor/
    workspace.json
    cache/**
```

When the page opens, `selene-editor` starts on a simple main menu with the Selene Editor mark and an explicit `Open Project` action. After you choose a local folder:

- if `selene.project.json` already exists, the editor opens it
- if it does not exist, the editor creates a new empty Selene project in that directory

## Current Editor Surface

The current shell is organized around:

- `Scene Browser`
- `Asset Browser`
- `Viewport`
- `Scene Tree`
- `Inspector`

The current first-pass authoring actions are:

- create atlas assets from selected images
- create animation assets from selected atlases
- save the selected entity subtree as a prefab
- insert selected image / atlas / animation / prefab resources into the active scene

The current resource chain is:

- images from `assets/images/**`
- atlas asset documents from `assets/atlases/**/*.atlas.json`
- animation asset documents from `assets/animations/**/*.anim.json`
- prefab documents from `prefabs/*.prefab.json`

Preview instantiation goes through `Milky2018/selene/editor_bridge`, so the editor preview and future game runtime share the same scene/asset bridge instead of maintaining private editor-only scene compilation logic.
