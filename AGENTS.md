# AGENTS.md

## Changelog
- Always update `docs/CHANGELOG.md` and keep `## [Unreleased]` at the top.
- Use only `Added` / `Changed` / `Fixed` / `Removed`.
- Before `python3 publish.py x.y.z`, move released items from `Unreleased` into `## [x.y.z] - YYYY-MM-DD`, then keep a new empty `Unreleased`.

## `publish.py`
- Pages: `python3 publish.py` (or `python3 publish.py clean`), with examples release build already in `_build`.
- Release: `python3 publish.py x.y.z`; it will fail if changelog has no matching version header.
- Release order is fixed: `selene-core -> selene-webgpu -> selene-raylib -> selene-tools`, all checks must be warning-free.

## Release Manifest Behavior
- Publish flow rewrites each release module `moon.mod.json` version and internal Selene deps to `x.y.z`.
- Cleanup restores only `deps` and runs `moon update`.
- Cleanup does not revert the `version` field.

## Scope
- `examples` is for demos/pages only and is not a published package.
