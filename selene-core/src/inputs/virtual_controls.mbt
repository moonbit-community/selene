///|
pub(all) struct VirtualButton {
  name : String
} derive(Eq, Hash, Debug)

///|
pub fn VirtualButton::VirtualButton(name : String) -> VirtualButton {
  { name, }
}

///|
pub fn VirtualButton::name(self : VirtualButton) -> String {
  self.name
}

///|
pub(all) struct VirtualAxis {
  name : String
} derive(Eq, Hash, Debug)

///|
pub fn VirtualAxis::VirtualAxis(name : String) -> VirtualAxis {
  { name, }
}

///|
pub fn VirtualAxis::name(self : VirtualAxis) -> String {
  self.name
}

///|
pub(all) enum VirtualButtonInputState {
  Pressed
  Released
} derive(Eq, Debug)

///|
pub(all) struct VirtualButtonEvent {
  button : VirtualButton
  state : VirtualButtonInputState
}

///|
pub(all) struct VirtualAxisEvent {
  axis : VirtualAxis
  value : Double
  delta : Double
}

///|
let pressed_virtual_buttons : Set[VirtualButton] = Set([])

///|
let virtual_axis_values : Map[VirtualAxis, Double] = Map([])

///|
pub let virtual_button_event_bus : @event.Events[VirtualButtonEvent] = Events()

///|
pub let virtual_axis_event_bus : @event.Events[VirtualAxisEvent] = Events()

///|
pub fn is_virtual_button_pressed(button : VirtualButton) -> Bool {
  pressed_virtual_buttons.contains(button)
}

///|
pub fn virtual_axis_value(axis : VirtualAxis) -> Double {
  virtual_axis_values.get(axis).unwrap_or(0.0)
}

///|
pub fn set_virtual_button_pressed(
  button : VirtualButton,
  pressed : Bool,
) -> Unit {
  let was_pressed = pressed_virtual_buttons.contains(button)
  if pressed == was_pressed {
    return
  }
  if pressed {
    pressed_virtual_buttons.add(button)
    virtual_button_event_bus.send({ button, state: Pressed })
  } else {
    pressed_virtual_buttons.remove(button)
    virtual_button_event_bus.send({ button, state: Released })
  }
}

///|
pub fn set_virtual_axis_value(axis : VirtualAxis, value : Double) -> Unit {
  let previous = virtual_axis_values.get(axis).unwrap_or(0.0)
  let delta = value - previous
  if delta > -0.000001 && delta < 0.000001 {
    return
  }
  if value > -0.000001 && value < 0.000001 {
    virtual_axis_values.remove(axis)
  } else {
    virtual_axis_values.set(axis, value)
  }
  virtual_axis_event_bus.send({ axis, value, delta })
}

///|
pub fn clear_virtual_controls() -> Unit {
  pressed_virtual_buttons.clear()
  virtual_axis_values.clear()
}
