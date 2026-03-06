# Selene Game Engine [中文版](./README-zh.md)

Selene is an ECS game engine for MoonBit, with a WebGPU-first web backend and a raylib native backend.

## Packages

| Package | Purpose |
| --- | --- |
| `Milky2018/selene` | Core ECS/runtime modules (`system`, `state`, `commands`, `event`, `asset2`, `physics2d/3d`, `render2d/3d`, `ui`) |
| `Milky2018/selene_webgpu` | Web backend implementation |
| `Milky2018/selene_raylib` | Native backend implementation (raylib) |
| `Milky2018/selene_tools` | CLI utilities (including embedded-asset tooling) |

## Current Direction

- Bevy-aligned runtime semantics (state flow, system sets, typed events, command flushing)
- Unified frame submission (`RenderExtract -> RenderPrepare -> Render`)
- 2D + 3D gameplay support in the same engine
- WebGPU as feature baseline, raylib as explicit downgrade backend

## Run Examples (Web)

```bash
cd examples
moon update
moon build --release
python3 -m http.server 8000
```

Open `http://localhost:8000/index.html`.

## Native Asset Embedding for raylib (Optional)

This is an optional optimization and packaging workflow for native releases.
By default, you can skip this and load assets from filesystem paths.

Install the CLI:

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

Then add pre-build steps in your native wrapper package `moon.pkg`:

```moonbit
options(
  "pre-build": [
    {
      "input": "<your-assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir $input --pack-out $output --path-prefix <runtime-prefix>",
    },
    {
      "input": "<your-assets-dir>",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir $input --index-out $output --path-prefix <runtime-prefix> --blob-name embedded_assets_blob --lookup-fn get_embedded_asset",
    },
    {
      "input": "_embedded_assets.pack",
      "output": "embedded_assets_blob.mbt",
      "command": ":embed --binary -i $input -o $output --name embedded_assets_blob",
    },
  ],
)
```

Use the same value for both `<your-assets-dir>` fields, and make `<runtime-prefix>` match your runtime asset paths.

When embedding is enabled, register the lookup before `app.run()`:

```moonbit
@asset.set_io(get_embedded_asset)
```

If embedding is not enabled, do not call this API.

## Documentation

- English tutorial: [docs/tutorial-en.md](./docs/tutorial-en.md)
- Chinese tutorial: [docs/tutorial-zh.md](./docs/tutorial-zh.md)
- Changelog: [docs/CHANGELOG.md](./docs/CHANGELOG.md)
- Examples: [examples](./examples/)

## License

Apache-2.0
