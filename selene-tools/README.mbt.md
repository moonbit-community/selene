# Milky2018/selene_tools

CLI utilities for Selene.

## Install

```bash
moon install Milky2018/selene_tools/cmd/selene-embed-assets
```

## Commands

- `selene-embed-assets`: generate an embedded asset pack and a MoonBit lookup file for native `pre-build` pipelines.

## Example

```bash
selene-embed-assets \
  --assets-dir <assets-dir> \
  --pack-out _embedded_assets.pack \
  --index-out embedded_assets_index.mbt \
  --path-prefix <runtime-prefix> \
  --blob-name embedded_assets_blob \
  --lookup-fn get_embedded_asset
```

If you load assets directly from the filesystem, you can skip this tooling.
