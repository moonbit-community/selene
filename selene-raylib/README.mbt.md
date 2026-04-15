# Milky2018/selene_raylib

raylib-based native backend for Selene.

## Install

```bash
moon add Milky2018/selene_raylib
```

## Enable This Backend

In your native wrapper package:

```moonbit
options(
  overrides: [
    "Milky2018/selene_raylib/platform_window",
    "Milky2018/selene_raylib/platform_input",
    "Milky2018/selene_raylib/platform_render",
    "Milky2018/selene_raylib/platform_audio",
    "Milky2018/selene_raylib/platform_asset_io",
  ],
)
```

## Build And Run

```bash
moon run --target native
```

## Optional Asset Embedding

For embedded native assets, use `Milky2018/selene_tools/cmd/selene-embed-assets` in your package `pre-build` pipeline.
