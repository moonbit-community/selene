///|
pub fn render_submit_system(_delta : Double) -> Unit {
  let assets3d : @render_pipeline.RenderAssetSync3D = {
    mesh_upserts: @render3d.take_dirty_mesh_assets(),
    material_upserts: @render3d.take_dirty_material_assets(),
    image_upserts: @render3d.take_dirty_image_assets(),
    mesh_releases: @render3d.take_released_mesh_assets(),
    material_releases: @render3d.take_released_material_assets(),
    image_releases: @render3d.take_released_image_assets(),
  }
  let frame : @render_pipeline.RenderFrame = {
    frame2d: @render2d.get_frame2d(),
    frame3d: @render3d_pipeline.get_prepared_frame3d(),
    assets3d,
  }
  @platform_render.submit_frame(frame)
}
