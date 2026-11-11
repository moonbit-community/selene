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
pub(all) struct Color {
  r : UInt32
  g : UInt32
  b : UInt32
  a : Double
}

///|
pub extend Color with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Color with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum AlphaMode2D {
  Opaque
  Blend
}

///|
pub extend AlphaMode2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AlphaMode2D with Eq::{not_equal, equal}

///|
#derive(Eq, Debug)
pub(all) enum BlendMode2D {
  Alpha
  Additive
  Multiply
}

///|
pub extend BlendMode2D with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BlendMode2D with Eq::{not_equal, equal}
