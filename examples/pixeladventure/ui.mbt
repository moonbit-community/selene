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
const HUD_ZINDEX : Int = 100

///|
const BUTTON_ZINDEX : Int = 110

///|
const PLAYFIELD_LEFT_INSET : Double = 48.0

///|
let ui_click_reader : @event.EventReader[@ui.UiClickEvent] = @event.EventReader::new()

///|
fn set_ui_text(entity : @entity.Entity, content : String) -> Unit {
  let text = @ui.texts.get_or_init(entity, fn() { @ui.Text::new(content) })
  text.content = content
}

///|
fn set_ui_text_color(entity : @entity.Entity, color : String) -> Unit {
  @ui.text_colors.set(entity, @ui.TextColor::from_css(color))
}

///|
fn configure_text_box(
  entity : @entity.Entity,
  offset : @math.Vec2D,
  content : String,
  color : String,
  font : String,
  size? : @math.Vec2D = @math.Vec2D(-1.0, -1.0),
  align? : @math.HAlign = @math.HAlign::Left,
  baseline? : @math.VAlign = @math.VAlign::Top,
) -> Unit {
  @ui.nodes.set(entity, @ui.Node::absolute(offset, size~))
  @ui.z_indexes.set(entity, @ui.ZIndex::new(HUD_ZINDEX))
  set_ui_text(entity, content)
  @ui.text_fonts.set(entity, @ui.TextFont::from_css(font))
  set_ui_text_color(entity, color)
  @ui.text_layouts.set(entity, @ui.TextLayout::new(align~, baseline~))
}

///|
fn add_result_box() -> Unit {
  configure_text_box(
    game_state.result_box,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 96.0, VIEWPORT_HEIGHT / 2.0 - 32.0),
    "",
    "white",
    "24px ThaleahFat",
    size=@math.Vec2D(192.0, 32.0),
    align=@math.HAlign::Center,
    baseline=@math.VAlign::Center,
  )
}

///|
fn add_score_box() -> Unit {
  configure_text_box(
    game_state.score_box,
    @math.Vec2D(PLAYFIELD_LEFT_INSET, 16.0),
    "Score: 0",
    "white",
    "20px ThaleahFat",
    size=@math.Vec2D(VIEWPORT_WIDTH - PLAYFIELD_LEFT_INSET, 24.0),
    align=@math.HAlign::Center,
  )
}

///|
fn add_health_box() -> Unit {
  configure_text_box(
    game_state.health_box,
    @math.Vec2D(20.0, 16.0),
    "HP: 3",
    "red",
    "20px ThaleahFat",
  )
}

///|
fn volume_image(volume_on : Bool) -> @ui.UiImage {
  let path = if volume_on {
    "assets/pixeladventure/Menu/Buttons/Volume.png"
  } else {
    "assets/pixeladventure/Menu/Buttons/VolumeOff.png"
  }
  @ui.UiImage::new(@math.Vec2D(21.0, 22.0), path, fit=@ui.ImageFit::Contain)
}

///|
fn add_volume_button() -> Unit {
  let button = game_state.volume_button
  @ui.nodes.set(
    button,
    @ui.Node::absolute(
      @math.Vec2D(VIEWPORT_WIDTH - 40.0, 18.0),
      size=@math.Vec2D(21.0, 22.0),
    ),
  )
  @ui.z_indexes.set(button, @ui.ZIndex::new(BUTTON_ZINDEX))
  @ui.buttons.set(button, @ui.Button::new())
  @ui.ui_images.set(button, volume_image(game_state.volume_on))
}

///|
fn volume_button_input_system(_delta : Double) -> Unit {
  for event in @ui.click_event_bus.read(ui_click_reader) {
    guard event.entity == game_state.volume_button else { continue }
    game_state.volume_on = !game_state.volume_on
    @ui.ui_images.set(
      game_state.volume_button,
      volume_image(game_state.volume_on),
    )
  }
}
