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
#derive(Eq, Debug)
#selene.component
pub(all) struct OrthographicProjection {
  near : Double
  far : Double
  scale : Double
}

///|
pub extend OrthographicProjection with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend OrthographicProjection with Eq::{not_equal, equal}

///|
pub fn OrthographicProjection::OrthographicProjection(
  scale~ : Double = 1.0,
  near~ : Double = -1000.0,
  far~ : Double = 1000.0,
) -> OrthographicProjection {
  { near, far, scale: projection_scale(scale), }
}

///|
pub impl Default for OrthographicProjection with fn default() -> OrthographicProjection {
  OrthographicProjection()
}

///|
pub extend OrthographicProjection with Default::{default}

///|
pub fn orthographic_projections() -> @ecs.ComponentStore[OrthographicProjection] {
  @ecs.components()
}

///|
fn projection_scale(scale : Double) -> Double {
  if scale <= 0.0 || !scale.is_finite() {
    1.0
  } else {
    scale
  }
}
