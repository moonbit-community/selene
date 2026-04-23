///|
pub struct Vec2Doc {
  x : Double
  y : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct RectDoc {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct ColorDoc {
  r : Int
  g : Int
  b : Int
  a : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AssetRef {
  path : String
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct SceneRef {
  path : String
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct PrefabRef {
  path : String
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct ProjectManifest {
  version : Int
  name : String
  startup_scene : String
  asset_roots : Array[String]
  scene_index : Array[SceneRef]
  prefab_index : Array[PrefabRef]
  atlas_index : Array[AssetRef]
  animation_clip_index : Array[AssetRef]
  animation_graph_index : Array[AssetRef]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct SceneDocument {
  version : Int
  name : String
  entities : Array[EntityDocument]
} derive(Eq, ToJson, FromJson)

///|
pub struct PrefabDocument {
  version : Int
  name : String
  entities : Array[EntityDocument]
} derive(Eq, ToJson, FromJson)

///|
pub struct WorkspaceDocument {
  version : Int
  last_scene : String?
  selected_entity_id : String?
  move_snap_enabled : Bool?
  move_snap_step : Double?
  sidebar_scene_ratio : Double?
  sidebar_assets_ratio : Double?
  asset_scope : String?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct EntityDocument {
  id : String
  name : String
  parent : String?
  components : Array[ComponentDocument]
} derive(Eq, ToJson, FromJson)

///|
pub struct ComponentDocument {
  kind : String
  data : Json
} derive(Eq, ToJson, FromJson)

///|
pub enum BuiltinComponentKind {
  Name
  Transform2d
  Visibility
  Sprite
  TextureAtlas
  AutoTileLayer2d
  Text2d
  Mesh2d
  ColorMaterial
  Camera2d
  PhysicsBody2d
  PhysicsCollider2d
  AnimationPlayer
  AnimationTransitions
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct NameComponent {
  value : String
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct Transform2dComponent {
  translation : Vec2Doc
  rotation : Double
  scale : Vec2Doc
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct VisibilityComponent {
  visible : Bool
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct TextureAtlasLayoutDoc {
  tile_size : Vec2Doc
  columns : Int
  rows : Int
  padding : Vec2Doc
  offset : Vec2Doc
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct TextureAtlasComponent {
  atlas_asset_path : String?
  region_name : String?
  layout : TextureAtlasLayoutDoc?
  index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct SpriteComponent {
  image_path : String?
  color : ColorDoc
  custom_size : Vec2Doc?
  anchor : Vec2Doc
  flip_x : Bool
  flip_y : Bool
  rect : RectDoc?
  image_mode : String
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct Text2dComponent {
  content : String
  font_path : String?
  font_size : Double
  color : ColorDoc
  bounds : Vec2Doc?
  anchor : Vec2Doc
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct Mesh2dComponent {
  primitive : String
  size : Vec2Doc?
  radius : Double?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct ColorMaterialComponent {
  color : ColorDoc
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct Camera2dComponent {
  is_active : Bool
  order : Int
  scale : Double
  viewport : RectDoc?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct PhysicsBody2dComponent {
  body_type : String
  linear_velocity : Vec2Doc
  angular_velocity : Double
  gravity_scale : Double
  linear_damping : Double
  angular_damping : Double
  lock_rotation : Bool
  ccd_enabled : Bool
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct PhysicsCollider2dComponent {
  shape : String
  size : Vec2Doc?
  radius : Double?
  sensor : Bool
  friction : Double
  restitution : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AnimationPlayerComponent {
  graph_asset_path : String?
  start_node : String?
  autoplay : Bool
  repeat_mode : String
  speed : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub enum AnimationRepeatModeDoc {
  Never
  Forever
  Count(Int)
} derive(Debug, Eq)

///|
pub struct AnimationTransitionsComponent {
  duration : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub enum AutoTileRuleSetDocument {
  Bitmask4
  Bitmask8
  Wang
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AutoTileMaskRuleDocument {
  mask : Int
  region_name : String
  atlas_index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AutoTileWangRuleDocument {
  north : Int
  east : Int
  south : Int
  west : Int
  region_name : String
  atlas_index : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AutoTilePaletteEntryDocument {
  terrain : Int
  fallback_region_name : String
  fallback_atlas_index : Int
  bitmask4_rules : Array[AutoTileMaskRuleDocument]
  bitmask8_rules : Array[AutoTileMaskRuleDocument]
  wang_rules : Array[AutoTileWangRuleDocument]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AutoTileCellDocument {
  x : Int
  y : Int
  terrain : Int
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AutoTileLayer2dComponent {
  tile_size : Vec2Doc
  origin : Vec2Doc
  atlas_asset_path : String
  rule_set : AutoTileRuleSetDocument
  palette : Array[AutoTilePaletteEntryDocument]
  cells : Array[AutoTileCellDocument]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AtlasRegionDocument {
  name : String
  index : Int
  rect : RectDoc
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AtlasAssetDocument {
  version : Int
  name : String
  source_image : String
  tile_size : Vec2Doc
  columns : Int
  rows : Int
  spacing : Vec2Doc
  margin : Vec2Doc
  default_anchor : Vec2Doc
  regions : Array[AtlasRegionDocument]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AnimationClipAssetDocument {
  version : Int
  name : String
  atlas_asset_path : String
  fps : Double
  looping : Bool
  frames : Array[String]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub enum AnimationGraphNodeKind {
  Clip(clip_asset_path~ : String)
  Blend
  AdditiveBlend
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AnimationGraphEdgeDocument {
  to : String
  weight : Double
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AnimationGraphNodeDocument {
  id : String
  kind : AnimationGraphNodeKind
  mask_groups : Array[Int]
  position : Vec2Doc
  edges : Array[AnimationGraphEdgeDocument]
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AnimationGraphAssetDocument {
  version : Int
  name : String
  nodes : Array[AnimationGraphNodeDocument]
  default_node : String?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub enum AssetKind {
  Directory
  Image
  Audio
  Font
  Atlas
  AnimationClip
  AnimationGraph
  Scene
  Prefab
  Project
  Meta
  Json
  Unknown
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AssetMetaDocument {
  tags : Array[String]
  importer : String?
  source : String?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub struct AssetDocument {
  path : String
  kind : AssetKind
  meta_path : String?
} derive(Debug, Eq, ToJson, FromJson)

///|
pub fn vec2_doc(x : Double, y : Double) -> Vec2Doc {
  { x, y }
}

///|
pub fn rect_doc(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> RectDoc {
  { x, y, width, height }
}

///|
pub fn color_doc(r : Int, g : Int, b : Int, a? : Int = 255) -> ColorDoc {
  { r, g, b, a }
}

///|
pub fn asset_ref(path : String) -> AssetRef {
  { path, }
}

///|
pub fn scene_ref(path : String) -> SceneRef {
  { path, }
}

///|
pub fn prefab_ref(path : String) -> PrefabRef {
  { path, }
}

///|
pub fn Vec2Doc::with_x(self : Vec2Doc, x : Double) -> Vec2Doc {
  { ..self, x, }
}

///|
pub fn Vec2Doc::with_y(self : Vec2Doc, y : Double) -> Vec2Doc {
  { ..self, y, }
}

///|
pub fn transform2d_value(
  translation? : Vec2Doc = vec2_doc(0.0, 0.0),
  rotation? : Double = 0.0,
  scale? : Vec2Doc = vec2_doc(1.0, 1.0),
) -> Transform2dComponent {
  { translation, rotation, scale }
}

///|
pub fn Transform2dComponent::with_translation(
  self : Transform2dComponent,
  translation : Vec2Doc,
) -> Transform2dComponent {
  { ..self, translation, }
}

///|
pub fn Transform2dComponent::with_rotation(
  self : Transform2dComponent,
  rotation : Double,
) -> Transform2dComponent {
  { ..self, rotation, }
}

///|
pub fn Transform2dComponent::with_scale(
  self : Transform2dComponent,
  scale : Vec2Doc,
) -> Transform2dComponent {
  { ..self, scale, }
}

///|
pub fn Text2dComponent::with_content(
  self : Text2dComponent,
  content : String,
) -> Text2dComponent {
  { ..self, content, }
}

///|
pub fn VisibilityComponent::toggled(
  self : VisibilityComponent,
) -> VisibilityComponent {
  { visible: !self.visible }
}

///|
pub fn AnimationPlayerComponent::repeat_mode_doc(
  self : AnimationPlayerComponent,
) -> AnimationRepeatModeDoc {
  animation_repeat_mode_doc_from_string(self.repeat_mode)
}

///|
pub fn AnimationPlayerComponent::with_repeat_mode_doc(
  self : AnimationPlayerComponent,
  repeat_mode : AnimationRepeatModeDoc,
) -> AnimationPlayerComponent {
  { ..self, repeat_mode: animation_repeat_mode_doc_to_string(repeat_mode) }
}

///|
fn asset_kind_extension(path : String) -> String? {
  if path.rev_find(".") is Some(index) {
    Some(path[index + 1:].to_string().to_lower())
  } else {
    None
  }
}

///|
fn sanitized_document_name(name : String) -> String {
  let normalized = name
    .trim()
    .to_string()
    .to_lower()
    .replace(old="\\", new="-")
    .replace(old="/", new="-")
    .replace(old=":", new="-")
    .replace(old="*", new="-")
    .replace(old="?", new="-")
    .replace(old="\"", new="-")
    .replace(old="<", new="-")
    .replace(old=">", new="-")
    .replace(old="|", new="-")
    .replace(old=".", new="-")
    .replace(old="\t", new=" ")
    .replace(old="\n", new=" ")
    .replace(old="\r", new=" ")
  let parts : Array[String] = []
  for part in normalized.split(" ") {
    let token = part.trim().to_string()
    if token != "" {
      parts.push(token)
    }
  }
  let stem = parts.join("-")
  if stem == "" {
    "project"
  } else {
    stem
  }
}

///|
pub fn normalized_document_stem(name : String) -> String {
  sanitized_document_name(name)
}

///|
pub fn project_manifest_file_name(_name : String) -> String {
  "selene.project.json"
}

///|
pub fn startup_scene_path_for_name(name : String) -> String {
  "scenes/" + normalized_document_stem(name) + ".scene.json"
}

///|
pub fn scene_file_name(name : String) -> String {
  normalized_document_stem(name) + ".scene.json"
}

///|
pub fn prefab_file_name(name : String) -> String {
  normalized_document_stem(name) + ".prefab.json"
}

///|
pub fn atlas_asset_file_name(name : String) -> String {
  normalized_document_stem(name) + ".atlas.json"
}

///|
pub fn animation_clip_asset_file_name(name : String) -> String {
  normalized_document_stem(name) + ".clip.json"
}

///|
pub fn animation_graph_asset_file_name(name : String) -> String {
  normalized_document_stem(name) + ".graph.json"
}

///|
pub fn infer_asset_kind(path : String) -> AssetKind {
  if path.has_suffix(".meta.json") {
    return Meta
  }
  if path.has_suffix(".scene.json") {
    return Scene
  }
  if path.has_suffix(".prefab.json") {
    return Prefab
  }
  if path.has_suffix(".atlas.json") {
    return Atlas
  }
  if path.has_suffix(".clip.json") {
    return AnimationClip
  }
  if path.has_suffix(".graph.json") {
    return AnimationGraph
  }
  if path.has_suffix("selene.project.json") {
    return Project
  }
  match asset_kind_extension(path) {
    Some("png") | Some("jpg") | Some("jpeg") | Some("webp") => Image
    Some("wav") | Some("ogg") | Some("mp3") => Audio
    Some("ttf") | Some("otf") => Font
    Some("json") => Json
    _ => Unknown
  }
}

///|
pub fn ProjectManifest::default(
  name : String,
  startup_scene? : String = startup_scene_path_for_name(name),
  asset_roots? : Array[String] = [
    "assets/images", "assets/audio", "assets/fonts", "assets/atlases", "assets/animation_clips",
    "assets/animation_graphs",
  ],
  scene_index? : Array[SceneRef] = [],
  prefab_index? : Array[PrefabRef] = [],
  atlas_index? : Array[AssetRef] = [],
  animation_clip_index? : Array[AssetRef] = [],
  animation_graph_index? : Array[AssetRef] = [],
) -> ProjectManifest {
  {
    version: project_schema_version,
    name,
    startup_scene,
    asset_roots,
    scene_index,
    prefab_index,
    atlas_index,
    animation_clip_index,
    animation_graph_index,
  }
}

///|
pub fn ProjectManifest::with_startup_scene(
  self : ProjectManifest,
  startup_scene : String,
) -> ProjectManifest {
  { ..self, startup_scene, }
}

///|
pub fn ProjectManifest::with_indexes(
  self : ProjectManifest,
  scene_index : Array[SceneRef],
  prefab_index : Array[PrefabRef],
  atlas_index : Array[AssetRef],
  animation_clip_index : Array[AssetRef],
  animation_graph_index : Array[AssetRef],
) -> ProjectManifest {
  {
    ..self,
    scene_index,
    prefab_index,
    atlas_index,
    animation_clip_index,
    animation_graph_index,
  }
}

///|
pub fn SceneDocument::empty(name? : String = "Main") -> SceneDocument {
  { version: scene_schema_version, name, entities: [] }
}

///|
pub fn SceneDocument::with_name(
  self : SceneDocument,
  name : String,
) -> SceneDocument {
  { ..self, name, }
}

///|
pub fn PrefabDocument::empty(name : String) -> PrefabDocument {
  { version: prefab_schema_version, name, entities: [] }
}

///|
pub fn prefab_document(
  name : String,
  entities : Array[EntityDocument],
) -> PrefabDocument {
  { version: prefab_schema_version, name, entities }
}

///|
pub fn PrefabDocument::with_name(
  self : PrefabDocument,
  name : String,
) -> PrefabDocument {
  { ..self, name, }
}

///|
pub fn WorkspaceDocument::default() -> WorkspaceDocument {
  {
    version: workspace_schema_version,
    last_scene: None,
    selected_entity_id: None,
    move_snap_enabled: None,
    move_snap_step: None,
    sidebar_scene_ratio: None,
    sidebar_assets_ratio: None,
    asset_scope: None,
  }
}

///|
pub fn WorkspaceDocument::with_last_scene(
  self : WorkspaceDocument,
  path : String?,
) -> WorkspaceDocument {
  { ..self, last_scene: path }
}

///|
pub fn WorkspaceDocument::with_selected_entity_id(
  self : WorkspaceDocument,
  id : String?,
) -> WorkspaceDocument {
  { ..self, selected_entity_id: id }
}

///|
pub fn WorkspaceDocument::with_move_snap_enabled(
  self : WorkspaceDocument,
  enabled : Bool,
) -> WorkspaceDocument {
  { ..self, move_snap_enabled: Some(enabled) }
}

///|
pub fn WorkspaceDocument::with_move_snap_step(
  self : WorkspaceDocument,
  step : Double,
) -> WorkspaceDocument {
  { ..self, move_snap_step: Some(step) }
}

///|
pub fn WorkspaceDocument::move_snap_enabled_or_default(
  self : WorkspaceDocument,
) -> Bool {
  self.move_snap_enabled.unwrap_or(false)
}

///|
pub fn WorkspaceDocument::move_snap_step_or_default(
  self : WorkspaceDocument,
) -> Double {
  match self.move_snap_step {
    Some(step) if step > 0.0 => step
    _ => 16.0
  }
}

///|
pub fn WorkspaceDocument::with_sidebar_scene_ratio(
  self : WorkspaceDocument,
  ratio : Double,
) -> WorkspaceDocument {
  { ..self, sidebar_scene_ratio: Some(ratio) }
}

///|
pub fn WorkspaceDocument::with_sidebar_assets_ratio(
  self : WorkspaceDocument,
  ratio : Double,
) -> WorkspaceDocument {
  { ..self, sidebar_assets_ratio: Some(ratio) }
}

///|
pub fn WorkspaceDocument::sidebar_scene_ratio_or_default(
  self : WorkspaceDocument,
) -> Double {
  match self.sidebar_scene_ratio {
    Some(ratio) if ratio > 0.0 && ratio < 1.0 => ratio
    _ => 0.18
  }
}

///|
pub fn WorkspaceDocument::sidebar_assets_ratio_or_default(
  self : WorkspaceDocument,
) -> Double {
  match self.sidebar_assets_ratio {
    Some(ratio) if ratio > 0.0 && ratio < 1.0 => ratio
    _ => 0.47
  }
}

///|
pub fn WorkspaceDocument::with_asset_scope(
  self : WorkspaceDocument,
  scope : String,
) -> WorkspaceDocument {
  { ..self, asset_scope: Some(scope) }
}

///|
pub fn WorkspaceDocument::asset_scope_or_default(
  self : WorkspaceDocument,
) -> String {
  match self.asset_scope {
    Some(scope) if scope.trim() != "" => scope.trim().to_string()
    _ => "images"
  }
}

///|
pub fn AtlasAssetDocument::with_name(
  self : AtlasAssetDocument,
  name : String,
) -> AtlasAssetDocument {
  { ..self, name, }
}

///|
pub fn AtlasAssetDocument::with_tile_size(
  self : AtlasAssetDocument,
  tile_size : Vec2Doc,
) -> AtlasAssetDocument {
  { ..self, tile_size, }
}

///|
pub fn AtlasAssetDocument::with_columns(
  self : AtlasAssetDocument,
  columns : Int,
) -> AtlasAssetDocument {
  { ..self, columns, }
}

///|
pub fn AtlasAssetDocument::with_rows(
  self : AtlasAssetDocument,
  rows : Int,
) -> AtlasAssetDocument {
  { ..self, rows, }
}

///|
pub fn AtlasAssetDocument::with_spacing(
  self : AtlasAssetDocument,
  spacing : Vec2Doc,
) -> AtlasAssetDocument {
  { ..self, spacing, }
}

///|
pub fn AtlasAssetDocument::with_margin(
  self : AtlasAssetDocument,
  margin : Vec2Doc,
) -> AtlasAssetDocument {
  { ..self, margin, }
}

///|
pub fn AtlasAssetDocument::with_default_anchor(
  self : AtlasAssetDocument,
  default_anchor : Vec2Doc,
) -> AtlasAssetDocument {
  { ..self, default_anchor, }
}

///|
pub fn AtlasAssetDocument::with_regions(
  self : AtlasAssetDocument,
  regions : Array[AtlasRegionDocument],
) -> AtlasAssetDocument {
  { ..self, regions, }
}

///|
pub fn animation_clip_asset_document(
  name : String,
  atlas_asset_path : String,
  fps : Double,
  looping : Bool,
  frames : Array[String],
) -> AnimationClipAssetDocument {
  {
    version: animation_clip_asset_schema_version,
    name,
    atlas_asset_path,
    fps,
    looping,
    frames,
  }
}

///|
pub fn animation_graph_edge_document(
  to : String,
  weight? : Double = 1.0,
) -> AnimationGraphEdgeDocument {
  { to, weight }
}

///|
pub fn animation_graph_node_kind_clip(
  clip_asset_path : String,
) -> AnimationGraphNodeKind {
  Clip(clip_asset_path~)
}

///|
pub fn animation_graph_node_kind_blend() -> AnimationGraphNodeKind {
  Blend
}

///|
pub fn animation_graph_node_kind_additive_blend() -> AnimationGraphNodeKind {
  AdditiveBlend
}

///|
pub fn animation_graph_node_document(
  id : String,
  kind : AnimationGraphNodeKind,
  mask_groups? : Array[Int] = [],
  position? : Vec2Doc = vec2_doc(0.0, 0.0),
  edges? : Array[AnimationGraphEdgeDocument] = [],
) -> AnimationGraphNodeDocument {
  { id, kind, mask_groups, position, edges }
}

///|
pub fn animation_graph_asset_document(
  name : String,
  nodes : Array[AnimationGraphNodeDocument],
  default_node : String?,
) -> AnimationGraphAssetDocument {
  { version: animation_graph_asset_schema_version, name, nodes, default_node }
}

///|
pub fn AnimationClipAssetDocument::with_name(
  self : AnimationClipAssetDocument,
  name : String,
) -> AnimationClipAssetDocument {
  { ..self, name, }
}

///|
pub fn AnimationClipAssetDocument::with_atlas_asset_path(
  self : AnimationClipAssetDocument,
  atlas_asset_path : String,
) -> AnimationClipAssetDocument {
  { ..self, atlas_asset_path, }
}

///|
pub fn AnimationClipAssetDocument::with_fps(
  self : AnimationClipAssetDocument,
  fps : Double,
) -> AnimationClipAssetDocument {
  { ..self, fps, }
}

///|
pub fn AnimationClipAssetDocument::with_looping(
  self : AnimationClipAssetDocument,
  looping : Bool,
) -> AnimationClipAssetDocument {
  { ..self, looping, }
}

///|
pub fn AnimationClipAssetDocument::with_frames(
  self : AnimationClipAssetDocument,
  frames : Array[String],
) -> AnimationClipAssetDocument {
  { ..self, frames, }
}

///|
pub fn AnimationGraphNodeDocument::with_kind(
  self : AnimationGraphNodeDocument,
  kind : AnimationGraphNodeKind,
) -> AnimationGraphNodeDocument {
  { ..self, kind, }
}

///|
pub fn AnimationGraphNodeDocument::with_mask_groups(
  self : AnimationGraphNodeDocument,
  mask_groups : Array[Int],
) -> AnimationGraphNodeDocument {
  { ..self, mask_groups, }
}

///|
pub fn AnimationGraphNodeDocument::with_position(
  self : AnimationGraphNodeDocument,
  position : Vec2Doc,
) -> AnimationGraphNodeDocument {
  { ..self, position, }
}

///|
pub fn AnimationGraphNodeDocument::with_edges(
  self : AnimationGraphNodeDocument,
  edges : Array[AnimationGraphEdgeDocument],
) -> AnimationGraphNodeDocument {
  { ..self, edges, }
}

///|
pub fn AnimationGraphAssetDocument::with_name(
  self : AnimationGraphAssetDocument,
  name : String,
) -> AnimationGraphAssetDocument {
  { ..self, name, }
}

///|
pub fn AnimationGraphAssetDocument::with_default_node(
  self : AnimationGraphAssetDocument,
  default_node : String?,
) -> AnimationGraphAssetDocument {
  { ..self, default_node, }
}

///|
pub fn AnimationGraphAssetDocument::with_nodes(
  self : AnimationGraphAssetDocument,
  nodes : Array[AnimationGraphNodeDocument],
) -> AnimationGraphAssetDocument {
  { ..self, nodes, }
}

///|
pub fn AtlasAssetDocument::default(
  name : String,
  source_image : String,
) -> AtlasAssetDocument {
  {
    version: atlas_asset_schema_version,
    name,
    source_image,
    tile_size: vec2_doc(32.0, 32.0),
    columns: 1,
    rows: 1,
    spacing: vec2_doc(0.0, 0.0),
    margin: vec2_doc(0.0, 0.0),
    default_anchor: vec2_doc(0.5, 0.5),
    regions: [
      { name: "frame_0", index: 0, rect: rect_doc(0.0, 0.0, 32.0, 32.0) },
    ],
  }
}

///|
pub fn atlas_asset_document_from_image(
  name : String,
  source_image : String,
  tile_size : Vec2Doc,
) -> AtlasAssetDocument {
  {
    version: atlas_asset_schema_version,
    name,
    source_image,
    tile_size,
    columns: 1,
    rows: 1,
    spacing: vec2_doc(0.0, 0.0),
    margin: vec2_doc(0.0, 0.0),
    default_anchor: vec2_doc(0.5, 0.5),
    regions: [
      atlas_region_document(
        "frame_0",
        0,
        rect_doc(0.0, 0.0, tile_size.x, tile_size.y),
      ),
    ],
  }
}

///|
pub fn AnimationClipAssetDocument::default(
  name : String,
  atlas_asset_path : String,
) -> AnimationClipAssetDocument {
  {
    version: animation_clip_asset_schema_version,
    name,
    atlas_asset_path,
    fps: 8.0,
    looping: true,
    frames: ["frame_0"],
  }
}

///|
pub fn AnimationGraphAssetDocument::default(
  name : String,
  clip_asset_path : String,
) -> AnimationGraphAssetDocument {
  {
    version: animation_graph_asset_schema_version,
    name,
    nodes: [
      animation_graph_node_document(
        "default",
        Clip(clip_asset_path~),
        position=vec2_doc(160.0, 90.0),
      ),
    ],
    default_node: Some("default"),
  }
}

///|
pub fn animation_graph_asset_document_from_clip(
  name : String,
  clip_asset_path : String,
  node_id? : String = "default",
) -> AnimationGraphAssetDocument {
  AnimationGraphAssetDocument::default(name, clip_asset_path)
  .with_default_node(Some(node_id))
  .with_nodes([
    animation_graph_node_document(
      node_id,
      Clip(clip_asset_path~),
      position=vec2_doc(160.0, 90.0),
    ),
  ])
}

///|
pub fn SceneDocument::default_main() -> SceneDocument {
  let camera = entity_document("camera", "Camera2d", components=[
    name_component("Camera2d"),
    transform2d_component(translation=Vec2Doc::{ x: 0.0, y: 0.0 }),
    camera2d_component(),
    visibility_component(),
  ])
  { version: scene_schema_version, name: "Main", entities: [camera] }
}

///|
pub fn EntityDocument::component(
  self : EntityDocument,
  kind : String,
) -> ComponentDocument? {
  for component in self.components {
    if component.kind == kind {
      return Some(component)
    }
  }
  None
}

///|
pub fn entity_document(
  id : String,
  name : String,
  parent? : String? = None,
  components? : Array[ComponentDocument] = [],
) -> EntityDocument {
  { id, name, parent, components }
}

///|
pub fn component_document(kind : String, data : Json) -> ComponentDocument {
  { kind, data }
}

///|
pub fn EntityDocument::with_component(
  self : EntityDocument,
  component : ComponentDocument,
) -> EntityDocument {
  let components = self.components.filter(fn(existing) {
    existing.kind != component.kind
  })
  components.push(component)
  { ..self, components, }
}

///|
pub fn EntityDocument::without_component(
  self : EntityDocument,
  kind : String,
) -> EntityDocument {
  {
    ..self,
    components: self.components.filter(fn(component) { component.kind != kind }),
  }
}

///|
pub fn EntityDocument::renamed(
  self : EntityDocument,
  name : String,
) -> EntityDocument {
  { ..self, name, }
}

///|
pub fn EntityDocument::reparented(
  self : EntityDocument,
  parent : String?,
) -> EntityDocument {
  { ..self, parent, }
}

///|
pub fn SceneDocument::entity(
  self : SceneDocument,
  id : String,
) -> EntityDocument? {
  for entity in self.entities {
    if entity.id == id {
      return Some(entity)
    }
  }
  None
}

///|
pub fn PrefabDocument::entity(
  self : PrefabDocument,
  id : String,
) -> EntityDocument? {
  for entity in self.entities {
    if entity.id == id {
      return Some(entity)
    }
  }
  None
}

///|
pub fn SceneDocument::with_entity(
  self : SceneDocument,
  entity : EntityDocument,
) -> SceneDocument {
  let entities = self.entities.filter(fn(existing) { existing.id != entity.id })
  entities.push(entity)
  { ..self, entities, }
}

///|
pub fn PrefabDocument::with_entity(
  self : PrefabDocument,
  entity : EntityDocument,
) -> PrefabDocument {
  let entities = self.entities.filter(fn(existing) { existing.id != entity.id })
  entities.push(entity)
  { ..self, entities, }
}

///|
pub fn SceneDocument::without_entity(
  self : SceneDocument,
  id : String,
) -> SceneDocument {
  let entities = self.entities.filter(fn(entity) {
    entity.id != id && entity.parent != Some(id)
  })
  { ..self, entities, }
}

///|
pub fn PrefabDocument::without_entity(
  self : PrefabDocument,
  id : String,
) -> PrefabDocument {
  let entities = self.entities.filter(fn(entity) {
    entity.id != id && entity.parent != Some(id)
  })
  { ..self, entities, }
}

///|
pub fn builtin_component_kinds() -> Array[BuiltinComponentKind] {
  [
    Name,
    Transform2d,
    Visibility,
    Sprite,
    TextureAtlas,
    AutoTileLayer2d,
    Text2d,
    Mesh2d,
    ColorMaterial,
    Camera2d,
    PhysicsBody2d,
    PhysicsCollider2d,
    AnimationPlayer,
    AnimationTransitions,
  ]
}

///|
pub fn builtin_component_kind_to_string(kind : BuiltinComponentKind) -> String {
  match kind {
    Name => "Name"
    Transform2d => "Transform2d"
    Visibility => "Visibility"
    Sprite => "Sprite"
    TextureAtlas => "TextureAtlas"
    AutoTileLayer2d => "AutoTileLayer2d"
    Text2d => "Text2d"
    Mesh2d => "Mesh2d"
    ColorMaterial => "ColorMaterial"
    Camera2d => "Camera2d"
    PhysicsBody2d => "PhysicsBody2d"
    PhysicsCollider2d => "PhysicsCollider2d"
    AnimationPlayer => "AnimationPlayer"
    AnimationTransitions => "AnimationTransitions"
  }
}

///|
pub fn builtin_component_kind_from_string(
  value : String,
) -> BuiltinComponentKind? {
  match value {
    "Name" => Some(Name)
    "Transform2d" => Some(Transform2d)
    "Visibility" => Some(Visibility)
    "Sprite" => Some(Sprite)
    "TextureAtlas" => Some(TextureAtlas)
    "AutoTileLayer2d" => Some(AutoTileLayer2d)
    "Text2d" => Some(Text2d)
    "Mesh2d" => Some(Mesh2d)
    "ColorMaterial" => Some(ColorMaterial)
    "Camera2d" => Some(Camera2d)
    "PhysicsBody2d" => Some(PhysicsBody2d)
    "PhysicsCollider2d" => Some(PhysicsCollider2d)
    "AnimationPlayer" => Some(AnimationPlayer)
    "AnimationTransitions" => Some(AnimationTransitions)
    _ => None
  }
}

///|
pub fn builtin_component_category(kind : BuiltinComponentKind) -> String {
  match kind {
    Name | Transform2d | Visibility => "Common"
    Sprite
    | TextureAtlas
    | AutoTileLayer2d
    | Text2d
    | Mesh2d
    | ColorMaterial
    | Camera2d => "Rendering"
    PhysicsBody2d | PhysicsCollider2d => "Physics2D"
    AnimationPlayer | AnimationTransitions => "Animation"
  }
}

///|
pub fn required_builtin_components(
  kind : BuiltinComponentKind,
) -> Array[BuiltinComponentKind] {
  match kind {
    TextureAtlas => [Sprite]
    AnimationPlayer => [TextureAtlas]
    AnimationTransitions => [AnimationPlayer]
    ColorMaterial => [Mesh2d]
    _ => []
  }
}

///|
pub fn removable_builtin_component(kind : BuiltinComponentKind) -> Bool {
  kind != Transform2d
}

///|
pub fn default_component_document(
  kind : BuiltinComponentKind,
) -> ComponentDocument {
  match kind {
    Name => name_component("Entity")
    Transform2d => transform2d_component()
    Visibility => visibility_component()
    Sprite => sprite_component()
    TextureAtlas =>
      texture_atlas_component(
        layout=Some(TextureAtlasLayoutDoc::{
          tile_size: vec2_doc(16.0, 16.0),
          columns: 1,
          rows: 1,
          padding: vec2_doc(0.0, 0.0),
          offset: vec2_doc(0.0, 0.0),
        }),
      )
    AutoTileLayer2d => autotile_layer2d_component()
    Text2d => text2d_component("Text")
    Mesh2d => mesh2d_component("rectangle", size=Some(vec2_doc(32.0, 32.0)))
    ColorMaterial => color_material_component()
    Camera2d => camera2d_component()
    PhysicsBody2d => physics_body2d_component()
    PhysicsCollider2d => physics_collider2d_component()
    AnimationPlayer => animation_player_component()
    AnimationTransitions => animation_transitions_component()
  }
}

///|
pub fn default_color() -> ColorDoc {
  { r: 255, g: 255, b: 255, a: 255 }
}

///|
pub fn name_component(value : String) -> ComponentDocument {
  { kind: "Name", data: NameComponent::{ value, }.to_json() }
}

///|
pub fn transform2d_component(
  translation? : Vec2Doc = { x: 0.0, y: 0.0 },
  rotation? : Double = 0.0,
  scale? : Vec2Doc = { x: 1.0, y: 1.0 },
) -> ComponentDocument {
  {
    kind: "Transform2d",
    data: Transform2dComponent::{ translation, rotation, scale }.to_json(),
  }
}

///|
pub fn visibility_component(visible? : Bool = true) -> ComponentDocument {
  { kind: "Visibility", data: VisibilityComponent::{ visible, }.to_json() }
}

///|
pub fn sprite_component(
  image_path? : String? = None,
  color? : ColorDoc = default_color(),
  custom_size? : Vec2Doc? = None,
  anchor? : Vec2Doc = { x: 0.5, y: 0.5 },
  flip_x? : Bool = false,
  flip_y? : Bool = false,
  rect? : RectDoc? = None,
  image_mode? : String = "stretch",
) -> ComponentDocument {
  {
    kind: "Sprite",
    data: SpriteComponent::{
      image_path,
      color,
      custom_size,
      anchor,
      flip_x,
      flip_y,
      rect,
      image_mode,
    }.to_json(),
  }
}

///|
pub fn texture_atlas_component(
  atlas_asset_path? : String? = None,
  region_name? : String? = None,
  layout? : TextureAtlasLayoutDoc? = None,
  index? : Int = 0,
) -> ComponentDocument {
  {
    kind: "TextureAtlas",
    data: TextureAtlasComponent::{
      atlas_asset_path,
      region_name,
      layout,
      index,
    }.to_json(),
  }
}

///|
pub fn autotile_rule_set_bitmask4() -> AutoTileRuleSetDocument {
  Bitmask4
}

///|
pub fn autotile_rule_set_bitmask8() -> AutoTileRuleSetDocument {
  Bitmask8
}

///|
pub fn autotile_rule_set_wang() -> AutoTileRuleSetDocument {
  Wang
}

///|
pub fn autotile_mask_rule_document(
  mask : Int,
  region_name : String,
  atlas_index? : Int = 0,
) -> AutoTileMaskRuleDocument {
  { mask, region_name, atlas_index }
}

///|
pub fn autotile_wang_rule_document(
  north : Int,
  east : Int,
  south : Int,
  west : Int,
  region_name : String,
  atlas_index? : Int = 0,
) -> AutoTileWangRuleDocument {
  { north, east, south, west, region_name, atlas_index }
}

///|
pub fn autotile_palette_entry_document(
  terrain : Int,
  fallback_region_name : String,
  fallback_atlas_index? : Int = 0,
  bitmask4_rules? : Array[AutoTileMaskRuleDocument] = [],
  bitmask8_rules? : Array[AutoTileMaskRuleDocument] = [],
  wang_rules? : Array[AutoTileWangRuleDocument] = [],
) -> AutoTilePaletteEntryDocument {
  {
    terrain,
    fallback_region_name,
    fallback_atlas_index,
    bitmask4_rules,
    bitmask8_rules,
    wang_rules,
  }
}

///|
pub fn autotile_cell_document(
  x : Int,
  y : Int,
  terrain : Int,
) -> AutoTileCellDocument {
  { x, y, terrain }
}

///|
pub fn autotile_layer2d_component(
  tile_size? : Vec2Doc = vec2_doc(16.0, 16.0),
  origin? : Vec2Doc = vec2_doc(0.0, 0.0),
  atlas_asset_path? : String = "",
  rule_set? : AutoTileRuleSetDocument = Bitmask8,
  palette? : Array[AutoTilePaletteEntryDocument] = [
    autotile_palette_entry_document(
      1,
      "tile_0",
      bitmask4_rules=[autotile_mask_rule_document(0, "tile_0")],
      bitmask8_rules=[autotile_mask_rule_document(0, "tile_0")],
      wang_rules=[autotile_wang_rule_document(0, 0, 0, 0, "tile_0")],
    ),
  ],
  cells? : Array[AutoTileCellDocument] = [],
) -> ComponentDocument {
  {
    kind: "AutoTileLayer2d",
    data: AutoTileLayer2dComponent::{
      tile_size,
      origin,
      atlas_asset_path,
      rule_set,
      palette,
      cells,
    }.to_json(),
  }
}

///|
pub fn text2d_component(
  content : String,
  font_path? : String? = None,
  font_size? : Double = 16.0,
  color? : ColorDoc = default_color(),
  bounds? : Vec2Doc? = None,
  anchor? : Vec2Doc = { x: 0.5, y: 0.5 },
) -> ComponentDocument {
  {
    kind: "Text2d",
    data: Text2dComponent::{
      content,
      font_path,
      font_size,
      color,
      bounds,
      anchor,
    }.to_json(),
  }
}

///|
pub fn mesh2d_component(
  primitive : String,
  size? : Vec2Doc? = None,
  radius? : Double? = None,
) -> ComponentDocument {
  {
    kind: "Mesh2d",
    data: Mesh2dComponent::{ primitive, size, radius }.to_json(),
  }
}

///|
pub fn color_material_component(
  color? : ColorDoc = default_color(),
) -> ComponentDocument {
  { kind: "ColorMaterial", data: ColorMaterialComponent::{ color, }.to_json() }
}

///|
pub fn camera2d_component(
  is_active? : Bool = true,
  order? : Int = 0,
  scale? : Double = 1.0,
  viewport? : RectDoc? = None,
) -> ComponentDocument {
  {
    kind: "Camera2d",
    data: Camera2dComponent::{ is_active, order, scale, viewport }.to_json(),
  }
}

///|
pub fn physics_body2d_component(
  body_type? : String = "dynamic",
  linear_velocity? : Vec2Doc = { x: 0.0, y: 0.0 },
  angular_velocity? : Double = 0.0,
  gravity_scale? : Double = 1.0,
  linear_damping? : Double = 0.0,
  angular_damping? : Double = 0.0,
  lock_rotation? : Bool = false,
  ccd_enabled? : Bool = false,
) -> ComponentDocument {
  {
    kind: "PhysicsBody2d",
    data: PhysicsBody2dComponent::{
      body_type,
      linear_velocity,
      angular_velocity,
      gravity_scale,
      linear_damping,
      angular_damping,
      lock_rotation,
      ccd_enabled,
    }.to_json(),
  }
}

///|
pub fn physics_collider2d_component(
  shape? : String = "rectangle",
  size? : Vec2Doc? = None,
  radius? : Double? = None,
  sensor? : Bool = false,
  friction? : Double = 0.7,
  restitution? : Double = 0.0,
) -> ComponentDocument {
  {
    kind: "PhysicsCollider2d",
    data: PhysicsCollider2dComponent::{
      shape,
      size,
      radius,
      sensor,
      friction,
      restitution,
    }.to_json(),
  }
}

///|
pub fn animation_repeat_mode_never() -> AnimationRepeatModeDoc {
  Never
}

///|
pub fn animation_repeat_mode_forever() -> AnimationRepeatModeDoc {
  Forever
}

///|
pub fn animation_repeat_mode_count(count : Int) -> AnimationRepeatModeDoc {
  if count <= 0 {
    Count(1)
  } else {
    Count(count)
  }
}

///|
pub fn animation_repeat_mode_doc_from_string(
  repeat_mode : String,
) -> AnimationRepeatModeDoc {
  let normalized = repeat_mode.trim().to_lower()
  if normalized == "" ||
    normalized == "forever" ||
    normalized == "loop" ||
    normalized == "infinite" {
    return Forever
  }
  if normalized == "never" || normalized == "once" {
    return Never
  }
  if normalized == "count" {
    return Count(1)
  }
  if normalized.has_prefix("count:") {
    let count = @string.parse_int(normalized[6:]) catch { _ => 0 }
    if count > 0 {
      return Count(count)
    }
    return Forever
  }
  if normalized.has_prefix("count(") && normalized.has_suffix(")") {
    let count = @string.parse_int(normalized[6:normalized.length() - 1]) catch {
      _ => 0
    }
    if count > 0 {
      return Count(count)
    }
    return Forever
  }
  Forever
}

///|
pub fn animation_repeat_mode_doc_to_string(
  repeat_mode : AnimationRepeatModeDoc,
) -> String {
  match repeat_mode {
    Never => "never"
    Forever => "forever"
    Count(count) => "count:\{count}"
  }
}

///|
pub fn animation_player_component(
  graph_asset_path? : String? = None,
  start_node? : String? = None,
  autoplay? : Bool = false,
  repeat_mode? : AnimationRepeatModeDoc = animation_repeat_mode_forever(),
  speed? : Double = 1.0,
) -> ComponentDocument {
  {
    kind: "AnimationPlayer",
    data: AnimationPlayerComponent::{
      graph_asset_path,
      start_node,
      autoplay,
      repeat_mode: animation_repeat_mode_doc_to_string(repeat_mode),
      speed,
    }.to_json(),
  }
}

///|
pub fn animation_transitions_component(
  duration? : Double = 0.1,
) -> ComponentDocument {
  {
    kind: "AnimationTransitions",
    data: AnimationTransitionsComponent::{ duration, }.to_json(),
  }
}

///|
pub fn atlas_region_document(
  name : String,
  index : Int,
  rect : RectDoc,
) -> AtlasRegionDocument {
  { name, index, rect }
}

///|
pub fn asset_document(
  path : String,
  kind : AssetKind,
  meta_path? : String? = None,
) -> AssetDocument {
  { path, kind, meta_path }
}
