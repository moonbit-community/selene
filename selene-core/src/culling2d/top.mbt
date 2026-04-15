///|
pub(all) struct SpatialGridEntry2d {
  id : UInt
  bounds : @math.Rect
}

///|
pub(all) struct SpatialGrid2d {
  cell_size : Double
  buckets : Map[String, Array[UInt]]
}

///|
fn effective_cell_size(cell_size : Double) -> Double {
  if cell_size < 1.0 { 1.0 } else { cell_size }
}

///|
fn cell_index(value : Double, cell_size : Double) -> Int {
  (value / cell_size).floor().to_int()
}

///|
fn rect_cell_bounds(
  rect : @math.Rect,
  cell_size : Double,
) -> (Int, Int, Int, Int) {
  let min_x = cell_index(rect.position[X], cell_size)
  let min_y = cell_index(rect.position[Y], cell_size)
  let max_x = cell_index(rect.position[X] + rect.size[X], cell_size)
  let max_y = cell_index(rect.position[Y] + rect.size[Y], cell_size)
  (min_x, min_y, max_x, max_y)
}

///|
fn bucket_key(x : Int, y : Int) -> String {
  x.to_string() + ":" + y.to_string()
}

///|
pub fn build_spatial_grid2d(
  entries : Array[SpatialGridEntry2d],
  cell_size? : Double = 256.0,
) -> SpatialGrid2d {
  let effective_size = effective_cell_size(cell_size)
  let buckets : Map[String, Array[UInt]] = Map::new()
  for entry in entries {
    let bounds = entry.bounds
    guard bounds.size[X] > 0.0 && bounds.size[Y] > 0.0 else { continue }
    let (min_x, min_y, max_x, max_y) = rect_cell_bounds(bounds, effective_size)
    for x in min_x..<(max_x + 1) {
      for y in min_y..<(max_y + 1) {
        buckets.get_or_init(bucket_key(x, y), fn() { [] }).push(entry.id)
      }
    }
  }
  { cell_size: effective_size, buckets }
}

///|
pub fn SpatialGrid2d::query(self : SpatialGrid2d, region : @math.Rect) -> Array[UInt] {
  if region.size[X] <= 0.0 || region.size[Y] <= 0.0 {
    return []
  }
  let unique : @set.Set[UInt] = @set.Set::new()
  let (min_x, min_y, max_x, max_y) = rect_cell_bounds(region, self.cell_size)
  for x in min_x..<(max_x + 1) {
    for y in min_y..<(max_y + 1) {
      match self.buckets.get(bucket_key(x, y)) {
        Some(ids) => {
          for id in ids {
            unique.add(id)
          }
        }
        None => ()
      }
    }
  }
  let sorted = unique.to_array()
  sorted.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
  sorted
}

///|
test "spatial grid query returns deterministic ids from overlapping cells" {
  let grid = build_spatial_grid2d([
    { id: 5U, bounds: { position: @math.Vec2(0.0, 0.0), size: @math.Vec2(16.0, 16.0) } },
    { id: 2U, bounds: { position: @math.Vec2(20.0, 0.0), size: @math.Vec2(16.0, 16.0) } },
    { id: 9U, bounds: { position: @math.Vec2(400.0, 0.0), size: @math.Vec2(16.0, 16.0) } },
  ], cell_size=32.0)
  inspect(
    grid.query({ position: @math.Vec2(0.0, 0.0), size: @math.Vec2(40.0, 32.0) }),
    content="[2, 5]",
  )
}
