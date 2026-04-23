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
pub fn validation_error(path : String, message : String) -> ValidationError {
  { path, message }
}

///|
fn[T : @json.FromJson] decoded_component_payload(
  component : ComponentDocument,
  path : String,
  invalid_message : String,
) -> Result[T, Array[ValidationError]] {
  let decoded : Result[T, Error] = try? @json.from_json(component.data)
  match decoded {
    Ok(value) => Ok(value)
    Err(_) => Err([validation_error(path, invalid_message)])
  }
}

///|
fn validate_color_doc(
  color : ColorDoc,
  path : String,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  if color.r < 0 || color.r > 255 {
    errors.push(
      validation_error(path + ".r", "Color channel must be in [0, 255]"),
    )
  }
  if color.g < 0 || color.g > 255 {
    errors.push(
      validation_error(path + ".g", "Color channel must be in [0, 255]"),
    )
  }
  if color.b < 0 || color.b > 255 {
    errors.push(
      validation_error(path + ".b", "Color channel must be in [0, 255]"),
    )
  }
  if color.a < 0 || color.a > 255 {
    errors.push(
      validation_error(path + ".a", "Color channel must be in [0, 255]"),
    )
  }
  errors
}

///|
fn validate_positive_vec2_doc(
  value : Vec2Doc,
  path : String,
  message : String,
) -> Array[ValidationError] {
  if value.x <= 0.0 || value.y <= 0.0 {
    [validation_error(path, message)]
  } else {
    []
  }
}

///|
fn validate_optional_positive_vec2_doc(
  value : Vec2Doc?,
  path : String,
  message : String,
) -> Array[ValidationError] {
  match value {
    Some(doc) => validate_positive_vec2_doc(doc, path, message)
    None => []
  }
}

///|
fn validate_optional_rect_doc(
  rect : RectDoc?,
  path : String,
  message : String,
) -> Array[ValidationError] {
  match rect {
    Some(value) =>
      if value.width <= 0.0 || value.height <= 0.0 {
        [validation_error(path, message)]
      } else {
        []
      }
    None => []
  }
}

///|
fn validate_texture_atlas_layout_doc(
  layout : TextureAtlasLayoutDoc,
  path : String,
) -> Array[ValidationError] {
  let errors = validate_positive_vec2_doc(
    layout.tile_size,
    path + ".tile_size",
    "Texture atlas layout tile size must be positive",
  )
  let next = errors
  if layout.columns <= 0 {
    next.push(
      validation_error(
        path + ".columns",
        "Texture atlas layout columns must be positive",
      ),
    )
  }
  if layout.rows <= 0 {
    next.push(
      validation_error(
        path + ".rows",
        "Texture atlas layout rows must be positive",
      ),
    )
  }
  if layout.padding.x < 0.0 || layout.padding.y < 0.0 {
    next.push(
      validation_error(
        path + ".padding",
        "Texture atlas layout padding must be non-negative",
      ),
    )
  }
  next
}

///|
fn valid_animation_repeat_mode_string(repeat_mode : String) -> Bool {
  let normalized = repeat_mode.trim().to_lower()
  if normalized == "" ||
    normalized == "forever" ||
    normalized == "loop" ||
    normalized == "infinite" ||
    normalized == "never" ||
    normalized == "once" ||
    normalized == "count" {
    return true
  }
  if normalized.has_prefix("count:") {
    let count = @string.parse_int(normalized[6:]) catch { _ => 0 }
    return count > 0
  }
  if normalized.has_prefix("count(") && normalized.has_suffix(")") {
    let count = @string.parse_int(normalized[6:normalized.length() - 1]) catch {
      _ => 0
    }
    return count > 0
  }
  false
}

///|
fn validate_builtin_component(
  component : ComponentDocument,
  path : String,
  component_kinds : Map[String, Bool],
) -> Array[ValidationError] {
  match builtin_component_kind_from_string(component.kind) {
    Some(Name) => {
      let decoded : Result[NameComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Name component payload is invalid",
      )
      match decoded {
        Ok(data) =>
          if data.value.trim() == "" {
            [
              validation_error(
                path + ".value",
                "Name component value must not be empty",
              ),
            ]
          } else {
            []
          }
        Err(errors) => errors
      }
    }
    Some(Transform2d) => {
      let decoded : Result[Transform2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Transform2d component payload is invalid",
      )
      match decoded {
        Ok(data) =>
          validate_positive_vec2_doc(
            data.scale,
            path + ".scale",
            "Transform2d scale must be positive",
          )
        Err(errors) => errors
      }
    }
    Some(Visibility) => {
      let decoded : Result[VisibilityComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Visibility component payload is invalid",
      )
      match decoded {
        Ok(_) => []
        Err(errors) => errors
      }
    }
    Some(Sprite) => {
      let decoded : Result[SpriteComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Sprite component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors = validate_color_doc(data.color, path + ".color") +
            validate_optional_positive_vec2_doc(
              data.custom_size,
              path + ".custom_size",
              "Sprite custom size must be positive when present",
            ) +
            validate_optional_rect_doc(
              data.rect,
              path + ".rect",
              "Sprite source rect size must be positive when present",
            )
          let next = errors
          match data.image_path {
            Some(image_path) =>
              if image_path.trim() == "" {
                next.push(
                  validation_error(
                    path + ".image_path",
                    "Sprite image path must not be empty when present",
                  ),
                )
              }
            None =>
              if !component_kinds.contains("TextureAtlas") {
                next.push(
                  validation_error(
                    path + ".image_path",
                    "Sprite must provide an image path or pair with TextureAtlas",
                  ),
                )
              }
          }
          next
        }
        Err(errors) => errors
      }
    }
    Some(TextureAtlas) => {
      let decoded : Result[TextureAtlasComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "TextureAtlas component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors : Array[ValidationError] = []
          match data.atlas_asset_path {
            Some(atlas_path) =>
              if atlas_path.trim() == "" {
                errors.push(
                  validation_error(
                    path + ".atlas_asset_path",
                    "TextureAtlas atlas asset path must not be empty when present",
                  ),
                )
              } else if !atlas_path.has_suffix(".atlas.json") {
                errors.push(
                  validation_error(
                    path + ".atlas_asset_path",
                    "TextureAtlas atlas asset path must point to a .atlas.json file",
                  ),
                )
              }
            None => ()
          }
          match data.region_name {
            Some(region_name) =>
              if region_name.trim() == "" {
                errors.push(
                  validation_error(
                    path + ".region_name",
                    "TextureAtlas region name must not be empty when present",
                  ),
                )
              }
            None => ()
          }
          if data.index < 0 {
            errors.push(
              validation_error(
                path + ".index",
                "TextureAtlas index must be non-negative",
              ),
            )
          }
          if data.atlas_asset_path is None && data.layout is None {
            errors.push(
              validation_error(
                path, "TextureAtlas must provide atlas_asset_path or inline layout",
              ),
            )
          }
          match data.layout {
            Some(layout) =>
              for
                error in validate_texture_atlas_layout_doc(
                  layout,
                  path + ".layout",
                ) {
                errors.push(error)
              }
            None => ()
          }
          errors
        }
        Err(errors) => errors
      }
    }
    Some(AutoTileLayer2d) => validate_autotile_component(component, path)
    Some(Text2d) => {
      let decoded : Result[Text2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Text2d component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors = validate_color_doc(data.color, path + ".color") +
            validate_optional_positive_vec2_doc(
              data.bounds,
              path + ".bounds",
              "Text2d bounds must be positive when present",
            )
          let next = errors
          if data.font_size <= 0.0 {
            next.push(
              validation_error(
                path + ".font_size",
                "Text2d font size must be positive",
              ),
            )
          }
          match data.font_path {
            Some(font_path) =>
              if font_path.trim() == "" {
                next.push(
                  validation_error(
                    path + ".font_path",
                    "Text2d font path must not be empty when present",
                  ),
                )
              }
            None => ()
          }
          next
        }
        Err(errors) => errors
      }
    }
    Some(Mesh2d) => {
      let decoded : Result[Mesh2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Mesh2d component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors = validate_optional_positive_vec2_doc(
            data.size,
            path + ".size",
            "Mesh2d size must be positive when present",
          )
          let next = errors
          if data.primitive != "rectangle" && data.primitive != "circle" {
            next.push(
              validation_error(
                path + ".primitive",
                "Mesh2d primitive must be rectangle or circle",
              ),
            )
          }
          match data.radius {
            Some(radius) =>
              if radius <= 0.0 {
                next.push(
                  validation_error(
                    path + ".radius",
                    "Mesh2d radius must be positive when present",
                  ),
                )
              }
            None => ()
          }
          next
        }
        Err(errors) => errors
      }
    }
    Some(ColorMaterial) => {
      let decoded : Result[ColorMaterialComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "ColorMaterial component payload is invalid",
      )
      match decoded {
        Ok(data) => validate_color_doc(data.color, path + ".color")
        Err(errors) => errors
      }
    }
    Some(Camera2d) => {
      let decoded : Result[Camera2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "Camera2d component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors = validate_optional_rect_doc(
            data.viewport,
            path + ".viewport",
            "Camera2d viewport size must be positive when present",
          )
          let next = errors
          if data.scale <= 0.0 {
            next.push(
              validation_error(
                path + ".scale",
                "Camera2d scale must be positive",
              ),
            )
          }
          next
        }
        Err(errors) => errors
      }
    }
    Some(PhysicsBody2d) => {
      let decoded : Result[PhysicsBody2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "PhysicsBody2d component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors : Array[ValidationError] = []
          let body_type = data.body_type.to_lower()
          if body_type != "dynamic" &&
            body_type != "fixed" &&
            body_type != "kinematic_position_based" &&
            body_type != "kinematic_velocity_based" {
            errors.push(
              validation_error(
                path + ".body_type",
                "PhysicsBody2d body_type is not supported",
              ),
            )
          }
          if data.linear_damping < 0.0 {
            errors.push(
              validation_error(
                path + ".linear_damping",
                "PhysicsBody2d linear damping must be non-negative",
              ),
            )
          }
          if data.angular_damping < 0.0 {
            errors.push(
              validation_error(
                path + ".angular_damping",
                "PhysicsBody2d angular damping must be non-negative",
              ),
            )
          }
          errors
        }
        Err(errors) => errors
      }
    }
    Some(PhysicsCollider2d) => {
      let decoded : Result[PhysicsCollider2dComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "PhysicsCollider2d component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors = validate_optional_positive_vec2_doc(
            data.size,
            path + ".size",
            "PhysicsCollider2d size must be positive when present",
          )
          let next = errors
          let shape = data.shape.to_lower()
          if shape != "rectangle" && shape != "circle" {
            next.push(
              validation_error(
                path + ".shape",
                "PhysicsCollider2d shape must be rectangle or circle",
              ),
            )
          }
          match data.radius {
            Some(radius) =>
              if radius <= 0.0 {
                next.push(
                  validation_error(
                    path + ".radius",
                    "PhysicsCollider2d radius must be positive when present",
                  ),
                )
              }
            None => ()
          }
          if data.friction < 0.0 {
            next.push(
              validation_error(
                path + ".friction",
                "PhysicsCollider2d friction must be non-negative",
              ),
            )
          }
          if data.restitution < 0.0 {
            next.push(
              validation_error(
                path + ".restitution",
                "PhysicsCollider2d restitution must be non-negative",
              ),
            )
          }
          next
        }
        Err(errors) => errors
      }
    }
    Some(AnimationPlayer) => {
      let decoded : Result[AnimationPlayerComponent, Array[ValidationError]] = decoded_component_payload(
        component, path, "AnimationPlayer component payload is invalid",
      )
      match decoded {
        Ok(data) => {
          let errors : Array[ValidationError] = []
          match data.graph_asset_path {
            Some(graph_path) =>
              if graph_path.trim() == "" {
                errors.push(
                  validation_error(
                    path + ".graph_asset_path",
                    "AnimationPlayer graph asset path must not be empty when present",
                  ),
                )
              } else if !graph_path.has_suffix(".graph.json") {
                errors.push(
                  validation_error(
                    path + ".graph_asset_path",
                    "AnimationPlayer graph asset path must point to a .graph.json file",
                  ),
                )
              }
            None => ()
          }
          match data.start_node {
            Some(node_id) =>
              if node_id.trim() == "" {
                errors.push(
                  validation_error(
                    path + ".start_node",
                    "AnimationPlayer start node must not be empty when present",
                  ),
                )
              }
            None => ()
          }
          if data.speed <= 0.0 {
            errors.push(
              validation_error(
                path + ".speed",
                "AnimationPlayer speed must be positive",
              ),
            )
          }
          if data.autoplay && data.graph_asset_path is None {
            errors.push(
              validation_error(
                path + ".autoplay",
                "AnimationPlayer autoplay requires graph_asset_path",
              ),
            )
          }
          if !valid_animation_repeat_mode_string(data.repeat_mode) {
            errors.push(
              validation_error(
                path + ".repeat_mode",
                "AnimationPlayer repeat mode must be never, forever, or count:n",
              ),
            )
          }
          errors
        }
        Err(errors) => errors
      }
    }
    Some(AnimationTransitions) => {
      let decoded : Result[
        AnimationTransitionsComponent,
        Array[ValidationError],
      ] = decoded_component_payload(
        component, path, "AnimationTransitions component payload is invalid",
      )
      match decoded {
        Ok(data) =>
          if data.duration < 0.0 {
            [
              validation_error(
                path + ".duration",
                "AnimationTransitions duration must be non-negative",
              ),
            ]
          } else {
            []
          }
        Err(errors) => errors
      }
    }
    None => []
  }
}

///|
fn validate_entity_component_documents(
  entity : EntityDocument,
  path_prefix : String,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  let component_kinds : Map[String, Bool] = {}
  let builtin_kinds : Map[String, Bool] = {}
  for component in entity.components {
    let component_path = path_prefix +
      "[\{entity.id}].components[\{component.kind}]"
    if component.kind == "" {
      errors.push(
        validation_error(
          path_prefix + "[\{entity.id}].components[]",
          "Component kind must not be empty",
        ),
      )
      continue
    }
    if component_kinds.contains(component.kind) {
      errors.push(
        validation_error(component_path, "Duplicated component kind on entity"),
      )
    } else {
      component_kinds.set(component.kind, true)
    }
    match builtin_component_kind_from_string(component.kind) {
      Some(kind) =>
        builtin_kinds.set(builtin_component_kind_to_string(kind), true)
      None => ()
    }
  }
  for component in entity.components {
    let component_path = path_prefix +
      "[\{entity.id}].components[\{component.kind}]"
    match builtin_component_kind_from_string(component.kind) {
      Some(_) =>
        for
          error in validate_builtin_component(
            component, component_path, component_kinds,
          ) {
          errors.push(error)
        }
      None =>
        match custom_component_handler_for(component.kind) {
          Some(handler) =>
            for error in (handler.validate)(component, component_path) {
              errors.push(error)
            }
          None =>
            for
              error in validate_custom_component_object_payload(
                component, component_path,
              ) {
              errors.push(error)
            }
        }
    }
  }
  for component in entity.components {
    match builtin_component_kind_from_string(component.kind) {
      Some(kind) =>
        for required in required_builtin_components(kind) {
          let required_kind = builtin_component_kind_to_string(required)
          if !builtin_kinds.contains(required_kind) {
            errors.push(
              validation_error(
                path_prefix + "[\{entity.id}].components[\{component.kind}]",
                component.kind +
                " requires " +
                required_kind +
                " on the same entity",
              ),
            )
          }
        }
      None => ()
    }
  }
  errors
}

///|
fn validate_parent_cycles(
  entities : Array[EntityDocument],
  path_prefix : String,
) -> Array[ValidationError] {
  let errors : Array[ValidationError] = []
  let entity_by_id : Map[String, EntityDocument] = {}
  for entity in entities {
    entity_by_id.set(entity.id, entity)
  }
  for entity in entities {
    let visited : Map[String, Bool] = {}
    let mut current = entity.parent
    while current is Some(parent) {
      if parent == entity.id || visited.contains(parent) {
        errors.push(
          validation_error(
            path_prefix + "[\{entity.id}].parent",
            "Parent relationship must not contain cycles",
          ),
        )
        break
      }
      visited.set(parent, true)
      current = entity_by_id
        .get(parent)
        .bind(fn(parent_entity) { parent_entity.parent })
    }
  }
  errors
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
      errors.push(
        validation_error(path_prefix + "[].id", "Entity id must not be empty"),
      )
    }
    if entity.name == "" {
      errors.push(
        validation_error(
          path_prefix + "[\{entity.id}].name",
          "Entity name must not be empty",
        ),
      )
    }
    if seen_ids.contains(entity.id) {
      errors.push(
        validation_error(path_prefix + "[\{entity.id}]", "Duplicated entity id"),
      )
    } else {
      seen_ids.set(entity.id, true)
    }
    for error in validate_entity_component_documents(entity, path_prefix) {
      errors.push(error)
    }
  })
  entities.each(fn(entity) {
    if entity.parent is Some(parent) && !seen_ids.contains(parent) {
      errors.push(
        validation_error(
          path_prefix + "[\{entity.id}].parent",
          "Parent entity does not exist",
        ),
      )
    }
  })
  for error in validate_parent_cycles(entities, path_prefix) {
    errors.push(error)
  }
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
  if workspace.asset_scope is Some(scope) {
    let normalized = scope.trim().to_string().to_lower()
    if normalized != "all" &&
      normalized != "images" &&
      normalized != "atlases" &&
      normalized != "animation_clips" &&
      normalized != "animation_graphs" &&
      normalized != "prefabs" {
      errors.push({
        path: "asset_scope",
        message: "Asset scope must be one of: all, images, atlases, animation_clips, animation_graphs, prefabs",
      })
    }
  }
  errors
}
