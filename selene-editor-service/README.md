# selene-editor-service

Native local HTTP/RPC/SSE daemon for Selene Editor.

## Run From Source

1. Build frontend bundle and copy to `public/editor.js`:

```bash
cd ../selene-editor-frontend
moon build frontend/web --target js --release --manifest-path moon.mod.json
cp ../_build/js/release/build/Milky2018/selene_editor_frontend/frontend/web/web.js ../selene-editor-service/public/editor.js
```

2. Run service:

```bash
cd ../selene-editor-service
moon run service --target native --manifest-path moon.mod.json -- --port 47142
```
