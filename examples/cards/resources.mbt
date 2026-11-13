///|
let game_font : @asset.FontHandle = @asset.fonts.add(
  @asset.Font::from_bytes(@embedded_assets.assets.cards.thaleahfat_ttf),
)

///|
fn game_text_font(css : String) -> @ui.TextFont {
  let style = @ui.TextFont::from_css(css)
  style.font_handle = Some(game_font)
  style
}
