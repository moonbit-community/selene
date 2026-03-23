///|
pub(all) struct BackgroundColor {
  color : @render.Color

  fn new(color : @render.Color) -> BackgroundColor
}

///|
pub fn BackgroundColor::new(color : @render.Color) -> BackgroundColor {
  { color, }
}

///|
pub fn BackgroundColor::from_css(color : String) -> BackgroundColor {
  BackgroundColor::new(parse_color(color))
}

///|
pub(all) struct BorderColor {
  color : @render.Color

  fn new(color : @render.Color) -> BorderColor
}

///|
pub fn BorderColor::new(color : @render.Color) -> BorderColor {
  { color, }
}

///|
pub fn BorderColor::from_css(color : String) -> BorderColor {
  BorderColor::new(parse_color(color))
}

///|
pub(all) struct BorderRadius {
  top_left : Val
  top_right : Val
  bottom_right : Val
  bottom_left : Val

  fn new(
    top_left? : Val,
    top_right? : Val,
    bottom_right? : Val,
    bottom_left? : Val,
  ) -> BorderRadius
} derive(Eq, Show)

///|
pub fn BorderRadius::all(value : Val) -> BorderRadius {
  { top_left: value, top_right: value, bottom_right: value, bottom_left: value }
}

///|
pub fn BorderRadius::new(
  top_left? : Val = Val::px(0.0),
  top_right? : Val = top_left,
  bottom_right? : Val = top_left,
  bottom_left? : Val = bottom_right,
) -> BorderRadius {
  { top_left, top_right, bottom_right, bottom_left }
}

///|
pub(all) struct Outline {
  width : Val
  offset : Val
  color : @render.Color

  fn new(width : Val, color : @render.Color, offset? : Val) -> Outline
}

///|
pub fn Outline::new(
  width : Val,
  color : @render.Color,
  offset? : Val = Val::px(0.0),
) -> Outline {
  { width, offset, color }
}

///|
pub(all) struct ShadowStyle {
  color : @render.Color
  x_offset : Val
  y_offset : Val
  spread_radius : Val
  blur_radius : Val

  fn new(
    color : @render.Color,
    x_offset? : Val,
    y_offset? : Val,
    spread_radius? : Val,
    blur_radius? : Val,
  ) -> ShadowStyle
} derive(Eq, Show)

///|
pub fn ShadowStyle::new(
  color : @render.Color,
  x_offset? : Val = Val::px(0.0),
  y_offset? : Val = Val::px(0.0),
  spread_radius? : Val = Val::px(0.0),
  blur_radius? : Val = Val::px(0.0),
) -> ShadowStyle {
  { color, x_offset, y_offset, spread_radius, blur_radius }
}

///|
pub(all) struct BoxShadow {
  layers : Array[ShadowStyle]

  fn new(layers : Array[ShadowStyle]) -> BoxShadow
} derive(Eq, Show)

///|
pub fn BoxShadow::new(layers : Array[ShadowStyle]) -> BoxShadow {
  { layers, }
}

///|
pub fn BoxShadow::single(
  color : @render.Color,
  x_offset? : Val = Val::px(0.0),
  y_offset? : Val = Val::px(0.0),
  spread_radius? : Val = Val::px(0.0),
  blur_radius? : Val = Val::px(0.0),
) -> BoxShadow {
  BoxShadow::new([
    ShadowStyle::new(color, x_offset~, y_offset~, spread_radius~, blur_radius~),
  ])
}

///|
pub(all) enum ImageFit {
  Stretch
  Contain
  Cover
  None
} derive(Eq, Show)

///|
pub(all) struct UiImage {
  size : @math.Vec2D
  image : @asset.ImageHandle
  tint : @render.Color
  fit : ImageFit

  fn new(
    size : @math.Vec2D,
    path : String,
    tint? : @render.Color,
    fit? : ImageFit,
  ) -> UiImage
} derive(Eq, Show)

///|
pub fn UiImage::from_image(
  size : @math.Vec2D,
  image : @asset.ImageHandle,
  tint? : @render.Color = rgba(255, 255, 255, 1.0),
  fit? : ImageFit = Stretch,
) -> UiImage {
  { size, image, tint, fit }
}

///|
pub fn UiImage::new(
  size : @math.Vec2D,
  path : String,
  tint? : @render.Color = rgba(255, 255, 255, 1.0),
  fit? : ImageFit = Stretch,
) -> UiImage {
  UiImage::from_image(size, @asset.load_image(path), tint~, fit~)
}

///|
pub(all) struct UiMaterialHandle(UInt) derive(Eq, Show, Hash)

///|
pub(all) struct MaterialNode {
  material : UiMaterialHandle

  fn new(material : UiMaterialHandle) -> MaterialNode
} derive(Eq, Show)

///|
pub fn MaterialNode::new(material : UiMaterialHandle) -> MaterialNode {
  { material, }
}

///|
pub(all) struct UiGradient {
  color_start : @render.Color
  color_end : @render.Color

  fn new(color_start : @render.Color, color_end : @render.Color) -> UiGradient
} derive(Eq, Show)

///|
pub fn UiGradient::new(
  color_start : @render.Color,
  color_end : @render.Color,
) -> UiGradient {
  { color_start, color_end }
}

///|
pub(all) struct UiMaterialContext {
  entity : @entity.Entity
  rect : @math.Rect
  content_rect : @math.Rect
  border_radius : BorderRadius

  fn new(
    entity : @entity.Entity,
    rect : @math.Rect,
    content_rect? : @math.Rect,
    border_radius? : BorderRadius,
  ) -> UiMaterialContext
}

///|
pub fn UiMaterialContext::new(
  entity : @entity.Entity,
  rect : @math.Rect,
  content_rect? : @math.Rect = rect,
  border_radius? : BorderRadius = BorderRadius::all(Val::px(0.0)),
) -> UiMaterialContext {
  { entity, rect, content_rect, border_radius }
}

///|
pub(all) struct UiMaterialAsset {
  draw : (UiMaterialContext) -> Unit

  fn new(
    size : @math.Vec2D,
    path : String,
    tint? : @render.Color,
    fit? : ImageFit,
  ) -> UiMaterialAsset
}

///|
pub fn UiMaterialAsset::from_draw(
  draw : (UiMaterialContext) -> Unit,
) -> UiMaterialAsset {
  { draw, }
}

///|
pub fn UiMaterialAsset::solid(color : @render.Color) -> UiMaterialAsset {
  UiMaterialAsset::from_draw(fn(context) {
    draw_ui_material_solid(context, color)
  })
}

///|
pub fn UiMaterialAsset::gradient(
  color_start : @render.Color,
  color_end : @render.Color,
) -> UiMaterialAsset {
  let gradient = UiGradient::new(color_start, color_end)
  UiMaterialAsset::from_draw(fn(context) {
    draw_ui_material_gradient(context, gradient)
  })
}

///|
pub fn UiMaterialAsset::from_ui_image(image : UiImage) -> UiMaterialAsset {
  UiMaterialAsset::from_draw(fn(context) {
    draw_ui_material_image(context, image)
  })
}

///|
pub fn UiMaterialAsset::from_image(
  size : @math.Vec2D,
  image : @asset.ImageHandle,
  tint? : @render.Color = rgba(255, 255, 255, 1.0),
  fit? : ImageFit = Stretch,
) -> UiMaterialAsset {
  UiMaterialAsset::from_ui_image(UiImage::from_image(size, image, tint~, fit~))
}

///|
pub fn UiMaterialAsset::new(
  size : @math.Vec2D,
  path : String,
  tint? : @render.Color = rgba(255, 255, 255, 1.0),
  fit? : ImageFit = Stretch,
) -> UiMaterialAsset {
  UiMaterialAsset::from_ui_image(UiImage::new(size, path, tint~, fit~))
}

///|
pub(all) struct Text {
  mut content : String

  fn new(content : String) -> Text
}

///|
pub fn Text::new(content : String) -> Text {
  { content, }
}

///|
pub(all) struct TextFont {
  mut family : String
  mut size : Double
  mut font_handle : @asset.FontHandle?

  fn new(family? : String, size? : Double) -> TextFont
}

///|
pub fn TextFont::new(
  family? : String = "Arial",
  size? : Double = 16.0,
) -> TextFont {
  { family, size, font_handle: @asset.font_by_family(family) }
}

///|
pub fn TextFont::from_font(
  font : @asset.FontHandle,
  size? : Double = 16.0,
) -> TextFont {
  let family = @asset.font_family(font).unwrap_or("Arial")
  { family, size, font_handle: Some(font) }
}

///|
fn parse_font_size(size : StringView) -> Double {
  try @strconv.parse_double(size.trim()) catch {
    _ => 16.0
  } noraise {
    value => value
  }
}

///|
fn parse_font_family(family : StringView) -> String {
  let family = family.trim().to_string()
  if family == "" {
    "Arial"
  } else {
    family
  }
}

///|
pub fn TextFont::from_css(font : String) -> TextFont {
  let font = font.trim().to_string()
  if font == "" {
    return TextFont::new()
  }
  let parts : Array[StringView] = []
  for part in font.split("px") {
    parts.push(part)
  }
  if parts.length() >= 2 {
    TextFont::new(
      family=parse_font_family(parts[1]),
      size=parse_font_size(parts[0]),
    )
  } else {
    TextFont::new(family=font)
  }
}

///|
pub(all) struct TextColor {
  mut color : @render.Color

  fn new(color : @render.Color) -> TextColor
}

///|
pub fn TextColor::new(color : @render.Color) -> TextColor {
  { color, }
}

///|
pub fn TextColor::from_css(color : String) -> TextColor {
  TextColor::new(parse_color(color))
}

///|
pub(all) enum TextWrap {
  NoWrap
  WordWrap
} derive(Eq, Show)

///|
pub(all) enum TextOverflow {
  Clip
  Ellipsis
} derive(Eq, Show)

///|
pub(all) struct TextLayout {
  mut align : @math.HAlign
  mut baseline : @math.VAlign
  mut line_height : Double
  mut wrap : TextWrap
  mut overflow : TextOverflow

  fn new(
    align? : @math.HAlign,
    baseline? : @math.VAlign,
    line_height? : Double,
    wrap? : TextWrap,
    overflow? : TextOverflow,
  ) -> TextLayout
}

///|
pub fn TextLayout::new(
  align? : @math.HAlign = Left,
  baseline? : @math.VAlign = Top,
  line_height? : Double = 1.0,
  wrap? : TextWrap = NoWrap,
  overflow? : TextOverflow = Clip,
) -> TextLayout {
  { align, baseline, line_height, wrap, overflow }
}

///|
pub(all) struct Button {
  enabled : Bool

  fn new(enabled? : Bool) -> Button
} derive(Eq, Show)

///|
pub fn Button::new(enabled? : Bool = true) -> Button {
  { enabled, }
}

///|
pub(all) enum Interaction {
  None
  Hovered
  Pressed
} derive(Eq, Show)

///|
priv struct UiVisualWorldStore {
  background_colors : Map[@entity.Entity, BackgroundColor]
  border_colors : Map[@entity.Entity, BorderColor]
  border_radii : Map[@entity.Entity, BorderRadius]
  box_shadows : Map[@entity.Entity, BoxShadow]
  outlines : Map[@entity.Entity, Outline]
  ui_images : Map[@entity.Entity, UiImage]
  material_nodes : Map[@entity.Entity, MaterialNode]
  texts : Map[@entity.Entity, Text]
  text_fonts : Map[@entity.Entity, TextFont]
  text_colors : Map[@entity.Entity, TextColor]
  text_layouts : Map[@entity.Entity, TextLayout]
  buttons : Map[@entity.Entity, Button]
  interactions : Map[@entity.Entity, Interaction]
}

///|
let ui_visual_world_stores : Map[UInt, UiVisualWorldStore] = Map::new()

///|
fn ui_visual_world_store() -> UiVisualWorldStore {
  let world_id = @ecs.require_current_world().id()
  ui_visual_world_stores.get_or_init(world_id, () => {
    background_colors: Map::new(),
    border_colors: Map::new(),
    border_radii: Map::new(),
    box_shadows: Map::new(),
    outlines: Map::new(),
    ui_images: Map::new(),
    material_nodes: Map::new(),
    texts: Map::new(),
    text_fonts: Map::new(),
    text_colors: Map::new(),
    text_layouts: Map::new(),
    buttons: Map::new(),
    interactions: Map::new(),
  })
}

///|
pub fn background_colors() -> Map[@entity.Entity, BackgroundColor] {
  ui_visual_world_store().background_colors
}

///|
pub fn border_colors() -> Map[@entity.Entity, BorderColor] {
  ui_visual_world_store().border_colors
}

///|
pub fn border_radii() -> Map[@entity.Entity, BorderRadius] {
  ui_visual_world_store().border_radii
}

///|
pub fn box_shadows() -> Map[@entity.Entity, BoxShadow] {
  ui_visual_world_store().box_shadows
}

///|
pub fn outlines() -> Map[@entity.Entity, Outline] {
  ui_visual_world_store().outlines
}

///|
pub fn ui_images() -> Map[@entity.Entity, UiImage] {
  ui_visual_world_store().ui_images
}

///|
pub fn material_nodes() -> Map[@entity.Entity, MaterialNode] {
  ui_visual_world_store().material_nodes
}

///|
let ui_material_assets : Map[UiMaterialHandle, UiMaterialAsset] = Map::new()

///|
let next_ui_material_id : Ref[UInt] = Ref::new(0)

///|
pub fn texts() -> Map[@entity.Entity, Text] {
  ui_visual_world_store().texts
}

///|
pub fn text_fonts() -> Map[@entity.Entity, TextFont] {
  ui_visual_world_store().text_fonts
}

///|
pub fn text_colors() -> Map[@entity.Entity, TextColor] {
  ui_visual_world_store().text_colors
}

///|
pub fn text_layouts() -> Map[@entity.Entity, TextLayout] {
  ui_visual_world_store().text_layouts
}

///|
pub fn buttons() -> Map[@entity.Entity, Button] {
  ui_visual_world_store().buttons
}

///|
pub fn interactions() -> Map[@entity.Entity, Interaction] {
  ui_visual_world_store().interactions
}

///|
pub fn register_ui_material_asset(
  material : UiMaterialAsset,
) -> UiMaterialHandle {
  let handle = UiMaterialHandle(next_ui_material_id.val)
  next_ui_material_id.val += 1
  ui_material_assets.set(handle, material)
  handle
}

///|
pub fn ui_material_asset(handle : UiMaterialHandle) -> UiMaterialAsset? {
  ui_material_assets.get(handle)
}

///|
pub fn update_ui_material_asset(
  handle : UiMaterialHandle,
  material : UiMaterialAsset,
) -> Unit {
  ui_material_assets.set(handle, material)
}

///|
pub fn release_ui_material_asset(handle : UiMaterialHandle) -> Unit {
  ui_material_assets.remove(handle)
}

///|
fn default_text_font() -> TextFont {
  TextFont::new()
}

///|
fn default_text_color() -> TextColor {
  TextColor::from_css("white")
}

///|
fn default_text_layout() -> TextLayout {
  TextLayout::new()
}

///|
fn text_font(entity : @entity.Entity) -> TextFont {
  text_fonts().get(entity).unwrap_or(default_text_font())
}

///|
fn text_color(entity : @entity.Entity) -> TextColor {
  text_colors().get(entity).unwrap_or(default_text_color())
}

///|
fn text_layout(entity : @entity.Entity) -> TextLayout {
  text_layouts().get(entity).unwrap_or(default_text_layout())
}

///|
pub fn text_style_for(entity : @entity.Entity) -> @render2d_types.TextStyle2D? {
  guard texts().get(entity) is Some(_) else { return None }
  let font = text_font(entity)
  let color = text_color(entity)
  let layout = text_layout(entity)
  Some({
    font: font.font_handle,
    family: font.family,
    size: font.size,
    color: color.color,
    align: layout.align,
    baseline: layout.baseline,
  })
}
