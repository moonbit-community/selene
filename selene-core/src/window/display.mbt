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
priv struct DisplayState {
  mut viewport_size : @math.Vec2
  mut screen_size : @math.Vec2
  mut zoom : Double
}

///|
let display_state_key : @ecs.ResourceKey[DisplayState] = ResourceKey()

///|
fn display_state() -> DisplayState {
  display_state_key.get_or_insert_with(@ecs.require_current_world(), _ => {
    viewport_size: Vec2(512.0, 256.0),
    screen_size: Vec2(512.0, 256.0),
    zoom: 1.0,
  })
}

///|
fn positive_zoom(zoom : Double) -> Double {
  if zoom <= 0.0 {
    1.0
  } else {
    zoom
  }
}

///|
pub fn configure_display(
  viewport_width : Double,
  viewport_height : Double,
  zoom : Double,
) -> Unit {
  let state = display_state()
  let zoom = positive_zoom(zoom)
  state.viewport_size = Vec2(viewport_width, viewport_height)
  state.screen_size = Vec2(viewport_width * zoom, viewport_height * zoom)
  state.zoom = zoom
}

///|
pub fn get_viewport_size() -> @math.Vec2 {
  display_state().viewport_size
}

///|
pub fn get_screen_size() -> @math.Vec2 {
  display_state().screen_size
}

///|
pub fn get_zoom() -> Double {
  display_state().zoom
}

///|
pub fn scale_value(value : Double) -> Double {
  value * display_state().zoom
}

///|
pub fn unscale_value(value : Double) -> Double {
  value / display_state().zoom
}

///|
pub fn scale_vec2(vec : @math.Vec2) -> @math.Vec2 {
  Vec2(scale_value(vec.x), scale_value(vec.y))
}

///|
pub fn unscale_vec2(vec : @math.Vec2) -> @math.Vec2 {
  Vec2(unscale_value(vec.x), unscale_value(vec.y))
}

///|
pub fn scale_transform_translation(transform : @math.Affine2) -> @math.Affine2 {
  { ..transform, tx: scale_value(transform.tx), ty: scale_value(transform.ty), }
}

///|
pub fn ui_virtual_to_screen(pos : @math.Vec2) -> @math.Vec2 {
  scale_vec2(pos)
}

///|
pub fn screen_to_ui_virtual(pos : @math.Vec2) -> @math.Vec2 {
  unscale_vec2(pos)
}
