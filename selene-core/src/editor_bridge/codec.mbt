///|
pub suberror EditorBridgeDecodeError {
  MissingDocument(String)
  InvalidProjectManifest(String)
  InvalidSceneDocument(String)
  InvalidPrefabDocument(String)
  InvalidAtlasAssetDocument(String)
  InvalidAnimationClipAssetDocument(String)
  InvalidAnimationGraphAssetDocument(String)
  InvalidWorkspaceDocument(String)
}

///|
pub struct DocumentEnvelope {
  schema : String
  version : Int
  data : Json
} derive(Eq, ToJson, FromJson)

///|
pub let project_manifest_schema = "selene/project_manifest"

///|
pub let scene_document_schema = "selene/scene_document"

///|
pub let prefab_document_schema = "selene/prefab_document"

///|
pub let atlas_asset_document_schema = "selene/atlas_asset_document"

///|
pub let animation_clip_asset_document_schema = "selene/animation_clip_asset_document"

///|
pub let animation_graph_asset_document_schema = "selene/animation_graph_asset_document"

///|
pub let workspace_document_schema = "selene/workspace_document"

///|
priv struct LegacyProjectManifestDocument {
  version : Int?
  name : String?
  startup_scene : String?
  asset_roots : Array[String]?
  scene_index : Array[SceneRef]?
  prefab_index : Array[PrefabRef]?
  atlas_index : Array[AssetRef]?
  animation_clip_index : Array[AssetRef]?
  animation_graph_index : Array[AssetRef]?
} derive(FromJson)

///|
priv struct LegacySceneDocument {
  version : Int?
  name : String?
  entities : Array[LegacyEntityDocument]?
} derive(FromJson)

///|
priv struct LegacyEntityDocument {
  id : String?
  name : String?
  parent : String?
  components : Array[ComponentDocument]?
} derive(FromJson)

///|
fn validation_error_message(errors : Array[ValidationError]) -> String {
  errors.to_json().stringify()
}

///|
fn decode_envelope_data(
  json : Json,
  expected_schema : String,
  invalid : (String) -> Error,
) -> Json raise {
  let envelope : DocumentEnvelope = @json.from_json(json) catch {
    err => raise invalid("Invalid envelope: " + err.to_string())
  }
  if envelope.schema != expected_schema {
    raise invalid(
      "Unexpected schema: expected " +
      expected_schema +
      ", got " +
      envelope.schema,
    )
  }
  if envelope.version != document_envelope_version {
    raise invalid(
      "Unexpected envelope version: expected " +
      document_envelope_version.to_string() +
      ", got " +
      envelope.version.to_string(),
    )
  }
  envelope.data
}

///|
fn encode_envelope(schema : String, data : Json) -> String {
  { schema, version: document_envelope_version, data }
  .to_json()
  .stringify(indent=2) +
  "\n"
}

///|
fn normalized_document_name(value : String?, fallback : String) -> String {
  match value {
    Some(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        fallback
      } else {
        trimmed
      }
    }
    None => fallback
  }
}

///|
fn migrated_legacy_scene_entities(
  entities : Array[LegacyEntityDocument]?,
) -> Array[EntityDocument] {
  let result : Array[EntityDocument] = []
  for index, entity in entities.unwrap_or([]) {
    let id = normalized_document_name(entity.id, "entity-\{index + 1}")
    result.push({
      id,
      name: normalized_document_name(entity.name, id),
      parent: entity.parent,
      components: entity.components.unwrap_or([]),
    })
  }
  result
}

///|
fn decode_manifest_data(data : Json) -> ProjectManifest raise {
  let manifest : ProjectManifest = @json.from_json(data) catch {
    err => raise InvalidProjectManifest(err.to_string())
  }
  let errors = validate_project_manifest(manifest)
  guard errors.is_empty() else {
    raise InvalidProjectManifest(validation_error_message(errors))
  }
  manifest
}

///|
fn decode_scene_data(data : Json) -> SceneDocument raise {
  let scene : SceneDocument = @json.from_json(data) catch {
    err => raise InvalidSceneDocument(err.to_string())
  }
  let errors = validate_scene_document(scene)
  guard errors.is_empty() else {
    raise InvalidSceneDocument(validation_error_message(errors))
  }
  scene
}

///|
fn decode_prefab_data(data : Json) -> PrefabDocument raise {
  let prefab : PrefabDocument = @json.from_json(data) catch {
    err => raise InvalidPrefabDocument(err.to_string())
  }
  let errors = validate_prefab_document(prefab)
  guard errors.is_empty() else {
    raise InvalidPrefabDocument(validation_error_message(errors))
  }
  prefab
}

///|
fn decode_atlas_data(data : Json) -> AtlasAssetDocument raise {
  let atlas : AtlasAssetDocument = @json.from_json(data) catch {
    err => raise InvalidAtlasAssetDocument(err.to_string())
  }
  let errors = validate_atlas_asset_document(atlas)
  guard errors.is_empty() else {
    raise InvalidAtlasAssetDocument(validation_error_message(errors))
  }
  atlas
}

///|
fn decode_animation_clip_data(data : Json) -> AnimationClipAssetDocument raise {
  let clip : AnimationClipAssetDocument = @json.from_json(data) catch {
    err => raise InvalidAnimationClipAssetDocument(err.to_string())
  }
  let errors = validate_animation_clip_asset_document(clip)
  guard errors.is_empty() else {
    raise InvalidAnimationClipAssetDocument(validation_error_message(errors))
  }
  clip
}

///|
fn decode_animation_graph_data(
  data : Json,
) -> AnimationGraphAssetDocument raise {
  let graph : AnimationGraphAssetDocument = @json.from_json(data) catch {
    err => raise InvalidAnimationGraphAssetDocument(err.to_string())
  }
  let errors = validate_animation_graph_asset_document(graph)
  guard errors.is_empty() else {
    raise InvalidAnimationGraphAssetDocument(validation_error_message(errors))
  }
  graph
}

///|
fn decode_workspace_data(data : Json) -> WorkspaceDocument raise {
  let workspace : WorkspaceDocument = @json.from_json(data) catch {
    err => raise InvalidWorkspaceDocument(err.to_string())
  }
  let errors = validate_workspace_document(workspace)
  guard errors.is_empty() else {
    raise InvalidWorkspaceDocument(validation_error_message(errors))
  }
  workspace
}

///|
fn migrate_project_manifest_preview_from_legacy(
  path : String,
  json : Json,
) -> ProjectManifestMigrationPreview raise {
  let legacy : LegacyProjectManifestDocument = @json.from_json(json) catch {
    err => raise InvalidProjectManifest("Invalid envelope: " + err.to_string())
  }
  let legacy_version = legacy.version.unwrap_or(0)
  if legacy_version < 2 || legacy_version >= project_schema_version {
    raise InvalidProjectManifest(
      "Unsupported legacy project version: " + legacy_version.to_string(),
    )
  }
  let name = normalized_document_name(legacy.name, "Project")
  let startup_scene = normalized_document_name(
    legacy.startup_scene,
    startup_scene_path_for_name(name),
  )
  let default_manifest = ProjectManifest::default(name, startup_scene~)
  let asset_roots = match legacy.asset_roots {
    Some(roots) if !roots.is_empty() => roots
    _ => default_manifest.asset_roots
  }
  let scene_index = match legacy.scene_index {
    Some(index) if !index.is_empty() => index
    _ => [scene_ref(startup_scene)]
  }
  let manifest = {
    ..default_manifest,
    asset_roots,
    scene_index,
    prefab_index: legacy.prefab_index.unwrap_or([]),
    atlas_index: legacy.atlas_index.unwrap_or([]),
    animation_clip_index: legacy.animation_clip_index.unwrap_or([]),
    animation_graph_index: legacy.animation_graph_index.unwrap_or([]),
  }
  let validation_errors = validate_project_manifest(manifest)
  guard validation_errors.is_empty() else {
    raise InvalidProjectManifest(validation_error_message(validation_errors))
  }
  let changes : Array[MigrationFieldChange] = []
  changes.push(
    migration_field_change(
      "version",
      "Legacy project document uses a previous schema version",
      project_schema_version.to_string(),
    ),
  )
  if legacy.scene_index is None || legacy.scene_index.unwrap_or([]).is_empty() {
    changes.push(
      migration_field_change(
        "scene_index",
        "Legacy project document has no explicit scene index",
        manifest.scene_index.to_json().stringify(),
      ),
    )
  }
  if legacy.prefab_index is None {
    changes.push(
      migration_field_change(
        "prefab_index", "Legacy project document has no explicit prefab index", "[]",
      ),
    )
  }
  if legacy.atlas_index is None {
    changes.push(
      migration_field_change(
        "atlas_index", "Legacy project document has no explicit atlas index", "[]",
      ),
    )
  }
  if legacy.animation_clip_index is None {
    changes.push(
      migration_field_change(
        "animation_clip_index", "Legacy project document has no explicit animation clip index",
        "[]",
      ),
    )
  }
  if legacy.animation_graph_index is None {
    changes.push(
      migration_field_change(
        "animation_graph_index", "Legacy project document has no explicit animation graph index",
        "[]",
      ),
    )
  }
  project_manifest_migration_preview(path, manifest, changes)
}

///|
fn migrate_scene_preview_from_legacy(
  path : String,
  json : Json,
) -> SceneMigrationPreview raise {
  let legacy : LegacySceneDocument = @json.from_json(json) catch {
    err => raise InvalidSceneDocument("Invalid envelope: " + err.to_string())
  }
  let legacy_version = legacy.version.unwrap_or(0)
  if legacy_version < 2 || legacy_version >= scene_schema_version {
    raise InvalidSceneDocument(
      "Unsupported legacy scene version: " + legacy_version.to_string(),
    )
  }
  let scene : SceneDocument = {
    version: scene_schema_version,
    name: normalized_document_name(legacy.name, "Main"),
    entities: migrated_legacy_scene_entities(legacy.entities),
  }
  let validation_errors = validate_scene_document(scene)
  guard validation_errors.is_empty() else {
    raise InvalidSceneDocument(validation_error_message(validation_errors))
  }
  let changes : Array[MigrationFieldChange] = []
  changes.push(
    migration_field_change(
      "version",
      "Legacy scene document uses a previous schema version",
      scene_schema_version.to_string(),
    ),
  )
  if legacy.name is None || legacy.name.unwrap_or("").trim() == "" {
    changes.push(
      migration_field_change(
        "name",
        "Legacy scene document has no explicit scene name",
        scene.name,
      ),
    )
  }
  scene_migration_preview(path, scene, changes)
}

///|
pub fn decode_project_manifest(json : Json) -> ProjectManifest raise {
  decode_manifest_data(
    decode_envelope_data(json, project_manifest_schema, fn(message) {
      InvalidProjectManifest(message)
    }),
  )
}

///|
pub fn decode_project_manifest_status(
  path : String,
  json : Json,
) -> ProjectManifestLoadStatus raise {
  let strict : Result[ProjectManifest, Error] = try? decode_project_manifest(
    json,
  )
  match strict {
    Ok(manifest) => Ready(manifest)
    Err(InvalidProjectManifest(message)) => {
      let legacy : Result[ProjectManifestMigrationPreview, Error] = try? migrate_project_manifest_preview_from_legacy(
        path, json,
      )
      match legacy {
        Ok(preview) => MigrationRequired(preview)
        Err(_) => raise InvalidProjectManifest(message)
      }
    }
    Err(err) => raise err
  }
}

///|
pub fn decode_scene_sdf(json : Json) -> SceneDocument raise {
  decode_scene_data(
    decode_envelope_data(json, scene_document_schema, fn(message) {
      InvalidSceneDocument(message)
    }),
  )
}

///|
pub fn encode_scene_sdf(scene : SceneDocument) -> String raise {
  ignore(decode_scene_data(scene.to_json()))
  encode_envelope(scene_document_schema, scene.to_json())
}

///|
pub fn decode_prefab_document(json : Json) -> PrefabDocument raise {
  decode_prefab_data(
    decode_envelope_data(json, prefab_document_schema, fn(message) {
      InvalidPrefabDocument(message)
    }),
  )
}

///|
pub fn decode_atlas_asset_document(json : Json) -> AtlasAssetDocument raise {
  decode_atlas_data(
    decode_envelope_data(json, atlas_asset_document_schema, fn(message) {
      InvalidAtlasAssetDocument(message)
    }),
  )
}

///|
pub fn decode_animation_clip_asset_document(
  json : Json,
) -> AnimationClipAssetDocument raise {
  decode_animation_clip_data(
    decode_envelope_data(json, animation_clip_asset_document_schema, fn(
      message,
    ) {
      InvalidAnimationClipAssetDocument(message)
    }),
  )
}

///|
pub fn decode_animation_graph_asset_document(
  json : Json,
) -> AnimationGraphAssetDocument raise {
  decode_animation_graph_data(
    decode_envelope_data(json, animation_graph_asset_document_schema, fn(
      message,
    ) {
      InvalidAnimationGraphAssetDocument(message)
    }),
  )
}

///|
pub fn decode_workspace_document(json : Json) -> WorkspaceDocument raise {
  decode_workspace_data(
    decode_envelope_data(json, workspace_document_schema, fn(message) {
      InvalidWorkspaceDocument(message)
    }),
  )
}

///|
pub fn decode_scene_sdf_status(
  path : String,
  json : Json,
) -> SceneDocumentLoadStatus raise {
  let strict : Result[SceneDocument, Error] = try? decode_scene_sdf(json)
  match strict {
    Ok(scene) => Ready(scene)
    Err(InvalidSceneDocument(message)) => {
      let legacy : Result[SceneMigrationPreview, Error] = try? migrate_scene_preview_from_legacy(
        path, json,
      )
      match legacy {
        Ok(preview) => MigrationRequired(preview)
        Err(_) => raise InvalidSceneDocument(message)
      }
    }
    Err(err) => raise err
  }
}

///|
pub fn decode_prefab_document_status(
  path : String,
  json : Json,
) -> PrefabDocumentLoadStatus raise {
  ignore(path)
  Ready(decode_prefab_document(json))
}

///|
pub fn decode_atlas_asset_document_status(
  path : String,
  json : Json,
) -> AtlasAssetDocumentLoadStatus raise {
  ignore(path)
  Ready(decode_atlas_asset_document(json))
}

///|
pub fn decode_animation_clip_asset_document_status(
  path : String,
  json : Json,
) -> AnimationClipAssetDocumentLoadStatus raise {
  ignore(path)
  Ready(decode_animation_clip_asset_document(json))
}

///|
pub fn decode_animation_graph_asset_document_status(
  path : String,
  json : Json,
) -> AnimationGraphAssetDocumentLoadStatus raise {
  ignore(path)
  Ready(decode_animation_graph_asset_document(json))
}

///|
pub fn migrate_scene_to_sdf(path : String, json : Json) -> SceneDocument raise {
  match decode_scene_sdf_status(path, json) {
    Ready(scene) => scene
    MigrationRequired(preview) => preview.scene
  }
}

///|
pub fn encode_project_manifest(manifest : ProjectManifest) -> String raise {
  ignore(decode_manifest_data(manifest.to_json()))
  encode_envelope(project_manifest_schema, manifest.to_json())
}

///|
pub fn encode_prefab_document(prefab : PrefabDocument) -> String raise {
  ignore(decode_prefab_data(prefab.to_json()))
  encode_envelope(prefab_document_schema, prefab.to_json())
}

///|
pub fn encode_atlas_asset_document(atlas : AtlasAssetDocument) -> String raise {
  ignore(decode_atlas_data(atlas.to_json()))
  encode_envelope(atlas_asset_document_schema, atlas.to_json())
}

///|
pub fn encode_animation_clip_asset_document(
  clip : AnimationClipAssetDocument,
) -> String raise {
  ignore(decode_animation_clip_data(clip.to_json()))
  encode_envelope(animation_clip_asset_document_schema, clip.to_json())
}

///|
pub fn encode_animation_graph_asset_document(
  graph : AnimationGraphAssetDocument,
) -> String raise {
  ignore(decode_animation_graph_data(graph.to_json()))
  encode_envelope(animation_graph_asset_document_schema, graph.to_json())
}

///|
pub fn encode_workspace_document(workspace : WorkspaceDocument) -> String raise {
  ignore(decode_workspace_data(workspace.to_json()))
  encode_envelope(workspace_document_schema, workspace.to_json())
}
