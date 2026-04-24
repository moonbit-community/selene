///|
priv struct ParsedLightTemplate {
  directional : @render3d.DirectionalLight3D?
  point : @render3d.PointLight3D?
  spot : @render3d.SpotLight3D?
}

///|
priv struct BufferViewTemplate {
  buffer : Int
  byte_offset : Int
  byte_length : Int
  byte_stride : Int?
}

///|
priv struct SparseIndicesTemplate {
  buffer_view : Int
  byte_offset : Int
  component_type : Int
}

///|
priv struct SparseValuesTemplate {
  buffer_view : Int
  byte_offset : Int
}

///|
priv struct SparseAccessorTemplate {
  count : Int
  indices : SparseIndicesTemplate
  values : SparseValuesTemplate
}

///|
priv struct AccessorTemplate {
  buffer_view : Int?
  byte_offset : Int
  component_type : Int
  count : Int
  type_name : String
  normalized : Bool
  sparse : SparseAccessorTemplate?
}

///|
let scene_templates : Map[@render3d.SceneHandle, SceneTemplate] = Map::new()

///|
let scene_paths : Map[@render3d.SceneHandle, String] = Map::new()

///|
fn empty_scene_template() -> SceneTemplate {
  { roots: [], nodes: [], skins: [], animations: Map::new() }
}

///|
fn default_scene_node_template() -> SceneNodeTemplate {
  {
    name: None,
    transform: {
      translation: @math.Vec3::zero(),
      rotation: @math.Quat::identity(),
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
) -> @entity.Entity {
  instantiate_scene_instance(scene, root_transform).root
}

///|
pub fn instantiate_scene_instance(
  scene : @render3d.SceneHandle,
  root_transform : @transform.Transform,
) -> SceneInstance {
  let root = @entity.Entity()
  @transform.transforms().set(root, root_transform)
  @name.names().set(root, @name.Name("scene_root"))
  let parts : Map[String, @entity.Entity] = Map::new()
  guard scene_templates.get(scene) is Some(template) else {
    return { root, parts, animations: Map::new() }
  }
  let node_entities : Map[Int, @entity.Entity] = Map::new()
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
  let animation_nodes : Map[String, @animation.AnimationNodeIndex] = Map::new()
  if template.animations.length() > 0 {
    let graph = @animation.AnimationGraph()
    for name, clip in template.animations {
      let node = graph.add_clip(clip)
      animation_nodes.set(name, node)
    }
    let graph_handle = @animation.register_animation_graph_asset(graph)
    @animation.animation_graph_handles().set(root, graph_handle)
    @animation.animation_players().set(root, @animation.AnimationPlayer())
    @animation.animation_transitions().set(
      root,
      @animation.AnimationTransitions(),
    )
  }
  { root, parts, animations: animation_nodes }
}

///|
pub fn scene_instance_part(
  instance : SceneInstance,
  path : String,
) -> @entity.Entity? {
  instance.parts.get(path)
}
