///|
pub fn initialize(
  config : @runtime.WindowConfig,
  callbacks : @runtime.RunnerCallbacks,
) -> () -> Unit {
  @impl.initialize(config, callbacks)
}

///|
pub fn request_close() -> Unit {
  @impl.request_close()
}
