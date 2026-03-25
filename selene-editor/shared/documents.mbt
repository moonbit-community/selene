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
pub struct ProjectManifest {
  version : Int
  name : String
  startup_scene : String
  asset_roots : Array[String]
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct SceneDocument {
  version : Int
  entities : Array[EntityDocument]
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
  layout : TextureAtlasLayoutDoc
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
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct PhysicsCollider2dComponent {
  shape : String
  size : Vec2Doc?
  radius : Double?
  sensor : Bool
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct TiledMapRefComponent {
  path : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub struct LdtkWorldRefComponent {
  path : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub enum AssetKind {
  Directory
  Image
  Audio
  Font
  TiledMap
  LdtkWorld
  Scene
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
pub fn project_manifest_file_name(name : String) -> String {
  normalized_document_stem(name) + ".project.json"
}

///|
pub fn startup_scene_path_for_name(name : String) -> String {
  "scenes/" + normalized_document_stem(name) + ".scene.json"
}

///|
pub fn infer_asset_kind(path : String) -> AssetKind {
  if path.has_suffix(".meta.json") {
    return Meta
  }
  if path.has_suffix(".scene.json") {
    return Scene
  }
  match asset_kind_extension(path) {
    Some("png") | Some("jpg") | Some("jpeg") | Some("webp") => Image
    Some("wav") | Some("ogg") | Some("mp3") => Audio
    Some("ttf") | Some("otf") => Font
    Some("tmx") | Some("tsx") => TiledMap
    Some("ldtk") => LdtkWorld
    Some("json") => Json
    _ => Unknown
  }
}

///|
pub fn ProjectManifest::default(
  name : String,
  startup_scene? : String = startup_scene_path_for_name(name),
  asset_roots? : Array[String] = ["assets"],
) -> ProjectManifest {
  { version: project_schema_version, name, startup_scene, asset_roots }
}

///|
pub fn SceneDocument::empty() -> SceneDocument {
  { version: scene_schema_version, entities: [] }
}

///|
pub fn SceneDocument::default_main() -> SceneDocument {
  let camera = EntityDocument::{
    id: "camera",
    name: "Camera2d",
    parent: None,
    components: [
      transform2d_component(translation=Vec2Doc::{ x: 0.0, y: 0.0 }),
      camera2d_component(),
      visibility_component(),
    ],
  }
  { version: scene_schema_version, entities: [camera] }
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
pub fn SceneDocument::with_entity(
  self : SceneDocument,
  entity : EntityDocument,
) -> SceneDocument {
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
pub fn default_color() -> ColorDoc {
  { r: 255, g: 255, b: 255, a: 255 }
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
  layout : TextureAtlasLayoutDoc,
  index? : Int = 0,
) -> ComponentDocument {
  {
    kind: "TextureAtlas",
    data: TextureAtlasComponent::{ layout, index }.to_json(),
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
) -> ComponentDocument {
  {
    kind: "PhysicsBody2d",
    data: PhysicsBody2dComponent::{
      body_type,
      linear_velocity,
      angular_velocity,
    }.to_json(),
  }
}

///|
pub fn physics_collider2d_component(
  shape? : String = "rectangle",
  size? : Vec2Doc? = None,
  radius? : Double? = None,
  sensor? : Bool = false,
) -> ComponentDocument {
  {
    kind: "PhysicsCollider2d",
    data: PhysicsCollider2dComponent::{ shape, size, radius, sensor }.to_json(),
  }
}

///|
pub fn tiled_map_ref_component(path : String) -> ComponentDocument {
  { kind: "TiledMapRef", data: TiledMapRefComponent::{ path, }.to_json() }
}

///|
pub fn ldtk_world_ref_component(path : String) -> ComponentDocument {
  { kind: "LdtkWorldRef", data: LdtkWorldRefComponent::{ path, }.to_json() }
}

///|
pub fn asset_document(
  path : String,
  kind : AssetKind,
  meta_path? : String? = None,
) -> AssetDocument {
  { path, kind, meta_path }
}
