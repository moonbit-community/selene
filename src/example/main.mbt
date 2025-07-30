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
fn main {
  let app = @selene.App::new(@canvas.CanvasBackend::new())
    .with_canvas_width(800.0)
    .with_canvas_height(600.0)
    .add_system(game_start)
    .add_system(game_loop)
    .add_render_pipe(@selene.render_fill_rect)
  app.run()
}

///|
fn game_loop(_ : &@selene.Backend) -> Unit {

}

///|
fn game_start(_ : &@selene.Backend) -> Unit {
  @selene.FillRect::set(@selene.Entity::new(), background)
}

///|
let background : @selene.FillRect = {
  pos: @selene.Vec2D::new(0.0, 0.0),
  width: 800.0,
  height: 600.0,
  tile_path: "src/example/pixel_adventure/Background/Gray.png",
}
