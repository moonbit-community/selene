///|
pub(all) struct DeterministicModeConfig {
  rng_seed : UInt
  fixed_delta_override : Double?
  frame_delta_override : Double?
  deterministic_ordering : Bool
}

///|
pub(all) enum InputInjectionEvent {
  KeyDown(@inputs.Code)
  KeyUp(@inputs.Code)
  MouseMove(@math.Vec2)
  MouseWheel(@math.Vec2)
  MouseLeft(Bool)
  MouseRight(Bool)
  MouseMiddle(Bool)
  GamepadConnected(@inputs.Gamepad, Bool)
  GamepadButton(@inputs.GamepadButtonInput, Bool)
  GamepadAxis(@inputs.GamepadAxisInput, Double)
}

///|
pub(all) struct FramePerformanceMetrics {
  frame_index : UInt
  fixed_step_index : UInt
  fixed_steps_this_frame : Int
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int
  draw2d_count : Int
  draw3d_count : Int
}

///|
pub(all) struct DrawSubmission2DInfo {
  entity_id : UInt?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  uv_rect : @math.Rect?
  destination_rect : @math.Rect?
  transform : @math.Transform?
  color : @render.Color?
}

///|
pub(all) struct DrawSubmission3DInfo {
  entity_id : UInt?
  mesh : @render3d_types.MeshHandle
  material : @render3d_types.MaterialHandle
  cast_shadows : Bool
  receive_shadows : Bool
  translation : @math.Vec3
  scale : @math.Vec3
}

///|
pub(all) struct RenderSubmissionDebug {
  frame_index : UInt
  fixed_step_index : UInt
  draw2d : Array[DrawSubmission2DInfo]
  draw3d : Array[DrawSubmission3DInfo]
}

///|
pub(all) enum AtlasValidationIssueKind {
  InvalidAtlasSize
  InvalidRectSize
  OutOfBounds
  DuplicateRect
  Overlap
  FullyTransparentRect
  TransparencyCheckUnavailable
}

///|
pub(all) struct AtlasValidationIssue {
  kind : AtlasValidationIssueKind
  rect_index : Int?
  other_rect_index : Int?
  message : String
}

///|
pub(all) struct AtlasValidationReport {
  total_rects : Int
  issues : Array[AtlasValidationIssue]
}

///|
pub(all) struct EntitySnapshot {
  entity_id : UInt
  name : String?
  transform : @transform.Transform?
  global_transform : @transform.GlobalTransform?
  visibility : @visibility.Visibility?
  sprite : @sprite.Sprite?
  rigid_body2d : @physics2d.RigidBody?
  collider2d : @physics2d.Collider?
  linear_velocity2d : @physics2d.LinearVelocity?
}

///|
pub(all) struct WorldSnapshot {
  frame_index : UInt
  fixed_step_index : UInt
  entities : Array[EntitySnapshot]
  custom_fields : Array[(String, String)]
}

///|
pub(all) struct DebugVec2 {
  x : Double
  y : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugVec3 {
  x : Double
  y : Double
  z : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugRect {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct DebugColor {
  r : UInt
  g : UInt
  b : UInt
  a : Double
} derive(Eq, Debug, ToJson)

///|
pub(all) struct SpriteInspectorEntry {
  entity_id : UInt
  entity_name : String?
  visible : Bool
  image_path : String?
  source_rect : DebugRect?
  destination_size : DebugVec2?
  anchor : DebugVec2
  flip_x : Bool
  flip_y : Bool
  local_translation : DebugVec3?
  world_translation : DebugVec3?
} derive(Debug, ToJson)

///|
pub(all) struct AtlasOverlayEntry {
  entity_id : UInt?
  layer : String
  texture_path : String
  source_rect : DebugRect
  destination_rect : DebugRect?
} derive(Debug, ToJson)

///|
pub(all) struct DrawSubmission2DMetadataEntry {
  entity_id : UInt?
  layer : String
  kind : String
  depth : Double?
  texture_path : String?
  source_rect : DebugRect?
  destination_rect : DebugRect?
  transform_translation : DebugVec2?
  color : DebugColor?
} derive(Debug, ToJson)

///|
pub(all) struct FramePerformanceMetricsExport {
  frame_index : UInt
  fixed_step_index : UInt
  fixed_steps_this_frame : Int
  update_delta : Double
  fixed_delta_total : Double
  render_delta : Double
  entity_count : Int
  draw2d_count : Int
  draw3d_count : Int
} derive(Eq, Debug, ToJson)

///|
pub(all) struct FrameCaptureMetadata {
  frame_index : UInt
  fixed_step_index : UInt
  metrics : FramePerformanceMetricsExport?
  draw2d : Array[DrawSubmission2DMetadataEntry]
  draw3d_count : Int
  sprites : Array[SpriteInspectorEntry]
  atlas_overlay : Array[AtlasOverlayEntry]
} derive(Debug, ToJson)

///|
pub(all) struct FrameCaptureArtifact {
  frame_index : UInt
  fixed_step_index : UInt
  file_stem : String
  png : Bytes
  metadata_json : String
} derive(Debug)

///|
pub type SnapshotProvider = (@ecs.World) -> String

///|
let deterministic_mode_by_world : Map[UInt, DeterministicModeConfig] = Map::new()

///|
let rng_state_by_world : Map[UInt, UInt] = Map::new()

///|
let queued_inputs_by_world : Map[UInt, Array[@inputs.InputSnapshot]] = Map::new()

///|
let staged_input_by_world : Map[UInt, @inputs.InputSnapshot] = Map::new()

///|
let frame_metrics_by_world : Map[UInt, FramePerformanceMetrics] = Map::new()

///|
let frame_metrics_history_by_world : Map[UInt, Array[FramePerformanceMetrics]] = Map::new()

///|
let render_submission_by_world : Map[UInt, RenderSubmissionDebug] = Map::new()

///|
let latest_render_frame_by_world : Map[UInt, @render_pipeline.RenderFrame] = Map::new()

///|
let snapshot_providers : Map[String, SnapshotProvider] = Map::new()

///|
let atlas_overlay_enabled_by_world : Map[UInt, Bool] = Map::new()

///|
fn current_world() -> @ecs.World {
  @ecs.require_current_world()
}

///|
fn current_world_id() -> UInt {
  current_world().id()
}

///|
fn default_deterministic_mode() -> DeterministicModeConfig {
  {
    rng_seed: 0U,
    fixed_delta_override: None,
    frame_delta_override: None,
    deterministic_ordering: true,
  }
}

///|
pub fn set_deterministic_mode(config : DeterministicModeConfig) -> Unit {
  let world_id = current_world_id()
  deterministic_mode_by_world.set(world_id, config)
  rng_state_by_world.set(world_id, config.rng_seed)
}

///|
pub fn deterministic_mode() -> DeterministicModeConfig {
  deterministic_mode_by_world.get_or_init(
    current_world_id(),
    default_deterministic_mode,
  )
}

///|
pub fn clear_deterministic_mode() -> Unit {
  let world_id = current_world_id()
  deterministic_mode_by_world.remove(world_id)
  rng_state_by_world.remove(world_id)
}

///|
pub fn frame_delta_override() -> Double? {
  deterministic_mode().frame_delta_override
}

///|
pub fn fixed_delta_override() -> Double? {
  deterministic_mode().fixed_delta_override
}

///|
pub fn deterministic_ordering_enabled() -> Bool {
  deterministic_mode().deterministic_ordering
}

///|
pub fn set_atlas_overlay_enabled(enabled : Bool) -> Unit {
  atlas_overlay_enabled_by_world.set(current_world_id(), enabled)
}

///|
pub fn atlas_overlay_enabled() -> Bool {
  atlas_overlay_enabled_by_world.get(current_world_id()).unwrap_or(false)
}

///|
pub fn set_rng_seed(seed : UInt) -> Unit {
  let world_id = current_world_id()
  let mode = deterministic_mode()
  deterministic_mode_by_world.set(world_id, { ..mode, rng_seed: seed })
  rng_state_by_world.set(world_id, seed)
}

///|
pub fn rng_seed() -> UInt {
  deterministic_mode().rng_seed
}

///|
pub fn next_deterministic_u32() -> UInt {
  let world_id = current_world_id()
  let mut x = rng_state_by_world.get_or_init(world_id, () => {
    deterministic_mode().rng_seed
  })
  if x == 0U {
    x = 0x6C8E9CF5U
  }
  x = x ^ (x << 13)
  x = x ^ (x >> 17)
  x = x ^ (x << 5)
  rng_state_by_world.set(world_id, x)
  x
}

///|
pub fn next_deterministic_f64() -> Double {
  let value = next_deterministic_u32()
  value.reinterpret_as_int().to_double() / 4294967295.0
}

///|
fn[T : Hash + Eq] copy_set(source : Set[T]) -> Set[T] {
  let out = Set::new()
  for item in source {
    out.add(item)
  }
  out
}

///|
fn[K : Hash + Eq, V] copy_map(source : Map[K, V]) -> Map[K, V] {
  let out = Map::new()
  for key, value in source {
    out.set(key, value)
  }
  out
}

///|
fn copy_snapshot(snapshot : @inputs.InputSnapshot) -> @inputs.InputSnapshot {
  {
    pressed_keys: copy_set(snapshot.pressed_keys),
    mouse: {
      pos: snapshot.mouse.pos,
      left_button: snapshot.mouse.left_button,
      right_button: snapshot.mouse.right_button,
      middle_button: snapshot.mouse.middle_button,
    },
    mouse_movement: { movement: snapshot.mouse_movement.movement },
    mouse_wheel: { delta: snapshot.mouse_wheel.delta },
    connected_gamepads: copy_set(snapshot.connected_gamepads),
    pressed_gamepad_buttons: copy_set(snapshot.pressed_gamepad_buttons),
    gamepad_axis_values: copy_map(snapshot.gamepad_axis_values),
  }
}

///|
fn staged_snapshot() -> @inputs.InputSnapshot {
  staged_input_by_world.get_or_init(
    current_world_id(),
    @inputs.empty_input_snapshot,
  )
}

///|
fn queued_inputs() -> Array[@inputs.InputSnapshot] {
  queued_inputs_by_world.get_or_init(current_world_id(), () => [])
}

///|
pub fn queue_input_snapshot(snapshot : @inputs.InputSnapshot) -> Unit {
  queued_inputs().push(copy_snapshot(snapshot))
}

///|
pub fn queued_input_count() -> Int {
  queued_inputs().length()
}

///|
pub fn clear_queued_inputs() -> Unit {
  queued_inputs().clear()
}

///|
pub fn queue_input_event(event : InputInjectionEvent) -> Unit {
  let staged = staged_snapshot()
  match event {
    KeyDown(code) => staged.pressed_keys.add(code)
    KeyUp(code) => staged.pressed_keys.remove(code)
    MouseMove(position) => {
      staged.mouse_movement.movement = position - staged.mouse.pos
      staged.mouse.pos = position
    }
    MouseWheel(delta) => staged.mouse_wheel.delta = delta
    MouseLeft(pressed) => staged.mouse.left_button = pressed
    MouseRight(pressed) => staged.mouse.right_button = pressed
    MouseMiddle(pressed) => staged.mouse.middle_button = pressed
    GamepadConnected(gamepad, connected) =>
      if connected {
        staged.connected_gamepads.add(gamepad)
      } else {
        staged.connected_gamepads.remove(gamepad)
      }
    GamepadButton(button, pressed) =>
      if pressed {
        staged.pressed_gamepad_buttons.add(button)
      } else {
        staged.pressed_gamepad_buttons.remove(button)
      }
    GamepadAxis(axis, value) => staged.gamepad_axis_values.set(axis, value)
  }
  queue_input_snapshot(staged)
}

///|
pub fn consume_injected_input_or(
  poller : () -> @inputs.InputSnapshot,
) -> @inputs.InputSnapshot {
  let queue = queued_inputs()
  if queue.is_empty() {
    return poller()
  }
  let head = queue[0]
  let tail : Array[@inputs.InputSnapshot] = []
  for index in 1..<queue.length() {
    tail.push(queue[index])
  }
  queued_inputs_by_world.set(current_world_id(), tail)
  copy_snapshot(head)
}

///|
fn default_metrics(world : @ecs.World) -> FramePerformanceMetrics {
  {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    fixed_steps_this_frame: 0,
    update_delta: 0.0,
    fixed_delta_total: 0.0,
    render_delta: 0.0,
    entity_count: 0,
    draw2d_count: 0,
    draw3d_count: 0,
  }
}

///|
fn ensure_metrics() -> FramePerformanceMetrics {
  let world = current_world()
  frame_metrics_by_world.get_or_init(world.id(), () => default_metrics(world))
}

///|
pub fn begin_frame_metrics() -> Unit {
  let world = current_world()
  frame_metrics_by_world.set(world.id(), {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    fixed_steps_this_frame: 0,
    update_delta: 0.0,
    fixed_delta_total: 0.0,
    render_delta: 0.0,
    entity_count: 0,
    draw2d_count: 0,
    draw3d_count: 0,
  })
}

///|
pub fn note_fixed_step(delta : Double) -> Unit {
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  frame_metrics_by_world.set(world_id, {
    ..metrics,
    fixed_steps_this_frame: metrics.fixed_steps_this_frame + 1,
    fixed_delta_total: metrics.fixed_delta_total + @cmp.maximum(0.0, delta),
  })
}

///|
pub fn note_update(update_delta : Double, entity_count : Int) -> Unit {
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  frame_metrics_by_world.set(world_id, {
    ..metrics,
    update_delta: @cmp.maximum(0.0, update_delta),
    entity_count: @cmp.maximum(0, entity_count),
  })
}

///|
pub fn note_render(
  render_delta : Double,
  draw2d_count : Int,
  draw3d_count : Int,
) -> Unit {
  let world_id = current_world_id()
  let metrics = ensure_metrics()
  let next_metrics = {
    ..metrics,
    render_delta: @cmp.maximum(0.0, render_delta),
    draw2d_count: @cmp.maximum(0, draw2d_count),
    draw3d_count: @cmp.maximum(0, draw3d_count),
  }
  frame_metrics_by_world.set(world_id, next_metrics)
  let history = frame_metrics_history_by_world.get_or_init(world_id, () => [])
  history.push({ ..next_metrics })
  let max_samples = 120
  if history.length() > max_samples {
    let retained = history.copy()
    history.clear()
    let keep_from = retained.length() - max_samples
    for index in keep_from..<retained.length() {
      history.push(retained[index])
    }
  }
}

///|
pub fn latest_metrics() -> FramePerformanceMetrics {
  { ..ensure_metrics() }
}

///|
pub fn rolling_metrics() -> Array[FramePerformanceMetrics] {
  frame_metrics_history_by_world
  .get_or_init(current_world_id(), () => [])
  .copy()
}

///|
fn draw2d_info(
  entity_id : UInt?,
  layer : String,
  depth : Double?,
  command : @render2d_types.DrawCommand2D,
) -> DrawSubmission2DInfo {
  match command {
    Image(image) => {
      let uv_rect = image.source.map(fn(region) {
        @math.Rect::{ position: region.position, size: region.size }
      })
      {
        entity_id,
        layer,
        kind: "Image",
        depth,
        texture_path: @asset.image_path(image.image),
        uv_rect,
        destination_rect: Some(image.destination),
        transform: Some(image.transform),
        color: Some(image.color),
      }
    }
    Text(text) => {
      let destination = @math.Rect::{
        position: text.position,
        size: @math.Vec2::zero(),
      }
      {
        entity_id,
        layer,
        kind: "Text",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(destination),
        transform: Some(text.transform),
        color: Some(text.style.color),
      }
    }
    Rect(rect) =>
      {
        entity_id,
        layer,
        kind: "Rect",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(rect.rect),
        transform: Some(rect.transform),
        color: Some(rect.fill_color),
      }
    Circle(circle) => {
      let destination = @math.Rect::{
        position: circle.center - @math.Vec2(circle.radius, circle.radius),
        size: @math.Vec2(circle.radius * 2.0, circle.radius * 2.0),
      }
      {
        entity_id,
        layer,
        kind: "Circle",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(destination),
        transform: Some(circle.transform),
        color: Some(circle.fill_color),
      }
    }
    GradientRect(gradient) =>
      {
        entity_id,
        layer,
        kind: "GradientRect",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(gradient.rect),
        transform: Some(gradient.transform),
        color: Some(gradient.color_start),
      }
    PushClip(clip) =>
      {
        entity_id,
        layer,
        kind: "PushClip",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: Some(clip.rect),
        transform: None,
        color: None,
      }
    PopClip =>
      {
        entity_id,
        layer,
        kind: "PopClip",
        depth,
        texture_path: None,
        uv_rect: None,
        destination_rect: None,
        transform: None,
        color: None,
      }
  }
}

///|
fn draw3d_info(item : @render3d_types.RenderItem3D) -> DrawSubmission3DInfo {
  {
    entity_id: item.entity_id,
    mesh: item.mesh,
    material: item.material,
    cast_shadows: item.cast_shadows,
    receive_shadows: item.receive_shadows,
    translation: item.transform.translation,
    scale: item.transform.scale,
  }
}

///|
pub fn record_render_submission(
  frame : @render_pipeline.RenderFrame,
  world_commands : Array[@render2d.DrawCommandWithDepth2D],
) -> Unit {
  let draw2d : Array[DrawSubmission2DInfo] = []
  for command in world_commands {
    draw2d.push(
      draw2d_info(
        command.entity_id,
        "world",
        Some(command.depth),
        command.command,
      ),
    )
  }
  for command in frame.frame2d.ui_commands {
    draw2d.push(draw2d_info(None, "ui", None, command))
  }
  let draw3d = frame.frame3d.items.map(draw3d_info)
  let world = current_world()
  latest_render_frame_by_world.set(world.id(), frame)
  render_submission_by_world.set(world.id(), {
    frame_index: world.frame_index(),
    fixed_step_index: world.fixed_step_index(),
    draw2d,
    draw3d,
  })
}

///|
pub fn latest_render_submission() -> RenderSubmissionDebug? {
  render_submission_by_world.get(current_world_id())
}

///|
fn draw2d_metadata_entry(
  item : DrawSubmission2DInfo,
) -> DrawSubmission2DMetadataEntry {
  {
    entity_id: item.entity_id,
    layer: item.layer,
    kind: item.kind,
    depth: item.depth,
    texture_path: item.texture_path,
    source_rect: item.uv_rect.map(debug_rect),
    destination_rect: item.destination_rect.map(debug_rect),
    transform_translation: item.transform.map(fn(transform) {
      debug_vec2(@math.Vec2(transform.tx, transform.ty))
    }),
    color: item.color.map(debug_color),
  }
}

///|
fn metrics_export(
  metrics : FramePerformanceMetrics,
) -> FramePerformanceMetricsExport {
  {
    frame_index: metrics.frame_index,
    fixed_step_index: metrics.fixed_step_index,
    fixed_steps_this_frame: metrics.fixed_steps_this_frame,
    update_delta: metrics.update_delta,
    fixed_delta_total: metrics.fixed_delta_total,
    render_delta: metrics.render_delta,
    entity_count: metrics.entity_count,
    draw2d_count: metrics.draw2d_count,
    draw3d_count: metrics.draw3d_count,
  }
}

///|
pub fn capture_last_frame_metadata() -> FrameCaptureMetadata? {
  guard latest_render_submission() is Some(submission) else { return None }
  let draw2d = submission.draw2d.map(draw2d_metadata_entry)
  let metrics = frame_metrics_by_world
    .get(current_world_id())
    .map(metrics_export)
  Some({
    frame_index: submission.frame_index,
    fixed_step_index: submission.fixed_step_index,
    metrics,
    draw2d,
    draw3d_count: submission.draw3d.length(),
    sprites: sprite_inspector_entries(),
    atlas_overlay: atlas_overlay_entries(),
  })
}

///|
pub fn capture_last_frame_metadata_json(indent? : Int = 2) -> String? {
  capture_last_frame_metadata().map(fn(metadata) {
    metadata.to_json().stringify(indent~)
  })
}

///|
pub fn frame_capture_file_stem(
  frame_index : UInt,
  fixed_step_index : UInt,
) -> String {
  "frame_\{frame_index.to_string()}_fixed_\{fixed_step_index.to_string()}"
}

///|
pub fn capture_last_frame_with_metadata(
  width : Int,
  height : Int,
  indent? : Int = 2,
) -> FrameCaptureArtifact? {
  guard capture_last_frame_metadata() is Some(metadata) else { return None }
  let png = match render_last_frame_offscreen_png(width, height) {
    Some(bytes) => Some(bytes)
    None => capture_frame_png()
  }
  guard png is Some(bytes) else { return None }
  let file_stem = frame_capture_file_stem(
    metadata.frame_index,
    metadata.fixed_step_index,
  )
  Some({
    frame_index: metadata.frame_index,
    fixed_step_index: metadata.fixed_step_index,
    file_stem,
    png: bytes,
    metadata_json: metadata.to_json().stringify(indent~),
  })
}

///|
pub fn render_last_frame_offscreen_png(width : Int, height : Int) -> Bytes? {
  guard latest_render_frame_by_world.get(current_world_id()) is Some(frame) else {
    return None
  }
  @platform_render.render_offscreen_png(frame, width, height)
}

///|
pub fn capture_frame_png() -> Bytes? {
  @platform_render.capture_frame_png()
}

///|
pub fn capture_frame_png_to_file(path : String) -> Bool {
  @platform_render.capture_frame_png_to_file(path)
}

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
  {
    ..frame,
    frame2d: { world_commands: frame.frame2d.world_commands, ui_commands },
  }
}

///|
fn rect_equals(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  lhs.position == rhs.position && lhs.size == rhs.size
}

///|
fn rect_overlap(lhs : @math.Rect, rhs : @math.Rect) -> Bool {
  let l_min_x = lhs.position[@math.X]
  let l_min_y = lhs.position[@math.Y]
  let l_max_x = lhs.position[@math.X] + lhs.size[@math.X]
  let l_max_y = lhs.position[@math.Y] + lhs.size[@math.Y]

  let r_min_x = rhs.position[@math.X]
  let r_min_y = rhs.position[@math.Y]
  let r_max_x = rhs.position[@math.X] + rhs.size[@math.X]
  let r_max_y = rhs.position[@math.Y] + rhs.size[@math.Y]

  l_min_x < r_max_x &&
  l_max_x > r_min_x &&
  l_min_y < r_max_y &&
  l_max_y > r_min_y
}

///|
fn validate_atlas_transparency(
  image_path : String?,
  rects : Array[@math.Rect],
  issues : Array[AtlasValidationIssue],
) -> Unit {
  guard image_path is Some(path) else {
    issues.push({
      kind: TransparencyCheckUnavailable,
      rect_index: None,
      other_rect_index: None,
      message: "Transparency checks require an atlas image path",
    })
    return
  }
  let mut backend_supported = false
  for index, rect in rects {
    match @platform_render.image_region_is_fully_transparent(path, rect) {
      Some(true) => {
        backend_supported = true
        issues.push({
          kind: FullyTransparentRect,
          rect_index: Some(index),
          other_rect_index: None,
          message: "Frame rect appears fully transparent",
        })
      }
      Some(false) => backend_supported = true
      None => ()
    }
  }
  if !backend_supported {
    issues.push({
      kind: TransparencyCheckUnavailable,
      rect_index: None,
      other_rect_index: None,
      message: "Current platform cannot inspect atlas transparency",
    })
  }
}

///|
pub fn validate_texture_atlas_layout(
  layout : @sprite.TextureAtlasLayout,
) -> AtlasValidationReport {
  validate_texture_atlas_layout_for_image(layout, None)
}

///|
pub fn validate_texture_atlas_layout_for_image(
  layout : @sprite.TextureAtlasLayout,
  image_path : String?,
) -> AtlasValidationReport {
  let atlas_size = @sprite.texture_atlas_layout_size(layout)
  let rects = @sprite.texture_atlas_layout_rects(layout)
  let issues : Array[AtlasValidationIssue] = []
  if atlas_size[@math.X] <= 0.0 || atlas_size[@math.Y] <= 0.0 {
    issues.push({
      kind: InvalidAtlasSize,
      rect_index: None,
      other_rect_index: None,
      message: "Atlas size must be positive",
    })
  }
  for index, rect in rects {
    if rect.size[@math.X] <= 0.0 || rect.size[@math.Y] <= 0.0 {
      issues.push({
        kind: InvalidRectSize,
        rect_index: Some(index),
        other_rect_index: None,
        message: "Frame rect size must be positive",
      })
    }
    let max_x = rect.position[@math.X] + rect.size[@math.X]
    let max_y = rect.position[@math.Y] + rect.size[@math.Y]
    if rect.position[@math.X] < 0.0 ||
      rect.position[@math.Y] < 0.0 ||
      max_x > atlas_size[@math.X] ||
      max_y > atlas_size[@math.Y] {
      issues.push({
        kind: OutOfBounds,
        rect_index: Some(index),
        other_rect_index: None,
        message: "Frame rect is outside atlas bounds",
      })
    }
  }
  for left_index in 0..<rects.length() {
    for right_index in (left_index + 1)..<rects.length() {
      let lhs = rects[left_index]
      let rhs = rects[right_index]
      if rect_equals(lhs, rhs) {
        issues.push({
          kind: DuplicateRect,
          rect_index: Some(left_index),
          other_rect_index: Some(right_index),
          message: "Duplicate frame rect detected",
        })
      } else if rect_overlap(lhs, rhs) {
        issues.push({
          kind: Overlap,
          rect_index: Some(left_index),
          other_rect_index: Some(right_index),
          message: "Overlapping frame rect detected",
        })
      }
    }
  }
  validate_atlas_transparency(image_path, rects, issues)
  { total_rects: rects.length(), issues }
}

///|
pub fn validate_registered_texture_atlases() -> Array[
  (@sprite.TextureAtlasLayoutHandle, AtlasValidationReport),
] {
  let atlas_image_paths : Map[@sprite.TextureAtlasLayoutHandle, String] = Map::new()
  for _entity, sprite in @sprite.sprites() {
    guard sprite.texture_atlas is Some(atlas) else { continue }
    guard sprite.image is Some(image_handle) else { continue }
    guard @asset.image_path(image_handle) is Some(path) else { continue }
    if !atlas_image_paths.contains(atlas.layout) {
      atlas_image_paths.set(atlas.layout, path)
    }
  }
  let reports : Array[(@sprite.TextureAtlasLayoutHandle, AtlasValidationReport)] = []
  for pair in @sprite.texture_atlas_layout_entries() {
    reports.push(
      (
        pair.0,
        validate_texture_atlas_layout_for_image(
          pair.1,
          atlas_image_paths.get(pair.0),
        ),
      ),
    )
  }
  reports
}
