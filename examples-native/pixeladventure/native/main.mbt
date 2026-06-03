///|
fn main {
  @asset.set_io(fn(path) { @support.read_example_asset("pixeladventure", path) })
  @pixeladventure_game.run()
}
