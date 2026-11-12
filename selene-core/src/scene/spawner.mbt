///|
pub type SceneHandle = @render3d.SceneHandle

///|
pub type SceneInstance = @scene3d.SceneInstance

///|
pub(all) struct SceneSpawner {
  _tag : Unit
}

///|
#derive(Eq, Debug)
pub(all) struct SceneInstanceReadyEvent {
  scene : SceneHandle
  root : @ecs.Entity
}

///|
pub extend SceneInstanceReadyEvent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SceneInstanceReadyEvent with Eq::{not_equal, equal}

///|
let scene_instances_key : @ecs.ResourceKey[@ecs.EntityTable[SceneHandle]] = ResourceKey()

///|
fn scene_instances() -> @ecs.EntityTable[SceneHandle] {
  scene_instances_key.get_or_insert_with(@ecs.require_current_world(), world => {
    EntityTable(world)
  })
}

///|
pub let scene_instance_ready_events : @event.Events[SceneInstanceReadyEvent] = Events()

///|
pub fn SceneSpawner::SceneSpawner() -> SceneSpawner {
  { _tag: (), }
}

///|
pub fn load_scene_gltf(path : String) -> SceneHandle {
  @scene3d.load_scene_gltf(path)
}

///|
pub fn instantiate_scene(
  scene : SceneHandle,
  root_transform : @transform.Transform,
  parent? : @ecs.Entity,
) -> SceneInstance {
  let instance = @scene3d.instantiate_scene_instance(
    scene,
    root_transform,
    parent?,
  )
  scene_instances().set(instance.root, scene)
  scene_instance_ready_events.send({ scene, root: instance.root, })
  instance
}

///|
pub fn SceneSpawner::spawn(
  self : SceneSpawner,
  scene : SceneHandle,
  root_transform : @transform.Transform,
  parent? : @ecs.Entity,
) -> SceneInstance {
  ignore(self)
  instantiate_scene(scene, root_transform, parent?)
}

///|
pub fn despawn_scene(root : @ecs.Entity) -> Unit {
  ignore(root.delete())
  scene_instances().remove(root)
}

///|
pub fn despawn_all_scenes() -> Unit {
  let roots = scene_instances().keys().collect()
  for root in roots {
    ignore(root.delete())
  }
  scene_instances().clear()
}

///|
pub fn scene_of(root : @ecs.Entity) -> SceneHandle? {
  scene_instances().get(root)
}

///|
pub fn scene_spawner_cleanup_system(_delta : Double) -> Unit {
  let world = @ecs.require_current_world()
  scene_instances().retain((entity, _) => entity.is_valid_in(world))
}
