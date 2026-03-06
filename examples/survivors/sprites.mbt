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
let player_idle_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let player_idle_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  loop_=true,
  fps=12,
  transform=@math.Transform::flip_x(PLAYER_SIZE),
)

///|
let player_idle_up_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 160.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let player_idle_down_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 80.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let player_run_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let player_run_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(PLAYER_SIZE),
)

///|
let player_run_down_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 80.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let player_run_up_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 160.0),
    space_x=64.0,
  ),
  fps=12,
  loop_=true,
)

///|
let grass_sprite : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/tilesets/decor_16x16.png",
    1,
    width=16,
    height=16,
    offset=Vec2D(0, 0),
  ),
)

///|
let background_picture = "assets/survivors/tilesets/grass.png"

///|
let creeper_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Creeper.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let creeper_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Creeper.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let icecream_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Icecream.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let icecream_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Icecream.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let orc_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Orc.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let orc_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Orc.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let skull_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Skull.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let skull_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Skull.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let devil_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Devil.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let devil_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Devil.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let pirate_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Pirate.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let pirate_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Pirate.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 48),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let teleman_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Teleman.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 0),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let teleman_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/survivors/enemy/Teleman.png",
    4,
    width=16,
    height=24,
    offset=Vec2D(0, 0),
    space_x=0,
  ),
  fps=12,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)
