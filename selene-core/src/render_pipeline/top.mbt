///|
pub(all) struct RenderAssetSync3D {
  mesh_upserts : Array[(@render3d_types.MeshHandle, @render3d_types.MeshAsset)]
  material_upserts : Array[
    (@render3d_types.MaterialHandle, @render3d_types.StandardMaterial3D),
  ]
  image_upserts : Array[
    (@render3d_types.ImageHandle, @render3d_types.ImageAsset),
  ]
  mesh_releases : Array[@render3d_types.MeshHandle]
  material_releases : Array[@render3d_types.MaterialHandle]
  image_releases : Array[@render3d_types.ImageHandle]
}

///|
pub(all) struct RenderFrame {
  frame2d : @render2d_types.RenderFrame2D
  frame3d : @render3d_types.RenderFrame3D
  assets3d : RenderAssetSync3D
}

///|
pub fn empty_asset_sync3d() -> RenderAssetSync3D {
  {
    mesh_upserts: [],
    material_upserts: [],
    image_upserts: [],
    mesh_releases: [],
    material_releases: [],
    image_releases: [],
  }
}

///|
pub fn empty_render_frame() -> RenderFrame {
  {
    frame2d: @render2d_types.empty_render_frame2d(),
    frame3d: @render3d_types.empty_render_frame3d(),
    assets3d: empty_asset_sync3d(),
  }
}
