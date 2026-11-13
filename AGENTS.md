# AGENTS.md

## Changelog
- Always update `docs/CHANGELOG.md` and keep `## [Unreleased]` at the top.
- Use only `Added` / `Changed` / `Fixed` / `Removed`.
- Before `moon run --target wasm publish.mbtx -- x.y.z`, move released items from `Unreleased` into `## [x.y.z] - YYYY-MM-DD`, then keep a new empty `Unreleased`.

## `publish.mbtx`
- Run release commands from the repository root.
- Stable release: `moon run --target wasm publish.mbtx -- x.y.z`, with a matching dated changelog section.
- Development codegen: `moon run --target wasm publish.mbtx -- x.y.z-betaN --codegen-only`, with notes under `Unreleased` and N starting at 1.
- Publish stable codegen first, validate its pinned consumers, then publish `selene-core` before `selene-webgpu`. All checks must be warning-free.
- Follow [CONTRIBUTING.md](CONTRIBUTING.md#release-process) for the release sequence.

## Pages
- Build examples from the repository root with `moon build --target js --release`, then copy the generated JavaScript as described in [page/README.md](page/README.md). Serve `page/` to preview the same directory published by Pages.

## Release Manifest Behavior
- Stable publish flow rewrites each release module `moon.mod` version and internal Selene deps to `@x.y.z`.
- Stable publish flow also syncs internal Selene dependencies in `examples` and `examples-web` to `@x.y.z`.
- Codegen beta publication updates its manifest, generator pins, and generated companions.
- Release pipeline finishes with `moon update` for release modules and example modules; it does not restore old deps.

## Scope
- `examples` is for demos/pages only and is not a published package.
