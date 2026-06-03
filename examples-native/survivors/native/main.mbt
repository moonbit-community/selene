///|
fn main {
  @asset.set_io(fn(path) { @support.read_example_asset("survivors", path) })
  @survivors_game.run()
}
