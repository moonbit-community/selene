///|
fn bird_contact_outcome_name(outcome : BirdContactOutcome) -> String {
  match outcome {
    None => "None"
    Stomp => "Stomp"
    Hurt => "Hurt"
  }
}

///|
fn test_scene_component_count(
  scene : @editor_bridge.SceneDocument,
  kind : String,
) -> Int {
  let mut count = 0
  for entity in scene.entities {
    if entity.component(kind) is Some(_) {
      count += 1
    }
  }
  count
}

///|
test "player freezes after any game result" {
  inspect(player_is_frozen(Some(Win)), content="true")
  inspect(player_is_frozen(Some(GameOver)), content="true")
  inspect(player_is_frozen(None), content="false")
}

///|
test "touching edges count as player/bird contact" {
  let player_rect = @math.Rect::{
    position: @math.Vec2D(32.0, 0.0),
    size: @math.Vec2D(24.0, 32.0),
  }
  let bird_rect = @math.Rect::{
    position: @math.Vec2D(32.0, 32.0),
    size: @math.Vec2D(32.0, 32.0),
  }
  inspect(rects_touch_or_intersect(player_rect, bird_rect), content="true")
}

///|
test "classify bird contact treats a downward landing as stomp" {
  let bird_rect = @math.Rect::{
    position: @math.Vec2D(32.0, 32.0),
    size: @math.Vec2D(32.0, 32.0),
  }
  inspect(
    bird_contact_outcome_name(
      classify_bird_contact(
        @math.Rect::{
          position: @math.Vec2D(32.0, -12.0),
          size: @math.Vec2D(24.0, 32.0),
        },
        @math.Rect::{
          position: @math.Vec2D(32.0, 0.0),
          size: @math.Vec2D(24.0, 32.0),
        },
        bird_rect,
        bird_rect,
        720.0,
      ),
    ),
    content="Stomp",
  )
}

///|
test "classify bird contact treats side overlap as hurt" {
  let player_rect = @math.Rect::{
    position: @math.Vec2D(60.0, 32.0),
    size: @math.Vec2D(24.0, 32.0),
  }
  let bird_rect = @math.Rect::{
    position: @math.Vec2D(32.0, 32.0),
    size: @math.Vec2D(32.0, 32.0),
  }
  inspect(
    bird_contact_outcome_name(
      classify_bird_contact(player_rect, player_rect, bird_rect, bird_rect, 0.0),
    ),
    content="Hurt",
  )
}

///|
test "classify bird contact ignores separated sweeps" {
  let bird_rect = @math.Rect::{
    position: @math.Vec2D(120.0, 32.0),
    size: @math.Vec2D(32.0, 32.0),
  }
  inspect(
    bird_contact_outcome_name(
      classify_bird_contact(
        @math.Rect::{
          position: @math.Vec2D(0.0, 0.0),
          size: @math.Vec2D(24.0, 32.0),
        },
        @math.Rect::{
          position: @math.Vec2D(8.0, 0.0),
          size: @math.Vec2D(24.0, 32.0),
        },
        bird_rect,
        bird_rect,
        480.0,
      ),
    ),
    content="None",
  )
}

///|
test "pending stomp bounce overrides downward Y velocity" {
  let actual = player_motion_base_velocity(
    @math.Vec2D(120.0, 480.0),
    Some(-BUMP_V),
  )
  let expected = @math.Vec2D(120.0, -BUMP_V)
  inspect(
    actual[@math.X] == expected[@math.X] && actual[@math.Y] == expected[@math.Y],
    content="true",
  )
}

///|
test "scene data contains player flag and terrain" {
  with_pixeladventure_test_asset_io(fn() raise {
    let scene = pixeladventure_startup_scene_document()
    inspect(
      test_scene_component_count(scene, pixeladventure_player_component_kind) >
      0,
      content="true",
    )
    inspect(
      test_scene_component_count(scene, pixeladventure_flag_component_kind) > 0,
      content="true",
    )
    inspect(
      test_scene_component_count(scene, pixeladventure_terrain_component_kind) >
      0,
      content="true",
    )
  })
}
