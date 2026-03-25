# selene-editor

`selene-editor` is a browser-hosted editor for Selene projects.

V1 focuses on:

- Rabbita-based editor shell
- Selene preview canvas
- MoonBit async local service
- JSON scene documents as source of truth

## Run

```bash
moon build frontend/web --target js
moon run service --target native
```

To open an existing project immediately:

```bash
moon run service --target native -- /absolute/project/path
```

The service hosts the editor on `http://127.0.0.1:47142` and tries to open the browser automatically.
