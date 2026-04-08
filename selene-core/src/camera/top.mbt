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
pub(all) struct Camera {
  mut is_active : Bool
  order : Int

  fn new(is_active? : Bool, order? : Int) -> Camera
} derive(Eq, Debug)

///|
pub fn Camera::new(is_active? : Bool = true, order? : Int = 0) -> Camera {
  { is_active, order }
}

///|
pub impl Default for Camera with default() -> Camera {
  Camera::new()
}

///|
pub(all) struct Camera2d {

  fn new() -> Camera2d
} derive(Eq, Debug)

///|
pub fn Camera2d::new() -> Camera2d {
  Camera2d::{  }
}

///|
pub impl Default for Camera2d with default() -> Camera2d {
  Camera2d::new()
}

///|
pub(all) struct OrthographicProjection {
  near : Double
  far : Double
  scale : Double

  fn new(
    scale? : Double,
    near? : Double,
    far? : Double,
  ) -> OrthographicProjection
} derive(Eq, Debug)

///|
pub fn OrthographicProjection::new(
  scale? : Double = 1.0,
  near? : Double = -1000.0,
  far? : Double = 1000.0,
) -> OrthographicProjection {
  { near, far, scale: projection_scale(scale) }
}

///|
pub impl Default for OrthographicProjection with default() -> OrthographicProjection {
  OrthographicProjection::new()
}

///|
priv struct CameraWorldStore {
  cameras : Map[@entity.Entity, Camera]
  camera2ds : Map[@entity.Entity, Camera2d]
  orthographic_projections : Map[@entity.Entity, OrthographicProjection]
}

///|
let camera_world_stores : Map[UInt, CameraWorldStore] = Map::new()

///|
fn camera_world_store() -> CameraWorldStore {
  let world_id = @ecs.require_current_world().id()
  camera_world_stores.get_or_init(world_id, () => {
    cameras: Map::new(),
    camera2ds: Map::new(),
    orthographic_projections: Map::new(),
  })
}

///|
pub fn cameras() -> Map[@entity.Entity, Camera] {
  camera_world_store().cameras
}

///|
pub fn camera2ds() -> Map[@entity.Entity, Camera2d] {
  camera_world_store().camera2ds
}

///|
pub fn orthographic_projections() -> Map[@entity.Entity, OrthographicProjection] {
  camera_world_store().orthographic_projections
}

///|
fn projection_scale(scale : Double) -> Double {
  if scale <= 0.0 {
    1.0
  } else {
    scale
  }
}

///|
pub fn Camera::world_to_viewport(
  _self : Camera,
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  world_position : @math.Vec2D,
) -> @math.Vec2D {
  let world_point = @math.Vec3::new(world_position[X], world_position[Y], 0.0)
  let view_point = match camera_transform.affine.inverse() {
    Some(inverse_camera) => inverse_camera.transform_point3(world_point)
    None => world_point
  }
  let pixels_per_world_unit = @system.get_zoom() /
    projection_scale(projection.scale)
  let viewport_center = @system.get_screen_size().scalar_mul(0.5)
  @math.Vec2D(
    viewport_center[X] + view_point.x * pixels_per_world_unit,
    viewport_center[Y] + view_point.y * pixels_per_world_unit,
  )
}

///|
pub fn Camera::viewport_to_world_2d(
  _self : Camera,
  camera_transform : @transform.GlobalTransform,
  projection : OrthographicProjection,
  viewport_position : @math.Vec2D,
) -> @math.Vec2D {
  let pixels_per_world_unit = @system.get_zoom() /
    projection_scale(projection.scale)
  let viewport_center = @system.get_screen_size().scalar_mul(0.5)
  let view_point = @math.Vec3::new(
    (viewport_position[X] - viewport_center[X]) / pixels_per_world_unit,
    (viewport_position[Y] - viewport_center[Y]) / pixels_per_world_unit,
    0.0,
  )
  let world_point = camera_transform.transform_point(view_point)
  @math.Vec2D(world_point.x, world_point.y)
}

///|
test "camera world_to_viewport roundtrip" {
  @system.configure_display(480.0, 320.0, 2.0)
  let camera = Camera::new()
  let projection = OrthographicProjection::new()
  let camera_transform = @transform.GlobalTransform::from_transform(
    @transform.Transform::from_xyz(100.0, 50.0, 0.0),
  )
  let world = @math.Vec2D(132.5, 64.0)
  let viewport = camera.world_to_viewport(camera_transform, projection, world)
  let world2 = camera.viewport_to_world_2d(
    camera_transform, projection, viewport,
  )
  assert_eq(world2[X], world[X])
  assert_eq(world2[Y], world[Y])
}

///|
test "camera world_to_viewport respects camera rotation" {
  @system.configure_display(100.0, 100.0, 1.0)
  let camera = Camera::new()
  let projection = OrthographicProjection::new()
  let quarter_turn = @math.Quat::from_axis_angle(
    @math.Vec3::z_axis(),
    1.5707963267948966,
  )
  let camera_transform = @transform.GlobalTransform::from_transform({
    translation: @math.Vec3::new(0.0, 0.0, 0.0),
    rotation: quarter_turn,
    scale: @math.Vec3::one(),
  })
  let viewport = camera.world_to_viewport(
    camera_transform,
    projection,
    @math.Vec2D(0.0, 10.0),
  )
  assert_eq(viewport[X], 60.0)
  assert_eq(viewport[Y], 50.0)
}
