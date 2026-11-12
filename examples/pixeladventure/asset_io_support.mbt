///|
pub fn with_pixeladventure_test_asset_io(
  action : () -> Unit raise,
) -> Unit raise {
  @asset.set_io(@embedded_assets.read, paths=@embedded_assets.paths())
  defer @asset.set_io(fn(_path) { None })
  action()
}
