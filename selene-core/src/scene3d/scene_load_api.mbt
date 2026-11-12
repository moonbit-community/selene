///|
priv struct ParsedLightTemplate {
  directional : @render3d.DirectionalLight3D?
  point : @render3d.PointLight3D?
  spot : @render3d.SpotLight3D?
}

///|
priv struct BufferViewTemplate {
  buffer : Int32
  byte_offset : Int32
  byte_length : Int32
  byte_stride : Int32?
}

///|
priv struct SparseIndicesTemplate {
  buffer_view : Int32
  byte_offset : Int32
  component_type : Int32
}

///|
priv struct SparseValuesTemplate {
  buffer_view : Int32
  byte_offset : Int32
}

///|
priv struct SparseAccessorTemplate {
  count : Int32
  indices : SparseIndicesTemplate
  values : SparseValuesTemplate
}

///|
priv struct AccessorTemplate {
  buffer_view : Int32?
  byte_offset : Int32
  component_type : Int32
  count : Int32
  type_name : String
  normalized : Bool
  sparse : SparseAccessorTemplate?
}

///|
let scene_templates : Map[@render3d.SceneHandle, SceneTemplate] = Map([])

///|
let scene_paths : Map[@render3d.SceneHandle, String] = Map([])

///|
fn SceneTemplate::SceneTemplate() -> SceneTemplate {
  { roots: [], nodes: [], skins: [], animations: Map([]), }
}

///|
fn SceneNodeTemplate::SceneNodeTemplate() -> SceneNodeTemplate {
  {
    name: None,
    transform: {
      translation: @math.Vec3::zero(),
      rotation: @math.Rotation3::identity(),
      scale: @math.Vec3::one(),
    },
    renderers: [],
    skin_index: None,
    morph_weights: [],
    camera: None,
    directional_light: None,
    point_light: None,
    spot_light: None,
    children: [],
  }
}

///|
/// Registers a glTF/GLB scene path and returns a stable scene handle.
pub fn load_scene_gltf(path : String) -> @render3d.SceneHandle {
  let handle = @render3d.register_scene_path(path)
  scene_paths.set(handle, path)
  scene_templates.set(handle, load_scene_template(path))
  handle
}

///|
/// Instantiates a scene root entity with the requested root transform.
pub fn instantiate_scene(
  scene : @render3d.SceneHandle,
  root_transform : @transform.Transform,
  parent? : @ecs.Entity,
) -> @ecs.Entity {
  instantiate_scene_instance(scene, root_transform, parent?).root
}

///|
pub fn instantiate_scene_instance(
  scene : @render3d.SceneHandle,
  root_transform : @transform.Transform,
  parent? : @ecs.Entity,
) -> SceneInstance {
  let world = @ecs.require_current_world()
  let draft = world.spawn_draft()
  draft.add(@transform.Spatial(root_transform))
  draft.add(@name.Name("scene_root"))
  let parts : Map[String, @ecs.Entity] = Map([])
  let animation_nodes : Map[String, @animation.AnimationNodeIndex] = Map([])
  guard scene_templates.get(scene) is Some(template) else {
    return {
      root: @ecs.commands(world).spawn_draft(draft, parent?),
      parts,
      animations: animation_nodes,
    }
  }
  if template.animations.length() > 0 {
    let graph = @animation.AnimationGraph()
    for name, clip in template.animations {
      let node = graph.add_clip(clip)
      animation_nodes.set(name, node)
    }
    draft.add(@animation.register_animation_graph_asset(graph))
    draft.add(@animation.AnimationPlayer())
    draft.add(@animation.AnimationTransitions())
  }
  let root = @ecs.commands(world).spawn_draft(draft, parent?)
  @ecs.commands(world).add(_ => {
    guard root.is_valid_in(world) else { return }
    let node_entities : Array[@ecs.Entity?] = Array::make(
      template.nodes.length(),
      None,
    )
    let pending_skin_bindings : Array[PendingSkinBinding] = []
    for root_order, node_index in template.roots {
      instantiate_scene_node(
        template,
        node_index,
        root,
        root,
        node_entities,
        pending_skin_bindings,
        parts,
        "root\{root_order}",
        0,
      )
    }
    resolve_scene_skin_bindings(template, node_entities, pending_skin_bindings)
  })
  { root, parts, animations: animation_nodes, }
}

///|
pub fn scene_instance_part(
  instance : SceneInstance,
  path : String,
) -> @ecs.Entity? {
  instance.parts.get(path)
}
