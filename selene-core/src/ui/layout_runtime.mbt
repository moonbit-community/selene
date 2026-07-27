///|
priv struct UiMeasureSnapshot {
  text_content : String?
  font_handle : @asset.FontHandle?
  font_state : @asset.LoadState?
  font_metrics_revision : UInt
  font_family : String?
  font_size : Double?
  line_height : Double
  wrap : TextWrap
  overflow : TextOverflow
  image_size : @math.Vec2?
} derive(Eq)

///|
priv struct UiProjectionSnapshot {
  target_camera : @entity.Entity?
  target_viewport_position : @math.Vec2?
  target_viewport_size : @math.Vec2?
  scroll_position : @math.Vec2?
  use_rounding : Bool?
  override_clip : Bool
  visible : Bool
  z_index : Int?
  global_z_index : Int?
} derive(Eq)

///|
priv struct UiLayoutNodeRuntime {
  mut node : Node
  mut measure : UiMeasureSnapshot
  mut projection : UiProjectionSnapshot
  mut children : Array[@entity.Entity]
}

///|
priv struct UiLayoutRootSnapshot {
  target_camera : @entity.Entity?
  viewport_position : @math.Vec2
  viewport_size : @math.Vec2
  logical_size : @math.Vec2
} derive(Eq)

///|
priv struct UiLayoutRootRuntime {
  node_id : Int
  mut child_node_id : Int
  mut snapshot : UiLayoutRootSnapshot
}

///|
priv struct UiLayoutRuntime {
  tree : @tree.ChicleTree[@entity.Entity]
  node_ids : Map[@entity.Entity, Int]
  nodes : Map[@entity.Entity, UiLayoutNodeRuntime]
  roots : Map[@entity.Entity, UiLayoutRootRuntime]
}

///|
let ui_layout_runtimes : Map[UInt, UiLayoutRuntime] = Map([])

///|
fn ui_layout_runtime() -> UiLayoutRuntime {
  let world_id = @ecs.require_current_world().id()
  ui_layout_runtimes.get_or_init(world_id, () => {
    tree: @tree.ChicleTree(),
    node_ids: Map([]),
    nodes: Map([]),
    roots: Map([]),
  })
}

///|
fn clone_grid_track(track : GridTrack) -> GridTrack {
  match track {
    Auto => Auto
    Px(value) => Px(value)
    Percent(value) => Percent(value)
    Fr(value) => Fr(value)
    MinContent => MinContent
    MaxContent => MaxContent
    FitContent(track) => FitContent(clone_grid_track(track))
    MinMax(min, max) => MinMax(clone_grid_track(min), clone_grid_track(max))
    Repeat(repetition, tracks) =>
      Repeat(repetition, tracks.map(clone_grid_track))
  }
}

///|
fn clone_layout_node(node : Node) -> Node {
  {
    ..node,
    grid_template_rows: node.grid_template_rows.map(clone_grid_track),
    grid_template_columns: node.grid_template_columns.map(clone_grid_track),
    grid_auto_rows: node.grid_auto_rows.map(clone_grid_track),
    grid_auto_columns: node.grid_auto_columns.map(clone_grid_track),
  }
}

///|
fn ui_measure_snapshot(entity : @entity.Entity) -> UiMeasureSnapshot {
  let text = texts().get(entity)
  let style = text_style_for(entity)
  let layout = text_layout(entity)
  let font_handle = match style {
    Some(value) => value.font
    None => None
  }
  {
    text_content: text.map(fn(value) { value.content }),
    font_handle,
    font_state: font_handle.map(@asset.font_load_state),
    font_metrics_revision: style
    .map(fn(value) { @platform_render.font_metrics_revision(value.family) })
    .unwrap_or(0U),
    font_family: style.map(fn(value) { value.family }),
    font_size: style.map(fn(value) { value.size }),
    line_height: layout.line_height,
    wrap: layout.wrap,
    overflow: layout.overflow,
    image_size: ui_images().get(entity).map(fn(value) { value.size }),
  }
}

///|
fn ui_projection_snapshot(entity : @entity.Entity) -> UiProjectionSnapshot {
  let (target_camera, target_viewport_position, target_viewport_size) = match
    ui_target_cameras().get(entity) {
    Some(target) => {
      let space = ui_layout_space(Some(target.camera))
      (
        space.target_camera,
        Some(space.viewport.position),
        Some(space.viewport.size),
      )
    }
    None => (None, None, None)
  }
  {
    target_camera,
    target_viewport_position,
    target_viewport_size,
    scroll_position: scroll_positions()
    .get(entity)
    .map(fn(value) { @math.Vec2(value.x, value.y) }),
    use_rounding: layout_configs()
    .get(entity)
    .map(fn(value) { value.use_rounding }),
    override_clip: override_clips().contains(entity),
    visible: @visibility.is_visible(entity),
    z_index: z_indexes().get(entity).map(fn(value) { value.value }),
    global_z_index: global_zindexes().get(entity).map(fn(value) { value.value }),
  }
}

///|
fn ui_root_snapshot(root : @entity.Entity) -> UiLayoutRootSnapshot {
  let space = ui_layout_space(
    ui_target_cameras().get(root).map(fn(target) { target.camera }),
  )
  {
    target_camera: space.target_camera,
    viewport_position: space.viewport.position,
    viewport_size: space.viewport.size,
    logical_size: ui_layout_root_size(space),
  }
}

///|
fn set_chicle_style(
  runtime : UiLayoutRuntime,
  node_id : Int,
  style : @style.Style,
) -> Unit {
  runtime.tree.set_style(node_id, style) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn set_chicle_children(
  runtime : UiLayoutRuntime,
  node_id : Int,
  children : Array[Int],
) -> Unit {
  runtime.tree.set_children(node_id, children) catch {
    _ => abort("UI layout runtime contains an invalid Chicle hierarchy")
  }
}

///|
fn mark_chicle_dirty(runtime : UiLayoutRuntime, node_id : Int) -> Unit {
  runtime.tree.mark_dirty(node_id) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn remove_chicle_node(runtime : UiLayoutRuntime, node_id : Int) -> Unit {
  runtime.tree.remove(node_id) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn sync_layout_node(
  runtime : UiLayoutRuntime,
  entity : @entity.Entity,
  reachable : Set[@entity.Entity],
  projection_changed : Ref[Bool],
) -> Int? {
  guard nodes().get(entity) is Some(node) else { return None }
  guard node.active else { return None }
  reachable.add(entity)
  let measure = ui_measure_snapshot(entity)
  let projection = ui_projection_snapshot(entity)
  let (node_id, state) = match runtime.nodes.get(entity) {
    Some(state) => {
      let node_id = runtime.node_ids.get(entity).unwrap()
      if node != state.node {
        set_chicle_style(runtime, node_id, node_to_chicle_style(node))
        state.node = clone_layout_node(node)
      }
      if measure != state.measure {
        mark_chicle_dirty(runtime, node_id)
        state.measure = measure
      }
      if projection != state.projection {
        state.projection = projection
        projection_changed.val = true
      }
      (node_id, state)
    }
    None => {
      let node_id = runtime.tree.new_leaf_with_context(
        node_to_chicle_style(node),
        entity,
      )
      let state = {
        node: clone_layout_node(node),
        measure,
        projection,
        children: [],
      }
      runtime.node_ids.set(entity, node_id)
      runtime.nodes.set(entity, state)
      projection_changed.val = true
      (node_id, state)
    }
  }

  let child_entities : Array[@entity.Entity] = []
  let child_ids : Array[Int] = []
  for child in ui_children(entity) {
    if sync_layout_node(runtime, child, reachable, projection_changed)
      is Some(child_id) {
      child_entities.push(child)
      child_ids.push(child_id)
    }
  }
  if child_entities != state.children {
    set_chicle_children(runtime, node_id, child_ids)
    state.children = child_entities
    projection_changed.val = true
  }
  if !computed_ui_nodes().contains(entity) ||
    !global_ui_nodes().contains(entity) ||
    !tree_orders().contains(entity) {
    projection_changed.val = true
  }
  Some(node_id)
}

///|
fn remove_stale_layout_nodes(
  runtime : UiLayoutRuntime,
  reachable : Set[@entity.Entity],
  projection_changed : Ref[Bool],
) -> Unit {
  let stale : Array[@entity.Entity] = []
  for entity, _ in runtime.nodes {
    if !reachable.contains(entity) {
      stale.push(entity)
    }
  }
  for entity in stale {
    if runtime.node_ids.get(entity) is Some(node_id) {
      remove_chicle_node(runtime, node_id)
    }
    runtime.node_ids.remove(entity)
    runtime.nodes.remove(entity)
    projection_changed.val = true
  }
}

///|
fn sync_layout_roots(
  runtime : UiLayoutRuntime,
  roots : Array[@entity.Entity],
  projection_changed : Ref[Bool],
) -> Unit {
  for root in roots {
    guard runtime.node_ids.get(root) is Some(root_node_id) else { continue }
    let snapshot = ui_root_snapshot(root)
    match runtime.roots.get(root) {
      Some(root_runtime) => {
        if snapshot != root_runtime.snapshot {
          if snapshot.logical_size != root_runtime.snapshot.logical_size {
            set_chicle_style(
              runtime,
              root_runtime.node_id,
              implicit_root_style(snapshot.logical_size),
            )
          }
          root_runtime.snapshot = snapshot
          projection_changed.val = true
        }
        if root_node_id != root_runtime.child_node_id {
          set_chicle_children(runtime, root_runtime.node_id, [root_node_id])
          root_runtime.child_node_id = root_node_id
          projection_changed.val = true
        }
      }
      None => {
        let node_id = runtime.tree.new_with_children(
          implicit_root_style(snapshot.logical_size),
          [root_node_id],
        )
        runtime.roots.set(root, {
          node_id,
          child_node_id: root_node_id,
          snapshot,
        })
        projection_changed.val = true
      }
    }
  }

  let stale : Array[@entity.Entity] = []
  for root, _ in runtime.roots {
    if !roots.contains(root) {
      stale.push(root)
    }
  }
  for root in stale {
    if runtime.roots.get(root) is Some(root_runtime) {
      remove_chicle_node(runtime, root_runtime.node_id)
    }
    runtime.roots.remove(root)
    projection_changed.val = true
  }
}

///|
fn compute_dirty_layout_roots(
  runtime : UiLayoutRuntime,
  roots : Array[@entity.Entity],
  projection_changed : Ref[Bool],
) -> Unit {
  for root in roots {
    guard runtime.roots.get(root) is Some(root_runtime) else { continue }
    let dirty = runtime.tree.dirty(root_runtime.node_id) catch {
      _ => abort("UI layout runtime contains an invalid Chicle root")
    }
    guard dirty else { continue }
    let viewport = root_runtime.snapshot.logical_size
    runtime.tree.compute_layout_with_measure(
      root_runtime.node_id,
      @geometry.Size(
        width=@style_helpers.available_space_definite(viewport[X]),
        height=@style_helpers.available_space_definite(viewport[Y]),
      ),
      measure_node,
    ) catch {
      _ => abort("UI layout runtime failed to compute a valid Chicle root")
    }
    projection_changed.val = true
  }
}

///|
fn project_layout(
  runtime : UiLayoutRuntime,
  roots : Array[@entity.Entity],
) -> Unit {
  computed_ui_nodes().clear()
  global_ui_nodes().clear()
  calculated_clips().clear()
  tree_orders().clear()
  let order_counter : Ref[Int] = Ref(0)
  for root in roots {
    guard runtime.roots.get(root) is Some(root_runtime) else { continue }
    let snapshot = root_runtime.snapshot
    let layout_space = UiLayoutSpace(
      { position: snapshot.viewport_position, size: snapshot.viewport_size },
      target_camera=snapshot.target_camera,
    )
    apply_layout_recursive(
      root,
      runtime.tree,
      runtime.node_ids,
      @math.Vec2::zero(),
      None,
      true,
      order_counter,
      layout_space,
    )
  }
  rebuild_ui_stack()
}

///|
pub fn ui_layout_system(_delta : Double) -> Unit {
  cleanup_dead_ui_state()
  let runtime = ui_layout_runtime()
  let roots = top_level_ui_nodes()
  let reachable : Set[@entity.Entity] = Set([])
  let projection_changed = Ref(false)
  for root in roots {
    ignore(sync_layout_node(runtime, root, reachable, projection_changed))
  }
  sync_layout_roots(runtime, roots, projection_changed)
  remove_stale_layout_nodes(runtime, reachable, projection_changed)
  compute_dirty_layout_roots(runtime, roots, projection_changed)
  if projection_changed.val {
    project_layout(runtime, roots)
  }
}
