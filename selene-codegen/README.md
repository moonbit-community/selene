# Selene ECS code generator

Generate a MoonBit companion file for `#selene.component` and
`#selene.resource` declarations.

```sh
moonx Milky2018/selene_codegen@0.39.2 movement.mbt movement.g.mbt
```

Pin the generator version used by your project. See the
[Selene ECS guide](https://github.com/moonbit-community/selene/blob/main/selene-core/src/ecs/README.md)
for package imports and `dev_build` configuration.

Use `--check source.mbt ...` to verify the generated companions without writing
files. CI can pass all tracked MoonBit sources to detect missing companions.

The resource marker generates a type identity. Initialize its value explicitly
with `world.insert_resource(value)` or `app.insert_resource(value)`. Read it
with `world.resource()`, or use `world.get_resource()` to handle a missing value.
Resource markers with factory arguments are rejected.

## Development releases

For a planned `0.40.0` Selene release, publish development generators as
`0.40.0-beta1`, `0.40.0-beta2`, and so on:

```sh
moon run --target wasm publish.mbtx -- 0.40.0-beta1 --codegen-only
```

This command updates CI, example rules, documentation pins, and generated
companions after the published executable becomes available. Record these
development changes under `Unreleased`.

The full `moon run --target wasm publish.mbtx -- 0.40.0` release publishes stable codegen first,
validates its consumers, then publishes core and WebGPU with the same stable
version. See the [release process](../CONTRIBUTING.md#release-process).
