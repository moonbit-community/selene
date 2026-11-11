# States

States are World-owned values with deferred transitions. Keep ordinary game
data such as scores and level progress in resources; use states for phases
with entry, exit, or conditional system behavior.

## Declare and initialize

```moonbit
#derive(Eq)
#selene.state
enum GamePhase {
  Menu
  Playing
  Paused
}
```

Import `Milky2018/selene/state` as `@state`. The code generator supplies one
`StateKey[GamePhase]` and a `StateType` implementation. It does not generate
per-state transition algorithms or make the enum an ordinary Resource.
The key stores no World data; its resource storage resolves values per World.

```moonbit
let app = @app.App()
  .with_world(world)
  .init_state(GamePhase::Menu)
  .add_system(Update, update_game,
    run_if=@state.in_state(GamePhase::Playing))
  .add_on_enter(GamePhase::Playing, setup_level)
  .add_on_exit(GamePhase::Playing, cleanup_level)
```

Initialize after selecting the App's World. Repeated initialization preserves
the existing current value and pending request. Initialization can also happen
in Startup through `@state.initialize(world, initial)`.

## Read and request transitions

```moonbit
fn start_game(world : @ecs.World) -> Unit {
  let phase : GamePhase = @state.current(world)
  if phase == Menu {
    @state.set_next(world, GamePhase::Playing)
  }
}
```

Reading, requesting, or testing an uninitialized state aborts with a configuration
error. Conditions have the same `(World) -> Bool` shape as `run_if`; they read
the executing World's value rather than capturing a particular World.
Each World and each declared state type have independent values.

## Transition timing

After Startup and its command flush, the App dispatches initial entries once
per World. Requests from Startup or initial entry remain pending until the
first ordinary transition point.

Each frame executes `First`, `PreUpdate`, a command flush, the state transition
point, the fixed-update loop, and then ordinary updates. A transition snapshots
all current requests, runs exits, flushes exit commands, commits all new values,
runs entries, and flushes entry commands. All exits see old values and all
entries see committed values, including when several state types change.
Lifecycle systems run in registration order within the exit or entry phase.

The last request before a transition point wins. Requests equal to the current
value do not trigger exits or entries. Requests made by lifecycle callbacks
are retained for the next point; transitions do not recurse. Requests during
Update or a fixed step therefore apply at a later transition point.
`App::step_fixed` also applies pending transitions before its fixed-step batch.

Lifecycle commands follow the ECS's one-batch flush rule. Commands queued by
another command wait for the next synchronization point.

## Integration

Applications use `init_state`, `add_on_enter`, and `add_on_exit`. A custom loop
can call `@state.advance(world, on_exit=..., on_enter=...)`, using `is_exiting`
and `is_entering` to match the frozen transition. These predicates are meaningful
only during lifecycle dispatch. Nested transitions and query-time execution
are rejected by the ECS schedule protections.
