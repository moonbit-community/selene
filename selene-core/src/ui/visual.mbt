///|
#selene.component
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
#selene.component
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
#derive(Eq, Debug)
#selene.component
pub(all) struct BorderRadius {
  top_left : Val
  top_right : Val
  bottom_right : Val
  bottom_left : Val
}

///|
pub extend BorderRadius with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BorderRadius with Eq::{not_equal, equal}

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
#selene.component
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
#derive(Eq, Debug)
pub(all) struct ShadowStyle {
  color : @render.Color
  x_offset : Val
  y_offset : Val
  spread_radius : Val
  blur_radius : Val
}

///|
pub extend ShadowStyle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ShadowStyle with Eq::{not_equal, equal}

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
#derive(Eq, Debug)
#selene.component
pub(all) struct BoxShadow {
  layers : Array[ShadowStyle]
}

///|
pub extend BoxShadow with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BoxShadow with Eq::{not_equal, equal}

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
#derive(Eq, Debug)
pub(all) enum ImageFit {
  Stretch
  Contain
  Cover
  None
}

///|
pub extend ImageFit with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageFit with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct UiImage {
  size : @math.Vec2
  image : @asset.ImageHandle
  tint : @render.Color
  fit : ImageFit
}

///|
pub extend UiImage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiImage with Eq::{not_equal, equal}

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
#derive(Eq, Debug, Hash)
pub(all) struct UiMaterialHandle(UInt32)

///|
pub extend UiMaterialHandle with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiMaterialHandle with Eq::{not_equal, equal}

///|
pub extend UiMaterialHandle with Hash::{hash, hash_combine}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct MaterialNode {
  material : UiMaterialHandle
}

///|
pub extend MaterialNode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MaterialNode with Eq::{not_equal, equal}

///|
pub fn MaterialNode::MaterialNode(material : UiMaterialHandle) -> MaterialNode {
  { material, }
}

///|
#derive(Eq, Debug)
pub(all) struct UiGradient {
  color_start : @render.Color
  color_end : @render.Color
}

///|
pub extend UiGradient with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend UiGradient with Eq::{not_equal, equal}

///|
pub fn UiGradient::UiGradient(
  color_start : @render.Color,
  color_end : @render.Color,
) -> UiGradient {
  { color_start, color_end, }
}

///|
pub(all) struct UiMaterialContext {
  entity : @ecs.Entity
  rect : @math.Rect
  content_rect : @math.Rect
  border_radius : BorderRadius
  target_camera_entity_id : UInt32?
}

///|
pub fn UiMaterialContext::UiMaterialContext(
  entity : @ecs.Entity,
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
#selene.component
pub(all) struct Text {
  mut content : String
}

///|
pub fn Text::Text(content : String) -> Text {
  { content, }
}

///|
#selene.component
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
#selene.component
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
#derive(Eq, Debug)
pub(all) enum TextWrap {
  NoWrap
  WordWrap
}

///|
pub extend TextWrap with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextWrap with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum TextOverflow {
  Clip
  Ellipsis
}

///|
pub extend TextOverflow with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextOverflow with Eq::{not_equal, equal}

///|
#selene.component
pub(all) struct TextLayout {
  mut align : @render2d_types.HAlign
  mut baseline : @render2d_types.VAlign
  mut line_height : Double
  mut wrap : TextWrap
  mut overflow : TextOverflow
}

///|
pub fn TextLayout::TextLayout(
  align~ : @render2d_types.HAlign = Left,
  baseline~ : @render2d_types.VAlign = Top,
  line_height~ : Double = 1.0,
  wrap~ : TextWrap = NoWrap,
  overflow~ : TextOverflow = Clip,
) -> TextLayout {
  { align, baseline, line_height, wrap, overflow, }
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Button {
  enabled : Bool
}

///|
pub extend Button with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Button with Eq::{not_equal, equal}

///|
pub fn Button::Button(enabled~ : Bool = true) -> Button {
  { enabled, }
}

///|
#derive(Eq, Debug)
pub(all) enum Interaction {
  None
  Hovered
  Pressed
}

///|
pub extend Interaction with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Interaction with Eq::{not_equal, equal}

///|
pub fn background_colors() -> @ecs.ComponentStore[BackgroundColor] {
  @ecs.components()
}

///|
pub fn border_colors() -> @ecs.ComponentStore[BorderColor] {
  @ecs.components()
}

///|
pub fn border_radii() -> @ecs.ComponentStore[BorderRadius] {
  @ecs.components()
}

///|
pub fn box_shadows() -> @ecs.ComponentStore[BoxShadow] {
  @ecs.components()
}

///|
pub fn outlines() -> @ecs.ComponentStore[Outline] {
  @ecs.components()
}

///|
pub fn ui_images() -> @ecs.ComponentStore[UiImage] {
  @ecs.components()
}

///|
pub fn material_nodes() -> @ecs.ComponentStore[MaterialNode] {
  @ecs.components()
}

///|
let ui_material_assets : Map[UiMaterialHandle, UiMaterialAsset] = Map([])

///|
let next_ui_material_id : Ref[UInt32] = Ref(0)

///|
pub fn texts() -> @ecs.ComponentStore[Text] {
  @ecs.components()
}

///|
pub fn text_fonts() -> @ecs.ComponentStore[TextFont] {
  @ecs.components()
}

///|
pub fn text_colors() -> @ecs.ComponentStore[TextColor] {
  @ecs.components()
}

///|
pub fn text_layouts() -> @ecs.ComponentStore[TextLayout] {
  @ecs.components()
}

///|
pub fn buttons() -> @ecs.ComponentStore[Button] {
  @ecs.components()
}

///|
pub fn interactions() -> @ecs.EntityTable[Interaction] {
  ui_model_world_store().interactions
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
fn default_text_color() -> TextColor {
  TextColor::from_css("white")
}

///|
fn text_font(entity : @ecs.Entity) -> TextFont {
  text_fonts().get(entity).unwrap_or(TextFont())
}

///|
fn text_color(entity : @ecs.Entity) -> TextColor {
  text_colors().get(entity).unwrap_or(default_text_color())
}

///|
fn text_layout(entity : @ecs.Entity) -> TextLayout {
  text_layouts().get(entity).unwrap_or(TextLayout())
}

///|
pub fn text_style_for(entity : @ecs.Entity) -> @render2d_types.TextStyle2D? {
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
