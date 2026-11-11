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
