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
/// Bevy-style local transform component.
///
/// Current Selene runtime is 2D-first; this component aliases the existing
/// position store to keep runtime behavior stable during the API migration.
pub type Transform = @position.Position

///|
/// Bevy-style global transform component.
///
/// For the current 2D runtime, global transform equals local transform.
pub type GlobalTransform = @position.Position

///|
/// Local transforms.
pub let transforms : Map[@entity.Entity, Transform] = @position.positions

///|
/// Backward-compatible alias for transform storage.
pub let positions : Map[@entity.Entity, Transform] = transforms

///|
/// Global transforms.
pub let global_transforms : Map[@entity.Entity, GlobalTransform] = transforms

///|
/// Previous-frame transform snapshot used for render interpolation.
pub let previous_transforms : Map[@entity.Entity, Transform] = @position.previous_positions

///|
/// Backward-compatible alias for previous transforms.
pub let previous_positions : Map[@entity.Entity, Transform] = previous_transforms

///|
/// Copies current local transforms into previous-frame snapshot.
pub fn capture_previous_transforms() -> Unit {
  @position.capture_previous_positions()
}

///|
/// Samples interpolated translation in world-space.
pub fn sample_translation(
  entity : @entity.Entity,
  alpha : Double,
) -> @math.Vec2D {
  @position.sample_position(entity, alpha)
}

///|
/// Backward-compatible alias for interpolated sampling.
pub fn sample_position(entity : @entity.Entity, alpha : Double) -> @math.Vec2D {
  sample_translation(entity, alpha)
}
