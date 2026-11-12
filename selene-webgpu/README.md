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

Embed resource files with `moonbit-community/embed@0.1.3` in a `dev_build`
rule. The example games demonstrate the generated structured resource fields.
Construct a resource value and register it once:

```moonbit
let image = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.cards.a_c_png),
)
let sprite = @sprite.Sprite(image=Some(image))
```

`Assets[T]` stores values and returns `Handle[T]`. `asset.images`, `asset.audios`,
and `asset.fonts` are the default collections; applications may also create
independent `Assets[T]` collections. Images, audio, and fonts are encoded resource
values constructed with `Image::from_bytes`, `Audio::from_bytes`, and
`Font::from_bytes`. Construction and registration do
not perform file IO, decode media, or require an active World or browser device.
Reuse the returned handles across sprites, UI nodes, 3D material textures, and
playback requests. 2D and 3D image handles refer to the same resource type.

Backends prepare resources when they are used. `image_preparation_state`,
`audio_preparation_state`, and `font_preparation_state` distinguish unprepared,
preparing, ready, and failed resources. File-loader `LoadState::Loaded` means the
encoded data was read; it does not imply successful decoding or GPU readiness.

Use `collection.get(handle)` to read a resource, `insert(handle, value)` to
replace it while retaining its identity, and `remove(handle)` to invalidate it.
Collection operations reject foreign and removed handles. Backend caches are
invalidated on replacement and removal. Existing audio instances retain their
Blob source until they finish or are stopped.

The example games require no path catalogue. Their generated `assets.g.mbt`
files are ignored by Git. `moon build` and `moon test` regenerate them using the
input files declared in each asset package's `moon.pkg`.

## Path-Based Resources

The existing file loaders remain available. Register a reader with
`@asset.set_io(read_asset, paths=asset_paths)` when assets are supplied by a
custom source. The path catalogue is optional and used for Tiled `.world`
patterns; relative references in maps use the reader. These path loaders populate
the same resource collections as direct registration.
