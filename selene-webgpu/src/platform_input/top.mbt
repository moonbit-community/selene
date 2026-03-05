///|
let snapshot : @inputs.InputSnapshot = @inputs.empty_input_snapshot()

///|
let registered : Ref[Bool] = Ref::new(false)

///|
let mouse_lock_ref : Ref[Bool] = Ref::new(false)

///|
let mouse_lock_registered : Ref[Bool] = Ref::new(false)

///|
fn[T : Hash + Eq] copy_set(src : Set[T]) -> Set[T] {
  let out = Set::new()
  for item in src {
    out.add(item)
  }
  out
}

///|
fn[K : Hash + Eq, V] copy_map(src : Map[K, V]) -> Map[K, V] {
  let out = Map::new()
  for key, value in src {
    out.set(key, value)
  }
  out
}

///|
fn ensure_registered() -> Unit {
  if registered.val {
    return
  }
  @impl.register_key_events(snapshot.pressed_keys)
  @impl.register_mouse_events(snapshot.mouse, snapshot.mouse_movement)
  @impl.register_gamepad_events(
    snapshot.connected_gamepads,
    snapshot.pressed_gamepad_buttons,
    snapshot.gamepad_axis_values,
  )
  registered.val = true
}

///|
pub fn poll_input() -> @inputs.InputSnapshot {
  ensure_registered()
  {
    pressed_keys: copy_set(snapshot.pressed_keys),
    mouse: {
      pos: snapshot.mouse.pos,
      left_button: snapshot.mouse.left_button,
      right_button: snapshot.mouse.right_button,
      middle_button: snapshot.mouse.middle_button,
    },
    mouse_movement: { movement: snapshot.mouse_movement.movement },
    connected_gamepads: copy_set(snapshot.connected_gamepads),
    pressed_gamepad_buttons: copy_set(snapshot.pressed_gamepad_buttons),
    gamepad_axis_values: copy_map(snapshot.gamepad_axis_values),
  }
}

///|
pub fn set_mouse_lock(locked : Bool) -> Bool {
  if !mouse_lock_registered.val {
    @impl.lock_mouse(mouse_lock_ref)
    mouse_lock_registered.val = true
  }
  mouse_lock_ref.val = locked
  mouse_lock_ref.val = @impl.sync_mouse_lock_state(mouse_lock_ref.val)
  mouse_lock_ref.val
}
