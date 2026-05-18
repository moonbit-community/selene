///|
pub(all) enum TouchPlacement {
  BottomLeft
  BottomRight
  TopLeft
  TopRight
  Anchor(Double, Double, @math.Vec2)
} derive(Eq, Debug)

///|
pub(all) enum StickMode {
  Fixed
  Floating
} derive(Eq, Debug)

///|
pub(all) struct TouchControlStyle {
  base_color : @render.Color
  active_color : @render.Color
  knob_color : @render.Color
  label_color : @render.Color
}

///|
pub fn TouchControlStyle::TouchControlStyle(
  base_color? : @render.Color = rgba(35U, 42U, 54U, 0.36),
  active_color? : @render.Color = rgba(78U, 142U, 255U, 0.52),
  knob_color? : @render.Color = rgba(236U, 242U, 255U, 0.58),
  label_color? : @render.Color = rgba(255U, 255U, 255U, 0.84),
) -> TouchControlStyle {
  { base_color, active_color, knob_color, label_color }
}

///|
pub(all) struct VirtualStick {
  id : String
  axis_x : @inputs.VirtualAxis
  axis_y : @inputs.VirtualAxis
  placement : TouchPlacement
  radius : Double
  dead_zone : Double
  mode : StickMode
  style : TouchControlStyle
}

///|
pub fn VirtualStick::VirtualStick(
  id : String,
  axis_x : @inputs.VirtualAxis,
  axis_y : @inputs.VirtualAxis,
  placement? : TouchPlacement = BottomLeft,
  radius? : Double = 64.0,
  dead_zone? : Double = 10.0,
  mode? : StickMode = Floating,
  style? : TouchControlStyle = TouchControlStyle(),
) -> VirtualStick {
  { id, axis_x, axis_y, placement, radius, dead_zone, mode, style }
}

///|
pub(all) struct VirtualButtonControl {
  id : String
  button : @inputs.VirtualButton
  placement : TouchPlacement
  radius : Double
  label : String
  style : TouchControlStyle
}

///|
pub fn VirtualButtonControl::VirtualButtonControl(
  id : String,
  button : @inputs.VirtualButton,
  placement? : TouchPlacement = BottomRight,
  radius? : Double = 48.0,
  label? : String = "",
  style? : TouchControlStyle = TouchControlStyle(),
) -> VirtualButtonControl {
  { id, button, placement, radius, label, style }
}

///|
priv struct StickRuntime {
  mut touch_id : @inputs.TouchId?
  mut center : @math.Vec2
  mut value : @math.Vec2
}

///|
priv struct ButtonRuntime {
  mut touch_id : @inputs.TouchId?
  mut pressed : Bool
}

///|
priv struct TouchControlsWorldStore {
  sticks : Map[String, VirtualStick]
  buttons : Map[String, VirtualButtonControl]
  stick_runtimes : Map[String, StickRuntime]
  button_runtimes : Map[String, ButtonRuntime]
  mut enabled : Bool
  mut visible : Bool
}
