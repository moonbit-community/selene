# Milky2018/selene

Core ECS/runtime package for Selene.

It includes app/runtime orchestration, ECS data flow, assets, scenes, animation, 2D/3D rendering, UI, physics.

## Runtime packages

| Package | Responsibility |
| --- | --- |
| `ecs` | Worlds, entities, queries, resources, commands, and safe schedule execution |
| `app` | Application stages (`Schedule`), system registration and ordering (`SystemSet`, `SystemOrdering`), plugins, and the game loop |
| `state` | World-owned state values, deferred transitions, and state conditions |
| `time` | World-local clocks, time scale, and cancellable timeouts |
| `window` | Display configuration and coordinate conversion, mouse capture, and window exit |
| `platform_*` | Virtual interfaces implemented by a platform backend |

`window` provides engine-level operations over the platform interfaces. Input
snapshots and queries remain in `inputs`. Application stages belong to `app`;
The App driver owns ECS execution and command application; game code uses
Commands for deferred structural changes.

## Install

```bash
moon add Milky2018/selene
```

## Web Backend

Use this package with `Milky2018/selene_webgpu` for browser builds.

## Learn More

- [ECS components, resources, systems, and code generation](src/ecs/README.md)
- [States, transition timing, and lifecycle systems](src/state/README.md)
- Repository overview: [../README.md](../README.md)
- Tutorials: [../docs](../docs)
- Examples: [../examples](../examples)
