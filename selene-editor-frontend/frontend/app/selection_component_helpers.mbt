///|
fn dedup_entity_ids(ids : Array[String]) -> Array[String] {
  let seen : Map[String, Bool] = {}
  let ordered : Array[String] = []
  for id in ids {
    if seen.contains(id) {
      continue
    }
    seen.set(id, true)
    ordered.push(id)
  }
  ordered
}

///|
fn normalize_entity_selection_for_scene(
  scene : @editor_bridge.SceneDocument?,
  primary : String?,
  ids : Array[String],
) -> (String?, Array[String]) {
  let deduped = dedup_entity_ids(ids)
  match scene {
    Some(scene) => {
      let existing : Array[String] = []
      for id in deduped {
        if scene.entity(id) is Some(_) {
          existing.push(id)
        }
      }
      let normalized_primary = match primary {
        Some(id) if scene.entity(id) is Some(_) => Some(id)
        _ => if existing.is_empty() { None } else { Some(existing[0]) }
      }
      let normalized_ids = match normalized_primary {
        Some(id) =>
          if existing.contains(id) {
            existing
          } else {
            [id] + existing
          }
        None => existing
      }
      (normalized_primary, normalized_ids)
    }
    None => (None, [])
  }
}

///|
fn with_entity_selection(
  model : Model,
  primary : String?,
  ids : Array[String],
) -> Model {
  let (selected_entity_id, selected_entity_ids) = normalize_entity_selection_for_scene(
    model_scene(model),
    primary,
    ids,
  )
  {
    ..model,
    selected_entity_id,
    selected_entity_ids,
    workspace: model.workspace.with_selected_entity_id(selected_entity_id),
  }
}

///|
fn with_single_entity_selection(model : Model, id : String?) -> Model {
  match id {
    Some(entity_id) =>
      with_entity_selection(model, Some(entity_id), [entity_id])
    None => with_entity_selection(model, None, [])
  }
}

///|
fn selected_entity_ids_for_edit(model : Model) -> Array[String] {
  let ids = dedup_entity_ids(model.selected_entity_ids)
  if ids.length() > 0 {
    return ids
  }
  match model.selected_entity_id {
    Some(id) => [id]
    None => []
  }
}

///|
fn preferred_entity_selection_ids(
  previous_ids : Array[String],
  fallback_primary : String?,
) -> Array[String] {
  if previous_ids.length() > 0 {
    previous_ids
  } else {
    match fallback_primary {
      Some(id) => [id]
      None => []
    }
  }
}

///|
fn selected_after_load(
  previous : String?,
  scene : @editor_bridge.SceneDocument,
) -> String? {
  match previous {
    Some(id) if scene.entity(id) is Some(_) => Some(id)
    _ =>
      if scene.entities.is_empty() {
        None
      } else {
        Some(scene.entities[0].id)
      }
  }
}

///|
fn restored_entity_selection_for_scene(
  scene : @editor_bridge.SceneDocument,
  previous_primary : String?,
  previous_ids : Array[String],
) -> (String?, Array[String]) {
  let preferred_primary = selected_after_load(previous_primary, scene)
  let preferred_ids = preferred_entity_selection_ids(
    previous_ids, preferred_primary,
  )
  normalize_entity_selection_for_scene(
    Some(scene),
    preferred_primary,
    preferred_ids,
  )
}

///|
pub fn Model::selected_entity_count(self : Model) -> Int {
  selected_entity_ids_for_edit(self).length()
}

///|
pub fn Model::has_entity_selection(self : Model) -> Bool {
  self.selected_entity_count() > 0
}

///|
pub fn[T : FromJson] component_of(
  entity : @editor_bridge.EntityDocument,
  kind : String,
) -> T? {
  match entity.component(kind) {
    Some(component) => Some(@json.from_json(component.data)) catch { _ => None }
    None => None
  }
}

///|
fn component_state_key(entity_id : String, kind : String) -> String {
  entity_id + "::" + kind
}

///|
fn parse_custom_component_json(draft : String) -> Result[Json, String] {
  let source = if draft.trim() == "" { "{}" } else { draft }
  Ok(@json.parse(source)) catch {
    err => Err("Invalid JSON: " + err.to_string())
  }
}

///|
fn update_selected_entity(
  model : Model,
  updater : (@editor_bridge.EntityDocument) -> @editor_bridge.EntityDocument,
) -> Model {
  match (model_scene(model), model.selected_entity_id) {
    (Some(scene), Some(id)) =>
      match scene.entity(id) {
        Some(entity) =>
          with_scene_document_updated(model, fn(_current_scene) {
            scene.with_entity(updater(entity))
          })
        None => model
      }
    _ => model
  }
}

///|
fn update_selected_component(
  model : Model,
  component : @editor_bridge.ComponentDocument,
) -> Model {
  update_selected_entity(model, fn(entity) { entity.with_component(component) })
}

///|
fn update_entity_component(
  model : Model,
  entity_id : String,
  component : @editor_bridge.ComponentDocument,
) -> Model {
  match model_scene(model) {
    Some(scene) =>
      match scene.entity(entity_id) {
        Some(entity) => {
          let next_scene = scene.with_entity(entity.with_component(component))
          with_scene_document_updated(model, fn(_current_scene) { next_scene })
        }
        None => model
      }
    None => model
  }
}

///|
fn with_selected_entities_updated(
  model : Model,
  updater : (String, @editor_bridge.EntityDocument) -> @editor_bridge.EntityDocument?,
) -> Model {
  let mut next = model
  for id in selected_entity_ids_for_edit(model) {
    guard model_scene(next) is Some(scene) else { continue }
    guard scene.entity(id) is Some(entity) else { continue }
    match updater(id, entity) {
      Some(updated_entity) =>
        next = with_scene_document_updated(next, fn(_current_scene) {
          scene.with_entity(updated_entity)
        })
      None => ()
    }
  }
  next
}

///|
fn with_selected_entities_transform_updated(
  model : Model,
  updater : (@editor_bridge.Transform2dComponent) -> @editor_bridge.Transform2dComponent,
) -> Model {
  with_selected_entities_updated(model, fn(_id, entity) {
    let transform : @editor_bridge.Transform2dComponent? = component_of(
      entity, "Transform2d",
    )
    match transform {
      Some(transform) => {
        let next_transform = updater(transform)
        Some(
          entity.with_component(
            @editor_bridge.transform2d_component(
              translation=next_transform.translation,
              rotation=next_transform.rotation,
              scale=next_transform.scale,
            ),
          ),
        )
      }
      None => None
    }
  })
}

///|
fn with_selected_entities_visibility_set(
  model : Model,
  visible : Bool,
) -> Model {
  with_selected_entities_updated(model, fn(_id, entity) {
    let visibility_component : @editor_bridge.VisibilityComponent? = component_of(
      entity, "Visibility",
    )
    match visibility_component {
      Some(_) =>
        Some(
          entity.with_component(@editor_bridge.visibility_component(visible~)),
        )
      None => None
    }
  })
}
