///|
fn collect_required_builtin_components(
  kind : @editor_bridge.BuiltinComponentKind,
  visited : Map[String, Bool],
  ordered : Array[@editor_bridge.BuiltinComponentKind],
) -> Unit {
  let key = @editor_bridge.builtin_component_kind_to_string(kind)
  if visited.contains(key) {
    return
  }
  visited.set(key, true)
  for dependency in @editor_bridge.required_builtin_components(kind) {
    collect_required_builtin_components(dependency, visited, ordered)
  }
  ordered.push(kind)
}

///|
fn ordered_required_builtin_components(
  kind : @editor_bridge.BuiltinComponentKind,
) -> Array[@editor_bridge.BuiltinComponentKind] {
  let ordered : Array[@editor_bridge.BuiltinComponentKind] = []
  collect_required_builtin_components(kind, {}, ordered)
  ordered
}

///|
fn builtin_requires_component(
  candidate : @editor_bridge.BuiltinComponentKind,
  target : @editor_bridge.BuiltinComponentKind,
) -> Bool {
  if candidate == target {
    return false
  }
  let required = ordered_required_builtin_components(candidate)
  for kind in required {
    if kind == target {
      return true
    }
  }
  false
}

///|
fn remove_component_block_reason_for_entity(
  entity : @editor_bridge.EntityDocument,
  kind : String,
) -> String? {
  match @editor_bridge.builtin_component_kind_from_string(kind) {
    Some(builtin_kind) => {
      if !@editor_bridge.removable_builtin_component(builtin_kind) {
        return Some("\{kind} is required and cannot be removed")
      }
      let blocked_by : Array[String] = []
      let blocked_kind_seen : Map[String, Bool] = {}
      for component in entity.components {
        if component.kind == kind {
          continue
        }
        match
          @editor_bridge.builtin_component_kind_from_string(component.kind) {
          Some(candidate) if builtin_requires_component(candidate, builtin_kind) => {
            let candidate_kind = @editor_bridge.builtin_component_kind_to_string(
              candidate,
            )
            if !blocked_kind_seen.contains(candidate_kind) {
              blocked_kind_seen.set(candidate_kind, true)
              blocked_by.push(candidate_kind)
            }
          }
          _ => ()
        }
      }
      if blocked_by.length() > 0 {
        Some("Required by " + blocked_by.join(", "))
      } else {
        None
      }
    }
    None => None
  }
}

///|
fn with_component_card_collapsed(
  model : Model,
  entity_id : String,
  kind : String,
) -> Model {
  let key = component_state_key(entity_id, kind)
  let collapsed_component_cards = model.collapsed_component_cards
  let is_collapsed = collapsed_component_cards.get(key).unwrap_or(false)
  collapsed_component_cards.set(key, !is_collapsed)
  { ..model, collapsed_component_cards, }
}

///|
fn with_component_removed(
  model : Model,
  kind : String,
) -> Result[Model, String] {
  match model.selected_entity() {
    Some(entity) => {
      if entity.component(kind) is None {
        return Err("\{kind} is not on this entity")
      }
      match remove_component_block_reason_for_entity(entity, kind) {
        Some(reason) => Err("Cannot remove \{kind}: \{reason}")
        None => {
          let next = update_selected_entity(model, fn(selected) {
            selected.without_component(kind)
          })
          let component_key = component_state_key(entity.id, kind)
          let collapsed_component_cards = next.collapsed_component_cards
          collapsed_component_cards.remove(component_key) |> ignore
          let custom_component_json_drafts = next.custom_component_json_drafts
          custom_component_json_drafts.remove(component_key) |> ignore
          let custom_component_json_errors = next.custom_component_json_errors
          custom_component_json_errors.remove(component_key) |> ignore
          Ok({
            ..next,
            collapsed_component_cards,
            custom_component_json_drafts,
            custom_component_json_errors,
            open_component_menu_kind: if next.open_component_menu_kind ==
              Some(kind) {
              None
            } else {
              next.open_component_menu_kind
            },
          })
        }
      }
    }
    None => Err("Select an entity first")
  }
}

///|
fn with_builtin_component_added(
  model : Model,
  kind : @editor_bridge.BuiltinComponentKind,
) -> (Model, Array[String]) {
  match model.selected_entity() {
    Some(entity) => {
      let mut next_entity = entity
      let added : Array[String] = []
      for current_kind in ordered_required_builtin_components(kind) {
        let kind_name = @editor_bridge.builtin_component_kind_to_string(
          current_kind,
        )
        if next_entity.component(kind_name) is None {
          next_entity = next_entity.with_component(
            @editor_bridge.default_component_document(current_kind),
          )
          added.push(kind_name)
        }
      }
      (
        {
          ..update_selected_entity(model, fn(_) { next_entity }),
          add_component_panel_open: true,
        },
        added,
      )
    }
    None => (model, [])
  }
}

///|
fn validated_custom_component_kind(raw_kind : String) -> Result[String, String] {
  let kind = raw_kind.trim().to_string()
  if kind == "" {
    return Err("Component kind is required")
  }
  if @editor_bridge.builtin_component_kind_from_string(kind) is Some(_) {
    return Err("Custom kind conflicts with a built-in component")
  }
  Ok(kind)
}

///|
pub fn Model::component_search_query_normalized(self : Model) -> String {
  self.component_search_query.trim().to_string().to_lower()
}

///|
pub fn Model::builtin_component_matches_query(
  self : Model,
  kind : @editor_bridge.BuiltinComponentKind,
) -> Bool {
  let query = self.component_search_query_normalized()
  if query == "" {
    true
  } else {
    @editor_bridge.builtin_component_kind_to_string(kind)
    .to_lower()
    .contains(query) ||
    @editor_bridge.builtin_component_category(kind).to_lower().contains(query)
  }
}

///|
pub fn Model::component_card_collapsed(
  self : Model,
  entity_id : String,
  kind : String,
) -> Bool {
  self.collapsed_component_cards
  .get(component_state_key(entity_id, kind))
  .unwrap_or(false)
}

///|
pub fn Model::component_menu_is_open(self : Model, kind : String) -> Bool {
  self.open_component_menu_kind == Some(kind)
}

///|
pub fn Model::selected_component_remove_block_reason(
  self : Model,
  kind : String,
) -> String? {
  match self.selected_entity() {
    Some(entity) => remove_component_block_reason_for_entity(entity, kind)
    None => None
  }
}

///|
pub fn Model::custom_component_json_draft(
  self : Model,
  entity_id : String,
  kind : String,
  fallback : Json,
) -> String {
  self.custom_component_json_drafts
  .get(component_state_key(entity_id, kind))
  .unwrap_or(fallback.stringify(indent=2))
}

///|
pub fn Model::custom_component_json_error(
  self : Model,
  entity_id : String,
  kind : String,
) -> String? {
  self.custom_component_json_errors.get(component_state_key(entity_id, kind))
}

///|
fn update_selected_atlas_document(
  model : Model,
  updater : (@editor_bridge.AtlasAssetDocument) -> @editor_bridge.AtlasAssetDocument,
) -> Model {
  match model.selected_atlas_document() {
    Some((path, atlas)) => {
      let atlas_documents = model.atlas_documents
      atlas_documents.set(path, updater(atlas))
      { ..model, atlas_documents, }
    }
    None => model
  }
}

///|
fn update_selected_animation_clip_document(
  model : Model,
  updater : (@editor_bridge.AnimationClipAssetDocument) -> @editor_bridge.AnimationClipAssetDocument,
) -> Model {
  match model.selected_animation_clip_document() {
    Some((path, animation)) => {
      let animation_clip_documents = model.animation_clip_documents
      animation_clip_documents.set(path, updater(animation))
      { ..model, animation_clip_documents, }
    }
    None => model
  }
}

///|
fn update_selected_prefab_document(
  model : Model,
  updater : (@editor_bridge.PrefabDocument) -> @editor_bridge.PrefabDocument,
) -> Model {
  match model.selected_prefab_document() {
    Some((path, prefab)) => {
      let prefab_documents = model.prefab_documents
      prefab_documents.set(path, updater(prefab))
      { ..model, prefab_documents, }
    }
    None => model
  }
}
