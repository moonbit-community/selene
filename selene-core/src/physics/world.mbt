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

///| Global physics world - using singleton pattern for ECS integration
pub let physics_world : Ref[PhysicsWorld] = {
  val: PhysicsWorld::new(WorldDef::default()),
}

///| Physics world class
pub struct PhysicsWorld {
  gravity : @smath.Vec2D
  contact_hertz : Double
  contact_damping_ratio : Double
  max_linear_velocity : Double
  max_angular_velocity : Double

  // Bodies storage
  bodies : Array[PhysicsBody]
  mut body_id_counter : Int

  // Time stepping
  mut dt : Double
  mut sub_step_count : Int
} derive(Show)

///| Create new physics world
pub fn PhysicsWorld::new(def : WorldDef) -> PhysicsWorld {
  {
    gravity: def.gravity,
    contact_hertz: def.contact_hertz,
    contact_damping_ratio: def.contact_damping_ratio,
    max_linear_velocity: def.max_linear_velocity,
    max_angular_velocity: def.max_angular_velocity,
    bodies: [],
    body_id_counter: 0,
    dt: 0.0,
    sub_step_count: 1,
  }
}

///| Create a physics body in the world
pub fn PhysicsWorld::create_body(self : PhysicsWorld, def : BodyDef) -> Int {
  let body_id = self.body_id_counter
  self.body_id_counter += 1
  let inv_mass = if def.body_type == Dynamic { 1.0 } else { 0.0 }
  let inv_inertia = if def.body_type == Dynamic { 1.0 } else { 0.0 }
  let body = PhysicsBody::{
    id: body_id,
    body_type: def.body_type,
    position: def.position,
    angle: def.angle,
    transform: PhysicsTransform::new(def.position, Rot::new(def.angle)),
    linear_velocity: def.linear_velocity,
    angular_velocity: def.angular_velocity,
    force: @smath.Vec2D(0.0, 0.0),
    torque: 0.0,
    mass: 1.0,
    inv_mass,
    inertia: 1.0,
    inv_inertia,
    linear_damping: def.linear_damping,
    angular_damping: def.angular_damping,
    gravity_scale: def.gravity_scale,
    shapes: [],
    user_data: def.user_data,
    is_awake: true,
    is_enabled: true,
  }
  self.bodies.push(body)
  body_id
}

///| Get body by ID
pub fn PhysicsWorld::get_body(
  self : PhysicsWorld,
  body_id : Int,
) -> PhysicsBody? {
  for body in self.bodies {
    if body.id == body_id {
      return Some(body)
    }
  }
  None
}

///| Add shape to a body
pub fn PhysicsWorld::add_shape_to_body(
  self : PhysicsWorld,
  body_id : Int,
  shape_def : ShapeDef,
) -> Bool {
  for i in 0..<self.bodies.length() {
    if self.bodies[i].id == body_id {
      let shape = create_shape(shape_def)
      self.bodies[i].shapes.push(shape)
      // Recalculate mass properties
      self.recalculate_mass_properties(i)
      return true
    }
  }
  false
}

///| Create a shape from definition
fn create_shape(def : ShapeDef) -> PhysicsShape {
  match def {
    Circle(radius, center) =>
      PhysicsShape::{
        shape_type: Circle,
        radius,
        vertices: [center],
        normals: [],
        centroid: center,
        density: 1.0,
        friction: 0.3,
        restitution: 0.0,
      }
    Box(width, height, center, angle) => {
      let hw = width / 2.0
      let hh = height / 2.0
      let vertices = [
        @smath.Vec2D(-hw, -hh),
        @smath.Vec2D(hw, -hh),
        @smath.Vec2D(hw, hh),
        @smath.Vec2D(-hw, hh),
      ]

      // Transform vertices by angle and center
      let rot = Rot::new(angle)
      let transformed_vertices = vertices.map(fn(v) { rot.mul_vec(v) + center })

      // Calculate normals
      let normals = [
        @smath.Vec2D(0.0, -1.0), // bottom
        @smath.Vec2D(1.0, 0.0), // right
        @smath.Vec2D(0.0, 1.0), // top
        @smath.Vec2D(-1.0, 0.0), // left
      ].map(fn(n) { rot.mul_vec(n) })
      PhysicsShape::{
        shape_type: Polygon,
        radius: 0.0,
        vertices: transformed_vertices,
        normals,
        centroid: center,
        density: 1.0,
        friction: 0.3,
        restitution: 0.0,
      }
    }
    Polygon(vertices) => {
      // For now, simple polygon support
      let centroid = calculate_centroid(vertices)
      let normals = calculate_normals(vertices)
      PhysicsShape::{
        shape_type: Polygon,
        radius: 0.0,
        vertices,
        normals,
        centroid,
        density: 1.0,
        friction: 0.3,
        restitution: 0.0,
      }
    }
  }
}

///| Calculate centroid of polygon vertices
fn calculate_centroid(vertices : Array[@smath.Vec2D]) -> @smath.Vec2D {
  let mut centroid = @smath.Vec2D(0.0, 0.0)
  for vertex in vertices {
    centroid = centroid + vertex
  }
  centroid.mul_scalar(1.0 / vertices.length().to_double())
}

///| Calculate normals for polygon edges
fn calculate_normals(vertices : Array[@smath.Vec2D]) -> Array[@smath.Vec2D] {
  let normals : Array[@smath.Vec2D] = []
  for i in 0..<vertices.length() {
    let v1 = vertices[i]
    let v2 = vertices[(i + 1) % vertices.length()]
    let edge = v2 - v1
    let normal = @smath.Vec2D(-edge[Y], edge[X]).normalize()
    normals.push(normal)
  }
  normals
}

///| Recalculate mass properties for a body
fn PhysicsWorld::recalculate_mass_properties(
  self : PhysicsWorld,
  body_index : Int,
) -> Unit {
  let body = self.bodies[body_index]
  if body.body_type != Dynamic {
    body.mass = 0.0
    body.inv_mass = 0.0
    body.inertia = 0.0
    body.inv_inertia = 0.0
    return
  }
  let mut total_mass = 0.0
  let mut total_inertia = 0.0
  let mut center = @smath.Vec2D(0.0, 0.0)
  for shape in body.shapes {
    let mass_data = calculate_mass_data(shape)
    total_mass += mass_data.mass
    center = center + mass_data.center.mul_scalar(mass_data.mass)
    total_inertia += mass_data.inertia
  }
  if total_mass > 0.0 {
    body.mass = total_mass
    body.inv_mass = 1.0 / total_mass
    center = center.mul_scalar(1.0 / total_mass)
    body.inertia = total_inertia
    body.inv_inertia = if total_inertia > 0.0 {
      1.0 / total_inertia
    } else {
      0.0
    }
  } else {
    body.mass = 1.0
    body.inv_mass = 1.0
    body.inertia = 1.0
    body.inv_inertia = 1.0
  }
}

///| Calculate mass data for a shape
fn calculate_mass_data(shape : PhysicsShape) -> MassData {
  match shape.shape_type {
    Circle => {
      let mass = @math.PI * shape.radius * shape.radius * shape.density
      let inertia = mass * shape.radius * shape.radius
      MassData::{ mass, center: shape.centroid, inertia }
    }
    Polygon => {
      // Simplified: treat as unit mass at centroid
      let mass = shape.density
      let inertia = mass
      MassData::{ mass, center: shape.centroid, inertia }
    }
  }
}

///| Step the physics simulation
pub fn PhysicsWorld::step(
  self : PhysicsWorld,
  time_step : Double,
  sub_step_count : Int,
) -> Unit {
  self.dt = time_step / sub_step_count.to_double()
  self.sub_step_count = sub_step_count
  for _sub_step in 0..<sub_step_count {
    self.sub_step()
  }
}

///| Perform one sub-step of simulation
fn PhysicsWorld::sub_step(self : PhysicsWorld) -> Unit {
  // Integration step
  self.integrate()
}

///| Integrate all bodies
fn PhysicsWorld::integrate(self : PhysicsWorld) -> Unit {
  for i in 0..<self.bodies.length() {
    let body = self.bodies[i]
    if body.body_type != Dynamic || !body.is_awake {
      continue
    }

    // Apply gravity
    let gravity_force = self.gravity.mul_scalar(body.mass * body.gravity_scale)
    body.force = body.force + gravity_force

    // Integrate velocity
    body.linear_velocity = body.linear_velocity +
      body.force.mul_scalar(body.inv_mass * self.dt)
    body.angular_velocity = body.angular_velocity +
      body.torque * (body.inv_inertia * self.dt)

    // Apply damping
    body.linear_velocity = body.linear_velocity.mul_scalar(
      1.0 / (1.0 + self.dt * body.linear_damping),
    )
    body.angular_velocity = body.angular_velocity *
      (1.0 / (1.0 + self.dt * body.angular_damping))

    // Integrate position
    body.position = body.position + body.linear_velocity.mul_scalar(self.dt)
    body.angle = body.angle + body.angular_velocity * self.dt

    // Update transform
    body.transform = PhysicsTransform::new(body.position, Rot::new(body.angle))

    // Clear forces
    body.force = @smath.Vec2D(0.0, 0.0)
    body.torque = 0.0
  }
}
