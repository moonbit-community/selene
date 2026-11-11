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
pub(all) struct DirectionalLightShadowMap3D {
  size : Int32
}

///|
pub extend DirectionalLightShadowMap3D with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend DirectionalLightShadowMap3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct PointLightShadowMap3D {
  size : Int32
}

///|
pub extend PointLightShadowMap3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PointLightShadowMap3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct CascadeShadowConfigBuilder3D {
  num_cascades : Int32
  minimum_distance : Double
  maximum_distance : Double
  first_cascade_far_bound : Double
  overlap_proportion : Double
}

///|
pub extend CascadeShadowConfigBuilder3D with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend CascadeShadowConfigBuilder3D with Eq::{not_equal, equal}

///|
#derive(Debug)
pub(all) struct CascadeShadowConfig3D {
  bounds : Array[Double]
  minimum_distance : Double
  overlap_proportion : Double
}

///|
pub extend CascadeShadowConfig3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn DirectionalLightShadowMap3D::DirectionalLightShadowMap3D() -> DirectionalLightShadowMap3D {
  { size: 2048, }
}

///|
pub fn PointLightShadowMap3D::PointLightShadowMap3D() -> PointLightShadowMap3D {
  { size: 1024, }
}

///|
pub fn CascadeShadowConfigBuilder3D::CascadeShadowConfigBuilder3D() -> CascadeShadowConfigBuilder3D {
  {
    num_cascades: 4,
    minimum_distance: 0.1,
    maximum_distance: 150.0,
    first_cascade_far_bound: 10.0,
    overlap_proportion: 0.2,
  }
}

///|
pub fn build_cascade_shadow_config3d(
  builder : CascadeShadowConfigBuilder3D,
) -> CascadeShadowConfig3D {
  let num_cascades = if builder.num_cascades < 1 {
    1
  } else {
    builder.num_cascades
  }
  let minimum_distance = if builder.minimum_distance < 0.0 {
    0.0
  } else {
    builder.minimum_distance
  }
  let maximum_distance = if builder.maximum_distance <= minimum_distance {
    minimum_distance + 1.0
  } else {
    builder.maximum_distance
  }
  let first_cascade_far_bound = if builder.first_cascade_far_bound <=
    minimum_distance {
    minimum_distance +
    (maximum_distance - minimum_distance) / num_cascades.to_double()
  } else if builder.first_cascade_far_bound >= maximum_distance {
    maximum_distance
  } else {
    builder.first_cascade_far_bound
  }
  let overlap_proportion = if builder.overlap_proportion < 0.0 {
    0.0
  } else if builder.overlap_proportion > 1.0 {
    1.0
  } else {
    builder.overlap_proportion
  }
  let bounds : Array[Double] = []
  if num_cascades == 1 {
    bounds.push(maximum_distance)
  } else {
    let base = @cmath.pow(
      maximum_distance / first_cascade_far_bound,
      1.0 / (num_cascades - 1).to_double(),
    )
    for index in 0..<num_cascades {
      bounds.push(first_cascade_far_bound * @cmath.pow(base, index.to_double()))
    }
  }
  { bounds, minimum_distance, overlap_proportion, }
}

///|
pub fn CascadeShadowConfig3D::CascadeShadowConfig3D() -> CascadeShadowConfig3D {
  build_cascade_shadow_config3d(CascadeShadowConfigBuilder3D())
}
