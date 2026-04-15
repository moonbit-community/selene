///|
fn full_screen_viewport() -> @math.Rect {
  { position: @math.Vec2::zero(), size: @system.get_screen_size() }
}

///|
fn screen_pass_order(camera_views : Array[@camera.Camera2dView]) -> Int {
  if camera_views.is_empty() {
    0
  } else {
    camera_views[camera_views.length() - 1].camera.order + 1
  }
}

///|
fn render_pass_load_op(
  load_op : @camera.CameraPassLoadOp2D,
) -> @render2d_types.RenderPassLoadOp2D {
  match load_op {
    Load => @render2d_types.RenderPassLoadOp2D::Load
    Clear => @render2d_types.RenderPassLoadOp2D::Clear
  }
}

///|
fn render_pass_target(
  target : @camera.CameraPassTarget2D,
) -> @render2d_types.RenderPassTarget2D {
  match target {
    Screen => @render2d_types.RenderPassTarget2D::Screen
    Offscreen(name) => @render2d_types.RenderPassTarget2D::Offscreen(name)
  }
}

///|
fn alpha_mode_batch_key(alpha_mode : @render.AlphaMode2D) -> String {
  match alpha_mode {
    Opaque => "opaque"
    Blend => "blend"
  }
}

///|
fn blend_mode_batch_key(blend_mode : @render.BlendMode2D) -> String {
  match blend_mode {
    Alpha => "alpha"
    Additive => "additive"
    Multiply => "multiply"
  }
}

///|
fn draw_command_batch_key(command : @render2d_types.DrawCommand2D) -> String? {
  match command {
    Image(command) =>
      Some(
        "image:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    Text(command) => Some("text:\{blend_mode_batch_key(command.blend_mode)}")
    Rect(command) =>
      Some(
        "rect:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    Circle(command) =>
      Some(
        "circle:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    GradientRect(command) =>
      Some(
        "gradient_rect:\{alpha_mode_batch_key(command.alpha_mode)}:\{blend_mode_batch_key(command.blend_mode)}",
      )
    PushClip(_) => None
    PopClip => None
  }
}

///|
fn build_draw_batches(
  commands : Array[@render2d_types.DrawCommand2D],
) -> Array[Array[@render2d_types.DrawCommand2D]] {
  let batches : Array[Array[@render2d_types.DrawCommand2D]] = []
  let mut current_key : String? = None
  for command in commands {
    match draw_command_batch_key(command) {
      Some(key) => {
        if current_key == Some(key) && !batches.is_empty() {
          batches[batches.length() - 1].push(command)
        } else {
          batches.push([command])
          current_key = Some(key)
        }
      }
      None => {
        // Clip commands are explicit batch barriers.
        batches.push([command])
        current_key = None
      }
    }
  }
  batches
}

///|
fn offscreen_local_viewport(viewport : @math.Rect) -> @math.Rect {
  { position: @math.Vec2::zero(), size: viewport.size }
}

///|
fn offset_rect(rect : @math.Rect, offset : @math.Vec2) -> @math.Rect {
  { position: rect.position - offset, size: rect.size }
}

///|
fn normalize_draw_command_for_offscreen(
  command : @render2d_types.DrawCommand2D,
  offset : @math.Vec2,
) -> @render2d_types.DrawCommand2D {
  match command {
    Image(image) =>
      Image({
        ..image,
        destination: offset_rect(image.destination, offset),
      })
    Text(text) => Text({ ..text, position: text.position - offset })
    Rect(rect) => Rect({ ..rect, rect: offset_rect(rect.rect, offset) })
    Circle(circle) => Circle({ ..circle, center: circle.center - offset })
    GradientRect(command) =>
      GradientRect({ ..command, rect: offset_rect(command.rect, offset) })
    PushClip(clip) => PushClip({ rect: offset_rect(clip.rect, offset) })
    PopClip => PopClip
  }
}

///|
fn normalize_draw_commands_for_target(
  commands : Array[@render2d_types.DrawCommand2D],
  target : @render2d_types.RenderPassTarget2D,
  viewport : @math.Rect,
) -> Array[@render2d_types.DrawCommand2D] {
  match target {
    Screen => commands
    Offscreen(_) =>
      commands.map(fn(command) {
        normalize_draw_command_for_offscreen(command, viewport.position)
      })
  }
}

///|
fn normalize_draw_command_for_target(
  command : @render2d_types.DrawCommand2D,
  target : @render2d_types.RenderPassTarget2D,
  viewport : @math.Rect,
) -> @render2d_types.DrawCommand2D {
  normalize_draw_commands_for_target([command], target, viewport)[0]
}

///|
fn build_frame2d(
  camera_views : Array[@camera.Camera2dView],
) -> (@render2d_types.RenderFrame2D, Array[@render2d.DrawCommandWithDepth2D]) {
  let passes : Array[@render2d_types.RenderPass2D] = []
  let world_commands : Array[@render2d_types.DrawCommand2D] = []
  let ui_commands : Array[@render2d_types.DrawCommand2D] = []
  let world_commands_with_depth : Array[@render2d.DrawCommandWithDepth2D] = []
  for camera_view in camera_views {
    let pass_world_with_depth = @render2d.get_camera_world_commands_with_depth(
      camera_view.entity.id(),
    )
    let pass_ui_commands = @render2d.get_camera_ui_commands(
      camera_view.entity.id(),
    )
    let needs_clear = camera_view.camera.pass.load_op is Clear
    if pass_world_with_depth.is_empty() &&
      pass_ui_commands.is_empty() &&
      !needs_clear {
      continue
    }
    let pass_target = render_pass_target(camera_view.camera.pass.target)
    let pass_world_commands = pass_world_with_depth.map(fn(command) {
      let normalized_command = normalize_draw_command_for_target(
        command.command,
        pass_target,
        camera_view.viewport,
      )
      world_commands_with_depth.push({
        ..command,
        command: normalized_command,
      })
      world_commands.push(normalized_command)
      normalized_command
    })
    let normalized_ui_commands = normalize_draw_commands_for_target(
      pass_ui_commands,
      pass_target,
      camera_view.viewport,
    )
    for command in normalized_ui_commands {
      ui_commands.push(command)
    }
    passes.push({
      camera_entity_id: Some(camera_view.entity.id()),
      order: camera_view.camera.order,
      viewport: match pass_target {
        Offscreen(_) => offscreen_local_viewport(camera_view.viewport)
        Screen => camera_view.viewport
      },
      load_op: render_pass_load_op(camera_view.camera.pass.load_op),
      clear_color: camera_view.camera.pass.clear_color,
      target: pass_target,
      world_commands: pass_world_commands,
      ui_commands: normalized_ui_commands,
      world_batches: build_draw_batches(pass_world_commands),
      ui_batches: build_draw_batches(normalized_ui_commands),
    })
  }

  let screen_world_with_depth = @render2d.get_screen_world_commands_with_depth()
  let screen_ui_commands = @render2d.get_screen_ui_commands()
  if !screen_world_with_depth.is_empty() ||
    !screen_ui_commands.is_empty() ||
    passes.is_empty() {
    let screen_world_commands = screen_world_with_depth.map(fn(command) {
      world_commands_with_depth.push(command)
      world_commands.push(command.command)
      command.command
    })
    for command in screen_ui_commands {
      ui_commands.push(command)
    }
    passes.push({
      camera_entity_id: None,
      order: screen_pass_order(camera_views),
      viewport: full_screen_viewport(),
      load_op: @render2d_types.RenderPassLoadOp2D::Load,
      clear_color: { r: 0U, g: 0U, b: 0U, a: 1.0 },
      target: @render2d_types.RenderPassTarget2D::Screen,
      world_commands: screen_world_commands,
      ui_commands: screen_ui_commands,
      world_batches: build_draw_batches(screen_world_commands),
      ui_batches: build_draw_batches(screen_ui_commands),
    })
  }

  ({ passes, world_commands, ui_commands }, world_commands_with_depth)
}

///|
pub fn render_submit_system(_delta : Double) -> Unit {
  let camera_views = @camera.active_camera2d_views()
  let (frame2d, world_commands_with_depth) = build_frame2d(camera_views)
  let assets3d : @render_pipeline.RenderAssetSync3D = {
    mesh_upserts: @render3d.take_dirty_mesh_assets(),
    material_upserts: @render3d.take_dirty_material_assets(),
    image_upserts: @render3d.take_dirty_image_assets(),
    mesh_releases: @render3d.take_released_mesh_assets(),
    material_releases: @render3d.take_released_material_assets(),
    image_releases: @render3d.take_released_image_assets(),
  }
  let frame : @render_pipeline.RenderFrame = {
    frame2d,
    frame3d: @render3d_pipeline.get_prepared_frame3d(),
    assets3d,
  }
  let debug_frame = @runtime_debug.decorate_frame_for_debug(
    frame, world_commands_with_depth,
  )
  @runtime_debug.record_render_submission(
    debug_frame, world_commands_with_depth,
  )
  @platform_render.submit_frame(debug_frame)
}
