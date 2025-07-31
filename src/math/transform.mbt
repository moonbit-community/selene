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
pub(all) struct Transform {
  scale : Vec2D
  translate : Vec2D
  skew : Vec2D
}

///|
pub fn Transform::new(
  scale~ : Vec2D = Vec2D::new(1.0, 1.0),
  translate~ : Vec2D = Vec2D::new(0.0, 0.0),
  skew~ : Vec2D = Vec2D::new(0.0, 0.0),
) -> Transform {
  { scale, translate, skew }
}

///|
pub fn Transform::flip_x(width : Double) -> Transform {
  Transform::new(scale=Vec2D::new(-1.0, 1.0), translate=Vec2D::new(width, 0.0))
}
