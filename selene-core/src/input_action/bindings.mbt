///|
pub(all) enum InputBinding {
  Key(@inputs.Code)
  Mouse(@inputs.MouseButton)
  PointerPrimary
  VirtualButton(@inputs.VirtualButton)
  VirtualAxis(
    @inputs.VirtualAxis,
    mut dead_zone~ : Double,
    mut positive~ : Bool
  )
  GamepadButton(@inputs.Gamepad, @inputs.GamepadButton)
  GamepadAxis(
    @inputs.Gamepad,
    @inputs.GamepadAxis,
    mut dead_zone~ : Double,
    mut positive~ : Bool
  )
}

///|
let input_bindings : Map[InputAction, Array[InputBinding]] = Map([])

///|
pub fn bind_action(action : InputAction, binding : InputBinding) -> Unit {
  let bindings = input_bindings.get(action).unwrap_or([])
  bindings.push(binding)
  input_bindings.set(action, bindings)
  if !action_states.contains(action) {
    action_states.set(action, {
      pressed: false,
      just_pressed: false,
      just_released: false,
      value: 0.0,
    })
  }
}

///|
pub fn clear_action_bindings(action : InputAction) -> Unit {
  input_bindings.remove(action)
  action_states.remove(action)
}

///|
pub fn clear_all_action_bindings() -> Unit {
  input_bindings.clear()
  action_states.clear()
}

///|
fn binding_value(binding : InputBinding) -> Double {
  match binding {
    Key(code) => if @inputs.is_pressed(code) { 1.0 } else { 0.0 }
    Mouse(button) => if @inputs.is_mouse_pressed(button) { 1.0 } else { 0.0 }
    PointerPrimary => if @inputs.primary_pointer_down() { 1.0 } else { 0.0 }
    VirtualButton(button) =>
      if @inputs.is_virtual_button_pressed(button) {
        1.0
      } else {
        0.0
      }
    VirtualAxis(axis, dead_zone~, positive~) =>
      axis_value_with_dead_zone(
        @inputs.virtual_axis_value(axis),
        dead_zone,
        positive,
      )
    GamepadButton(gamepad, button) =>
      if @inputs.is_gamepad_button_pressed(gamepad, button) {
        1.0
      } else {
        0.0
      }
    GamepadAxis(gamepad, axis, dead_zone~, positive~) =>
      axis_value_with_dead_zone(
        @inputs.gamepad_axis_value(gamepad, axis),
        dead_zone,
        positive,
      )
  }
}

///|
fn axis_value_with_dead_zone(
  axis_value : Double,
  dead_zone : Double,
  positive : Bool,
) -> Double {
  let dead_zone = @cmp.minimum(1.0, @cmp.maximum(0.0, dead_zone))
  let absolute = if axis_value < 0.0 { -axis_value } else { axis_value }
  let filtered = if absolute <= dead_zone { 0.0 } else { axis_value }
  if positive {
    @cmp.maximum(0.0, filtered)
  } else {
    @cmp.maximum(0.0, -filtered)
  }
}
