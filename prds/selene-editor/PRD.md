# PRD: selene-editor

## Problem

Selene currently lacks a first-party scene editor that lets users create, inspect, and revise Selene scene documents without hand-editing JSON or building one-off level pipelines around LDtk or Tiled.

The current `selene-editor` prototype proves that JSON scene documents, a browser-hosted shell, a local native service, and an in-browser Selene preview can work together. However, the user experience is not yet specified clearly enough. As a result, implementation decisions have drifted away from the intended interaction model, and users cannot reliably predict how to open a project, create a project, edit a scene, or understand errors.

The main problem to solve is not only missing features, but missing product clarity. `selene-editor` needs an explicit product contract so the UI, service behavior, preview behavior, and future tests all target the same user-facing workflow.

## Goal

Build a first-party 2D scene editor for Selene that:

- opens and creates Selene JSON projects predictably
- edits scene documents visually and structurally
- previews the scene using the real Selene runtime
- uses JSON documents as the source of truth
- exposes a simple, understandable workflow for users who do not need to know the internal frontend/service/preview split

The editor must feel like a coherent product, not a development scaffold.

## Target Users

- Selene users building 2D games or interactive scenes
- Selene maintainers validating scene/runtime integration
- Users who want a lightweight editor around Selene scene JSON without adopting an external DCC or level editor as the primary authoring tool

## Product Principles

1. **JSON-first**  
   Project and scene files are the source of truth. The editor edits JSON documents, and the preview reflects them.

2. **Editor-first preview**  
   The preview is for editing and validation. It is not a separate project build pipeline.

3. **Clear first-run flow**  
   Users must immediately understand whether they need to choose a folder, open an existing project, or create a new one.

4. **No hidden toolchain dependency**  
   Running the editor and editing JSON projects must not require the user to understand or run `moon`.

5. **Selene-native scene semantics**  
   The scene format must be consumable by Selene runtime code through `Milky2018/selene/editor_bridge`.

## Core Features

1. **Project entry flow**
   - On launch, the editor presents a clear entry state for choosing a folder, opening a project, or creating a new project.
   - The editor must never attempt project creation or opening against an empty root path.

2. **Project document management**
   - A Selene Editor project is rooted at a directory containing `<name>.project.json`.
   - Scene documents live under `scenes/<name>.scene.json`.
   - Opening a valid project loads the startup scene automatically.
   - Creating a project writes the project manifest and a default startup scene.

3. **Scene editing**
   - The editor displays a scene tree, inspector, asset browser, viewport, and logs.
   - Users can select entities from the scene tree or viewport.
   - Users can edit at least:
     - entity name
     - `Transform2d`
     - `Visibility`
     - `Sprite`
     - `Text2d`
   - Users can add and delete basic entities.

4. **Live preview**
   - The viewport renders the current scene using the real Selene runtime.
   - Loading a scene document instantiates it through `Milky2018/selene/editor_bridge`.
   - Selection and transform edits synchronize between shell and preview.

5. **Error clarity**
   - Invalid actions must produce actionable messages.
   - Typical examples:
     - no folder selected
     - invalid project directory
     - malformed JSON
     - missing asset
     - unsupported component/document version

## UX Requirements

### Entry Screen

When no project is open, the editor must behave as an entry flow, not as a fully armed scene editor.

Minimum expectations:

- The top-level UI must make it obvious that the first action is to choose a folder.
- `Open Project` and `Create Project` must not silently operate on an empty path.
- If no folder is selected, the primary feedback must be a clear instructional message, not a low-level IO or decode error.

### Open Project Flow

1. User chooses a folder.
2. User clicks `Open Project`.
3. If the directory contains a valid `<name>.project.json`, the editor:
   - loads the manifest
   - loads the startup scene
   - populates scene tree, asset browser, inspector state, and preview
4. If the directory is not a valid project, the editor must say why.

### Create Project Flow

1. User chooses a folder.
2. User enters a project name.
3. User clicks `Create Project`.
4. The editor writes:
   - `<name>.project.json`
   - `scenes/<name>.scene.json`
5. The editor then opens that project and startup scene.

### Editing Flow

1. User selects an entity.
2. Inspector shows editable properties for supported components.
3. Editing a property updates the in-memory `SceneDocument`.
4. Preview updates to reflect the change.
5. Saving writes the current JSON scene document to disk.

## Acceptance Criteria

- [ ] Launching the editor with no open project shows a clear instruction to choose a folder before opening or creating a project.
- [ ] Clicking `Open Project` with no chosen folder does not send a filesystem write/open request and instead shows a clear user-facing validation message.
- [ ] Clicking `Create Project` with no chosen folder does not send a filesystem write request and instead shows a clear user-facing validation message.
- [ ] Choosing a valid project directory and clicking `Open Project` loads the manifest and startup scene successfully.
- [ ] Choosing an empty directory, entering a project name, and clicking `Create Project` creates `<name>.project.json` and `scenes/<name>.scene.json`, then opens the project.
- [ ] After a scene is opened, selecting an entity in the scene tree updates the inspector and preview selection.
- [ ] Selecting an entity in the preview updates the scene tree and inspector selection.
- [ ] Editing `Transform2d.translation.x/y` in the inspector updates both the in-memory `SceneDocument` and the preview scene.
- [ ] Editing `Text2d.content` in the inspector updates both the in-memory `SceneDocument` and the preview scene.
- [ ] Toggling `Visibility.visible` updates both the in-memory `SceneDocument` and the preview scene.
- [ ] Saving and re-opening a project preserves all supported scene edits.
- [ ] Runtime scene loading for preview is implemented through `Milky2018/selene/editor_bridge`, not a private editor-only scene compiler.
- [ ] The game/runtime side can consume the same project/scene JSON through `Milky2018/selene/editor_bridge`.

## Scope

### In Scope

- Browser-hosted `selene-editor`
- Local native service for project/document IO and file watching
- Rabbita shell UI
- Selene-based 2D preview
- JSON project and scene documents
- Basic 2D entity editing
- `editor_bridge`-based scene instantiation
- Explicit product and UX behavior for entry/open/create/edit/save flows

### Out of Scope

- 3D scene editing
- Prefab authoring
- Multiplayer collaboration
- Code editor / IDE features
- Shader graph / material graph
- User project build/export pipelines
- Packaging the editor as a desktop shell in this phase

## Correctness Verification

Verification must happen at three levels:

1. **Schema and bridge verification**
   - Round-trip project and scene JSON documents through `Milky2018/selene/editor_bridge`
   - Validate malformed/unsupported JSON behavior
   - Verify `SceneDocument -> ECS World` instantiation for supported components

2. **Behavior-driven editor verification**
   - Use the `selene-editor` BDD harness to verify:
     - entry flow
     - open/create flows
     - selection sync
     - inspector edits
     - save/reopen persistence

3. **Runtime smoke verification**
   - Launch the actual service
   - Load the actual browser page and latest `public/editor.js`
   - Confirm the first-run page, open/create actions, and error states match this PRD

## Reproduction Steps

### Build the editor frontend bundle

```bash
cd selene-editor
just build
```

### Run the editor service

```bash
cd selene-editor
just run
```

### Run editor checks and tests

```bash
cd selene-editor
just check
just test
```

### Run core/runtime checks for the shared bridge

```bash
cd selene-core
moon check --target all
moon test src/editor_bridge/editor_bridge_wbtest.mbt
```

## References

- [selene-editor README](/Users/zhengyu/Documents/projects/selene/selene-editor/README.md)
- [selene-core editor_bridge package](/Users/zhengyu/Documents/projects/selene/selene-core/src/editor_bridge)
- [Selene changelog](/Users/zhengyu/Documents/projects/selene/docs/CHANGELOG.md)
