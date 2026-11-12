///|
let background_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.background.gray_png,
  ),
)

///|
let bird_flying_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.enemies.bluebird.flying_32x32_png,
  ),
)

///|
let bird_hit_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.enemies.bluebird.hit_32x32_png,
  ),
)

///|
let flag_idle_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.items.checkpoints.checkpoint.checkpoint_flag_idle_64x64_png,
  ),
)

///|
let apple_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.items.fruits.apple_png,
  ),
)

///|
let player_fall_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.main_characters.mask_dude.fall_32x32_png,
  ),
)

///|
let player_hit_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.main_characters.mask_dude.hit_32x32_png,
  ),
)

///|
let player_idle_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.main_characters.mask_dude.idle_32x32_png,
  ),
)

///|
let player_jump_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.main_characters.mask_dude.jump_32x32_png,
  ),
)

///|
let player_run_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.main_characters.mask_dude.run_32x32_png,
  ),
)

///|
let volume_on_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.menu.buttons.volume_png,
  ),
)

///|
let volumeoff_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.menu.buttons.volumeoff_png,
  ),
)

///|
let terrain_image : @asset.ImageHandle = @asset.images.add(
  @asset.Image::from_bytes(
    @embedded_assets.assets.pixeladventure.terrain.terrain_16x16_png,
  ),
)

///|
let coin_sound : @asset.AudioHandle = @asset.audios.add(
  @asset.Audio::from_bytes(
    @embedded_assets.assets.pixeladventure.sounds.coin_wav,
  ),
)

///|
let hurt_sound : @asset.AudioHandle = @asset.audios.add(
  @asset.Audio::from_bytes(
    @embedded_assets.assets.pixeladventure.sounds.hurt_wav,
  ),
)

///|
let jump_sound : @asset.AudioHandle = @asset.audios.add(
  @asset.Audio::from_bytes(
    @embedded_assets.assets.pixeladventure.sounds.jump_wav,
  ),
)

///|
let game_font : @asset.FontHandle = @asset.fonts.add(
  @asset.Font::from_bytes(
    @embedded_assets.assets.pixeladventure.fonts.thaleahfat_ttf,
  ),
)

///|
fn game_text_font(css : String) -> @ui.TextFont {
  let style = @ui.TextFont::from_css(css)
  style.font_handle = Some(game_font)
  style
}
