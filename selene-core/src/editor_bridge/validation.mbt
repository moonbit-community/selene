///|
pub struct ValidationError {
  path : String
  message : String
} derive(Show, Eq, ToJson, FromJson)

///|
let supported_component_kinds : Array[String] = [
  "Transform2d", "Visibility", "Sprite", "TextureAtlas", "Text2d", "Mesh2d", "ColorMaterial",
  "Camera2d", "PhysicsBody2d", "PhysicsCollider2d", "TiledMapRef", "LdtkWorldRef",
]

///|
pub fn validate_project_manifest(
  manifest : ProjectManifest,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  if manifest.version != project_schema_version {
    errors.push({
      path: "version",
      message: "Unsupported project schema version: \{manifest.version}",
    })
  }
  if manifest.name == "" {
    errors.push({ path: "name", message: "Project name must not be empty" })
  }
  if manifest.startup_scene == "" {
    errors.push({
      path: "startup_scene",
      message: "Startup scene must not be empty",
    })
  }
  if manifest.asset_roots is [] {
    errors.push({
      path: "asset_roots",
      message: "At least one asset root is required",
    })
  }
  errors
}

///|
pub fn validate_scene_document(scene : SceneDocument) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  if scene.version != scene_schema_version {
    errors.push({
      path: "version",
      message: "Unsupported scene schema version: \{scene.version}",
    })
  }
  let seen_ids : Map[String, Bool] = {}
  scene.entities.each(fn(entity) {
    if entity.id == "" {
      errors.push({
        path: "entities[].id",
        message: "Entity id must not be empty",
      })
    }
    if entity.name == "" {
      errors.push({
        path: "entities[\{entity.id}].name",
        message: "Entity name must not be empty",
      })
    }
    if seen_ids.contains(entity.id) {
      errors.push({
        path: "entities[\{entity.id}]",
        message: "Duplicated entity id",
      })
    } else {
      seen_ids.set(entity.id, true)
    }
    entity.components.each(fn(component) {
      if !supported_component_kinds.contains(component.kind) {
        errors.push({
          path: "entities[\{entity.id}].components[\{component.kind}]",
          message: "Unsupported component kind",
        })
      }
    })
  })
  scene.entities.each(fn(entity) {
    if entity.parent is Some(parent) && !seen_ids.contains(parent) {
      errors.push({
        path: "entities[\{entity.id}].parent",
        message: "Parent entity does not exist",
      })
    }
  })
  errors
}
