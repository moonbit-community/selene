# Selene ECS

A `World` owns its entities, component columns, resources, and command queue.
The app selects a World before running its systems. A component or resource
declaration can be used in several Worlds, with separate values in each one.

## Components and systems

Mark a concrete struct or enum with `#selene.component`. The generator supplies
its default component key and implements `@ecs.Component` for the type.

```moonbit
#selene.component
priv struct Position {
  x : Double
  y : Double
}

#selene.component
priv struct Velocity {
  x : Double
  y : Double
}

fn move_entities(query : @ecs.Query2[Position, Velocity]) -> Unit {
  query.for_each_batch_mut_a((_, positions, velocities) => {
    for i in 0..<positions.length() {
      positions[i] = {
        x: positions[i].x + velocities[i].x,
        y: positions[i].y + velocities[i].y,
      }
    }
  })
}
```

Register the callback with `app.add_system(Update, @ecs.query_system(move_entities))`.
The adapter resolves and caches one query per World. Use the query callback's
views within the callback and queue structural changes through `Commands`.

Use the expected type to select a component store for point access or a spawn
bundle. An explicit World is useful for setup, tests, or cross-World work.

```moonbit
let positions : @ecs.ComponentStore[Position] = @ecs.components()
positions.set(player, { x: 3.0, y: 4.0 })

let preview_positions : @ecs.ComponentStore[Position] =
  @ecs.components_in(preview_world)
```

When two columns use the same value type, declare separate
`@ecs.ComponentKey[T]` values with `ComponentKey()`. The key provides
`get(entity)`, `set(entity, value)`, `store()`, and `store_in(world)`.

## Resources

A resource holds one value per World. Mark the type with `#selene.resource`
to generate its identity, then explicitly insert its initial value.

```moonbit
#selene.resource
priv struct Score {
  mut points : Int
}

fn setup(world : @ecs.World) -> Unit {
  world.insert_resource(Score::{ points: 0 })
}

fn score_point(world : @ecs.World) -> Unit {
  let score : Score = world.resource()
  score.points += 1
}
```

Initialize resources in application or plugin setup, or in an earlier Startup
system. `app.insert_resource(Score::{ points: 0 })` configures the app's World
before its systems run. When constructing an App for another World, call
`with_world(world)` before inserting resources.

`world.resource()` requires an existing resource and aborts when it is missing.
`world.get_resource()` returns `None` when missing. Neither operation constructs
a resource. `world.insert_resource(value)` replaces the existing value of that
type in that World. The caller can construct the value from configuration or
other resources before inserting it. Different Worlds keep separate values.

For several resources of the same type, create separate
`@ecs.ResourceKey[T]` values with `ResourceKey()`. Use
`key.insert_in(world, value)` and `key.get_in(world)`, which returns an optional
value. Internal caches can explicitly request initialization with
`key.get_or_insert_with(world, create)`; the constructor runs only when the
value is missing. `create` receives the requested World.

## Schedules and commands

Use `@ecs.commands(world)` to queue structural changes. The ECS schedule applies
one command batch and completes entity lifecycle changes when the systems finish.
Commands added while applying a batch run at the next synchronization point.
The app runs these schedules at startup, for each fixed step, and for each
game frame. Render stages consume the resulting state.

Standalone ECS code can run a schedule with `@ecs.run_schedule(world, system)`.
The scheduler rejects nested schedules and schedules started during a query.
Messages and observers live in `@event`. Queue an event operation with
`commands.add(_ => events.trigger(message, target))` when it should run with
deferred work.

## Code generation

The generator reads one `.mbt` file and writes a companion `.g.mbt` in the same
package. Import `Milky2018/selene/ecs` as `@ecs` in packages with generated files.

The generator lives in the separate `selene-codegen` module. The core module
ships its generated sources and can build independently. CI regenerates those
sources in memory to verify that the checked-in companions are current and
catch missing files before the build. CI and the examples' `dev_build` rules
run the published generator through `moonx`, pinned to version `0.39.2`.
To regenerate a file, run:

```sh
moonx Milky2018/selene_codegen@0.39.2 input.mbt input.g.mbt
```

Projects can define the same rule in their `moon.mod`. Update the pinned
version after publishing a generator change.

```moonbit
rule(
  name: "selene_codegen",
  command: "moonx Milky2018/selene_codegen@0.39.2 \"$input\" \"$output\"",
)
```

Apply the rule to each marked source file in its `moon.pkg`. Paths in this
entry are relative to the package directory.

```moonbit
dev_build(rule: "selene_codegen", input: "movement.mbt", output: "movement.g.mbt")
formatter(ignore: ["movement.g.mbt"])
```

The generator formats its own output. Commit the generated file alongside its
input and include it when publishing.
MoonBit runs `dev_build` during local development. Consumers compile the
generated sources included in the published package.
