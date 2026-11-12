///|
let creeper_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.creeper_png),
)

///|
let devil_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.devil_png),
)

///|
let icecream_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.icecream_png),
)

///|
let orc_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.orc_png),
)

///|
let pirate_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.pirate_png),
)

///|
let skull_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.skull_png),
)

///|
let teleman_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.enemy.teleman_png),
)

///|
let bullet_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.icon.bullet_png),
)

///|
let powerup_attack_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.powerup_attack_png,
  ),
)

///|
let powerup_bandana_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.powerup_bandana_png,
  ),
)

///|
let powerup_cooldown_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.powerup_cooldown_png,
  ),
)

///|
let powerup_range_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.powerup_range_png,
  ),
)

///|
let powerup_speed_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.powerup_speed_png,
  ),
)

///|
let weapon_minigun_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.weapon_minigun_png,
  ),
)

///|
let weapon_pistol_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.weapon_pistol_png,
  ),
)

///|
let weapon_sniperrifle_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.weapon_sniperrifle_png,
  ),
)

///|
let weapon_sword_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.icon.weapon_sword_png,
  ),
)

///|
let decor_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.survivors.tilesets.decor_16x16_png,
  ),
)

///|
let background_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.tilesets.grass_png),
)

///|
let player_idle_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.whiteboy.idle_png),
)

///|
let player_run_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(@embedded_assets.assets.survivors.whiteboy.run_png),
)

///|
let game_font : @asset.FontHandle = @asset.fonts.add(
  @asset.Font::from_bytes(
    @embedded_assets.assets.survivors.fonts.thaleahfat_ttf,
  ),
)

///|
fn game_text_font(css : String) -> @ui.TextFont {
  let style = @ui.TextFont::from_css(css)
  style.font_handle = Some(game_font)
  style
}
