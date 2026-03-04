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
let volume_button_ref : Ref[@entity.Entity?] = { val: None }

///|
let ui_interaction_reader : @event.EventReader[@ui.InteractionEvent] = @event.EventReader::new()

///|
fn add_result_box() -> Unit {
  let box = @entity.Entity::new()
  @transform.positions.set(
    box,
    @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 48, VIEWPORT_HEIGHT / 2.0 - 32),
  )
  let text = @sprite.Sprite::from_text(game_state.result_box, @ui.UI_ZINDEX)
  @ui.uis.set(box, @ui.Ui::new(space=@ui.UiSpace::Virtual))
  @sprite.sprites.set(box, text)
}

///|
fn add_score_box() -> Unit {
  let box = @entity.Entity::new()
  @transform.positions.set(box, @math.Vec2D(VIEWPORT_WIDTH / 2.0 - 24, 16))
  let text = @sprite.Sprite::from_text(game_state.score_box, @ui.UI_ZINDEX)
  @sprite.sprites.set(box, text)
  @ui.uis.set(box, @ui.Ui::new(space=@ui.UiSpace::Virtual))
}

///|
fn add_health_box() -> Unit {
  let box = @entity.Entity::new()
  @transform.positions.set(box, @math.Vec2D(20, 16))
  let text = @sprite.Sprite::from_text(game_state.health_box, @ui.UI_ZINDEX)
  @sprite.sprites.set(box, text)
  @ui.uis.set(box, @ui.Ui::new(space=@ui.UiSpace::Virtual))
}

///|
fn volume_sprite(volume_on : Bool) -> @sprite.Sprite {
  let path = if volume_on {
    "assets/pixeladventure/Menu/Buttons/Volume.png"
  } else {
    "assets/pixeladventure/Menu/Buttons/VolumeOff.png"
  }
  @sprite.Sprite::from_picture(
    @sprite.Picture::new(@math.Vec2D(21, 22), path),
    100,
  )
}

///|
fn add_volume_button() -> Unit {
  let button = @ui.add_button(
    @ui.virtual_root,
    node=@ui.Node::new(
      size=@ui.NodeSize::Fixed(@math.Vec2D(21.0, 22.0)),
      layout=@ui.LayoutDirection::Overlay,
      space=@ui.UiSpace::Virtual,
      offset=@math.Vec2D(VIEWPORT_WIDTH - 40, 18),
    ),
    button=@ui.Button::new(trigger=@inputs.MouseButton::Left),
  )
  @sprite.sprites.set(button, volume_sprite(game_state.volume_on))
  volume_button_ref.val = Some(button)
}

///|
fn volume_button_input_system(_delta : Double) -> Unit {
  guard volume_button_ref.val is Some(button) else { return }
  for event in @ui.interaction_event_bus.read(ui_interaction_reader) {
    guard event.entity == button else { continue }
    guard event.previous is @ui.Interaction::Pressed else { continue }
    guard event.current is @ui.Interaction::Hovered else { continue }
    game_state.volume_on = !game_state.volume_on
    @sprite.sprites.set(button, volume_sprite(game_state.volume_on))
  }
}
