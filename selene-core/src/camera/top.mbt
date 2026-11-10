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
pub(all) struct CameraViewport {
  position : @math.Vec2
  size : @math.Vec2
}

///|
pub fn CameraViewport::CameraViewport(
  position : @math.Vec2,
  size : @math.Vec2,
) -> CameraViewport {
  let width = if size.x < 0.0 { 0.0 } else { size.x }
  let height = if size.y < 0.0 { 0.0 } else { size.y }
  { position, size: Vec2(width, height), }
}

///|
pub fn CameraViewport::from_rect(rect : @math.Rect) -> CameraViewport {
  CameraViewport(rect.position, rect.size)
}

///|
pub fn CameraViewport::rect(self : CameraViewport) -> @math.Rect {
  { position: self.position, size: self.size, }
}

///|
#derive(Eq, Debug)
pub(all) enum CameraPassLoadOp2D {
  Load
  Clear
}

///|
#derive(Eq, Debug)
pub(all) enum CameraPassTarget2D {
  Screen
  Offscreen(String)
}

///|
#derive(Eq, Debug)
pub(all) struct CameraPass2D {
  load_op : CameraPassLoadOp2D
  clear_color : @render.Color
  target : CameraPassTarget2D
}

///|
fn default_camera_clear_color() -> @render.Color {
  { r: 0U, g: 0U, b: 0U, a: 1.0, }
}

///|
pub fn CameraPass2D::CameraPass2D(
  load_op~ : CameraPassLoadOp2D = Load,
  clear_color~ : @render.Color = default_camera_clear_color(),
  target~ : CameraPassTarget2D = Screen,
) -> CameraPass2D {
  { load_op, clear_color, target, }
}

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
#derive(Eq, Debug)
#selene.component
pub(all) struct Camera2d {}

///|
pub fn Camera2d::Camera2d() -> Camera2d {
  Camera2d::{ }
}

///|
pub impl Default for Camera2d with fn default() -> Camera2d {
  Camera2d()
}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct OrthographicProjection {
  near : Double
  far : Double
  scale : Double
}

///|
pub fn OrthographicProjection::OrthographicProjection(
  scale~ : Double = 1.0,
  near~ : Double = -1000.0,
  far~ : Double = 1000.0,
) -> OrthographicProjection {
  { near, far, scale: projection_scale(scale), }
}

///|
pub impl Default for OrthographicProjection with fn default() -> OrthographicProjection {
  OrthographicProjection()
}

///|
pub fn cameras() -> @ecs.ComponentStore[Camera] {
  @ecs.components()
}

///|
pub fn camera2ds() -> @ecs.ComponentStore[Camera2d] {
  @ecs.components()
}

///|
pub fn orthographic_projections() -> @ecs.ComponentStore[OrthographicProjection] {
  @ecs.components()
}

///|
fn projection_scale(scale : Double) -> Double {
  if scale <= 0.0 || !scale.is_finite() {
    1.0
  } else {
    scale
  }
}

///|
fn full_screen_viewport_rect() -> @math.Rect {
  { position: @math.Vec2::zero(), size: @system.get_screen_size(), }
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
) -> @math.Affine2 {
  let world_units_per_pixel = projection_scale(projection.scale) /
    @system.get_zoom()
  let center = viewport.position + viewport.size.scalar_mul(0.5)
  camera_transform.affine.project_xy() *
  @math.Affine2::from_scale(world_units_per_pixel, world_units_per_pixel) *
  @math.Affine2::from_translation(-center.x, -center.y)
}

///|
/// Projects onto the viewport. Returns None if the camera's XY plane collapses.
pub fn Camera::world_to_viewport(
  self : Camera,
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  world_position : @math.Vec2,
) -> @math.Vec2? {
  viewport_to_world_affine(camera_transform, projection, self.viewport_rect())
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
  viewport_to_world_affine(camera_transform, projection, self.viewport_rect()).transform_point(
    viewport_position,
  )
}

///|
test "camera world_to_viewport roundtrip" {
  @system.configure_display(480.0, 320.0, 2.0)
  let camera = Camera()
  let projection = OrthographicProjection()
  let camera_transform = @transform.GlobalTransform::from_transform(
    @transform.Transform::from_xyz(100.0, 50.0, 0.0),
  )
  let world = @math.Vec2(132.5, 64.0)
  let viewport = camera
    .world_to_viewport(camera_transform, projection, world)
    .unwrap()
  let world2 = camera.viewport_to_world_2d(
    camera_transform, projection, viewport,
  )
  assert_eq(world2.x, world.x)
  assert_eq(world2.y, world.y)
}

///|
test "camera world_to_viewport respects camera rotation" {
  @system.configure_display(100.0, 100.0, 1.0)
  let camera = Camera()
  let projection = OrthographicProjection()
  let quarter_turn = @math.Rotation3::from_axis_angle(
    @math.Vec3::z_axis(),
    1.5707963267948966,
  )
  let camera_transform = @transform.GlobalTransform::from_transform({
    translation: Vec3(0.0, 0.0, 0.0),
    rotation: quarter_turn,
    scale: @math.Vec3::one(),
  })
  let viewport = camera
    .world_to_viewport(camera_transform, projection, Vec2(0.0, 10.0))
    .unwrap()
  assert_eq(viewport.x, 60.0)
  assert_eq(viewport.y, 50.0)
}

///|
test "camera viewport offsets world_to_viewport into viewport rect" {
  @system.configure_display(200.0, 120.0, 1.0)
  let camera = Camera(
    viewport=Some(CameraViewport(Vec2(20.0, 10.0), Vec2(80.0, 40.0))),
  )
  let projection = OrthographicProjection()
  let camera_transform = @transform.GlobalTransform::from_transform(
    @transform.Transform::default(),
  )
  let viewport = camera
    .world_to_viewport(camera_transform, projection, @math.Vec2::zero())
    .unwrap()
  assert_eq(viewport.x, 60.0)
  assert_eq(viewport.y, 30.0)
  let world = camera.viewport_to_world_2d(
    camera_transform, projection, viewport,
  )
  assert_eq(world.x, 0.0)
  assert_eq(world.y, 0.0)
}

///|
test "camera viewport projection inverts the same XY plane it draws" {
  @system.configure_display(100.0, 100.0, 1.0)
  let camera = Camera()
  let projection = OrthographicProjection()
  let pose = @transform.GlobalTransform::from_transform(
    @transform.Transform::from_rotation(
      @math.Rotation3::from_axis_angle(@math.Vec3::x_axis(), 0.7),
    ).with_translation(Vec3(1.0, 2.0, 3.0)),
  )
  let world = @math.Vec2(3.0, 5.0)
  let viewport = camera.world_to_viewport(pose, projection, world).unwrap()
  assert_true(
    camera.viewport_to_world_2d(pose, projection, viewport).distance(world) <
    1.0e-10,
  )
  let collapsed = @transform.GlobalTransform::from_transform(
    @transform.Transform::from_scale(Vec3(0.0, 1.0, 1.0)),
  )
  assert_true(camera.world_to_viewport(collapsed, projection, world) is None)
}
