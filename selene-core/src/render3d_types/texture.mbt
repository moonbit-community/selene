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
pub(all) enum TextureWrap3D {
  ClampToEdge
  Repeat
  MirroredRepeat
}

///|
pub extend TextureWrap3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureWrap3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum TextureFilter3D {
  Nearest
  Linear
}

///|
pub extend TextureFilter3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureFilter3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct TextureSampler3D {
  wrap_u : TextureWrap3D
  wrap_v : TextureWrap3D
  min_filter : TextureFilter3D
  mag_filter : TextureFilter3D
  mipmap_filter : TextureFilter3D?
}

///|
pub extend TextureSampler3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureSampler3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct TextureTransform3D {
  offset : @math.Vec2
  scale : @math.Vec2
  rotation : Double
}

///|
pub extend TextureTransform3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureTransform3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct TextureBinding3D {
  image : ImageHandle
  sampler : TextureSampler3D
  texcoord_set : Int32
  transform : TextureTransform3D
}

///|
pub extend TextureBinding3D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextureBinding3D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) struct ImageAsset {
  path : String
}

///|
pub extend ImageAsset with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageAsset with Eq::{not_equal, equal}

///|
pub fn TextureSampler3D::TextureSampler3D() -> TextureSampler3D {
  {
    wrap_u: Repeat,
    wrap_v: Repeat,
    min_filter: Linear,
    mag_filter: Linear,
    mipmap_filter: Some(Linear),
  }
}

///|
pub fn TextureTransform3D::TextureTransform3D() -> TextureTransform3D {
  { offset: @math.Vec2::zero(), scale: Vec2(1.0, 1.0), rotation: 0.0, }
}

///|
pub fn apply_texture_transform3d(
  transform : TextureTransform3D,
  uv : @math.Vec2,
) -> @math.Vec2 {
  let scaled = uv * transform.scale
  let sin_rotation = @cmath.sin(transform.rotation)
  let cos_rotation = @cmath.cos(transform.rotation)
  Vec2(
    scaled.x * cos_rotation - scaled.y * sin_rotation + transform.offset.x,
    scaled.x * sin_rotation + scaled.y * cos_rotation + transform.offset.y,
  )
}

///|
pub fn TextureBinding3D::TextureBinding3D(
  image : ImageHandle,
  texcoord_set~ : Int32 = 0,
  sampler~ : TextureSampler3D = TextureSampler3D(),
  transform~ : TextureTransform3D = TextureTransform3D(),
) -> TextureBinding3D {
  { image, sampler, texcoord_set, transform, }
}
