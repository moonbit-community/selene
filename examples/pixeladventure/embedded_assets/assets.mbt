///|
let catalogue : Map[String, Bytes] = Map([
  (
    "assets/pixeladventure/Background/Gray.png",
    assets.pixeladventure.background.gray_png,
  ),
  (
    "assets/pixeladventure/Enemies/BlueBird/Flying (32x32).png",
    assets.pixeladventure.enemies.bluebird.flying_32x32_png,
  ),
  (
    "assets/pixeladventure/Enemies/BlueBird/Hit (32x32).png",
    assets.pixeladventure.enemies.bluebird.hit_32x32_png,
  ),
  (
    "assets/pixeladventure/Fonts/ThaleahFat.ttf",
    assets.pixeladventure.fonts.thaleahfat_ttf,
  ),
  (
    "assets/pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
    assets.pixeladventure.items.checkpoints.checkpoint.checkpoint_flag_idle_64x64_png,
  ),
  (
    "assets/pixeladventure/Items/Fruits/Apple.png",
    assets.pixeladventure.items.fruits.apple_png,
  ),
  (
    "assets/pixeladventure/Main Characters/Mask Dude/Fall (32x32).png",
    assets.pixeladventure.main_characters.mask_dude.fall_32x32_png,
  ),
  (
    "assets/pixeladventure/Main Characters/Mask Dude/Hit (32x32).png",
    assets.pixeladventure.main_characters.mask_dude.hit_32x32_png,
  ),
  (
    "assets/pixeladventure/Main Characters/Mask Dude/Idle (32x32).png",
    assets.pixeladventure.main_characters.mask_dude.idle_32x32_png,
  ),
  (
    "assets/pixeladventure/Main Characters/Mask Dude/Jump (32x32).png",
    assets.pixeladventure.main_characters.mask_dude.jump_32x32_png,
  ),
  (
    "assets/pixeladventure/Main Characters/Mask Dude/Run (32x32).png",
    assets.pixeladventure.main_characters.mask_dude.run_32x32_png,
  ),
  (
    "assets/pixeladventure/Menu/Buttons/Volume.png",
    assets.pixeladventure.menu.buttons.volume_png,
  ),
  (
    "assets/pixeladventure/Menu/Buttons/VolumeOff.png",
    assets.pixeladventure.menu.buttons.volumeoff_png,
  ),
  (
    "assets/pixeladventure/Terrain/Terrain (16x16).png",
    assets.pixeladventure.terrain.terrain_16x16_png,
  ),
  ("assets/pixeladventure/arrowkey.png", assets.pixeladventure.arrowkey_png),
  (
    "assets/pixeladventure/sounds/coin.wav",
    assets.pixeladventure.sounds.coin_wav,
  ),
  (
    "assets/pixeladventure/sounds/hurt.wav",
    assets.pixeladventure.sounds.hurt_wav,
  ),
  (
    "assets/pixeladventure/sounds/jump.wav",
    assets.pixeladventure.sounds.jump_wav,
  ),
])

///|
pub fn read(path : String) -> Bytes? {
  catalogue.get(path)
}

///|
pub fn paths() -> Array[String] {
  catalogue.keys().collect()
}
