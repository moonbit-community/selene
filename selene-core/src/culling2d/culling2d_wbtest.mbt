///|
test "spatial grid query returns deterministic ids from overlapping cells" {
  let grid = SpatialGrid2d(
    [
      { id: 5U, bounds: { position: Vec2(0.0, 0.0), size: Vec2(16.0, 16.0), }, },
      {
        id: 2U,
        bounds: { position: Vec2(20.0, 0.0), size: Vec2(16.0, 16.0), },
      },
      {
        id: 9U,
        bounds: { position: Vec2(400.0, 0.0), size: Vec2(16.0, 16.0), },
      },
    ],
    cell_size=32.0,
  )
  let ids = grid.query({ position: Vec2(0.0, 0.0), size: Vec2(40.0, 32.0), })
  inspect(ids.length(), content="2")
  inspect(ids[0], content="2")
  inspect(ids[1], content="5")
}

///|
test "integer grid keys distinguish negative and positive coordinates" {
  let grid = SpatialGrid2d(
    [
      {
        id: 3U,
        bounds: { position: Vec2(-48.0, -48.0), size: Vec2(8.0, 8.0), },
      },
      {
        id: 1U,
        bounds: { position: Vec2(40.0, -48.0), size: Vec2(8.0, 8.0), },
      },
      {
        id: 2U,
        bounds: { position: Vec2(-48.0, 40.0), size: Vec2(8.0, 8.0), },
      },
    ],
    cell_size=16.0,
  )
  debug_inspect(
    grid.query({ position: Vec2(-48.0, -48.0), size: Vec2(8.0, 8.0), }),
    content="[3]",
  )
  debug_inspect(
    grid.query({ position: Vec2(-64.0, -64.0), size: Vec2(128.0, 128.0), }),
    content="[1, 2, 3]",
  )
}
