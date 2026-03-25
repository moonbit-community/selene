///|
pub struct FakePreviewBridge {
  mut commands : Array[@bridge.PreviewCommand]
  mut current_scene : @editor_bridge.SceneDocument?
  mut selected_entity_id : String?
  mut bootstrapped : Bool
}

///|
fn FakePreviewBridge::new() -> FakePreviewBridge {
  {
    commands: [],
    current_scene: None,
    selected_entity_id: None,
    bootstrapped: false,
  }
}

///|
fn FakePreviewBridge::apply(
  self : FakePreviewBridge,
  command : @bridge.PreviewCommand,
) -> Unit {
  self.commands.push(command)
  match command {
    @bridge.Bootstrap => self.bootstrapped = true
    @bridge.ClearScene => self.current_scene = None
    @bridge.LoadScene(scene) => self.current_scene = Some(scene)
    @bridge.SelectEntity(id) => self.selected_entity_id = id
    @bridge.SetTool(_) => ()
    @bridge.FrameSelection => ()
  }
}

///|
fn FakePreviewBridge::take_commands(
  self : FakePreviewBridge,
) -> Array[@bridge.PreviewCommand] {
  let commands = self.commands
  self.commands = []
  commands
}

///|
pub struct EditorHarness {
  project_root : String
  service : @core.EditorService
  mut model : @app.Model
  mut next_rpc_id : Int
  mut service_events_subscribed : Bool
  mut preview_events_subscribed : Bool
  preview : FakePreviewBridge
}

///|
fn[T : FromJson] decode_rpc_payload(payload : Json) -> Result[T, String] {
  try {
    let success : @shared.RpcSuccess = @json.from_json(payload)
    Ok(@json.from_json(success.result))
  } catch {
    _ =>
      try {
        let failure : @shared.RpcFailure = @json.from_json(payload)
        Err(failure.error.message)
      } catch {
        err => Err(err.to_string())
      }
  }
}

///|
fn msg_for_rpc_target(target : @app.RpcTarget, payload : Json) -> @app.Msg {
  match target {
    @app.ProjectRootPicked =>
      @app.msg_project_root_picked(decode_rpc_payload(payload))
    @app.ProjectLoaded => @app.msg_project_loaded(decode_rpc_payload(payload))
    @app.SceneLoaded => @app.msg_scene_loaded(decode_rpc_payload(payload))
    @app.AssetsLoaded => @app.msg_assets_loaded(decode_rpc_payload(payload))
    @app.SceneSaved => @app.msg_scene_saved(decode_rpc_payload(payload))
  }
}

///|
fn editor_harness(module_root : String, project_root : String) -> EditorHarness {
  {
    project_root,
    service: @core.EditorService::new(module_root),
    model: @app.new_model(),
    next_rpc_id: 1,
    service_events_subscribed: false,
    preview_events_subscribed: false,
    preview: FakePreviewBridge::new(),
  }
}

///|
pub fn given_editor_harness_at(project_root : String) -> EditorHarness {
  editor_harness(@env.current_dir().unwrap_or("."), project_root)
}

///|
pub async fn given_editor_harness() -> EditorHarness {
  @async.with_task_group(group => ignore(group))
  let module_root = @env.current_dir().unwrap_or(".")
  let project_root = @fs.tmpdir(prefix="selene-editor-bdd")
  editor_harness(module_root, project_root)
}

///|
pub async fn EditorHarness::cleanup(self : EditorHarness) -> Unit {
  if @fs.exists(self.project_root) {
    @fs.rmdir(self.project_root, recursive=true)
  }
}

///|
async fn EditorHarness::dispatch(self : EditorHarness, msg : @app.Msg) -> Unit {
  let (effects, next) = @app.update(msg, self.model)
  self.model = next
  self.process_effects(effects)
}

///|
async fn EditorHarness::process_effects(
  self : EditorHarness,
  effects : Array[@app.Effect],
) -> Unit {
  for effect in effects {
    self.process_effect(effect)
  }
  self.flush_service_events()
}

///|
async fn EditorHarness::process_effect(
  self : EditorHarness,
  effect : @app.Effect,
) -> Unit {
  match effect {
    @app.Rpc(target~, method_name~, params~) => {
      let request = @shared.rpc_request(self.next_rpc_id, method_name, params)
      self.next_rpc_id += 1
      let payload = self.service.handle_rpc(request)
      self.dispatch(msg_for_rpc_target(target, payload))
    }
    @app.SubscribeServiceEvents => self.service_events_subscribed = true
    @app.SubscribePreviewEvents => self.preview_events_subscribed = true
    @app.Preview(command) => self.preview.apply(command)
  }
}

///|
async fn EditorHarness::flush_service_events(self : EditorHarness) -> Unit {
  if !self.service_events_subscribed {
    return
  }
  let events = self.service.drain_events()
  for event in events {
    self.dispatch(@app.msg_service_event(Ok(event)))
  }
}

///|
async fn EditorHarness::emit_preview_event(
  self : EditorHarness,
  event : @bridge.PreviewEvent,
) -> Unit {
  if self.preview_events_subscribed {
    self.dispatch(@app.msg_preview_event(event))
  }
}

///|
pub fn EditorHarness::project_root_path(self : EditorHarness) -> String {
  self.project_root
}

///|
pub fn EditorHarness::scene_path(self : EditorHarness) -> String {
  self.model.scene_path
}

///|
pub fn EditorHarness::current_root(self : EditorHarness) -> String? {
  self.model.current_root
}

///|
pub fn EditorHarness::scene(
  self : EditorHarness,
) -> @editor_bridge.SceneDocument? {
  self.model.scene
}

///|
pub fn EditorHarness::selected_entity_id(self : EditorHarness) -> String? {
  self.model.selected_entity_id
}

///|
pub fn EditorHarness::entity(
  self : EditorHarness,
  id : String,
) -> @editor_bridge.EntityDocument? {
  match self.model.scene {
    Some(scene) => scene.entity(id)
    None => None
  }
}

///|
pub fn EditorHarness::preview_bootstrapped(self : EditorHarness) -> Bool {
  self.preview.bootstrapped
}

///|
pub fn EditorHarness::preview_scene(
  self : EditorHarness,
) -> @editor_bridge.SceneDocument? {
  self.preview.current_scene
}

///|
pub fn EditorHarness::preview_selected_entity_id(
  self : EditorHarness,
) -> String? {
  self.preview.selected_entity_id
}

///|
pub fn EditorHarness::take_preview_commands(
  self : EditorHarness,
) -> Array[@bridge.PreviewCommand] {
  self.preview.take_commands()
}

///|
pub async fn EditorHarness::when_editor_initialized(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_initialize())
}

///|
pub async fn EditorHarness::when_project_created(
  self : EditorHarness,
  name : String,
) -> Unit {
  self.dispatch(@app.msg_set_project_root_input(self.project_root))
  self.dispatch(@app.msg_set_project_name_input(name))
  self.dispatch(@app.msg_create_project())
}

///|
pub async fn EditorHarness::when_project_opened(self : EditorHarness) -> Unit {
  self.dispatch(@app.msg_set_project_root_input(self.project_root))
  self.dispatch(@app.msg_open_project())
}

///|
pub async fn EditorHarness::when_scene_tree_selects_entity(
  self : EditorHarness,
  id : String?,
) -> Unit {
  self.dispatch(@app.msg_select_entity(id))
}

///|
pub async fn EditorHarness::when_preview_picks_entity(
  self : EditorHarness,
  id : String?,
) -> Unit {
  self.emit_preview_event(@bridge.preview_event_entity_picked(id))
}

///|
pub async fn EditorHarness::when_selected_translate_x_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_translate_x(value))
}

///|
pub async fn EditorHarness::when_selected_translate_y_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_translate_y(value))
}

///|
pub async fn EditorHarness::when_selected_text_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_text(value))
}

///|
pub async fn EditorHarness::when_selected_visibility_is_toggled(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_toggle_selected_visibility())
}

///|
pub async fn EditorHarness::when_scene_is_saved(self : EditorHarness) -> Unit {
  self.dispatch(@app.msg_save_scene())
}

///|
pub async fn EditorHarness::when_sprite_entity_is_added(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_add_sprite_entity())
}

///|
pub async fn EditorHarness::when_text_entity_is_added(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_add_text_entity())
}

///|
pub async fn EditorHarness::when_selected_entity_is_deleted(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_delete_selected())
}
