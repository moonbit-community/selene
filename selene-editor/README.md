# selene-editor

`selene-editor` is a browser-hosted editor for a single-scene Selene project.

V1 focuses on:

- direct folder-first project opening
- a single scene editing interface
- Selene preview canvas
- MoonBit async local service
- JSON scene documents as source of truth

## Run

```bash
just build
just run
```

To use a different port:

```bash
just run 48143
```

The service hosts the editor on `http://127.0.0.1:47142` and tries to open the browser automatically.

The frontend bundle is generated into `public/editor.js`, and the service serves that static file directly.

When the page opens, `selene-editor` immediately prompts for a local folder. After you choose one:

- if `selene.project.json` already exists, the editor opens it
- if it does not exist, the editor creates a new empty project in that directory

The editor then loads the single startup scene from `scenes/main.scene.json` and shows only the scene editing interface.
