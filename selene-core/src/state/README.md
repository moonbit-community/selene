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
`StateKey[GamePhase]`, a `StateType` implementation, and an `extend` attaching
the trait's shared `set` method. It does not generate per-state transition
algorithms or make the enum an ordinary Resource.
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
fn start_game(
  phase : @state.State[GamePhase],
  next : @state.NextState[GamePhase],
) -> Unit {
  if phase.get() == Menu {
    next.set(Playing)
  }
}
app.add_system(Update, @ecs.args2(start_game))
```

`GamePhase::set(value)` uses the active World selected by the scheduler and
requests a deferred transition. It requires an active World. For explicit setup,
tests, or cross-World work, use `@state.set_next(world, GamePhase::Playing)`.
No implicit World is captured by a state declaration or its generated key.

Reading, requesting, or testing an uninitialized state aborts with a configuration
error. `in_state` returns an `@ecs.Condition` using the injected `State[T]`.
Custom conditions use `Condition(predicate)` and the same `SystemParam` protocol
as ordinary systems; they read the executing World's value.
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

Applications use `init_state`, `add_on_enter`, and `add_on_exit`. Lifecycle
callbacks accept the same injected parameters and `argsN` adapters as ordinary
systems. `State[T]::get()` reads the current phase; `NextState[T]::set(value)`
queues its next value. `State::is_entering` and `is_exiting` inspect the frozen
transition only during lifecycle dispatch. Callbacks that need the whole World
use `add_exclusive_on_enter` or `add_exclusive_on_exit` explicitly.

Transition execution is internal to the App. The public ECS `Schedule::run`
executes complete ordinary schedules; it does not advance state transitions.
