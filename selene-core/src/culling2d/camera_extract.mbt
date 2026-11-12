///|
pub(all) struct CameraExtract2dContext {
  camera_views : Array[@camera.Camera2dView]
  all_camera_ids : Array[UInt32]
  camera_views_by_id : Map[UInt32, @camera.Camera2dView]
  camera_grid : SpatialGrid2d
}

///|
pub fn CameraExtract2dContext::CameraExtract2dContext(
  camera_views : Array[@camera.Camera2dView],
) -> CameraExtract2dContext {
  let all_camera_ids = camera_views.map(fn(camera_view) {
    camera_view.entity.id()
  })
  let camera_views_by_id : Map[UInt32, @camera.Camera2dView] = Map([])
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
    camera_grid: SpatialGrid2d(camera_grid_entries),
  }
}

///|
pub fn CameraExtract2dContext::camera_views_for_bounds(
  self : CameraExtract2dContext,
  world~ : @ecs.World,
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
      @visibility.entity_render_layers(world~, camera_view.entity),
      entity_layers,
    ) else {
      continue
    }
    matched_camera_views.push(camera_view)
  }
  matched_camera_views
}
