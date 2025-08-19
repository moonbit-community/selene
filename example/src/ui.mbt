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
fn add_result_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(
    box,
    @math.Vec2D((VIEWPORT_WIDTH / 2.0 - 48) / ZOOM, (VIEWPORT_HEIGHT / 2.0 - 32) / ZOOM),
  )
  let text = @sprite.Sprite::new_text(game_state.result_box, @ui.UI_ZINDEX)
  @ui.uis.set(box, @ui.Ui::new())
  @sprite.sprites.set(box, text)
}

///|
fn add_score_box() -> Unit {
  let box = @system.Entity::new()
  @position.positions.set(box, @math.Vec2D((VIEWPORT_WIDTH / 2.0 - 24) / ZOOM, 40 / ZOOM))
  let text = @sprite.Sprite::new_text(game_state.score_box, @ui.UI_ZINDEX)
  @sprite.sprites.set(box, text)
  @ui.uis.set(box, @ui.Ui::new())
}

///|
fn add_volume_button() -> Unit {
  let button = @system.Entity::new()
  @position.positions.set(button, @math.Vec2D((VIEWPORT_WIDTH - 40) / ZOOM, 18 / ZOOM))
  let volume_on = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(21, 22),
      "pixel_adventure/Menu/Buttons/Volume.png",
    ),
    100,
  )
  let volumn_off = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(21, 22),
      "pixel_adventure/Menu/Buttons/VolumeOff.png",
    ),
    100,
  )
  @sprite.sprites.set(button, volume_on)
  let area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(21.0, 22.0),
      offset=@math.Vec2D::zero(),
    ),
    non_collide_layer,
    @collision.CollisionMask::new([]),
    monitoring_mouse=true,
  )
  area.on_just_released(fn(mouse_button) {
    if mouse_button == Left {
      game_state.volume_on = !game_state.volume_on
      if game_state.volume_on {
        @sprite.sprites.set(button, volume_on)
      } else {
        @sprite.sprites.set(button, volumn_off)
      }
    }
  })
  @collision.areas.set(button, area)
  @ui.uis.set(button, @ui.Ui::new())
}
