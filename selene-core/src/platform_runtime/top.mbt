///|
pub(all) struct WindowConfig {
  viewport_width : Double
  viewport_height : Double
  screen_width : Double
  screen_height : Double
  fps : UInt
  image_smooth : Bool
}

///|
pub(all) struct RunnerCallbacks {
  startup : () -> Unit
  service_frame : () -> Unit
  render_loop : (Double) -> Unit
  game_loop : (Double) -> Unit
}
