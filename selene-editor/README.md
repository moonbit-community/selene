# selene-editor

`selene-editor` is a browser-hosted editor for Selene projects.

V1 focuses on:

- Rabbita-based editor shell
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

Inside the editor page, use `Choose Folder` to select a project directory from the local filesystem. If the chosen directory does not already contain a `*.project.json` manifest, `selene-editor` will initialize a new project there automatically using the directory name.
