///|
pub type SceneHandle = @render3d.SceneHandle

///|
pub type SceneInstance = @scene3d.SceneInstance

///|
pub(all) struct SceneSpawner {
  _tag : Unit
}

///|
pub(all) struct SceneInstanceReadyEvent {
  scene : SceneHandle
  root : @entity.Entity
} derive(Eq, Show)

///|
let scene_instances : Map[@entity.Entity, SceneHandle] = Map::new()

///|
pub let scene_instance_ready_events : @event.Events[SceneInstanceReadyEvent] = @event.Events::new()

///|
pub fn spawner() -> SceneSpawner {
  { _tag: () }
}

///|
pub fn load_scene_gltf(path : String) -> SceneHandle {
  @scene3d.load_scene_gltf(path)
}

///|
pub fn instantiate_scene(
  scene : SceneHandle,
  root_transform : @transform3d.Transform3D,
) -> SceneInstance {
  let instance = @scene3d.instantiate_scene_instance(scene, root_transform)
  scene_instances.set(instance.root, scene)
  scene_instance_ready_events.send({ scene, root: instance.root })
  instance
}

///|
pub fn SceneSpawner::spawn(
  self : SceneSpawner,
  scene : SceneHandle,
  root_transform : @transform3d.Transform3D,
) -> SceneInstance {
  ignore(self)
  instantiate_scene(scene, root_transform)
}

///|
pub fn despawn_scene(root : @entity.Entity) -> Unit {
  root.destroy()
  scene_instances.remove(root)
}

///|
pub fn despawn_all_scenes() -> Unit {
  let roots = scene_instances.keys()
  for root in roots {
    root.destroy()
  }
  scene_instances.clear()
}

///|
pub fn scene_of(root : @entity.Entity) -> SceneHandle? {
  scene_instances.get(root)
}

///|
pub fn scene_animation(
  instance : SceneInstance,
  name : String,
) -> @animation3d.AnimationClipHandle? {
  @scene3d.scene_instance_animation(instance, name)
}

///|
pub fn play_scene_animation(
  instance : SceneInstance,
  name : String,
  repeat? : Bool = true,
) -> Bool {
  @scene3d.play_scene_animation(instance, name, repeat~)
}

///|
pub fn set_scene_animation_graph(
  instance : SceneInstance,
  graph : @animation3d.AnimationGraph3D,
  repeat? : Bool = true,
) -> Unit {
  @scene3d.set_scene_animation_graph(instance, graph, repeat~)
}

///|
pub fn trigger_scene_animation(
  instance : SceneInstance,
  trigger : String,
) -> Unit {
  @scene3d.trigger_scene_animation(instance, trigger)
}

///|
pub fn scene_spawner_cleanup_system(_delta : Double) -> Unit {
  for pair in scene_instances.to_array() {
    let root = pair.0
    if !root.is_alive() {
      scene_instances.remove(root)
    }
  }
}
