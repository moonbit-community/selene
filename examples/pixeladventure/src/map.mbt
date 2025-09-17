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
fn tile_to_vec2d(tile : @tilemap.Tile, tile_size : Int) -> @math.Vec2D {
  @math.Vec2D(
    tile.x.to_double() * tile_size.to_double(),
    tile.y.to_double() * tile_size.to_double(),
  )
}

///|
fn generate_map(backend : &@system.Backend) -> Unit {
  let tilemap = @tilemap.TileMap::from_json(tilemap)
  let world_width = tilemap.map_width.to_double() *
    tilemap.tile_size.to_double()
  let world_height = tilemap.map_height.to_double() *
    tilemap.tile_size.to_double()
  @camera.set_limits(top=0.0, bottom=world_height, left=0.0, right=world_width)
  add_background(@math.Vec2D(world_width, world_height))
  let mask_dude = tilemap.get_tiles_first("MaskDude")[0]
  add_player(tile_to_vec2d(mask_dude, tilemap.tile_size))
  let flag = tilemap.get_tiles_first("Flag")[0]
  add_flag(tile_to_vec2d(flag, tilemap.tile_size) - @math.Vec2D(16.0, 16.0))
  let apples = tilemap.get_tiles_first("Apple")
  for apple in apples {
    add_apple(backend, tile_to_vec2d(apple, tilemap.tile_size))
  }
  let grasses = tilemap.get_tiles("Grass")
  for grass in grasses {
    add_grass(tile_to_vec2d(grass, tilemap.tile_size), grass.id)
  }
  let birds = tilemap.get_tiles_first("Bird")
  for bird in birds {
    add_bird(tile_to_vec2d(bird, tilemap.tile_size))
  }
}

///|
fn add_background(size : @math.Vec2D) -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::from_picture(
    @sprite.Picture::new(size, "assets/Background/Gray.png", repeat=Repeat),
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D(0, 0))
}

///|
fn add_grass(pos : @math.Vec2D, sprite_id : String) -> Unit {
  let src_pos = match sprite_id {
    "15" => @math.Vec2D(96.0, 0.0)
    "9" => @math.Vec2D(112.0, 0.0)
    "16" => @math.Vec2D(128.0, 0.0)
    "11" => @math.Vec2D(96.0, 16.0)
    "13" => @math.Vec2D(112.0, 16.0)
    "10" => @math.Vec2D(128.0, 16.0)
    "14" => @math.Vec2D(96.0, 32.0)
    "8" => @math.Vec2D(112.0, 32.0)
    "12" => @math.Vec2D(128.0, 32.0)
    _ => panic()
  }
  let sprite = @sprite.Sprite::from_animation(
    @sprite.Animation::single_frame(
      "assets/Terrain/Terrain (16x16).png",
      @math.Vec2D(16.0, 16.0),
      offset=src_pos,
    ),
    10,
  )
  let grass = @system.Entity::new()
  @sprite.sprites.set(grass, sprite)
  @position.positions.set(grass, pos)
  @collision.shapes.set(
    grass,
    Rect(size=@math.Vec2D(16.0, 16.0), offset=@math.Vec2D::zero()),
  )
  @collision.collision_layers.set(grass, terrain_collision_layer)
}

///|
fn add_flag(pos : @math.Vec2D) -> Unit {
  let flag = @system.Entity::new()
  let flag_sprite = @sprite.Sprite::from_animation(
    @sprite.Animation::single_frame(
      "assets/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
      @math.Vec2D(64.0, 64.0),
    ),
    20,
  )
  @sprite.sprites.set(flag, flag_sprite)
  @position.positions.set(flag, pos)
  @collision.shapes.set(
    flag,
    Rect(size=@math.Vec2D(64.0, 64.0), offset=@math.Vec2D::zero()),
  )
  let area = @collision.Area::new(
    @collision.CollisionMask::new([player_collision_layer]),
  )
  @collision.areas.set(flag, area)
  area.on_enter(fn(e) {
    if e == game_state.player {
      set_score(game_state.score + 100)
      set_game_result(GameResult::Win)
      @system.Entity::destroy(flag)
    }
  })
}

///|
fn add_apple(backend : &@system.Backend, pos : @math.Vec2D) -> Unit {
  let apple = @system.Entity::new()
  let apple_sprite = @sprite.Sprite::from_animation(
    @sprite.Animation::new(
      @sprite.frames_from_atlas(
        "assets/Items/Fruits/Apple.png",
        17,
        width=32.0,
        height=32.0,
      ),
      loop_=true,
      fps=12,
    ),
    20,
  )
  @sprite.sprites.set(apple, apple_sprite)
  @position.positions.set(apple, pos)
  @collision.shapes.set(
    apple,
    Rect(size=@math.Vec2D(32.0, 32.0), offset=@math.Vec2D::zero()),
  )
  let area = @collision.Area::new(
    @collision.CollisionMask::new([player_collision_layer]),
  )
  @collision.areas.set(apple, area)
  area.on_enter(fn(e) {
    if e == game_state.player {
      set_score(game_state.score + 10)
      if game_state.volume_on {
        @audio.play_audio(backend, "sounds/coin.wav")
      }
      @system.Entity::destroy(apple)
    }
  })
}
