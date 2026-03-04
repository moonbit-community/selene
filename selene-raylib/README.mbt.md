# Milky2018/selene_raylib

Native backend implementation for Selene based on `tonyfettes/raylib`.

## Embed assets with MoonBit pre-build

For native binary distribution, you can embed all assets into the executable and let raylib load textures/audio/fonts from memory.

### 1. Install the asset bundling CLI

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

### 2. Add pre-build hooks in your game package `moon.pkg`

```moonbit
options(
  "pre-build": [
    {
      "input": "../../examples/assets/pixeladventure",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir ../../examples/assets/pixeladventure --pack-out $output --path-prefix assets/pixeladventure",
    },
    {
      "input": "../../examples/assets/pixeladventure",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir ../../examples/assets/pixeladventure --index-out $output --path-prefix assets/pixeladventure --blob-name embedded_assets_blob --lookup-fn get_embedded_asset",
    },
    {
      "input": "_embedded_assets.pack",
      "output": "embedded_assets_blob.mbt",
      "command": ":embed --binary -i $input -o $output --name embedded_assets_blob",
    },
  ],
)
```

This generates:
- `embedded_assets_blob.mbt` (raw bytes via `:embed`)
- `embedded_assets_index.mbt` (`get_embedded_asset(path) -> Bytes?`)

### 3. Install embedded lookup before `App::run`

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
