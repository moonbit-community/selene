# Milky2018/selene_webgpu

WebGPU backend for Selene web builds.

## Install

```bash
moon add Milky2018/selene_webgpu
```

## Enable This Backend

In your web wrapper package:

```moonbit
options(
  overrides: [
    "Milky2018/selene_webgpu/platform_window",
    "Milky2018/selene_webgpu/platform_input",
    "Milky2018/selene_webgpu/platform_render",
    "Milky2018/selene_webgpu/platform_audio",
    "Milky2018/selene_webgpu/platform_asset_io",
  ],
)
```

## Build And Run

```bash
moon build --target js --release
python3 -m http.server 8000
```

Open `http://localhost:8000`.

## Embedded Assets

Register embedded asset bytes before starting the application:

```moonbit
@asset.set_io(read_asset, paths=asset_paths)
```

`read_asset` has type `(String) -> Bytes?`. `asset_paths` lists the same paths
accepted by the reader; Tiled world patterns use this catalogue to discover maps
in the world file's directory. Replacing the reader replaces the catalogue too.

The example games generate their embedded assets with
`moonbit-community/embed@0.1.3` through `dev_build`. Ordinary `moon build` and
`moon test` regenerate the data when an input changes. Their `embedded_assets`
packages adapt the generated fields to the reader and path catalogue. When adding
an asset, update that package's `moon.pkg` input list and `assets.mbt` catalogue.
Generated `assets.g.mbt` files are ignored by Git.

The backend reads embedded bytes directly for asset data and audio. Images and
fonts use cached data URLs with the existing browser decoders. Paths absent from
the reader retain the backend's URL loading behavior.
