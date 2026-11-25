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
#derive(Eq, Debug)
#selene.component
pub(all) struct Camera {
  mut is_active : Bool
  order : Int32
  viewport : CameraViewport?
  pass : CameraPass2D
}

///|
pub extend Camera with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Camera with Eq::{not_equal, equal}

///|
pub fn Camera::Camera(
  is_active~ : Bool = true,
  order~ : Int32 = 0,
  viewport~ : CameraViewport? = None,
  pass~ : CameraPass2D = CameraPass2D(),
) -> Camera {
  { is_active, order, viewport, pass, }
}

///|
pub impl Default for Camera with fn default() -> Camera {
  Camera()
}

///|
pub extend Camera with Default::{default}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Camera2d {}

///|
pub extend Camera2d with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Camera2d with Eq::{not_equal, equal}

///|
pub fn Camera2d::Camera2d() -> Camera2d {
  Camera2d::{ }
}

///|
pub impl Default for Camera2d with fn default() -> Camera2d {
  Camera2d()
}

///|
pub extend Camera2d with Default::{default}

///|
fn full_screen_viewport_rect() -> @math.Rect {
  { position: @math.Vec2::zero(), size: @window.get_screen_size(), }
}

///|
pub fn Camera::viewport_rect(self : Camera) -> @math.Rect {
  self.viewport.map_or(full_screen_viewport_rect(), fn(viewport) {
    viewport.rect()
  })
}

///|
pub fn Camera::with_viewport(
  self : Camera,
  viewport : CameraViewport?,
) -> Camera {
  { ..self, viewport, }
}

///|
pub fn Camera::with_pass(self : Camera, pass : CameraPass2D) -> Camera {
  { ..self, pass, }
}

///|
pub fn Camera::contains_screen_point(self : Camera, point : @math.Vec2) -> Bool {
  let viewport = self.viewport_rect()
  point.x >= viewport.position.x &&
  point.x <= viewport.position.x + viewport.size.x &&
  point.y >= viewport.position.y &&
  point.y <= viewport.position.y + viewport.size.y
}

///|
fn viewport_to_world_affine(
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  viewport : @math.Rect,
  zoom : Double,
) -> @math.Affine2 {
  let world_units_per_pixel = projection_scale(projection.scale) / zoom
  let center = viewport.position + viewport.size.scalar_mul(0.5)
  camera_transform.affine.project_xy() *
  @math.Affine2::from_scale(Vec2(world_units_per_pixel, world_units_per_pixel)) *
  @math.Affine2::from_translation(Vec2(-center.x, -center.y))
}

///|
/// Projects onto the viewport. Returns None if the camera's XY plane collapses.
pub fn Camera::world_to_viewport(
  self : Camera,
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  world_position : @math.Vec2,
) -> @math.Vec2? {
  viewport_to_world_affine(
    camera_transform,
    projection,
    self.viewport_rect(),
    @window.get_zoom(),
  )
  .inverse()
  .map(transform => transform.transform_point(world_position))
}

///|
pub fn Camera::viewport_to_world_2d(
  self : Camera,
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  viewport_position : @math.Vec2,
) -> @math.Vec2 {
  viewport_to_world_affine(
    camera_transform,
    projection,
    self.viewport_rect(),
    @window.get_zoom(),
  ).transform_point(viewport_position)
}
