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
/// Collision geometry used by 2D colliders and trigger areas.
pub(all) enum CollisionShape {
  Rect(size~ : @math.Vec2D, offset~ : @math.Vec2D)
  Ball(radius~ : Double, offset~ : @math.Vec2D)
  Polygon(points~ : Array[@math.Vec2D], offset~ : @math.Vec2D)
  Polyline(points~ : Array[@math.Vec2D], offset~ : @math.Vec2D, closed~ : Bool)
} derive(Eq, Show)

///|
priv struct ShapeWorldStore {
  shapes : Map[@entity.Entity, CollisionShape]
}

///|
let shape_world_stores : Map[UInt, ShapeWorldStore] = Map::new()

///|
fn shape_world_store() -> ShapeWorldStore {
  let world_id = @ecs.require_current_world().id()
  shape_world_stores.get_or_init(world_id, () => { shapes: Map::new() })
}

///|
/// Stores collision shapes for entities in the current world.
///
/// Example:
///
/// ```moonbit nocheck
/// let entity = @entity.Entity::new()
/// defer entity.destroy()
/// @collision.shapes().set(
///   entity,
///   @collision.CollisionShape::Rect(
///     size=@math.Vec2D(50.0, 30.0),
///     offset=@math.Vec2D(0.0, 0.0),
///   ),
/// )
/// ```
pub fn shapes() -> Map[@entity.Entity, CollisionShape] {
  shape_world_store().shapes
}
