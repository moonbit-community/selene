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
/// Text sprite with customizable content, color, and font styling.
///
/// Fields:
///
/// * `content` : The text content to be displayed.
/// * `color` : The color of the text (e.g., "white", "#FF0000").
/// * `font` : The font specification including size and family (e.g., "16px
///   Arial").
///
/// Example:
///
/// ```notest
/// let text = @sprite.Text::new("Hello World", color="red", font="24px Times")
/// text.content = "Updated content"
/// text.color = "blue"
/// text.font = "18px Helvetica"
/// inspect(text.content, content="Updated content")
/// inspect(text.color, content="blue")
/// inspect(text.font, content="18px Helvetica")
/// ```
///
pub(all) struct Text {
  mut content : String
  mut color : String
  mut font : String
}

///|
pub fn Text::new(
  content : String,
  color~ : String = "white",
  font~ : String = "16px Arial",
) -> Text {
  { content, color, font }
}

///|
fn render_text(
  backend : &@system.Backend,
  text : Text,
  position : @math.Vec2D,
) -> Unit {
  backend.draw_text(
    text.content,
    x=position[X],
    y=position[Y],
    font=text.font,
    color=text.color,
  )
}
