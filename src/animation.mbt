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
pub struct Animation {
  sprite_path : String
  id : String
  max_frame : UInt
  loop_ : Bool
  height : Double
  width : Double
  offset : Vec2D
}

///|
fn Animation::new(
  id : String,
  sprite_path : String,
  max_frame~ : UInt,
  loop_~ : Bool = true,
  height~ : Double,
  width~ : Double,
  offset~ : Vec2D = Vec2D::new(0, 0),
) -> Animation {
  { sprite_path, id, max_frame, loop_, height, width, offset }
}

