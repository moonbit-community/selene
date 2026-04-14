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
pub enum SpatialQueryBodyFilter {
  All
  Dynamic
  Fixed
  Kinematic
} derive(Eq)

///|
/// Spatial-query filter translated to Rapier query predicates.
pub struct SpatialQueryFilter {
  groups : CollisionFilter?
  exclude_entity : @entity.Entity?
  exclude_sensors : Bool
  exclude_solids : Bool
  body_filter : SpatialQueryBodyFilter
} derive(Eq)

///|
pub fn SpatialQueryFilter::default() -> SpatialQueryFilter {
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
  { ..SpatialQueryFilter::default(), body_filter: Dynamic }
}

///|
pub fn SpatialQueryFilter::only_fixed() -> SpatialQueryFilter {
  { ..SpatialQueryFilter::default(), body_filter: Fixed }
}

///|
pub fn SpatialQueryFilter::only_kinematic() -> SpatialQueryFilter {
  { ..SpatialQueryFilter::default(), body_filter: Kinematic }
}

///|
/// Result payload for a 2D raycast hit.
pub struct RaycastHit {
  entity : @entity.Entity
  toi : Double
  point : @math.Vec2
  normal : @math.Vec2
} derive(Eq, Debug)

///|
/// Result payload for a 2D shape-cast hit.
pub struct ShapeCastHit {
  entity : @entity.Entity
  toi : Double
  point : @math.Vec2
  normal : @math.Vec2
} derive(Eq, Debug)
