///|
fn main {
  let module_root = @env.current_dir().unwrap_or(".")
  @async.run_async_main(async fn() { @core.run_cli(module_root, @env.args()) })
}
