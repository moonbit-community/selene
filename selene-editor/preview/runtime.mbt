///|
priv struct PreviewState {
  mut bootstrapped : Bool
  mut pending_scene : @shared.SceneDocument?
  mut current_scene : @shared.SceneDocument?
  mut selected_entity_id : String?
  mut hovered_entity_id : String?
  mut active_tool : @shared.PreviewTool
  mut entity_ids : Map[String, @entity.Entity]
  mut tracked_entities : Array[@entity.Entity]
  mut atlas_layouts : Array[@sprite.TextureAtlasLayoutHandle]
  mut material_handles : Array[@material2d.ColorMaterialHandle]
  mut mesh_handles : Array[@mesh2d.Mesh2dHandle]
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
    selected_entity_id: None,
    hovered_entity_id: None,
    active_tool: @shared.preview_tool_select(),
    entity_ids: {},
    tracked_entities: [],
    atlas_layouts: [],
    material_handles: [],
    mesh_handles: [],
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
fn vec2_of(doc : @shared.Vec2Doc) -> @math.Vec2D {
  @math.Vec2D(doc.x, doc.y)
}

///|
fn color_of(doc : @shared.ColorDoc) -> @render.Color {
  @render.Color::{
    r: doc.r.reinterpret_as_uint(),
    g: doc.g.reinterpret_as_uint(),
    b: doc.b.reinterpret_as_uint(),
    a: doc.a.to_double() / 255.0,
  }
}

///|
fn rect_of(doc : @shared.RectDoc) -> @math.Rect {
  @math.Rect::{
    position: @math.Vec2D(doc.x, doc.y),
    size: @math.Vec2D(doc.width, doc.height),
  }
}

///|
fn anchor_of(doc : @shared.Vec2Doc) -> @sprite.Anchor {
  @sprite.Anchor(@math.Vec2D(doc.x, doc.y))
}

///|
fn basename_of(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn[T : FromJson] decode_component(component : @shared.ComponentDocument?) -> T? {
  match component {
    Some(value) => Some(@json.from_json(value.data)) catch { _ => None }
    None => None
  }
}

///|
fn decoded_transform(
  document : @shared.EntityDocument,
) -> @shared.Transform2dComponent {
  decode_component(document.component("Transform2d")).unwrap_or(
    @shared.transform2d_value(),
  )
}

///|
fn sprite_doc_size(
  sprite_data : @shared.SpriteComponent,
  atlas_size : @shared.Vec2Doc?,
) -> @shared.Vec2Doc {
  match sprite_data.custom_size {
    Some(size) => size
    None =>
      match atlas_size {
        Some(size) => size
        None =>
          match sprite_data.rect {
            Some(rect) => @shared.vec2_doc(rect.width, rect.height)
            None => @shared.vec2_doc(32.0, 32.0)
          }
      }
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
pub fn load_scene(scene : @shared.SceneDocument) -> Unit {
  preview_state.pending_scene = Some(scene)
}

///|
pub fn clear_scene() -> Unit {
  preview_state.pending_scene = Some(@shared.SceneDocument::empty())
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
fn clear_entity_components(entity : @entity.Entity) -> Unit {
  @transform.transforms().remove(entity) |> ignore
  @transform.global_transforms().remove(entity) |> ignore
  @visibility.visibilities().remove(entity) |> ignore
  @sprite.sprites().remove(entity) |> ignore
  @mesh2d.mesh2ds().remove(entity) |> ignore
  @material2d.mesh_material2ds().remove(entity) |> ignore
  @text2d.text2ds().remove(entity) |> ignore
  @text2d.text_bounds().remove(entity) |> ignore
  @text2d.text_anchors().remove(entity) |> ignore
  @ui.texts().remove(entity) |> ignore
  @ui.text_fonts().remove(entity) |> ignore
  @ui.text_colors().remove(entity) |> ignore
  @ui.text_layouts().remove(entity) |> ignore
  entity.remove_parent()
  entity.destroy()
}

///|
fn clear_runtime_scene() -> Unit {
  for entity in preview_state.tracked_entities {
    clear_entity_components(entity)
  }
  for handle in preview_state.atlas_layouts {
    @sprite.release_texture_atlas_layout(handle)
  }
  for handle in preview_state.material_handles {
    @material2d.release_color_material(handle)
  }
  for handle in preview_state.mesh_handles {
    @mesh2d.release_mesh2d_asset(handle)
  }
  preview_state.entity_ids = {}
  preview_state.tracked_entities = []
  preview_state.atlas_layouts = []
  preview_state.material_handles = []
  preview_state.mesh_handles = []
}

///|
fn spawn_scene_entities(scene : @shared.SceneDocument) -> Unit {
  clear_runtime_scene()
  for document in scene.entities {
    let entity = @entity.Entity::new()
    preview_state.entity_ids.set(document.id, entity)
    preview_state.tracked_entities.push(entity)
  }
  for document in scene.entities {
    match document.parent {
      Some(parent_id) =>
        if preview_state.entity_ids.contains(parent_id) {
          preview_state.entity_ids[document.id].set_parent(
            preview_state.entity_ids[parent_id],
          )
        }
      None => ()
    }
  }
  for document in scene.entities {
    let entity = preview_state.entity_ids[document.id]
    apply_document_components(entity, document)
  }
}

///|
fn apply_document_components(
  entity : @entity.Entity,
  document : @shared.EntityDocument,
) -> Unit {
  let atlas_doc : @shared.TextureAtlasComponent? = decode_component(
    document.component("TextureAtlas"),
  )
  let mesh_doc : @shared.Mesh2dComponent? = decode_component(
    document.component("Mesh2d"),
  )
  let material_doc : @shared.ColorMaterialComponent? = decode_component(
    document.component("ColorMaterial"),
  )

  for component in document.components {
    match component.kind {
      "Transform2d" => {
        let data : @shared.Transform2dComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @transform.transforms().set(
          entity,
          @transform.Transform::from_xyz(
            data.translation.x,
            data.translation.y,
            0.0,
          )
          .with_rotation(
            @math.Quat::from_axis_angle(@math.Vec3::z_axis(), data.rotation),
          )
          .with_scale(@math.Vec3::new(data.scale.x, data.scale.y, 1.0)),
        )
      }
      "Visibility" => {
        let data : @shared.VisibilityComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @visibility.visibilities().set(
          entity,
          if data.visible {
            @visibility.Visible
          } else {
            @visibility.Hidden
          },
        )
      }
      "Sprite" => {
        let data : @shared.SpriteComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        let atlas = atlas_doc.map(fn(atlas_data) {
          let layout = @sprite.register_texture_atlas_layout(
            @sprite.TextureAtlasLayout::from_grid(
              vec2_of(atlas_data.layout.tile_size),
              atlas_data.layout.columns,
              atlas_data.layout.rows,
              padding=Some(vec2_of(atlas_data.layout.padding)),
              offset=Some(vec2_of(atlas_data.layout.offset)),
            ),
          )
          preview_state.atlas_layouts.push(layout)
          @sprite.TextureAtlas::new(layout, index=atlas_data.index)
        })
        let image = resolve_project_asset_path(data.image_path).map(fn(path) {
          @asset.load_image(path)
        })
        @sprite.sprites().set(
          entity,
          @sprite.Sprite::new(
            image~,
            texture_atlas=atlas,
            rect=data.rect.map(rect_of),
            color=color_of(data.color),
            custom_size=data.custom_size.map(vec2_of),
            anchor=anchor_of(data.anchor),
            flip_x=data.flip_x,
            flip_y=data.flip_y,
          ),
        )
      }
      "Text2d" => {
        let data : @shared.Text2dComponent = match
          decode_component(Some(component)) {
          Some(data) => data
          None => continue
        }
        @text2d.text2ds().set(entity, @text2d.Text2d::new())
        @text2d.text_anchors().set(entity, anchor_of(data.anchor))
        match data.bounds {
          Some(bounds) =>
            @text2d.text_bounds().set(
              entity,
              @text2d.TextBounds::new(bounds.x, bounds.y),
            )
          None => ()
        }
        @ui.texts().set(entity, @ui.Text::new(data.content))
        @ui.text_colors().set(entity, @ui.TextColor::new(color_of(data.color)))
        let font = match resolve_project_asset_path(data.font_path) {
          Some(path) =>
            @ui.TextFont::from_font(
              @asset.load_font(path, family=basename_of(path)),
              size=data.font_size,
            )
          None => @ui.TextFont::new(size=data.font_size)
        }
        @ui.text_fonts().set(entity, font)
      }
      "Mesh2d" =>
        if mesh_doc is Some(mesh_data) && material_doc is Some(material_data) {
          let handle = match mesh_data.primitive {
            "rectangle" =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::rectangle(
                  mesh_data.size.unwrap_or(@shared.vec2_doc(32.0, 32.0))
                  |> vec2_of,
                ),
              )
            "circle" =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::circle(mesh_data.radius.unwrap_or(16.0)),
              )
            _ =>
              @mesh2d.register_mesh2d_asset(
                @mesh2d.Mesh2dAsset::rectangle(@math.Vec2D(32.0, 32.0)),
              )
          }
          preview_state.mesh_handles.push(handle)
          let material = @material2d.register_color_material(
            @material2d.ColorMaterial::from_color(color_of(material_data.color)),
          )
          preview_state.material_handles.push(material)
          @mesh2d.mesh2ds().set(entity, @mesh2d.Mesh2d::new(handle))
          @material2d.mesh_material2ds().set(
            entity,
            @material2d.MeshMaterial2d::from_color_material(material),
          )
        }
      _ => ()
    }
  }
  if !@transform.transforms().contains(entity) {
    @transform.transforms().set(entity, @transform.Transform::identity())
  }
  if !@visibility.visibilities().contains(entity) {
    @visibility.visibilities().set(entity, @visibility.Visible)
  }
}

///|
fn entity_transform2d(entity : @entity.Entity) -> @shared.Transform2dComponent {
  match preview_state.current_scene {
    Some(scene) =>
      match entity_id_of(entity) {
        Some(id) =>
          scene
          .entity(id)
          .map_or(@shared.transform2d_value(), decoded_transform)
        None => @shared.transform2d_value()
      }
    None => @shared.transform2d_value()
  }
}

///|
fn entity_id_of(entity : @entity.Entity) -> String? {
  for id, existing in preview_state.entity_ids {
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
  let transform = decoded_transform(document)
  if document.component("Sprite") is Some(component) {
    let sprite_data : @shared.SpriteComponent = match
      decode_component(Some(component)) {
      Some(sprite_data) => sprite_data
      None => return None
    }
    let atlas_data = decode_component(document.component("TextureAtlas")).map(fn(
      atlas : @shared.TextureAtlasComponent,
    ) {
      atlas.layout.tile_size
    })
    let size = sprite_doc_size(sprite_data, atlas_data)
    let anchor = sprite_data.anchor
    let min_x = transform.translation.x - size.x * (anchor.x + 0.5)
    let min_y = transform.translation.y - size.y * (0.5 - anchor.y)
    return Some((@math.Vec2D(min_x, min_y), @math.Vec2D(size.x, size.y)))
  }
  if document.component("Text2d") is Some(component) {
    let text_data : @shared.Text2dComponent = match
      decode_component(Some(component)) {
      Some(text_data) => text_data
      None => return None
    }
    let size = text_data.bounds.unwrap_or(
      @shared.vec2_doc(
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
    let mesh_data : @shared.Mesh2dComponent = match
      decode_component(Some(component)) {
      Some(mesh_data) => mesh_data
      None => return None
    }
    let size = match mesh_data.primitive {
      "circle" => {
        let radius = mesh_data.radius.unwrap_or(16.0)
        @math.Vec2D(radius * 2.0, radius * 2.0)
      }
      _ => mesh_data.size.unwrap_or(@shared.vec2_doc(32.0, 32.0)) |> vec2_of
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
fn pick_entity_id_at(point : @math.Vec2D) -> String? {
  guard preview_state.current_scene is Some(scene) else { return None }
  for document in scene.entities.rev_iter() {
    let transform = decoded_transform(document)
    if document.component("Sprite") is Some(component) {
      let sprite_data : @shared.SpriteComponent = match
        decode_component(Some(component)) {
        Some(sprite_data) => sprite_data
        None => continue
      }
      let atlas_size = decode_component(document.component("TextureAtlas")).map(fn(
          atlas : @shared.TextureAtlasComponent,
        ) {
          atlas.layout.tile_size
        },
      )
      let size = sprite_doc_size(sprite_data, atlas_size)
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
      let mesh_data : @shared.Mesh2dComponent = match
        decode_component(Some(component)) {
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
          let size = mesh_data.size.unwrap_or(@shared.vec2_doc(32.0, 32.0))
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
    preview_state.entity_ids.contains(entity_id) {
    let entity = preview_state.entity_ids[entity_id]
    let current = entity_transform2d(entity)
    let delta = world_point - anchor_point
    let next = @shared.vec2_doc(
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
  .with_viewport_width(960.0)
  .with_viewport_height(540.0)
  .with_image_smooth(false)
  .add_plugin(@plugins.default_plugin)
  .add_system(@system.Startup, preview_startup_system)
  .add_system(@system.Update, preview_scene_sync_system)
  .add_system(@system.Update, preview_camera_control_system)
  .add_system(@system.Update, preview_pick_system)
  .run()
}
