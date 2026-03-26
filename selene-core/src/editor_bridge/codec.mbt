///|
pub suberror EditorBridgeDecodeError {
  MissingDocument(String)
  InvalidProjectManifest(String)
  InvalidSceneDocument(String)
  InvalidPrefabDocument(String)
  InvalidAtlasAssetDocument(String)
  InvalidAnimationAssetDocument(String)
  InvalidWorkspaceDocument(String)
}

///|
fn validation_error_message(errors : Array[ValidationError]) -> String {
  errors.to_json().stringify()
}

///|
pub fn decode_project_manifest(json : Json) -> ProjectManifest raise {
  let manifest : ProjectManifest = @json.from_json(json) catch {
    err => raise InvalidProjectManifest(err.to_string())
  }
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(validation_error_message(errors))
  }
  manifest
}

///|
pub fn decode_project_manifest_status(
  path : String,
  json : Json,
) -> ProjectManifestLoadStatus raise {
  migration_status_for(
    path,
    json,
    decode_project_manifest,
    project_manifest_migration_preview,
    fn(manifest) { Ready(manifest) },
    fn(preview) { MigrationRequired(preview) },
    ProjectManifestMigrator::{  },
  )
}

///|
pub fn decode_scene_document(json : Json) -> SceneDocument raise {
  let scene : SceneDocument = @json.from_json(json) catch {
    err => raise InvalidSceneDocument(err.to_string())
  }
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(validation_error_message(errors))
  }
  scene
}

///|
pub fn decode_prefab_document(json : Json) -> PrefabDocument raise {
  let prefab : PrefabDocument = @json.from_json(json) catch {
    err => raise InvalidPrefabDocument(err.to_string())
  }
  let errors = validate_prefab_document(prefab)
  guard errors.is_empty() else {
    raise InvalidPrefabDocument(validation_error_message(errors))
  }
  prefab
}

///|
pub fn decode_atlas_asset_document(json : Json) -> AtlasAssetDocument raise {
  let atlas : AtlasAssetDocument = @json.from_json(json) catch {
    err => raise InvalidAtlasAssetDocument(err.to_string())
  }
  let errors = validate_atlas_asset_document(atlas)
  guard errors.is_empty() else {
    raise InvalidAtlasAssetDocument(validation_error_message(errors))
  }
  atlas
}

///|
pub fn decode_animation_asset_document(
  json : Json,
) -> AnimationAssetDocument raise {
  let animation : AnimationAssetDocument = @json.from_json(json) catch {
    err => raise InvalidAnimationAssetDocument(err.to_string())
  }
  let errors = validate_animation_asset_document(animation)
  guard errors.is_empty() else {
    raise InvalidAnimationAssetDocument(validation_error_message(errors))
  }
  animation
}

///|
pub fn decode_workspace_document(json : Json) -> WorkspaceDocument raise {
  let workspace : WorkspaceDocument = @json.from_json(json) catch {
    err => raise InvalidWorkspaceDocument(err.to_string())
  }
  let errors = validate_workspace_document(workspace)
  guard errors.is_empty() else {
    raise InvalidWorkspaceDocument(validation_error_message(errors))
  }
  workspace
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
      let changes_result : Result[Array[MigrationFieldChange]?, Error] = try? migrator.migration_changes(
        path, json,
      )
      match changes_result {
        Ok(Some(changes)) => {
          let migrated_json_result : Result[Json, Error] = try? migrator.migrate_json(
            path, json,
          )
          match migrated_json_result {
            Ok(migrated_json) => {
              let migrated_result : Result[T, Error] = try? decode_current(
                migrated_json,
              )
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
pub fn decode_scene_document_status(
  path : String,
  json : Json,
) -> SceneDocumentLoadStatus raise {
  migration_status_for(
    path,
    json,
    decode_scene_document,
    scene_migration_preview,
    fn(scene) { Ready(scene) },
    fn(preview) { MigrationRequired(preview) },
    SceneDocumentMigrator::{  },
  )
}

///|
pub fn decode_prefab_document_status(
  path : String,
  json : Json,
) -> PrefabDocumentLoadStatus raise {
  migration_status_for(
    path,
    json,
    decode_prefab_document,
    prefab_migration_preview,
    fn(prefab) { Ready(prefab) },
    fn(preview) { MigrationRequired(preview) },
    PrefabDocumentMigrator::{  },
  )
}

///|
pub fn decode_atlas_asset_document_status(
  path : String,
  json : Json,
) -> AtlasAssetDocumentLoadStatus raise {
  migration_status_for(
    path,
    json,
    decode_atlas_asset_document,
    atlas_asset_migration_preview,
    fn(atlas) { Ready(atlas) },
    fn(preview) { MigrationRequired(preview) },
    AtlasAssetDocumentMigrator::{  },
  )
}

///|
pub fn decode_animation_asset_document_status(
  path : String,
  json : Json,
) -> AnimationAssetDocumentLoadStatus raise {
  migration_status_for(
    path,
    json,
    decode_animation_asset_document,
    animation_asset_migration_preview,
    fn(animation) { Ready(animation) },
    fn(preview) { MigrationRequired(preview) },
    AnimationAssetDocumentMigrator::{  },
  )
}

///|
pub fn migrate_scene_document_json(
  path : String,
  json : Json,
) -> SceneDocument raise {
  match decode_scene_document_status(path, json) {
    Ready(scene) => scene
    MigrationRequired(preview) => preview.scene
  }
}

///|
pub fn migrate_project_manifest_json(
  path : String,
  json : Json,
) -> ProjectManifest raise {
  match decode_project_manifest_status(path, json) {
    Ready(manifest) => manifest
    MigrationRequired(preview) => preview.manifest
  }
}

///|
pub fn migrate_prefab_document_json(
  path : String,
  json : Json,
) -> PrefabDocument raise {
  match decode_prefab_document_status(path, json) {
    Ready(prefab) => prefab
    MigrationRequired(preview) => preview.prefab
  }
}

///|
pub fn migrate_atlas_asset_document_json(
  path : String,
  json : Json,
) -> AtlasAssetDocument raise {
  match decode_atlas_asset_document_status(path, json) {
    Ready(atlas) => atlas
    MigrationRequired(preview) => preview.atlas
  }
}

///|
pub fn migrate_animation_asset_document_json(
  path : String,
  json : Json,
) -> AnimationAssetDocument raise {
  match decode_animation_asset_document_status(path, json) {
    Ready(animation) => animation
    MigrationRequired(preview) => preview.animation
  }
}
