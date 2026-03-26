///|
pub struct MigrationFieldChange {
  path : String
  reason : String
  migrated_value : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub trait Migration {
  migration_changes(Self, String, Json) -> Array[MigrationFieldChange]? raise
  migrate_json(Self, String, Json) -> Json raise
}

///|
pub struct ProjectManifestMigrationPreview {
  path : String
  manifest : ProjectManifest
  changes : Array[MigrationFieldChange]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum ProjectManifestLoadStatus {
  Ready(ProjectManifest)
  MigrationRequired(ProjectManifestMigrationPreview)
} derive(Show, Eq)

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
pub struct PrefabMigrationPreview {
  path : String
  prefab : PrefabDocument
  changes : Array[MigrationFieldChange]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum PrefabDocumentLoadStatus {
  Ready(PrefabDocument)
  MigrationRequired(PrefabMigrationPreview)
} derive(Show, Eq)

///|
pub struct AtlasAssetMigrationPreview {
  path : String
  atlas : AtlasAssetDocument
  changes : Array[MigrationFieldChange]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum AtlasAssetDocumentLoadStatus {
  Ready(AtlasAssetDocument)
  MigrationRequired(AtlasAssetMigrationPreview)
} derive(Show, Eq)

///|
pub struct AnimationAssetMigrationPreview {
  path : String
  animation : AnimationAssetDocument
  changes : Array[MigrationFieldChange]
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum AnimationAssetDocumentLoadStatus {
  Ready(AnimationAssetDocument)
  MigrationRequired(AnimationAssetMigrationPreview)
} derive(Show, Eq)

///|
pub struct ProjectManifestMigrator {}

///|
pub struct SceneDocumentMigrator {}

///|
pub struct PrefabDocumentMigrator {}

///|
pub struct AtlasAssetDocumentMigrator {}

///|
pub struct AnimationAssetDocumentMigrator {}

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
pub fn animation_asset_migration_preview(
  path : String,
  animation : AnimationAssetDocument,
  changes : Array[MigrationFieldChange],
) -> AnimationAssetMigrationPreview {
  { path, animation, changes }
}

///|
fn file_name_of_path(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
}

///|
fn display_name_of_document_path(
  path : String,
  suffix : String,
  fallback : String,
) -> String {
  let file_name = file_name_of_path(path)
  let stem = if file_name.has_suffix(suffix) {
    file_name[:file_name.length() - suffix.length()].to_string()
  } else {
    file_name
  }
  let normalized = stem
    .replace(old="-", new=" ")
    .replace(old="_", new=" ")
    .trim()
    .to_string()
  if normalized == "" {
    return fallback
  }
  let parts : Array[String] = []
  for raw in normalized.split(" ") {
    let token = raw.trim().to_string()
    if token == "" {
      continue
    }
    let head = token[:1].to_string().to_upper()
    let tail = if token.length() > 1 { token[1:].to_string() } else { "" }
    parts.push(head + tail)
  }
  if parts.is_empty() {
    fallback
  } else {
    parts.join(" ")
  }
}

///|
fn migrate_name_or_default(
  field_path : String,
  name : String?,
  fallback : String,
  reason : String,
  changes : Array[MigrationFieldChange],
) -> String {
  match name {
    Some(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        changes.push(migration_field_change(field_path, reason, fallback))
        fallback
      } else {
        name
      }
    }
    None => {
      changes.push(migration_field_change(field_path, reason, fallback))
      fallback
    }
  }
}

///|
fn migrate_optional_vec2_or_default(
  field_path : String,
  value : Vec2Doc?,
  fallback : Vec2Doc,
  reason : String,
  changes : Array[MigrationFieldChange],
) -> Vec2Doc {
  match value {
    Some(value) => value
    None => {
      changes.push(
        migration_field_change(
          field_path,
          reason,
          fallback.to_json().stringify(),
        ),
      )
      fallback
    }
  }
}

///|
fn migrate_entities_from_legacy(
  entities : Array[LegacyEntityDocument],
  changes : Array[MigrationFieldChange],
) -> Array[EntityDocument] {
  entities.map(fn(entity) {
    let entity_name = migrate_name_or_default(
      "entities[\{entity.id}].name",
      entity.name,
      entity.id,
      "Missing required entity name",
      changes,
    )
    let parent = match entity.parent {
      Some(parent) => Some(parent)
      None => {
        changes.push(
          migration_field_change(
            "entities[\{entity.id}].parent",
            "Missing parent field",
            "null",
          ),
        )
        None
      }
    }
    let components = match entity.components {
      Some(components) => components
      None => {
        changes.push(
          migration_field_change(
            "entities[\{entity.id}].components",
            "Missing components array",
            "[]",
          ),
        )
        []
      }
    }
    EntityDocument::{ id: entity.id, name: entity_name, parent, components }
  })
}

///|
fn generated_atlas_regions(
  tile_size : Vec2Doc,
  columns : Int,
  rows : Int,
  spacing : Vec2Doc,
  margin : Vec2Doc,
) -> Array[AtlasRegionDocument] {
  let regions : Array[AtlasRegionDocument] = []
  let mut index = 0
  for row in 0..<rows {
    for column in 0..<columns {
      let x = margin.x + column.to_double() * (tile_size.x + spacing.x)
      let y = margin.y + row.to_double() * (tile_size.y + spacing.y)
      regions.push(
        atlas_region_document(
          "frame_\{index}",
          index,
          rect_doc(x, y, tile_size.x, tile_size.y),
        ),
      )
      index += 1
    }
  }
  regions
}

///|
fn migrate_animation_clips_from_legacy(
  clips : Array[LegacyAnimationClipDocument]?,
  changes : Array[MigrationFieldChange],
) -> Array[AnimationClipDocument] {
  match clips {
    Some(clips) if !clips.is_empty() => {
      let migrated : Array[AnimationClipDocument] = []
      let mut index = 0
      for clip in clips {
        let fallback_name = "clip_\{index}"
        let name = migrate_name_or_default(
          "clips[\{index}].name",
          clip.name,
          fallback_name,
          "Missing animation clip name",
          changes,
        )
        let fps = match clip.fps {
          Some(fps) if fps > 0.0 => fps
          _ => {
            changes.push(
              migration_field_change(
                "clips[\{index}].fps",
                "Missing animation clip fps",
                "8",
              ),
            )
            8.0
          }
        }
        let looping = match clip.looping {
          Some(looping) => looping
          None => {
            changes.push(
              migration_field_change(
                "clips[\{index}].looping",
                "Missing animation clip looping flag",
                "true",
              ),
            )
            true
          }
        }
        let frames = match clip.frames {
          Some(frames) if !frames.is_empty() => frames
          _ => {
            changes.push(
              migration_field_change(
                "clips[\{index}].frames",
                "Missing animation clip frames",
                "[\"frame_0\"]",
              ),
            )
            ["frame_0"]
          }
        }
        migrated.push(animation_clip_document(name, fps, looping, frames))
        index += 1
      }
      migrated
    }
    _ => {
      changes.push(
        migration_field_change(
          "clips", "Missing animation clips", "[default clip]",
        ),
      )
      [animation_clip_document("default", 8.0, true, ["frame_0"])]
    }
  }
}

///|
struct LegacyEntityDocument {
  id : String
  name : String?
  parent : String?
  components : Array[ComponentDocument]?
} derive(FromJson)

///|
struct LegacySceneDocument {
  version : Int
  name : String?
  entities : Array[LegacyEntityDocument]
} derive(FromJson)

///|
struct LegacyPrefabDocument {
  version : Int
  name : String?
  entities : Array[LegacyEntityDocument]
} derive(FromJson)

///|
struct LegacyAtlasAssetDocument {
  version : Int
  name : String?
  source_image : String
  tile_size : Vec2Doc
  columns : Int
  rows : Int
  spacing : Vec2Doc?
  margin : Vec2Doc?
  default_anchor : Vec2Doc?
  regions : Array[AtlasRegionDocument]?
} derive(FromJson)

///|
struct LegacyAnimationClipDocument {
  name : String?
  fps : Double?
  looping : Bool?
  frames : Array[String]?
} derive(FromJson)

///|
struct LegacyAnimationAssetDocument {
  version : Int
  name : String?
  atlas_asset_path : String
  clips : Array[LegacyAnimationClipDocument]?
  default_clip : String?
} derive(FromJson)

///|
struct LegacyProjectManifest {
  version : Int
  name : String
  startup_scene : String
  asset_roots : Array[String]
  scene_index : Array[SceneRef]?
  prefab_index : Array[PrefabRef]?
  atlas_index : Array[AssetRef]?
  animation_index : Array[AssetRef]?
  editor_min_version : String?
} derive(FromJson)

///|
fn decode_legacy_scene_document(json : Json) -> LegacySceneDocument raise {
  @json.from_json(json)
}

///|
fn decode_legacy_prefab_document(json : Json) -> LegacyPrefabDocument raise {
  @json.from_json(json)
}

///|
fn decode_legacy_atlas_asset_document(
  json : Json,
) -> LegacyAtlasAssetDocument raise {
  @json.from_json(json)
}

///|
fn decode_legacy_animation_asset_document(
  json : Json,
) -> LegacyAnimationAssetDocument raise {
  @json.from_json(json)
}

///|
fn decode_legacy_project_manifest(json : Json) -> LegacyProjectManifest raise {
  @json.from_json(json)
}

///|
fn migrated_manifest_scene_index(
  legacy : LegacyProjectManifest,
  changes : Array[MigrationFieldChange],
) -> Array[SceneRef] {
  match legacy.scene_index {
    Some(index) => index
    None => {
      let fallback = if legacy.startup_scene.trim() == "" {
        []
      } else {
        [scene_ref(legacy.startup_scene)]
      }
      changes.push(
        migration_field_change(
          "scene_index",
          "Missing scene index",
          fallback.to_json().stringify(),
        ),
      )
      fallback
    }
  }
}

///|
fn migrated_manifest_prefab_index(
  legacy : LegacyProjectManifest,
  changes : Array[MigrationFieldChange],
) -> Array[PrefabRef] {
  match legacy.prefab_index {
    Some(index) => index
    None => {
      let fallback : Array[PrefabRef] = []
      changes.push(
        migration_field_change(
          "prefab_index",
          "Missing prefab index",
          fallback.to_json().stringify(),
        ),
      )
      fallback
    }
  }
}

///|
fn migrated_manifest_atlas_index(
  legacy : LegacyProjectManifest,
  changes : Array[MigrationFieldChange],
) -> Array[AssetRef] {
  match legacy.atlas_index {
    Some(index) => index
    None => {
      let fallback : Array[AssetRef] = []
      changes.push(
        migration_field_change(
          "atlas_index",
          "Missing atlas index",
          fallback.to_json().stringify(),
        ),
      )
      fallback
    }
  }
}

///|
fn migrated_manifest_animation_index(
  legacy : LegacyProjectManifest,
  changes : Array[MigrationFieldChange],
) -> Array[AssetRef] {
  match legacy.animation_index {
    Some(index) => index
    None => {
      let fallback : Array[AssetRef] = []
      changes.push(
        migration_field_change(
          "animation_index",
          "Missing animation index",
          fallback.to_json().stringify(),
        ),
      )
      fallback
    }
  }
}

///|
impl Migration for ProjectManifestMigrator with migration_changes(
  self,
  _path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_project_manifest(json)
  if legacy.version != project_schema_version {
    return None
  }
  let changes : Array[MigrationFieldChange] = []
  ignore(ProjectManifest::{
    version: project_schema_version,
    name: legacy.name,
    startup_scene: legacy.startup_scene,
    asset_roots: legacy.asset_roots,
    scene_index: migrated_manifest_scene_index(legacy, changes),
    prefab_index: migrated_manifest_prefab_index(legacy, changes),
    atlas_index: migrated_manifest_atlas_index(legacy, changes),
    animation_index: migrated_manifest_animation_index(legacy, changes),
    editor_min_version: legacy.editor_min_version,
  })
  if changes.is_empty() {
    None
  } else {
    Some(changes)
  }
}

///|
impl Migration for ProjectManifestMigrator with migrate_json(self, _path, json) {
  ignore(self)
  let legacy = decode_legacy_project_manifest(json)
  guard legacy.version == project_schema_version else {
    raise InvalidProjectManifest(
      "Project manifest schema version \{legacy.version} is not migratable",
    )
  }
  let ignored_changes : Array[MigrationFieldChange] = []
  ProjectManifest::{
    version: project_schema_version,
    name: legacy.name,
    startup_scene: legacy.startup_scene,
    asset_roots: legacy.asset_roots,
    scene_index: migrated_manifest_scene_index(legacy, ignored_changes),
    prefab_index: migrated_manifest_prefab_index(legacy, ignored_changes),
    atlas_index: migrated_manifest_atlas_index(legacy, ignored_changes),
    animation_index: migrated_manifest_animation_index(legacy, ignored_changes),
    editor_min_version: legacy.editor_min_version,
  }.to_json()
}

///|
impl Migration for SceneDocumentMigrator with migration_changes(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_scene_document(json)
  if legacy.version != scene_schema_version {
    return None
  }
  let changes : Array[MigrationFieldChange] = []
  ignore(SceneDocument::{
    version: scene_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".scene.json", "Scene"),
      "Missing required scene name",
      changes,
    ),
    entities: migrate_entities_from_legacy(legacy.entities, changes),
  })
  if changes.is_empty() {
    None
  } else {
    Some(changes)
  }
}

///|
impl Migration for SceneDocumentMigrator with migrate_json(self, path, json) {
  ignore(self)
  let legacy = decode_legacy_scene_document(json)
  guard legacy.version == scene_schema_version else {
    raise InvalidSceneDocument(
      "Scene document schema version \{legacy.version} is not migratable",
    )
  }
  let ignored_changes : Array[MigrationFieldChange] = []
  SceneDocument::{
    version: scene_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".scene.json", "Scene"),
      "Missing required scene name",
      ignored_changes,
    ),
    entities: migrate_entities_from_legacy(legacy.entities, ignored_changes),
  }.to_json()
}

///|
impl Migration for PrefabDocumentMigrator with migration_changes(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_prefab_document(json)
  if legacy.version != prefab_schema_version {
    return None
  }
  let changes : Array[MigrationFieldChange] = []
  ignore(PrefabDocument::{
    version: prefab_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".prefab.json", "Prefab"),
      "Missing required prefab name",
      changes,
    ),
    entities: migrate_entities_from_legacy(legacy.entities, changes),
  })
  if changes.is_empty() {
    None
  } else {
    Some(changes)
  }
}

///|
impl Migration for PrefabDocumentMigrator with migrate_json(self, path, json) {
  ignore(self)
  let legacy = decode_legacy_prefab_document(json)
  guard legacy.version == prefab_schema_version else {
    raise InvalidPrefabDocument(
      "Prefab document schema version \{legacy.version} is not migratable",
    )
  }
  let ignored_changes : Array[MigrationFieldChange] = []
  PrefabDocument::{
    version: prefab_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".prefab.json", "Prefab"),
      "Missing required prefab name",
      ignored_changes,
    ),
    entities: migrate_entities_from_legacy(legacy.entities, ignored_changes),
  }.to_json()
}

///|
impl Migration for AtlasAssetDocumentMigrator with migration_changes(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_atlas_asset_document(json)
  if legacy.version != atlas_asset_schema_version {
    return None
  }
  let changes : Array[MigrationFieldChange] = []
  let spacing = migrate_optional_vec2_or_default(
    "spacing",
    legacy.spacing,
    vec2_doc(0.0, 0.0),
    "Missing atlas spacing",
    changes,
  )
  let margin = migrate_optional_vec2_or_default(
    "margin",
    legacy.margin,
    vec2_doc(0.0, 0.0),
    "Missing atlas margin",
    changes,
  )
  let default_anchor = migrate_optional_vec2_or_default(
    "default_anchor",
    legacy.default_anchor,
    vec2_doc(0.5, 0.5),
    "Missing atlas default anchor",
    changes,
  )
  match legacy.regions {
    Some(regions) if !regions.is_empty() => ignore(regions)
    _ =>
      changes.push(
        migration_field_change(
          "regions", "Missing atlas regions", "Generated from atlas grid",
        ),
      )
  }
  ignore(AtlasAssetDocument::{
    version: atlas_asset_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".atlas.json", "Atlas"),
      "Missing required atlas name",
      changes,
    ),
    source_image: legacy.source_image,
    tile_size: legacy.tile_size,
    columns: legacy.columns,
    rows: legacy.rows,
    spacing,
    margin,
    default_anchor,
    regions: match legacy.regions {
      Some(regions) if !regions.is_empty() => regions
      _ =>
        generated_atlas_regions(
          legacy.tile_size,
          legacy.columns,
          legacy.rows,
          spacing,
          margin,
        )
    },
  })
  if changes.is_empty() {
    None
  } else {
    Some(changes)
  }
}

///|
impl Migration for AtlasAssetDocumentMigrator with migrate_json(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_atlas_asset_document(json)
  guard legacy.version == atlas_asset_schema_version else {
    raise InvalidAtlasAssetDocument(
      "Atlas document schema version \{legacy.version} is not migratable",
    )
  }
  let spacing = match legacy.spacing {
    Some(spacing) => spacing
    None => vec2_doc(0.0, 0.0)
  }
  let margin = match legacy.margin {
    Some(margin) => margin
    None => vec2_doc(0.0, 0.0)
  }
  AtlasAssetDocument::{
    version: atlas_asset_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".atlas.json", "Atlas"),
      "Missing required atlas name",
      [],
    ),
    source_image: legacy.source_image,
    tile_size: legacy.tile_size,
    columns: legacy.columns,
    rows: legacy.rows,
    spacing,
    margin,
    default_anchor: match legacy.default_anchor {
      Some(anchor) => anchor
      None => vec2_doc(0.5, 0.5)
    },
    regions: match legacy.regions {
      Some(regions) if !regions.is_empty() => regions
      _ =>
        generated_atlas_regions(
          legacy.tile_size,
          legacy.columns,
          legacy.rows,
          spacing,
          margin,
        )
    },
  }.to_json()
}

///|
impl Migration for AnimationAssetDocumentMigrator with migration_changes(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_animation_asset_document(json)
  if legacy.version != animation_asset_schema_version {
    return None
  }
  let changes : Array[MigrationFieldChange] = []
  let clips = migrate_animation_clips_from_legacy(legacy.clips, changes)
  let default_clip = match legacy.default_clip {
    Some(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        let fallback = clips[0].name
        changes.push(
          migration_field_change(
            "default_clip", "Missing animation default clip", fallback,
          ),
        )
        Some(fallback)
      } else {
        Some(name)
      }
    }
    None => {
      let fallback = clips[0].name
      changes.push(
        migration_field_change(
          "default_clip", "Missing animation default clip", fallback,
        ),
      )
      Some(fallback)
    }
  }
  ignore(AnimationAssetDocument::{
    version: animation_asset_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".anim.json", "Animation"),
      "Missing required animation name",
      changes,
    ),
    atlas_asset_path: legacy.atlas_asset_path,
    clips,
    default_clip,
  })
  if changes.is_empty() {
    None
  } else {
    Some(changes)
  }
}

///|
impl Migration for AnimationAssetDocumentMigrator with migrate_json(
  self,
  path,
  json,
) {
  ignore(self)
  let legacy = decode_legacy_animation_asset_document(json)
  guard legacy.version == animation_asset_schema_version else {
    raise InvalidAnimationAssetDocument(
      "Animation document schema version \{legacy.version} is not migratable",
    )
  }
  let ignored_changes : Array[MigrationFieldChange] = []
  let clips = migrate_animation_clips_from_legacy(legacy.clips, ignored_changes)
  AnimationAssetDocument::{
    version: animation_asset_schema_version,
    name: migrate_name_or_default(
      "name",
      legacy.name,
      display_name_of_document_path(path, ".anim.json", "Animation"),
      "Missing required animation name",
      ignored_changes,
    ),
    atlas_asset_path: legacy.atlas_asset_path,
    clips,
    default_clip: match legacy.default_clip {
      Some(name) => {
        let trimmed = name.trim().to_string()
        if trimmed == "" {
          Some(clips[0].name)
        } else {
          Some(name)
        }
      }
      None => Some(clips[0].name)
    },
  }.to_json()
}
