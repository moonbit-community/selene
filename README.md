# Selene Game Engine [中文版](./README-zh.md)

Selene is an ECS game engine for MoonBit with a WebGPU-first web backend, a raylib native backend, and an in-repo scene editor stack.

## Packages

| Package | Purpose |
| --- | --- |
| `Milky2018/selene` | Core ECS/runtime modules (`app`, `asset`, `editor_bridge`, `animation`, `scene`, `physics2d/3d`, `render2d/3d`, `ui`) |
| `Milky2018/selene_webgpu` | Web backend implementation |
| `Milky2018/selene_raylib` | Native backend implementation |
| `Milky2018/selene_editor_shared` | Shared editor protocol and bridge contracts |
| `Milky2018/selene_editor_frontend` | Browser editor shell and preview runtime |
| `Milky2018/selene_editor_service` | Native local editor service |

## Quick Start

```bash
cd examples
moon update
moon build --release
python3 -m http.server 8000
```

Open `http://localhost:8000/index.html`.

## Editor

From the repository root:

```bash
just editor
```

This builds the frontend bundle, copies it into the service, and starts the local editor service on port `47142`.

## Documentation

- English tutorial: [docs/tutorial-en.md](./docs/tutorial-en.md)
- Chinese tutorial: [docs/tutorial-zh.md](./docs/tutorial-zh.md)
- Changelog: [docs/CHANGELOG.md](./docs/CHANGELOG.md)
- Examples: [examples](./examples/)

## Status

Selene is still experimental and evolves quickly.

## License

Apache-2.0
