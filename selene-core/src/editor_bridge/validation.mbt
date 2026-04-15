///|
pub struct ValidationError {
  path : String
  message : String
} derive(Debug, Eq, ToJson, FromJson)

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
fn validate_autotile_component(
  component : ComponentDocument,
  path_prefix : String,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  let decoded : Result[AutoTileLayer2dComponent, Error] = try? @json.from_json(
    component.data,
  )
  let data = match decoded {
    Ok(value) => value
    Err(_) => {
      errors.push({
        path: path_prefix,
        message: "AutoTileLayer2d component payload is invalid",
      })
      return errors
    }
  }
  if data.atlas_asset_path.trim() == "" {
    errors.push({
      path: path_prefix + ".atlas_asset_path",
      message: "AutoTileLayer2d must reference an atlas asset path",
    })
  }
  if data.tile_size.x <= 0.0 || data.tile_size.y <= 0.0 {
    errors.push({
      path: path_prefix + ".tile_size",
      message: "AutoTileLayer2d tile size must be positive",
    })
  }
  if data.palette.is_empty() {
    errors.push({
      path: path_prefix + ".palette",
      message: "AutoTileLayer2d palette must not be empty",
    })
  }
  let seen_terrains : Map[Int, Bool] = {}
  for entry in data.palette {
    if entry.terrain <= 0 {
      errors.push({
        path: path_prefix + ".palette",
        message: "AutoTile palette terrain must be positive",
      })
    }
    if seen_terrains.contains(entry.terrain) {
      errors.push({
        path: path_prefix + ".palette",
        message: "AutoTile palette contains duplicated terrain id",
      })
    } else {
      seen_terrains.set(entry.terrain, true)
    }
    if entry.fallback_region_name.trim() == "" {
      errors.push({
        path: path_prefix + ".palette",
        message: "AutoTile palette fallback region must not be empty",
      })
    }
    for rule in entry.bitmask4_rules {
      if rule.mask < 0 || rule.mask > 15 {
        errors.push({
          path: path_prefix + ".palette.bitmask4_rules",
          message: "Bitmask4 mask must be in [0, 15]",
        })
      }
      if rule.region_name.trim() == "" {
        errors.push({
          path: path_prefix + ".palette.bitmask4_rules",
          message: "Bitmask4 rule region name must not be empty",
        })
      }
    }
    for rule in entry.bitmask8_rules {
      if rule.mask < 0 || rule.mask > 255 {
        errors.push({
          path: path_prefix + ".palette.bitmask8_rules",
          message: "Bitmask8 mask must be in [0, 255]",
        })
      }
      if rule.region_name.trim() == "" {
        errors.push({
          path: path_prefix + ".palette.bitmask8_rules",
          message: "Bitmask8 rule region name must not be empty",
        })
      }
    }
    for rule in entry.wang_rules {
      if rule.north < 0 || rule.east < 0 || rule.south < 0 || rule.west < 0 {
        errors.push({
          path: path_prefix + ".palette.wang_rules",
          message: "Wang rule edge colors must be non-negative",
        })
      }
      if rule.region_name.trim() == "" {
        errors.push({
          path: path_prefix + ".palette.wang_rules",
          message: "Wang rule region name must not be empty",
        })
      }
    }
  }
  let seen_cells : Map[String, Bool] = {}
  for cell in data.cells {
    let key = cell.x.to_string() + "," + cell.y.to_string()
    if seen_cells.contains(key) {
      errors.push({
        path: path_prefix + ".cells",
        message: "AutoTile cells contain duplicated coordinates",
      })
    } else {
      seen_cells.set(key, true)
    }
    if !seen_terrains.contains(cell.terrain) {
      errors.push({
        path: path_prefix + ".cells",
        message: "AutoTile cell terrain is not defined in palette",
      })
    }
  }
  errors
}

///|
fn validate_scene_autotile_components(
  scene : SceneDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  for entity in scene.entities {
    for component in entity.components {
      if component.kind == "AutoTileLayer2d" {
        let path = "entities[\{entity.id}].components[AutoTileLayer2d]"
        for error in validate_autotile_component(component, path) {
          errors.push(error)
        }
      }
    }
  }
  errors
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
    manifest.animation_clip_index.map(fn(ref_) { ref_.path }),
    "animation_clip_index",
    ".clip.json",
  )
  validate_ref_index(
    errors,
    manifest.animation_graph_index.map(fn(ref_) { ref_.path }),
    "animation_graph_index",
    ".graph.json",
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
  errors +
  validate_entity_documents(scene.entities, "entities") +
  validate_scene_autotile_components(scene)
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
pub fn validate_animation_clip_asset_document(
  clip : AnimationClipAssetDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    clip.version,
    animation_clip_asset_schema_version,
  )
  if clip.name == "" {
    errors.push({
      path: "name",
      message: "Animation clip name must not be empty",
    })
  }
  if clip.atlas_asset_path == "" {
    errors.push({
      path: "atlas_asset_path",
      message: "Animation clip must reference an atlas asset",
    })
  }
  if clip.fps <= 0.0 {
    errors.push({ path: "fps", message: "Animation clip fps must be positive" })
  }
  if clip.frames.is_empty() {
    errors.push({
      path: "frames",
      message: "Animation clip must contain at least one frame",
    })
  }
  errors
}

///|
pub fn validate_animation_graph_asset_document(
  graph : AnimationGraphAssetDocument,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  push_version_error(
    errors,
    "version",
    graph.version,
    animation_graph_asset_schema_version,
  )
  if graph.name == "" {
    errors.push({
      path: "name",
      message: "Animation graph name must not be empty",
    })
  }
  let seen_nodes : Map[String, Bool] = {}
  for node in graph.nodes {
    if node.id == "" {
      errors.push({
        path: "nodes[].id",
        message: "Animation graph node id must not be empty",
      })
    }
    if seen_nodes.contains(node.id) {
      errors.push({
        path: "nodes[\{node.id}]",
        message: "Duplicated animation graph node id",
      })
    } else {
      seen_nodes.set(node.id, true)
    }
    match node.kind {
      Clip(clip_asset_path~) =>
        if clip_asset_path.trim() == "" {
          errors.push({
            path: "nodes[\{node.id}].kind.clip_asset_path",
            message: "Clip node must reference a clip asset path",
          })
        }
      _ => ()
    }
    for group in node.mask_groups {
      if group < 0 || group >= 63 {
        errors.push({
          path: "nodes[\{node.id}].mask_groups",
          message: "Mask group must be in [0, 62]",
        })
      }
    }
  }
  if graph.nodes.is_empty() {
    errors.push({
      path: "nodes",
      message: "Animation graph must contain at least one node",
    })
  }
  if graph.default_node is Some(default_node) &&
    !seen_nodes.contains(default_node) {
    errors.push({
      path: "default_node",
      message: "Default node must exist in graph nodes",
    })
  }
  for node in graph.nodes {
    for edge in node.edges {
      if edge.to.trim() == "" {
        errors.push({
          path: "nodes[\{node.id}].edges[].to",
          message: "Edge target node id must not be empty",
        })
      } else if !seen_nodes.contains(edge.to) {
        errors.push({
          path: "nodes[\{node.id}].edges[\{edge.to}]",
          message: "Edge target node does not exist",
        })
      }
      if edge.weight < 0.0 {
        errors.push({
          path: "nodes[\{node.id}].edges[\{edge.to}].weight",
          message: "Edge weight must be non-negative",
        })
      }
    }
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
  if workspace.sidebar_scene_ratio is Some(ratio) &&
    (ratio <= 0.0 || ratio >= 1.0) {
    errors.push({
      path: "sidebar_scene_ratio",
      message: "Sidebar scene ratio must be in (0, 1) when present",
    })
  }
  if workspace.sidebar_assets_ratio is Some(ratio) &&
    (ratio <= 0.0 || ratio >= 1.0) {
    errors.push({
      path: "sidebar_assets_ratio",
      message: "Sidebar assets ratio must be in (0, 1) when present",
    })
  }
  match (workspace.sidebar_scene_ratio, workspace.sidebar_assets_ratio) {
    (Some(scene_ratio), Some(assets_ratio)) =>
      if scene_ratio + assets_ratio >= 1.0 {
        errors.push({
          path: "sidebar_scene_ratio/sidebar_assets_ratio",
          message: "Sidebar scene and assets ratios must leave room for scene tree",
        })
      }
    _ => ()
  }
  errors
}
