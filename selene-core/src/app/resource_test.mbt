///|
struct Settings {
  value : Int32
}

///|
let settings_key : @ecs.ResourceKey[Settings] = ResourceKey()

///|
impl @ecs.Resource for Settings with fn resource_key() {
  settings_key
}

///|
test "App resources are available before Startup and retain their configured value" {
  let first = @ecs.World()
  let second = @ecs.World()
  let observed = []
  let read_settings = (world : @ecs.World) => {
    let settings : Settings = world.resource()
    observed.push(settings.value)
  }
  @app.App()
  .with_world(first)
  .insert_resource(Settings::{ value: 7, })
  .add_system(Startup, read_settings)
  .run_frames(1)
  @app.App()
  .with_world(second)
  .insert_resource(Settings::{ value: 9, })
  .add_system(Startup, read_settings)
  .run_frames(1)
  assert_eq(observed, [7, 9])
  let first_settings : Settings = first.resource()
  assert_eq(first_settings.value, 7)
}
