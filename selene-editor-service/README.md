# selene-editor-service

Native local HTTP/RPC/SSE service for Selene Editor.

## Quick Start

From the repository root:

```bash
just editor
```

## Manual Run

First build and copy the frontend bundle, then run:

```bash
moon run service --target native --manifest-path moon.mod.json -- --port 47142
```
