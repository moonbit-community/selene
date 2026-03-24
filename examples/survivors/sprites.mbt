// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
priv struct SpriteAnimationDef {
  name : String
  image : @asset.ImageHandle
  layout : @sprite.TextureAtlasLayoutHandle
  fps : Double
  loop_ : Bool
  size : @math.Vec2D
  anchor : @sprite.Anchor
  flip_x : Bool
  flip_y : Bool
}

///|
fn atlas_animation(
  path : String,
  frame_count : Int,
  size : @math.Vec2D,
  offset? : @math.Vec2D = @math.Vec2D::zero(),
  step_x? : Double = size[X],
  fps? : Double = 12.0,
  loop_? : Bool = true,
  anchor? : @sprite.Anchor = @sprite.Anchor(@math.Vec2D(0.0, 0.0)),
  flip_x? : Bool = false,
  flip_y? : Bool = false,
) -> SpriteAnimationDef {
  let padding_x = if step_x > size[X] { step_x - size[X] } else { 0.0 }
  {
    name: path,
    image: @asset2.load_image(path),
    layout: @sprite.register_texture_atlas_layout(
      @sprite.TextureAtlasLayout::from_grid(
        size,
        frame_count,
        1,
        padding=Some(@math.Vec2D(padding_x, 0.0)),
        offset=Some(offset),
      ),
    ),
    fps,
    loop_,
    size,
    anchor,
    flip_x,
    flip_y,
  }
}

///|
fn sprite_animation_sprite(animation : SpriteAnimationDef) -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(animation.image),
    texture_atlas=Some(@sprite.TextureAtlas::new(animation.layout)),
    custom_size=Some(animation.size),
    anchor=animation.anchor,
    flip_x=animation.flip_x,
    flip_y=animation.flip_y,
  )
}

///|
fn static_region_sprite(
  path : String,
  size : @math.Vec2D,
  rect? : @math.Rect? = None,
  anchor? : @sprite.Anchor = @sprite.Anchor(@math.Vec2D(0.0, 0.0)),
) -> @sprite.Sprite {
  @sprite.Sprite::new(
    image=Some(@asset2.load_image(path)),
    rect~,
    custom_size=Some(size),
    anchor~,
  )
}

///|
let player_idle_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/idle.png",
  4,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 32.0),
  step_x=64.0,
)

///|
let player_idle_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/idle.png",
  4,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 32.0),
  step_x=64.0,
  flip_x=true,
)

///|
let player_idle_up_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/idle.png",
  4,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 192.0),
  step_x=64.0,
)

///|
let player_idle_down_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/idle.png",
  4,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 112.0),
  step_x=64.0,
)

///|
let player_run_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/run.png",
  8,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 32.0),
  step_x=64.0,
)

///|
let player_run_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/run.png",
  8,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 32.0),
  step_x=64.0,
  flip_x=true,
)

///|
let player_run_down_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/run.png",
  8,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 112.0),
  step_x=64.0,
)

///|
let player_run_up_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/whiteboy/run.png",
  8,
  Vec2D(PLAYER_SIZE, PLAYER_SIZE),
  offset=Vec2D(32.0, 192.0),
  step_x=64.0,
)

///|
fn grass_sprite() -> @sprite.Sprite {
  static_region_sprite(
    "assets/survivors/tilesets/decor_16x16.png",
    Vec2D(16.0, 16.0),
    rect=Some({ position: Vec2D(0.0, 0.0), size: Vec2D(16.0, 16.0) }),
    anchor=@sprite.Anchor(@math.Vec2D(-0.5, 0.5)),
  )
}

///|
let background_picture = "assets/survivors/tilesets/grass.png"

///|
let creeper_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Creeper.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let creeper_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Creeper.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let icecream_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Icecream.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let icecream_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Icecream.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let orc_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Orc.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let orc_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Orc.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let skull_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Skull.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let skull_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Skull.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let devil_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Devil.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let devil_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Devil.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let pirate_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Pirate.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
)

///|
let pirate_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Pirate.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 48.0),
  flip_x=true,
)

///|
let teleman_right_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Teleman.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 0.0),
)

///|
let teleman_left_animation : SpriteAnimationDef = atlas_animation(
  "assets/survivors/enemy/Teleman.png",
  4,
  Vec2D(16.0, 24.0),
  offset=Vec2D(0.0, 0.0),
  flip_x=true,
)
