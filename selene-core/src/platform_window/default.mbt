///|
pub fn initialize(
  config : @platform_runtime.WindowConfig,
  callbacks : @platform_runtime.RunnerCallbacks,
) -> () -> Unit {
  ignore(callbacks.startup)
  ignore(callbacks.render_loop)
  ignore(callbacks.game_loop)
  ignore(config.viewport_width)
  ignore(config.viewport_height)
  ignore(config.screen_width)
  ignore(config.screen_height)
  ignore(config.fps)
  ignore(config.image_smooth)
  fn() {  }
}

///|
pub fn request_close() -> Unit {

}
