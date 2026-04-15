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
    let pass_world_commands = pass_world_with_depth.map(fn(command) {
      world_commands_with_depth.push(command)
      world_commands.push(command.command)
      command.command
    })
    for command in pass_ui_commands {
      ui_commands.push(command)
    }
    passes.push({
      camera_entity_id: Some(camera_view.entity.id()),
      order: camera_view.camera.order,
      viewport: camera_view.viewport,
      load_op: render_pass_load_op(camera_view.camera.pass.load_op),
      clear_color: camera_view.camera.pass.clear_color,
      world_commands: pass_world_commands,
      ui_commands: pass_ui_commands,
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
      world_commands: screen_world_commands,
      ui_commands: screen_ui_commands,
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
