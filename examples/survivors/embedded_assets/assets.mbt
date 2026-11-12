///|
let catalogue : Map[String, Bytes] = Map([
  ("assets/survivors/enemy/Creeper.png", assets.survivors.enemy.creeper_png),
  ("assets/survivors/enemy/Devil.png", assets.survivors.enemy.devil_png),
  ("assets/survivors/enemy/Icecream.png", assets.survivors.enemy.icecream_png),
  ("assets/survivors/enemy/Orc.png", assets.survivors.enemy.orc_png),
  ("assets/survivors/enemy/Pirate.png", assets.survivors.enemy.pirate_png),
  ("assets/survivors/enemy/Skull.png", assets.survivors.enemy.skull_png),
  ("assets/survivors/enemy/Teleman.png", assets.survivors.enemy.teleman_png),
  (
    "assets/survivors/fonts/ThaleahFat.ttf",
    assets.survivors.fonts.thaleahfat_ttf,
  ),
  ("assets/survivors/icon/bullet.png", assets.survivors.icon.bullet_png),
  (
    "assets/survivors/icon/powerup_attack.png",
    assets.survivors.icon.powerup_attack_png,
  ),
  (
    "assets/survivors/icon/powerup_bandana.png",
    assets.survivors.icon.powerup_bandana_png,
  ),
  (
    "assets/survivors/icon/powerup_cooldown.png",
    assets.survivors.icon.powerup_cooldown_png,
  ),
  (
    "assets/survivors/icon/powerup_range.png",
    assets.survivors.icon.powerup_range_png,
  ),
  (
    "assets/survivors/icon/powerup_speed.png",
    assets.survivors.icon.powerup_speed_png,
  ),
  (
    "assets/survivors/icon/weapon_minigun.png",
    assets.survivors.icon.weapon_minigun_png,
  ),
  (
    "assets/survivors/icon/weapon_pistol.png",
    assets.survivors.icon.weapon_pistol_png,
  ),
  (
    "assets/survivors/icon/weapon_sniperrifle.png",
    assets.survivors.icon.weapon_sniperrifle_png,
  ),
  (
    "assets/survivors/icon/weapon_sword.png",
    assets.survivors.icon.weapon_sword_png,
  ),
  (
    "assets/survivors/tilesets/decor_16x16.png",
    assets.survivors.tilesets.decor_16x16_png,
  ),
  ("assets/survivors/tilesets/grass.png", assets.survivors.tilesets.grass_png),
  ("assets/survivors/whiteboy/death.png", assets.survivors.whiteboy.death_png),
  ("assets/survivors/whiteboy/hurt.png", assets.survivors.whiteboy.hurt_png),
  ("assets/survivors/whiteboy/idle.png", assets.survivors.whiteboy.idle_png),
  ("assets/survivors/whiteboy/run.png", assets.survivors.whiteboy.run_png),
  ("assets/survivors/whiteboy/walk.png", assets.survivors.whiteboy.walk_png),
])

///|
pub fn read(path : String) -> Bytes? {
  catalogue.get(path)
}

///|
pub fn paths() -> Array[String] {
  catalogue.keys().collect()
}
