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
      "Unexpected schema: expected " + expected_schema + ", got " + envelope.schema,
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
  {
    schema,
    version: document_envelope_version,
    data,
  }.to_json().stringify(indent=2) + "\n"
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
fn decode_animation_graph_data(data : Json) -> AnimationGraphAssetDocument raise {
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
pub fn decode_project_manifest(json : Json) -> ProjectManifest raise {
  decode_manifest_data(
    decode_envelope_data(
      json,
      project_manifest_schema,
      fn(message) { InvalidProjectManifest(message) },
    ),
  )
}

///|
pub fn decode_project_manifest_status(
  path : String,
  json : Json,
) -> ProjectManifestLoadStatus raise {
  ignore(path)
  Ready(decode_project_manifest(json))
}

///|
pub fn decode_scene_snf(json : Json) -> SceneDocument raise {
  decode_scene_data(
    decode_envelope_data(
      json,
      scene_document_schema,
      fn(message) { InvalidSceneDocument(message) },
    ),
  )
}

///|
pub fn encode_scene_snf(scene : SceneDocument) -> String raise {
  ignore(decode_scene_data(scene.to_json()))
  encode_envelope(scene_document_schema, scene.to_json())
}

///|
pub fn decode_prefab_document(json : Json) -> PrefabDocument raise {
  decode_prefab_data(
    decode_envelope_data(
      json,
      prefab_document_schema,
      fn(message) { InvalidPrefabDocument(message) },
    ),
  )
}

///|
pub fn decode_atlas_asset_document(json : Json) -> AtlasAssetDocument raise {
  decode_atlas_data(
    decode_envelope_data(
      json,
      atlas_asset_document_schema,
      fn(message) { InvalidAtlasAssetDocument(message) },
    ),
  )
}

///|
pub fn decode_animation_clip_asset_document(
  json : Json,
) -> AnimationClipAssetDocument raise {
  decode_animation_clip_data(
    decode_envelope_data(
      json,
      animation_clip_asset_document_schema,
      fn(message) { InvalidAnimationClipAssetDocument(message) },
    ),
  )
}

///|
pub fn decode_animation_graph_asset_document(
  json : Json,
) -> AnimationGraphAssetDocument raise {
  decode_animation_graph_data(
    decode_envelope_data(
      json,
      animation_graph_asset_document_schema,
      fn(message) { InvalidAnimationGraphAssetDocument(message) },
    ),
  )
}

///|
pub fn decode_workspace_document(json : Json) -> WorkspaceDocument raise {
  decode_workspace_data(
    decode_envelope_data(
      json,
      workspace_document_schema,
      fn(message) { InvalidWorkspaceDocument(message) },
    ),
  )
}

///|
pub fn decode_scene_snf_status(
  path : String,
  json : Json,
) -> SceneDocumentLoadStatus raise {
  ignore(path)
  Ready(decode_scene_snf(json))
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
pub fn decode_scene_document(json : Json) -> SceneDocument raise {
  decode_scene_snf(json)
}

///|
pub fn decode_scene_document_status(
  path : String,
  json : Json,
) -> SceneDocumentLoadStatus raise {
  decode_scene_snf_status(path, json)
}

///|
pub fn encode_project_manifest_json(manifest : ProjectManifest) -> String raise {
  ignore(decode_manifest_data(manifest.to_json()))
  encode_envelope(project_manifest_schema, manifest.to_json())
}

///|
pub fn encode_prefab_document_json(prefab : PrefabDocument) -> String raise {
  ignore(decode_prefab_data(prefab.to_json()))
  encode_envelope(prefab_document_schema, prefab.to_json())
}

///|
pub fn encode_atlas_asset_document_json(
  atlas : AtlasAssetDocument,
) -> String raise {
  ignore(decode_atlas_data(atlas.to_json()))
  encode_envelope(atlas_asset_document_schema, atlas.to_json())
}

///|
pub fn encode_animation_clip_asset_document_json(
  clip : AnimationClipAssetDocument,
) -> String raise {
  ignore(decode_animation_clip_data(clip.to_json()))
  encode_envelope(animation_clip_asset_document_schema, clip.to_json())
}

///|
pub fn encode_animation_graph_asset_document_json(
  graph : AnimationGraphAssetDocument,
) -> String raise {
  ignore(decode_animation_graph_data(graph.to_json()))
  encode_envelope(animation_graph_asset_document_schema, graph.to_json())
}

///|
pub fn encode_workspace_document_json(workspace : WorkspaceDocument) -> String raise {
  ignore(decode_workspace_data(workspace.to_json()))
  encode_envelope(workspace_document_schema, workspace.to_json())
}
