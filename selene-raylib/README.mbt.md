# Milky2018/selene_raylib

Native backend implementation for Selene based on `tonyfettes/raylib`.

## Embed assets with MoonBit pre-build

This is an optional optimization and packaging workflow for native binary distribution.
By default, you can skip it and let raylib load textures/audio/fonts from the filesystem.

### 1. Install the asset bundling CLI

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

### 2. Add pre-build hooks in your game package `moon.pkg`

```moonbit
options(
  "pre-build": [
    {
      "input": "<assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir $input --pack-out $output --path-prefix <runtime-prefix>",
    },
    {
      "input": "<assets-dir>",
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

Use the same `<assets-dir>` in both pre-build steps, and set `<runtime-prefix>` to match your runtime asset paths.

This generates:
- `embedded_assets_blob.mbt` (raw bytes via `:embed`)
- `embedded_assets_index.mbt` (`get_embedded_asset(path) -> Bytes?`)

### 3. Install embedded lookup before `App::run` (only when embedding is enabled)

```moonbit
import { "Milky2018/selene/backend" @backend }

fn main {
  @backend.set_embedded_assets(get_embedded_asset)
  // app.run()
}
```

When installed, `selene_raylib` will prefer embedded bytes for:
- images/textures
- sounds/music
- fonts

If a path is not found in embedded assets, it falls back to filesystem loading.

If embedding is not enabled, you should not call `set_embedded_assets`.
