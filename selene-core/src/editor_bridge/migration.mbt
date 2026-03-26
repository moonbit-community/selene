///|
pub struct MigrationFieldChange {
  path : String
  reason : String
  migrated_value : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneMigrationPreview {
  path : String
  scene : SceneDocument
  changes : Array[MigrationFieldChange]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum SceneDocumentLoadStatus {
  Ready(SceneDocument)
  MigrationRequired(SceneMigrationPreview)
} derive(Show, Eq)

///|
pub fn migration_field_change(
  path : String,
  reason : String,
  migrated_value : String,
) -> MigrationFieldChange {
  { path, reason, migrated_value }
}

///|
pub fn scene_migration_preview(
  path : String,
  scene : SceneDocument,
  changes : Array[MigrationFieldChange],
) -> SceneMigrationPreview {
  { path, scene, changes }
}
