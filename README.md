# Selene Game Engine [中文版](./README-zh.md)

Selene is an ECS game engine for MoonBit with a WebGPU renderer for browsers. Native WebGPU support is planned.

## Packages

| Package | Purpose |
| --- | --- |
| `Milky2018/selene` | Core ECS/runtime modules (`app`, `asset`, `animation`, `scene`, `physics2d/3d`, `render2d/3d`, `ui`) |
| `Milky2018/selene_webgpu` | Web backend implementation |

## Quick Start

Use the MoonBit `latest` toolchain. The sources also support `pre-release`,
which may report syntax deprecation warnings until `latest` supports the replacements.

```bash
moon build --target js --release
python3 -m http.server 8000
```

Open `http://localhost:8000/examples/index.html`.

## Documentation

- English tutorial: [docs/tutorial-en.md](./docs/tutorial-en.md)
- Chinese tutorial: [docs/tutorial-zh.md](./docs/tutorial-zh.md)
- Changelog: [docs/CHANGELOG.md](./docs/CHANGELOG.md)
- Examples: [examples](./examples/)

## Status

Selene is still experimental and evolves quickly.

## License

Apache-2.0
