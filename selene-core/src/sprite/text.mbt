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
/// ```moonbit nocheck
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
  mut font_handle : @asset.FontHandle?
  mut baseline : @math.VAlign
  mut align : @math.HAlign
}

///|
pub fn Text::new(
  content : String,
  color? : String = "white",
  font? : String = "16px Arial",
  baseline? : @math.VAlign = Top,
  align? : @math.HAlign = Left,
) -> Text {
  { content, color, font, font_handle: None, baseline, align }
}

///|
pub fn Text::from_font(
  content : String,
  font : @asset.FontHandle,
  size? : Double = 16.0,
  color? : String = "white",
  baseline? : @math.VAlign = Top,
  align? : @math.HAlign = Left,
) -> Text {
  let family = @asset.font_family(font).unwrap_or("Arial")
  {
    content,
    color,
    font: "\{size}px \{family}",
    font_handle: Some(font),
    baseline,
    align,
  }
}

///|
fn render_text(
  text : Text,
  position : @math.Vec2D,
  scale_with_zoom : Bool,
) -> Unit {
  let style = parse_text_style(
    text.font,
    text.color,
    text.align,
    text.baseline,
    font_handle=text.font_handle,
  )
  let style = if scale_with_zoom {
    { ..style, size: @system.scale_value(style.size) }
  } else {
    style
  }
  let command : @render2d_types.TextDrawCommand2D = {
    text: text.content,
    position,
    style,
  }
  @render2d.push_text(command)
}

///|
pub fn measure_text_size(text : Text) -> @math.Vec2D {
  let style = parse_text_style(
    text.font,
    text.color,
    text.align,
    text.baseline,
    font_handle=text.font_handle,
  )
  @platform_render.measure_text(style, text.content)
}
