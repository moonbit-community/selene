///|
test "tiled settings are configurable from external packages" {
  let map_settings = {
    ..@tiled.default_tiled_spawn_settings(),
    image_layer_hook: Some(fn(_event) { () }),
  }
  let physics_settings = {
    ..@tiled.default_tiled_physics_settings(),
    collider_hook: Some(fn(_event) { () }),
  }
  let world_settings = {
    ..@tiled.default_tiled_world_spawn_settings(),
    map_settings,
    world_hook: Some(fn(_event) { () }),
  }
  inspect(map_settings.image_layer_hook is Some(_), content="true")
  inspect(physics_settings.collider_hook is Some(_), content="true")
  inspect(world_settings.world_hook is Some(_), content="true")
}
