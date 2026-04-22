///|
fn push_log(model : Model, line : String) -> Model {
  let next_logs = model.logs + [line]
  let logs = if next_logs.length() > 200 {
    next_logs[next_logs.length() - 200:].to_array()
  } else {
    next_logs
  }
  { ..model, logs, }
}

///|
let scene_history_limit = 200

///|
fn empty_scene_session(path : String) -> SceneSession {
  {
    path,
    scene: @editor_bridge.SceneDocument::empty(),
    dirty: false,
    base_hash: "",
    base_revision: 0,
    last_saved_at: 0,
    conflict_state: SceneConflictState::NoConflict,
    undo_stack: [],
    redo_stack: [],
    active_scene_edit_transaction: None,
  }
}

///|
fn model_scene_path(model : Model) -> String {
  match model.scene_session {
    Some(session) => session.path
    None => fallback_scene_path(model)
  }
}

///|
fn model_scene(model : Model) -> @editor_bridge.SceneDocument? {
  model.scene_session.map(fn(session) { session.scene })
}

///|
fn with_scene_session(model : Model, session : SceneSession?) -> Model {
  { ..model, scene_session: session }
}

///|
fn with_loaded_scene_session(
  model : Model,
  path : String,
  scene : @editor_bridge.SceneDocument,
  disk_hash : String,
  disk_revision : Int,
) -> Model {
  with_scene_session(
    model,
    Some({
      ..empty_scene_session(path),
      path,
      scene,
      base_hash: disk_hash,
      base_revision: disk_revision,
      last_saved_at: disk_revision,
    }),
  )
}

///|
let move_snap_step_options : ReadOnlyArray[Double] = [
  1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0,
]

///|
fn nearest_move_snap_step(step : Double) -> Double {
  let fallback = 16.0
  let candidate = if step > 0.0 { step } else { fallback }
  let mut best = move_snap_step_options[0]
  let mut best_distance = (candidate - best).abs()
  for option in move_snap_step_options {
    let distance = (candidate - option).abs()
    if distance < best_distance {
      best = option
      best_distance = distance
    }
  }
  best
}

///|
fn move_snap_step_index(step : Double) -> Int {
  let normalized = nearest_move_snap_step(step)
  for index = 0; index < move_snap_step_options.length(); index = index + 1 {
    if move_snap_step_options[index] == normalized {
      return index
    }
  }
  4
}

///|
fn adjusted_move_snap_step(current : Double, delta : Int) -> Double {
  let index = move_snap_step_index(current)
  let target = index + delta
  if target < 0 {
    move_snap_step_options[0]
  } else if target >= move_snap_step_options.length() {
    move_snap_step_options[move_snap_step_options.length() - 1]
  } else {
    move_snap_step_options[target]
  }
}

///|
fn bounded_history(
  history : Array[@editor_bridge.SceneDocument],
) -> Array[@editor_bridge.SceneDocument] {
  if history.length() > scene_history_limit {
    history[history.length() - scene_history_limit:].to_array()
  } else {
    history
  }
}

///|
fn with_recorded_scene_change(previous : Model, next : Model) -> Model {
  match (previous.scene_session, next.scene_session) {
    (Some(before), Some(after)) if before != after => {
      let undo_stack = bounded_history(before.undo_stack + [before.scene])
      with_scene_session(
        next,
        Some({
          ..after,
          dirty: true,
          conflict_state: SceneConflictState::NoConflict,
          undo_stack,
          redo_stack: [],
          active_scene_edit_transaction: None,
        }),
      )
    }
    (Some(_), None) => next
    _ => next
  }
}

///|
fn with_started_scene_edit_transaction(model : Model, label : String) -> Model {
  match model.scene_session {
    Some(session) if session.active_scene_edit_transaction is None => {
      let transaction : SceneEditTransaction = { label, before: session.scene }
      with_scene_session(
        model,
        Some({ ..session, active_scene_edit_transaction: Some(transaction) }),
      )
    }
    _ => model
  }
}

///|
fn with_committed_scene_edit_transaction(model : Model) -> Model {
  match model.scene_session {
    Some(session) =>
      match session.active_scene_edit_transaction {
        Some(transaction) if transaction.before != session.scene => {
          let undo_stack = bounded_history(
            session.undo_stack + [transaction.before],
          )
          with_scene_session(
            model,
            Some({
              ..session,
              dirty: true,
              conflict_state: SceneConflictState::NoConflict,
              undo_stack,
              redo_stack: [],
              active_scene_edit_transaction: None,
            }),
          )
        }
        Some(_) =>
          with_scene_session(
            model,
            Some({ ..session, active_scene_edit_transaction: None }),
          )
        None => model
      }
    None => model
  }
}

///|
fn with_scene_document_updated(
  model : Model,
  updater : (@editor_bridge.SceneDocument) -> @editor_bridge.SceneDocument,
) -> Model {
  match model.scene_session {
    Some(session) => {
      let next_scene = updater(session.scene)
      with_scene_session(model, Some({ ..session, scene: next_scene }))
    }
    _ => model
  }
}

///|
fn is_scene_edit_continuation(msg : Msg) -> Bool {
  match msg {
    RenameSelected(_)
    | UpdateSelectedTranslateX(_)
    | UpdateSelectedTranslateY(_)
    | UpdateSelectedRotation(_)
    | UpdateSelectedText(_)
    | CommitSceneEditTransaction
    | PreviewEvent(@bridge.TransformGestureStarted(..))
    | PreviewEvent(@bridge.TransformChanged(..))
    | PreviewEvent(@bridge.TransformGestureFinished(..)) => true
    _ => false
  }
}

///|
fn project_open_failed_message() -> String {
  "Project open failed. Check browser console for details."
}

///|
fn scene_load_failed_message() -> String {
  "Scene load failed. Check browser console for details."
}

///|
fn folder_picker_failed_message() -> String {
  "Folder picker failed. Check browser console for details."
}

///|
fn rpc_effect(binding : RpcBinding) -> Effect {
  Rpc(binding~)
}

///|
fn save_workspace_effects(model : Model) -> Array[Effect] {
  match model.current_root {
    Some(_) => [rpc_effect(RpcProjectSaveWorkspace(model.workspace))]
    None => []
  }
}

///|
fn sync_preview_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = [
    Preview(@bridge.preview_command_set_tool(model.active_tool)),
    Preview(
      @bridge.preview_command_set_move_snap(
        model.move_snap_enabled,
        model.move_snap_step,
      ),
    ),
    Preview(
      @bridge.preview_command_set_autotile_brush_terrain(
        model.autotile_brush_terrain,
      ),
    ),
    Preview(
      @bridge.preview_command_set_selection(
        model.selected_entity_id,
        selected_entity_ids_for_edit(model),
      ),
    ),
  ]
  effects
}

///|
fn scene_preview_effect(model : Model) -> Effect {
  match model.scene_session {
    Some(session) => {
      let atlases : Array[@bridge.AtlasAssetEntry] = []
      let animation_clips : Array[@bridge.AnimationClipAssetEntry] = []
      let animation_graphs : Array[@bridge.AnimationGraphAssetEntry] = []
      for path, atlas in model.atlas_documents {
        atlases.push(@bridge.atlas_asset_entry(path, atlas))
      }
      for path, clip in model.animation_clip_documents {
        animation_clips.push(@bridge.animation_clip_asset_entry(path, clip))
      }
      for path, graph in model.animation_graph_documents {
        animation_graphs.push(@bridge.animation_graph_asset_entry(path, graph))
      }
      Preview(
        @bridge.preview_command_load_scene(
          @bridge.preview_scene_payload(
            Some(session.path),
            session.scene,
            atlases,
            animation_clips,
            animation_graphs,
          ),
        ),
      )
    }
    None => Preview(@bridge.preview_command_clear_scene())
  }
}

///|
fn sync_preview_effects_with_scene(model : Model) -> Array[Effect] {
  let effects = sync_preview_effects(model)
  effects.push(scene_preview_effect(model))
  effects
}

///|
fn load_supporting_resource_effects(model : Model) -> Array[Effect] {
  let effects : Array[Effect] = []
  for prefab_ref in model.prefab_refs {
    effects.push(rpc_effect(RpcPrefabLoad(prefab_ref.path)))
  }
  for atlas_ref in model.atlas_refs {
    effects.push(rpc_effect(RpcAtlasLoad(atlas_ref.path)))
  }
  for animation_ref in model.animation_clip_refs {
    effects.push(rpc_effect(RpcAnimationClipLoad(animation_ref.path)))
  }
  for animation_ref in model.animation_graph_refs {
    effects.push(rpc_effect(RpcAnimationGraphLoad(animation_ref.path)))
  }
  effects
}

///|
fn refresh_project_effects(model : Model) -> Array[Effect] {
  match model.manifest {
    Some(_) => {
      let effects : Array[Effect] = [
        Preview(@bridge.preview_command_bootstrap()),
        rpc_effect(RpcSceneLoad(model_scene_path(model))),
        rpc_effect(RpcSceneList),
        rpc_effect(RpcAssetsList),
      ]
      effects.push_iter(load_supporting_resource_effects(model).iter())
      effects
    }
    None => []
  }
}

///|
fn normalize_scene_after_change(model : Model) -> (Array[Effect], Model) {
  (sync_preview_effects_with_scene(model), model)
}

///|
fn normalize_scene_after_change_without_preview(
  model : Model,
) -> (Array[Effect], Model) {
  ([], model)
}

///|
fn apply_scene_change(previous : Model, next : Model) -> (Array[Effect], Model) {
  normalize_scene_after_change(with_recorded_scene_change(previous, next))
}

///|
fn apply_scene_change_without_history(
  _previous : Model,
  next : Model,
) -> (Array[Effect], Model) {
  normalize_scene_after_change(next)
}

///|
fn apply_scene_change_without_history_or_preview(
  _previous : Model,
  next : Model,
) -> (Array[Effect], Model) {
  normalize_scene_after_change_without_preview(next)
}

///|
fn fallback_scene_path(model : Model) -> String {
  match model.manifest {
    Some(manifest) => manifest.startup_scene
    None => @editor_bridge.startup_scene_path_for_name("main")
  }
}

///|
fn preferred_scene_path(
  manifest : @editor_bridge.ProjectManifest?,
  scene_refs : Array[@editor_bridge.SceneRef],
  workspace : @editor_bridge.WorkspaceDocument,
  current : String,
) -> String {
  if workspace.last_scene is Some(path) && scene_path_exists(scene_refs, path) {
    return path
  }
  if scene_path_exists(scene_refs, current) {
    return current
  }
  match manifest {
    Some(value) if scene_path_exists(scene_refs, value.startup_scene) =>
      value.startup_scene
    Some(value) => value.startup_scene
    None => if scene_refs.is_empty() { current } else { scene_refs[0].path }
  }
}

///|
fn save_success_status(model : Model) -> String {
  match model.status {
    "Saving prefab..." => "Prefab saved"
    "Saving atlas..." => "Atlas saved"
    "Saving animation clip..." => "Animation clip saved"
    "Saving animation graph..." => "Animation graph saved"
    _ => "Scene saved"
  }
}

///|
fn move_snap_status(enabled : Bool, step : Double) -> String {
  if enabled {
    "Move snap: ON (\{step.to_int()}px)"
  } else {
    "Move snap: OFF (\{step.to_int()}px, hold Shift to snap)"
  }
}
