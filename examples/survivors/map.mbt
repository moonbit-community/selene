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
fn add_background(size : @math.Vec2) -> Unit {
  let background_sprite = @sprite.Sprite(
    image=Some(@asset.load_image(background_picture)),
    custom_size=Some(size),
    anchor=Anchor(Vec2(-0.5, 0.5)),
    image_mode=Tiled(Repeat),
  )
  ignore(
    spawn_survivors_entity(
      (
        background_sprite,
        @transform.Spatial(
          @transform.Transform::from_xyz(0.0, 0.0, GROUND_ZINDEX.to_double()),
        ),
      ),
    ),
  )
}

///|
fn add_border(size : @math.Vec2) -> Unit {
  fn add_one_border(pos : @math.Vec2, size : @math.Vec2) -> Unit {
    let shape : @physics2d.ColliderShape = Rect(size~, offset=Vec2(0.0, 0.0))
    ignore(
      spawn_survivors_entity(
        (
          @physics2d.Collider(
            @physics2d.CollisionFilter::empty(wall_collision_group),
          ),
          shape,
          @transform.Spatial(@transform.Transform::from_xyz(pos.x, pos.y, 0.0)),
        ),
      ),
    )
  }

  add_one_border(Vec2(-16.0, -16.0), Vec2(size.x + 32.0, 16.0))
  add_one_border(Vec2(-16.0, 0), Vec2(16.0, size.y))
  add_one_border(Vec2(-16.0, size.y), Vec2(size.x + 32.0, 16.0))
  add_one_border(Vec2(size.x, 0), Vec2(16.0, size.y))
}

///|
fn add_grass() -> Unit {
  let density = 0.05
  let rand = @random.Rand()
  let plan : @ecs.SpawnPlan[(@sprite.Sprite, @transform.Spatial)] = @ecs.commands(
    @ecs.require_current_world(),
  ).prepare_spawn()
  let entities = survivors_runtime().entities
  for x in 0..<(MAP_WIDTH / 16.0).to_int() {
    for y in 0..<(MAP_HEIGHT / 16.0).to_int() {
      if rand.double() < density {
        entities.push(
          @ecs.commands(@ecs.require_current_world()).spawn_prepared(
            plan,
            (
              grass_sprite(),
              Spatial(
                @transform.Transform::from_xyz(
                  x.to_double() * 16.0,
                  y.to_double() * 16.0,
                  GRASS_ZINDEX.to_double(),
                ),
              ),
            ),
          ),
        )
      }
    }
  }
}
