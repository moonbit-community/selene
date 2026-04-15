# Selene Pages

Static output for the published Selene example pages.

## Build

```bash
cd examples
moon build --release

cd ..
python3 publish_pages.py
```

`publish_pages.py` expects the release web artifacts to exist in `_build`.

## Preview

```bash
cd page
python3 -m http.server 8000
```

Open `http://localhost:8000`.

## Clean

```bash
python3 publish_pages.py clean
```
