///|
fn default_deterministic_mode() -> DeterministicModeConfig {
  {
    rng_seed: 0U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: true,
  }
}

///|
pub fn set_deterministic_mode(config : DeterministicModeConfig) -> Unit {
  let world_id = current_world_id()
  deterministic_mode_by_world.set(world_id, config)
  rng_state_by_world.set(world_id, config.rng_seed)
}

///|
pub fn deterministic_mode() -> DeterministicModeConfig {
  deterministic_mode_by_world.get_or_init(
    current_world_id(),
    default_deterministic_mode,
  )
}

///|
pub fn clear_deterministic_mode() -> Unit {
  let world_id = current_world_id()
  deterministic_mode_by_world.remove(world_id)
  rng_state_by_world.remove(world_id)
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
  atlas_overlay_enabled_by_world.set(current_world_id(), enabled)
}

///|
pub fn atlas_overlay_enabled() -> Bool {
  atlas_overlay_enabled_by_world.get(current_world_id()).unwrap_or(false)
}

///|
pub fn set_rng_seed(seed : UInt) -> Unit {
  let world_id = current_world_id()
  let mode = deterministic_mode()
  deterministic_mode_by_world.set(world_id, { ..mode, rng_seed: seed })
  rng_state_by_world.set(world_id, seed)
}

///|
pub fn rng_seed() -> UInt {
  deterministic_mode().rng_seed
}

///|
pub fn next_deterministic_u32() -> UInt {
  let world_id = current_world_id()
  let mut x = rng_state_by_world.get_or_init(world_id, () => {
    deterministic_mode().rng_seed
  })
  if x == 0U {
    x = 0x6C8E9CF5U
  }
  x = x ^ (x << 13)
  x = x ^ (x >> 17)
  x = x ^ (x << 5)
  rng_state_by_world.set(world_id, x)
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
fn copy_snapshot(snapshot : @inputs.InputSnapshot) -> @inputs.InputSnapshot {
  {
    pressed_keys: copy_set(snapshot.pressed_keys),
    mouse: {
      pos: snapshot.mouse.pos,
      left_button: snapshot.mouse.left_button,
      right_button: snapshot.mouse.right_button,
      middle_button: snapshot.mouse.middle_button,
    },
    mouse_movement: { movement: snapshot.mouse_movement.movement },
    mouse_wheel: { delta: snapshot.mouse_wheel.delta },
    connected_gamepads: copy_set(snapshot.connected_gamepads),
    pressed_gamepad_buttons: copy_set(snapshot.pressed_gamepad_buttons),
    gamepad_axis_values: copy_map(snapshot.gamepad_axis_values),
  }
}

///|
fn staged_snapshot() -> @inputs.InputSnapshot {
  staged_input_by_world.get_or_init(
    current_world_id(),
    @inputs.empty_input_snapshot,
  )
}

///|
fn queued_inputs() -> Array[@inputs.InputSnapshot] {
  queued_inputs_by_world.get_or_init(current_world_id(), () => [])
}

///|
pub fn queue_input_snapshot(snapshot : @inputs.InputSnapshot) -> Unit {
  queued_inputs().push(copy_snapshot(snapshot))
}

///|
pub fn queued_input_count() -> Int {
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
      staged.mouse_movement.movement = position - staged.mouse.pos
      staged.mouse.pos = position
    }
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
  queued_inputs_by_world.set(current_world_id(), tail)
  copy_snapshot(head)
}
