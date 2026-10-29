///|
const TERRAIN_TILE_SIZE : Int32 = 16

///|
priv struct LoadedLevelScene {
  player_entity : @entity.Entity
  camera_entity : @entity.Entity
  world_size : @math.Vec2
}

///|
fn set_entity_z(entity : @entity.Entity, z : Double) -> Unit {
  let transform = @transform.transforms()
    .get(entity)
    .unwrap_or(@transform.Transform::identity())
  @transform.transforms().set(
    entity,
    transform.with_translation(
      Vec3(transform.translation.x, transform.translation.y, z),
    ),
  )
}

///|
fn spawn_level_entity(x : Double, y : Double) -> @entity.Entity {
  let entity = @entity.Entity()
  @transform.transforms().set(entity, @transform.Transform::from_xyz(x, y, 0.0))
  entity
}

///|
fn load_level_scene() -> LoadedLevelScene {
  let camera_entity = spawn_level_entity(0.0, 0.0)
  @camera.cameras().set(camera_entity, Camera())
  @camera.camera2ds().set(camera_entity, Camera2d())
  @camera.orthographic_projections().set(
    camera_entity,
    OrthographicProjection(),
  )
  let player_entity = spawn_level_entity(80.0, 496.0)
  configure_player_entity(player_entity)
  configure_flag_entity(spawn_level_entity(64.0, 80.0))
  configure_apple_entity(spawn_level_entity(160.0, 384.0))
  configure_apple_entity(spawn_level_entity(448.0, 384.0))
  configure_apple_entity(spawn_level_entity(736.0, 384.0))
  configure_apple_entity(spawn_level_entity(848.0, 496.0))
  configure_apple_entity(spawn_level_entity(304.0, 96.0))
  configure_apple_entity(spawn_level_entity(848.0, 208.0))
  configure_apple_entity(spawn_level_entity(448.0, 208.0))
  configure_bird_entity(spawn_level_entity(240.0, 50.0))
  configure_bird_entity(spawn_level_entity(752.0, 210.0))
  let terrain_image = @asset.load_image(
    "assets/pixeladventure/Terrain/Terrain (16x16).png",
  )
  let rows : Map[Int32, Array[Int32]] = Map([])
  for run in terrain_runs {
    let (x, y, count, atlas_x, atlas_y) = run
    for offset in 0..<count {
      let tile_x = x + offset
      let entity = spawn_level_entity(
        (tile_x * TERRAIN_TILE_SIZE).to_double(),
        (y * TERRAIN_TILE_SIZE).to_double(),
      )
      @sprite.sprites().set(
        entity,
        Sprite(
          image=Some(terrain_image),
          rect=Some({
            position: Vec2(atlas_x.to_double(), atlas_y.to_double()),
            size: Vec2(16.0, 16.0),
          }),
          custom_size=Some(Vec2(16.0, 16.0)),
          anchor=Anchor(Vec2(-0.5, 0.5)),
        ),
      )
      rows.get_or_init(y, fn() { [] }).push(tile_x)
    }
  }
  build_terrain_colliders(rows)
  { player_entity, camera_entity, world_size: Vec2(928.0, 576.0), }
}

///|
fn build_terrain_colliders(rows : Map[Int32, Array[Int32]]) -> Unit {
  let tile_size_d = TERRAIN_TILE_SIZE.to_double()
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
        Vec2(start_x.to_double() * tile_size_d, y.to_double() * tile_size_d),
        Vec2((end_x - start_x + 1).to_double() * tile_size_d, tile_size_d),
      )
    }
  }
}
