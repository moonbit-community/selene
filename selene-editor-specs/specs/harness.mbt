///|
pub struct FakePreviewBridge {
  mut commands : Array[@bridge.PreviewCommand]
  mut current_scene : @editor_bridge.SceneDocument?
  mut selected_entity_id : String?
  mut selected_entity_ids : Array[String]
  mut bootstrapped : Bool
}

///|
fn FakePreviewBridge::FakePreviewBridge() -> FakePreviewBridge {
  {
    commands: [],
    current_scene: None,
    selected_entity_id: None,
    selected_entity_ids: [],
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
    @bridge.SetSelection(primary~, ids~) => {
      self.selected_entity_id = primary
      self.selected_entity_ids = ids
    }
    @bridge.SetTool(_) => ()
    @bridge.SetMoveSnap(..) => ()
    @bridge.SetAutoTileBrushTerrain(_) => ()
    @bridge.SetAnimationPreviewPaused(_) => ()
    @bridge.SetAnimationPreviewSpeed(_) => ()
    @bridge.SeekAnimationPreview(_) => ()
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
  mut sidebar_layout_subscribed : Bool
  preview : FakePreviewBridge
}

///|
fn decode_rpc_payload(
  payload : Json,
) -> Result[@shared.RpcResponseEnvelope, String] {
  Ok(@json.from_json(payload)) catch {
    err => Err(err.to_string())
  }
}

///|
fn msg_for_rpc_binding(binding : @app.RpcBinding, payload : Json) -> @app.Msg {
  match decode_rpc_payload(payload) {
    Ok(envelope) =>
      match binding.response_to_msg(envelope.response) {
        Ok(msg) => msg
        Err(message) => binding.transport_error_msg(message)
      }
    Err(message) => binding.transport_error_msg(message)
  }
}

///|
fn editor_harness(module_root : String, project_root : String) -> EditorHarness {
  {
    project_root,
    service: @core.EditorService(module_root),
    model: @app.new_model(),
    next_rpc_id: 1,
    service_events_subscribed: false,
    preview_events_subscribed: false,
    sidebar_layout_subscribed: false,
    preview: FakePreviewBridge(),
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
    @app.Rpc(binding~) => {
      let request_id = self.next_rpc_id
      self.next_rpc_id += 1
      let payload = if binding is @app.RpcProjectPickDirectory(_) {
        @shared.rpc_response_envelope(
          request_id,
          @shared.rpc_response_directory_picked(
            @shared.directory_pick_result(Some(self.project_root)),
          ),
        ).to_json()
      } else {
        self.service.handle_rpc(binding.request_envelope(id=request_id))
      }
      self.dispatch(msg_for_rpc_binding(binding, payload))
    }
    @app.SubscribeServiceEvents => self.service_events_subscribed = true
    @app.SubscribePreviewEvents => self.preview_events_subscribed = true
    @app.SubscribeKeyboardShortcuts => ()
    @app.SubscribeSidebarLayout => self.sidebar_layout_subscribed = true
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
  match self.model.scene_session {
    Some(session) => session.path
    None => "scenes/main.scene.json"
  }
}

///|
pub fn EditorHarness::current_root(self : EditorHarness) -> String? {
  self.model.current_root
}

///|
pub fn EditorHarness::manifest(
  self : EditorHarness,
) -> @editor_bridge.ProjectManifest? {
  self.model.manifest
}

///|
pub fn EditorHarness::scene(
  self : EditorHarness,
) -> @editor_bridge.SceneDocument? {
  self.model.scene_session.map(fn(session) { session.scene })
}

///|
pub fn EditorHarness::pending_scene_migration(
  self : EditorHarness,
) -> @editor_bridge.SceneMigrationPreview? {
  self.model.pending_scene_migration
}

///|
pub fn EditorHarness::assets(
  self : EditorHarness,
) -> Array[@editor_bridge.AssetDocument] {
  self.model.assets
}

///|
pub fn EditorHarness::scene_refs(
  self : EditorHarness,
) -> Array[@editor_bridge.SceneRef] {
  self.model.scene_refs
}

///|
pub fn EditorHarness::status(self : EditorHarness) -> String {
  self.model.status
}

///|
pub fn EditorHarness::logs(self : EditorHarness) -> Array[String] {
  self.model.logs
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
  self.model.animation_graph_refs
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
pub fn EditorHarness::selected_entity_ids(
  self : EditorHarness,
) -> Array[String] {
  self.model.selected_entity_ids
}

///|
pub fn EditorHarness::entity(
  self : EditorHarness,
  id : String,
) -> @editor_bridge.EntityDocument? {
  match self.model.scene_session {
    Some(session) => session.scene.entity(id)
    None => None
  }
}

///|
pub fn EditorHarness::scene_dirty(self : EditorHarness) -> Bool {
  match self.model.scene_session {
    Some(session) => session.dirty
    None => false
  }
}

///|
pub fn EditorHarness::scene_conflict_state(
  self : EditorHarness,
) -> @app.SceneConflictState? {
  match self.model.scene_session {
    Some(session) => Some(session.conflict_state)
    None => None
  }
}

///|
pub fn EditorHarness::scene_base_hash(self : EditorHarness) -> String? {
  match self.model.scene_session {
    Some(session) => Some(session.base_hash)
    None => None
  }
}

///|
pub fn EditorHarness::scene_base_revision(self : EditorHarness) -> Int? {
  match self.model.scene_session {
    Some(session) => Some(session.base_revision)
    None => None
  }
}

///|
pub fn EditorHarness::scene_path_or_none(self : EditorHarness) -> String? {
  match self.model.scene_session {
    Some(session) => Some(session.path)
    None => None
  }
}

///|
pub fn EditorHarness::scene_exists(self : EditorHarness) -> Bool {
  match self.model.scene_session {
    Some(_) => true
    None => false
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
pub fn EditorHarness::preview_selected_entity_ids(
  self : EditorHarness,
) -> Array[String] {
  self.preview.selected_entity_ids
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
pub async fn EditorHarness::when_project_folder_pick_is_cancelled(
  self : EditorHarness,
) -> Unit {
  self.dispatch(
    @app.msg_project_root_picked(Ok(@shared.directory_pick_result(None))),
  )
}

///|
pub async fn EditorHarness::when_pending_scene_migration_is_confirmed(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_confirm_scene_migration())
}

///|
pub async fn EditorHarness::when_pending_scene_migration_is_cancelled(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_cancel_scene_migration())
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
pub async fn EditorHarness::given_text_file(
  self : EditorHarness,
  relative_path : String,
  content : String,
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
  @fs.write_file(full_path, content |> @utf8.encode, create=0o644)
}

///|
async fn ensure_dir(path : String) -> Unit {
  if !@fs.exists(path) {
    @fs.mkdir(path, permission=0o755, recursive=true)
  }
}

///|
async fn ensure_parent_dir(path : String) -> Unit {
  if path.rev_find("/") is Some(index) {
    let parent = path[:index].to_string()
    if parent != "" {
      ensure_dir(parent)
    }
  }
}

///|
async fn ensure_project_layout(root : String) -> Unit {
  ensure_dir(root)
  ensure_dir(root + "/scenes")
  ensure_dir(root + "/prefabs")
  ensure_dir(root + "/assets")
  ensure_dir(root + "/assets/images")
  ensure_dir(root + "/assets/audio")
  ensure_dir(root + "/assets/fonts")
  ensure_dir(root + "/assets/atlases")
  ensure_dir(root + "/assets/animation_clips")
  ensure_dir(root + "/assets/animation_graphs")
  ensure_dir(root + "/.selene-editor")
  ensure_dir(root + "/.selene-editor/cache")
}

///|
async fn write_text_file(path : String, content : String) -> Unit {
  ensure_parent_dir(path)
  @fs.write_file(path, @utf8.encode(content), create=0o644)
}

///|
async fn parse_json_file(path : String) -> Json {
  @json.parse(@fs.read_file(path).text())
}

///|
pub async fn EditorHarness::read_scene_document(
  self : EditorHarness,
  relative_path : String,
) -> @editor_bridge.SceneDocument {
  let json = parse_json_file(self.project_root + "/" + relative_path)
  @editor_bridge.decode_scene_sdf(json)
}

///|
pub async fn EditorHarness::read_scene_document_status(
  self : EditorHarness,
  relative_path : String,
) -> @editor_bridge.SceneDocumentLoadStatus {
  let json = parse_json_file(self.project_root + "/" + relative_path)
  @editor_bridge.decode_scene_sdf_status(relative_path, json)
}

///|
pub async fn EditorHarness::read_prefab_document(
  self : EditorHarness,
  relative_path : String,
) -> @editor_bridge.PrefabDocument {
  let json = parse_json_file(self.project_root + "/" + relative_path)
  @editor_bridge.decode_prefab_document(json)
}

///|
pub async fn EditorHarness::read_atlas_document(
  self : EditorHarness,
  relative_path : String,
) -> @editor_bridge.AtlasAssetDocument {
  let json = parse_json_file(self.project_root + "/" + relative_path)
  @editor_bridge.decode_atlas_asset_document(json)
}

///|
pub async fn EditorHarness::read_animation_document(
  self : EditorHarness,
  relative_path : String,
) -> @editor_bridge.AnimationClipAssetDocument {
  let json = parse_json_file(self.project_root + "/" + relative_path)
  @editor_bridge.decode_animation_clip_asset_document(json)
}

///|
pub async fn EditorHarness::given_project_manifest(
  self : EditorHarness,
  manifest : @editor_bridge.ProjectManifest,
) -> Unit {
  ensure_project_layout(self.project_root)
  let encoded = @editor_bridge.encode_project_manifest(manifest)
  write_text_file(self.project_root + "/selene.project.json", encoded)
}

///|
pub async fn EditorHarness::given_scene_document(
  self : EditorHarness,
  relative_path : String,
  scene : @editor_bridge.SceneDocument,
) -> Unit {
  ensure_project_layout(self.project_root)
  let encoded = @editor_bridge.encode_scene_sdf(scene)
  write_text_file(self.project_root + "/" + relative_path, encoded)
}

///|
pub async fn EditorHarness::given_prefab_document(
  self : EditorHarness,
  relative_path : String,
  prefab : @editor_bridge.PrefabDocument,
) -> Unit {
  ensure_project_layout(self.project_root)
  let encoded = @editor_bridge.encode_prefab_document(prefab)
  write_text_file(self.project_root + "/" + relative_path, encoded)
}

///|
pub async fn EditorHarness::given_atlas_document(
  self : EditorHarness,
  relative_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Unit {
  ensure_project_layout(self.project_root)
  let encoded = @editor_bridge.encode_atlas_asset_document(atlas)
  write_text_file(self.project_root + "/" + relative_path, encoded)
}

///|
pub async fn EditorHarness::given_animation_document(
  self : EditorHarness,
  relative_path : String,
  animation : @editor_bridge.AnimationClipAssetDocument,
) -> Unit {
  ensure_project_layout(self.project_root)
  let encoded = @editor_bridge.encode_animation_clip_asset_document(animation)
  write_text_file(self.project_root + "/" + relative_path, encoded)
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
  self.dispatch(
    @app.msg_select_resource(Some(@app.resource_selection_image(path))),
  )
}

///|
pub async fn EditorHarness::when_atlas_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(
    @app.msg_select_resource(Some(@app.resource_selection_atlas(path))),
  )
}

///|
pub async fn EditorHarness::when_animation_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(
    @app.msg_select_resource(Some(@app.resource_selection_animation_clip(path))),
  )
}

///|
pub async fn EditorHarness::when_prefab_resource_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(
    @app.msg_select_resource(Some(@app.resource_selection_prefab(path))),
  )
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
pub async fn EditorHarness::when_selected_animation_clip_creates_graph(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_create_animation_graph_from_selected_clip())
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
  match self.model.selected_resource {
    Some(@app.AnimationClip(_)) => ()
    _ =>
      if self.model.animation_clip_refs.length() > 0 {
        self.dispatch(
          @app.msg_select_resource(
            Some(
              @app.resource_selection_animation_clip(
                self.model.animation_clip_refs[0].path,
              ),
            ),
          ),
        )
      }
  }
  self.dispatch(@app.msg_update_selected_animation_clip_frames(value))
}

///|
pub async fn EditorHarness::when_selected_animation_is_saved(
  self : EditorHarness,
) -> Unit {
  match self.model.selected_resource {
    Some(@app.AnimationClip(_)) => ()
    _ =>
      if self.model.animation_clip_refs.length() > 0 {
        self.dispatch(
          @app.msg_select_resource(
            Some(
              @app.resource_selection_animation_clip(
                self.model.animation_clip_refs[0].path,
              ),
            ),
          ),
        )
      }
  }
  self.dispatch(@app.msg_save_selected_animation_clip())
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
pub async fn EditorHarness::when_scene_is_created(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_create_scene(value))
}

///|
pub async fn EditorHarness::when_current_scene_is_deleted(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_delete_current_scene())
}

///|
pub async fn EditorHarness::when_current_scene_is_marked_as_startup(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_set_current_scene_as_startup())
}

///|
pub async fn EditorHarness::when_scene_is_opened(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(@app.msg_open_scene(path))
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
  let ids = match id {
    Some(value) => [value]
    None => []
  }
  self.emit_preview_event(@bridge.preview_event_selection_changed(id, ids))
}

///|
pub async fn EditorHarness::when_preview_selects_entities(
  self : EditorHarness,
  ids : Array[String],
) -> Unit {
  let primary = if ids.is_empty() { None } else { Some(ids[0]) }
  self.emit_preview_event(@bridge.preview_event_selection_changed(primary, ids))
}

///|
pub async fn EditorHarness::when_service_event_fails(
  self : EditorHarness,
  message : String,
) -> Unit {
  self.dispatch(@app.msg_service_event(Err(message)))
}

///|
pub async fn EditorHarness::when_workspace_delta_is_received(
  self : EditorHarness,
) -> Unit {
  self.dispatch(
    @app.msg_service_event(
      Ok(
        @shared.editor_event_project_delta(
          @shared.project_delta_workspace_changed(),
        ),
      ),
    ),
  )
}

///|
pub async fn EditorHarness::when_scene_file_delta_is_received(
  self : EditorHarness,
  path : String,
  disk_hash : String,
  disk_revision : Int,
) -> Unit {
  self.dispatch(
    @app.msg_service_event(
      Ok(
        @shared.editor_event_project_delta(
          @shared.project_delta_scene_file_changed(
            path, disk_hash, disk_revision,
          ),
        ),
      ),
    ),
  )
}

///|
pub async fn EditorHarness::when_conflict_keep_mine_is_selected(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_resolve_scene_conflict_keep_mine())
}

///|
pub async fn EditorHarness::when_conflict_reload_disk_is_selected(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_resolve_scene_conflict_reload_disk())
}

///|
pub async fn EditorHarness::when_conflict_save_as_is_selected(
  self : EditorHarness,
  path : String,
) -> Unit {
  self.dispatch(@app.msg_resolve_scene_conflict_save_as(path))
}

///|
pub async fn EditorHarness::when_prefab_load_fails(
  self : EditorHarness,
  message : String,
) -> Unit {
  self.dispatch(@app.msg_prefab_loaded(Err(message)))
}

///|
pub async fn EditorHarness::when_atlas_load_fails(
  self : EditorHarness,
  message : String,
) -> Unit {
  self.dispatch(@app.msg_atlas_loaded(Err(message)))
}

///|
pub async fn EditorHarness::when_animation_load_fails(
  self : EditorHarness,
  message : String,
) -> Unit {
  self.dispatch(@app.msg_animation_clip_loaded(Err(message)))
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
  self.dispatch(
    @app.msg_add_sprite_from_asset_at(
      asset_path,
      @editor_bridge.vec2_doc(0.0, 0.0),
    ),
  )
}

///|
pub async fn EditorHarness::when_sprite_asset_is_dropped(
  self : EditorHarness,
  asset_path : String,
  x : Double,
  y : Double,
) -> Unit {
  self.dispatch(
    @app.msg_add_sprite_from_asset_at(asset_path, @editor_bridge.vec2_doc(x, y)),
  )
}

///|
pub async fn EditorHarness::when_scene_is_saved(self : EditorHarness) -> Unit {
  self.dispatch(@app.msg_save_scene())
}

///|
pub async fn EditorHarness::when_move_snap_is_toggled(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_toggle_move_snap())
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

///|
pub async fn EditorHarness::when_add_component_panel_is_opened(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_open_add_component_panel())
}

///|
pub async fn EditorHarness::when_builtin_component_is_added(
  self : EditorHarness,
  kind : @editor_bridge.BuiltinComponentKind,
) -> Unit {
  self.dispatch(@app.msg_add_builtin_component(kind))
}

///|
pub async fn EditorHarness::when_component_is_removed(
  self : EditorHarness,
  kind : String,
) -> Unit {
  self.dispatch(@app.msg_remove_component(kind))
}

///|
pub async fn EditorHarness::when_custom_component_is_added(
  self : EditorHarness,
  kind : String,
) -> Unit {
  self.dispatch(@app.msg_add_custom_component(kind))
}

///|
pub async fn EditorHarness::when_custom_component_json_is_edited(
  self : EditorHarness,
  kind : String,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_custom_component_json(kind, value))
}

///|
pub async fn EditorHarness::when_custom_component_json_is_committed(
  self : EditorHarness,
  kind : String,
) -> Unit {
  self.dispatch(@app.msg_commit_custom_component_json(kind))
}

///|
pub fn EditorHarness::entity_has_component(
  self : EditorHarness,
  entity_id : String,
  kind : String,
) -> Bool {
  match self.entity(entity_id) {
    Some(entity) => entity.component(kind) is Some(_)
    None => false
  }
}

///|
pub async fn EditorHarness::when_selected_autotile_rule_set_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_autotile_rule_set(value))
}

///|
pub async fn EditorHarness::when_selected_autotile_atlas_path_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_autotile_atlas_path(value))
}

///|
pub async fn EditorHarness::when_selected_autotile_palette_json_is_edited(
  self : EditorHarness,
  value : String,
) -> Unit {
  self.dispatch(@app.msg_update_selected_autotile_palette_json(value))
}

///|
pub async fn EditorHarness::when_selected_autotile_palette_json_is_committed(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_commit_selected_autotile_palette_json())
}

///|
pub async fn EditorHarness::when_preview_updates_autotile_layer(
  self : EditorHarness,
  id : String,
  component : @editor_bridge.AutoTileLayer2dComponent,
) -> Unit {
  self.emit_preview_event(
    @bridge.preview_event_autotile_layer_changed(id, component),
  )
}

///|
pub async fn EditorHarness::when_tool_is_set(
  self : EditorHarness,
  tool : @shared.PreviewTool,
) -> Unit {
  self.dispatch(@app.msg_set_tool(tool))
}

///|
pub async fn EditorHarness::when_scene_undo_is_requested(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_undo_scene())
}

///|
pub async fn EditorHarness::when_scene_redo_is_requested(
  self : EditorHarness,
) -> Unit {
  self.dispatch(@app.msg_redo_scene())
}

///|
pub fn EditorHarness::autotile_layer_component(
  self : EditorHarness,
  entity_id : String,
) -> @editor_bridge.AutoTileLayer2dComponent? {
  match self.entity(entity_id) {
    Some(entity) => @app.component_of(entity, "AutoTileLayer2d")
    None => None
  }
}
