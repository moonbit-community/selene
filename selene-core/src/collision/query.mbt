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
/// Body-type scope for spatial queries.
#derive(Eq)
pub enum SpatialQueryBodyFilter {
  All
  Dynamic
  Fixed
  Kinematic
}

///|
pub extend SpatialQueryBodyFilter with Eq::{not_equal, equal}

///|
/// Spatial-query filter translated to Rapier query predicates.
#derive(Eq)
pub struct SpatialQueryFilter {
  groups : CollisionFilter?
  exclude_entity : @ecs.Entity?
  exclude_sensors : Bool
  exclude_solids : Bool
  body_filter : SpatialQueryBodyFilter
}

///|
pub extend SpatialQueryFilter with Eq::{not_equal, equal}

///|
pub fn SpatialQueryFilter::SpatialQueryFilter() -> SpatialQueryFilter {
  {
    groups: None,
    exclude_entity: None,
    exclude_sensors: false,
    exclude_solids: false,
    body_filter: All,
  }
}

///|
pub fn SpatialQueryFilter::only_dynamic() -> SpatialQueryFilter {
  { ..SpatialQueryFilter(), body_filter: Dynamic, }
}

///|
pub fn SpatialQueryFilter::only_fixed() -> SpatialQueryFilter {
  { ..SpatialQueryFilter(), body_filter: Fixed, }
}

///|
pub fn SpatialQueryFilter::only_kinematic() -> SpatialQueryFilter {
  { ..SpatialQueryFilter(), body_filter: Kinematic, }
}

///|
/// Payload for a 2D raycast hit.
#derive(Eq, Debug)
pub struct RaycastHit {
  entity : @ecs.Entity
  toi : Double
  point : @math.Vec2
  normal : @math.Vec2
}

///|
pub extend RaycastHit with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RaycastHit with Eq::{not_equal, equal}

///|
/// Payload for a 2D shape-cast hit.
#derive(Eq, Debug)
pub struct ShapeCastHit {
  entity : @ecs.Entity
  toi : Double
  point : @math.Vec2
  normal : @math.Vec2
}

///|
pub extend ShapeCastHit with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ShapeCastHit with Eq::{not_equal, equal}
