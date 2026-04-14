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
  match (previous.scene, next.scene) {
    (Some(before), Some(after)) if before != after => {
      let undo_stack = bounded_history(previous.undo_stack + [before])
      {
        ..next,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    (Some(before), None) => {
      let undo_stack = bounded_history(previous.undo_stack + [before])
      {
        ..next,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    _ => next
  }
}

///|
fn with_started_scene_edit_transaction(model : Model, label : String) -> Model {
  match (model.scene, model.active_scene_edit_transaction) {
    (Some(before), None) => {
      let transaction : SceneEditTransaction = { label, before }
      { ..model, active_scene_edit_transaction: Some(transaction) }
    }
    _ => model
  }
}

///|
fn with_committed_scene_edit_transaction(model : Model) -> Model {
  match (model.active_scene_edit_transaction, model.scene) {
    (Some(transaction), Some(after)) if transaction.before != after => {
      let undo_stack = bounded_history(model.undo_stack + [transaction.before])
      {
        ..model,
        undo_stack,
        redo_stack: [],
        active_scene_edit_transaction: None,
      }
    }
    (Some(_), _) => { ..model, active_scene_edit_transaction: None }
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
priv struct LegacyAnimationPlayerComponent {
  animation_asset_path : String?
} derive(FromJson)

///|
fn rpc_effect(target : RpcTarget, request : @shared.RpcRequest) -> Effect {
  Rpc(target~, request=@shared.rpc_request_envelope(1, request))
}

///|
fn save_workspace_effects(model : Model) -> Array[Effect] {
  match model.current_root {
    Some(_) =>
      [
        rpc_effect(
          WorkspaceSaved,
          @shared.rpc_request_project_save_workspace(model.workspace),
        ),
      ]
    None => []
  }
}

///|
fn normalized_project_root(root : String) -> String {
  root.trim().to_string()
}

///|
fn next_entity_id(scene : @editor_bridge.SceneDocument) -> String {
  let mut index = scene.entities.length()
  for ;; {
    let candidate = "entity-\{index}"
    if scene.entity(candidate) is None {
      return candidate
    }
    index += 1
  }
  "entity"
}

///|
fn asset_basename(path : String) -> String {
  let normalized = path.replace(old="\\", new="/")
  let base = if normalized.rev_find("/") is Some(index) {
    normalized[index + 1:].to_string()
  } else {
    normalized
  }
  if base.rev_find(".") is Some(index) {
    base[:index].to_string()
  } else {
    base
  }
}

///|
fn resource_stem(path : String) -> String {
  asset_basename(path)
}

///|
fn next_resource_entity_translation() -> @editor_bridge.Vec2Doc {
  @editor_bridge.vec2_doc(0.0, 0.0)
}

///|
fn atlas_document_from_image(
  image_path : String,
  image_size : @editor_bridge.Vec2Doc?,
) -> @editor_bridge.AtlasAssetDocument {
  @editor_bridge.atlas_asset_document_from_image(
    resource_stem(image_path),
    image_path,
    image_size.unwrap_or(@editor_bridge.vec2_doc(32.0, 32.0)),
  )
}

///|
fn animation_clip_document_from_atlas(
  atlas_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
) -> @editor_bridge.AnimationClipAssetDocument {
  let mut frames : Array[String] = []
  for region in atlas.regions {
    frames.push(region.name)
  }
  if frames.is_empty() {
    frames = ["frame_0"]
  }
  @editor_bridge.animation_clip_asset_document(
    atlas.name + " Clip",
    atlas_path,
    8.0,
    true,
    frames,
  )
}

///|
fn animation_graph_document_for_clip(
  clip_path : String,
  clip : @editor_bridge.AnimationClipAssetDocument,
) -> @editor_bridge.AnimationGraphAssetDocument {
  @editor_bridge.AnimationGraphAssetDocument::default(
    clip.name + " Graph",
    clip_path,
  )
}

///|
fn animation_graph_default_clip_path(
  graph : @editor_bridge.AnimationGraphAssetDocument,
) -> String? {
  for node in graph.nodes {
    if graph.default_node == Some(node.id) {
      match node.kind {
        @editor_bridge.Clip(clip_asset_path~) => return Some(clip_asset_path)
        _ => ()
      }
    }
  }
  for node in graph.nodes {
    match node.kind {
      @editor_bridge.Clip(clip_asset_path~) => return Some(clip_asset_path)
      _ => ()
    }
  }
  None
}

///|
fn add_atlas_asset_to_scene(
  scene : @editor_bridge.SceneDocument,
  atlas_path : String,
  atlas : @editor_bridge.AtlasAssetDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let first_region = if atlas.regions.is_empty() {
    None
  } else {
    Some(atlas.regions[0])
  }
  let entity = @editor_bridge.entity_document(id, atlas.name, components=[
    @editor_bridge.name_component(atlas.name),
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      custom_size=Some(
        first_region.map_or(atlas.tile_size, fn(region) {
          @editor_bridge.vec2_doc(region.rect.width, region.rect.height)
        }),
      ),
      anchor=atlas.default_anchor,
    ),
    @editor_bridge.texture_atlas_component(
      atlas_asset_path=Some(atlas_path),
      region_name=first_region.map(fn(region) { region.name }),
      index=first_region.map_or(0, fn(region) { region.index }),
    ),
  ])
  (scene.with_entity(entity), id)
}

///|
fn add_animation_graph_asset_to_scene(
  scene : @editor_bridge.SceneDocument,
  graph_path : String,
  graph : @editor_bridge.AnimationGraphAssetDocument,
  clip : @editor_bridge.AnimationClipAssetDocument,
  atlas : @editor_bridge.AtlasAssetDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let mut default_frame_name = "frame_0"
  if !clip.frames.is_empty() {
    default_frame_name = clip.frames[0]
  }
  let mut first_region : @editor_bridge.AtlasRegionDocument? = None
  for region in atlas.regions {
    if region.name == default_frame_name {
      first_region = Some(region)
      break
    }
  }
  if first_region is None && !atlas.regions.is_empty() {
    first_region = Some(atlas.regions[0])
  }
  let entity = @editor_bridge.entity_document(id, graph.name, components=[
    @editor_bridge.name_component(graph.name),
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      custom_size=Some(
        first_region.map_or(atlas.tile_size, fn(region) {
          @editor_bridge.vec2_doc(region.rect.width, region.rect.height)
        }),
      ),
      anchor=atlas.default_anchor,
    ),
    @editor_bridge.texture_atlas_component(
      atlas_asset_path=Some(clip.atlas_asset_path),
      region_name=first_region.map(fn(region) { region.name }),
      index=first_region.map_or(0, fn(region) { region.index }),
    ),
    @editor_bridge.animation_player_component(
      graph_asset_path=Some(graph_path),
      start_node=graph.default_node,
      autoplay=true,
    ),
    @editor_bridge.animation_transitions_component(),
  ])
  (scene.with_entity(entity), id)
}

///|
fn subtree_entities(
  scene : @editor_bridge.SceneDocument,
  root_id : String,
) -> Array[@editor_bridge.EntityDocument] {
  let entities : Array[@editor_bridge.EntityDocument] = []
  fn visit(
    scene : @editor_bridge.SceneDocument,
    id : String,
    entities : Array[@editor_bridge.EntityDocument],
  ) -> Unit {
    match scene.entity(id) {
      Some(entity) => entities.push(entity)
      None => return
    }
    for child in scene.entities {
      if child.parent == Some(id) {
        visit(scene, child.id, entities)
      }
    }
  }
  visit(scene, root_id, entities)
  entities
}

///|
fn prefab_from_scene_selection(
  scene : @editor_bridge.SceneDocument,
  entity_id : String,
) -> @editor_bridge.PrefabDocument? {
  match scene.entity(entity_id) {
    Some(entity) =>
      Some(
        @editor_bridge.prefab_document(
          entity.name,
          subtree_entities(scene, entity_id),
        ),
      )
    None => None
  }
}

///|
fn instantiate_prefab_into_scene(
  scene : @editor_bridge.SceneDocument,
  prefab : @editor_bridge.PrefabDocument,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String?) {
  let mut next_scene = scene
  let id_map : Map[String, String] = {}
  let mut root_id : String? = None
  for entity in prefab.entities {
    let new_id = next_entity_id(next_scene)
    id_map.set(entity.id, new_id)
    let is_root = entity.parent is None
    let next_parent = match entity.parent {
      Some(parent) => id_map.get(parent)
      None => None
    }
    let mut next_entity = @editor_bridge.entity_document(
      new_id,
      entity.name,
      parent=next_parent,
      components=entity.components,
    )
    if is_root {
      root_id = Some(new_id)
      let transform : @editor_bridge.Transform2dComponent = component_of(
        entity, "Transform2d",
      ).unwrap_or(@editor_bridge.transform2d_value())
      next_entity = next_entity.with_component(
        @editor_bridge.transform2d_component(
          translation=@editor_bridge.vec2_doc(
            transform.translation.x + translation.x,
            transform.translation.y + translation.y,
          ),
          rotation=transform.rotation,
          scale=transform.scale,
        ),
      )
    }
    next_scene = next_scene.with_entity(next_entity)
  }
  (next_scene, root_id)
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
  match model.scene {
    Some(scene) => {
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
            Some(model.scene_path),
            scene,
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
    effects.push(
      rpc_effect(PrefabLoaded, @shared.rpc_request_prefab_load(prefab_ref.path)),
    )
  }
  for atlas_ref in model.atlas_refs {
    effects.push(
      rpc_effect(AtlasLoaded, @shared.rpc_request_atlas_load(atlas_ref.path)),
    )
  }
  for animation_ref in model.animation_clip_refs {
    effects.push(
      rpc_effect(
        AnimationClipLoaded,
        @shared.rpc_request_animation_clip_load(animation_ref.path),
      ),
    )
  }
  for animation_ref in model.animation_graph_refs {
    effects.push(
      rpc_effect(
        AnimationGraphLoaded,
        @shared.rpc_request_animation_graph_load(animation_ref.path),
      ),
    )
  }
  effects
}

///|
fn refresh_project_effects(model : Model) -> Array[Effect] {
  match model.manifest {
    Some(_) => {
      let effects : Array[Effect] = [
        Preview(@bridge.preview_command_bootstrap()),
        rpc_effect(
          SceneLoaded,
          @shared.rpc_request_scene_load(model.scene_path),
        ),
        rpc_effect(SceneListLoaded, @shared.rpc_request_scene_list()),
        rpc_effect(AssetsLoaded, @shared.rpc_request_assets_list()),
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
fn parse_double_or(current : Double, input : String) -> Double {
  @string.parse_double(input[:]) catch {
    _ => current
  }
}

///|
fn parse_int_or(current : Int, input : String) -> Int {
  @string.parse_int(input[:]) catch {
    _ => current
  }
}

///|
fn parse_positive_double_or(current : Double, input : String) -> Double {
  let parsed = parse_double_or(current, input)
  if parsed <= 0.0 {
    current
  } else {
    parsed
  }
}

///|
fn parse_positive_int_or(current : Int, input : String) -> Int {
  let parsed = parse_int_or(current, input)
  if parsed <= 0 {
    current
  } else {
    parsed
  }
}

///|
fn atlas_region_name(
  existing : Array[@editor_bridge.AtlasRegionDocument],
  index : Int,
) -> String {
  for region in existing {
    if region.index == index {
      return region.name
    }
  }
  "frame_\{index}"
}

///|
fn rebuild_atlas_regions(
  atlas : @editor_bridge.AtlasAssetDocument,
) -> Array[@editor_bridge.AtlasRegionDocument] {
  let regions : Array[@editor_bridge.AtlasRegionDocument] = []
  let step_x = atlas.tile_size.x + atlas.spacing.x
  let step_y = atlas.tile_size.y + atlas.spacing.y
  for row = 0; row < atlas.rows; row = row + 1 {
    for column = 0; column < atlas.columns; column = column + 1 {
      let index = row * atlas.columns + column
      regions.push(
        @editor_bridge.atlas_region_document(
          atlas_region_name(atlas.regions, index),
          index,
          @editor_bridge.rect_doc(
            atlas.margin.x + step_x * column.to_double(),
            atlas.margin.y + step_y * row.to_double(),
            atlas.tile_size.x,
            atlas.tile_size.y,
          ),
        ),
      )
    }
  }
  regions
}

///|
fn with_rebuilt_regions(
  atlas : @editor_bridge.AtlasAssetDocument,
) -> @editor_bridge.AtlasAssetDocument {
  atlas.with_regions(rebuild_atlas_regions(atlas))
}

///|
fn parse_clip_frames(current : Array[String], input : String) -> Array[String] {
  let frames : Array[String] = []
  for raw in input.split(",") {
    let frame = raw.trim().to_string()
    if frame != "" {
      frames.push(frame)
    }
  }
  if frames.is_empty() {
    current
  } else {
    frames
  }
}

///|
fn animation_graph_has_node_id(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node_id : String,
) -> Bool {
  for node in graph.nodes {
    if node.id == node_id {
      return true
    }
  }
  false
}

///|
fn next_animation_graph_node_id(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  prefix : String,
) -> String {
  let mut index = graph.nodes.length() + 1
  for ;; {
    let candidate = prefix + "-" + index.to_string()
    if !animation_graph_has_node_id(graph, candidate) {
      return candidate
    }
    index += 1
  }
  prefix + "-1"
}

///|
fn clamp01(value : Double) -> Double {
  if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn animation_graph_axis_bounds(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  axis : (@editor_bridge.AnimationGraphNodeDocument) -> Double,
) -> (Double, Double) {
  if graph.nodes.is_empty() {
    return (-1.0, 1.0)
  }
  let mut min_value = axis(graph.nodes[0])
  let mut max_value = min_value
  for node in graph.nodes[1:] {
    let value = axis(node)
    if value < min_value {
      min_value = value
    }
    if value > max_value {
      max_value = value
    }
  }
  if max_value - min_value < 0.001 {
    (min_value - 1.0, max_value + 1.0)
  } else {
    (min_value, max_value)
  }
}

///|
fn animation_graph_axis_unproject(
  normalized : Double,
  min_value : Double,
  max_value : Double,
) -> Double {
  min_value + clamp01(normalized) * (max_value - min_value)
}

///|
fn first_animation_clip_path(model : Model) -> String? {
  for clip_ref in model.animation_clip_refs {
    return Some(clip_ref.path)
  }
  for path, _ in model.animation_clip_documents {
    return Some(path)
  }
  None
}

///|
fn with_selected_animation_graph_node_added(
  model : Model,
  kind : @editor_bridge.AnimationGraphNodeKind,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let node_id = next_animation_graph_node_id(graph, "node")
    let node = @editor_bridge.animation_graph_node_document(
      node_id,
      kind,
      position=@editor_bridge.vec2_doc(
        160.0 + graph.nodes.length().to_double() * 80.0,
        120.0,
      ),
    )
    let next_default = if graph.default_node is Some(_) {
      graph.default_node
    } else {
      Some(node_id)
    }
    graph.with_nodes(graph.nodes + [node]).with_default_node(next_default)
  })
}

///|
fn with_selected_animation_graph_node_removed(
  model : Model,
  node_id : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    let mut removed = false
    for node in graph.nodes {
      if node.id == node_id {
        removed = true
      } else {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for edge in node.edges {
          if edge.to != node_id {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      }
    }
    let next_default = if graph.default_node == Some(node_id) {
      if nodes.is_empty() {
        None
      } else {
        Some(nodes[0].id)
      }
    } else {
      graph.default_node
    }
    if removed {
      graph.with_nodes(nodes).with_default_node(next_default)
    } else {
      graph
    }
  })
}

///|
fn with_selected_animation_graph_clip_path_updated(
  model : Model,
  node_id : String,
  clip_path : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        match node.kind {
          @editor_bridge.Clip(..) =>
            nodes.push(
              node.with_kind(
                @editor_bridge.animation_graph_node_kind_clip(clip_path),
              ),
            )
          _ => nodes.push(node)
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn next_animation_graph_edge_target(
  graph : @editor_bridge.AnimationGraphAssetDocument,
  node_id : String,
) -> String? {
  for node in graph.nodes {
    if node.id != node_id {
      return Some(node.id)
    }
  }
  None
}

///|
fn with_selected_animation_graph_edge_added(
  model : Model,
  node_id : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    let target = next_animation_graph_edge_target(graph, node_id)
    for node in graph.nodes {
      if node.id == node_id {
        match target {
          Some(target) => {
            let mut exists = false
            for edge in node.edges {
              if edge.to == target {
                exists = true
                break
              }
            }
            if exists {
              nodes.push(node)
            } else {
              nodes.push(
                node.with_edges(
                  node.edges +
                  [@editor_bridge.animation_graph_edge_document(target)],
                ),
              )
            }
          }
          None => nodes.push(node)
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_added_to_target(
  model : Model,
  source_node_id : String,
  target_node_id : String,
) -> (Model, Bool) {
  if source_node_id == target_node_id {
    return (model, false)
  }
  let mut changed = false
  let next = update_selected_animation_graph_document(model, fn(graph) {
    let mut target_exists = false
    for node in graph.nodes {
      if node.id == target_node_id {
        target_exists = true
        break
      }
    }
    if !target_exists {
      return graph
    }
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == source_node_id {
        let mut exists = false
        for edge in node.edges {
          if edge.to == target_node_id {
            exists = true
            break
          }
        }
        if exists {
          nodes.push(node)
        } else {
          changed = true
          nodes.push(
            node.with_edges(
              node.edges +
              [@editor_bridge.animation_graph_edge_document(target_node_id)],
            ),
          )
        }
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
  (next, changed)
}

///|
fn with_selected_animation_graph_edge_removed(
  model : Model,
  node_id : String,
  edge_index : Int,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          if index != edge_index {
            edges.push(node.edges[index])
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_target_updated(
  model : Model,
  node_id : String,
  edge_index : Int,
  target : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let next_target = target.trim().to_string()
    if next_target == "" {
      return graph
    }
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          let edge = node.edges[index]
          if index == edge_index {
            edges.push(
              @editor_bridge.animation_graph_edge_document(
                next_target,
                weight=edge.weight,
              ),
            )
          } else {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
}

///|
fn with_selected_animation_graph_edge_weight_updated(
  model : Model,
  node_id : String,
  edge_index : Int,
  value : String,
) -> Model {
  update_selected_animation_graph_document(model, fn(graph) {
    let nodes : Array[@editor_bridge.AnimationGraphNodeDocument] = []
    for node in graph.nodes {
      if node.id == node_id {
        let edges : Array[@editor_bridge.AnimationGraphEdgeDocument] = []
        for index = 0; index < node.edges.length(); index = index + 1 {
          let edge = node.edges[index]
          if index == edge_index {
            edges.push(
              @editor_bridge.animation_graph_edge_document(
                edge.to,
                weight=parse_positive_double_or(edge.weight, value),
              ),
            )
          } else {
            edges.push(edge)
          }
        }
        nodes.push(node.with_edges(edges))
      } else {
        nodes.push(node)
      }
    }
    graph.with_nodes(nodes)
  })
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

///|
pub fn tool_label(tool : @shared.PreviewTool) -> String {
  match tool {
    @shared.Select => "Select"
    @shared.DragCanvas => "Drag Canvas"
    @shared.Translate => "Move"
    @shared.Rotate => "Rotate"
    @shared.Scale => "Scale"
    @shared.AutoTilePaint => "AutoTile Paint"
    @shared.AutoTileErase => "AutoTile Erase"
    @shared.AutoTileFill => "AutoTile Fill"
  }
}

///|
pub fn entity_label(entity : @editor_bridge.EntityDocument) -> String {
  entity.name + " (" + entity.id + ")"
}

///|
fn scene_path_exists(
  scene_refs : Array[@editor_bridge.SceneRef],
  path : String,
) -> Bool {
  for scene_ref in scene_refs {
    if scene_ref.path == path {
      return true
    }
  }
  false
}

///|
fn asset_ref_exists(
  refs : Array[@editor_bridge.AssetRef],
  path : String,
) -> Bool {
  for asset_ref in refs {
    if asset_ref.path == path {
      return true
    }
  }
  false
}

///|
fn prefab_ref_exists(
  refs : Array[@editor_bridge.PrefabRef],
  path : String,
) -> Bool {
  for prefab_ref in refs {
    if prefab_ref.path == path {
      return true
    }
  }
  false
}

///|
fn resource_exists(model : Model, selection : ResourceSelection) -> Bool {
  match selection {
    Image(path) => {
      for asset in model.assets {
        if asset.kind is @editor_bridge.Image && asset.path == path {
          return true
        }
      }
      false
    }
    Atlas(path) => {
      for asset_ref in model.atlas_refs {
        if asset_ref.path == path {
          return true
        }
      }
      false
    }
    AnimationClip(path) => {
      for asset_ref in model.animation_clip_refs {
        if asset_ref.path == path {
          return true
        }
      }
      false
    }
    AnimationGraph(path) => {
      for asset_ref in model.animation_graph_refs {
        if asset_ref.path == path {
          return true
        }
      }
      false
    }
    Prefab(path) => {
      for prefab_ref in model.prefab_refs {
        if prefab_ref.path == path {
          return true
        }
      }
      false
    }
  }
}

///|
fn sorted_strings(values : Array[String]) -> Array[String] {
  let sorted : Array[String] = []
  sorted.push_iter(values.iter())
  sorted.sort_by(fn(left, right) { left.compare(right) })
  sorted
}

///|
fn legacy_animation_paths_in_scene(
  scene : @editor_bridge.SceneDocument,
) -> Array[String] {
  let paths : Array[String] = []
  let seen : Map[String, Bool] = {}
  for entity in scene.entities {
    guard entity.component("AnimationPlayer") is Some(player_component) else {
      continue
    }
    let legacy_result : Result[LegacyAnimationPlayerComponent, Error] = try? @json.from_json(
      player_component.data,
    )
    guard legacy_result is Ok(legacy_player) else { continue }
    guard legacy_player.animation_asset_path is Some(path) else { continue }
    let normalized_path = path.trim().to_string()
    if normalized_path == "" || seen.contains(normalized_path) {
      continue
    }
    seen.set(normalized_path, true)
    paths.push(normalized_path)
  }
  sorted_strings(paths)
}

///|
fn visible_resources_in_order(model : Model) -> Array[ResourceSelection] {
  let resources : Array[ResourceSelection] = []
  let force_expand_sections = model.asset_query_normalized() != ""

  if model.images_section_expanded || force_expand_sections {
    let image_paths : Array[String] = []
    for asset in model.image_assets() {
      if model.asset_matches_query(asset_basename(asset.path), asset.path) {
        image_paths.push(asset.path)
      }
    }
    for path in sorted_strings(image_paths) {
      resources.push(Image(path))
    }
  }

  if model.atlases_section_expanded || force_expand_sections {
    let atlas_paths : Array[String] = []
    for atlas_ref in model.atlas_refs {
      let atlas_name = match model.atlas_documents.get(atlas_ref.path) {
        Some(atlas) => atlas.name
        None => asset_basename(atlas_ref.path)
      }
      if model.asset_matches_query(atlas_name, atlas_ref.path) {
        atlas_paths.push(atlas_ref.path)
      }
    }
    for path in sorted_strings(atlas_paths) {
      resources.push(Atlas(path))
    }
  }

  if model.animation_clips_section_expanded || force_expand_sections {
    let animation_paths : Array[String] = []
    for animation_ref in model.animation_clip_refs {
      let animation_name = match
        model.animation_clip_documents.get(animation_ref.path) {
        Some(animation) => animation.name
        None => asset_basename(animation_ref.path)
      }
      if model.asset_matches_query(animation_name, animation_ref.path) {
        animation_paths.push(animation_ref.path)
      }
    }
    for path in sorted_strings(animation_paths) {
      resources.push(AnimationClip(path))
    }
  }

  if model.animation_graphs_section_expanded || force_expand_sections {
    let animation_paths : Array[String] = []
    for animation_ref in model.animation_graph_refs {
      let animation_name = match
        model.animation_graph_documents.get(animation_ref.path) {
        Some(animation) => animation.name
        None => asset_basename(animation_ref.path)
      }
      if model.asset_matches_query(animation_name, animation_ref.path) {
        animation_paths.push(animation_ref.path)
      }
    }
    for path in sorted_strings(animation_paths) {
      resources.push(AnimationGraph(path))
    }
  }

  if model.prefabs_section_expanded || force_expand_sections {
    let prefab_paths : Array[String] = []
    for prefab_ref in model.prefab_refs {
      let prefab_name = match model.prefab_documents.get(prefab_ref.path) {
        Some(prefab) => prefab.name
        None => asset_basename(prefab_ref.path)
      }
      if model.asset_matches_query(prefab_name, prefab_ref.path) {
        prefab_paths.push(prefab_ref.path)
      }
    }
    for path in sorted_strings(prefab_paths) {
      resources.push(Prefab(path))
    }
  }

  resources
}

///|
fn resource_index(
  resources : Array[ResourceSelection],
  target : ResourceSelection,
) -> Int? {
  for index = 0; index < resources.length(); index = index + 1 {
    if resources[index] == target {
      return Some(index)
    }
  }
  None
}

///|
fn with_expanded_section_for_selection(
  model : Model,
  selection : ResourceSelection?,
) -> Model {
  match selection {
    Some(Image(_)) => { ..model, images_section_expanded: true }
    Some(Atlas(_)) => { ..model, atlases_section_expanded: true }
    Some(AnimationClip(_)) =>
      { ..model, animation_clips_section_expanded: true }
    Some(AnimationGraph(_)) =>
      { ..model, animation_graphs_section_expanded: true }
    Some(Prefab(_)) => { ..model, prefabs_section_expanded: true }
    None => model
  }
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
fn add_sprite_asset_to_scene(
  asset_size : @editor_bridge.Vec2Doc?,
  scene : @editor_bridge.SceneDocument,
  asset_path : String,
  translation : @editor_bridge.Vec2Doc,
) -> (@editor_bridge.SceneDocument, String) {
  let id = next_entity_id(scene)
  let entity = @editor_bridge.entity_document(id, asset_basename(asset_path), components=[
    @editor_bridge.transform2d_component(translation~),
    @editor_bridge.visibility_component(),
    @editor_bridge.sprite_component(
      image_path=Some(asset_path),
      custom_size=asset_size,
    ),
  ])
  (scene.with_entity(entity), id)
}

///|
pub fn Model::selected_entity(self : Model) -> @editor_bridge.EntityDocument? {
  match (self.scene, self.selected_entity_id) {
    (Some(scene), Some(id)) => scene.entity(id)
    _ => None
  }
}

///|
pub fn Model::image_assets(self : Model) -> Array[@editor_bridge.AssetDocument] {
  let images : Array[@editor_bridge.AssetDocument] = []
  for asset in self.assets {
    if asset.kind is @editor_bridge.Image {
      images.push(asset)
    }
  }
  images
}

///|
pub fn Model::selected_image_asset(
  self : Model,
) -> @editor_bridge.AssetDocument? {
  match self.selected_resource {
    Some(Image(path)) => {
      for asset in self.assets {
        if asset.kind is @editor_bridge.Image && asset.path == path {
          return Some(asset)
        }
      }
      None
    }
    _ => None
  }
}

///|
pub fn Model::selected_atlas_document(
  self : Model,
) -> (String, @editor_bridge.AtlasAssetDocument)? {
  match self.selected_resource {
    Some(Atlas(path)) =>
      match self.atlas_documents.get(path) {
        Some(atlas) => Some((path, atlas))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::selected_animation_clip_document(
  self : Model,
) -> (String, @editor_bridge.AnimationClipAssetDocument)? {
  match self.selected_resource {
    Some(AnimationClip(path)) =>
      match self.animation_clip_documents.get(path) {
        Some(animation) => Some((path, animation))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::selected_animation_graph_document(
  self : Model,
) -> (String, @editor_bridge.AnimationGraphAssetDocument)? {
  match self.selected_resource {
    Some(AnimationGraph(path)) =>
      match self.animation_graph_documents.get(path) {
        Some(animation) => Some((path, animation))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::selected_prefab_document(
  self : Model,
) -> (String, @editor_bridge.PrefabDocument)? {
  match self.selected_resource {
    Some(Prefab(path)) =>
      match self.prefab_documents.get(path) {
        Some(prefab) => Some((path, prefab))
        None => None
      }
    _ => None
  }
}

///|
pub fn Model::asset_size(
  self : Model,
  path : String,
) -> @editor_bridge.Vec2Doc? {
  self.asset_sizes.get(path)
}

///|
pub fn Model::asset_query_normalized(self : Model) -> String {
  self.asset_query.trim().to_string().to_lower()
}

///|
pub fn Model::asset_matches_query(
  self : Model,
  name : String,
  path : String,
) -> Bool {
  let query = self.asset_query_normalized()
  if query == "" {
    true
  } else {
    name.to_lower().contains(query) || path.to_lower().contains(query)
  }
}

///|
pub fn Model::asset_tree_folder_expanded(self : Model, key : String) -> Bool {
  self.asset_tree_expanded.get(key).unwrap_or(true)
}

///|
pub fn Model::selected_resource_path(self : Model) -> String? {
  match self.selected_resource {
    Some(Image(path)) => Some(path)
    Some(Atlas(path)) => Some(path)
    Some(AnimationClip(path)) => Some(path)
    Some(AnimationGraph(path)) => Some(path)
    Some(Prefab(path)) => Some(path)
    None => None
  }
}

///|
pub fn Model::can_undo(self : Model) -> Bool {
  self.undo_stack.length() > 0
}

///|
pub fn Model::can_redo(self : Model) -> Bool {
  self.redo_stack.length() > 0
}

///|
fn resource_selection_section_key(selection : ResourceSelection) -> String {
  match selection {
    Image(_) => "images"
    Atlas(_) => "atlases"
    AnimationClip(_) => "animation-clips"
    AnimationGraph(_) => "animation-graphs"
    Prefab(_) => "prefabs"
  }
}

///|
fn resource_selection_root_folder(selection : ResourceSelection) -> String {
  match selection {
    Image(_) => "assets"
    Atlas(_) => "assets"
    AnimationClip(_) => "assets"
    AnimationGraph(_) => "assets"
    Prefab(_) => "prefabs"
  }
}

///|
fn resource_selection_path(selection : ResourceSelection) -> String {
  match selection {
    Image(path) => path
    Atlas(path) => path
    AnimationClip(path) => path
    AnimationGraph(path) => path
    Prefab(path) => path
  }
}

///|
fn resource_selection_name(selection : ResourceSelection) -> String {
  asset_basename(resource_selection_path(selection))
}

///|
fn resource_tree_segments(path : String, root : String) -> Array[String] {
  let raw = path.split("/")
  let segments : Array[String] = []
  for segment in raw {
    if segment != "" {
      segments.push(segment.to_string())
    }
  }
  let mut start = 0
  if !segments.is_empty() && segments[0] == root {
    start = 1
  }
  let trimmed : Array[String] = []
  for index = start; index < segments.length(); index = index + 1 {
    trimmed.push(segments[index])
  }
  trimmed
}

///|
fn with_asset_tree_expanded_for_selection(
  expanded : Map[String, Bool],
  selection : ResourceSelection?,
) -> Map[String, Bool] {
  let next = expanded
  match selection {
    Some(selection) => {
      let section = resource_selection_section_key(selection)
      let root = resource_selection_root_folder(selection)
      let path = resource_selection_path(selection)
      let segments = resource_tree_segments(path, root)
      if segments.length() <= 1 {
        return next
      }
      for index = 0; index < segments.length() - 1; index = index + 1 {
        let key = section + ":" + segments[:index + 1].join("/")
        next.set(key, true)
      }
      next
    }
    None => next
  }
}

///|
fn collect_folder_keys_for_path(
  path : String,
  section : String,
  root : String,
  seen : Map[String, Bool],
  keys : Array[String],
) -> Unit {
  let segments = resource_tree_segments(path, root)
  if segments.length() <= 1 {
    return
  }
  for index = 0; index < segments.length() - 1; index = index + 1 {
    let key = section + ":" + segments[:index + 1].join("/")
    if seen.contains(key) {
      continue
    }
    seen.set(key, true)
    keys.push(key)
  }
}

///|
fn all_asset_tree_folder_keys(model : Model) -> Array[String] {
  let seen : Map[String, Bool] = {}
  let keys : Array[String] = []
  for asset in model.image_assets() {
    collect_folder_keys_for_path(asset.path, "images", "assets", seen, keys)
  }
  for atlas in model.atlas_refs {
    collect_folder_keys_for_path(atlas.path, "atlases", "assets", seen, keys)
  }
  for animation in model.animation_clip_refs {
    collect_folder_keys_for_path(
      animation.path,
      "animation-clips",
      "assets",
      seen,
      keys,
    )
  }
  for animation in model.animation_graph_refs {
    collect_folder_keys_for_path(
      animation.path,
      "animation-graphs",
      "assets",
      seen,
      keys,
    )
  }
  for prefab in model.prefab_refs {
    collect_folder_keys_for_path(prefab.path, "prefabs", "prefabs", seen, keys)
  }
  keys
}

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
fn update_selected_animation_graph_document(
  model : Model,
  updater : (@editor_bridge.AnimationGraphAssetDocument) -> @editor_bridge.AnimationGraphAssetDocument,
) -> Model {
  match model.selected_animation_graph_document() {
    Some((path, animation)) => {
      let animation_graph_documents = model.animation_graph_documents
      animation_graph_documents.set(path, updater(animation))
      { ..model, animation_graph_documents, }
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

///|
