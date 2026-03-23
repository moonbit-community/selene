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
  mut viewport_size : @math.Vec2D
  mut screen_size : @math.Vec2D
  mut zoom : Double
  mut render_alpha : Double
}

///|
let display_world_states : Map[UInt, DisplayState] = Map::new()

///|
fn display_state() -> DisplayState {
  let world_id = @ecs.require_current_world().id()
  display_world_states.get_or_init(world_id, () => {
    viewport_size: @math.Vec2D(512.0, 256.0),
    screen_size: @math.Vec2D(512.0, 256.0),
    zoom: 1.0,
    render_alpha: 1.0,
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
  state.viewport_size = @math.Vec2D(viewport_width, viewport_height)
  state.screen_size = @math.Vec2D(viewport_width * zoom, viewport_height * zoom)
  state.zoom = zoom
  state.render_alpha = 1.0
}

///|
pub fn get_viewport_size() -> @math.Vec2D {
  display_state().viewport_size
}

///|
pub fn get_screen_size() -> @math.Vec2D {
  display_state().screen_size
}

///|
pub fn get_zoom() -> Double {
  display_state().zoom
}

///|
pub fn set_render_alpha(alpha : Double) -> Unit {
  let state = display_state()
  state.render_alpha = @cmp.maximum(0.0, @cmp.minimum(1.0, alpha))
}

///|
pub fn get_render_alpha() -> Double {
  display_state().render_alpha
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
pub fn scale_vec2(vec : @math.Vec2D) -> @math.Vec2D {
  @math.Vec2D(scale_value(vec[X]), scale_value(vec[Y]))
}

///|
pub fn unscale_vec2(vec : @math.Vec2D) -> @math.Vec2D {
  @math.Vec2D(unscale_value(vec[X]), unscale_value(vec[Y]))
}

///|
pub fn scale_transform_translation(
  transform : @math.Transform,
) -> @math.Transform {
  { ..transform, tx: scale_value(transform.tx), ty: scale_value(transform.ty) }
}

///|
pub fn ui_virtual_to_screen(pos : @math.Vec2D) -> @math.Vec2D {
  scale_vec2(pos)
}

///|
pub fn screen_to_ui_virtual(pos : @math.Vec2D) -> @math.Vec2D {
  unscale_vec2(pos)
}

///|
test "scale transform translation only" {
  configure_display(480.0, 320.0, 2.0)
  let transformed = scale_transform_translation(
    @math.Transform::new(a=1.2, b=0.3, c=0.4, d=1.1, tx=10.0, ty=20.0),
  )
  assert_eq(transformed.a, 1.2)
  assert_eq(transformed.b, 0.3)
  assert_eq(transformed.c, 0.4)
  assert_eq(transformed.d, 1.1)
  assert_eq(transformed.tx, 20.0)
  assert_eq(transformed.ty, 40.0)
}
