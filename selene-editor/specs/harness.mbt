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
    @bridge.LoadScene(payload) => self.current_scene = Some(payload.scene)
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
fn decode_rpc_payload(
  payload : Json,
) -> Result[@shared.RpcResponseEnvelope, String] {
  try {
    Ok(@json.from_json(payload))
  } catch {
    err => Err(err.to_string())
  }
}

///|
fn msg_for_rpc_target(
  target : @app.RpcTarget,
  payload : Json,
) -> @app.Msg {
  let response = match decode_rpc_payload(payload) {
    Ok(envelope) => envelope.response
    Err(message) =>
      return match target {
        @app.ProjectRootPicked =>
          @app.msg_project_root_picked(Err(message))
        @app.ProjectLoaded => @app.msg_project_loaded(Err(message))
        @app.SceneLoaded => @app.msg_scene_loaded(Err(message))
        @app.SceneListLoaded => @app.msg_scene_list_loaded(Err(message))
        @app.AssetsLoaded => @app.msg_assets_loaded(Err(message))
        @app.PrefabLoaded => @app.msg_prefab_loaded(Err(message))
        @app.AtlasLoaded => @app.msg_atlas_loaded(Err(message))
        @app.AnimationLoaded => @app.msg_animation_loaded(Err(message))
        @app.SceneSaved => @app.msg_scene_saved(Err(message))
      }
  }
  match target {
    @app.ProjectRootPicked =>
      @app.msg_project_root_picked(
        match response {
          @shared.DirectoryPicked(result~) => Ok(result)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for project root picker")
        },
      )
    @app.ProjectLoaded =>
      @app.msg_project_loaded(
        match response {
          @shared.ProjectState(state~) => Ok(state)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for project state")
        },
      )
    @app.SceneLoaded =>
      @app.msg_scene_loaded(
        match response {
          @shared.SceneLoaded(scene~) => Ok(scene)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for scene")
        },
      )
    @app.SceneListLoaded =>
      @app.msg_scene_list_loaded(
        match response {
          @shared.SceneListed(list~) => Ok(list)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for scene list")
        },
      )
    @app.AssetsLoaded =>
      @app.msg_assets_loaded(
        match response {
          @shared.AssetsListed(list~) => Ok(list)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for assets")
        },
      )
    @app.PrefabLoaded =>
      @app.msg_prefab_loaded(
        match response {
          @shared.PrefabLoaded(prefab~) => Ok(prefab)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for prefab")
        },
      )
    @app.AtlasLoaded =>
      @app.msg_atlas_loaded(
        match response {
          @shared.AtlasLoaded(atlas~) => Ok(atlas)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for atlas")
        },
      )
    @app.AnimationLoaded =>
      @app.msg_animation_loaded(
        match response {
          @shared.AnimationLoaded(animation~) => Ok(animation)
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for animation")
        },
      )
    @app.SceneSaved =>
      @app.msg_scene_saved(
        match response {
          @shared.SavedOk | @shared.StartupSceneUpdated(_) => Ok(())
          @shared.Error(error~) => Err(error.message)
          _ => Err("Unexpected RPC response for save")
        },
      )
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
  let temp_root = @fs.tmpdir(prefix="selene-editor-bdd")
  let project_root = temp_root + "/project"
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
    @app.Rpc(target~, request~) => {
      let request_id = self.next_rpc_id
      self.next_rpc_id += 1
      let payload = if request.request is @shared.ProjectPickDirectory(_) {
        @shared.rpc_response_envelope(
          request_id,
          @shared.rpc_response_directory_picked(
            @shared.directory_pick_result(Some(self.project_root)),
          ),
        )
        .to_json()
      } else {
        self.service.handle_rpc(
          @shared.rpc_request_envelope(request_id, request.request),
        )
      }
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
    self.dispatch(@app.msg_service_event(Ok(event.event)))
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
pub fn EditorHarness::assets(
  self : EditorHarness,
) -> Array[@editor_bridge.AssetDocument] {
  self.model.assets
}

///|
pub fn EditorHarness::selected_resource_path(self : EditorHarness) -> String? {
  self.model.selected_resource_path()
}

///|
pub fn EditorHarness::atlas_refs(
  self : EditorHarness,
) -> Array[@editor_bridge.AssetRef] {
  self.model.atlas_refs
}

///|
pub fn EditorHarness::animation_refs(
  self : EditorHarness,
) -> Array[@editor_bridge.AssetRef] {
  self.model.animation_refs
}

///|
pub fn EditorHarness::prefab_refs(
  self : EditorHarness,
) -> Array[@editor_bridge.PrefabRef] {
  self.model.prefab_refs
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
  self.dispatch(@app.msg_open_project())
}

///|
pub async fn EditorHarness::when_project_opened(self : EditorHarness) -> Unit {
  self.dispatch(@app.msg_open_project())
}

///|
pub async fn EditorHarness::given_image_asset(
  self : EditorHarness,
  relative_path : String,
) -> Unit {
  let full_path = self.project_root + "/" + relative_path
  let parent = if full_path.rev_find("/") is Some(index) {
    full_path[:index].to_string()
  } else {
    self.project_root
  }
  if !@fs.exists(parent) {
    @fs.mkdir(parent, permission=0o755, recursive=true)
  }
  @fs.write_file(full_path, b"fake-image", create=0o644)
}

///|
pub async fn EditorHarness::when_scene_tree_selects_entity(
  self : EditorHarness,
  id : String?,
) -> Unit {
  self.dispatch(@app.msg_select_entity(id))
}

///|
pub async fn EditorHarness::when_image_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(@app.msg_select_resource(Some(@app.resource_selection_image(path))))
}

///|
pub async fn EditorHarness::when_atlas_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(@app.msg_select_resource(Some(@app.resource_selection_atlas(path))))
}

///|
pub async fn EditorHarness::when_animation_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(
    @app.msg_select_resource(Some(@app.resource_selection_animation(path))),
  )
}

///|
pub async fn EditorHarness::when_prefab_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(@app.msg_select_resource(Some(@app.resource_selection_prefab(path))))
}

///|
pub async fn EditorHarness::when_selected_image_creates_atlas(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_create_atlas_from_selected_image())
}

///|
pub async fn EditorHarness::when_selected_atlas_creates_animation(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_create_animation_from_selected_atlas())
}

///|
pub async fn EditorHarness::when_selected_atlas_columns_are_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_atlas_columns(value))
}

///|
pub async fn EditorHarness::when_selected_atlas_is_saved(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_save_selected_atlas())
}

///|
pub async fn EditorHarness::when_selected_animation_frames_are_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_animation_clip_frames(value))
}

///|
pub async fn EditorHarness::when_selected_animation_is_saved(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_save_selected_animation())
}

///|
pub async fn EditorHarness::when_selected_entity_is_saved_as_prefab(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_save_selected_as_prefab())
}

///|
pub async fn EditorHarness::when_current_scene_is_renamed(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_rename_current_scene(value))
}

///|
pub async fn EditorHarness::when_selected_prefab_name_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_prefab_name(value))
}

///|
pub async fn EditorHarness::when_selected_prefab_is_saved(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_save_selected_prefab())
}

///|
pub async fn EditorHarness::when_selected_resource_is_inserted(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_insert_selected_resource())
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
pub async fn EditorHarness::when_sprite_asset_is_added(
  self : EditorHarness,
  asset_path : String,
) -> Unit {
  self.dispatch(@app.msg_add_sprite_from_asset(asset_path))
}

///|
pub async fn EditorHarness::when_sprite_asset_is_dropped(
  self : EditorHarness,
  asset_path : String,
  x : Double,
  y : Double,
) -> Unit {
  self.dispatch(
    @app.msg_add_sprite_from_asset_at(
      asset_path,
      @editor_bridge.vec2_doc(x, y),
    ),
  )
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
