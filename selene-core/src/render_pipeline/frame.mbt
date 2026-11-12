///|
pub(all) struct RenderAssetSync3D {
  mesh_upserts : Array[(@render3d_types.MeshHandle, @render3d_types.MeshAsset)]
  material_upserts : Array[
    (@render3d_types.MaterialHandle, @render3d_types.StandardMaterial3D),
  ]
  cubemap_upserts : Array[
    (@render3d_types.CubemapHandle, @render3d_types.CubemapAsset3D),
  ]
  mesh_releases : Array[@render3d_types.MeshHandle]
  material_releases : Array[@render3d_types.MaterialHandle]
  cubemap_releases : Array[@render3d_types.CubemapHandle]
}

///|
pub(all) struct RenderFrame {
  frame2d : @render2d_types.RenderFrame2D
  frame3d : @render3d_types.RenderFrame3D
  assets3d : RenderAssetSync3D
}

///|
pub fn RenderAssetSync3D::RenderAssetSync3D() -> RenderAssetSync3D {
  {
    mesh_upserts: [],
    material_upserts: [],
    cubemap_upserts: [],
    mesh_releases: [],
    material_releases: [],
    cubemap_releases: [],
  }
}

///|
pub fn RenderFrame::RenderFrame() -> RenderFrame {
  {
    frame2d: RenderFrame2D(),
    frame3d: RenderFrame3D(),
    assets3d: RenderAssetSync3D(),
  }
}
