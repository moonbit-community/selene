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

/// Selene Physics Module
/// 
/// A 2D physics engine integrated with the Selene ECS system.
/// Provides rigid body dynamics, collision detection, and constraint solving.
/// 
/// ## Basic Usage
/// 
/// ```moonbit
/// // Initialize physics world
/// init_physics_world(WorldDef::default())
/// 
/// // Create a dynamic body for an entity
/// let body_def = BodyDef::{
///   body_type: Dynamic,
///   position: Vec2(0.0, 10.0),
///   ..BodyDef::default()
/// }
/// create_physics_body(entity, body_def)
/// 
/// // Add a circle shape
/// add_physics_shape(entity, Circle(radius=1.0, center=Vec2(0.0, 0.0)))
/// 
/// // Add physics system to your app
/// app.add_system(physics_system)
/// ```
/// 
/// The physics system will automatically sync with selene's position system.
