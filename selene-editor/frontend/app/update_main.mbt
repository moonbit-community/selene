///|
pub fn update(msg : Msg, model : Model) -> (Array[Effect], Model) {
  let model = if is_scene_edit_continuation(msg) {
    model
  } else {
    with_committed_scene_edit_transaction(model)
  }
  match to_domain_msg(msg) {
    ProjectRuntime(domain_msg) => update_project_runtime(domain_msg, model)
    SelectionHistoryTools(domain_msg) =>
      update_selection_history_tools(domain_msg, model)
    SceneLifecycle(domain_msg) => update_scene_lifecycle(domain_msg, model)
    AssetsResources(domain_msg) => update_assets_resources(domain_msg, model)
    InspectorComponents(domain_msg) =>
      update_inspector_components(domain_msg, model)
    AnimationEditor(domain_msg) => update_animation_editor(domain_msg, model)
  }
}
