///|
pub fn register_snapshot_provider(
  name : String,
  provider : SnapshotProvider,
) -> Unit {
  snapshot_providers.set(name, provider)
}

///|
pub fn unregister_snapshot_provider(name : String) -> Unit {
  snapshot_providers.remove(name)
}

///|
pub fn world_snapshot() -> WorldSnapshot {
  let world = current_world()
  let entities : Array[EntitySnapshot] = []
  for entity in @entity.iter_entities() {
    if !entity.is_alive() {
      continue
    }
    entities.push({
      entity_id: entity.id(),
      name: @name.name_of(entity),
      transform: @transform.transforms().get(entity),
      global_transform: @transform.global_transforms().get(entity),
      visibility: @visibility.visibilities().get(entity),
      sprite: @sprite.sprites().get(entity),
      rigid_body2d: @physics2d.rigid_bodies().get(entity),
      collider2d: @physics2d.colliders().get(entity),
      linear_velocity2d: @physics2d.linear_velocities().get(entity),
    })
  }
  entities.sort_by(fn(lhs, rhs) {
    if lhs.entity_id < rhs.entity_id {
      -1
    } else if lhs.entity_id > rhs.entity_id {
      1
    } else {
      0
    }
  })
  let custom_fields : Array[(String, String)] = []
  for key, provider in snapshot_providers {
    custom_fields.push((key, provider(world)))
  }
  custom_fields.sort_by(fn(lhs, rhs) {
    if lhs.0 < rhs.0 {
      -1
    } else if lhs.0 > rhs.0 {
      1
    } else {
      0
    }
  })
  {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    entities,
    custom_fields,
  }
}

///|
fn debug_vec2(value : @math.Vec2) -> DebugVec2 {
  { x: value[@math.X], y: value[@math.Y] }
}

///|
fn debug_vec3(value : @math.Vec3) -> DebugVec3 {
  { x: value.x, y: value.y, z: value.z }
}

///|
fn debug_rect(value : @math.Rect) -> DebugRect {
  {
    x: value.position[@math.X],
    y: value.position[@math.Y],
    width: value.size[@math.X],
    height: value.size[@math.Y],
  }
}

///|
fn debug_color(value : @render.Color) -> DebugColor {
  { r: value.r, g: value.g, b: value.b, a: value.a }
}

///|
fn sprite_source_rect(sprite : @sprite.Sprite) -> @math.Rect? {
  match sprite.texture_atlas {
    Some(texture_atlas) => @sprite.texture_atlas_rect(texture_atlas)
    None => sprite.rect
  }
}

///|
fn sprite_destination_size(sprite : @sprite.Sprite) -> @math.Vec2? {
  match sprite.custom_size {
    Some(size) => Some(size)
    None => sprite_source_rect(sprite).map(fn(rect) { rect.size })
  }
}

///|
pub fn sprite_inspector_entries() -> Array[SpriteInspectorEntry] {
  let entries : Array[SpriteInspectorEntry] = []
  for entity, sprite in @sprite.sprites() {
    if !entity.is_alive() {
      continue
    }
    let image_path = match sprite.image {
      Some(image) => @asset.image_path(image)
      None => None
    }
    let source_rect = sprite_source_rect(sprite).map(debug_rect)
    let destination_size = sprite_destination_size(sprite).map(debug_vec2)
    let anchor = debug_vec2(sprite.anchor.as_vec())
    let local_translation = @transform.transforms()
      .get(entity)
      .map(fn(transform) { debug_vec3(transform.translation) })
    let world_translation = @transform.global_transforms()
      .get(entity)
      .map(fn(transform) { debug_vec3(transform.translation()) })
    entries.push({
      entity_id: entity.id(),
      entity_name: @name.name_of(entity),
      visible: @visibility.is_visible(entity),
      image_path,
      source_rect,
      destination_size,
      anchor,
      flip_x: sprite.flip_x,
      flip_y: sprite.flip_y,
      local_translation,
      world_translation,
    })
  }
  entries.sort_by(fn(lhs, rhs) {
    if lhs.entity_id < rhs.entity_id {
      -1
    } else if lhs.entity_id > rhs.entity_id {
      1
    } else {
      0
    }
  })
  entries
}

///|
pub fn atlas_overlay_entries() -> Array[AtlasOverlayEntry] {
  let entries : Array[AtlasOverlayEntry] = []
  guard latest_render_submission() is Some(submission) else { return entries }
  for item in submission.draw2d {
    guard item.texture_path is Some(texture_path) else { continue }
    guard item.uv_rect is Some(source_rect) else { continue }
    entries.push({
      entity_id: item.entity_id,
      layer: item.layer,
      texture_path,
      source_rect: debug_rect(source_rect),
      destination_rect: item.destination_rect.map(debug_rect),
    })
  }
  entries
}

///|
fn atlas_overlay_fill_color() -> @render.Color {
  { r: 255U, g: 64U, b: 160U, a: 0.08 }
}

///|
fn atlas_overlay_stroke_color() -> @render.Color {
  { r: 255U, g: 64U, b: 160U, a: 0.95 }
}

///|
fn atlas_overlay_from_draw_command(
  command : @render2d_types.DrawCommand2D,
) -> @render2d_types.DrawCommand2D? {
  match command {
    Image(image) =>
      if image.source is Some(_) {
        Some(
          Rect({
            rect: image.destination,
            transform: image.transform,
            fill_color: atlas_overlay_fill_color(),
            stroke_color: Some(atlas_overlay_stroke_color()),
          }),
        )
      } else {
        None
      }
    _ => None
  }
}

///|
pub fn decorate_frame_for_debug(
  frame : @render_pipeline.RenderFrame,
  world_commands : Array[@render2d.DrawCommandWithDepth2D],
) -> @render_pipeline.RenderFrame {
  if !atlas_overlay_enabled() {
    return frame
  }
  let overlays : Array[@render2d_types.DrawCommand2D] = []
  for command in world_commands {
    if atlas_overlay_from_draw_command(command.command) is Some(overlay) {
      overlays.push(overlay)
    }
  }
  for command in frame.frame2d.ui_commands {
    if atlas_overlay_from_draw_command(command) is Some(overlay) {
      overlays.push(overlay)
    }
  }
  if overlays.length() == 0 {
    return frame
  }
  let ui_commands = frame.frame2d.ui_commands.copy()
  for overlay in overlays {
    ui_commands.push(overlay)
  }
  let passes = frame.frame2d.passes.copy()
  if !passes.is_empty() {
    let pass = passes[passes.length() - 1]
    for overlay in overlays {
      pass.ui_commands.push(overlay)
    }
  }
  { ..frame, frame2d: { ..frame.frame2d, passes, ui_commands } }
}
