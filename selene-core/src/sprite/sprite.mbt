///|
pub(all) enum SpriteImageMode {
  Auto
  Tiled(@render2d_types.RepeatMode)
}

///|
#selene.component
pub(all) struct Sprite {
  image : @asset.ImageHandle?
  mut texture_atlas : TextureAtlas?
  mut rect : @math.Rect?
  mut color : @render.Color
  mut custom_size : @math.Vec2?
  mut anchor : Anchor
  mut flip_x : Bool
  mut flip_y : Bool
  mut image_mode : SpriteImageMode
  mut blend_mode : @render.BlendMode2D
}

///|
fn white_sprite_color() -> @render.Color {
  color_from_css("white")
}

///|
pub fn Sprite::Sprite(
  image~ : @asset.ImageHandle? = None,
  texture_atlas~ : TextureAtlas? = None,
  rect~ : @math.Rect? = None,
  color~ : @render.Color = white_sprite_color(),
  custom_size~ : @math.Vec2? = None,
  anchor~ : Anchor = default_anchor(),
  flip_x~ : Bool = false,
  flip_y~ : Bool = false,
  image_mode~ : SpriteImageMode = Auto,
  blend_mode~ : @render.BlendMode2D = Alpha,
) -> Sprite {
  {
    image,
    texture_atlas,
    rect,
    color,
    custom_size,
    anchor,
    flip_x,
    flip_y,
    image_mode,
    blend_mode,
  }
}

///|
pub fn Sprite::from_image(
  image : @asset.ImageHandle,
  custom_size~ : @math.Vec2? = None,
) -> Sprite {
  Sprite(image=Some(image), custom_size~)
}

///|
pub fn Sprite::from_atlas_image(
  image : @asset.ImageHandle,
  texture_atlas : TextureAtlas,
) -> Sprite {
  let custom_size = texture_atlas_rect(texture_atlas).map(fn(rect) { rect.size })
  Sprite(image=Some(image), texture_atlas=Some(texture_atlas), custom_size~)
}

///|
pub fn Sprite::from_color(
  color : @render.Color,
  custom_size : @math.Vec2,
) -> Sprite {
  Sprite(color~, custom_size=Some(custom_size))
}
