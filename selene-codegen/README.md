# Selene ECS code generator

Generate a MoonBit companion file for `#selene.component`, `#selene.resource`,
and `#selene.state` declarations.

```sh
moonx Milky2018/selene_codegen@0.40.0-beta3 movement.mbt movement.g.mbt
```

Pin the generator version used by your project. See the
[Selene ECS guide](https://github.com/moonbit-community/selene/blob/main/selene-core/src/ecs/README.md)
for package imports and `dev_build` configuration.

Use `--check source.mbt ...` to verify the generated companions without writing
files. CI can pass all tracked MoonBit sources to detect missing companions.

The component marker generates a `ComponentKey` and a `Component`
implementation. The key identifies the component across Worlds; it exposes no
storage or data access. Obtain component data through `world.query()`, joined
World queries, or `world.get_component(entity)`. The generator does not emit
global store accessors. Existing generated companions need no regeneration
for this access-model change.

The resource marker generates a type identity. Initialize its value explicitly
with `world.insert_resource(value)` or `app.insert_resource(value)`. Read it
with `world.resource()`, or use `world.get_resource()` to handle a missing value.
Resource markers with factory arguments are rejected.

State markers generate one `@state.StateKey[T]` and an implementation of
`@state.StateType`, and attach its shared `set` method to the declared type.
Use `GamePhase::set(Playing)` in a running system to request a transition in
the active World. Import `Milky2018/selene/state` as `@state` in that package.
The state type must implement `Eq`, usually with `#derive(Eq)`. The marker
does not implement `Resource` for the state value or initialize a World.
Use `app.init_state(initial)` explicitly. See the
[state guide](../selene-core/src/state/README.md) for transitions and lifecycle
systems. Generic declarations and multiple Selene markers on one type are rejected.

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
