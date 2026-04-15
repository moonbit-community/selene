///|
priv struct LegacyAnimationPlayerComponent {
  animation_asset_path : String?
} derive(FromJson)

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
  match (model_scene(self), self.selected_entity_id) {
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
  match self.scene_session {
    Some(session) => session.undo_stack.length() > 0
    None => false
  }
}

///|
pub fn Model::can_redo(self : Model) -> Bool {
  match self.scene_session {
    Some(session) => session.redo_stack.length() > 0
    None => false
  }
}
