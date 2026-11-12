///|
pub(all) struct DeterministicModeConfig {
  rng_seed : UInt32
  fixed_delta_override : Double?
  frame_delta_override : Double?
  deterministic_ordering : Bool
}

///|
pub(all) enum InputInjectionEvent {
  KeyDown(@inputs.Code)
  KeyUp(@inputs.Code)
  MouseMove(@math.Vec2)
  MouseDelta(@math.Vec2)
  MouseWheel(@math.Vec2)
  MouseLeft(Bool)
  MouseRight(Bool)
  MouseMiddle(Bool)
  GamepadConnected(@inputs.Gamepad, Bool)
  GamepadButton(@inputs.GamepadButtonInput, Bool)
  GamepadAxis(@inputs.GamepadAxisInput, Double)
}

///|
let deterministic_mode_key : @ecs.ResourceKey[DeterministicModeConfig] = ResourceKey()

///|
let rng_state_key : @ecs.ResourceKey[UInt32] = ResourceKey()

///|
let queued_inputs_key : @ecs.ResourceKey[Array[@inputs.InputSnapshot]] = ResourceKey()

///|
let staged_input_key : @ecs.ResourceKey[@inputs.InputSnapshot] = ResourceKey()

///|
fn DeterministicModeConfig::DeterministicModeConfig() -> DeterministicModeConfig {
  {
    rng_seed: 0U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: true,
  }
}

///|
pub fn set_deterministic_mode(config : DeterministicModeConfig) -> Unit {
  deterministic_mode_key.insert_in(current_world(), config)
  rng_state_key.insert_in(current_world(), config.rng_seed)
}

///|
pub fn deterministic_mode() -> DeterministicModeConfig {
  deterministic_mode_key.get_or_insert_with(current_world(), _ => {
    DeterministicModeConfig()
  })
}

///|
pub fn clear_deterministic_mode() -> Unit {
  deterministic_mode_key.insert_in(current_world(), DeterministicModeConfig())
  rng_state_key.insert_in(current_world(), 0U)
}

///|
pub fn frame_delta_override() -> Double? {
  deterministic_mode().frame_delta_override
}

///|
pub fn fixed_delta_override() -> Double? {
  deterministic_mode().fixed_delta_override
}

///|
pub fn deterministic_ordering_enabled() -> Bool {
  deterministic_mode().deterministic_ordering
}

///|
pub fn set_atlas_overlay_enabled(enabled : Bool) -> Unit {
  atlas_overlay_enabled_key.insert_in(current_world(), enabled)
}

///|
pub fn atlas_overlay_enabled() -> Bool {
  atlas_overlay_enabled_key.get_in(current_world()).unwrap_or(false)
}

///|
pub fn set_rng_seed(seed : UInt32) -> Unit {
  let mode = deterministic_mode()
  deterministic_mode_key.insert_in(current_world(), { ..mode, rng_seed: seed, })
  rng_state_key.insert_in(current_world(), seed)
}

///|
pub fn rng_seed() -> UInt32 {
  deterministic_mode().rng_seed
}

///|
pub fn next_deterministic_u32() -> UInt32 {
  let mut x = rng_state_key.get_or_insert_with(current_world(), _ => {
    deterministic_mode().rng_seed
  })
  if x == 0U {
    x = 0x6C8E9CF5U
  }
  x = x ^ (x << 13)
  x = x ^ (x >> 17)
  x = x ^ (x << 5)
  rng_state_key.insert_in(current_world(), x)
  x
}

///|
pub fn next_deterministic_f64() -> Double {
  let value = next_deterministic_u32()
  value.reinterpret_as_int().to_double() / 4294967295.0
}

///|
fn[T : Hash + Eq] copy_set(source : Set[T]) -> Set[T] {
  let out = Set([])
  for item in source {
    out.add(item)
  }
  out
}

///|
fn[K : Hash + Eq, V] copy_map(source : Map[K, V]) -> Map[K, V] {
  let out = Map([])
  for key, value in source {
    out.set(key, value)
  }
  out
}

///|
fn[T] copy_array(source : Array[T]) -> Array[T] {
  let out : Array[T] = []
  for item in source {
    out.push(item)
  }
  out
}

///|
fn copy_snapshot(snapshot : @inputs.InputSnapshot) -> @inputs.InputSnapshot {
  {
    pressed_keys: copy_set(snapshot.pressed_keys),
    mouse: {
      pos: snapshot.mouse.pos,
      left_button: snapshot.mouse.left_button,
      right_button: snapshot.mouse.right_button,
      middle_button: snapshot.mouse.middle_button,
    },
    mouse_relative_delta: snapshot.mouse_relative_delta,
    mouse_wheel: { delta: snapshot.mouse_wheel.delta, },
    touches: copy_map(snapshot.touches),
    touch_changes: copy_array(snapshot.touch_changes),
    connected_gamepads: copy_set(snapshot.connected_gamepads),
    pressed_gamepad_buttons: copy_set(snapshot.pressed_gamepad_buttons),
    gamepad_axis_values: copy_map(snapshot.gamepad_axis_values),
  }
}

///|
fn staged_snapshot() -> @inputs.InputSnapshot {
  staged_input_key.get_or_insert_with(current_world(), _ => InputSnapshot())
}

///|
fn queued_inputs() -> Array[@inputs.InputSnapshot] {
  queued_inputs_key.get_or_insert_with(current_world(), _ => [])
}

///|
pub fn queue_input_snapshot(snapshot : @inputs.InputSnapshot) -> Unit {
  queued_inputs().push(copy_snapshot(snapshot))
}

///|
pub fn queued_input_count() -> Int32 {
  queued_inputs().length()
}

///|
pub fn clear_queued_inputs() -> Unit {
  queued_inputs().clear()
}

///|
pub fn queue_input_event(event : InputInjectionEvent) -> Unit {
  let staged = staged_snapshot()
  match event {
    KeyDown(code) => staged.pressed_keys.add(code)
    KeyUp(code) => staged.pressed_keys.remove(code)
    MouseMove(position) => {
      staged.mouse_relative_delta = None
      staged.mouse.pos = position
    }
    MouseDelta(delta) => staged.mouse_relative_delta = Some(delta)
    MouseWheel(delta) => staged.mouse_wheel.delta = delta
    MouseLeft(pressed) => staged.mouse.left_button = pressed
    MouseRight(pressed) => staged.mouse.right_button = pressed
    MouseMiddle(pressed) => staged.mouse.middle_button = pressed
    GamepadConnected(gamepad, connected) =>
      if connected {
        staged.connected_gamepads.add(gamepad)
      } else {
        staged.connected_gamepads.remove(gamepad)
      }
    GamepadButton(button, pressed) =>
      if pressed {
        staged.pressed_gamepad_buttons.add(button)
      } else {
        staged.pressed_gamepad_buttons.remove(button)
      }
    GamepadAxis(axis, value) => staged.gamepad_axis_values.set(axis, value)
  }
  queue_input_snapshot(staged)
}

///|
pub fn consume_injected_input_or(
  poller : () -> @inputs.InputSnapshot,
) -> @inputs.InputSnapshot {
  let queue = queued_inputs()
  if queue.is_empty() {
    return poller()
  }
  let head = queue[0]
  let tail : Array[@inputs.InputSnapshot] = []
  for index in 1..<queue.length() {
    tail.push(queue[index])
  }
  queued_inputs_key.insert_in(current_world(), tail)
  copy_snapshot(head)
}
