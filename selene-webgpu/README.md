# Milky2018/selene_webgpu

WebGPU backend implementation for Selene.

## Install

```bash
moon add Milky2018/selene_webgpu
```

## Enable This Backend

Override Selene platform interfaces in your entry package:

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
