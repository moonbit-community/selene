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
  query.batches(batch => {
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

Register a single-parameter callback directly. Use `argsN` for an ordinary
function with several parameters:

```moonbit
app.add_system(Update, move_entities)

fn remove_dead(
  enemies : @ecs.Query[(Enemy, Health)],
  commands : @ecs.Commands,
) -> Unit {
  for entity, (_, health) in enemies {
    if health.value <= 0 {
      commands.delete(entity)
    }
  }
}
app.add_system(Update, @ecs.args2(remove_dead))
```

`SystemParam` supplies `Query[Row]`, `Commands`, `Res[T]`, optional `Res[T]?`,
`Unit`, and tuples of two through eight parameters. `args0` adapts a function
with no arguments; `args2` through `args8` adapt ordinary multiargument
functions. Single-parameter functions need no adapter. These adapters also work
with predicates passed to `Condition`.

The scheduler prepares parameters once per registration and World, then fetches
them on each execution. A `System` is an opaque description, not a callable
function. Registering the same description twice creates independent parameter
state. `World` is deliberately not a `SystemParam`: use
`app.add_exclusive_system(stage, callback)` when full World access is needed.
This is an explicit access declaration; execution remains sequential.
`@time.Time`, `@time.Timers`, `@state.State[T]`, and `@state.NextState[T]`
are additional parameters supplied by their respective packages. Time reads
follow the active frame or fixed step; state requests remain deferred.

Systems should declare the resources and queries they use. Pass these values
through their helper functions as well. Named parameters can group a subsystem's
fixed component queries and runtime state without retaining a World.

Use `Entities` for entity validity and liveness, and `Hierarchy` for the fixed
parent-child tree:

```moonbit
fn inspect_tree(entities : @ecs.Entities, hierarchy : @ecs.Hierarchy) -> Unit {
  for root in hierarchy.roots() {
    for child in hierarchy.children(root) {
      if entities.is_alive(child) {
        inspect_child(root, child)
      }
    }
  }
}
app.add_system(Update, @ecs.args2(inspect_tree))
```

Both parameters are read-only and bound to one World. They retain entity
metadata, not the World, and expose no component access or structural changes.
`Entities::is_valid` accepts a reserved handle before its spawn is flushed;
`is_alive` requires a materialized live entity. `iter` and `count` include live
entities only. `Hierarchy::children` returns an independent array; relationships
become visible when deferred spawning completes. Foreign and stale handles
return `false`, `None`, or an empty child array.

Subsystem parameters include `@transform.Transforms`, `@visibility.VisibilityState`,
`@physics2d.PhysicsMotion`, `@render2d.Frame2D`, and `@ui.UiGeometryView`.
They provide the corresponding operations on their bound data. `Frame2D` stays
valid across frame resets. Custom UI material callbacks submit commands through
`context.frame`.

Keep exclusive systems for operations that need the World itself, such as
runtime-selected animation field types or data-driven importer factories.
`current_world`, explicit World methods, and convenience calls such as
`GamePhase::set(...)` and `timeout(...)` remain available. They are useful at
application boundaries and callbacks, while ordinary systems receive their
dependencies as parameters.

Event buses may be declared globally; queues and reader cursors belong to each
World. A prepared parameter can bind a writer with `events.writer(world=world)`
and a cursor with `reader.bind(world, events)`. Pass the resulting
`EventWriter[T]` and `EventReaderView[T]` to helpers and call `send` or `read`
there. They remain bound when the active World changes; rebinding the same reader
in the same World shares its cursor. Event maintenance uses an injected
`@event.EventRegistry`.

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
`world.query()` also accepts that shape. All shapes provide `get`, `set`, `contains`,
`single`, `length`, ordinary `for` loops, and `batches` with the same semantics.
Their component storage and batch representations are private.

Use `query.set(entity, row)` to replace value components through the same
World-bound query, including during ordinary iteration:

```moonbit
for entity, (position, velocity) in moving {
  moving.set(entity, (Position::{ x: position.x + velocity.x, y: position.y + velocity.y }, velocity))
}
positions.set(player, Single(Position::{ x: 3.0, y: 4.0 }))
```

Point writes replace the whole declared row. Use a narrower query when replacing
only one component. Writes never add components or change the entity's layout;
they preserve iterator validity and abort for missing, foreign, deleted, or
filtered-out rows. Use `batches` for loops that need direct column access.

Outside a system, use an inferred cached query constructor:

```moonbit
let moving_query : (@ecs.World) -> @ecs.Query[(Position, Velocity)] =
  @ecs.cache_query()
```

Filters are part of the query view, so point reads, counts, snapshots, ordinary
iteration, and batch callbacks agree about which entities match:

```moonbit
let with_velocity : @ecs.With[Velocity] = With(world)
let moving_positions : @ecs.Query[@ecs.Single[Position]] =
  world.query1(filters=[with_velocity.to_filter()])
```

`Without[T](world)` excludes archetypes containing `T`. Filters must belong to
the query's World; foreign filters are rejected. Matching happens once for each
archetype, including new archetypes encountered later. `query.with_filters(...)`
creates an independently cached view and copies its filter list. To filter a
registered system, declare a custom parameter that constructs the filtered query
in `SystemParam::prepare`:

```moonbit
priv struct MovingPositions {
  query : @ecs.Query[@ecs.Single[Position]]
}

impl @ecs.SystemParam for MovingPositions with fn prepare(world) {
  let with_velocity : @ecs.With[Velocity] = With(world)
  let query : @ecs.Query[@ecs.Single[Position]] =
    world.query1(filters=[with_velocity.to_filter()])
  _ => { query, }
}
```

The returned fetcher must not retain `world`: the World owns its prepared state.
Cache queries or resource slots, and use the World supplied to the fetcher for
operations that need it. Preparation is lazy and occurs only when conditions
allow the system to run. Custom named parameter structs can also combine the
built-in parameters through their `prepare` methods. For example, Cards combines
its runtime resource, text/node queries, and Commands in a private `CardsGame`
parameter; Survivors groups widget queries in `SurvivorsUi`. These views contain
concrete handles rather than a World, and fetch the latest resource value on
each execution so restarting a game does not retain the previous session.
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

Use `commands.spawn1(value)` for one component, `commands.spawn((a, b, ...))`
for a flat tuple of two to eight components, or `commands.spawn(())` for an empty entity. `@ecs.Single(value)`
also wraps one component as a bundle. The World puts all initial values in one
archetype row. An entity keeps that component layout until permanent deletion.
Use a mutable value, such as an optional payload or an enabled flag, for state
that can change during the entity's lifetime.

```moonbit
let position : Position = { x: 3.0, y: 4.0 }
let velocity : Velocity = { x: 0.0, y: 0.0 }
let commands = @ecs.commands(world)
let marker = commands.spawn1(position)
let player = commands.spawn((position, velocity))
let empty = commands.spawn(())
```

All public structural operations are deferred, both in setup and during queries.
The scheduler initializes the returned pending handle at the command flush.
A later command in the same batch can overwrite one of its initialized values.

For repeated spawns, prepare the layout once in its owning World.

```moonbit
let players : @ecs.SpawnPlan[(Position, Velocity)] = commands.prepare_spawn()
let pending = commands.spawn_prepared(players, (position, velocity))
```

Use `SpawnPlan::combine` to join plans for larger groups. A plan belongs to a single World and each component column may occur only once.

For imports whose columns depend on data, collect the values with
`commands.draft()` and `draft.add(value)`, then call `commands.spawn_draft(draft)` once.
The draft infers each column from its component type and rejects duplicate
columns. Component stores cannot be supplied by callers.

## Hierarchy and transforms

Set a parent at spawn with `parent=`, including for prepared layouts. A deferred child can name a pending parent
queued before it. If the parent is unavailable when the command runs, the
scheduler cancels the child and recycles its slot.

```moonbit
let room = commands.spawn(())
let player = commands.spawn(
  (@transform.Spatial(@transform.Transform::from_xyz(3.0, 4.0, 0.0)), velocity),
  parent=room,
)
```

`get_parent()` and `get_children()` read the hierarchy. Children are ordered by
spawn. `commands.despawn(entity)` and `commands.respawn(entity)` preserve the
subtree and its components. `commands.delete(entity)` invalidates its handles
and recycles its slots when the command is applied. Spawn a
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
of row tuples. Ordinary iteration constructs each logical row on demand;
for large hot loops, use typed columns to avoid forming a tuple for every row.
See [measured row and column costs](BENCHMARKS.md) for native and Node.js results.

```moonbit
moving.batches(batch => {
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

`batches` rejects immediate structural changes and schedule flushes inside its
callback. Queue spawns and deletions through `Commands`.

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

Application stages such as `Startup`, `Update`, and `FixedUpdate` belong to
`@app.Stage`. Reusable `Schedule`, `System`, `Condition`, and system-set ordering
belong to `ecs`:

```moonbit
let movement = @ecs.SystemSet("movement")
let animation = @ecs.SystemSet("animation")
app.add_system(Update, move_system, in_set=movement, before=[animation])
app.add_systems(Update, [
  @ecs.System(move_system),
  @ecs.System(@ecs.args2(remove_dead)),
])
```

A resource parameter uses the same `#selene.resource` declaration as World
resource access. Required resources must exist when the system executes;
optional parameters are fetched again each time and may become available later.
Cached `Res` handles observe resource replacements.

```moonbit
fn show_score(score : @ecs.Res[Score]) -> Unit {
  display_score(score.get().value)
}
fn advance_score(score : @ecs.Res[Score]) -> Unit {
  score.set(Score::{ value: score.get().value + 1 })
}
app.add_system(Update, show_score,
  run_if=@ecs.Condition(fn(score : @ecs.Res[Score]?) { score is Some(_) }))
```

Systems receive `Commands` directly. Outside a system, obtain the same deferred
queue with `@ecs.commands(world)`. `commands.draft()` and
`commands.prepare_spawn()` build World-bound spawn descriptions. Immediate
creation/deletion and bare command/lifecycle flushes are private to `ecs`.

Apps and custom loops use the same complete execution boundary:

```moonbit
let world = @ecs.World()
let schedule = @ecs.Schedule()
  .add_system(fn(commands : @ecs.Commands) {
    ignore(commands.spawn1(Position::{ x: 0.0, y: 0.0 }))
  })
  .add_system(move_entities)
try! schedule.run(world)
// Pending entities materialize only after all systems in this schedule.
```

`Schedule::run` selects its World, executes systems and conditions, applies one
frozen FIFO command batch, completes entity lifecycle changes, and restores the
previous active World. Commands added while applying that batch wait for the
next synchronization point. Nested execution, including for a different World,
and execution inside any query batch callback are rejected. App drivers check
these same conditions before changing platform or World state. Ordinary lazy
row iterators detect structural invalidation on their next advance.

`Schedule::chain([a, b])` snapshots ordered groups and flushes once at the end;
`Schedule::merge([a, b])` combines registrations into one system-set ordering
group. Both preserve existing registration state. `with_run_if(condition)` adds
a gate to each registration while preserving its state. `Condition::exclusive`
and `System::exclusive` explicitly declare callbacks that need a World.

The App synchronizes after Startup, after First/PreUpdate, after each complete
fixed step, after Update/PostUpdate/observer dispatch/Last, and after
RenderExtract/RenderPrepare/Render/RenderCleanup. There is no intermediate flush
within any of these groups. State transitions occur between PreUpdate and fixed
updates, with synchronization after exits and entries. See the
[state guide](../state/README.md) for initialization and lifecycle semantics.

Public ECS types remain owned by `ecs`; World storage and App runtime
registrations are private. Engine importers queue structural changes through
Commands as application code does. Public LDtk, Tiled, scene, audio, and
autotile creation requests are deferred. Tiled worlds queue their selected maps
when the root initializes, so those maps wait for the next synchronization
point under the same frozen-batch rule.

Timeouts belong to `time` and are stored in the active World. The default plugins
advance them once per frame. Cancellation remains valid when another World is
active. Timers scheduled by a callback become eligible on the next timer tick.

```moonbit
let handle = @time.timeout(0.5, () => finish_action())
ignore(handle.cancel())
```

Timeouts use scaled frame time by default. Pass `pausible=false` for unscaled
frame time. Systems can receive `@time.Timers` and schedule through
`timers.timeout(delay, callback)`. Custom loops use the same clock and schedule:

```moonbit
let time = @time.Time(world)
let timers = @ecs.Schedule().add_system(@ecs.args2(@time.timers_system))
time.begin_frame(raw_delta)
try! timers.run(world)
```

Constructors `Time(world)` and `Timers(world)` preserve existing state. The
free clock functions and `timeout(...)` select the active World for imperative
code.

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
