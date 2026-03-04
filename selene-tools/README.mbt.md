# Milky2018/selene_tools

CLI tools for Selene.

## Install

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

## selene-embed-assets

Build an embedded asset pack and/or MoonBit index file for native pre-build hooks.

```bash
selene-embed-assets \
  --assets-dir examples/assets/pixeladventure \
  --pack-out _embedded_assets.pack \
  --index-out embedded_assets_index.mbt \
  --path-prefix assets/pixeladventure \
  --blob-name embedded_assets_blob \
  --lookup-fn get_embedded_asset
```
