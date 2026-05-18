///|
let touch_control_stores : Map[UInt, TouchControlsWorldStore] = Map([])

///|
fn store() -> TouchControlsWorldStore {
  let world_id = @ecs.require_current_world().id()
  touch_control_stores.get_or_init(world_id, fn() {
    {
      sticks: Map([]),
      buttons: Map([]),
      stick_runtimes: Map([]),
      button_runtimes: Map([]),
      enabled: true,
      visible: true,
    }
  })
}

///|
pub fn set_enabled(enabled : Bool) -> Unit {
  store().enabled = enabled
}

///|
pub fn is_enabled() -> Bool {
  store().enabled
}

///|
pub fn set_visible(visible : Bool) -> Unit {
  store().visible = visible
}

///|
pub fn is_visible() -> Bool {
  store().visible
}

///|
pub fn add_virtual_stick_control(stick : VirtualStick) -> Unit {
  let runtime = store()
  runtime.sticks.set(stick.id, stick)
  ignore(
    runtime.stick_runtimes.get_or_init(stick.id, fn() {
      {
        touch_id: None,
        center: resolved_placement(
          stick.placement,
          @system.get_screen_size(),
          stick.radius,
        ),
        value: @math.Vec2::zero(),
      }
    }),
  )
}

///|
pub fn add_virtual_button_control(button : VirtualButtonControl) -> Unit {
  let runtime = store()
  runtime.buttons.set(button.id, button)
  ignore(
    runtime.button_runtimes.get_or_init(button.id, fn() {
      { touch_id: None, pressed: false }
    }),
  )
}

///|
pub fn clear_controls() -> Unit {
  let runtime = store()
  release_outputs(runtime)
  runtime.sticks.clear()
  runtime.buttons.clear()
  runtime.stick_runtimes.clear()
  runtime.button_runtimes.clear()
}

///|
pub fn spawn_mobile_platformer_controls(
  move_left_button : @inputs.VirtualButton,
  move_right_button : @inputs.VirtualButton,
  jump_button : @inputs.VirtualButton,
  left_label? : String = "",
  right_label? : String = "",
  jump_label? : String = "JUMP",
) -> Unit {
  clear_controls()
  add_virtual_button_control(
    VirtualButtonControl(
      "move-left",
      move_left_button,
      placement=Anchor(0.18, 0.82, @math.Vec2::zero()),
      radius=42.0,
      label=left_label,
    ),
  )
  add_virtual_button_control(
    VirtualButtonControl(
      "move-right",
      move_right_button,
      placement=Anchor(0.36, 0.82, @math.Vec2::zero()),
      radius=42.0,
      label=right_label,
    ),
  )
  add_virtual_button_control(
    VirtualButtonControl(
      "jump",
      jump_button,
      placement=Anchor(0.82, 0.82, @math.Vec2::zero()),
      radius=48.0,
      label=jump_label,
    ),
  )
}

///|
pub fn spawn_twin_stick_controls(
  move_x : @inputs.VirtualAxis,
  move_y : @inputs.VirtualAxis,
) -> Unit {
  clear_controls()
  add_virtual_stick_control(
    VirtualStick(
      "move",
      move_x,
      move_y,
      placement=BottomLeft,
      radius=68.0,
      dead_zone=10.0,
      mode=Floating,
    ),
  )
}
