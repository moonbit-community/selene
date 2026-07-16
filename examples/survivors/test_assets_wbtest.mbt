///|
fn use_survivors_test_assets() -> Unit {
  @asset.set_io(fn(_path) { Some(Bytes::from_array([1U.to_byte()])) })
}
