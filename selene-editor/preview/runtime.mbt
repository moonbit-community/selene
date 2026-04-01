///|
priv struct ToolDragState {
  entity_id : String
  tool : @shared.PreviewTool
  anchor_world : @math.Vec2D
  anchor_pointer : @math.Vec2D
  pivot_world : @math.Vec2D
  start_transform : @editor_bridge.Transform2dComponent
}

///|
priv struct PreviewState {
  mut bootstrapped : Bool
  mut pending_scene : @bridge.PreviewScenePayload?
  mut current_scene_path : String?
  mut current_scene : @editor_bridge.SceneDocument?
  mut runtime_scene : @editor_bridge.SceneRuntime?
  mut selected_entity_id : String?
  mut hovered_entity_id : String?
  mut active_tool : @shared.PreviewTool
  mut move_snap_enabled : Bool
  mut move_snap_step : Double
  mut camera_entity : @entity.Entity?
  mut selection_overlay : @entity.Entity?
  mut pivot_overlay : @entity.Entity?
  mut pending_frame_selection : Bool
  mut tool_drag : ToolDragState?
  mut camera_pan_anchor : @math.Vec2D?
  mut event_sink : ((@bridge.PreviewEvent) -> Unit)?
  mut initial_scene_aligned : Bool
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
    hovered_entity_id: None,
    active_tool: @shared.preview_tool_select(),
    move_snap_enabled: false,
    move_snap_step: 16.0,
    camera_entity: None,
    selection_overlay: None,
    pivot_overlay: None,
    pending_frame_selection: false,
    tool_drag: None,
    camera_pan_anchor: None,
    event_sink: None,
    initial_scene_aligned: false,
  }
}

///|
let preview_state : PreviewState = PreviewState::new()

///|
let editor_viewport_width = 960.0

///|
let editor_viewport_height = 540.0

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
fn normalized_mouse_position() -> @math.Vec2D {
  let size = canvas_client_size()
  let client_width = if size.length() > 0 && size[0] > 0.0 {
    size[0]
  } else {
    editor_viewport_width
  }
  let client_height = if size.length() > 1 && size[1] > 0.0 {
    size[1]
  } else {
    editor_viewport_height
  }
  @math.Vec2D(
    @inputs.mouse.pos[X] * editor_viewport_width / client_width,
    @inputs.mouse.pos[Y] * editor_viewport_height / client_height,
  )
}

///|
fn inside_editor_viewport(point : @math.Vec2D) -> Bool {
  point[X] >= 0.0 &&
  point[X] <= editor_viewport_width &&
  point[Y] >= 0.0 &&
  point[Y] <= editor_viewport_height
}

///|
fn mouse_to_viewport_delta(delta : @math.Vec2D) -> @math.Vec2D {
  let size = canvas_client_size()
  let client_width = if size.length() > 0 && size[0] > 0.0 {
    size[0]
  } else {
    editor_viewport_width
  }
  let client_height = if size.length() > 1 && size[1] > 0.0 {
    size[1]
  } else {
    editor_viewport_height
  }
  @math.Vec2D(
    delta[X] * editor_viewport_width / client_width,
    delta[Y] * editor_viewport_height / client_height,
  )
}

///|
fn pointer_drag_started(anchor : @math.Vec2D) -> Bool {
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
fn point_angle(center : @math.Vec2D, point : @math.Vec2D) -> Double {
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
fn distance_between(a : @math.Vec2D, b : @math.Vec2D) -> Double {
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
fn snap_to_move_grid(point : @math.Vec2D) -> @math.Vec2D {
  let grid = if preview_state.move_snap_step > 0.0 {
    preview_state.move_snap_step
  } else {
    16.0
  }
  @math.Vec2D(
    (point[X] / grid).round() * grid,
    (point[Y] / grid).round() * grid,
  )
}

///|
fn move_target_world_point(point : @math.Vec2D) -> @math.Vec2D {
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
pub fn select_entity(id : String?) -> Unit {
  preview_state.selected_entity_id = id
}

///|
pub fn set_tool(tool : @shared.PreviewTool) -> Unit {
  preview_state.active_tool = tool
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
fn overlay_bounds() -> (@math.Vec2D, @math.Vec2D)? {
  guard preview_state.current_scene is Some(scene) else { return None }
  guard preview_state.selected_entity_id is Some(id) else { return None }
  guard scene.entity(id) is Some(document) else { return None }
  let transform = @editor_bridge.decoded_transform(document)
  document_visual_bounds(document, transform)
}

///|
fn document_visual_bounds(
  document : @editor_bridge.EntityDocument,
  transform : @editor_bridge.Transform2dComponent,
) -> (@math.Vec2D, @math.Vec2D)? {
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
      (@math.Vec2D(min_x, min_y), @math.Vec2D(scaled_width, scaled_height)),
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
      (@math.Vec2D(min_x, min_y), @math.Vec2D(scaled_width, scaled_height)),
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
        @math.Vec2D(radius * 2.0, radius * 2.0)
      }
      _ =>
        @math.Vec2D(
          mesh_data.size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)).x,
          mesh_data.size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)).y,
        )
    }
    let scaled_width = size[X] * transform.scale.x.abs()
    let scaled_height = size[Y] * transform.scale.y.abs()
    let min_x = transform.translation.x - scaled_width * 0.5
    let min_y = transform.translation.y - scaled_height * 0.5
    return Some(
      (@math.Vec2D(min_x, min_y), @math.Vec2D(scaled_width, scaled_height)),
    )
  }
  Some(
    (
      @math.Vec2D(transform.translation.x, transform.translation.y),
      @math.Vec2D(0.0, 0.0),
    ),
  )
}

///|
fn scene_visual_bounds() -> (@math.Vec2D, @math.Vec2D)? {
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
    Some((@math.Vec2D(min_x, min_y), @math.Vec2D(max_x - min_x, max_y - min_y)))
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
  let view_width = editor_viewport_width * projection.scale
  let view_height = editor_viewport_height * projection.scale
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
  let view_width = editor_viewport_width * projection.scale
  let view_height = editor_viewport_height * projection.scale
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
fn selected_pivot_world() -> @math.Vec2D? {
  guard preview_state.current_scene is Some(scene) else { return None }
  guard preview_state.selected_entity_id is Some(id) else { return None }
  guard scene.entity(id) is Some(document) else { return None }
  let transform = @editor_bridge.decoded_transform(document)
  Some(@math.Vec2D(transform.translation.x, transform.translation.y))
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
  match overlay_bounds() {
    Some((position, size)) => {
      let color = if preview_state.tool_drag is Some(_) {
        @render.Color::{ r: 92U, g: 196U, b: 255U, a: 0.24 }
      } else if preview_state.hovered_entity_id ==
        preview_state.selected_entity_id {
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
        @sprite.Sprite::from_color(color, @math.Vec2D(1.0, 1.0)),
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
        @sprite.Sprite::from_color(color, @math.Vec2D(1.0, 1.0)),
      )
    }
    None => @visibility.visibilities().set(overlay, @visibility.Hidden)
  }
}

///|
fn editor_camera_entity() -> @entity.Entity? {
  preview_state.camera_entity
}

///|
fn world_point_from_mouse() -> @math.Vec2D? {
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
  let viewport_point = @math.Vec2D(
    x * editor_viewport_width / viewport_width,
    y * editor_viewport_height / viewport_height,
  )
  let world_point = camera_.viewport_to_world_2d(
    global, projection, viewport_point,
  )
  Some(@editor_bridge.vec2_doc(world_point[X], world_point[Y]))
}

///|
fn pick_entity_id_at(point : @math.Vec2D) -> String? {
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
          let center = @math.Vec2D(
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
fn frame_selection_impl() -> Unit {
  guard preview_state.pending_frame_selection else { return }
  preview_state.pending_frame_selection = false
  guard editor_camera_entity() is Some(camera_entity) else { return }
  guard overlay_bounds() is Some((position, size)) else { return }
  let center = @math.Vec2D(
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
      @math.Vec2D(1.0, 1.0),
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
      @math.Vec2D(1.0, 1.0),
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
fn preview_pick_system(_world : @ecs.World) -> Unit {
  guard world_point_from_mouse() is Some(world_point) else { return }
  let pointer_inside = pointer_over_canvas() &&
    inside_editor_viewport(normalized_mouse_position())
  let hovered = if pointer_inside {
    pick_entity_id_at(world_point)
  } else {
    None
  }
  if hovered != preview_state.hovered_entity_id {
    preview_state.hovered_entity_id = hovered
    emit_preview_event(@bridge.preview_event_hover_changed(hovered))
  }
  let cursor = if pointer_pan_active() {
    "grabbing"
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
        if preview_state.selected_entity_id is Some(selected) &&
          hovered == Some(selected) {
          "move"
        } else if hovered is Some(_) {
          "pointer"
        } else if preview_state.selected_entity_id is Some(_) {
          "crosshair"
        } else {
          "default"
        }
      @shared.Rotate => "crosshair"
      @shared.Scale => "nwse-resize"
    }
  }
  set_canvas_cursor(cursor)
  if pointer_pan_active() {
    preview_state.tool_drag = None
    return
  }
  if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) && pointer_inside {
    match preview_state.active_tool {
      @shared.Translate =>
        match preview_state.selected_entity_id {
          Some(selected) if preview_state.runtime_scene is Some(scene) &&
            scene.entity_ids.contains(selected) => {
            let selected_entity = scene.entity_ids[selected]
            let start_transform = entity_transform2d(selected_entity)
            if hovered == Some(selected) {
              let pivot_world = selected_pivot_world().unwrap_or(
                @math.Vec2D(
                  start_transform.translation.x,
                  start_transform.translation.y,
                ),
              )
              preview_state.tool_drag = Some({
                entity_id: selected,
                tool: @shared.preview_tool_translate(),
                anchor_world: world_point,
                anchor_pointer: @inputs.mouse.pos,
                pivot_world,
                start_transform,
              })
              emit_preview_event(
                @bridge.preview_event_transform_gesture_started(selected),
              )
            } else if hovered is Some(hovered_id) {
              preview_state.selected_entity_id = Some(hovered_id)
              emit_preview_event(
                @bridge.preview_event_entity_picked(Some(hovered_id)),
              )
            } else {
              let target = move_target_world_point(world_point)
              let next_transform = @editor_bridge.transform2d_value(
                translation=@editor_bridge.vec2_doc(target[X], target[Y]),
                rotation=start_transform.rotation,
                scale=start_transform.scale,
              )
              emit_preview_event(
                @bridge.preview_event_transform_gesture_started(selected),
              )
              apply_runtime_transform(selected, next_transform)
              emit_preview_event(
                @bridge.preview_event_transform_changed(
                  selected,
                  next_transform.translation,
                  next_transform.rotation,
                  next_transform.scale,
                ),
              )
              emit_preview_event(
                @bridge.preview_event_transform_gesture_finished(selected),
              )
            }
          }
          _ => {
            preview_state.selected_entity_id = hovered
            emit_preview_event(@bridge.preview_event_entity_picked(hovered))
          }
        }
      @shared.Rotate =>
        if preview_state.selected_entity_id is Some(selected) &&
          hovered == Some(selected) &&
          preview_state.runtime_scene is Some(scene) &&
          scene.entity_ids.contains(selected) {
          let start_transform = entity_transform2d(scene.entity_ids[selected])
          let pivot_world = selected_pivot_world().unwrap_or(
            @math.Vec2D(
              start_transform.translation.x,
              start_transform.translation.y,
            ),
          )
          preview_state.tool_drag = Some({
            entity_id: selected,
            tool: @shared.preview_tool_rotate(),
            anchor_world: world_point,
            anchor_pointer: @inputs.mouse.pos,
            pivot_world,
            start_transform,
          })
          emit_preview_event(
            @bridge.preview_event_transform_gesture_started(selected),
          )
        } else {
          preview_state.selected_entity_id = hovered
          emit_preview_event(@bridge.preview_event_entity_picked(hovered))
        }
      @shared.Scale =>
        if preview_state.selected_entity_id is Some(selected) &&
          hovered == Some(selected) &&
          preview_state.runtime_scene is Some(scene) &&
          scene.entity_ids.contains(selected) {
          let start_transform = entity_transform2d(scene.entity_ids[selected])
          let pivot_world = selected_pivot_world().unwrap_or(
            @math.Vec2D(
              start_transform.translation.x,
              start_transform.translation.y,
            ),
          )
          preview_state.tool_drag = Some({
            entity_id: selected,
            tool: @shared.preview_tool_scale(),
            anchor_world: world_point,
            anchor_pointer: @inputs.mouse.pos,
            pivot_world,
            start_transform,
          })
          emit_preview_event(
            @bridge.preview_event_transform_gesture_started(selected),
          )
        } else {
          preview_state.selected_entity_id = hovered
          emit_preview_event(@bridge.preview_event_entity_picked(hovered))
        }
      _ => {
        preview_state.selected_entity_id = hovered
        emit_preview_event(@bridge.preview_event_entity_picked(hovered))
      }
    }
  } else if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) {
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
    preview_state.runtime_scene is Some(scene) &&
    scene.entity_ids.contains(drag_state.entity_id) {
    if !pointer_drag_started(drag_state.anchor_pointer) {
      return
    }
    let start = drag_state.start_transform
    let next_transform = match drag_state.tool {
      @shared.Translate => {
        let target_world = move_target_world_point(world_point)
        let anchor_world = move_target_world_point(drag_state.anchor_world)
        let delta = target_world - anchor_world
        @editor_bridge.transform2d_value(
          translation=@editor_bridge.vec2_doc(
            start.translation.x + delta[X],
            start.translation.y + delta[Y],
          ),
          rotation=start.rotation,
          scale=start.scale,
        )
      }
      @shared.Rotate => {
        let start_angle = point_angle(
          drag_state.pivot_world,
          drag_state.anchor_world,
        )
        let current_angle = point_angle(drag_state.pivot_world, world_point)
        let rotation_delta = shortest_angle_delta(start_angle, current_angle)
        let snapped_delta = if @inputs.is_pressed(@inputs.ShiftLeft) {
          let step = @cmath.PI / 12.0
          (rotation_delta / step).round() * step
        } else {
          rotation_delta
        }
        @editor_bridge.transform2d_value(
          translation=start.translation,
          rotation=start.rotation + snapped_delta,
          scale=start.scale,
        )
      }
      @shared.Scale => {
        let start_distance = distance_between(
          drag_state.pivot_world,
          drag_state.anchor_world,
        )
        let current_distance = distance_between(
          drag_state.pivot_world,
          world_point,
        )
        let factor = if start_distance <= 0.001 {
          1.0 + (@inputs.mouse.pos[X] - drag_state.anchor_pointer[X]) * 0.01
        } else {
          current_distance / start_distance
        }
        let clamped_factor = if factor < 0.05 { 0.05 } else { factor }
        @editor_bridge.transform2d_value(
          translation=start.translation,
          rotation=start.rotation,
          scale=@editor_bridge.vec2_doc(
            clamp_scale_value(start.scale.x * clamped_factor),
            clamp_scale_value(start.scale.y * clamped_factor),
          ),
        )
      }
      _ => start
    }
    apply_runtime_transform(drag_state.entity_id, next_transform)
    emit_preview_event(
      @bridge.preview_event_transform_changed(
        drag_state.entity_id,
        next_transform.translation,
        next_transform.rotation,
        next_transform.scale,
      ),
    )
  }
}

///|
pub fn bootstrap() -> Unit {
  if preview_state.bootstrapped {
    return
  }
  preview_state.bootstrapped = true
  @app.App::new()
  .with_viewport_width(editor_viewport_width)
  .with_viewport_height(editor_viewport_height)
  .with_image_smooth(false)
  .add_plugin(@plugins.default_plugin)
  .add_system(@system.Startup, preview_startup_system)
  .add_system(@system.Update, preview_scene_sync_system)
  .add_system(@system.Update, preview_camera_control_system)
  .add_system(@system.Update, preview_pick_system)
  .run()
}
