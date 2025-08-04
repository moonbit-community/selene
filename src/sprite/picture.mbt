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
pub(all) struct Picture {
  size : @math.Vec2D
  tile_path : String
  transform : @math.Transform
  repeat : Bool
}

///|
pub fn Picture::new(
  size : @math.Vec2D,
  tile_path : String,
  transform~ : @math.Transform = @math.Transform::new(),
  repeat~ : Bool = false,
) -> Picture {
  { size, tile_path, transform, repeat }
}

///|
fn render_picture(
  backend : &@system.Backend,
  picture : Picture,
  pos : @math.Vec2D,
) -> Unit {
  backend.draw_picture(
    picture.tile_path,
    x=pos.x,
    y=pos.y,
    width=picture.size.x,
    height=picture.size.y,
    repeat=picture.repeat,
    transform=picture.transform,
  )
}
