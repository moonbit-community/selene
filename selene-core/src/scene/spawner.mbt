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
fn scene_instances(
  world~ : @ecs.World = @ecs.require_current_world(),
) -> @ecs.EntityTable[SceneHandle] {
  scene_instances_key.get_or_insert_with(world, world => EntityTable(world))
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
  @ecs.commands(@ecs.require_current_world()).add(world => {
    guard instance.root.is_valid_in(world) else { return }
    scene_instance_ready_events.send({ scene, root: instance.root, })
  })
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
  @ecs.commands(@ecs.require_current_world()).delete(root)
  scene_instances().remove(root)
}

///|
pub fn despawn_all_scenes() -> Unit {
  let roots = scene_instances().keys().collect()
  for root in roots {
    @ecs.commands(@ecs.require_current_world()).delete(root)
  }
  scene_instances().clear()
}

///|
pub fn scene_of(root : @ecs.Entity) -> SceneHandle? {
  scene_instances().get(root)
}

///|
pub fn scene_spawner_cleanup_system(instances : SceneInstances) -> Unit {
  instances.entries.retain((entity, _) => instances.entities.is_valid(entity))
}

///|
struct SceneInstances {
  entries : @ecs.EntityTable[SceneHandle]
  entities : @ecs.Entities
}

///|
pub fn SceneInstances::SceneInstances(world : @ecs.World) -> SceneInstances {
  { entries: scene_instances(world~), entities: Entities(world), }
}

///|
pub impl @ecs.SystemParam for SceneInstances with fn prepare(world) {
  let instances = SceneInstances(world)
  _ => instances
}

///|
pub extend SceneInstances with @ecs.SystemParam::{prepare}
