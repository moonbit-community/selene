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

fn move_entities(query : @ecs.Query[(Position, Velocity)]) -> Unit {
  query.for_each_batch(batch => {
    let positions : @ecs.WriteColumn[Position] = batch.write_column()
    let velocities : @ecs.ReadColumn[Velocity] = batch.read_column()
    for row in 0..<batch.length() {
      positions[row] = Position::{
        x: positions[row].x + velocities[row].x,
        y: positions[row].y + velocities[row].y,
      }
    }
  })
}
```

Register the typed callback directly:

```moonbit
app.add_query_system(Update, move_entities)
```

The callback's parameter supplies the row shape. The scheduler constructs and
caches that query separately for each World; no query factory is required at
registration. `add_query_system` accepts the same schedules, conditions, names,
and system-set ordering arguments as `add_system`. Use `add_system` for a
callback that explicitly needs the entire World.

There is one opaque `Query[Row]` type. `Single[T]` describes one component;
flat tuples describe two to eight components. This uses the same single-value
and tuple convention as spawn bundles, without generating additional code for
each component. `Single` wraps the query row, not the stored component.

```moonbit
let positions : @ecs.Query[@ecs.Single[Position]] = world.query1()
let moving : @ecs.Query[(Position, Velocity)] = world.query()
for entity, Single(position) in positions {
  update_position(entity, position)
}
for entity, (position, velocity) in moving {
  update_movement(entity, position, velocity)
}
let position : @ecs.Single[Position]? = positions.get(player)
```

`world.query1()` is shorthand for constructing `Query[Single[T]]`; the general
`world.query()` also accepts that shape. All shapes provide `get`, `contains`,
`single`, `length`, `for_each`, and `for_each_batch` with the same semantics.
Their component storage and batch representations are private.

For custom schedulers, `@ecs.query_system(callback)` produces a `System`.
Outside a system, use an inferred cached query constructor:

```moonbit
let moving_query : (@ecs.World) -> @ecs.Query[(Position, Velocity)] =
  @ecs.cache_query()
```

Filters are part of the query view, so point reads, counts, snapshots, row
callbacks, and batch callbacks agree about which entities match:

```moonbit
let with_velocity : @ecs.With[Velocity] = With(world)
let moving_positions : @ecs.Query[@ecs.Single[Position]] =
  world.query1(filters=[with_velocity.to_filter()])
```

`Without[T](world)` excludes archetypes containing `T`. Filters must belong to
the query's World; foreign filters are rejected. Matching happens once for each
archetype, including new archetypes encountered later. `query.with_filters(...)`
creates an independently cached view and copies its filter list. To filter a
registered system, pass `filters=world => [...]` to `add_query_system`; that
constructor runs only when the query is first needed in each World.
`QueryReader[Row]::read(query)` snapshots the same filtered row shape.

For setup and systems that explicitly need the whole World, use point access:

```moonbit
let position : Position? = world.get_component(player)
world.set_component(player, Position::{ x: 3.0, y: 4.0 })
```

Reads return `None` for foreign handles, deleted generations, or missing
components. Writes require an existing component on a materialized entity in
that World and abort otherwise. They replace values without changing the
entity's component layout.

There is no public `ComponentStore` or global component accessor. A
`ComponentKey` supplies identity only; it cannot read, write, or expose storage.
Use distinct component wrapper types for semantically different values of the
same underlying type. Component code generation produces only the identity
and `Component` implementation, with no global access functions.

MoonBit mutable values have reference semantics. A component obtained through
a query or point read can still be retained and mutated. These APIs establish
World ownership; they do not provide Rust-style borrow checking or read-only
component references. Systems currently execute sequentially.

## Spawning entities

Use `spawn1(value)` for one component, `spawn((a, b, ...))` for a flat tuple of
two to eight components, or `spawn(())` for an empty entity. `@ecs.Single(value)`
also wraps one component as a bundle. The World puts all initial values in one
archetype row. An entity keeps that component layout until permanent deletion.
Use a mutable value, such as an optional payload or an enabled flag, for state
that can change during the entity's lifetime.

```moonbit
let position : Position = { x: 3.0, y: 4.0 }
let velocity : Velocity = { x: 0.0, y: 0.0 }
let marker = world.spawn1(position)
let player = world.spawn((position, velocity))
let empty = world.spawn(())
```

Use `commands.spawn(values)` or `commands.spawn1(value)` during a query.
The scheduler initializes the returned pending handle at the command flush.
A later command in the same batch can overwrite one of its initialized values.

For repeated spawns, prepare the layout once in its owning World.

```moonbit
let players : @ecs.SpawnPlan[(Position, Velocity)] = world.prepare_spawn()
let player = players.spawn((position, velocity))
let pending = commands.spawn_prepared(players, (position, velocity))
```

Use `SpawnPlan::combine` to join plans for larger groups. A plan belongs to a single World and each component column may occur only once.

For imports whose columns depend on data, collect the values with
`world.spawn_draft()` and `draft.add(value)`, then call `draft.spawn()` once.
The draft infers each column from its component type and rejects duplicate
columns. Component stores cannot be supplied by callers.

## Hierarchy and transforms

Set a parent at spawn with `parent=`. This works for immediate and deferred
spawns, including prepared layouts. A deferred child can name a pending parent
queued before it. If the parent is unavailable when the command runs, the
scheduler cancels the child and recycles its slot.

```moonbit
let room = world.spawn(())
let player = world.spawn(
  (@transform.Spatial(@transform.Transform::from_xyz(3.0, 4.0, 0.0)), velocity),
  parent=room,
)
```

`get_parent()` and `get_children()` read the hierarchy. Children are ordered by
spawn. `destroy()` and `respawn()` preserve the subtree and its components.
`delete()` invalidates the subtree's handles and recycles their slots. Spawn a
replacement to change a node's parent or component layout.

`Spatial` holds the local pose and the cached world transform. Use
`@transform.set_local_transform(world~, entity, pose)` to update a pose and
`@transform.global_transform(world~, entity)` to read the propagation result. When a
system needs the current world pose before propagation, use
`@transform.compute_global_transform(world~, entity)`. A container without `Spatial`
passes the parent's transform to its children.

## Traversal and batch access

All row shapes keep the existing archetype column layout. Queries cache matching
archetypes and bind their columns once. They do not turn the World into an array
of row tuples. `for_each` constructs the logical row supplied to its callback;
for large hot loops, use typed columns to avoid forming a tuple for every row.
See [measured row and column costs](BENCHMARKS.md) for native and Node.js results.

```moonbit
moving.for_each_batch(batch => {
  let positions : @ecs.ReadColumn[Position] = batch.read_column()
  let velocities : @ecs.WriteColumn[Velocity] = batch.write_column()
  for row in 0..<batch.length() {
    let entity = batch.entity(row)
    velocities[row] = next_velocity(entity, positions[row], velocities[row])
  }
})
```

A batch can read or write any component declared in its query, regardless of
column order. Obtain several write columns to replace several component values
in one loop. Requesting an undeclared component is rejected even when that
component happens to exist on the same archetype. `batch.get(row)` and
`batch.set(row, value)` access a complete logical row.

`ReadColumn` permits reading elements; `WriteColumn` also permits replacement.
Reading a mutable component object does not make that object immutable. Batch
objects and columns expire when their callback returns; accessing an escaped
view aborts. They expose no raw arrays or persistent array views.

`for_each` and `for_each_batch` reject immediate structural changes and schedule
flushes during traversal. Queue spawns and deletions through `Commands`.

`iter()` returns `Iter[(Entity, Row)]`; `iter2()` returns `Iter2[Entity, Row]`.
Both read archetype rows lazily, without collecting entity handles or results.
Use ordinary loops with either one destructuring pattern or two loop variables:

```moonbit
for (entity, (position, velocity)) in moving {
  update_movement(entity, position, velocity)
}
for entity, (position, velocity) in moving {
  update_movement(entity, position, velocity)
}
```

Each iterator has its own cursor. Value writes before a row is visited are visible.
`values()` also reads lazily; `keys()` lazily follows the first component's insertion
order. Row iterators use archetype order, which is not global spawn order.

Adding or removing an archetype row in the owning World invalidates existing
iterators, including before their first step. Their next advance aborts before
reading a shifted row or a recycled entity slot. Changes in another World and
schedules that only replace values do not invalidate them. Exhausted row iterators
stay exhausted. Iterators hold no query lock between steps, so `break`, `return`,
and discarding an iterator require no cleanup.

Queue structural changes through `Commands` and flush after traversal. When
immediate deletion during traversal is necessary, explicitly use `to_array()` to
collect a shallow snapshot. Snapshots retain component objects, not deep copies of
mutable values. Lazy traversal avoids result-array allocation; constructing each
logical row can still allocate a tuple, as described in the benchmark report.

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

`@ecs.System` is a function from `World` to `Unit`. Application stages such as
`Startup`, `Update`, and `FixedUpdate` belong to `@app.Schedule`. System groups
and their ordering are also owned by `app`:

```moonbit
let movement = @app.SystemSet("movement")
let animation = @app.SystemSet("animation")
app.add_system(Update, move_system, in_set=movement, before=[animation])
```

Use `@ecs.commands(world)` to queue structural changes. The ECS schedule applies
one command batch and completes entity lifecycle changes when the systems finish.
Commands added while applying a batch run at the next synchronization point.
The app runs these schedules at startup, after `First`/`PreUpdate`, for each
fixed step, and after the ordinary updates. State transitions run between
`PreUpdate` and fixed updates, with command synchronization after exit and
entry systems. Render stages consume the resulting state. See the
[state guide](../state/README.md) for initialization and lifecycle semantics.

The app passes its selected World to engine systems, including rendering,
physics, transforms, and animation. Helpers that access components take an
explicit `world~` argument. Engine packages follow the same access rules as
game code.

Standalone ECS code can run a schedule with `@ecs.run_schedule(world, system)`.
The scheduler rejects nested schedules and schedules started during a query.
Messages and observers live in `@event`. Queue an event operation with
`commands.add(_ => events.trigger(message, target))` when it should run with
deferred work.

Timeouts belong to `time` and are stored in the active World. The default plugins
advance them once per frame. Cancellation remains valid when another World is
active. Timers scheduled by a callback become eligible on the next timer tick.

```moonbit
let handle = @time.timeout(0.5, () => finish_action())
ignore(handle.cancel())
```

Timeouts use scaled frame time by default. Pass `pausible=false` for unscaled
frame time. Custom loops can call `@time.timers_system(@time.delta())` after
advancing the World's clock.

## Code generation

The generator reads one `.mbt` file and writes a companion `.g.mbt` in the same
package. Import `Milky2018/selene/ecs` as `@ecs` for component and resource
declarations, or `Milky2018/selene/state` as `@state` for state declarations.

The generator lives in the separate `selene-codegen` module. The core module
ships its generated sources and can build independently. CI regenerates those
sources in memory to verify that the checked-in companions are current and
catch missing files before the build. CI and the examples' `dev_build` rules
run the published generator through `moonx`, pinned to the exact version
shown below.
To regenerate a file, run:

```sh
moonx Milky2018/selene_codegen@0.40.0-beta3 input.mbt input.g.mbt
```

Projects can define the same rule in their `moon.mod`. During development,
use a beta of the next planned Selene version, such as `0.40.0-beta1`.
The release script updates the pins after publishing each generator version.
Stable Selene releases use the matching stable generator. See the
[release process](../../../CONTRIBUTING.md#release-process).

```moonbit
rule(
  name: "selene_codegen",
  command: "moonx Milky2018/selene_codegen@0.40.0-beta3 \"$input\" \"$output\"",
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

## Runtime data outside components

Use a World resource for subsystem state, including caches and event readers.
Do not keep a global `Map[WorldId, State]`: the World should own its data.

Engine subsystems keep entity-indexed runtime caches inside those resources.
Game code accesses individual results or control handles rather than mutable
cache containers:

```moonbit
let interaction = @ui.interaction(entity)
let clip = @ui.calculated_clip(entity)
let position = @ui.scroll_position(entity) // a snapshot
@ui.set_scroll_position(entity, { x: 0.0, y: 100.0 })
@ui.focus(entity)

if @audio.audio_sink(entity) is Some(sink) {
  sink.set_volume(0.5)
  sink.pause()
}
```

Scroll position updates are applied and clamped during layout. Readers return
copies of mutable value data, including scroll positions and character contact
arrays. Audio sinks are opaque control handles with playback operations.
Visibility and character motion readers return results from the latest
propagation or physics pass. LDtk respawn requests use `mark_ldtk_respawn`,
`clear_ldtk_respawn`, and `is_ldtk_respawn_requested`.

The underlying entity tables can retain deleted generations until the owning
subsystem releases external resources. Public readers reject deleted handles
and do not expose those cleanup records.

Prefer direct iteration for reads. Use `Map::retain` for simple filtering, and
queue entity deletions through `Commands` while traversing components. Collect a
snapshot only when callbacks or structural changes require a stable set of
entries. A snapshot preserves entries, not a deep copy of mutable values.
