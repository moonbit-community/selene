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
pub(all) struct CubemapFaces3D {
  positive_x : ImageHandle
  negative_x : ImageHandle
  positive_y : ImageHandle
  negative_y : ImageHandle
  positive_z : ImageHandle
  negative_z : ImageHandle
}

///|
pub extend CubemapFaces3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CubemapFaces3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum CubemapAsset3D {
  SixFaces(CubemapFaces3D)
}

///|
pub extend CubemapAsset3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CubemapAsset3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
#selene.component
pub(all) struct Skybox3D {
  cubemap : CubemapHandle
  brightness : Double
  rotation : @math.Rotation3
}

///|
pub extend Skybox3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Skybox3D with Eq::{not_equal, equal}

///|
pub fn CubemapFaces3D::CubemapFaces3D(
  positive_x : ImageHandle,
  negative_x : ImageHandle,
  positive_y : ImageHandle,
  negative_y : ImageHandle,
  positive_z : ImageHandle,
  negative_z : ImageHandle,
) -> CubemapFaces3D {
  { positive_x, negative_x, positive_y, negative_y, positive_z, negative_z, }
}

///|
pub fn cubemap_asset_six_faces(faces : CubemapFaces3D) -> CubemapAsset3D {
  SixFaces(faces)
}

///|
pub fn Skybox3D::Skybox3D(
  cubemap : CubemapHandle,
  brightness~ : Double = 1.0,
  rotation~ : @math.Rotation3 = @math.Rotation3::identity(),
) -> Skybox3D {
  {
    cubemap,
    brightness: if brightness < 0.0 {
      0.0
    } else {
      brightness
    },
    rotation,
  }
}
