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
pub(all) struct CameraExtract2dContext {
  camera_views : Array[@camera.Camera2dView]
  all_camera_ids : Array[UInt]
  camera_views_by_id : Map[UInt, @camera.Camera2dView]
  camera_grid : SpatialGrid2d
}

///|
pub fn build_camera_extract2d_context(
  camera_views : Array[@camera.Camera2dView],
) -> CameraExtract2dContext {
  let all_camera_ids = camera_views.map(fn(camera_view) {
    camera_view.entity.id()
  })
  let camera_views_by_id : Map[UInt, @camera.Camera2dView] = Map::new()
  let camera_grid_entries : Array[SpatialGridEntry2d] = []
  for camera_view in camera_views {
    camera_views_by_id.set(camera_view.entity.id(), camera_view)
    camera_grid_entries.push({
      id: camera_view.entity.id(),
      bounds: camera_view.world_bounds(),
    })
  }
  {
    camera_views,
    all_camera_ids,
    camera_views_by_id,
    camera_grid: build_spatial_grid2d(camera_grid_entries),
  }
}

///|
pub fn CameraExtract2dContext::camera_views_for_bounds(
  self : CameraExtract2dContext,
  world_bounds : @math.Rect,
  entity_layers : @visibility.RenderLayers,
  parallax_depends_on_camera : Bool,
) -> Array[@camera.Camera2dView] {
  let candidate_camera_ids = if parallax_depends_on_camera {
    self.all_camera_ids
  } else {
    self.camera_grid.query(world_bounds)
  }
  if candidate_camera_ids.is_empty() {
    return []
  }
  let matched_camera_views : Array[@camera.Camera2dView] = []
  for camera_entity_id in candidate_camera_ids {
    guard self.camera_views_by_id.get(camera_entity_id) is Some(camera_view) else {
      continue
    }
    guard @visibility.matches(
      @visibility.entity_render_layers(camera_view.entity),
      entity_layers,
    ) else {
      continue
    }
    matched_camera_views.push(camera_view)
  }
  matched_camera_views
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
pub fn SpatialGrid2d::query(
  self : SpatialGrid2d,
  region : @math.Rect,
) -> Array[UInt] {
  if region.size[X] <= 0.0 || region.size[Y] <= 0.0 {
    return []
  }
  let unique : @set.Set[UInt] = @set.Set::new()
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

///|
test "spatial grid query returns deterministic ids from overlapping cells" {
  let grid = build_spatial_grid2d(
    [
      {
        id: 5U,
        bounds: { position: @math.Vec2(0.0, 0.0), size: @math.Vec2(16.0, 16.0) },
      },
      {
        id: 2U,
        bounds: {
          position: @math.Vec2(20.0, 0.0),
          size: @math.Vec2(16.0, 16.0),
        },
      },
      {
        id: 9U,
        bounds: {
          position: @math.Vec2(400.0, 0.0),
          size: @math.Vec2(16.0, 16.0),
        },
      },
    ],
    cell_size=32.0,
  )
  inspect(
    grid.query({ position: @math.Vec2(0.0, 0.0), size: @math.Vec2(40.0, 32.0) }),
    content="[2, 5]",
  )
}
