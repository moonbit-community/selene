# selene-editor-frontend

Browser UI and preview runtime for Selene Editor.

## Build

```bash
moon build frontend/web --target js --release --manifest-path moon.mod.json
cp ../_build/js/release/build/Milky2018/selene_editor_frontend/frontend/web/web.js ../selene-editor-service/public/editor.js
```

`selene-editor-service` serves `public/editor.js` directly, so the release bundle must be copied after each frontend rebuild.
