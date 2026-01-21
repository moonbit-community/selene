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
/// Normalizes an angle to the range \[0, 2PI) radians.
///
/// Parameters:
///
/// * `angle` : The angle in radians to normalize.
///
/// Returns the normalized angle in the range \[0, 2PI) radians.
///
/// Example:
///
/// ```moonbit
/// // Positive angle greater than 2PI
/// inspect(@cmath.normalize_angle(7.0), content="0.7168146928204138")
///
/// // Negative angle
/// inspect(@cmath.normalize_angle(-1.0), content="5.283185307179586")
///
/// // Angle already in range
/// inspect(@cmath.normalize_angle(1.5), content="1.5")
/// ```
///
pub fn normalize_angle(angle : Double) -> Double {
  let two_pi = @cmath.PI * 2
  let angle = angle % two_pi
  if angle < 0.0 {
    angle + two_pi
  } else {
    angle
  }
}

///|
test "normalize_angle" {
  // Test positive angles greater than 2π
  inspect(normalize_angle(7.0), content="0.7168146928204138")

  // Test negative angles
  inspect(normalize_angle(-1.0), content="5.283185307179586")

  // Test angles already in range [0, 2π)
  inspect(normalize_angle(1.5), content="1.5")
  inspect(normalize_angle(0.0), content="0")

  // Test angle exactly at 2π (should normalize to 0)
  inspect(normalize_angle(@cmath.PI * 2.0), content="0")
}

///|
test "normalize_angle/edge_cases" {
  // Test very large positive angles
  inspect(normalize_angle(100.0), content="5.7522203923062065")

  // Test very large negative angles  
  inspect(normalize_angle(-100.0), content="0.5309649148733797")

  // Test multiple full rotations
  inspect(normalize_angle(@cmath.PI * 6.0), content="0")
  inspect(normalize_angle(@cmath.PI * -4.0), content="0")
}

///|
test "normalize_angle/boundary_values" {
  // Test just under 2π
  let almost_two_pi = @cmath.PI * 2.0 - 0.001
  inspect(normalize_angle(almost_two_pi), content="6.282185307179586")

  // Test just over 0 when coming from negative
  let small_negative = -0.001
  inspect(normalize_angle(small_negative), content="6.282185307179586")
}
