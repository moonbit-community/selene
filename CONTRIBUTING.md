# Contributing to Selene

## Development

Use the MoonBit **latest** toolchain, a C compiler for native builds, Python 3,
and a browser with WebGPU support. Run commands from the repository root;
`moon.work` connects the engine, backend, codegen, and example modules.

```sh
moon update
moon check --deny-warn
moon test --deny-warn
```

To try a change in the browser:

```sh
moon -C examples-web build --release
python3 -m http.server 8000
```

Open <http://localhost:8000/examples/index.html>.
See the [README](README.md) for package roles and tutorials.

## Changes and pull requests

- Discuss significant changes in [GitHub Issues](https://github.com/moonbit-community/selene/issues)
  before implementation. Bug reports should include the toolchain version,
  platform, and a minimal reproduction.
- Keep changes focused. Add tests for changed behavior and update affected
  documentation and examples. Verify rendering and input changes in a browser.
- Document public APIs. Run `moon info` for affected targets and include the
  generated `.mbti` changes when the public API changes.
- Add release notes under `Unreleased` in [docs/CHANGELOG.md](docs/CHANGELOG.md),
  using `Added`, `Changed`, `Fixed`, or `Removed`. Describe breaking changes.
- Run `moon fmt` before submitting. Use commit messages such as `fix: ...` or
  `feat: ...`, and describe the resulting behavior and validation in the PR.

The [CI workflow](.github/workflows/build.yaml) defines the required checks.
`latest` must pass without warnings; `pre-release` may retain deprecation
warnings while the replacement syntax is unavailable on `latest`.
If you change `publish.py`, also run:

```sh
python3 -m unittest discover -s tests -p 'test_publish.py'
```

## Generated ECS declarations

Use `#selene.component` and `#selene.resource` as described in the
[ECS guide](selene-core/src/ecs/README.md). Update the source declarations,
regenerate their `.g.mbt` companions, and commit both. CI checks for missing
or stale companions. The examples use the published, pinned generator through
`moonx` in `dev_build`.

## Release process

For codegen changes targeting the next release, publish a development beta
before updating consumers. For example:

```sh
python3 publish.py 0.40.0-beta1 --codegen-only
```

Increment `betaN` for later generator changes; published versions are immutable.
Keep notes under `Unreleased`. The script updates generator pins and companions
after publication; review and commit those changes.

Prepare formatting and public API interfaces before publishing. The release
script checks formatting without rewriting it and does not run `moon info`.
Compiler checks and tests use `--deny-warn`; any failed command stops the release.

For a stable release, move its notes into `## [x.y.z] - YYYY-MM-DD`, leave an
empty `Unreleased` section, then run `python3 publish.py x.y.z`. The script
publishes stable codegen, validates its pinned consumers without warnings,
and publishes core before WebGPU at the same version. Review and commit the
updated manifests, dependency pins, and generated files. If publication fails,
check which packages were published before retrying.
