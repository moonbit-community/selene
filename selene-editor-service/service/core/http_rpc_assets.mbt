///|
async fn EditorService::handle_asset_rpc(
  self : EditorService,
  request : @shared.RpcRequest,
) -> @shared.RpcResponse? {
  match request {
    @shared.AssetsList => {
      let root = self.current_project_root()
      let manifest = self.current_manifest()
      let assets = collect_assets(root, manifest)
      Some(
        @shared.rpc_response_assets_listed(@shared.assets_list_response(assets)),
      )
    }
    @shared.PrefabLoad(path~) => {
      let root = self.current_project_root()
      let prefab = load_prefab_document(root, path)
      Some(
        @shared.rpc_response_prefab_loaded(
          @shared.prefab_load_response(path, prefab),
        ),
      )
    }
    @shared.PrefabSave(path~, prefab~) => {
      let root = self.current_project_root()
      save_prefab_document(root, path, prefab)
      Some(@shared.rpc_response_saved_ok())
    }
    @shared.AtlasLoad(path~) => {
      let root = self.current_project_root()
      let atlas = load_atlas_asset_document(root, path)
      Some(
        @shared.rpc_response_atlas_loaded(
          @shared.atlas_load_response(path, atlas),
        ),
      )
    }
    @shared.AtlasSave(path~, atlas~) => {
      let root = self.current_project_root()
      save_atlas_asset_document(root, path, atlas)
      Some(@shared.rpc_response_saved_ok())
    }
    _ => None
  }
}
