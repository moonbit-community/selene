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

///| Body type enumeration
pub(all) enum BodyType {
  Static // Mass = 0, velocity = 0, no collision response
  Kinematic // Mass = 0, velocity set by user, no collision response  
  Dynamic // Mass > 0, velocity computed by solver
} derive(Show, Eq)

///| Shape type enumeration
pub(all) enum ShapeType {
  Circle
  Polygon
} derive(Show, Eq)

///| Shape definition for creating shapes
pub(all) enum ShapeDef {
  Circle(Double, @smath.Vec2D)
  Box(Double, Double, @smath.Vec2D, Double)
  Polygon(Array[@smath.Vec2D])
} derive(Show)

///| Body definition for creating bodies
pub struct BodyDef {
  body_type : BodyType
  position : @smath.Vec2D
  angle : Double
  linear_velocity : @smath.Vec2D
  angular_velocity : Double
  linear_damping : Double
  angular_damping : Double
  gravity_scale : Double
  user_data : Int // Can store entity ID or other data
} derive(Show)

///| Default body definition
pub fn BodyDef::default() -> BodyDef {
  {
    body_type: Dynamic,
    position: @smath.Vec2D(0.0, 0.0),
    angle: 0.0,
    linear_velocity: @smath.Vec2D(0.0, 0.0),
    angular_velocity: 0.0,
    linear_damping: 0.0,
    angular_damping: 0.0,
    gravity_scale: 1.0,
    user_data: 0,
  }
}

///|
test "BodyDef::default should create reasonable defaults" {
  let def = BodyDef::default()
  assert_true(def.body_type == Dynamic)
  assert_true(def.position[X] == 0.0 && def.position[Y] == 0.0)
  assert_true(def.angle == 0.0)
  assert_true(def.linear_velocity[X] == 0.0 && def.linear_velocity[Y] == 0.0)
  assert_true(def.angular_velocity == 0.0)
  assert_true(def.linear_damping == 0.0)
  assert_true(def.angular_damping == 0.0)
  assert_true(def.gravity_scale == 1.0)
  assert_true(def.user_data == 0)
}

///| Physics shape
pub struct PhysicsShape {
  shape_type : ShapeType
  // Shape-specific data
  radius : Double // For circles
  vertices : Array[@smath.Vec2D] // For polygons (in local coordinates)
  normals : Array[@smath.Vec2D] // For polygons (outward normals)
  centroid : @smath.Vec2D // Center of mass
  // Material properties
  density : Double
  friction : Double
  restitution : Double
} derive(Show)

///| Physics body
pub struct PhysicsBody {
  id : Int
  body_type : BodyType

  // Transform
  mut position : @smath.Vec2D
  mut angle : Double
  mut transform : PhysicsTransform

  // Velocity
  mut linear_velocity : @smath.Vec2D
  mut angular_velocity : Double

  // Forces
  mut force : @smath.Vec2D
  mut torque : Double

  // Mass properties
  mut mass : Double
  mut inv_mass : Double
  mut inertia : Double
  mut inv_inertia : Double

  // Damping
  linear_damping : Double
  angular_damping : Double
  gravity_scale : Double

  // Shapes attached to this body
  shapes : Array[PhysicsShape]

  // User data (can store Entity ID)
  user_data : Int

  // Internal flags
  is_awake : Bool
  is_enabled : Bool
} derive(Show)

///| Contact manifold point
pub struct ManifoldPoint {
  local_point : @smath.Vec2D // Local contact point on shape A
  normal_impulse : Double // Accumulated normal impulse
  tangent_impulse : Double // Accumulated tangent impulse
  id : Int // Contact ID for warm starting
} derive(Show)

///| Contact manifold
pub struct Manifold {
  points : Array[ManifoldPoint]
  local_normal : @smath.Vec2D // Normal vector in local coordinates of shape A
  local_point : @smath.Vec2D // Contact point in local coordinates of shape A
  point_count : Int // Number of contact points
} derive(Show)

///| World definition for creating physics world
pub struct WorldDef {
  gravity : @smath.Vec2D
  contact_hertz : Double
  contact_damping_ratio : Double
  max_linear_velocity : Double
  max_angular_velocity : Double
} derive(Show)

///| Default world definition
pub fn WorldDef::default() -> WorldDef {
  {
    gravity: @smath.Vec2D(0.0, 98.0), // Positive Y = downward in screen coordinates
    contact_hertz: 30.0,
    contact_damping_ratio: 0.7,
    max_linear_velocity: 200.0,
    max_angular_velocity: 250.0,
  }
}

///|
test "WorldDef::default should create reasonable defaults" {
  let def = WorldDef::default()
  assert_true(def.gravity[X] == 0.0 && def.gravity[Y] == 98.0)
  assert_true(def.contact_hertz == 30.0)
  assert_true(def.contact_damping_ratio == 0.7)
  assert_true(def.max_linear_velocity == 200.0)
  assert_true(def.max_angular_velocity == 250.0)
}

///|
test "ShapeDef variants should construct correctly" {
  // Test Circle variant
  let circle = ShapeDef::Circle(1.0, @smath.Vec2D(0.0, 0.0))
  match circle {
    ShapeDef::Circle(radius, center) => {
      assert_true(radius == 1.0)
      assert_true(center[X] == 0.0 && center[Y] == 0.0)
    }
    _ => assert_true(false)
  }

  // Test Box variant  
  let box = ShapeDef::Box(2.0, 1.0, @smath.Vec2D(1.0, 1.0), 0.0)
  match box {
    ShapeDef::Box(width, height, center, angle) => {
      assert_true(width == 2.0)
      assert_true(height == 1.0)
      assert_true(center[X] == 1.0 && center[Y] == 1.0)
      assert_true(angle == 0.0)
    }
    _ => assert_true(false)
  }

  // Test Polygon variant
  let vertices = [
    @smath.Vec2D(0.0, 0.0),
    @smath.Vec2D(1.0, 0.0),
    @smath.Vec2D(0.0, 1.0),
  ]
  let polygon = ShapeDef::Polygon(vertices)
  match polygon {
    ShapeDef::Polygon(verts) => {
      assert_true(verts.length() == 3)
      assert_true(verts[0][X] == 0.0 && verts[0][Y] == 0.0)
    }
    _ => assert_true(false)
  }
}

///|
test "ManifoldPoint should construct correctly" {
  let point = ManifoldPoint::{
    local_point: @smath.Vec2D(1.0, 2.0),
    normal_impulse: 5.0,
    tangent_impulse: 3.0,
    id: 42,
  }
  assert_true(point.local_point[X] == 1.0 && point.local_point[Y] == 2.0)
  assert_true(point.normal_impulse == 5.0)
  assert_true(point.tangent_impulse == 3.0)
  assert_true(point.id == 42)
}

///|
test "Manifold should construct correctly" {
  let point1 = ManifoldPoint::{
    local_point: @smath.Vec2D(0.0, 0.0),
    normal_impulse: 1.0,
    tangent_impulse: 0.5,
    id: 1,
  }
  let point2 = ManifoldPoint::{
    local_point: @smath.Vec2D(1.0, 1.0),
    normal_impulse: 2.0,
    tangent_impulse: 1.0,
    id: 2,
  }
  let manifold = Manifold::{
    points: [point1, point2],
    local_normal: @smath.Vec2D(0.0, 1.0),
    local_point: @smath.Vec2D(0.5, 0.5),
    point_count: 2,
  }
  assert_true(manifold.points.length() == 2)
  assert_true(
    manifold.local_normal[X] == 0.0 && manifold.local_normal[Y] == 1.0,
  )
  assert_true(manifold.local_point[X] == 0.5 && manifold.local_point[Y] == 0.5)
  assert_true(manifold.point_count == 2)
}
