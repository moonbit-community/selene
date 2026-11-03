///|
pub(all) struct BackgroundColor {
  color : @render.Color
}

///|
pub fn BackgroundColor::BackgroundColor(
  color : @render.Color,
) -> BackgroundColor {
  { color, }
}

///|
pub fn BackgroundColor::from_css(color : String) -> BackgroundColor {
  BackgroundColor(parse_color(color))
}

///|
pub(all) struct BorderColor {
  color : @render.Color
}

///|
pub fn BorderColor::BorderColor(color : @render.Color) -> BorderColor {
  { color, }
}

///|
pub fn BorderColor::from_css(color : String) -> BorderColor {
  BorderColor(parse_color(color))
}

///|
pub(all) struct BorderRadius {
  top_left : Val
  top_right : Val
  bottom_right : Val
  bottom_left : Val
} derive(Eq, Debug)

///|
pub fn BorderRadius::all(value : Val) -> BorderRadius {
  {
    top_left: value,
    top_right: value,
    bottom_right: value,
    bottom_left: value,
  }
}

///|
pub fn BorderRadius::BorderRadius(
  top_left~ : Val = Val::px(0.0),
  top_right~ : Val = top_left,
  bottom_right~ : Val = top_left,
  bottom_left~ : Val = bottom_right,
) -> BorderRadius {
  { top_left, top_right, bottom_right, bottom_left, }
}

///|
pub(all) struct Outline {
  width : Val
  offset : Val
  color : @render.Color
}

///|
pub fn Outline::Outline(
  width : Val,
  color : @render.Color,
  offset~ : Val = Val::px(0.0),
) -> Outline {
  { width, offset, color, }
}

///|
pub(all) struct ShadowStyle {
  color : @render.Color
  x_offset : Val
  y_offset : Val
  spread_radius : Val
  blur_radius : Val
} derive(Eq, Debug)

///|
pub fn ShadowStyle::ShadowStyle(
  color : @render.Color,
  x_offset~ : Val = Val::px(0.0),
  y_offset~ : Val = Val::px(0.0),
  spread_radius~ : Val = Val::px(0.0),
  blur_radius~ : Val = Val::px(0.0),
) -> ShadowStyle {
  { color, x_offset, y_offset, spread_radius, blur_radius, }
}

///|
pub(all) struct BoxShadow {
  layers : Array[ShadowStyle]
} derive(Eq, Debug)

///|
pub fn BoxShadow::BoxShadow(layers : Array[ShadowStyle]) -> BoxShadow {
  { layers, }
}

///|
pub fn BoxShadow::single(
  color : @render.Color,
  x_offset~ : Val = Val::px(0.0),
  y_offset~ : Val = Val::px(0.0),
  spread_radius~ : Val = Val::px(0.0),
  blur_radius~ : Val = Val::px(0.0),
) -> BoxShadow {
  BoxShadow([
    ShadowStyle(color, x_offset~, y_offset~, spread_radius~, blur_radius~),
  ])
}

///|
pub(all) enum ImageFit {
  Stretch
  Contain
  Cover
  None
} derive(Eq, Debug)

///|
pub(all) struct UiImage {
  size : @math.Vec2
  image : @asset.ImageHandle
  tint : @render.Color
  fit : ImageFit
} derive(Eq, Debug)

///|
pub fn UiImage::from_image(
  size : @math.Vec2,
  image : @asset.ImageHandle,
  tint~ : @render.Color = rgba(255, 255, 255, 1.0),
  fit~ : ImageFit = Stretch,
) -> UiImage {
  { size, image, tint, fit, }
}

///|
pub fn UiImage::UiImage(
  size : @math.Vec2,
  path : String,
  tint~ : @render.Color = rgba(255, 255, 255, 1.0),
  fit~ : ImageFit = Stretch,
) -> UiImage {
  UiImage::from_image(size, @asset.load_image(path), tint~, fit~)
}

///|
pub(all) struct UiMaterialHandle(UInt32) derive(Eq, Debug, Hash)

///|
pub(all) struct MaterialNode {
  material : UiMaterialHandle
} derive(Eq, Debug)

///|
pub fn MaterialNode::MaterialNode(material : UiMaterialHandle) -> MaterialNode {
  { material, }
}

///|
pub(all) struct UiGradient {
  color_start : @render.Color
  color_end : @render.Color
} derive(Eq, Debug)

///|
pub fn UiGradient::UiGradient(
  color_start : @render.Color,
  color_end : @render.Color,
) -> UiGradient {
  { color_start, color_end, }
}

///|
pub(all) struct UiMaterialContext {
  entity : @entity.Entity
  rect : @math.Rect
  content_rect : @math.Rect
  border_radius : BorderRadius
  target_camera_entity_id : UInt32?
}

///|
pub fn UiMaterialContext::UiMaterialContext(
  entity : @entity.Entity,
  rect : @math.Rect,
  content_rect~ : @math.Rect = rect,
  border_radius~ : BorderRadius = BorderRadius::all(Val::px(0.0)),
  target_camera_entity_id~ : UInt32? = None,
) -> UiMaterialContext {
  { entity, rect, content_rect, border_radius, target_camera_entity_id, }
}

///|
pub(all) struct UiMaterialAsset {
  draw : (UiMaterialContext) -> Unit
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
  let gradient = UiGradient(color_start, color_end)
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
  size : @math.Vec2,
  image : @asset.ImageHandle,
  tint~ : @render.Color = rgba(255, 255, 255, 1.0),
  fit~ : ImageFit = Stretch,
) -> UiMaterialAsset {
  UiMaterialAsset::from_ui_image(UiImage::from_image(size, image, tint~, fit~))
}

///|
pub fn UiMaterialAsset::UiMaterialAsset(
  size : @math.Vec2,
  path : String,
  tint~ : @render.Color = rgba(255, 255, 255, 1.0),
  fit~ : ImageFit = Stretch,
) -> UiMaterialAsset {
  UiMaterialAsset::from_ui_image(UiImage(size, path, tint~, fit~))
}

///|
pub(all) struct Text {
  mut content : String
}

///|
pub fn Text::Text(content : String) -> Text {
  { content, }
}

///|
pub(all) struct TextFont {
  mut family : String
  mut size : Double
  mut font_handle : @asset.FontHandle?
}

///|
pub fn TextFont::TextFont(
  family~ : String = "Arial",
  size~ : Double = 16.0,
) -> TextFont {
  { family, size, font_handle: @asset.font_by_family(family), }
}

///|
pub fn TextFont::from_font(
  font : @asset.FontHandle,
  size~ : Double = 16.0,
) -> TextFont {
  let family = @asset.font_family(font).unwrap_or("Arial")
  { family, size, font_handle: Some(font), }
}

///|
fn parse_font_size(size : StringView) -> Double {
  try @string.parse_double(size.trim()) catch {
    _ => 16.0
  } noraise {
    value => value
  }
}

///|
fn parse_font_family(family : StringView) -> String {
  let family = family.trim().to_owned()
  if family == "" {
    "Arial"
  } else {
    family
  }
}

///|
pub fn TextFont::from_css(font : String) -> TextFont {
  let font = font.trim().to_owned()
  if font == "" {
    return TextFont()
  }
  let parts : Array[StringView] = []
  for part in font.split("px") {
    parts.push(part)
  }
  if parts.length() >= 2 {
    TextFont(family=parse_font_family(parts[1]), size=parse_font_size(parts[0]))
  } else {
    TextFont(family=font)
  }
}

///|
pub(all) struct TextColor {
  mut color : @render.Color
}

///|
pub fn TextColor::TextColor(color : @render.Color) -> TextColor {
  { color, }
}

///|
pub fn TextColor::from_css(color : String) -> TextColor {
  TextColor(parse_color(color))
}

///|
pub(all) enum TextWrap {
  NoWrap
  WordWrap
} derive(Eq, Debug)

///|
pub(all) enum TextOverflow {
  Clip
  Ellipsis
} derive(Eq, Debug)

///|
pub(all) struct TextLayout {
  mut align : @math.HAlign
  mut baseline : @math.VAlign
  mut line_height : Double
  mut wrap : TextWrap
  mut overflow : TextOverflow
}

///|
pub fn TextLayout::TextLayout(
  align~ : @math.HAlign = Left,
  baseline~ : @math.VAlign = Top,
  line_height~ : Double = 1.0,
  wrap~ : TextWrap = NoWrap,
  overflow~ : TextOverflow = Clip,
) -> TextLayout {
  { align, baseline, line_height, wrap, overflow, }
}

///|
pub(all) struct Button {
  enabled : Bool
} derive(Eq, Debug)

///|
pub fn Button::Button(enabled~ : Bool = true) -> Button {
  { enabled, }
}

///|
pub(all) enum Interaction {
  None
  Hovered
  Pressed
} derive(Eq, Debug)

///|
priv struct UiVisualWorldStore {
  background_colors : @entity.ComponentStore[BackgroundColor]
  border_colors : @entity.ComponentStore[BorderColor]
  border_radii : @entity.ComponentStore[BorderRadius]
  box_shadows : @entity.ComponentStore[BoxShadow]
  outlines : @entity.ComponentStore[Outline]
  ui_images : @entity.ComponentStore[UiImage]
  material_nodes : @entity.ComponentStore[MaterialNode]
  texts : @entity.ComponentStore[Text]
  text_fonts : @entity.ComponentStore[TextFont]
  text_colors : @entity.ComponentStore[TextColor]
  text_layouts : @entity.ComponentStore[TextLayout]
  buttons : @entity.ComponentStore[Button]
  interactions : @entity.ComponentStore[Interaction]
}

///|
let ui_visual_world_store_key : @ecs.WorldKey[UiVisualWorldStore] = WorldKey(() => {
  background_colors: ComponentStore(@ecs.require_current_world()),
  border_colors: ComponentStore(@ecs.require_current_world()),
  border_radii: ComponentStore(@ecs.require_current_world()),
  box_shadows: ComponentStore(@ecs.require_current_world()),
  outlines: ComponentStore(@ecs.require_current_world()),
  ui_images: ComponentStore(@ecs.require_current_world()),
  material_nodes: ComponentStore(@ecs.require_current_world()),
  texts: ComponentStore(@ecs.require_current_world()),
  text_fonts: ComponentStore(@ecs.require_current_world()),
  text_colors: ComponentStore(@ecs.require_current_world()),
  text_layouts: ComponentStore(@ecs.require_current_world()),
  buttons: ComponentStore(@ecs.require_current_world()),
  interactions: ComponentStore(@ecs.require_current_world()),
})

///|
fn ui_visual_world_store() -> UiVisualWorldStore {
  @ecs.require_current_world().get_or_init(ui_visual_world_store_key)
}

///|
pub fn background_colors() -> @entity.ComponentStore[BackgroundColor] {
  ui_visual_world_store().background_colors
}

///|
pub fn border_colors() -> @entity.ComponentStore[BorderColor] {
  ui_visual_world_store().border_colors
}

///|
pub fn border_radii() -> @entity.ComponentStore[BorderRadius] {
  ui_visual_world_store().border_radii
}

///|
pub fn box_shadows() -> @entity.ComponentStore[BoxShadow] {
  ui_visual_world_store().box_shadows
}

///|
pub fn outlines() -> @entity.ComponentStore[Outline] {
  ui_visual_world_store().outlines
}

///|
pub fn ui_images() -> @entity.ComponentStore[UiImage] {
  ui_visual_world_store().ui_images
}

///|
pub fn material_nodes() -> @entity.ComponentStore[MaterialNode] {
  ui_visual_world_store().material_nodes
}

///|
let ui_material_assets : Map[UiMaterialHandle, UiMaterialAsset] = Map([])

///|
let next_ui_material_id : Ref[UInt32] = Ref(0)

///|
pub fn texts() -> @entity.ComponentStore[Text] {
  ui_visual_world_store().texts
}

///|
pub fn text_fonts() -> @entity.ComponentStore[TextFont] {
  ui_visual_world_store().text_fonts
}

///|
pub fn text_colors() -> @entity.ComponentStore[TextColor] {
  ui_visual_world_store().text_colors
}

///|
pub fn text_layouts() -> @entity.ComponentStore[TextLayout] {
  ui_visual_world_store().text_layouts
}

///|
pub fn buttons() -> @entity.ComponentStore[Button] {
  ui_visual_world_store().buttons
}

///|
pub fn interactions() -> @entity.ComponentStore[Interaction] {
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
  TextFont()
}

///|
fn default_text_color() -> TextColor {
  TextColor::from_css("white")
}

///|
fn default_text_layout() -> TextLayout {
  TextLayout()
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
