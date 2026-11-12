///|
test "collections own handles and asset identity is independent of value" {
  let first : @asset_types.Assets[Int32] = Assets()
  let second : @asset_types.Assets[Int32] = Assets()
  let a = first.add(42)
  let b = first.add(42)
  let c = second.add(42)
  assert_true(a != b && a != c)
  assert_eq(first.get(a), Some(42))
  assert_eq(second.get(a), None)
  assert_false(second.insert(a, 7))
  assert_eq(second.remove(a), None)
  let handles = Map([(a, "a"), (b, "b"), (c, "c")])
  assert_true(first.insert(a, 99))
  assert_eq(handles.get(a), Some("a"))
  assert_eq(first.get(a), Some(99))
}

///|
test "removal invalidates all copies and cannot resurrect a stale handle" {
  let assets : @asset_types.Assets[String] = Assets()
  let handle = assets.add("old")
  let copy = handle
  assert_eq(assets.remove(handle), Some("old"))
  assert_eq(copy.get(), None)
  assert_false(copy.is_alive())
  assert_false(assets.insert(copy, "new"))
  assert_eq(assets.remove(copy), None)
  let next = assets.add("new")
  assert_true(next != copy)
  assert_eq(assets.length(), 1)
}

///|
test "reserved identities can be fulfilled and invalidation callbacks run once" {
  let assets : @asset_types.Assets[Int32] = Assets()
  let handle = assets.reserve()
  assert_true(handle.is_alive())
  assert_eq(handle.get(), None)
  let invalidations = Ref(0)
  handle.on_invalidate(fn() { invalidations.val += 1 })
  assert_true(assets.insert(handle, 1))
  assert_true(assets.insert(handle, 2))
  assert_eq(invalidations.val, 1)
  handle.on_invalidate(fn() { invalidations.val += 1 })
  assert_eq(assets.remove(handle), Some(2))
  assert_eq(invalidations.val, 2)
}

///|
test "resource constructors preserve encoded data without backend preparation" {
  let images : @asset_types.Assets[@asset_types.Image] = Assets()
  let image = images.add(@asset_types.Image::from_bytes(b"encoded image"))
  assert_eq(images.get(image).unwrap().bytes, b"encoded image")
  let fonts : @asset_types.Assets[@asset_types.Font] = Assets()
  let font = fonts.add(@asset_types.Font::from_bytes(b"encoded font"))
  assert_eq(font.get().unwrap().bytes, b"encoded font")
}
