///|
pub struct ValidationError {
  path : String
  message : String
} derive(Show, Eq, ToJson, FromJson)

///|
fn push_version_error(
  errors : Array[ValidationError],
  path : String,
  actual : Int,
  expected : Int,
) -> Unit {
  if actual != expected {
    errors.push({
      path,
      message: "Unsupported schema version: \{actual}, expected \{expected}",
    })
  }
}

///|
fn validate_entity_documents(
  entities : Array[EntityDocument],
  path_prefix : String,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  let seen_ids : Map[String, Bool] = {}
  entities.each(fn(entity) {
    if entity.id == "" {
      errors.push({
        path: path_prefix + "[].id",
        message: "Entity id must not be empty",
      })
    }
    if entity.name == "" {
      errors.push({
        path: path_prefix + "[\{entity.id}].name",
        message: "Entity name must not be empty",
      })
    }
    if seen_ids.contains(entity.id) {
      errors.push({
        path: path_prefix + "[\{entity.id}]",
        message: "Duplicated entity id",
      })
    } else {
      seen_ids.set(entity.id, true)
    }
    entity.components.each(fn(component) {
      if component.kind == "" {
        errors.push({
          path: path_prefix + "[\{entity.id}].components[]",
          message: "Component kind must not be empty",
        })
      }
    })
  })
  entities.each(fn(entity) {
    if entity.parent is Some(parent) && !seen_ids.contains(parent) {
      errors.push({
        path: path_prefix + "[\{entity.id}].parent",
        message: "Parent entity does not exist",
      })
    }
  })
  errors
}

///|
fn validate_ref_index(
  errors : Array[ValidationError],
  paths : Array[String],
  field : String,
  required_suffix : String,
) -> Unit {
  let seen : Map[String, Bool] = {}
  let mut index = 0
  for path in paths {
    if path.trim() == "" {
      errors.push({
        path: "\{field}[\{index}]",
        message: "Path must not be empty",
      })
    }
    if !path.has_suffix(required_suffix) {
      errors.push({
        path: "\{field}[\{index}]",
        message: "Path must end with " + required_suffix,
      })
    }
    if seen.contains(path) {
      errors.push({
        path: "\{field}[\{index}]",
        message: "Duplicated path in index",
      })
    } else {
      seen.set(path, true)
    }
    index += 1
  }
}

///|
pub fn validate_project_manifest(
  manifest : ProjectManifest,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    manifest.version,
    project_schema_version,
  )
  if manifest.name == "" {
    errors.push({ path: "name", message: "Project name must not be empty" })
  }
  if manifest.startup_scene == "" {
    errors.push({
      path: "startup_scene",
      message: "Startup scene must not be empty",
    })
  }
  if !manifest.startup_scene.has_suffix(".scene.json") {
    errors.push({
      path: "startup_scene",
      message: "Startup scene must point to a .scene.json file",
    })
  }
  if manifest.asset_roots.is_empty() {
    errors.push({
      path: "asset_roots",
      message: "At least one asset root is required",
    })
  }
  validate_ref_index(
    errors,
    manifest.scene_index.map(fn(ref_) { ref_.path }),
    "scene_index",
    ".scene.json",
  )
  validate_ref_index(
    errors,
    manifest.prefab_index.map(fn(ref_) { ref_.path }),
    "prefab_index",
    ".prefab.json",
  )
  validate_ref_index(
    errors,
    manifest.atlas_index.map(fn(ref_) { ref_.path }),
    "atlas_index",
    ".atlas.json",
  )
  validate_ref_index(
    errors,
    manifest.animation_index.map(fn(ref_) { ref_.path }),
    "animation_index",
    ".anim.json",
  )
  errors
}

///|
pub fn validate_scene_document(scene : SceneDocument) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(errors, "version", scene.version, scene_schema_version)
  if scene.name == "" {
    errors.push({ path: "name", message: "Scene name must not be empty" })
  }
  errors + validate_entity_documents(scene.entities, "entities")
}

///|
pub fn validate_prefab_document(
  prefab : PrefabDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(errors, "version", prefab.version, prefab_schema_version)
  if prefab.name == "" {
    errors.push({ path: "name", message: "Prefab name must not be empty" })
  }
  errors + validate_entity_documents(prefab.entities, "entities")
}

///|
pub fn validate_atlas_asset_document(
  atlas : AtlasAssetDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    atlas.version,
    atlas_asset_schema_version,
  )
  if atlas.name == "" {
    errors.push({ path: "name", message: "Atlas name must not be empty" })
  }
  if atlas.source_image == "" {
    errors.push({
      path: "source_image",
      message: "Atlas source image must not be empty",
    })
  }
  if atlas.tile_size.x <= 0.0 || atlas.tile_size.y <= 0.0 {
    errors.push({
      path: "tile_size",
      message: "Atlas tile size must be positive",
    })
  }
  if atlas.columns <= 0 || atlas.rows <= 0 {
    errors.push({
      path: "columns",
      message: "Atlas grid dimensions must be positive",
    })
  }
  let seen_region_names : Map[String, Bool] = {}
  atlas.regions.each(fn(region) {
    if region.name == "" {
      errors.push({
        path: "regions[].name",
        message: "Atlas region name must not be empty",
      })
    }
    if seen_region_names.contains(region.name) {
      errors.push({
        path: "regions[\{region.name}]",
        message: "Duplicated atlas region name",
      })
    } else {
      seen_region_names.set(region.name, true)
    }
    if region.rect.width <= 0.0 || region.rect.height <= 0.0 {
      errors.push({
        path: "regions[\{region.name}].rect",
        message: "Atlas region size must be positive",
      })
    }
  })
  errors
}

///|
pub fn validate_animation_asset_document(
  animation : AnimationAssetDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    animation.version,
    animation_asset_schema_version,
  )
  if animation.name == "" {
    errors.push({
      path: "name",
      message: "Animation asset name must not be empty",
    })
  }
  if animation.atlas_asset_path == "" {
    errors.push({
      path: "atlas_asset_path",
      message: "Animation asset must reference an atlas asset",
    })
  }
  let seen_clip_names : Map[String, Bool] = {}
  animation.clips.each(fn(clip) {
    if clip.name == "" {
      errors.push({
        path: "clips[].name",
        message: "Animation clip name must not be empty",
      })
    }
    if seen_clip_names.contains(clip.name) {
      errors.push({
        path: "clips[\{clip.name}]",
        message: "Duplicated animation clip name",
      })
    } else {
      seen_clip_names.set(clip.name, true)
    }
    if clip.fps <= 0.0 {
      errors.push({
        path: "clips[\{clip.name}].fps",
        message: "Animation clip fps must be positive",
      })
    }
    if clip.frames.is_empty() {
      errors.push({
        path: "clips[\{clip.name}].frames",
        message: "Animation clip must contain at least one frame",
      })
    }
  })
  if animation.default_clip is Some(default_clip) &&
    !seen_clip_names.contains(default_clip) {
    errors.push({
      path: "default_clip",
      message: "Default clip must exist in clips",
    })
  }
  errors
}

///|
pub fn validate_workspace_document(
  workspace : WorkspaceDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    workspace.version,
    workspace_schema_version,
  )
  if workspace.move_snap_step is Some(step) && step <= 0.0 {
    errors.push({
      path: "move_snap_step",
      message: "Move snap step must be positive when present",
    })
  }
  errors
}
