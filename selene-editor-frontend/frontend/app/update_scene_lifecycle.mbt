///|
fn update_scene_lifecycle(
  msg : SceneLifecycleMsg,
  model : Model,
) -> (Array[Effect], Model) {
  match msg {
    OpenScene(path) =>
      (
        [rpc_effect(SceneLoaded, @shared.rpc_request_scene_load(path))],
        {
          ..model,
          add_component_panel_open: false,
          component_search_query: "",
          open_component_menu_kind: None,
          status: "Loading " + path + "...",
        },
      )
    CreateScene(name) => {
      let trimmed = name.trim().to_string()
      if trimmed == "" {
        let next = push_log(model, "Scene name is required")
        ([], { ..next, status: "Scene name is required" })
      } else {
        (
          [
            rpc_effect(SceneLoaded, @shared.rpc_request_scene_create(trimmed)),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
          ],
          { ..model, status: "Creating scene..." },
        )
      }
    }
    DeleteCurrentScene =>
      if model.scene_refs.length() <= 1 {
        let next = push_log(model, "Cannot delete the last scene")
        ([], { ..next, status: "Cannot delete the last scene" })
      } else {
        let fallback = fallback_scene_path(model)
        let current_scene_path = model_scene_path(model)
        let next_scene_path = if current_scene_path == fallback &&
          model.scene_refs.length() > 1 {
          model.scene_refs[1].path
        } else {
          fallback
        }
        (
          [
            rpc_effect(
              SceneSaved,
              @shared.rpc_request_scene_delete(current_scene_path),
            ),
            rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
            rpc_effect(
              SceneLoaded,
              @shared.rpc_request_scene_load(next_scene_path),
            ),
          ],
          { ..model, status: "Deleting scene..." },
        )
      }
    SetCurrentSceneAsStartup =>
      (
        [
          rpc_effect(
            SceneSaved,
            @shared.rpc_request_project_set_startup_scene(
              model_scene_path(model),
            ),
          ),
          rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
        ],
        { ..model, status: "Updating startup scene..." },
      )
    RenameCurrentScene(value) =>
      match model_scene(model) {
        Some(scene) => {
          let trimmed = value.trim().to_string()
          if trimmed == "" {
            let next = push_log(model, "Scene name is required")
            ([], { ..next, status: "Scene name is required" })
          } else {
            let next_scene = scene.with_name(trimmed)
            let next = with_scene_document_updated(
              { ..model, status: "Renaming scene..." },
              fn(_current_scene) { next_scene },
            )
            let with_history = with_recorded_scene_change(model, next)
            let (base_hash, base_revision) = match model.scene_session {
              Some(session) => (session.base_hash, session.base_revision)
              None => ("", 0)
            }
            (
              [
                rpc_effect(
                  SceneSaved,
                  @shared.rpc_request_scene_save(
                    model_scene_path(model),
                    next_scene,
                    base_hash,
                    base_revision,
                  ),
                ),
              ] +
              sync_preview_effects_with_scene(with_history),
              with_history,
            )
          }
        }
        None => ([], model)
      }
    SaveScene =>
      match model.scene_session {
        Some(session) =>
          (
            [
              rpc_effect(
                SceneSaved,
                @shared.rpc_request_scene_save(
                  session.path,
                  session.scene,
                  session.base_hash,
                  session.base_revision,
                ),
              ),
            ],
            { ..model, status: "Saving scene..." },
          )
        None => ([], model)
      }
    AddSpriteEntity =>
      match model_scene(model) {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Sprite", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.sprite_component(
              custom_size=Some(@editor_bridge.vec2_doc(64.0, 64.0)),
            ),
          ])
          let next = with_single_entity_selection(
            with_scene_document_updated(model, fn(_current_scene) {
              scene.with_entity(entity)
            }),
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddSpriteFromAssetAt(path, translation) =>
      match model_scene(model) {
        Some(scene) => {
          let (next_scene, id) = add_sprite_asset_to_scene(
            model.asset_size(path),
            scene,
            path,
            translation,
          )
          let next = with_single_entity_selection(
            with_scene_document_updated(model, fn(_current_scene) { next_scene }),
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    AddTextEntity =>
      match model_scene(model) {
        Some(scene) => {
          let id = next_entity_id(scene)
          let entity = @editor_bridge.entity_document(id, "Text", components=[
            @editor_bridge.transform2d_component(),
            @editor_bridge.visibility_component(),
            @editor_bridge.text2d_component("Text"),
          ])
          let next = with_single_entity_selection(
            with_scene_document_updated(model, fn(_current_scene) {
              scene.with_entity(entity)
            }),
            Some(id),
          )
          apply_scene_change(model, next)
        }
        None => ([], model)
      }
    DeleteSelected =>
      match model_scene(model) {
        Some(scene) => {
          let selected_ids = selected_entity_ids_for_edit(model)
          if selected_ids.is_empty() {
            ([], model)
          } else {
            let mut next_scene = scene
            for id in selected_ids {
              next_scene = next_scene.without_entity(id)
            }
            let next = {
              ..with_entity_selection(model, None, []),
              scene_session: model.scene_session.map(fn(session) {
                { ..session, scene: next_scene }
              }),
              add_component_panel_open: false,
              component_search_query: "",
              open_component_menu_kind: None,
            }
            apply_scene_change(model, next)
          }
        }
        None => ([], model)
      }
  }
}
