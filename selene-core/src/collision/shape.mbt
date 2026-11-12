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
#derive(Eq, Debug)
#selene.component
pub(all) enum CollisionShape {
  Rect(size~ : @math.Vec2, offset~ : @math.Vec2)
  Ball(radius~ : Double, offset~ : @math.Vec2)
  Polygon(points~ : Array[@math.Vec2], offset~ : @math.Vec2)
  Polyline(points~ : Array[@math.Vec2], offset~ : @math.Vec2, closed~ : Bool)
}

///|
pub extend CollisionShape with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CollisionShape with Eq::{not_equal, equal}
