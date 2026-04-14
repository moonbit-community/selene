///|
pub fn render_submit_system(_delta : Double) -> Unit {
  let world_commands_with_depth = @render2d.get_world_commands_with_depth()
  let assets3d : @render_pipeline.RenderAssetSync3D = {
    mesh_upserts: @render3d.take_dirty_mesh_assets(),
    material_upserts: @render3d.take_dirty_material_assets(),
    image_upserts: @render3d.take_dirty_image_assets(),
    mesh_releases: @render3d.take_released_mesh_assets(),
    material_releases: @render3d.take_released_material_assets(),
    image_releases: @render3d.take_released_image_assets(),
  }
  let frame : @render_pipeline.RenderFrame = {
    frame2d: {
      world_commands: world_commands_with_depth.map(fn(command) {
        command.command
      }),
      ui_commands: @render2d.get_ui_commands(),
    },
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
