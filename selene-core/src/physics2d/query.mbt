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
pub fn raycast(
  origin : @math.Vec2,
  direction : @math.Vec2,
  max_toi~ : Double = 1000.0,
  solid~ : Bool = true,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> RaycastHit? {
  @collision.raycast(origin, direction, max_toi~, solid~, query_filter~)
}

///|
pub fn shape_cast(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  direction~ : @math.Vec2 = Vec2(0.0, -1.0),
  max_toi~ : Double = 1000.0,
  stop_at_penetration~ : Bool = false,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> ShapeCastHit? {
  @collision.shape_cast(
    shape,
    origin,
    rotation~,
    direction~,
    max_toi~,
    stop_at_penetration~,
    query_filter~,
  )
}

///|
pub fn intersect_point(
  point : @math.Vec2,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  @collision.intersect_point(point, query_filter~)
}

///|
pub fn intersect_shape(
  shape : CollisionShape,
  origin : @math.Vec2,
  rotation~ : Double = 0.0,
  query_filter~ : SpatialQueryFilter = SpatialQueryFilter(),
) -> Array[@ecs.Entity] {
  @collision.intersect_shape(shape, origin, rotation~, query_filter~)
}

///|
pub fn is_grounded(entity : @ecs.Entity) -> Bool {
  @collision.is_grounded(entity)
}

///|
pub fn get_contains(area : @ecs.Entity) -> @set.Set[@ecs.Entity] {
  @collision.get_contains(area)
}
