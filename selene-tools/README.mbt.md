# Milky2018/selene_tools

CLI tools for Selene.

## Install

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

## selene-embed-assets

Build an embedded asset pack and/or MoonBit index file for native pre-build hooks.
This is an optional optimization/packaging flow for native release; default filesystem loading does not require it.

```bash
selene-embed-assets \
  --assets-dir <assets-dir> \
  --pack-out _embedded_assets.pack \
  --index-out embedded_assets_index.mbt \
  --path-prefix <runtime-prefix> \
  --blob-name embedded_assets_blob \
  --lookup-fn get_embedded_asset
```

## moon.pkg.json pre-build example

Add the generated file as source and run `selene-embed-assets` in `pre-build`:

```json
{
  "import": [
    "Milky2018/selene",
    "Milky2018/selene_raylib"
  ],
  "source": [
    "src",
    "embedded_assets_index.mbt"
  ],
  "pre-build": [
    {
      "input": "<assets-dir>",
      "output": "_embedded_assets.pack",
      "command": "selene-embed-assets --assets-dir $input --pack-out $output --path-prefix <runtime-prefix>"
    },
    {
      "input": "<assets-dir>",
      "output": "embedded_assets_index.mbt",
      "command": "selene-embed-assets --assets-dir $input --index-out $output --path-prefix <runtime-prefix> --blob-name embedded_assets_blob --lookup-fn get_embedded_asset"
    }
  ]
}
```

If you are not embedding assets into a native binary, you can skip this setup.
