# selene-editor-frontend

Browser shell and preview runtime for Selene Editor.

## Build Frontend Bundle (release)

```bash
moon build frontend/web --target js --release --manifest-path moon.mod.json
cp ../_build/js/release/build/Milky2018/selene_editor_frontend/frontend/web/web.js ../selene-editor-service/public/editor.js
```

The service serves `public/editor.js` directly, so frontend bundle generation and copy are explicit source steps.
