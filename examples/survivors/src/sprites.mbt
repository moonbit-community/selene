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
    "assets/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let player_idle_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  loop_=true,
  rate=0.2,
  transform=@math.Transform::flip_x(PLAYER_SIZE),
)

///|
let player_idle_up_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 160.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let player_idle_down_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/idle.png",
    4,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 80.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let player_run_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let player_run_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::flip_x(PLAYER_SIZE),
)

///|
let player_run_down_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 80.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let player_run_up_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/whiteboy/run.png",
    8,
    width=PLAYER_SIZE,
    height=PLAYER_SIZE,
    offset=Vec2D(32.0, 32.0 + 160.0),
    space_x=64.0,
  ),
  rate=0.2,
  loop_=true,
)

///|
let grass_sprite : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/tilesets/decor_16x16.png",
    1,
    width=16,
    height=16,
    offset=Vec2D(0, 0),
  ),
)

///|
let background_picture = "assets/tilesets/grass.png"

///|
let slime_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/slime.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(8, 40),
    space_x=16,
  ),
  rate=0.2,
  loop_=true,
)

///|
let slime_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/slime.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(8, 40),
    space_x=16,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

///|
let icecream_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Icecream.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::new(),
)

///|
let icecream_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Icecream.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

let orc_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Orc.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::new(),
)

let orc_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Orc.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)

let skull_right_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Skull.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::new(),
)

let skull_left_animation : @sprite.Animation = @sprite.Animation::new(
  @sprite.frames_from_atlas(
    "assets/enemy/Skull.png",
    4,
    width=16,
    height=16,
    offset=Vec2D(0, 56),
    space_x=0,
  ),
  rate=0.2,
  loop_=true,
  transform=@math.Transform::flip_x(16),
)
