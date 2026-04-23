///|
priv struct ToolDragState {
  entity_id : String
  entity_ids : Array[String]
  tool : @shared.PreviewTool
  anchor_world : @math.Vec2
  anchor_pointer : @math.Vec2
  pivot_world : @math.Vec2
  start_transforms : Map[String, @editor_bridge.Transform2dComponent]
}

///|
priv struct SelectionDragState {
  anchor_world : @math.Vec2
  anchor_pointer : @math.Vec2
}

///|
priv struct PreviewState {
  mut bootstrapped : Bool
  mut pending_scene : @bridge.PreviewScenePayload?
  mut current_scene_path : String?
  mut current_scene : @editor_bridge.SceneDocument?
  mut runtime_scene : @editor_bridge.SceneRuntime?
  mut selected_entity_id : String?
  mut selected_entity_ids : Array[String]
  mut hovered_entity_id : String?
  mut active_tool : @shared.PreviewTool
  mut move_snap_enabled : Bool
  mut move_snap_step : Double
  mut autotile_brush_terrain : Int
  mut camera_entity : @entity.Entity?
  mut selection_overlay : @entity.Entity?
  mut pivot_overlay : @entity.Entity?
  mut selection_rect_overlay : @entity.Entity?
  snap_grid_overlays : Array[@entity.Entity]
  mut pending_frame_selection : Bool
  mut tool_drag : ToolDragState?
  mut selection_drag : SelectionDragState?
  mut camera_pan_anchor : @math.Vec2?
  mut event_sink : ((@bridge.PreviewEvent) -> Unit)?
  mut initial_scene_aligned : Bool
  mut last_autotile_cell_key : String?
  mut viewport_width : Double
  mut viewport_height : Double
}

///|
fn PreviewState::new() -> PreviewState {
  {
    bootstrapped: false,
    pending_scene: None,
    current_scene_path: None,
    current_scene: None,
    runtime_scene: None,
    selected_entity_id: None,
    selected_entity_ids: [],
    hovered_entity_id: None,
    active_tool: @shared.preview_tool_select(),
    move_snap_enabled: false,
    move_snap_step: 16.0,
    autotile_brush_terrain: 1,
    camera_entity: None,
    selection_overlay: None,
    pivot_overlay: None,
    selection_rect_overlay: None,
    snap_grid_overlays: [],
    pending_frame_selection: false,
    tool_drag: None,
    selection_drag: None,
    camera_pan_anchor: None,
    event_sink: None,
    initial_scene_aligned: false,
    last_autotile_cell_key: None,
    viewport_width: 960.0,
    viewport_height: 540.0,
  }
}

///|
let preview_state : PreviewState = PreviewState::new()

///|
let default_editor_viewport_width = 960.0

///|
let default_editor_viewport_height = 540.0

///|
#cfg(target="js")
extern "js" fn canvas_client_size() -> Array[Double] =
  #| () => {
  #|   const canvas = document.getElementById("canvas");
  #|   if (!canvas) return [960, 540];
  #|   const rect = canvas.getBoundingClientRect();
  #|   return [
  #|     Math.max(1, rect.width || canvas.clientWidth || canvas.width || 960),
  #|     Math.max(1, rect.height || canvas.clientHeight || canvas.height || 540),
  #|   ];
  #| }

///|
#cfg(target="js")
extern "js" fn sync_canvas_backing_size(width : Double, height : Double) =
  #| (width, height) => {
  #|   const canvas = document.getElementById("canvas");
  #|   if (!canvas) return;
  #|   const nextWidth = Math.max(1, Math.floor(width));
  #|   const nextHeight = Math.max(1, Math.floor(height));
  #|   if (canvas.width !== nextWidth) canvas.width = nextWidth;
  #|   if (canvas.height !== nextHeight) canvas.height = nextHeight;
  #| }

///|
#cfg(not(target="js"))
fn canvas_client_size() -> Array[Double] {
  [preview_state.viewport_width, preview_state.viewport_height]
}

///|
#cfg(not(target="js"))
fn sync_canvas_backing_size(_width : Double, _height : Double) -> Unit {
  ()
}

///|
#cfg(target="js")
extern "js" fn set_canvas_cursor(cursor : String) =
  #| (cursor) => {
  #|   const canvas = document.getElementById("canvas");
  #|   if (!canvas) return;
  #|   canvas.style.cursor = cursor;
  #| }

///|
#cfg(target="js")
extern "js" fn pointer_over_canvas() -> Bool =
  #| () => {
  #|   const canvas = document.getElementById("canvas");
  #|   return !!canvas && canvas.matches(":hover");
  #| }

///|
#cfg(target="js")
extern "js" fn preview_debug_enabled() -> Bool =
  #| () => {
  #|   try {
  #|     return window.location.search.includes("preview_debug=1");
  #|   } catch (_error) {
  #|     return false;
  #|   }
  #| }

///|
#cfg(target="js")
extern "js" fn preview_debug_log(message : String) =
  #| (message) => console.debug("[selene-preview]", message)

///|
#cfg(not(target="js"))
fn preview_debug_enabled() -> Bool {
  false
}

///|
#cfg(not(target="js"))
fn preview_debug_log(_message : String) -> Unit {
  ()
}

///|
#cfg(not(target="js"))
fn pointer_over_canvas() -> Bool {
  true
}

///|
#cfg(not(target="js"))
fn set_canvas_cursor(_cursor : String) -> Unit {
  ()
}

///|
fn preview_debug(message : String) -> Unit {
  if preview_debug_enabled() {
    preview_debug_log(message)
  }
}

///|
fn resolved_canvas_client_size() -> @math.Vec2 {
  let size = canvas_client_size()
  let width = if size.length() > 0 && size[0] > 0.0 {
    size[0]
  } else {
    default_editor_viewport_width
  }
  let height = if size.length() > 1 && size[1] > 0.0 {
    size[1]
  } else {
    default_editor_viewport_height
  }
  @math.Vec2(width, height)
}

///|
fn current_editor_viewport_size() -> @math.Vec2 {
  @math.Vec2(preview_state.viewport_width, preview_state.viewport_height)
}

///|
fn refresh_editor_viewport_size() -> Unit {
  let size = resolved_canvas_client_size()
  let width = size[X]
  let height = size[Y]
  let changed = (width - preview_state.viewport_width).abs() > 0.5 ||
    (height - preview_state.viewport_height).abs() > 0.5
  if changed {
    let zoom = @system.get_zoom()
    preview_state.viewport_width = width
    preview_state.viewport_height = height
    @system.configure_display(width, height, zoom)
    preview_debug("viewport resized to \{width.to_string()}x\{height.to_string()}")
  }
  sync_canvas_backing_size(width, height)
}

///|
fn normalized_mouse_position() -> @math.Vec2 {
  let client_size = resolved_canvas_client_size()
  let client_width = client_size[X]
  let client_height = client_size[Y]
  let viewport = current_editor_viewport_size()
  @math.Vec2(
    @inputs.mouse.pos[X] * viewport[X] / client_width,
    @inputs.mouse.pos[Y] * viewport[Y] / client_height,
  )
}

///|
fn inside_editor_viewport(point : @math.Vec2) -> Bool {
  let viewport = current_editor_viewport_size()
  point[X] >= 0.0 &&
  point[X] <= viewport[X] &&
  point[Y] >= 0.0 &&
  point[Y] <= viewport[Y]
}

///|
fn mouse_to_viewport_delta(delta : @math.Vec2) -> @math.Vec2 {
  let client_size = resolved_canvas_client_size()
  let client_width = client_size[X]
  let client_height = client_size[Y]
  let viewport = current_editor_viewport_size()
  @math.Vec2(
    delta[X] * viewport[X] / client_width,
    delta[Y] * viewport[Y] / client_height,
  )
}

///|
fn pointer_drag_started(anchor : @math.Vec2) -> Bool {
  let delta = @inputs.mouse.pos - anchor
  delta[X].abs() >= 1.0 || delta[Y].abs() >= 1.0
}

///|
fn pointer_pan_active() -> Bool {
  match preview_state.camera_pan_anchor {
    Some(_) =>
      @inputs.mouse.middle_button ||
      (
        preview_state.active_tool == @shared.preview_tool_drag_canvas() &&
        @inputs.mouse.left_button
      )
    None => false
  }
}

///|
fn point_angle(center : @math.Vec2, point : @math.Vec2) -> Double {
  @cmath.atan2(point[Y] - center[Y], point[X] - center[X])
}

///|
fn shortest_angle_delta(start : Double, current : Double) -> Double {
  let raw = current - start
  if raw > @cmath.PI {
    raw - @cmath.PI * 2.0
  } else if raw < -@cmath.PI {
    raw + @cmath.PI * 2.0
  } else {
    raw
  }
}

///|
fn distance_between(a : @math.Vec2, b : @math.Vec2) -> Double {
  a.distance_to(b)
}

///|
fn clamp_scale_value(value : Double) -> Double {
  if value < 0.05 {
    0.05
  } else if value > 4096.0 {
    4096.0
  } else {
    value
  }
}

///|
fn move_grid_snap_active() -> Bool {
  preview_state.move_snap_enabled || @inputs.is_pressed(@inputs.ShiftLeft)
}

///|
fn snap_to_move_grid(point : @math.Vec2) -> @math.Vec2 {
  let grid = if preview_state.move_snap_step > 0.0 {
    preview_state.move_snap_step
  } else {
    16.0
  }
  @math.Vec2((point[X] / grid).round() * grid, (point[Y] / grid).round() * grid)
}

///|
fn move_target_world_point(point : @math.Vec2) -> @math.Vec2 {
  if move_grid_snap_active() {
    snap_to_move_grid(point)
  } else {
    point
  }
}

///|
fn resolve_project_asset_path(path : String?) -> String? {
  path.map(fn(value) {
    if value.has_prefix("/") ||
      value.has_prefix("http://") ||
      value.has_prefix("https://") {
      value
    } else {
      "/project/" + value
    }
  })
}

///|
fn emit_preview_event(event : @bridge.PreviewEvent) -> Unit {
  match preview_state.event_sink {
    Some(sink) => sink(event)
    None => ()
  }
}

///|
pub fn set_event_sink(sink : ((@bridge.PreviewEvent) -> Unit)?) -> Unit {
  preview_state.event_sink = sink
}

///|
pub fn load_scene(payload : @bridge.PreviewScenePayload) -> Unit {
  preview_state.pending_scene = Some(payload)
}

///|
pub fn clear_scene() -> Unit {
  preview_state.pending_scene = Some(
    @bridge.preview_scene_payload(
      None,
      @editor_bridge.SceneDocument::empty(),
      [],
      [],
      [],
    ),
  )
}

///|
pub fn set_selection(primary : String?, ids : Array[String]) -> Unit {
  let unique_ids : Array[String] = []
  let seen : Map[String, Bool] = {}
  for id in ids {
    if seen.contains(id) {
      continue
    }
    seen.set(id, true)
    unique_ids.push(id)
  }
  let normalized_primary = match primary {
    Some(id) if seen.contains(id) => Some(id)
    Some(_) => if unique_ids.is_empty() { None } else { Some(unique_ids[0]) }
    None => if unique_ids.is_empty() { None } else { Some(unique_ids[0]) }
  }
  let normalized_ids = match normalized_primary {
    Some(id) if unique_ids.contains(id) => unique_ids
    Some(id) => [id] + unique_ids
    None => []
  }
  preview_state.selected_entity_id = normalized_primary
  preview_state.selected_entity_ids = normalized_ids
}

///|
fn selected_entity_ids_for_edit() -> Array[String] {
  let ids : Array[String] = []
  let seen : Map[String, Bool] = {}
  for id in preview_state.selected_entity_ids {
    if seen.contains(id) {
      continue
    }
    seen.set(id, true)
    ids.push(id)
  }
  match preview_state.selected_entity_id {
    Some(primary) if !seen.contains(primary) => [primary] + ids
    _ => ids
  }
}

///|
fn selected_entity_ids_for_drag(
  runtime_scene : @editor_bridge.SceneRuntime,
  fallback_primary : String,
) -> Array[String] {
  let selected : Array[String] = []
  for id in selected_entity_ids_for_edit() {
    if runtime_scene.entity_ids.contains(id) {
      selected.push(id)
    }
  }
  if selected.is_empty() && runtime_scene.entity_ids.contains(fallback_primary) {
    [fallback_primary]
  } else {
    selected
  }
}

///|
fn selected_drag_start_transforms(
  runtime_scene : @editor_bridge.SceneRuntime,
  ids : Array[String],
) -> Map[String, @editor_bridge.Transform2dComponent] {
  let transforms : Map[String, @editor_bridge.Transform2dComponent] = {}
  for id in ids {
    guard runtime_scene.entity_ids.contains(id) else { continue }
    transforms.set(id, entity_transform2d(runtime_scene.entity_ids[id]))
  }
  transforms
}

///|
pub fn set_tool(tool : @shared.PreviewTool) -> Unit {
  preview_state.active_tool = tool
  if tool != @shared.preview_tool_select() {
    preview_state.selection_drag = None
  }
  preview_state.last_autotile_cell_key = None
}

///|
fn normalized_move_snap_step(step : Double) -> Double {
  if step > 0.0 {
    step
  } else {
    16.0
  }
}

///|
pub fn set_move_snap(enabled : Bool, step : Double) -> Unit {
  preview_state.move_snap_enabled = enabled
  preview_state.move_snap_step = normalized_move_snap_step(step)
}

///|
let preview_snap_grid_color : @render.Color = @render.Color::{
  r: 152U,
  g: 152U,
  b: 152U,
  a: 0.22,
}

///|
let preview_snap_grid_z = -8.0

///|
fn ensure_snap_grid_overlay_capacity(count : Int) -> Unit {
  while preview_state.snap_grid_overlays.length() < count {
    let overlay = @entity.Entity::new()
    preview_state.snap_grid_overlays.push(overlay)
    @transform.transforms().set(
      overlay,
      @transform.Transform::from_xyz(0.0, 0.0, preview_snap_grid_z),
    )
    @visibility.visibilities().set(overlay, @visibility.Hidden)
    @sprite.sprites().set(
      overlay,
      @sprite.Sprite::from_color(preview_snap_grid_color, @math.Vec2(1.0, 1.0)),
    )
  }
}

///|
fn hide_snap_grid_overlays_from(start : Int) -> Unit {
  for index = start; index < preview_state.snap_grid_overlays.length(); index = index +
      1 {
    @visibility.visibilities().set(
      preview_state.snap_grid_overlays[index],
      @visibility.Hidden,
    )
  }
}

///|
fn clear_snap_grid_overlays() -> Unit {
  hide_snap_grid_overlays_from(0)
}

///|
fn preview_camera_projection_state(
) -> (@camera.Camera, @camera.OrthographicProjection, @transform.GlobalTransform)? {
  guard editor_camera_entity() is Some(camera_entity) else { return None }
  guard @camera.cameras().get(camera_entity) is Some(camera_) else {
    return None
  }
  guard @camera.orthographic_projections().get(camera_entity)
    is Some(projection) else {
    return None
  }
  guard @transform.compute_global_transform(camera_entity) is Some(global) else {
    return None
  }
  Some((camera_, projection, global))
}

///|
fn apply_snap_grid_overlays() -> Unit {
  if !preview_state.move_snap_enabled {
    clear_snap_grid_overlays()
    return
  }
  let step = normalized_move_snap_step(preview_state.move_snap_step)
  if step <= 0.0 {
    clear_snap_grid_overlays()
    return
  }
  guard preview_camera_projection_state() is Some((camera_, projection, global)) else {
    clear_snap_grid_overlays()
    return
  }
  let viewport = current_editor_viewport_size()
  let top_left = camera_.viewport_to_world_2d(global, projection, @math.Vec2(0.0, 0.0))
  let bottom_right = camera_.viewport_to_world_2d(global, projection, viewport)
  let min_x = if top_left[X] < bottom_right[X] {
    top_left[X]
  } else {
    bottom_right[X]
  }
  let max_x = if top_left[X] > bottom_right[X] {
    top_left[X]
  } else {
    bottom_right[X]
  }
  let min_y = if top_left[Y] < bottom_right[Y] {
    top_left[Y]
  } else {
    bottom_right[Y]
  }
  let max_y = if top_left[Y] > bottom_right[Y] {
    top_left[Y]
  } else {
    bottom_right[Y]
  }
  if max_x <= min_x || max_y <= min_y {
    clear_snap_grid_overlays()
    return
  }
  let padding = step
  let start_x = ((min_x - padding) / step).floor() * step
  let end_x = ((max_x + padding) / step).ceil() * step
  let start_y = ((min_y - padding) / step).floor() * step
  let end_y = ((max_y + padding) / step).ceil() * step
  let vertical_count = ((end_x - start_x) / step).ceil().to_int() + 1
  let horizontal_count = ((end_y - start_y) / step).ceil().to_int() + 1
  let line_count = vertical_count + horizontal_count
  let max_lines = 1024
  if line_count <= 0 || line_count > max_lines {
    clear_snap_grid_overlays()
    return
  }
  ensure_snap_grid_overlay_capacity(line_count)
  let line_thickness = if projection.scale < 1.0 {
    projection.scale
  } else {
    1.0
  }
  let vertical_height = (end_y - start_y) + line_thickness
  let horizontal_width = (end_x - start_x) + line_thickness
  let mut overlay_index = 0
  for index = 0; index < vertical_count; index = index + 1 {
    let x = start_x + step * index.to_double()
    let overlay = preview_state.snap_grid_overlays[overlay_index]
    overlay_index += 1
    @transform.transforms().set(
      overlay,
      @transform.Transform::from_xyz(
        x,
        (start_y + end_y) * 0.5,
        preview_snap_grid_z,
      ).with_scale(@math.Vec3::new(line_thickness, vertical_height, 1.0)),
    )
    @visibility.visibilities().set(overlay, @visibility.Visible)
  }
  for index = 0; index < horizontal_count; index = index + 1 {
    let y = start_y + step * index.to_double()
    let overlay = preview_state.snap_grid_overlays[overlay_index]
    overlay_index += 1
    @transform.transforms().set(
      overlay,
      @transform.Transform::from_xyz(
        (start_x + end_x) * 0.5,
        y,
        preview_snap_grid_z,
      ).with_scale(@math.Vec3::new(horizontal_width, line_thickness, 1.0)),
    )
    @visibility.visibilities().set(overlay, @visibility.Visible)
  }
  hide_snap_grid_overlays_from(overlay_index)
}

///|
pub fn set_autotile_brush_terrain(terrain : Int) -> Unit {
  preview_state.autotile_brush_terrain = if terrain > 0 { terrain } else { 1 }
}

///|
fn selected_runtime_entity() -> @entity.Entity? {
  guard preview_state.runtime_scene is Some(scene) else { return None }
  guard preview_state.selected_entity_id is Some(id) else { return None }
  scene.entity(id)
}

///|
fn with_selected_animation_player(
  updater : (@animation.AnimationPlayer) -> Unit,
) -> Unit {
  guard selected_runtime_entity() is Some(entity) else { return }
  guard @animation.animation_players().get(entity) is Some(player) else {
    return
  }
  updater(player)
}

///|
pub fn set_animation_preview_paused(paused : Bool) -> Unit {
  with_selected_animation_player(fn(player) {
    if paused {
      ignore(player.pause_all())
    } else {
      ignore(player.resume_all())
    }
  })
}

///|
pub fn set_animation_preview_speed(speed : Double) -> Unit {
  with_selected_animation_player(fn(player) {
    for _, playing in player.playing_animations() {
      let (node, _active) = playing
      match player.animation_mut(node) {
        Some(active) => ignore(active.set_speed(speed))
        None => ()
      }
    }
  })
}

///|
pub fn seek_animation_preview(seconds : Double) -> Unit {
  let clamped = if seconds < 0.0 { 0.0 } else { seconds }
  with_selected_animation_player(fn(player) {
    for _, playing in player.playing_animations() {
      let (node, _active) = playing
      match player.animation_mut(node) {
        Some(active) => ignore(active.set_seek_time(clamped))
        None => ()
      }
    }
  })
}

///|
pub fn frame_selection() -> Unit {
  preview_state.pending_frame_selection = true
}

///|
fn clear_runtime_scene() -> Unit {
  match preview_state.runtime_scene {
    Some(scene) => scene.destroy()
    None => ()
  }
  preview_state.runtime_scene = None
  preview_state.tool_drag = None
  preview_state.selection_drag = None
  preview_state.last_autotile_cell_key = None
}

///|
fn deactivate_runtime_scene_cameras(
  runtime_scene : @editor_bridge.SceneRuntime,
) -> Unit {
  for _, entity in runtime_scene.entity_ids {
    if @camera.cameras().contains(entity) {
      @camera.cameras().set(entity, @camera.Camera::new(is_active=false))
    }
  }
}

///|
fn spawn_scene_entities(payload : @bridge.PreviewScenePayload) -> Unit {
  clear_runtime_scene()
  let atlas_assets : Map[String, @editor_bridge.AtlasAssetDocument] = {}
  let animation_clip_assets : Map[
    String,
    @editor_bridge.AnimationClipAssetDocument,
  ] = {}
  let animation_graph_assets : Map[
    String,
    @editor_bridge.AnimationGraphAssetDocument,
  ] = {}
  for entry in payload.atlases {
    atlas_assets.set(entry.path, entry.atlas)
  }
  for entry in payload.animation_clips {
    animation_clip_assets.set(entry.path, entry.clip)
  }
  for entry in payload.animation_graphs {
    animation_graph_assets.set(entry.path, entry.graph)
  }
  let runtime_scene = @editor_bridge.instantiate_scene_document_with_context(
    payload.scene,
    @editor_bridge.asset_instantiation_context(
      asset_path_resolver=resolve_project_asset_path,
      atlas_assets~,
      animation_clip_assets~,
      animation_graph_assets~,
    ),
  )
  deactivate_runtime_scene_cameras(runtime_scene)
  preview_state.runtime_scene = Some(runtime_scene)
}

///|
fn entity_transform2d(
  entity : @entity.Entity,
) -> @editor_bridge.Transform2dComponent {
  match preview_state.current_scene {
    Some(scene) =>
      match entity_id_of(entity) {
        Some(id) =>
          match scene.entity(id) {
            Some(document) => @editor_bridge.decoded_transform(document)
            None => @editor_bridge.transform2d_value()
          }
        None => @editor_bridge.transform2d_value()
      }
    None => @editor_bridge.transform2d_value()
  }
}

///|
fn entity_id_of(entity : @entity.Entity) -> String? {
  guard preview_state.runtime_scene is Some(scene) else { return None }
  for id, existing in scene.entity_ids {
    if existing == entity {
      return Some(id)
    }
  }
  None
}

///|
priv struct AutoTileEditCoord {
  x : Int
  y : Int
}

///|
fn autotile_cell_key(x : Int, y : Int) -> String {
  x.to_string() + "," + y.to_string()
}

///|
fn autotile_cell_map(
  layer : @editor_bridge.AutoTileLayer2dComponent,
) -> Map[String, @editor_bridge.AutoTileCellDocument] {
  let map : Map[String, @editor_bridge.AutoTileCellDocument] = {}
  for cell in layer.cells {
    map.set(autotile_cell_key(cell.x, cell.y), cell)
  }
  map
}

///|
fn sorted_autotile_cells(
  cells : Map[String, @editor_bridge.AutoTileCellDocument],
) -> Array[@editor_bridge.AutoTileCellDocument] {
  let ordered : Array[@editor_bridge.AutoTileCellDocument] = []
  for _, cell in cells {
    ordered.push(cell)
  }
  ordered.sort_by(fn(left, right) {
    if left.y == right.y {
      left.x.compare(right.x)
    } else {
      left.y.compare(right.y)
    }
  })
  ordered
}

///|
fn autotile_layer_with_cells(
  layer : @editor_bridge.AutoTileLayer2dComponent,
  cells : Array[@editor_bridge.AutoTileCellDocument],
) -> @editor_bridge.AutoTileLayer2dComponent {
  let component = @editor_bridge.autotile_layer2d_component(
    tile_size=layer.tile_size,
    origin=layer.origin,
    atlas_asset_path=layer.atlas_asset_path,
    rule_set=layer.rule_set,
    palette=layer.palette,
    cells~,
  )
  match @editor_bridge.decode_component(Some(component)) {
    Some(next_layer) => next_layer
    None => layer
  }
}

///|
fn selected_autotile_layer() -> (
  String,
  @editor_bridge.AutoTileLayer2dComponent,
)? {
  guard preview_state.current_scene is Some(scene) else { return None }
  guard preview_state.selected_entity_id is Some(layer_id) else { return None }
  guard scene.entity(layer_id) is Some(document) else { return None }
  let layer : @editor_bridge.AutoTileLayer2dComponent? = @editor_bridge.decode_component(
    document.component("AutoTileLayer2d"),
  )
  layer.map(fn(value) { (layer_id, value) })
}

///|
fn world_to_autotile_cell(
  layer : @editor_bridge.AutoTileLayer2dComponent,
  world_point : @math.Vec2,
) -> AutoTileEditCoord {
  let tile_width = if layer.tile_size.x <= 0.0 {
    16.0
  } else {
    layer.tile_size.x
  }
  let tile_height = if layer.tile_size.y <= 0.0 {
    16.0
  } else {
    layer.tile_size.y
  }
  let x = @cmath.floor((world_point[X] - layer.origin.x) / tile_width).to_int()
  let y = @cmath.floor((world_point[Y] - layer.origin.y) / tile_height).to_int()
  { x, y }
}

///|
fn runtime_layer_entity(layer_id : String) -> @entity.Entity? {
  guard preview_state.runtime_scene is Some(scene) else { return None }
  scene.entity(layer_id)
}

///|
fn apply_runtime_autotile_cells(
  layer_id : String,
  changed : Array[AutoTileEditCoord],
  terrain : Int?,
) -> Unit {
  guard runtime_layer_entity(layer_id) is Some(layer_entity) else { return }
  for coord in changed {
    match terrain {
      Some(value) =>
        @autotile2d.set_runtime_cell(layer_entity, coord.x, coord.y, value)
      None => @autotile2d.remove_runtime_cell(layer_entity, coord.x, coord.y)
    }
  }
}

///|
fn set_scene_autotile_layer(
  layer_id : String,
  layer : @editor_bridge.AutoTileLayer2dComponent,
) -> Unit {
  guard preview_state.current_scene is Some(scene) else { return }
  guard scene.entity(layer_id) is Some(document) else { return }
  let next_scene = scene.with_entity(
    document.with_component(
      @editor_bridge.component_document("AutoTileLayer2d", layer.to_json()),
    ),
  )
  preview_state.current_scene = Some(next_scene)
  emit_preview_event(
    @bridge.preview_event_autotile_layer_changed(layer_id, layer),
  )
}

///|
fn apply_autotile_single_cell_edit(
  layer_id : String,
  layer : @editor_bridge.AutoTileLayer2dComponent,
  coord : AutoTileEditCoord,
  terrain : Int?,
) -> Bool {
  let cells = autotile_cell_map(layer)
  let key = autotile_cell_key(coord.x, coord.y)
  let changed = match terrain {
    Some(value) =>
      match cells.get(key) {
        Some(cell) if cell.terrain == value => false
        _ => {
          cells.set(
            key,
            @editor_bridge.autotile_cell_document(coord.x, coord.y, value),
          )
          true
        }
      }
    None =>
      match cells.get(key) {
        Some(_) => {
          ignore(cells.remove(key))
          true
        }
        None => false
      }
  }
  if !changed {
    return false
  }
  let next_layer = autotile_layer_with_cells(
    layer,
    sorted_autotile_cells(cells),
  )
  set_scene_autotile_layer(layer_id, next_layer)
  apply_runtime_autotile_cells(layer_id, [coord], terrain)
  true
}

///|
fn apply_autotile_fill_edit(
  layer_id : String,
  layer : @editor_bridge.AutoTileLayer2dComponent,
  start : AutoTileEditCoord,
  terrain : Int,
) -> Bool {
  let cells = autotile_cell_map(layer)
  let start_key = autotile_cell_key(start.x, start.y)
  let target_terrain = match cells.get(start_key) {
    Some(cell) => Some(cell.terrain)
    None => None
  }
  match target_terrain {
    None =>
      apply_autotile_single_cell_edit(layer_id, layer, start, Some(terrain))
    Some(target) =>
      if target == terrain {
        false
      } else {
        let queue : Array[AutoTileEditCoord] = [start]
        let affected : Map[String, AutoTileEditCoord] = {}
        let visited : Map[String, Bool] = {}
        visited.set(start_key, true)
        let mut index = 0
        while index < queue.length() {
          let coord = queue[index]
          index = index + 1
          let key = autotile_cell_key(coord.x, coord.y)
          guard cells.get(key) is Some(cell) else { continue }
          if cell.terrain != target {
            continue
          }
          affected.set(key, coord)
          let neighbors = [
            { x: coord.x, y: coord.y - 1 },
            { x: coord.x + 1, y: coord.y },
            { x: coord.x, y: coord.y + 1 },
            { x: coord.x - 1, y: coord.y },
          ]
          for neighbor in neighbors {
            let neighbor_key = autotile_cell_key(neighbor.x, neighbor.y)
            if visited.contains(neighbor_key) {
              continue
            }
            visited.set(neighbor_key, true)
            if cells.get(neighbor_key) is Some(neighbor_cell) &&
              neighbor_cell.terrain == target {
              queue.push(neighbor)
            }
          }
        }
        if affected.is_empty() {
          false
        } else {
          let changed_coords : Array[AutoTileEditCoord] = []
          for key, coord in affected {
            cells.set(
              key,
              @editor_bridge.autotile_cell_document(coord.x, coord.y, terrain),
            )
            changed_coords.push(coord)
          }
          let next_layer = autotile_layer_with_cells(
            layer,
            sorted_autotile_cells(cells),
          )
          set_scene_autotile_layer(layer_id, next_layer)
          apply_runtime_autotile_cells(layer_id, changed_coords, Some(terrain))
          true
        }
      }
  }
}

///|
fn apply_autotile_tool_at_world(
  world_point : @math.Vec2,
  tool : @shared.PreviewTool,
) -> Bool {
  guard selected_autotile_layer() is Some((layer_id, layer)) else {
    return false
  }
  let coord = world_to_autotile_cell(layer, world_point)
  let key = autotile_cell_key(coord.x, coord.y)
  if (
      tool == @shared.preview_tool_autotile_paint() ||
      tool == @shared.preview_tool_autotile_erase()
    ) &&
    preview_state.last_autotile_cell_key == Some(key) {
    return false
  }
  let changed = match tool {
    @shared.AutoTilePaint =>
      apply_autotile_single_cell_edit(
        layer_id,
        layer,
        coord,
        Some(preview_state.autotile_brush_terrain),
      )
    @shared.AutoTileErase =>
      apply_autotile_single_cell_edit(layer_id, layer, coord, None)
    @shared.AutoTileFill =>
      apply_autotile_fill_edit(
        layer_id,
        layer,
        coord,
        preview_state.autotile_brush_terrain,
      )
    _ => false
  }
  if changed {
    preview_state.last_autotile_cell_key = Some(key)
  }
  changed
}

///|
fn overlay_bounds() -> (@math.Vec2, @math.Vec2)? {
  guard preview_state.current_scene is Some(scene) else { return None }
  let selected_ids = selected_entity_ids_for_edit()
  guard !selected_ids.is_empty() else { return None }
  let mut has_bounds = false
  let mut min_x = 0.0
  let mut min_y = 0.0
  let mut max_x = 0.0
  let mut max_y = 0.0
  for id in selected_ids {
    guard scene.entity(id) is Some(document) else { continue }
    let transform = @editor_bridge.decoded_transform(document)
    guard document_visual_bounds(document, transform) is Some((position, size)) else {
      continue
    }
    let left = position[X]
    let top = position[Y]
    let right = position[X] + size[X]
    let bottom = position[Y] + size[Y]
    if !has_bounds {
      has_bounds = true
      min_x = left
      min_y = top
      max_x = right
      max_y = bottom
    } else {
      if left < min_x {
        min_x = left
      }
      if top < min_y {
        min_y = top
      }
      if right > max_x {
        max_x = right
      }
      if bottom > max_y {
        max_y = bottom
      }
    }
  }
  if !has_bounds {
    None
  } else {
    Some((@math.Vec2(min_x, min_y), @math.Vec2(max_x - min_x, max_y - min_y)))
  }
}

///|
fn document_visual_bounds(
  document : @editor_bridge.EntityDocument,
  transform : @editor_bridge.Transform2dComponent,
) -> (@math.Vec2, @math.Vec2)? {
  if document.component("Sprite") is Some(component) {
    let sprite_data : @editor_bridge.SpriteComponent = match
      @editor_bridge.decode_component(Some(component)) {
      Some(sprite_data) => sprite_data
      None => return None
    }
    let atlas_data = @editor_bridge.decode_component(
      document.component("TextureAtlas"),
    ).map(fn(atlas : @editor_bridge.TextureAtlasComponent) {
      match atlas.layout {
        Some(layout) => layout.tile_size
        None => @editor_bridge.vec2_doc(32.0, 32.0)
      }
    })
    let size = @editor_bridge.sprite_doc_size(sprite_data, atlas_data)
    let scaled_width = size.x * transform.scale.x.abs()
    let scaled_height = size.y * transform.scale.y.abs()
    let anchor = sprite_data.anchor
    let min_x = transform.translation.x - scaled_width * (anchor.x + 0.5)
    let min_y = transform.translation.y - scaled_height * (0.5 - anchor.y)
    return Some(
      (@math.Vec2(min_x, min_y), @math.Vec2(scaled_width, scaled_height)),
    )
  }
  if document.component("Text2d") is Some(component) {
    let text_data : @editor_bridge.Text2dComponent = match
      @editor_bridge.decode_component(Some(component)) {
      Some(text_data) => text_data
      None => return None
    }
    let size = text_data.bounds.unwrap_or(
      @editor_bridge.vec2_doc(
        if text_data.content.length().to_double() * text_data.font_size * 0.5 >
          32.0 {
          text_data.content.length().to_double() * text_data.font_size * 0.5
        } else {
          32.0
        },
        text_data.font_size * 1.4,
      ),
    )
    let scaled_width = size.x * transform.scale.x.abs()
    let scaled_height = size.y * transform.scale.y.abs()
    let min_x = transform.translation.x -
      scaled_width * (text_data.anchor.x + 0.5)
    let min_y = transform.translation.y -
      scaled_height * (0.5 - text_data.anchor.y)
    return Some(
      (@math.Vec2(min_x, min_y), @math.Vec2(scaled_width, scaled_height)),
    )
  }
  if document.component("Mesh2d") is Some(component) {
    let mesh_data : @editor_bridge.Mesh2dComponent = match
      @editor_bridge.decode_component(Some(component)) {
      Some(mesh_data) => mesh_data
      None => return None
    }
    let size = match mesh_data.primitive {
      "circle" => {
        let radius = mesh_data.radius.unwrap_or(16.0)
        @math.Vec2(radius * 2.0, radius * 2.0)
      }
      _ =>
        @math.Vec2(
          mesh_data.size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)).x,
          mesh_data.size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)).y,
        )
    }
    let scaled_width = size[X] * transform.scale.x.abs()
    let scaled_height = size[Y] * transform.scale.y.abs()
    let min_x = transform.translation.x - scaled_width * 0.5
    let min_y = transform.translation.y - scaled_height * 0.5
    return Some(
      (@math.Vec2(min_x, min_y), @math.Vec2(scaled_width, scaled_height)),
    )
  }
  Some(
    (
      @math.Vec2(transform.translation.x, transform.translation.y),
      @math.Vec2(0.0, 0.0),
    ),
  )
}

///|
fn scene_visual_bounds() -> (@math.Vec2, @math.Vec2)? {
  guard preview_state.current_scene is Some(scene) else { return None }
  let mut has_bounds = false
  let mut min_x = 0.0
  let mut min_y = 0.0
  let mut max_x = 0.0
  let mut max_y = 0.0
  for document in scene.entities {
    if document.component("Camera2d") is Some(_) {
      continue
    }
    let transform = @editor_bridge.decoded_transform(document)
    guard document_visual_bounds(document, transform) is Some((position, size)) else {
      continue
    }
    let left = position[X]
    let top = position[Y]
    let right = position[X] + size[X]
    let bottom = position[Y] + size[Y]
    if !has_bounds {
      has_bounds = true
      min_x = left
      min_y = top
      max_x = right
      max_y = bottom
    } else {
      if left < min_x {
        min_x = left
      }
      if top < min_y {
        min_y = top
      }
      if right > max_x {
        max_x = right
      }
      if bottom > max_y {
        max_y = bottom
      }
    }
  }
  if !has_bounds {
    None
  } else {
    Some((@math.Vec2(min_x, min_y), @math.Vec2(max_x - min_x, max_y - min_y)))
  }
}

///|
fn align_camera_to_scene_top_left() -> Bool {
  guard editor_camera_entity() is Some(camera_entity) else { return false }
  guard scene_visual_bounds() is Some((position, _size)) else { return false }
  guard @camera.orthographic_projections().get(camera_entity)
    is Some(projection) else {
    preview_debug("camera align skipped: missing orthographic projection")
    return false
  }
  guard @transform.transforms().get(camera_entity) is Some(transform) else {
    preview_debug("camera align skipped: missing camera transform")
    return false
  }
  let viewport = current_editor_viewport_size()
  let view_width = viewport[X] * projection.scale
  let view_height = viewport[Y] * projection.scale
  @transform.transforms().set(
    camera_entity,
    transform.with_translation(
      @math.Vec3::new(
        position[X] + view_width * 0.5,
        position[Y] + view_height * 0.5,
        transform.translation.z,
      ),
    ),
  )
  true
}

///|
fn align_camera_to_origin_top_left() -> Bool {
  guard editor_camera_entity() is Some(camera_entity) else { return false }
  guard @camera.orthographic_projections().get(camera_entity)
    is Some(projection) else {
    preview_debug("origin align skipped: missing orthographic projection")
    return false
  }
  guard @transform.transforms().get(camera_entity) is Some(transform) else {
    preview_debug("origin align skipped: missing camera transform")
    return false
  }
  let viewport = current_editor_viewport_size()
  let view_width = viewport[X] * projection.scale
  let view_height = viewport[Y] * projection.scale
  @transform.transforms().set(
    camera_entity,
    transform.with_translation(
      @math.Vec3::new(
        view_width * 0.5,
        view_height * 0.5,
        transform.translation.z,
      ),
    ),
  )
  true
}

///|
fn try_align_initial_scene_camera() -> Unit {
  if preview_state.initial_scene_aligned {
    return
  }
  match preview_state.current_scene {
    Some(scene) =>
      preview_state.initial_scene_aligned = if scene.entities.is_empty() {
        align_camera_to_origin_top_left()
      } else {
        align_camera_to_scene_top_left()
      }
    None => ()
  }
}

///|
fn selected_pivot_world() -> @math.Vec2? {
  guard preview_state.current_scene is Some(scene) else { return None }
  guard preview_state.selected_entity_id is Some(id) else { return None }
  guard scene.entity(id) is Some(document) else { return None }
  let transform = @editor_bridge.decoded_transform(document)
  Some(@math.Vec2(transform.translation.x, transform.translation.y))
}

///|
fn update_current_scene_entity_transform(
  entity_id : String,
  next_transform : @editor_bridge.Transform2dComponent,
) -> Unit {
  guard preview_state.current_scene is Some(scene) else { return }
  guard scene.entity(entity_id) is Some(document) else { return }
  let next_scene = scene.with_entity(
    document.with_component(
      @editor_bridge.transform2d_component(
        translation=next_transform.translation,
        rotation=next_transform.rotation,
        scale=next_transform.scale,
      ),
    ),
  )
  preview_state.current_scene = Some(next_scene)
}

///|
fn apply_runtime_transform(
  entity_id : String,
  next_transform : @editor_bridge.Transform2dComponent,
) -> Unit {
  update_current_scene_entity_transform(entity_id, next_transform)
  guard preview_state.runtime_scene is Some(scene) else { return }
  guard scene.entity_ids.contains(entity_id) else { return }
  let entity = scene.entity_ids[entity_id]
  let current = @transform.transforms()
    .get(entity)
    .unwrap_or(@transform.Transform::identity())
  let runtime_transform = @transform.Transform::from_xyz(
      next_transform.translation.x,
      next_transform.translation.y,
      current.translation.z,
    )
    .with_rotation(
      @math.Quat::from_axis_angle(@math.Vec3::z_axis(), next_transform.rotation),
    )
    .with_scale(
      @math.Vec3::new(next_transform.scale.x, next_transform.scale.y, 1.0),
    )
  @transform.transforms().set(entity, runtime_transform)
}

///|
fn apply_selection_overlay() -> Unit {
  guard preview_state.selection_overlay is Some(overlay) else { return }
  let selected_ids = selected_entity_ids_for_edit()
  match overlay_bounds() {
    Some((position, size)) => {
      let color = if preview_state.tool_drag is Some(_) {
        @render.Color::{ r: 92U, g: 196U, b: 255U, a: 0.24 }
      } else if preview_state.hovered_entity_id is Some(hovered_id) &&
        selected_ids.contains(hovered_id) {
        @render.Color::{ r: 255U, g: 220U, b: 64U, a: 0.28 }
      } else {
        @render.Color::{ r: 255U, g: 220U, b: 64U, a: 0.18 }
      }
      @visibility.visibilities().set(overlay, @visibility.Visible)
      @transform.transforms().set(
        overlay,
        @transform.Transform::from_xyz(
          position[X] + size[X] * 0.5,
          position[Y] + size[Y] * 0.5,
          10.0,
        ).with_scale(@math.Vec3::new(size[X], size[Y], 1.0)),
      )
      @sprite.sprites().set(
        overlay,
        @sprite.Sprite::from_color(color, @math.Vec2(1.0, 1.0)),
      )
    }
    None => @visibility.visibilities().set(overlay, @visibility.Hidden)
  }
}

///|
fn apply_pivot_overlay() -> Unit {
  guard preview_state.pivot_overlay is Some(overlay) else { return }
  match selected_pivot_world() {
    Some(position) => {
      let color = if preview_state.tool_drag is Some(_) {
        @render.Color::{ r: 120U, g: 255U, b: 198U, a: 0.95 }
      } else {
        @render.Color::{ r: 96U, g: 220U, b: 255U, a: 0.9 }
      }
      @visibility.visibilities().set(overlay, @visibility.Visible)
      @transform.transforms().set(
        overlay,
        @transform.Transform::from_xyz(position[X], position[Y], 12.0).with_scale(
          @math.Vec3::new(8.0, 8.0, 1.0),
        ),
      )
      @sprite.sprites().set(
        overlay,
        @sprite.Sprite::from_color(color, @math.Vec2(1.0, 1.0)),
      )
    }
    None => @visibility.visibilities().set(overlay, @visibility.Hidden)
  }
}

///|
fn apply_selection_rect_overlay(world_point : @math.Vec2?) -> Unit {
  guard preview_state.selection_rect_overlay is Some(overlay) else { return }
  guard preview_state.selection_drag is Some(drag) else {
    @visibility.visibilities().set(overlay, @visibility.Hidden)
    return
  }
  guard world_point is Some(point) else {
    @visibility.visibilities().set(overlay, @visibility.Hidden)
    return
  }
  if !@inputs.mouse.left_button {
    @visibility.visibilities().set(overlay, @visibility.Hidden)
    return
  }
  if !pointer_drag_started(drag.anchor_pointer) {
    @visibility.visibilities().set(overlay, @visibility.Hidden)
    return
  }
  let min_x = if drag.anchor_world[X] < point[X] {
    drag.anchor_world[X]
  } else {
    point[X]
  }
  let min_y = if drag.anchor_world[Y] < point[Y] {
    drag.anchor_world[Y]
  } else {
    point[Y]
  }
  let max_x = if drag.anchor_world[X] > point[X] {
    drag.anchor_world[X]
  } else {
    point[X]
  }
  let max_y = if drag.anchor_world[Y] > point[Y] {
    drag.anchor_world[Y]
  } else {
    point[Y]
  }
  let width = max_x - min_x
  let height = max_y - min_y
  @visibility.visibilities().set(overlay, @visibility.Visible)
  @transform.transforms().set(
    overlay,
    @transform.Transform::from_xyz(
      min_x + width * 0.5,
      min_y + height * 0.5,
      11.0,
    ).with_scale(@math.Vec3::new(width, height, 1.0)),
  )
  @sprite.sprites().set(
    overlay,
    @sprite.Sprite::from_color(
      @render.Color::{ r: 96U, g: 220U, b: 255U, a: 0.22 },
      @math.Vec2(1.0, 1.0),
    ),
  )
}

///|
fn editor_camera_entity() -> @entity.Entity? {
  preview_state.camera_entity
}

///|
fn world_point_from_mouse() -> @math.Vec2? {
  guard editor_camera_entity() is Some(camera_entity) else { return None }
  guard @camera.cameras().get(camera_entity) is Some(camera_) else {
    return None
  }
  guard @camera.orthographic_projections().get(camera_entity)
    is Some(projection) else {
    return None
  }
  guard @transform.compute_global_transform(camera_entity) is Some(global) else {
    return None
  }
  Some(
    camera_.viewport_to_world_2d(
      global,
      projection,
      normalized_mouse_position(),
    ),
  )
}

///|
pub fn viewport_to_world(
  x : Double,
  y : Double,
  viewport_width : Double,
  viewport_height : Double,
) -> @editor_bridge.Vec2Doc? {
  if viewport_width <= 0.0 || viewport_height <= 0.0 {
    return None
  }
  guard editor_camera_entity() is Some(camera_entity) else { return None }
  guard @camera.cameras().get(camera_entity) is Some(camera_) else {
    return None
  }
  guard @camera.orthographic_projections().get(camera_entity)
    is Some(projection) else {
    return None
  }
  guard @transform.compute_global_transform(camera_entity) is Some(global) else {
    return None
  }
  let editor_viewport = current_editor_viewport_size()
  let viewport_point = @math.Vec2(
    x * editor_viewport[X] / viewport_width,
    y * editor_viewport[Y] / viewport_height,
  )
  let world_point = camera_.viewport_to_world_2d(
    global, projection, viewport_point,
  )
  Some(@editor_bridge.vec2_doc(world_point[X], world_point[Y]))
}

///|
fn pick_entity_id_at(point : @math.Vec2) -> String? {
  guard preview_state.current_scene is Some(scene) else { return None }
  for document in scene.entities.rev_iter() {
    let transform = @editor_bridge.decoded_transform(document)
    if document.component("Sprite") is Some(component) {
      let sprite_data : @editor_bridge.SpriteComponent = match
        @editor_bridge.decode_component(Some(component)) {
        Some(sprite_data) => sprite_data
        None => continue
      }
      let atlas_size = @editor_bridge.decode_component(
        document.component("TextureAtlas"),
      ).map(fn(atlas : @editor_bridge.TextureAtlasComponent) {
        match atlas.layout {
          Some(layout) => layout.tile_size
          None => @editor_bridge.vec2_doc(32.0, 32.0)
        }
      })
      let size = @editor_bridge.sprite_doc_size(sprite_data, atlas_size)
      let scaled_width = size.x * transform.scale.x.abs()
      let scaled_height = size.y * transform.scale.y.abs()
      let anchor = sprite_data.anchor
      let min_x = transform.translation.x - scaled_width * (anchor.x + 0.5)
      let min_y = transform.translation.y - scaled_height * (0.5 - anchor.y)
      if point[X] >= min_x &&
        point[X] <= min_x + scaled_width &&
        point[Y] >= min_y &&
        point[Y] <= min_y + scaled_height {
        return Some(document.id)
      }
    } else if document.component("Mesh2d") is Some(component) {
      let mesh_data : @editor_bridge.Mesh2dComponent = match
        @editor_bridge.decode_component(Some(component)) {
        Some(mesh_data) => mesh_data
        None => continue
      }
      match mesh_data.primitive {
        "circle" => {
          let radius = mesh_data.radius.unwrap_or(16.0) *
            transform.scale.x.abs()
          let center = @math.Vec2(
            transform.translation.x,
            transform.translation.y,
          )
          if center.distance_to(point) <= radius {
            return Some(document.id)
          }
        }
        _ => {
          let size = mesh_data.size.unwrap_or(
            @editor_bridge.vec2_doc(32.0, 32.0),
          )
          let scaled_width = size.x * transform.scale.x.abs()
          let scaled_height = size.y * transform.scale.y.abs()
          let min_x = transform.translation.x - scaled_width * 0.5
          let min_y = transform.translation.y - scaled_height * 0.5
          if point[X] >= min_x &&
            point[X] <= min_x + scaled_width &&
            point[Y] >= min_y &&
            point[Y] <= min_y + scaled_height {
            return Some(document.id)
          }
        }
      }
    }
  }
  None
}

///|
fn rect_contains_point(
  min_point : @math.Vec2,
  max_point : @math.Vec2,
  point : @math.Vec2,
) -> Bool {
  point[X] >= min_point[X] &&
  point[X] <= max_point[X] &&
  point[Y] >= min_point[Y] &&
  point[Y] <= max_point[Y]
}

///|
fn rect_intersects(
  min_a : @math.Vec2,
  max_a : @math.Vec2,
  min_b : @math.Vec2,
  max_b : @math.Vec2,
) -> Bool {
  !(max_a[X] < min_b[X] ||
  max_b[X] < min_a[X] ||
  max_a[Y] < min_b[Y] ||
  max_b[Y] < min_a[Y])
}

///|
fn pick_entity_ids_in_rect(
  anchor : @math.Vec2,
  current : @math.Vec2,
) -> Array[String] {
  guard preview_state.current_scene is Some(scene) else { return [] }
  let min_point = @math.Vec2(
    if anchor[X] < current[X] {
      anchor[X]
    } else {
      current[X]
    },
    if anchor[Y] < current[Y] {
      anchor[Y]
    } else {
      current[Y]
    },
  )
  let max_point = @math.Vec2(
    if anchor[X] > current[X] {
      anchor[X]
    } else {
      current[X]
    },
    if anchor[Y] > current[Y] {
      anchor[Y]
    } else {
      current[Y]
    },
  )
  let selected : Array[String] = []
  for document in scene.entities.rev_iter() {
    if document.component("Camera2d") is Some(_) {
      continue
    }
    let transform = @editor_bridge.decoded_transform(document)
    let matched = match document_visual_bounds(document, transform) {
      Some((position, size)) =>
        if size[X].abs() <= 0.001 && size[Y].abs() <= 0.001 {
          rect_contains_point(min_point, max_point, position)
        } else {
          rect_intersects(
            min_point,
            max_point,
            position,
            @math.Vec2(position[X] + size[X], position[Y] + size[Y]),
          )
        }
      None => false
    }
    if matched {
      selected.push(document.id)
    }
  }
  selected
}

///|
fn set_selected_ids_and_emit(ids : Array[String]) -> Unit {
  let primary = if ids.is_empty() { None } else { Some(ids[0]) }
  set_selection(primary, ids)
  emit_preview_event(
    @bridge.preview_event_selection_changed(
      preview_state.selected_entity_id,
      preview_state.selected_entity_ids,
    ),
  )
}

///|
fn frame_selection_impl() -> Unit {
  guard preview_state.pending_frame_selection else { return }
  preview_state.pending_frame_selection = false
  guard editor_camera_entity() is Some(camera_entity) else { return }
  guard overlay_bounds() is Some((position, size)) else { return }
  let center = @math.Vec2(
    position[X] + size[X] * 0.5,
    position[Y] + size[Y] * 0.5,
  )
  let transform = @transform.transforms()
    .get(camera_entity)
    .unwrap_or(@transform.Transform::identity())
  @transform.transforms().set(
    camera_entity,
    transform.with_translation(
      @math.Vec3::new(center[X], center[Y], transform.translation.z),
    ),
  )
}

///|
fn preview_startup_system(_world : @ecs.World) -> Unit {
  let camera_entity = @entity.Entity::new()
  preview_state.camera_entity = Some(camera_entity)
  @transform.transforms().set(
    camera_entity,
    @transform.Transform::from_xyz(0.0, 0.0, 1000.0),
  )
  @camera.cameras().set(camera_entity, @camera.Camera::new(order=0))
  @camera.camera2ds().set(camera_entity, @camera.Camera2d::new())
  @camera.orthographic_projections().set(
    camera_entity,
    @camera.OrthographicProjection::new(scale=1.0),
  )
  let overlay = @entity.Entity::new()
  preview_state.selection_overlay = Some(overlay)
  @transform.transforms().set(
    overlay,
    @transform.Transform::from_xyz(0.0, 0.0, 10.0),
  )
  @visibility.visibilities().set(overlay, @visibility.Hidden)
  @sprite.sprites().set(
    overlay,
    @sprite.Sprite::from_color(
      @render.Color::{ r: 255U, g: 220U, b: 64U, a: 0.18 },
      @math.Vec2(1.0, 1.0),
    ),
  )
  let pivot_overlay = @entity.Entity::new()
  preview_state.pivot_overlay = Some(pivot_overlay)
  @transform.transforms().set(
    pivot_overlay,
    @transform.Transform::from_xyz(0.0, 0.0, 12.0),
  )
  @visibility.visibilities().set(pivot_overlay, @visibility.Hidden)
  @sprite.sprites().set(
    pivot_overlay,
    @sprite.Sprite::from_color(
      @render.Color::{ r: 96U, g: 220U, b: 255U, a: 0.9 },
      @math.Vec2(1.0, 1.0),
    ),
  )
  let selection_rect_overlay = @entity.Entity::new()
  preview_state.selection_rect_overlay = Some(selection_rect_overlay)
  @transform.transforms().set(
    selection_rect_overlay,
    @transform.Transform::from_xyz(0.0, 0.0, 11.0),
  )
  @visibility.visibilities().set(selection_rect_overlay, @visibility.Hidden)
  @sprite.sprites().set(
    selection_rect_overlay,
    @sprite.Sprite::from_color(
      @render.Color::{ r: 96U, g: 220U, b: 255U, a: 0.22 },
      @math.Vec2(1.0, 1.0),
    ),
  )
}

///|
fn preview_scene_sync_system(_world : @ecs.World) -> Unit {
  if preview_state.pending_scene is Some(payload) {
    let previous_scene_path = preview_state.current_scene_path
    let scene_switched = previous_scene_path != payload.scene_path
    spawn_scene_entities(payload)
    preview_state.current_scene_path = payload.scene_path
    preview_state.current_scene = Some(payload.scene)
    preview_state.pending_scene = None
    preview_state.tool_drag = None
    preview_state.selection_drag = None
    let kept_ids : Array[String] = []
    for id in preview_state.selected_entity_ids {
      if payload.scene.entity(id) is Some(_) {
        kept_ids.push(id)
      }
    }
    let kept_primary = match preview_state.selected_entity_id {
      Some(id) if payload.scene.entity(id) is Some(_) => Some(id)
      _ => None
    }
    set_selection(kept_primary, kept_ids)
    if scene_switched || payload.scene.entities.is_empty() {
      preview_state.initial_scene_aligned = false
    }
  }
  try_align_initial_scene_camera()
  apply_selection_overlay()
  apply_pivot_overlay()
  frame_selection_impl()
}

///|
fn preview_viewport_sync_system(_world : @ecs.World) -> Unit {
  refresh_editor_viewport_size()
}

///|
fn preview_snap_grid_overlay_system(_world : @ecs.World) -> Unit {
  apply_snap_grid_overlays()
}

///|
fn preview_camera_control_system(_world : @ecs.World) -> Unit {
  guard editor_camera_entity() is Some(camera_entity) else { return }
  let pointer_inside_canvas = pointer_over_canvas()
  if @camera.orthographic_projections().get(camera_entity) is Some(projection) {
    let wheel_delta = @inputs.mouse_wheel.delta
    if wheel_delta[X] != 0.0 || wheel_delta[Y] != 0.0 {
      if @inputs.is_pressed(@inputs.ShiftLeft) {
        let raw_scale = projection.scale * (1.0 - wheel_delta[Y] * 0.1)
        let next_scale = if raw_scale < 0.1 { 0.1 } else { raw_scale }
        @camera.orthographic_projections().set(camera_entity, {
          ..projection,
          scale: next_scale,
        })
      } else {
        let transform = @transform.transforms()
          .get(camera_entity)
          .unwrap_or(@transform.Transform::identity())
        @transform.transforms().set(
          camera_entity,
          transform.with_translation(
            @math.Vec3::new(
              transform.translation.x + wheel_delta[X] * projection.scale,
              transform.translation.y + wheel_delta[Y] * projection.scale,
              transform.translation.z,
            ),
          ),
        )
      }
    }
  }
  if (
      @inputs.is_mouse_just_pressed(@inputs.MouseButton::Middle) &&
      pointer_inside_canvas
    ) ||
    (
      @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
      preview_state.active_tool == @shared.preview_tool_drag_canvas() &&
      pointer_inside_canvas
    ) {
    preview_state.camera_pan_anchor = Some(@inputs.mouse.pos)
  } else if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
    preview_state.active_tool == @shared.preview_tool_drag_canvas() &&
    !pointer_inside_canvas {
    preview_debug(
      "ignored drag-canvas left press outside canvas, mouse=" +
      @inputs.mouse.pos[X].to_string() +
      "," +
      @inputs.mouse.pos[Y].to_string(),
    )
  }
  let pan_active = pointer_pan_active()
  if !@inputs.mouse.middle_button &&
    !(preview_state.active_tool == @shared.preview_tool_drag_canvas() &&
    @inputs.mouse.left_button) {
    preview_state.camera_pan_anchor = None
  }
  if pan_active && preview_state.camera_pan_anchor is Some(anchor) {
    let current = @inputs.mouse.pos
    let movement = mouse_to_viewport_delta(current - anchor)
    if movement[X].abs() >= 1.0 || movement[Y].abs() >= 1.0 {
      let projection = @camera.orthographic_projections()
        .get(camera_entity)
        .unwrap_or(@camera.OrthographicProjection::new())
      let transform = @transform.transforms()
        .get(camera_entity)
        .unwrap_or(@transform.Transform::identity())
      @transform.transforms().set(
        camera_entity,
        transform.with_translation(
          @math.Vec3::new(
            transform.translation.x - movement[X] * projection.scale,
            transform.translation.y - movement[Y] * projection.scale,
            transform.translation.z,
          ),
        ),
      )
      preview_state.camera_pan_anchor = Some(current)
    }
  }
}

///|
fn is_autotile_tool(tool : @shared.PreviewTool) -> Bool {
  match tool {
    @shared.AutoTilePaint | @shared.AutoTileErase | @shared.AutoTileFill => true
    _ => false
  }
}

///|
fn preview_pick_system(_world : @ecs.World) -> Unit {
  guard world_point_from_mouse() is Some(world_point) else {
    apply_selection_rect_overlay(None)
    return
  }
  let pointer_inside = pointer_over_canvas() &&
    inside_editor_viewport(normalized_mouse_position())
  let hovered = if pointer_inside {
    pick_entity_id_at(world_point)
  } else {
    None
  }
  let selected_ids = selected_entity_ids_for_edit()
  if hovered != preview_state.hovered_entity_id {
    preview_state.hovered_entity_id = hovered
    emit_preview_event(@bridge.preview_event_hover_changed(hovered))
  }
  apply_selection_rect_overlay(Some(world_point))
  let cursor = if pointer_pan_active() {
    "grabbing"
  } else if preview_state.active_tool == @shared.preview_tool_select() &&
    preview_state.selection_drag is Some(_) {
    "crosshair"
  } else if preview_state.tool_drag is Some(drag_state) {
    match drag_state.tool {
      @shared.Translate => "grabbing"
      @shared.Rotate => "crosshair"
      @shared.Scale => "nwse-resize"
      _ => "default"
    }
  } else {
    match preview_state.active_tool {
      @shared.Select => if hovered is Some(_) { "pointer" } else { "default" }
      @shared.DragCanvas => "grab"
      @shared.Translate =>
        if hovered is Some(hovered_id) && selected_ids.contains(hovered_id) {
          "move"
        } else if hovered is Some(_) {
          "pointer"
        } else if !selected_ids.is_empty() {
          "crosshair"
        } else {
          "default"
        }
      @shared.Rotate => "crosshair"
      @shared.Scale => "nwse-resize"
      @shared.AutoTilePaint => "crosshair"
      @shared.AutoTileErase => "cell"
      @shared.AutoTileFill => "copy"
    }
  }
  set_canvas_cursor(cursor)
  if pointer_pan_active() {
    preview_state.tool_drag = None
    preview_state.selection_drag = None
    return
  }
  if is_autotile_tool(preview_state.active_tool) {
    if !@inputs.mouse.left_button {
      preview_state.last_autotile_cell_key = None
    }
    if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
      !pointer_inside {
      preview_debug(
        "ignored autotile edit outside canvas, mouse=" +
        @inputs.mouse.pos[X].to_string() +
        "," +
        @inputs.mouse.pos[Y].to_string(),
      )
      return
    }
    if !pointer_inside {
      return
    }
    let active_tool = preview_state.active_tool
    if active_tool == @shared.preview_tool_autotile_fill() {
      if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) {
        ignore(apply_autotile_tool_at_world(world_point, active_tool))
      }
    } else if @inputs.mouse.left_button {
      ignore(apply_autotile_tool_at_world(world_point, active_tool))
    }
    return
  }
  if preview_state.active_tool == @shared.preview_tool_select() {
    if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
      pointer_inside {
      preview_state.selection_drag = Some({
        anchor_world: world_point,
        anchor_pointer: @inputs.mouse.pos,
      })
    } else if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
      !pointer_inside {
      preview_debug(
        "ignored left pick outside canvas, mouse=" +
        @inputs.mouse.pos[X].to_string() +
        "," +
        @inputs.mouse.pos[Y].to_string(),
      )
    }
    if (
        @inputs.is_mouse_just_released(@inputs.MouseButton::Left) ||
        !@inputs.mouse.left_button
      ) &&
      preview_state.selection_drag is Some(drag) {
      if pointer_drag_started(drag.anchor_pointer) {
        let ids = pick_entity_ids_in_rect(drag.anchor_world, world_point)
        set_selected_ids_and_emit(ids)
      } else {
        match hovered {
          Some(id) => set_selected_ids_and_emit([id])
          None => set_selected_ids_and_emit([])
        }
      }
      preview_state.selection_drag = None
    }
  } else if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
    pointer_inside {
    match preview_state.active_tool {
      @shared.Translate =>
        match preview_state.selected_entity_id {
          Some(selected) if preview_state.runtime_scene is Some(scene) &&
            scene.entity_ids.contains(selected) => {
            let drag_ids = selected_entity_ids_for_drag(scene, selected)
            let start_transforms = selected_drag_start_transforms(
              scene, drag_ids,
            )
            let start_transform = start_transforms
              .get(selected)
              .unwrap_or(entity_transform2d(scene.entity_ids[selected]))
            if hovered is Some(hovered_id) && drag_ids.contains(hovered_id) {
              let pivot_world = selected_pivot_world().unwrap_or(
                @math.Vec2(
                  start_transform.translation.x,
                  start_transform.translation.y,
                ),
              )
              preview_state.tool_drag = Some({
                entity_id: selected,
                entity_ids: drag_ids,
                tool: @shared.preview_tool_translate(),
                anchor_world: world_point,
                anchor_pointer: @inputs.mouse.pos,
                pivot_world,
                start_transforms,
              })
              emit_preview_event(
                @bridge.preview_event_transform_gesture_started(selected),
              )
            } else if hovered is Some(hovered_id) {
              set_selected_ids_and_emit([hovered_id])
            } else {
              ()
            }
          }
          _ =>
            match hovered {
              Some(id) => set_selected_ids_and_emit([id])
              None => set_selected_ids_and_emit([])
            }
        }
      @shared.Rotate =>
        if preview_state.selected_entity_id is Some(selected) &&
          preview_state.runtime_scene is Some(scene) &&
          scene.entity_ids.contains(selected) {
          let drag_ids = selected_entity_ids_for_drag(scene, selected)
          if !(hovered is Some(hovered_id) && drag_ids.contains(hovered_id)) {
            match hovered {
              Some(id) => set_selected_ids_and_emit([id])
              None => set_selected_ids_and_emit([])
            }
            return
          }
          let start_transforms = selected_drag_start_transforms(scene, drag_ids)
          let start_transform = start_transforms
            .get(selected)
            .unwrap_or(entity_transform2d(scene.entity_ids[selected]))
          let pivot_world = selected_pivot_world().unwrap_or(
            @math.Vec2(
              start_transform.translation.x,
              start_transform.translation.y,
            ),
          )
          preview_state.tool_drag = Some({
            entity_id: selected,
            entity_ids: drag_ids,
            tool: @shared.preview_tool_rotate(),
            anchor_world: world_point,
            anchor_pointer: @inputs.mouse.pos,
            pivot_world,
            start_transforms,
          })
          emit_preview_event(
            @bridge.preview_event_transform_gesture_started(selected),
          )
        } else {
          match hovered {
            Some(id) => set_selected_ids_and_emit([id])
            None => set_selected_ids_and_emit([])
          }
        }
      @shared.Scale =>
        if preview_state.selected_entity_id is Some(selected) &&
          preview_state.runtime_scene is Some(scene) &&
          scene.entity_ids.contains(selected) {
          let drag_ids = selected_entity_ids_for_drag(scene, selected)
          if !(hovered is Some(hovered_id) && drag_ids.contains(hovered_id)) {
            match hovered {
              Some(id) => set_selected_ids_and_emit([id])
              None => set_selected_ids_and_emit([])
            }
            return
          }
          let start_transforms = selected_drag_start_transforms(scene, drag_ids)
          let start_transform = start_transforms
            .get(selected)
            .unwrap_or(entity_transform2d(scene.entity_ids[selected]))
          let pivot_world = selected_pivot_world().unwrap_or(
            @math.Vec2(
              start_transform.translation.x,
              start_transform.translation.y,
            ),
          )
          preview_state.tool_drag = Some({
            entity_id: selected,
            entity_ids: drag_ids,
            tool: @shared.preview_tool_scale(),
            anchor_world: world_point,
            anchor_pointer: @inputs.mouse.pos,
            pivot_world,
            start_transforms,
          })
          emit_preview_event(
            @bridge.preview_event_transform_gesture_started(selected),
          )
        } else {
          match hovered {
            Some(id) => set_selected_ids_and_emit([id])
            None => set_selected_ids_and_emit([])
          }
        }
      _ =>
        match hovered {
          Some(id) => set_selected_ids_and_emit([id])
          None => set_selected_ids_and_emit([])
        }
    }
  } else if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) &&
    preview_state.active_tool != @shared.preview_tool_select() {
    preview_debug(
      "ignored left pick outside canvas, mouse=" +
      @inputs.mouse.pos[X].to_string() +
      "," +
      @inputs.mouse.pos[Y].to_string(),
    )
  }
  if (
      @inputs.is_mouse_just_released(@inputs.MouseButton::Left) ||
      !@inputs.mouse.left_button
    ) &&
    preview_state.tool_drag is Some(drag_state) {
    emit_preview_event(
      @bridge.preview_event_transform_gesture_finished(drag_state.entity_id),
    )
    preview_state.tool_drag = None
  }
  if @inputs.mouse.left_button &&
    preview_state.tool_drag is Some(drag_state) &&
    preview_state.runtime_scene is Some(_scene) {
    if !pointer_drag_started(drag_state.anchor_pointer) {
      return
    }
    let start_angle = point_angle(
      drag_state.pivot_world,
      drag_state.anchor_world,
    )
    let current_angle = point_angle(drag_state.pivot_world, world_point)
    let rotation_delta = shortest_angle_delta(start_angle, current_angle)
    let snapped_rotation_delta = if @inputs.is_pressed(@inputs.ShiftLeft) {
      let step = @cmath.PI / 12.0
      (rotation_delta / step).round() * step
    } else {
      rotation_delta
    }
    let cos_delta = @cmath.cos(snapped_rotation_delta)
    let sin_delta = @cmath.sin(snapped_rotation_delta)
    let start_distance = distance_between(
      drag_state.pivot_world,
      drag_state.anchor_world,
    )
    let current_distance = distance_between(drag_state.pivot_world, world_point)
    let scale_factor = if start_distance <= 0.001 {
      1.0 + (@inputs.mouse.pos[X] - drag_state.anchor_pointer[X]) * 0.01
    } else {
      current_distance / start_distance
    }
    let clamped_scale_factor = if scale_factor < 0.05 {
      0.05
    } else {
      scale_factor
    }
    let target_world = move_target_world_point(world_point)
    let anchor_world = move_target_world_point(drag_state.anchor_world)
    let translate_delta = target_world - anchor_world
    for id in drag_state.entity_ids {
      guard drag_state.start_transforms.contains(id) else { continue }
      let start = drag_state.start_transforms[id]
      let next_transform = match drag_state.tool {
        @shared.Translate =>
          @editor_bridge.transform2d_value(
            translation=@editor_bridge.vec2_doc(
              start.translation.x + translate_delta[X],
              start.translation.y + translate_delta[Y],
            ),
            rotation=start.rotation,
            scale=start.scale,
          )
        @shared.Rotate => {
          let offset_x = start.translation.x - drag_state.pivot_world[X]
          let offset_y = start.translation.y - drag_state.pivot_world[Y]
          let rotated_x = offset_x * cos_delta - offset_y * sin_delta
          let rotated_y = offset_x * sin_delta + offset_y * cos_delta
          @editor_bridge.transform2d_value(
            translation=@editor_bridge.vec2_doc(
              drag_state.pivot_world[X] + rotated_x,
              drag_state.pivot_world[Y] + rotated_y,
            ),
            rotation=start.rotation + snapped_rotation_delta,
            scale=start.scale,
          )
        }
        @shared.Scale => {
          let offset_x = start.translation.x - drag_state.pivot_world[X]
          let offset_y = start.translation.y - drag_state.pivot_world[Y]
          @editor_bridge.transform2d_value(
            translation=@editor_bridge.vec2_doc(
              drag_state.pivot_world[X] + offset_x * clamped_scale_factor,
              drag_state.pivot_world[Y] + offset_y * clamped_scale_factor,
            ),
            rotation=start.rotation,
            scale=@editor_bridge.vec2_doc(
              clamp_scale_value(start.scale.x * clamped_scale_factor),
              clamp_scale_value(start.scale.y * clamped_scale_factor),
            ),
          )
        }
        _ => start
      }
      apply_runtime_transform(id, next_transform)
      emit_preview_event(
        @bridge.preview_event_transform_changed(
          id,
          next_transform.translation,
          next_transform.rotation,
          next_transform.scale,
        ),
      )
    }
  }
}

///|
pub fn bootstrap() -> Unit {
  if preview_state.bootstrapped {
    return
  }
  preview_state.bootstrapped = true
  let initial_viewport = resolved_canvas_client_size()
  preview_state.viewport_width = initial_viewport[X]
  preview_state.viewport_height = initial_viewport[Y]
  sync_canvas_backing_size(initial_viewport[X], initial_viewport[Y])
  @app.App::new()
  .with_viewport_width(initial_viewport[X])
  .with_viewport_height(initial_viewport[Y])
  .with_image_smooth(false)
  .add_plugin(@plugins.default_plugin)
  .add_system(@system.Startup, preview_startup_system)
  .add_system(@system.Update, preview_viewport_sync_system)
  .add_system(@system.Update, preview_scene_sync_system)
  .add_system(@system.Update, preview_camera_control_system)
  .add_system(@system.Update, preview_snap_grid_overlay_system)
  .add_system(@system.Update, preview_pick_system)
  .run()
}
