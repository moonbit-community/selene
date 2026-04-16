///|
pub struct MigrationFieldChange {
  path : String
  reason : String
  migrated_value : String
} derive(Eq, ToJson, FromJson)

///|
pub struct ProjectManifestMigrationPreview {
  path : String
  manifest : ProjectManifest
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum ProjectManifestLoadStatus {
  Ready(ProjectManifest)
} derive(Eq, ToJson, FromJson)

///|
pub struct SceneMigrationPreview {
  path : String
  scene : SceneDocument
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum SceneDocumentLoadStatus {
  Ready(SceneDocument)
} derive(Eq, ToJson, FromJson)

///|
pub struct PrefabMigrationPreview {
  path : String
  prefab : PrefabDocument
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum PrefabDocumentLoadStatus {
  Ready(PrefabDocument)
} derive(Eq, ToJson, FromJson)

///|
pub struct AtlasAssetMigrationPreview {
  path : String
  atlas : AtlasAssetDocument
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum AtlasAssetDocumentLoadStatus {
  Ready(AtlasAssetDocument)
} derive(Eq, ToJson, FromJson)

///|
pub struct AnimationClipAssetMigrationPreview {
  path : String
  clip : AnimationClipAssetDocument
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum AnimationClipAssetDocumentLoadStatus {
  Ready(AnimationClipAssetDocument)
} derive(Eq, ToJson, FromJson)

///|
pub struct AnimationGraphAssetMigrationPreview {
  path : String
  graph : AnimationGraphAssetDocument
  changes : Array[MigrationFieldChange]
} derive(Eq, ToJson, FromJson)

///|
pub enum AnimationGraphAssetDocumentLoadStatus {
  Ready(AnimationGraphAssetDocument)
} derive(Eq, ToJson, FromJson)

///|
pub fn migration_field_change(
  path : String,
  reason : String,
  migrated_value : String,
) -> MigrationFieldChange {
  { path, reason, migrated_value }
}

///|
pub fn project_manifest_migration_preview(
  path : String,
  manifest : ProjectManifest,
  changes : Array[MigrationFieldChange],
) -> ProjectManifestMigrationPreview {
  { path, manifest, changes }
}

///|
pub fn scene_migration_preview(
  path : String,
  scene : SceneDocument,
  changes : Array[MigrationFieldChange],
) -> SceneMigrationPreview {
  { path, scene, changes }
}

///|
pub fn prefab_migration_preview(
  path : String,
  prefab : PrefabDocument,
  changes : Array[MigrationFieldChange],
) -> PrefabMigrationPreview {
  { path, prefab, changes }
}

///|
pub fn atlas_asset_migration_preview(
  path : String,
  atlas : AtlasAssetDocument,
  changes : Array[MigrationFieldChange],
) -> AtlasAssetMigrationPreview {
  { path, atlas, changes }
}

///|
pub fn animation_clip_asset_migration_preview(
  path : String,
  clip : AnimationClipAssetDocument,
  changes : Array[MigrationFieldChange],
) -> AnimationClipAssetMigrationPreview {
  { path, clip, changes }
}

///|
pub fn animation_graph_asset_migration_preview(
  path : String,
  graph : AnimationGraphAssetDocument,
  changes : Array[MigrationFieldChange],
) -> AnimationGraphAssetMigrationPreview {
  { path, graph, changes }
}
