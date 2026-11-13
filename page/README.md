# Selene Pages

This directory is the complete GitHub Pages site. Example pages, screenshots,
and other static images live in `examples/`; game assets are embedded in the
compiled JavaScript.

## Build

Run these commands from the repository root:

```bash
moon update
moon build --target js --release
for game in cards pixeladventure survivors; do
  cp "_build/js/release/build/Milky2018/selene-examples-web/$game/web/web.js" "page/examples/$game/web.js"
done
python3 -m http.server --directory page 8000
```

Open `http://localhost:8000/` or `http://localhost:8000/examples/`.
Each game page loads its adjacent `web.js`, which is ignored by Git.
The Pages workflow uses the same build and copy commands, then publishes this
directory directly.
