///|
const TERRAIN_TILE_SIZE : Int32 = 16

///|
priv struct LoadedLevelScene {
  player_entity : @ecs.Entity
  camera_entity : @ecs.Entity
  world_size : @math.Vec2
}

///|
fn load_level_scene(world~ : @ecs.World) -> LoadedLevelScene {
  let camera_entity = spawn_game_entity(
    (
      @transform.Spatial(@transform.Transform::identity()),
      @camera.Camera(),
      @camera.Camera2d(),
      @camera.OrthographicProjection(),
    ),
  )
  let player_entity = spawn_player_entity(world~, 80.0, 496.0)
  spawn_flag_entity(world~, 64.0, 80.0)
  for
    (x, y) in [
      (160.0, 384.0),
      (448.0, 384.0),
      (736.0, 384.0),
      (848.0, 496.0),
      (304.0, 96.0),
      (848.0, 208.0),
      (448.0, 208.0),
    ] {
    spawn_apple_entity(world~, x, y)
  }
  spawn_bird_entity(world~, 240.0, 50.0)
  spawn_bird_entity(world~, 752.0, 210.0)
  let terrain_image = @asset.load_image(
    "assets/pixeladventure/Terrain/Terrain (16x16).png",
  )
  let rows : Map[Int32, Array[Int32]] = Map([])
  let plan : @ecs.SpawnPlan[(@transform.Spatial, @sprite.Sprite)] = world.prepare_spawn()
  let entities = pixeladventure_world_state().entities
  for (x, y, count, atlas_x, atlas_y) in terrain_runs {
    for offset in 0..<count {
      let tile_x = x + offset
      let entity = @ecs.commands(@ecs.require_current_world()).spawn_prepared(
        plan,
        (
          Spatial(
            @transform.Transform::from_xyz(
              (tile_x * TERRAIN_TILE_SIZE).to_double(),
              (y * TERRAIN_TILE_SIZE).to_double(),
              0.0,
            ),
          ),
          Sprite(
            image=Some(terrain_image),
            rect=Some({
              position: Vec2(atlas_x.to_double(), atlas_y.to_double()),
              size: Vec2(16.0, 16.0),
            }),
            custom_size=Some(Vec2(16.0, 16.0)),
            anchor=Anchor(Vec2(-0.5, 0.5)),
          ),
        ),
      )
      entities.push(entity)
      rows.get_or_init(y, fn() { [] }).push(tile_x)
    }
  }
  build_terrain_colliders(rows)
  { player_entity, camera_entity, world_size: Vec2(928.0, 576.0), }
}

///|
fn build_terrain_colliders(rows : Map[Int32, Array[Int32]]) -> Unit {
  let tile_size_d = TERRAIN_TILE_SIZE.to_double()
  let plan : TerrainSpawnPlan = @ecs.require_current_world().prepare_spawn()
  for y, columns in rows {
    columns.sort()
    let mut cursor = 0
    while cursor < columns.length() {
      let start_x = columns[cursor]
      let mut end_x = start_x
      cursor += 1
      while cursor < columns.length() && columns[cursor] == end_x + 1 {
        end_x = columns[cursor]
        cursor += 1
      }
      spawn_terrain_collider(
        plan,
        Vec2(start_x.to_double() * tile_size_d, y.to_double() * tile_size_d),
        Vec2((end_x - start_x + 1).to_double() * tile_size_d, tile_size_d),
      )
    }
  }
}
