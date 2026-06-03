# Pixel Adventure Example

A small Selene example built around scene documents, atlases, animation clips/graphs, and the editor/runtime round-trip.

## Run

```bash
moon -C examples-web build ./pixeladventure/web --target js --release
cd examples
python3 -m http.server 8000
```

Open `http://localhost:8000/pixeladventure/`.

## Asset Sources

- https://pixelfrog-assets.itch.io/pixel-adventure-1
- https://brackeysgames.itch.io/brackeys-platformer-bundle
