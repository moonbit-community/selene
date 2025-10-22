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
pub fn add_widget(
  parent : @entity.Entity,
  sprite? : (Int) -> @sprite.Sprite,
  on_just_pressed? : (@inputs.MouseButton) -> Unit,
  shape? : @collision.CollisionShape,
  size_plan? : SizePlan = SizePlan::FromSprite,
  flex? : Flex = Flex::Overlap,
  h_padding? : Double = 0.0,
  v_padding? : Double = 0.0,
  h_offset? : Double = 0.0,
  v_offset? : Double = 0.0,
) -> @entity.Entity {
  let child = parent.spawn_child()
  @ui.uis.set(child, @ui.Ui::new())
  let style = Style::new(
    size_plan~,
    flex~,
    h_padding~,
    v_padding~,
    h_offset~,
    v_offset~,
  )
  styles.set(child, style)
  if sprite is Some(sprite_maker) {
    let zindex = get_zindex(parent) + 1
    let sprite = sprite_maker(zindex)
    @sprite.sprites.set(child, sprite)
  }
  if shape is Some(shape) {
    @collision.shapes.set(child, shape)
  }
  if on_just_pressed is Some(button_cb) {
    let pickable = @collision.Pickable::new()
    pickable.on_just_pressed(button_cb)
    @collision.pickables.set(child, pickable)
  }
  child
}

///|
fn get_zindex(entity : @entity.Entity) -> Int {
  @sprite.sprites.get(entity).map_or(@ui.UI_ZINDEX, s => s.zindex)
}
