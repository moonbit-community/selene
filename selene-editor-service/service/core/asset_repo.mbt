///|
async fn load_prefab_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.PrefabDocument {
  let path = prefab_path(root, relative_path)
  guard @fs.exists(path) else { raise PrefabNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Prefab document is invalid: " + relative_path)
  }
  @editor_bridge.decode_prefab_document(json) catch {
    @editor_bridge.InvalidPrefabDocument(_) =>
      raise Failure("Prefab document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_prefab_document(
  root : String,
  relative_path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> Unit {
  let path = prefab_path(root, relative_path)
  ensure_dir(path_join(root, "prefabs"))
  let encoded = @editor_bridge.encode_prefab_document_json(prefab)
  write_text_file(path, encoded)
}

///|
async fn list_prefab_documents(
  root : String,
) -> Array[@editor_bridge.PrefabRef] {
  let prefabs_root = path_join(root, "prefabs")
  list_document_refs(
    prefabs_root,
    "prefabs/",
    ".prefab.json",
    fn(path) { @editor_bridge.prefab_ref(path) },
    fn(prefab_ref) { prefab_ref.path },
  )
}

///|
async fn load_atlas_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AtlasAssetDocument {
  let path = atlas_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AtlasNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Atlas document is invalid: " + relative_path)
  }
  @editor_bridge.decode_atlas_asset_document(json) catch {
    @editor_bridge.InvalidAtlasAssetDocument(_) =>
      raise Failure("Atlas document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_atlas_asset_document(
  root : String,
  relative_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Unit {
  let path = atlas_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/atlases"))
  let encoded = @editor_bridge.encode_atlas_asset_document_json(atlas)
  write_text_file(path, encoded)
}

///|
async fn list_atlas_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let assets_root = path_join(root, "assets/atlases")
  list_document_refs(
    assets_root,
    "assets/atlases/",
    ".atlas.json",
    fn(path) { @editor_bridge.asset_ref(path) },
    fn(asset_ref) { asset_ref.path },
  )
}

///|
async fn load_animation_clip_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AnimationClipAssetDocument {
  let path = animation_clip_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AnimationNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Animation clip document is invalid: " + relative_path)
  }
  @editor_bridge.decode_animation_clip_asset_document(json) catch {
    @editor_bridge.InvalidAnimationClipAssetDocument(_) =>
      raise Failure("Animation clip document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_animation_clip_asset_document(
  root : String,
  relative_path : String,
  clip : @editor_bridge.AnimationClipAssetDocument,
) -> Unit {
  let path = animation_clip_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/animation_clips"))
  let encoded = @editor_bridge.encode_animation_clip_asset_document_json(clip)
  write_text_file(path, encoded)
}

///|
async fn list_animation_clip_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let assets_root = path_join(root, "assets/animation_clips")
  list_document_refs(
    assets_root,
    "assets/animation_clips/",
    ".clip.json",
    fn(path) { @editor_bridge.asset_ref(path) },
    fn(asset_ref) { asset_ref.path },
  )
}

///|
async fn load_animation_graph_asset_document(
  root : String,
  relative_path : String,
) -> @editor_bridge.AnimationGraphAssetDocument {
  let path = animation_graph_asset_path(root, relative_path)
  guard @fs.exists(path) else { raise AnimationNotFound(relative_path) }
  let json = parse_json_file(path) catch {
    _ => raise Failure("Animation graph document is invalid: " + relative_path)
  }
  @editor_bridge.decode_animation_graph_asset_document(json) catch {
    @editor_bridge.InvalidAnimationGraphAssetDocument(_) =>
      raise Failure("Animation graph document is invalid: " + relative_path)
    err => raise err
  }
}

///|
async fn save_animation_graph_asset_document(
  root : String,
  relative_path : String,
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> Unit {
  let path = animation_graph_asset_path(root, relative_path)
  ensure_dir(path_join(root, "assets/animation_graphs"))
  let encoded = @editor_bridge.encode_animation_graph_asset_document_json(graph)
  write_text_file(path, encoded)
}

///|
async fn list_animation_graph_asset_documents(
  root : String,
) -> Array[@editor_bridge.AssetRef] {
  let assets_root = path_join(root, "assets/animation_graphs")
  list_document_refs(
    assets_root,
    "assets/animation_graphs/",
    ".graph.json",
    fn(path) { @editor_bridge.asset_ref(path) },
    fn(asset_ref) { asset_ref.path },
  )
}

///|
async fn load_workspace_document(
  root : String,
) -> @editor_bridge.WorkspaceDocument {
  let path = workspace_path(root)
  if !@fs.exists(path) {
    return @editor_bridge.WorkspaceDocument::default()
  }
  let json = parse_json_file(path) catch {
    _ =>
      raise Failure(
        "Workspace document is invalid: .selene-editor/workspace.json",
      )
  }
  @editor_bridge.decode_workspace_document(json) catch {
    @editor_bridge.InvalidWorkspaceDocument(_) =>
      raise Failure(
        "Workspace document is invalid: .selene-editor/workspace.json",
      )
    err => raise err
  }
}

///|
async fn save_workspace_document(
  root : String,
  workspace : @editor_bridge.WorkspaceDocument,
) -> Unit {
  ensure_dir(path_join(root, ".selene-editor"))
  let encoded = @editor_bridge.encode_workspace_document_json(workspace)
  write_text_file(workspace_path(root), encoded)
}

///|
async fn collect_assets(
  root : String,
  manifest : @editor_bridge.ProjectManifest,
) -> Array[@editor_bridge.AssetDocument] {
  let assets : Array[@editor_bridge.AssetDocument] = []
  for asset_root in manifest.asset_roots {
    let root_path = path_join(root, asset_root)
    if !@fs.exists(root_path) {
      continue
    }
    for relative in list_files_recursive(root_path) {
      let full_relative = path_join(asset_root, relative)
      let meta_relative = full_relative + ".meta.json"
      assets.push(
        @editor_bridge.asset_document(
          full_relative,
          @editor_bridge.infer_asset_kind(full_relative),
          meta_path=if @fs.exists(path_join(root, meta_relative)) {
            Some(meta_relative)
          } else {
            None
          },
        ),
      )
    }
  }
  assets.sort_by(fn(left, right) { left.path.compare(right.path) })
  assets
}
