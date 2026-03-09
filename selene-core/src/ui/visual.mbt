///|
pub(all) struct BackgroundColor {
  color : @render.Color
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
  top_left : Double
  top_right : Double
  bottom_right : Double
  bottom_left : Double
} derive(Eq, Show)

///|
pub fn BorderRadius::all(value : Double) -> BorderRadius {
  { top_left: value, top_right: value, bottom_right: value, bottom_left: value }
}

///|
pub fn BorderRadius::new(
  top_left? : Double = 0.0,
  top_right? : Double = top_left,
  bottom_right? : Double = top_left,
  bottom_left? : Double = bottom_right,
) -> BorderRadius {
  { top_left, top_right, bottom_right, bottom_left }
}

///|
pub(all) struct Outline {
  width : Double
  offset : Double
  color : @render.Color
}

///|
pub fn Outline::new(
  width : Double,
  color : @render.Color,
  offset? : Double = 0.0,
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
}

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
pub(all) struct Text {
  mut content : String
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
pub let background_colors : Map[@entity.Entity, BackgroundColor] = Map::new()

///|
pub let border_colors : Map[@entity.Entity, BorderColor] = Map::new()

///|
pub let border_radii : Map[@entity.Entity, BorderRadius] = Map::new()

///|
pub let box_shadows : Map[@entity.Entity, BoxShadow] = Map::new()

///|
pub let outlines : Map[@entity.Entity, Outline] = Map::new()

///|
pub let ui_images : Map[@entity.Entity, UiImage] = Map::new()

///|
pub let texts : Map[@entity.Entity, Text] = Map::new()

///|
pub let text_fonts : Map[@entity.Entity, TextFont] = Map::new()

///|
pub let text_colors : Map[@entity.Entity, TextColor] = Map::new()

///|
pub let text_layouts : Map[@entity.Entity, TextLayout] = Map::new()

///|
pub let buttons : Map[@entity.Entity, Button] = Map::new()

///|
pub let interactions : Map[@entity.Entity, Interaction] = Map::new()

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
  text_fonts.get(entity).unwrap_or(default_text_font())
}

///|
fn text_color(entity : @entity.Entity) -> TextColor {
  text_colors.get(entity).unwrap_or(default_text_color())
}

///|
fn text_layout(entity : @entity.Entity) -> TextLayout {
  text_layouts.get(entity).unwrap_or(default_text_layout())
}

///|
fn text_style_for(entity : @entity.Entity) -> @render2d_types.TextStyle2D? {
  guard texts.get(entity) is Some(_) else { return None }
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
