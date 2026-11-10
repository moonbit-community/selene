# Selene Pages

This directory contains the site's landing page. Example pages and assets live
in `examples/`.

## Build

Run these commands from the repository root:

```bash
moon update
moon build --target js --release
python3 -m http.server 8000
```

Open `http://localhost:8000/examples/index.html`. The Pages workflow copies the
landing page, examples, and compiled JavaScript into the deployment directory.
