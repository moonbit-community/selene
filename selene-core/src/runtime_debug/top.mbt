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
  MouseMove(@math.Vec2D)
  MouseWheel(@math.Vec2D)
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
        size: @math.Vec2D::zero(),
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
        position: circle.center - @math.Vec2D(circle.radius, circle.radius),
        size: @math.Vec2D(circle.radius * 2.0, circle.radius * 2.0),
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
