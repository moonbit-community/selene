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
  @math.Vec2D::new(
    tile.x.to_double() * tile_size.to_double(),
    tile.y.to_double() * tile_size.to_double(),
  )
}

///|
fn generate_map() -> Unit {
  add_background(@math.Vec2D::new(WORLD_WIDTH, WORLD_HEIGHT))
  let tilemap = @tilemap.TileMap::from_json(tilemap)
  let mask_dude = tilemap.get_tiles_leftcorner("MaskDude")[0]
  add_player(tile_to_vec2d(mask_dude, tilemap.tile_size))
  let flag = tilemap.get_tiles_leftcorner("Flag")[0]
  add_flag(
    tile_to_vec2d(flag, tilemap.tile_size) - @math.Vec2D::new(16.0, 16.0),
  )
  let apples = tilemap.get_tiles_leftcorner("Apple")
  for apple in apples {
    add_apple(tile_to_vec2d(apple, tilemap.tile_size))
  }
  let grasses = tilemap.get_tiles("Grass")
  for grass in grasses {
    add_grass(tile_to_vec2d(grass, tilemap.tile_size), grass.id)
  }
}

///|
fn add_background(size : @math.Vec2D) -> Unit {
  let background = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      size,
      "pixel_adventure/Background/Gray.png",
      repeat=true,
    ),
    0,
  )
  @sprite.sprites.set(background, background_sprite)
  @position.positions.set(background, @math.Vec2D::new(0, 0))
}

///|
fn add_grass(pos : @math.Vec2D, sprite_id : String) -> Unit {
  let src_pos = match sprite_id {
    "15" => @math.Vec2D::new(96.0, 0.0)
    "9" => @math.Vec2D::new(112.0, 0.0)
    "16" => @math.Vec2D::new(128.0, 0.0)
    "11" => @math.Vec2D::new(96.0, 16.0)
    "13" => @math.Vec2D::new(112.0, 16.0)
    "10" => @math.Vec2D::new(128.0, 16.0)
    "14" => @math.Vec2D::new(96.0, 32.0)
    "8" => @math.Vec2D::new(112.0, 32.0)
    "12" => @math.Vec2D::new(128.0, 32.0)
    _ => panic()
  }
  let sprite = @sprite.Sprite::new_animation(
    @sprite.Animation::new(
      "pixel_adventure/Terrain/Terrain (16x16).png",
      max_frame=1,
      height=16.0,
      width=16.0,
      offset=src_pos,
    ),
    10,
  )
  let grass = @system.Entity::new()
  @sprite.sprites.set(grass, sprite)
  @position.positions.set(grass, pos)
  @collision.collides.set(grass, @collision.Collide::{
    shape: Rect(size=@math.Vec2D::new(16.0, 16.0), offset=@math.Vec2D::zero()),
    layer: terrain_collision_layer,
    mask: @collision.CollisionMask::empty(),
  })
}

///|
let non_collide_layer : @collision.CollisionLayer = @collision.CollisionLayer::new()

///|
fn add_flag(pos : @math.Vec2D) -> Unit {
  let flag = @system.Entity::new()
  let flag_sprite = @sprite.Sprite::new_animation(
    @sprite.Animation::new(
      "pixel_adventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
      max_frame=10,
      height=64.0,
      width=64.0,
    ),
    20,
  )
  @sprite.sprites.set(flag, flag_sprite)
  @position.positions.set(flag, pos)
  let area = @collision.Area::new(
    Rect(size=@math.Vec2D::new(64.0, 64.0), offset=@math.Vec2D::zero()),
    non_collide_layer,
    @collision.CollisionMask::new([player_collision_layer]),
  )
  @collision.areas.set(flag, area)
  area.on_enter(fn(e) {
    if e == game_state.player {
      game_state.score += 100
      set_game_result(GameResult::Win)
      @system.Entity::destroy(flag)
    }
  })
}

///|
fn add_apple(pos : @math.Vec2D) -> Unit {
  let apple = @system.Entity::new()
  let apple_sprite = @sprite.Sprite::new_animation(
    @sprite.Animation::new(
      "pixel_adventure/Items/Fruits/Apple.png",
      max_frame=17,
      height=32.0,
      width=32.0,
    ),
    20,
  )
  @sprite.sprites.set(apple, apple_sprite)
  @position.positions.set(apple, pos)
  let area = @collision.Area::new(
    Rect(size=@math.Vec2D::new(32.0, 32.0), offset=@math.Vec2D::zero()),
    non_collide_layer,
    @collision.CollisionMask::new([player_collision_layer]),
  )
  @collision.areas.set(apple, area)
  area.on_enter(fn(e) {
    if e == game_state.player {
      score_up(10)
      @system.Entity::destroy(apple)
    }
  })
}

///|
let tilemap : Json = {
  "tileSize": 16,
  "mapWidth": 35,
  "mapHeight": 27,
  "layers": [
    {
      "name": "MaskDude",
      "tiles": [
        { "id": "0", "x": 5, "y": 22 },
        { "id": "1", "x": 6, "y": 22 },
        { "id": "2", "x": 5, "y": 23 },
        { "id": "3", "x": 6, "y": 23 },
      ],
      "collider": false,
    },
    {
      "name": "Apple",
      "tiles": [
        { "id": "17", "x": 12, "y": 22 },
        { "id": "18", "x": 13, "y": 22 },
        { "id": "19", "x": 12, "y": 23 },
        { "id": "20", "x": 13, "y": 23 },
        { "id": "17", "x": 22, "y": 22 },
        { "id": "18", "x": 23, "y": 22 },
        { "id": "19", "x": 22, "y": 23 },
        { "id": "20", "x": 23, "y": 23 },
        { "id": "17", "x": 27, "y": 7 },
        { "id": "18", "x": 28, "y": 7 },
        { "id": "19", "x": 27, "y": 8 },
        { "id": "20", "x": 28, "y": 8 },
        { "id": "17", "x": 15, "y": 12 },
        { "id": "18", "x": 16, "y": 12 },
        { "id": "19", "x": 15, "y": 13 },
        { "id": "20", "x": 16, "y": 13 },
        { "id": "17", "x": 25, "y": 16 },
        { "id": "18", "x": 26, "y": 16 },
        { "id": "19", "x": 25, "y": 17 },
        { "id": "20", "x": 26, "y": 17 },
      ],
      "collider": false,
    },
    {
      "name": "Flag",
      "tiles": [
        { "id": "22", "x": 5, "y": 7 },
        { "id": "23", "x": 6, "y": 7 },
        { "id": "25", "x": 5, "y": 8 },
        { "id": "26", "x": 6, "y": 8 },
        { "id": "28", "x": 5, "y": 9 },
        { "id": "21", "x": 6, "y": 9 },
      ],
      "collider": false,
    },
    {
      "name": "Grass",
      "tiles": [
        { "id": "11", "x": 0, "y": 4 },
        { "id": "10", "x": 2, "y": 4 },
        { "id": "11", "x": 0, "y": 5 },
        { "id": "10", "x": 2, "y": 5 },
        { "id": "11", "x": 0, "y": 6 },
        { "id": "10", "x": 2, "y": 6 },
        { "id": "11", "x": 0, "y": 7 },
        { "id": "10", "x": 2, "y": 7 },
        { "id": "11", "x": 0, "y": 8 },
        { "id": "10", "x": 2, "y": 8 },
        { "id": "11", "x": 0, "y": 9 },
        { "id": "11", "x": 0, "y": 10 },
        { "id": "11", "x": 0, "y": 11 },
        { "id": "11", "x": 0, "y": 12 },
        { "id": "11", "x": 0, "y": 13 },
        { "id": "10", "x": 2, "y": 13 },
        { "id": "11", "x": 0, "y": 14 },
        { "id": "10", "x": 2, "y": 14 },
        { "id": "11", "x": 0, "y": 15 },
        { "id": "10", "x": 2, "y": 15 },
        { "id": "11", "x": 0, "y": 16 },
        { "id": "10", "x": 2, "y": 16 },
        { "id": "11", "x": 0, "y": 17 },
        { "id": "10", "x": 2, "y": 17 },
        { "id": "11", "x": 0, "y": 18 },
        { "id": "10", "x": 2, "y": 18 },
        { "id": "11", "x": 0, "y": 19 },
        { "id": "10", "x": 2, "y": 19 },
        { "id": "11", "x": 0, "y": 20 },
        { "id": "10", "x": 2, "y": 20 },
        { "id": "11", "x": 0, "y": 21 },
        { "id": "10", "x": 2, "y": 21 },
        { "id": "11", "x": 0, "y": 22 },
        { "id": "10", "x": 2, "y": 22 },
        { "id": "13", "x": 1, "y": 4 },
        { "id": "13", "x": 1, "y": 5 },
        { "id": "13", "x": 1, "y": 6 },
        { "id": "13", "x": 1, "y": 7 },
        { "id": "13", "x": 1, "y": 8 },
        { "id": "13", "x": 1, "y": 9 },
        { "id": "13", "x": 1, "y": 10 },
        { "id": "13", "x": 1, "y": 11 },
        { "id": "13", "x": 1, "y": 12 },
        { "id": "13", "x": 1, "y": 13 },
        { "id": "13", "x": 1, "y": 14 },
        { "id": "13", "x": 1, "y": 15 },
        { "id": "13", "x": 1, "y": 16 },
        { "id": "13", "x": 1, "y": 17 },
        { "id": "13", "x": 1, "y": 18 },
        { "id": "13", "x": 1, "y": 19 },
        { "id": "13", "x": 1, "y": 20 },
        { "id": "13", "x": 1, "y": 21 },
        { "id": "13", "x": 1, "y": 22 },
        { "id": "11", "x": 0, "y": 23 },
        { "id": "13", "x": 1, "y": 23 },
        { "id": "10", "x": 2, "y": 23 },
        { "id": "13", "x": 2, "y": 24 },
        { "id": "9", "x": 3, "y": 24 },
        { "id": "9", "x": 4, "y": 24 },
        { "id": "9", "x": 5, "y": 24 },
        { "id": "9", "x": 6, "y": 24 },
        { "id": "9", "x": 7, "y": 24 },
        { "id": "9", "x": 8, "y": 24 },
        { "id": "9", "x": 9, "y": 24 },
        { "id": "9", "x": 10, "y": 24 },
        { "id": "9", "x": 11, "y": 24 },
        { "id": "9", "x": 12, "y": 24 },
        { "id": "9", "x": 13, "y": 24 },
        { "id": "9", "x": 14, "y": 24 },
        { "id": "9", "x": 15, "y": 24 },
        { "id": "9", "x": 16, "y": 24 },
        { "id": "9", "x": 17, "y": 24 },
        { "id": "9", "x": 18, "y": 24 },
        { "id": "9", "x": 19, "y": 24 },
        { "id": "9", "x": 20, "y": 24 },
        { "id": "9", "x": 21, "y": 24 },
        { "id": "9", "x": 22, "y": 24 },
        { "id": "9", "x": 23, "y": 24 },
        { "id": "9", "x": 24, "y": 24 },
        { "id": "9", "x": 25, "y": 24 },
        { "id": "9", "x": 26, "y": 24 },
        { "id": "9", "x": 27, "y": 24 },
        { "id": "9", "x": 28, "y": 24 },
        { "id": "9", "x": 29, "y": 24 },
        { "id": "9", "x": 30, "y": 24 },
        { "id": "11", "x": 0, "y": 24 },
        { "id": "13", "x": 1, "y": 24 },
        { "id": "11", "x": 0, "y": 25 },
        { "id": "14", "x": 0, "y": 26 },
        { "id": "8", "x": 1, "y": 26 },
        { "id": "8", "x": 2, "y": 26 },
        { "id": "8", "x": 3, "y": 26 },
        { "id": "8", "x": 4, "y": 26 },
        { "id": "8", "x": 5, "y": 26 },
        { "id": "8", "x": 6, "y": 26 },
        { "id": "8", "x": 7, "y": 26 },
        { "id": "8", "x": 8, "y": 26 },
        { "id": "8", "x": 9, "y": 26 },
        { "id": "8", "x": 10, "y": 26 },
        { "id": "8", "x": 11, "y": 26 },
        { "id": "8", "x": 12, "y": 26 },
        { "id": "8", "x": 13, "y": 26 },
        { "id": "8", "x": 14, "y": 26 },
        { "id": "8", "x": 15, "y": 26 },
        { "id": "8", "x": 16, "y": 26 },
        { "id": "8", "x": 17, "y": 26 },
        { "id": "8", "x": 18, "y": 26 },
        { "id": "8", "x": 19, "y": 26 },
        { "id": "8", "x": 20, "y": 26 },
        { "id": "8", "x": 21, "y": 26 },
        { "id": "8", "x": 22, "y": 26 },
        { "id": "8", "x": 23, "y": 26 },
        { "id": "8", "x": 24, "y": 26 },
        { "id": "8", "x": 25, "y": 26 },
        { "id": "8", "x": 26, "y": 26 },
        { "id": "8", "x": 27, "y": 26 },
        { "id": "8", "x": 28, "y": 26 },
        { "id": "8", "x": 29, "y": 26 },
        { "id": "8", "x": 30, "y": 26 },
        { "id": "13", "x": 1, "y": 25 },
        { "id": "13", "x": 2, "y": 25 },
        { "id": "13", "x": 3, "y": 25 },
        { "id": "13", "x": 4, "y": 25 },
        { "id": "13", "x": 5, "y": 25 },
        { "id": "13", "x": 6, "y": 25 },
        { "id": "13", "x": 7, "y": 25 },
        { "id": "13", "x": 8, "y": 25 },
        { "id": "13", "x": 9, "y": 25 },
        { "id": "13", "x": 10, "y": 25 },
        { "id": "13", "x": 11, "y": 25 },
        { "id": "13", "x": 12, "y": 25 },
        { "id": "13", "x": 13, "y": 25 },
        { "id": "13", "x": 14, "y": 25 },
        { "id": "13", "x": 15, "y": 25 },
        { "id": "13", "x": 16, "y": 25 },
        { "id": "13", "x": 17, "y": 25 },
        { "id": "13", "x": 18, "y": 25 },
        { "id": "13", "x": 19, "y": 25 },
        { "id": "13", "x": 20, "y": 25 },
        { "id": "13", "x": 21, "y": 25 },
        { "id": "13", "x": 22, "y": 25 },
        { "id": "13", "x": 23, "y": 25 },
        { "id": "13", "x": 24, "y": 25 },
        { "id": "13", "x": 25, "y": 25 },
        { "id": "13", "x": 26, "y": 25 },
        { "id": "13", "x": 27, "y": 25 },
        { "id": "13", "x": 28, "y": 25 },
        { "id": "13", "x": 29, "y": 25 },
        { "id": "13", "x": 30, "y": 25 },
        { "id": "11", "x": 32, "y": 4 },
        { "id": "10", "x": 34, "y": 4 },
        { "id": "11", "x": 32, "y": 5 },
        { "id": "10", "x": 34, "y": 5 },
        { "id": "11", "x": 32, "y": 6 },
        { "id": "10", "x": 34, "y": 6 },
        { "id": "11", "x": 32, "y": 7 },
        { "id": "10", "x": 34, "y": 7 },
        { "id": "10", "x": 34, "y": 8 },
        { "id": "10", "x": 34, "y": 9 },
        { "id": "10", "x": 34, "y": 10 },
        { "id": "10", "x": 34, "y": 11 },
        { "id": "11", "x": 32, "y": 12 },
        { "id": "10", "x": 34, "y": 12 },
        { "id": "11", "x": 32, "y": 13 },
        { "id": "10", "x": 34, "y": 13 },
        { "id": "11", "x": 32, "y": 14 },
        { "id": "10", "x": 34, "y": 14 },
        { "id": "11", "x": 32, "y": 15 },
        { "id": "10", "x": 34, "y": 15 },
        { "id": "11", "x": 32, "y": 16 },
        { "id": "10", "x": 34, "y": 16 },
        { "id": "11", "x": 32, "y": 17 },
        { "id": "10", "x": 34, "y": 17 },
        { "id": "11", "x": 32, "y": 18 },
        { "id": "10", "x": 34, "y": 18 },
        { "id": "11", "x": 32, "y": 19 },
        { "id": "10", "x": 34, "y": 19 },
        { "id": "11", "x": 32, "y": 20 },
        { "id": "10", "x": 34, "y": 20 },
        { "id": "11", "x": 32, "y": 21 },
        { "id": "10", "x": 34, "y": 21 },
        { "id": "11", "x": 32, "y": 22 },
        { "id": "10", "x": 34, "y": 22 },
        { "id": "11", "x": 32, "y": 23 },
        { "id": "10", "x": 34, "y": 23 },
        { "id": "9", "x": 31, "y": 24 },
        { "id": "13", "x": 32, "y": 24 },
        { "id": "10", "x": 34, "y": 24 },
        { "id": "13", "x": 31, "y": 25 },
        { "id": "8", "x": 31, "y": 26 },
        { "id": "13", "x": 32, "y": 25 },
        { "id": "8", "x": 32, "y": 26 },
        { "id": "10", "x": 34, "y": 25 },
        { "id": "8", "x": 33, "y": 26 },
        { "id": "12", "x": 34, "y": 26 },
        { "id": "13", "x": 33, "y": 4 },
        { "id": "13", "x": 33, "y": 5 },
        { "id": "13", "x": 33, "y": 6 },
        { "id": "13", "x": 33, "y": 7 },
        { "id": "13", "x": 33, "y": 8 },
        { "id": "13", "x": 33, "y": 9 },
        { "id": "13", "x": 33, "y": 10 },
        { "id": "13", "x": 33, "y": 11 },
        { "id": "13", "x": 33, "y": 12 },
        { "id": "13", "x": 33, "y": 13 },
        { "id": "13", "x": 33, "y": 14 },
        { "id": "13", "x": 33, "y": 15 },
        { "id": "13", "x": 33, "y": 16 },
        { "id": "13", "x": 33, "y": 17 },
        { "id": "13", "x": 33, "y": 18 },
        { "id": "13", "x": 33, "y": 19 },
        { "id": "13", "x": 33, "y": 20 },
        { "id": "13", "x": 33, "y": 21 },
        { "id": "13", "x": 33, "y": 22 },
        { "id": "13", "x": 33, "y": 23 },
        { "id": "13", "x": 33, "y": 24 },
        { "id": "13", "x": 33, "y": 25 },
        { "id": "9", "x": 2, "y": 0 },
        { "id": "9", "x": 3, "y": 0 },
        { "id": "9", "x": 4, "y": 0 },
        { "id": "9", "x": 5, "y": 0 },
        { "id": "9", "x": 6, "y": 0 },
        { "id": "9", "x": 7, "y": 0 },
        { "id": "9", "x": 8, "y": 0 },
        { "id": "9", "x": 9, "y": 0 },
        { "id": "9", "x": 10, "y": 0 },
        { "id": "9", "x": 11, "y": 0 },
        { "id": "9", "x": 12, "y": 0 },
        { "id": "9", "x": 13, "y": 0 },
        { "id": "9", "x": 14, "y": 0 },
        { "id": "9", "x": 15, "y": 0 },
        { "id": "9", "x": 16, "y": 0 },
        { "id": "9", "x": 17, "y": 0 },
        { "id": "9", "x": 18, "y": 0 },
        { "id": "9", "x": 19, "y": 0 },
        { "id": "9", "x": 20, "y": 0 },
        { "id": "9", "x": 21, "y": 0 },
        { "id": "9", "x": 22, "y": 0 },
        { "id": "9", "x": 23, "y": 0 },
        { "id": "9", "x": 24, "y": 0 },
        { "id": "9", "x": 25, "y": 0 },
        { "id": "9", "x": 26, "y": 0 },
        { "id": "9", "x": 27, "y": 0 },
        { "id": "9", "x": 28, "y": 0 },
        { "id": "9", "x": 29, "y": 0 },
        { "id": "9", "x": 30, "y": 0 },
        { "id": "9", "x": 31, "y": 0 },
        { "id": "9", "x": 32, "y": 0 },
        { "id": "15", "x": 0, "y": 0 },
        { "id": "9", "x": 1, "y": 0 },
        { "id": "9", "x": 33, "y": 0 },
        { "id": "16", "x": 34, "y": 0 },
        { "id": "11", "x": 0, "y": 1 },
        { "id": "11", "x": 0, "y": 2 },
        { "id": "11", "x": 0, "y": 3 },
        { "id": "13", "x": 1, "y": 2 },
        { "id": "13", "x": 1, "y": 3 },
        { "id": "13", "x": 2, "y": 2 },
        { "id": "10", "x": 2, "y": 3 },
        { "id": "8", "x": 3, "y": 2 },
        { "id": "8", "x": 4, "y": 2 },
        { "id": "8", "x": 5, "y": 2 },
        { "id": "8", "x": 6, "y": 2 },
        { "id": "8", "x": 7, "y": 2 },
        { "id": "8", "x": 8, "y": 2 },
        { "id": "8", "x": 9, "y": 2 },
        { "id": "8", "x": 10, "y": 2 },
        { "id": "8", "x": 11, "y": 2 },
        { "id": "8", "x": 12, "y": 2 },
        { "id": "8", "x": 13, "y": 2 },
        { "id": "8", "x": 14, "y": 2 },
        { "id": "8", "x": 15, "y": 2 },
        { "id": "8", "x": 16, "y": 2 },
        { "id": "8", "x": 17, "y": 2 },
        { "id": "8", "x": 18, "y": 2 },
        { "id": "8", "x": 19, "y": 2 },
        { "id": "8", "x": 20, "y": 2 },
        { "id": "8", "x": 21, "y": 2 },
        { "id": "8", "x": 22, "y": 2 },
        { "id": "8", "x": 23, "y": 2 },
        { "id": "8", "x": 24, "y": 2 },
        { "id": "8", "x": 25, "y": 2 },
        { "id": "8", "x": 26, "y": 2 },
        { "id": "8", "x": 27, "y": 2 },
        { "id": "8", "x": 28, "y": 2 },
        { "id": "8", "x": 29, "y": 2 },
        { "id": "8", "x": 30, "y": 2 },
        { "id": "8", "x": 31, "y": 2 },
        { "id": "13", "x": 32, "y": 2 },
        { "id": "11", "x": 32, "y": 3 },
        { "id": "10", "x": 34, "y": 1 },
        { "id": "13", "x": 33, "y": 2 },
        { "id": "10", "x": 34, "y": 2 },
        { "id": "13", "x": 33, "y": 3 },
        { "id": "10", "x": 34, "y": 3 },
        { "id": "13", "x": 1, "y": 1 },
        { "id": "13", "x": 2, "y": 1 },
        { "id": "13", "x": 3, "y": 1 },
        { "id": "13", "x": 4, "y": 1 },
        { "id": "13", "x": 5, "y": 1 },
        { "id": "13", "x": 6, "y": 1 },
        { "id": "13", "x": 7, "y": 1 },
        { "id": "13", "x": 8, "y": 1 },
        { "id": "13", "x": 9, "y": 1 },
        { "id": "13", "x": 10, "y": 1 },
        { "id": "13", "x": 11, "y": 1 },
        { "id": "13", "x": 12, "y": 1 },
        { "id": "13", "x": 13, "y": 1 },
        { "id": "13", "x": 14, "y": 1 },
        { "id": "13", "x": 15, "y": 1 },
        { "id": "13", "x": 16, "y": 1 },
        { "id": "13", "x": 17, "y": 1 },
        { "id": "13", "x": 18, "y": 1 },
        { "id": "13", "x": 19, "y": 1 },
        { "id": "13", "x": 20, "y": 1 },
        { "id": "13", "x": 21, "y": 1 },
        { "id": "13", "x": 22, "y": 1 },
        { "id": "13", "x": 23, "y": 1 },
        { "id": "13", "x": 24, "y": 1 },
        { "id": "13", "x": 25, "y": 1 },
        { "id": "13", "x": 26, "y": 1 },
        { "id": "13", "x": 27, "y": 1 },
        { "id": "13", "x": 28, "y": 1 },
        { "id": "13", "x": 29, "y": 1 },
        { "id": "13", "x": 30, "y": 1 },
        { "id": "13", "x": 31, "y": 1 },
        { "id": "13", "x": 32, "y": 1 },
        { "id": "13", "x": 33, "y": 1 },
        { "id": "16", "x": 27, "y": 18 },
        { "id": "12", "x": 27, "y": 19 },
        { "id": "9", "x": 25, "y": 18 },
        { "id": "9", "x": 26, "y": 18 },
        { "id": "8", "x": 25, "y": 19 },
        { "id": "8", "x": 26, "y": 19 },
        { "id": "9", "x": 17, "y": 14 },
        { "id": "8", "x": 17, "y": 15 },
        { "id": "9", "x": 16, "y": 14 },
        { "id": "8", "x": 16, "y": 15 },
        { "id": "10", "x": 2, "y": 12 },
        { "id": "10", "x": 2, "y": 9 },
        { "id": "13", "x": 2, "y": 10 },
        { "id": "13", "x": 2, "y": 11 },
        { "id": "9", "x": 3, "y": 10 },
        { "id": "8", "x": 3, "y": 11 },
        { "id": "9", "x": 4, "y": 10 },
        { "id": "8", "x": 4, "y": 11 },
        { "id": "9", "x": 5, "y": 10 },
        { "id": "8", "x": 5, "y": 11 },
        { "id": "9", "x": 6, "y": 10 },
        { "id": "8", "x": 6, "y": 11 },
        { "id": "9", "x": 7, "y": 10 },
        { "id": "8", "x": 7, "y": 11 },
        { "id": "9", "x": 15, "y": 14 },
        { "id": "8", "x": 15, "y": 15 },
        { "id": "11", "x": 32, "y": 8 },
        { "id": "13", "x": 32, "y": 9 },
        { "id": "13", "x": 32, "y": 10 },
        { "id": "11", "x": 32, "y": 11 },
        { "id": "9", "x": 31, "y": 9 },
        { "id": "8", "x": 31, "y": 10 },
        { "id": "9", "x": 30, "y": 9 },
        { "id": "8", "x": 30, "y": 10 },
        { "id": "9", "x": 29, "y": 9 },
        { "id": "8", "x": 29, "y": 10 },
        { "id": "9", "x": 28, "y": 9 },
        { "id": "8", "x": 28, "y": 10 },
        { "id": "15", "x": 26, "y": 9 },
        { "id": "9", "x": 27, "y": 9 },
        { "id": "14", "x": 26, "y": 10 },
        { "id": "8", "x": 27, "y": 10 },
        { "id": "9", "x": 18, "y": 14 },
        { "id": "8", "x": 18, "y": 15 },
        { "id": "9", "x": 19, "y": 14 },
        { "id": "8", "x": 19, "y": 15 },
        { "id": "15", "x": 13, "y": 14 },
        { "id": "9", "x": 14, "y": 14 },
        { "id": "14", "x": 13, "y": 15 },
        { "id": "8", "x": 14, "y": 15 },
        { "id": "9", "x": 8, "y": 10 },
        { "id": "16", "x": 9, "y": 10 },
        { "id": "8", "x": 8, "y": 11 },
        { "id": "12", "x": 9, "y": 11 },
        { "id": "9", "x": 20, "y": 14 },
        { "id": "8", "x": 20, "y": 15 },
        { "id": "8", "x": 24, "y": 19 },
        { "id": "9", "x": 24, "y": 18 },
        { "id": "9", "x": 21, "y": 14 },
        { "id": "9", "x": 22, "y": 14 },
        { "id": "16", "x": 23, "y": 14 },
        { "id": "8", "x": 21, "y": 15 },
        { "id": "13", "x": 22, "y": 15 },
        { "id": "10", "x": 23, "y": 15 },
        { "id": "11", "x": 22, "y": 16 },
        { "id": "10", "x": 23, "y": 16 },
        { "id": "11", "x": 22, "y": 17 },
        { "id": "10", "x": 23, "y": 17 },
        { "id": "11", "x": 22, "y": 18 },
        { "id": "13", "x": 23, "y": 18 },
        { "id": "14", "x": 22, "y": 19 },
        { "id": "8", "x": 23, "y": 19 },
      ],
      "collider": false,
    },
  ],
}
