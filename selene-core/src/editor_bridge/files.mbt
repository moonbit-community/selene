///|
pub suberror EditorBridgeFileError {
  InvalidProjectManifest(String)
  InvalidSceneDocument(String)
  InvalidPrefabDocument(String)
  InvalidAtlasAssetDocument(String)
  InvalidAnimationAssetDocument(String)
  InvalidWorkspaceDocument(String)
}

///|
fn parse_json_file(path : String) -> Json raise {
  let content = @fs.read_file_to_string(path)
  @json.parse(content)
}

///|
fn decode_scene_document(json : Json) -> SceneDocument raise {
  let scene : SceneDocument = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidSceneDocument(err.to_string())
  }
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(errors.to_json().stringify())
  }
  scene
}

///|
fn decode_prefab_document(json : Json) -> PrefabDocument raise {
  let prefab : PrefabDocument = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidPrefabDocument(err.to_string())
  }
  let errors = validate_prefab_document(prefab)
  guard errors.is_empty() else {
    raise InvalidPrefabDocument(errors.to_json().stringify())
  }
  prefab
}

///|
fn decode_atlas_asset_document(json : Json) -> AtlasAssetDocument raise {
  let atlas : AtlasAssetDocument = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidAtlasAssetDocument(err.to_string())
  }
  let errors = validate_atlas_asset_document(atlas)
  guard errors.is_empty() else {
    raise InvalidAtlasAssetDocument(errors.to_json().stringify())
  }
  atlas
}

///|
fn decode_animation_asset_document(json : Json) -> AnimationAssetDocument raise {
  let animation : AnimationAssetDocument = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidAnimationAssetDocument(err.to_string())
  }
  let errors = validate_animation_asset_document(animation)
  guard errors.is_empty() else {
    raise InvalidAnimationAssetDocument(errors.to_json().stringify())
  }
  animation
}

///|
fn[T, Preview, Status, M : Migration] migration_status_for(
  path : String,
  json : Json,
  decode_current : (Json) -> T raise,
  build_preview : (String, T, Array[MigrationFieldChange]) -> Preview,
  ready : (T) -> Status,
  required : (Preview) -> Status,
  migrator : M,
) -> Status raise {
  let current : Result[T, Error] = try? decode_current(json)
  match current {
    Ok(document) => ready(document)
    Err(err) => {
      let changes_result : Result[Array[MigrationFieldChange]?, Error] = try?
        migrator.migration_changes(path, json)
      match changes_result {
        Ok(Some(changes)) => {
          let migrated_json_result : Result[Json, Error] = try? migrator.migrate_json(
            path,
            json,
          )
          match migrated_json_result {
            Ok(migrated_json) => {
              let migrated_result : Result[T, Error] = try? decode_current(migrated_json)
              match migrated_result {
                Ok(document) => required(build_preview(path, document, changes))
                Err(_) => raise err
              }
            }
            Err(_) => raise err
          }
        }
        _ => raise err
      }
    }
  }
}

///|
fn write_json_file(path : String, value : &ToJson) -> Unit raise {
  @fs.write_string_to_file(path, value.to_json().stringify(indent=2) + "\n")
}

///|
fn parent_dir(path : String) -> String? {
  let normalized = path.replace(old="\\", new="/")
  let trimmed = if normalized.has_suffix("/") && normalized.length() > 1 {
    normalized[:normalized.length() - 1]
  } else {
    normalized
  }
  if trimmed == "" || trimmed == "." {
    return None
  }
  if trimmed.rev_find("/") is Some(index) {
    if index == 0 {
      Some("/")
    } else {
      Some(trimmed[:index].to_string())
    }
  } else {
    None
  }
}

///|
fn ensure_dir(path : String) -> Unit raise {
  if path == "" || path == "." || @fs.path_exists(path) {
    return
  }
  if parent_dir(path) is Some(parent) && parent != path {
    ensure_dir(parent)
  }
  if !@fs.path_exists(path) {
    @fs.create_dir(path)
  }
}

///|
fn ensure_parent_dir(path : String) -> Unit raise {
  if parent_dir(path) is Some(parent) {
    ensure_dir(parent)
  }
}

///|
pub fn ensure_project_layout(root : String) -> Unit raise {
  ensure_dir(root)
  ensure_dir(root + "/scenes")
  ensure_dir(root + "/prefabs")
  ensure_dir(root + "/assets")
  ensure_dir(root + "/assets/images")
  ensure_dir(root + "/assets/audio")
  ensure_dir(root + "/assets/fonts")
  ensure_dir(root + "/assets/atlases")
  ensure_dir(root + "/assets/animations")
  ensure_dir(root + "/.selene-editor")
  ensure_dir(root + "/.selene-editor/cache")
}

///|
pub fn project_manifest_candidates(root : String) -> Array[String] raise {
  let candidates : Array[String] = []
  if !@fs.path_exists(root) {
    return candidates
  }
  let path = root + "/" + project_manifest_file_name("")
  if @fs.path_exists(path) && @fs.is_file(path) {
    candidates.push(path)
  }
  candidates
}

///|
pub fn read_project_manifest(path : String) -> ProjectManifest raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidProjectManifest(err.to_string())
  }
  let manifest : ProjectManifest = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidProjectManifest(err.to_string())
  }
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(errors.to_json().stringify())
  }
  manifest
}

///|
pub fn write_project_manifest(
  path : String,
  manifest : ProjectManifest,
) -> Unit raise {
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, manifest)
}

///|
pub fn read_scene_document(path : String) -> SceneDocument raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidSceneDocument(err.to_string())
  }
  decode_scene_document(json)
}

///|
pub fn read_scene_document_status(
  path : String,
) -> SceneDocumentLoadStatus raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidSceneDocument(err.to_string())
  }
  migration_status_for(
    path,
    json,
    decode_scene_document,
    scene_migration_preview,
    fn(scene) { Ready(scene) },
    fn(preview) { MigrationRequired(preview) },
    SceneDocumentMigrator::{},
  )
}

///|
pub fn migrate_scene_document(path : String) -> SceneDocument raise {
  match read_scene_document_status(path) {
    Ready(scene) => scene
    MigrationRequired(preview) => {
      write_scene_document(path, preview.scene)
      preview.scene
    }
  }
}

///|
pub fn write_scene_document(path : String, scene : SceneDocument) -> Unit raise {
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, scene)
}

///|
pub fn read_prefab_document(path : String) -> PrefabDocument raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidPrefabDocument(err.to_string())
  }
  decode_prefab_document(json)
}

///|
pub fn read_prefab_document_status(
  path : String,
) -> PrefabDocumentLoadStatus raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidPrefabDocument(err.to_string())
  }
  migration_status_for(
    path,
    json,
    decode_prefab_document,
    prefab_migration_preview,
    fn(prefab) { Ready(prefab) },
    fn(preview) { MigrationRequired(preview) },
    PrefabDocumentMigrator::{},
  )
}

///|
pub fn migrate_prefab_document(path : String) -> PrefabDocument raise {
  match read_prefab_document_status(path) {
    Ready(prefab) => prefab
    MigrationRequired(preview) => {
      write_prefab_document(path, preview.prefab)
      preview.prefab
    }
  }
}

///|
pub fn write_prefab_document(
  path : String,
  prefab : PrefabDocument,
) -> Unit raise {
  let errors = validate_prefab_document(prefab)
  guard errors.is_empty() else {
    raise InvalidPrefabDocument(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, prefab)
}

///|
pub fn read_atlas_asset_document(path : String) -> AtlasAssetDocument raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidAtlasAssetDocument(err.to_string())
  }
  decode_atlas_asset_document(json)
}

///|
pub fn read_atlas_asset_document_status(
  path : String,
) -> AtlasAssetDocumentLoadStatus raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidAtlasAssetDocument(err.to_string())
  }
  migration_status_for(
    path,
    json,
    decode_atlas_asset_document,
    atlas_asset_migration_preview,
    fn(atlas) { Ready(atlas) },
    fn(preview) { MigrationRequired(preview) },
    AtlasAssetDocumentMigrator::{},
  )
}

///|
pub fn migrate_atlas_asset_document(path : String) -> AtlasAssetDocument raise {
  match read_atlas_asset_document_status(path) {
    Ready(atlas) => atlas
    MigrationRequired(preview) => {
      write_atlas_asset_document(path, preview.atlas)
      preview.atlas
    }
  }
}

///|
pub fn write_atlas_asset_document(
  path : String,
  atlas : AtlasAssetDocument,
) -> Unit raise {
  let errors = validate_atlas_asset_document(atlas)
  guard errors.is_empty() else {
    raise InvalidAtlasAssetDocument(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, atlas)
}

///|
pub fn read_animation_asset_document(
  path : String,
) -> AnimationAssetDocument raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidAnimationAssetDocument(err.to_string())
  }
  decode_animation_asset_document(json)
}

///|
pub fn read_animation_asset_document_status(
  path : String,
) -> AnimationAssetDocumentLoadStatus raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidAnimationAssetDocument(err.to_string())
  }
  migration_status_for(
    path,
    json,
    decode_animation_asset_document,
    animation_asset_migration_preview,
    fn(animation) { Ready(animation) },
    fn(preview) { MigrationRequired(preview) },
    AnimationAssetDocumentMigrator::{},
  )
}

///|
pub fn migrate_animation_asset_document(
  path : String,
) -> AnimationAssetDocument raise {
  match read_animation_asset_document_status(path) {
    Ready(animation) => animation
    MigrationRequired(preview) => {
      write_animation_asset_document(path, preview.animation)
      preview.animation
    }
  }
}

///|
pub fn write_animation_asset_document(
  path : String,
  animation : AnimationAssetDocument,
) -> Unit raise {
  let errors = validate_animation_asset_document(animation)
  guard errors.is_empty() else {
    raise InvalidAnimationAssetDocument(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, animation)
}

///|
pub fn read_workspace_document(path : String) -> WorkspaceDocument raise {
  let json = parse_json_file(path) catch {
    err => raise InvalidWorkspaceDocument(err.to_string())
  }
  let workspace : WorkspaceDocument = try {
    @json.from_json(json)
  } catch {
    err => raise InvalidWorkspaceDocument(err.to_string())
  }
  let errors = validate_workspace_document(workspace)
  guard errors.is_empty() else {
    raise InvalidWorkspaceDocument(errors.to_json().stringify())
  }
  workspace
}

///|
pub fn write_workspace_document(
  path : String,
  workspace : WorkspaceDocument,
) -> Unit raise {
  let errors = validate_workspace_document(workspace)
  guard errors.is_empty() else {
    raise InvalidWorkspaceDocument(errors.to_json().stringify())
  }
  ensure_parent_dir(path)
  write_json_file(path, workspace)
}

///|
fn list_files_recursive(root : String) -> Array[String] raise {
  let files : Array[String] = []
  if !@fs.path_exists(root) {
    return files
  }
  fn visit(path : String, prefix : String) -> Unit raise {
    guard @fs.is_dir(path) else {
      files.push(prefix)
      return
    }
    let entries = @fs.read_dir(path)
    entries.sort()
    for entry in entries {
      let child_path = if path.has_suffix("/") {
        path + entry
      } else {
        path + "/" + entry
      }
      let child_prefix = if prefix == "" {
        entry
      } else if prefix.has_suffix("/") {
        prefix + entry
      } else {
        prefix + "/" + entry
      }
      visit(child_path, child_prefix)
    }
  }
  visit(root, "")
  files
}

///|
pub fn list_scene_documents(root : String) -> Array[SceneRef] raise {
  let refs : Array[SceneRef] = []
  let scenes_root = root + "/scenes"
  for relative in list_files_recursive(scenes_root) {
    if infer_asset_kind(relative) == Scene {
      refs.push(scene_ref("scenes/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
pub fn list_prefab_documents(root : String) -> Array[PrefabRef] raise {
  let refs : Array[PrefabRef] = []
  let prefabs_root = root + "/prefabs"
  for relative in list_files_recursive(prefabs_root) {
    if infer_asset_kind(relative) == Prefab {
      refs.push(prefab_ref("prefabs/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
pub fn list_atlas_assets(root : String) -> Array[AssetRef] raise {
  let refs : Array[AssetRef] = []
  let assets_root = root + "/assets/atlases"
  for relative in list_files_recursive(assets_root) {
    if infer_asset_kind(relative) == Atlas {
      refs.push(asset_ref("assets/atlases/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
pub fn list_animation_assets(root : String) -> Array[AssetRef] raise {
  let refs : Array[AssetRef] = []
  let assets_root = root + "/assets/animations"
  for relative in list_files_recursive(assets_root) {
    if infer_asset_kind(relative) == Animation {
      refs.push(asset_ref("assets/animations/" + relative))
    }
  }
  refs.sort_by(fn(left, right) { left.path.compare(right.path) })
  refs
}

///|
pub fn collect_asset_documents(
  root : String,
  asset_roots : Array[String],
) -> Array[AssetDocument] raise {
  let assets : Array[AssetDocument] = []
  for asset_root in asset_roots {
    let root_path = root + "/" + asset_root
    if !@fs.path_exists(root_path) {
      continue
    }
    for relative in list_files_recursive(root_path) {
      let full_relative = asset_root + "/" + relative
      let meta_relative = full_relative + ".meta.json"
      assets.push(
        asset_document(
          full_relative,
          infer_asset_kind(full_relative),
          meta_path=if @fs.path_exists(root + "/" + meta_relative) {
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
