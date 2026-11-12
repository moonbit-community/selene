///|
#derive(Eq, Debug, Hash)
pub(all) struct InputAction {
  name : String
}

///|
pub extend InputAction with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend InputAction with Eq::{not_equal, equal}

///|
pub extend InputAction with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
pub(all) struct ActionState {
  mut pressed : Bool
  mut just_pressed : Bool
  mut just_released : Bool
  mut value : Double
}

///|
pub extend ActionState with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionState with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum ActionEventKind {
  Pressed
  Released
  ValueChanged
}

///|
pub extend ActionEventKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionEventKind with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct ActionEvent {
  action : InputAction
  kind : ActionEventKind
  value : Double
}

///|
pub extend ActionEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ActionEvent with Eq::{not_equal, equal}

///|
let action_states : Map[InputAction, ActionState] = Map([])

///|
pub let input_action_event_bus : @event.Events[ActionEvent] = Events()

///|
pub fn InputAction::InputAction(name : String) -> InputAction {
  { name, }
}

///|
pub fn action_pressed(action : InputAction) -> Bool {
  action_states.get(action).map(fn(state) { state.pressed }).unwrap_or(false)
}

///|
pub fn action_just_pressed(action : InputAction) -> Bool {
  action_states
  .get(action)
  .map(fn(state) { state.just_pressed })
  .unwrap_or(false)
}

///|
pub fn action_just_released(action : InputAction) -> Bool {
  action_states
  .get(action)
  .map(fn(state) { state.just_released })
  .unwrap_or(false)
}

///|
pub fn action_value(action : InputAction) -> Double {
  action_states.get(action).map(fn(state) { state.value }).unwrap_or(0.0)
}

///|
pub fn input_action_system() -> Unit {
  for action, bindings in input_bindings {
    let previous = action_states
      .get(action)
      .unwrap_or({
        pressed: false,
        just_pressed: false,
        just_released: false,
        value: 0.0,
      })
    let mut value = 0.0
    for binding in bindings {
      value = @cmp.maximum(value, binding_value(binding))
    }
    let pressed = value > 0.0
    let just_pressed = pressed && !previous.pressed
    let just_released = !pressed && previous.pressed
    let next_state : ActionState = {
      pressed,
      just_pressed,
      just_released,
      value,
    }
    action_states.set(action, next_state)
    if just_pressed {
      input_action_event_bus.send({ action, kind: Pressed, value, })
    }
    if just_released {
      input_action_event_bus.send({ action, kind: Released, value, })
    }
    let delta = value - previous.value
    let absolute_delta = if delta < 0.0 { -delta } else { delta }
    if absolute_delta > 0.000001 {
      input_action_event_bus.send({ action, kind: ValueChanged, value, })
    }
  }
}
