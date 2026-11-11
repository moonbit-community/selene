///|
pub(all) struct SpatialGridEntry2d {
  id : UInt32
  bounds : @math.Rect
}

///|
pub(all) struct SpatialGrid2d {
  cell_size : Double
  buckets : Map[String, Array[UInt32]]
}

///|
fn effective_cell_size(cell_size : Double) -> Double {
  if cell_size < 1.0 {
    1.0
  } else {
    cell_size
  }
}

///|
fn cell_index(value : Double, cell_size : Double) -> Int32 {
  (value / cell_size).floor().to_int()
}

///|
fn rect_cell_bounds(
  rect : @math.Rect,
  cell_size : Double,
) -> (Int32, Int32, Int32, Int32) {
  let min_x = cell_index(rect.position.x, cell_size)
  let min_y = cell_index(rect.position.y, cell_size)
  let max_x = cell_index(rect.position.x + rect.size.x, cell_size)
  let max_y = cell_index(rect.position.y + rect.size.y, cell_size)
  (min_x, min_y, max_x, max_y)
}

///|
fn bucket_key(x : Int32, y : Int32) -> String {
  x.to_string() + ":" + y.to_string()
}

///|
pub fn SpatialGrid2d::SpatialGrid2d(
  entries : Array[SpatialGridEntry2d],
  cell_size~ : Double = 256.0,
) -> SpatialGrid2d {
  let effective_size = effective_cell_size(cell_size)
  let buckets : Map[String, Array[UInt32]] = Map([])
  for entry in entries {
    let bounds = entry.bounds
    guard bounds.size.x > 0.0 && bounds.size.y > 0.0 else { continue }
    let (min_x, min_y, max_x, max_y) = rect_cell_bounds(bounds, effective_size)
    for x in min_x..<(max_x + 1) {
      for y in min_y..<(max_y + 1) {
        buckets.get_or_init(bucket_key(x, y), fn() { [] }).push(entry.id)
      }
    }
  }
  { cell_size: effective_size, buckets, }
}

///|
pub fn SpatialGrid2d::query(
  self : SpatialGrid2d,
  region : @math.Rect,
) -> Array[UInt32] {
  if region.size.x <= 0.0 || region.size.y <= 0.0 {
    return []
  }
  let unique : @set.Set[UInt32] = Set([])
  let (min_x, min_y, max_x, max_y) = rect_cell_bounds(region, self.cell_size)
  for x in min_x..<(max_x + 1) {
    for y in min_y..<(max_y + 1) {
      match self.buckets.get(bucket_key(x, y)) {
        Some(ids) =>
          for id in ids {
            unique.add(id)
          }
        None => ()
      }
    }
  }
  let sorted = unique.to_array()
  sorted.sort_by(fn(lhs, rhs) { lhs.compare(rhs) })
  sorted
}
