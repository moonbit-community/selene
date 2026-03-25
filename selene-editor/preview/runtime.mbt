///|
priv struct PreviewState {
  mut bootstrapped : Bool
  mut pending_scene : @editor_bridge.SceneDocument?
  mut current_scene : @editor_bridge.SceneDocument?
  mut runtime_scene : @editor_bridge.SceneRuntime?
  mut selected_entity_id : String?
  mut hovered_entity_id : String?
  mut active_tool : @shared.PreviewTool
  mut camera_entity : @entity.Entity?
  mut selection_overlay : @entity.Entity?
  mut pending_frame_selection : Bool
  mut drag_anchor : (@math.Vec2D, String)?
  mut event_sink : ((@bridge.PreviewEvent) -> Unit)?
}

///|
fn PreviewState::new() -> PreviewState {
  {
    bootstrapped: false,
    pending_scene: None,
    current_scene: None,
    runtime_scene: None,
    selected_entity_id: None,
    hovered_entity_id: None,
    active_tool: @shared.preview_tool_select(),
    camera_entity: None,
    selection_overlay: None,
    pending_frame_selection: false,
    drag_anchor: None,
    event_sink: None,
  }
}

///|
let preview_state : PreviewState = PreviewState::new()

///|
let editor_viewport_width = 960.0

///|
let editor_viewport_height = 540.0

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
pub fn load_scene(scene : @editor_bridge.SceneDocument) -> Unit {
  preview_state.pending_scene = Some(scene)
}

///|
pub fn clear_scene() -> Unit {
  preview_state.pending_scene = Some(@editor_bridge.SceneDocument::empty())
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
}

///|
fn spawn_scene_entities(scene : @editor_bridge.SceneDocument) -> Unit {
  clear_runtime_scene()
  preview_state.runtime_scene = Some(
    @editor_bridge.instantiate_scene_document(scene, resolve_project_asset_path),
  )
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
  if document.component("Sprite") is Some(component) {
    let sprite_data : @editor_bridge.SpriteComponent = match
      @editor_bridge.decode_component(Some(component)) {
      Some(sprite_data) => sprite_data
      None => return None
    }
    let atlas_data = @editor_bridge.decode_component(
      document.component("TextureAtlas"),
    ).map(fn(atlas : @editor_bridge.TextureAtlasComponent) {
      atlas.layout.tile_size
    })
    let size = @editor_bridge.sprite_doc_size(sprite_data, atlas_data)
    let anchor = sprite_data.anchor
    let min_x = transform.translation.x - size.x * (anchor.x + 0.5)
    let min_y = transform.translation.y - size.y * (0.5 - anchor.y)
    return Some((@math.Vec2D(min_x, min_y), @math.Vec2D(size.x, size.y)))
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
    let min_x = transform.translation.x - size.x * (text_data.anchor.x + 0.5)
    let min_y = transform.translation.y - size.y * (0.5 - text_data.anchor.y)
    return Some((@math.Vec2D(min_x, min_y), @math.Vec2D(size.x, size.y)))
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
    let min_x = transform.translation.x - size[X] * 0.5
    let min_y = transform.translation.y - size[Y] * 0.5
    return Some((@math.Vec2D(min_x, min_y), size))
  }
  None
}

///|
fn apply_selection_overlay() -> Unit {
  guard preview_state.selection_overlay is Some(overlay) else { return }
  match overlay_bounds() {
    Some((position, size)) => {
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
        @sprite.Sprite::from_color(
          @render.Color::{ r: 255U, g: 220U, b: 64U, a: 0.18 },
          @math.Vec2D(1.0, 1.0),
        ),
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
  Some(camera_.viewport_to_world_2d(global, projection, @inputs.mouse.pos))
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
    global,
    projection,
    viewport_point,
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
        atlas.layout.tile_size
      })
      let size = @editor_bridge.sprite_doc_size(sprite_data, atlas_size)
      let anchor = sprite_data.anchor
      let min_x = transform.translation.x - size.x * (anchor.x + 0.5)
      let min_y = transform.translation.y - size.y * (0.5 - anchor.y)
      if point[X] >= min_x &&
        point[X] <= min_x + size.x &&
        point[Y] >= min_y &&
        point[Y] <= min_y + size.y {
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
          let radius = mesh_data.radius.unwrap_or(16.0)
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
          let min_x = transform.translation.x - size.x * 0.5
          let min_y = transform.translation.y - size.y * 0.5
          if point[X] >= min_x &&
            point[X] <= min_x + size.x &&
            point[Y] >= min_y &&
            point[Y] <= min_y + size.y {
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
}

///|
fn preview_scene_sync_system(_world : @ecs.World) -> Unit {
  if preview_state.pending_scene is Some(scene) {
    spawn_scene_entities(scene)
    preview_state.current_scene = Some(scene)
    preview_state.pending_scene = None
  }
  apply_selection_overlay()
  frame_selection_impl()
}

///|
fn preview_camera_control_system(_world : @ecs.World) -> Unit {
  guard editor_camera_entity() is Some(camera_entity) else { return }
  if @camera.orthographic_projections().get(camera_entity) is Some(projection) &&
    @inputs.mouse_wheel.delta[Y] != 0.0 {
    let raw_scale = projection.scale *
      (1.0 - @inputs.mouse_wheel.delta[Y] * 0.1)
    let next_scale = if raw_scale < 0.1 { 0.1 } else { raw_scale }
    @camera.orthographic_projections().set(camera_entity, {
      ..projection,
      scale: next_scale,
    })
  }
  if @inputs.mouse.middle_button {
    let movement = @inputs.mouse_movement.movement
    if movement != @math.Vec2D::zero() {
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
            transform.translation.y + movement[Y] * projection.scale,
            transform.translation.z,
          ),
        ),
      )
    }
  }
}

///|
fn preview_pick_system(_world : @ecs.World) -> Unit {
  guard world_point_from_mouse() is Some(world_point) else { return }
  let hovered = pick_entity_id_at(world_point)
  if hovered != preview_state.hovered_entity_id {
    preview_state.hovered_entity_id = hovered
    emit_preview_event(@bridge.preview_event_hover_changed(hovered))
  }
  if @inputs.is_mouse_just_pressed(@inputs.MouseButton::Left) {
    match preview_state.active_tool {
      @shared.Translate =>
        if preview_state.selected_entity_id is Some(selected) &&
          hovered == Some(selected) {
          preview_state.drag_anchor = Some((world_point, selected))
        } else {
          preview_state.selected_entity_id = hovered
          emit_preview_event(@bridge.preview_event_entity_picked(hovered))
        }
      _ => {
        preview_state.selected_entity_id = hovered
        emit_preview_event(@bridge.preview_event_entity_picked(hovered))
      }
    }
  }
  if @inputs.is_mouse_just_released(@inputs.MouseButton::Left) {
    preview_state.drag_anchor = None
  }
  if preview_state.active_tool is @shared.Translate &&
    @inputs.mouse.left_button &&
    preview_state.drag_anchor is Some((anchor_point, entity_id)) &&
    preview_state.runtime_scene is Some(scene) &&
    scene.entity_ids.contains(entity_id) {
    let entity = scene.entity_ids[entity_id]
    let current = entity_transform2d(entity)
    let delta = world_point - anchor_point
    let next = @editor_bridge.vec2_doc(
      current.translation.x + delta[X],
      current.translation.y + delta[Y],
    )
    preview_state.drag_anchor = Some((world_point, entity_id))
    emit_preview_event(
      @bridge.preview_event_transform_changed(entity_id, next, current.rotation),
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
