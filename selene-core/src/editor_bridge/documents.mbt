///|
pub struct Vec2Doc {
  x : Double
  y : Double
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct RectDoc {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct ColorDoc {
  r : Int
  g : Int
  b : Int
  a : Int
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AssetRef {
  path : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneRef {
  path : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct PrefabRef {
  path : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct ProjectManifest {
  version : Int
  name : String
  startup_scene : String
  asset_roots : Array[String]
  scene_index : Array[SceneRef]
  prefab_index : Array[PrefabRef]
  atlas_index : Array[AssetRef]
  animation_index : Array[AssetRef]
  editor_min_version : String?
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneDocument {
  version : Int
  name : String
  entities : Array[EntityDocument]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct PrefabDocument {
  version : Int
  name : String
  entities : Array[EntityDocument]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct WorkspaceDocument {
  version : Int
  last_scene : String?
  selected_entity_id : String?
  move_snap_enabled : Bool?
  move_snap_step : Double?
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct EntityDocument {
  id : String
  name : String
  parent : String?
  components : Array[ComponentDocument]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct ComponentDocument {
  kind : String
  data : Json
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct NameComponent {
  value : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct Transform2dComponent {
  translation : Vec2Doc
  rotation : Double
  scale : Vec2Doc
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct VisibilityComponent {
  visible : Bool
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct TextureAtlasLayoutDoc {
  tile_size : Vec2Doc
  columns : Int
  rows : Int
  padding : Vec2Doc
  offset : Vec2Doc
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct TextureAtlasComponent {
  atlas_asset_path : String?
  region_name : String?
  layout : TextureAtlasLayoutDoc?
  index : Int
} derive(Show, Eq, ToJson, FromJson)

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
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct Text2dComponent {
  content : String
  font_path : String?
  font_size : Double
  color : ColorDoc
  bounds : Vec2Doc?
  anchor : Vec2Doc
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct Mesh2dComponent {
  primitive : String
  size : Vec2Doc?
  radius : Double?
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct ColorMaterialComponent {
  color : ColorDoc
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct Camera2dComponent {
  is_active : Bool
  order : Int
  scale : Double
} derive(Show, Eq, ToJson, FromJson)

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
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct PhysicsCollider2dComponent {
  shape : String
  size : Vec2Doc?
  radius : Double?
  sensor : Bool
  friction : Double
  restitution : Double
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AnimationPlayerComponent {
  animation_asset_path : String?
  default_clip : String?
  autoplay : Bool
  repeat_mode : String
  speed : Double
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AnimationTransitionsComponent {
  duration : Double
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AtlasRegionDocument {
  name : String
  index : Int
  rect : RectDoc
} derive(Show, Eq, ToJson, FromJson)

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
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AnimationClipDocument {
  name : String
  fps : Double
  looping : Bool
  frames : Array[String]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AnimationAssetDocument {
  version : Int
  name : String
  atlas_asset_path : String
  clips : Array[AnimationClipDocument]
  default_clip : String?
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum AssetKind {
  Directory
  Image
  Audio
  Font
  Atlas
  Animation
  Scene
  Prefab
  Project
  Meta
  Json
  Unknown
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AssetMetaDocument {
  tags : Array[String]
  importer : String?
  source : String?
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct AssetDocument {
  path : String
  kind : AssetKind
  meta_path : String?
} derive(Show, Eq, ToJson, FromJson)

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
pub fn animation_asset_file_name(name : String) -> String {
  normalized_document_stem(name) + ".anim.json"
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
  if path.has_suffix(".anim.json") {
    return Animation
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
    "assets/images", "assets/audio", "assets/fonts", "assets/atlases", "assets/animations",
  ],
  scene_index? : Array[SceneRef] = [],
  prefab_index? : Array[PrefabRef] = [],
  atlas_index? : Array[AssetRef] = [],
  animation_index? : Array[AssetRef] = [],
  editor_min_version? : String? = None,
) -> ProjectManifest {
  {
    version: project_schema_version,
    name,
    startup_scene,
    asset_roots,
    scene_index,
    prefab_index,
    atlas_index,
    animation_index,
    editor_min_version,
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
  animation_index : Array[AssetRef],
) -> ProjectManifest {
  { ..self, scene_index, prefab_index, atlas_index, animation_index }
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
pub fn animation_asset_document(
  name : String,
  atlas_asset_path : String,
  clips : Array[AnimationClipDocument],
  default_clip : String?,
) -> AnimationAssetDocument {
  {
    version: animation_asset_schema_version,
    name,
    atlas_asset_path,
    clips,
    default_clip,
  }
}

///|
pub fn AnimationClipDocument::with_name(
  self : AnimationClipDocument,
  name : String,
) -> AnimationClipDocument {
  { ..self, name, }
}

///|
pub fn AnimationClipDocument::with_fps(
  self : AnimationClipDocument,
  fps : Double,
) -> AnimationClipDocument {
  { ..self, fps, }
}

///|
pub fn AnimationClipDocument::with_looping(
  self : AnimationClipDocument,
  looping : Bool,
) -> AnimationClipDocument {
  { ..self, looping, }
}

///|
pub fn AnimationClipDocument::with_frames(
  self : AnimationClipDocument,
  frames : Array[String],
) -> AnimationClipDocument {
  { ..self, frames, }
}

///|
pub fn AnimationAssetDocument::with_name(
  self : AnimationAssetDocument,
  name : String,
) -> AnimationAssetDocument {
  { ..self, name, }
}

///|
pub fn AnimationAssetDocument::with_default_clip(
  self : AnimationAssetDocument,
  default_clip : String?,
) -> AnimationAssetDocument {
  { ..self, default_clip, }
}

///|
pub fn AnimationAssetDocument::with_clips(
  self : AnimationAssetDocument,
  clips : Array[AnimationClipDocument],
) -> AnimationAssetDocument {
  { ..self, clips, }
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
pub fn AnimationAssetDocument::default(
  name : String,
  atlas_asset_path : String,
) -> AnimationAssetDocument {
  {
    version: animation_asset_schema_version,
    name,
    atlas_asset_path,
    clips: [{ name: "default", fps: 8.0, looping: true, frames: ["frame_0"] }],
    default_clip: Some("default"),
  }
}

///|
pub fn animation_clip_document(
  name : String,
  fps : Double,
  looping : Bool,
  frames : Array[String],
) -> AnimationClipDocument {
  { name, fps, looping, frames }
}

///|
pub fn animation_asset_document_from_frames(
  name : String,
  atlas_asset_path : String,
  frames : Array[String],
  default_clip? : String = "default",
) -> AnimationAssetDocument {
  {
    version: animation_asset_schema_version,
    name,
    atlas_asset_path,
    clips: [animation_clip_document(default_clip, 8.0, true, frames)],
    default_clip: Some(default_clip),
  }
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
) -> ComponentDocument {
  {
    kind: "Camera2d",
    data: Camera2dComponent::{ is_active, order, scale }.to_json(),
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
pub fn animation_player_component(
  animation_asset_path? : String? = None,
  default_clip? : String? = None,
  autoplay? : Bool = false,
  repeat_mode? : String = "forever",
  speed? : Double = 1.0,
) -> ComponentDocument {
  {
    kind: "AnimationPlayer",
    data: AnimationPlayerComponent::{
      animation_asset_path,
      default_clip,
      autoplay,
      repeat_mode,
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
