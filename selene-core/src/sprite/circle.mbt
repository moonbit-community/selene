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
/// A circular sprite rendered with a solid color.
///
/// Fields:
///
/// * `radius` : The radius of the circle in pixels.
/// * `color` : The fill color of the circle as a CSS color string.
/// * `stroke_color` : Optional stroke (outline) color for the circle.
///
/// Example:
///
/// ```moonbit
/// let circle = @sprite.ColorCircle::new(
///   25.0,
///   "blue",
///   stroke_color="white"
/// )
/// inspect(circle.radius, content="25")
/// ```
///
pub(all) struct ColorCircle {
  radius : Double
  color : String
  stroke_color : String
}

///|
/// Creates a new `ColorCircle` with the specified radius and colors.
///
/// Parameters:
///
/// * `radius` : The radius of the circle in pixels.
/// * `color` : The fill color as a CSS color string (e.g., "red", "#FF0000",
///   "rgb(255, 0, 0)").
/// * `stroke_color` : Optional stroke color for the circle outline. If not
///   specified, no stroke will be drawn.
///
/// Returns a new `ColorCircle` instance with the specified properties.
///
/// Example:
///
/// ```moonbit
/// // Create a red circle with white outline
/// let circle = @sprite.ColorCircle::new(
///   30.0,
///   "red",
///   stroke_color="white"
/// )
/// inspect(circle.color, content="red")
///
/// // Create a blue circle without outline
/// let simple_circle = @sprite.ColorCircle::new(20.0, "blue")
/// inspect(simple_circle.stroke_color, content="rgba(0, 0, 0, 0.0)")
/// ```
///
pub fn ColorCircle::new(
  radius : Double,
  color : String,
  stroke_color? : String = "rgba(0, 0, 0, 0.0)",
) -> ColorCircle {
  { radius, color, stroke_color }
}

///|
/// Renders a color circle to the screen at the specified position.
///
/// Parameters:
///
/// * `color_circle` : The `ColorCircle` to render.
/// * `position` : The center position where the circle should be drawn.
///
/// The function draws the filled circle first, then draws the stroke outline
/// if a stroke color was specified.
///
fn render_color_circle(
  color_circle : ColorCircle,
  position : @math.Vec2D,
) -> Unit {
  @backend.draw_color_circle(
    x=position[X] + color_circle.radius,
    y=position[Y] + color_circle.radius,
    radius=color_circle.radius,
    color=color_circle.color,
    stroke_color=color_circle.stroke_color,
  )
}
