///|
#derive(Eq)
priv struct UiMeasureSnapshot {
  text_content : String?
  font_handle : @asset.FontHandle?
  font_state : @asset.LoadState?
  font_metrics_revision : UInt32
  font_family : String?
  font_size : Double?
  line_height : Double
  wrap : TextWrap
  overflow : TextOverflow
  image_size : @math.Vec2?
}

///|
#derive(Eq)
priv struct UiProjectionSnapshot {
  target_camera : @ecs.Entity?
  target_viewport_position : @math.Vec2?
  target_viewport_size : @math.Vec2?
  scroll_position : @math.Vec2?
  use_rounding : Bool?
  override_clip : Bool
  overflow_clip_margin : OverflowClipMargin
}

///|
#derive(Eq)
priv struct UiStackSnapshot {
  displayed : Bool
  visible : Bool
  z_index : Int32?
  global_z_index : Int32?
}

///|
/// Chicle's Style does not implement Eq, so this stores the equivalent
/// normalized Selene values used to construct it.
#derive(Eq)
priv struct UiChicleStyleSnapshot {
  node : Node
}

///|
priv struct UiLayoutNodeRuntime {
  node_id : Int32
  mut source_node : Node
  mut chicle_style : UiChicleStyleSnapshot
  mut measure : UiMeasureSnapshot
  mut projection : UiProjectionSnapshot
  mut stack : UiStackSnapshot
  mut children : Array[@ecs.Entity]
}

///|
#derive(Eq)
priv struct UiLayoutRootSnapshot {
  target_camera : @ecs.Entity?
  viewport_position : @math.Vec2
  viewport_size : @math.Vec2
  logical_size : @math.Vec2
}

///|
priv struct UiLayoutRootRuntime {
  node_id : Int32
  mut child_node_id : Int32
  mut snapshot : UiLayoutRootSnapshot
}

///|
priv struct UiLayoutRuntime {
  tree : @tree.ChicleTree[@ecs.Entity]
  nodes : @ecs.EntityTable[UiLayoutNodeRuntime]
  roots : @ecs.EntityTable[UiLayoutRootRuntime]
  mut layout_revision : UInt32
  mut projection_revision : UInt32
  mut stacking_revision : UInt32
}

///|
priv struct UiLayoutDirty {
  mut layout : Bool
  mut projection : Bool
  mut stacking : Bool
}

///|
let ui_layout_runtime_key : @ecs.ResourceKey[UiLayoutRuntime] = ResourceKey()

///|
fn ui_layout_runtime() -> UiLayoutRuntime {
  ui_layout_runtime_key.get_or_insert_with(@ecs.require_current_world(), world => {
    tree: ChicleTree(),
    nodes: EntityTable(world),
    roots: EntityTable(world),
    layout_revision: 0U,
    projection_revision: 0U,
    stacking_revision: 0U,
  })
}

///|
fn normalize_style_val(value : Val) -> Val {
  match value {
    Px(value) => Px(@cmp.maximum(0.0, value))
    Auto => Auto
    Percent(value) => Percent(value)
  }
}

///|
fn normalize_style_rect(rect : UiRectValues) -> UiRectValues {
  {
    left: normalize_style_val(rect.left),
    right: normalize_style_val(rect.right),
    top: normalize_style_val(rect.top),
    bottom: normalize_style_val(rect.bottom),
  }
}

///|
fn normalize_style_grid_track(track : GridTrack) -> GridTrack {
  match track {
    Auto => Auto
    Px(value) => Px(@cmp.maximum(0.0, value))
    Percent(value) => Percent(value)
    Fr(value) => Fr(@cmp.maximum(0.0, value))
    MinContent => MinContent
    MaxContent => MaxContent
    FitContent(track) => FitContent(normalize_style_grid_track(track))
    MinMax(min, max) =>
      MinMax(normalize_style_grid_track(min), normalize_style_grid_track(max))
    Repeat(repetition, tracks) =>
      Repeat(repetition, tracks.map(normalize_style_grid_track))
  }
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
fn chicle_style_snapshot(node : Node) -> UiChicleStyleSnapshot {
  {
    node: {
      ..node,
      width: normalize_style_val(node.width),
      height: normalize_style_val(node.height),
      min_width: normalize_style_val(node.min_width),
      min_height: normalize_style_val(node.min_height),
      max_width: normalize_style_val(node.max_width),
      max_height: normalize_style_val(node.max_height),
      left: normalize_style_val(node.left),
      right: normalize_style_val(node.right),
      top: normalize_style_val(node.top),
      bottom: normalize_style_val(node.bottom),
      margin: normalize_style_rect(node.margin),
      padding: normalize_style_rect(node.padding),
      border: normalize_style_rect(node.border),
      row_gap: @cmp.maximum(0.0, node.row_gap),
      column_gap: @cmp.maximum(0.0, node.column_gap),
      overflow_clip_margin: OverflowClipMargin::content_box(),
      flex_basis: normalize_style_val(node.flex_basis),
      aspect_ratio: match node.aspect_ratio {
        Some(value) if value > 0.0 => Some(value)
        _ => None
      },
      scrollbar_width: @cmp.maximum(0.0, node.scrollbar_width),
      grid_template_rows: node.grid_template_rows.map(
        normalize_style_grid_track,
      ),
      grid_template_columns: node.grid_template_columns.map(
        normalize_style_grid_track,
      ),
      grid_auto_rows: node.grid_auto_rows.map(normalize_style_grid_track),
      grid_auto_columns: node.grid_auto_columns.map(normalize_style_grid_track),
      active: true,
    },
  }
}

///|
fn ui_measure_snapshot(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> UiMeasureSnapshot {
  let text = (world.get_component(entity) : Text?)
  let style = text_style_for(world~, entity)
  let layout = text_layout(world~, entity)
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
    image_size: (world.get_component(entity) : UiImage?).map(fn(value) {
      value.size
    }),
  }
}

///|
fn ui_projection_snapshot(
  world~ : @ecs.World,
  entity : @ecs.Entity,
) -> UiProjectionSnapshot {
  let query_override_clip : @ecs.Query[@ecs.Single[OverrideClip]] = world.query()
  let overflow_clip_margin = (world.get_component(entity) : Node?)
    .map(fn(node) { node.overflow_clip_margin })
    .unwrap_or(OverflowClipMargin::content_box())
  let (target_camera, target_viewport_position, target_viewport_size) = match
    (world.get_component(entity) : UiTargetCamera?) {
    Some(target) => {
      let space = ui_layout_space(world~, Some(target.camera))
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
    .map(fn(value) { Vec2(value.x, value.y) }),
    use_rounding: (world.get_component(entity) : LayoutConfig?).map(fn(value) {
      value.use_rounding
    }),
    override_clip: query_override_clip.contains(entity),
    overflow_clip_margin,
  }
}

///|
fn ui_stack_snapshot(
  world~ : @ecs.World,
  entity : @ecs.Entity,
  node : Node,
) -> UiStackSnapshot {
  {
    displayed: node.display != None,
    visible: @visibility.is_visible(entity),
    z_index: (world.get_component(entity) : ZIndex?).map(fn(value) {
      value.value
    }),
    global_z_index: (world.get_component(entity) : GlobalZIndex?).map(fn(
      value,
    ) {
      value.value
    }),
  }
}

///|
fn ui_root_snapshot(
  world~ : @ecs.World,
  root : @ecs.Entity,
) -> UiLayoutRootSnapshot {
  let space = ui_layout_space(
    world~,
    (world.get_component(root) : UiTargetCamera?).map(fn(target) {
      target.camera
    }),
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
  node_id : Int32,
  style : @style.Style,
) -> Unit {
  runtime.tree.set_style(node_id, style) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn set_chicle_children(
  runtime : UiLayoutRuntime,
  node_id : Int32,
  children : Array[Int32],
) -> Unit {
  runtime.tree.set_children(node_id, children) catch {
    _ => abort("UI layout runtime contains an invalid Chicle hierarchy")
  }
}

///|
fn mark_chicle_dirty(runtime : UiLayoutRuntime, node_id : Int32) -> Unit {
  runtime.tree.mark_dirty(node_id) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn remove_chicle_node(runtime : UiLayoutRuntime, node_id : Int32) -> Unit {
  runtime.tree.remove(node_id) catch {
    _ => abort("UI layout runtime contains an invalid Chicle node")
  }
}

///|
fn sync_layout_node(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  entity : @ecs.Entity,
  reachable : Set[@ecs.Entity],
  dirty : UiLayoutDirty,
) -> Int32? {
  let query_node : @ecs.Query[@ecs.Single[Node]] = world.query()
  guard query_node.get(entity).map(value => value.0) is Some(node) else {
    return None
  }
  guard node.active else { return None }
  reachable.add(entity)
  let measure = ui_measure_snapshot(world~, entity)
  let projection = ui_projection_snapshot(world~, entity)
  let stack = ui_stack_snapshot(world~, entity, node)
  let (node_id, state) = match runtime.nodes.get(entity) {
    Some(state) => {
      let node_id = state.node_id
      if node != state.source_node {
        let chicle_style = chicle_style_snapshot(node)
        if chicle_style != state.chicle_style {
          set_chicle_style(runtime, node_id, node_to_chicle_style(node))
          state.chicle_style = chicle_style
          dirty.layout = true
        }
        state.source_node = clone_layout_node(node)
      }
      if measure != state.measure {
        mark_chicle_dirty(runtime, node_id)
        state.measure = measure
        dirty.layout = true
      }
      if projection != state.projection {
        state.projection = projection
        dirty.projection = true
      }
      if stack != state.stack {
        state.stack = stack
        dirty.stacking = true
      }
      (node_id, state)
    }
    None => {
      let node_id = runtime.tree.new_leaf_with_context(
        node_to_chicle_style(node),
        entity,
      )
      let state = {
        node_id,
        source_node: clone_layout_node(node),
        chicle_style: chicle_style_snapshot(node),
        measure,
        projection,
        stack,
        children: [],
      }
      runtime.nodes.set(entity, state)
      dirty.layout = true
      dirty.projection = true
      dirty.stacking = true
      (node_id, state)
    }
  }

  let child_entities : Array[@ecs.Entity] = []
  let child_ids : Array[Int32] = []
  for child in ui_children(world~, entity) {
    if sync_layout_node(world~, runtime, child, reachable, dirty)
      is Some(child_id) {
      child_entities.push(child)
      child_ids.push(child_id)
    }
  }
  if child_entities != state.children {
    set_chicle_children(runtime, node_id, child_ids)
    state.children = child_entities
    dirty.layout = true
    dirty.stacking = true
  }
  if !ui_geometry().contains(entity) {
    dirty.projection = true
  }
  if !tree_orders().contains(entity) {
    dirty.stacking = true
  }
  Some(node_id)
}

///|
fn remove_stale_layout_nodes(
  runtime : UiLayoutRuntime,
  reachable : Set[@ecs.Entity],
  dirty : UiLayoutDirty,
) -> Unit {
  let stale : Array[@ecs.Entity] = []
  for entity, _ in runtime.nodes {
    if !reachable.contains(entity) {
      stale.push(entity)
    }
  }
  for entity in stale {
    if runtime.nodes.get(entity) is Some(state) {
      remove_chicle_node(runtime, state.node_id)
    }
    runtime.nodes.remove(entity)
    dirty.layout = true
    dirty.projection = true
    dirty.stacking = true
  }
}

///|
fn sync_layout_roots(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  roots : Array[@ecs.Entity],
  dirty : UiLayoutDirty,
) -> Unit {
  for root in roots {
    guard runtime.nodes.get(root) is Some(root_node) else { continue }
    let root_node_id = root_node.node_id
    let snapshot = ui_root_snapshot(world~, root)
    match runtime.roots.get(root) {
      Some(root_runtime) => {
        if snapshot != root_runtime.snapshot {
          if snapshot.logical_size != root_runtime.snapshot.logical_size {
            set_chicle_style(
              runtime,
              root_runtime.node_id,
              implicit_root_style(snapshot.logical_size),
            )
            dirty.layout = true
          }
          dirty.projection = true
          root_runtime.snapshot = snapshot
        }
        if root_node_id != root_runtime.child_node_id {
          set_chicle_children(runtime, root_runtime.node_id, [root_node_id])
          root_runtime.child_node_id = root_node_id
          dirty.layout = true
          dirty.stacking = true
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
        dirty.layout = true
        dirty.projection = true
        dirty.stacking = true
      }
    }
  }

  let stale : Array[@ecs.Entity] = []
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
    dirty.layout = true
    dirty.projection = true
    dirty.stacking = true
  }
}

///|
fn compute_dirty_layout_roots(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  roots : Array[@ecs.Entity],
  dirty : UiLayoutDirty,
) -> Unit {
  guard dirty.layout else { return }
  let mut computed = false
  for root in roots {
    guard runtime.roots.get(root) is Some(root_runtime) else { continue }
    let dirty = runtime.tree.dirty(root_runtime.node_id) catch {
      _ => abort("UI layout runtime contains an invalid Chicle root")
    }
    guard dirty else { continue }
    let viewport = root_runtime.snapshot.logical_size
    runtime.tree.compute_layout_with_measure(
      root_runtime.node_id,
      Size(
        width=@style_helpers.available_space_definite(viewport.x),
        height=@style_helpers.available_space_definite(viewport.y),
      ),
      (known, available, id, entity, style) => {
        measure_node(world~, known, available, id, entity, style)
      },
    ) catch {
      _ => abort("UI layout runtime failed to compute a valid Chicle root")
    }
    computed = true
  }
  if computed {
    runtime.layout_revision = runtime.layout_revision + 1U
    dirty.projection = true
  }
}

///|
fn project_layout(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  roots : Array[@ecs.Entity],
) -> Unit {
  let projected : Set[@ecs.Entity] = Set([])
  for root in roots {
    guard runtime.roots.get(root) is Some(root_runtime) else { continue }
    let snapshot = root_runtime.snapshot
    let layout_space = UiLayoutSpace(
      { position: snapshot.viewport_position, size: snapshot.viewport_size, },
      target_camera=snapshot.target_camera,
    )
    apply_layout_recursive(
      world~,
      root,
      runtime.tree,
      runtime.nodes,
      @math.Vec2::zero(),
      None,
      true,
      layout_space,
      projected,
    )
  }
  ui_geometry().retain((entity, _) => projected.contains(entity))
  calculated_clips().retain((entity, _) => projected.contains(entity))
}

///|
fn record_ui_tree_order(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  entity : @ecs.Entity,
  order : Ref[Int32],
) -> Unit {
  guard runtime.nodes.contains(entity) else { return }
  order.val += 1
  tree_orders().set(entity, order.val)
  for child in ui_children(world~, entity) {
    record_ui_tree_order(world~, runtime, child, order)
  }
}

///|
fn rebuild_layout_stack(
  world~ : @ecs.World,
  runtime : UiLayoutRuntime,
  roots : Array[@ecs.Entity],
) -> Unit {
  let order = Ref(0)
  for root in roots {
    record_ui_tree_order(world~, runtime, root, order)
  }
  tree_orders().retain((entity, _) => runtime.nodes.contains(entity))
  rebuild_ui_stack(world~)
}

///|
pub fn ui_layout_system(world~ : @ecs.World, _delta : Double) -> Unit {
  cleanup_dead_ui_state()
  let runtime = ui_layout_runtime()
  let roots = top_level_ui_nodes(world~)
  let reachable : Set[@ecs.Entity] = Set([])
  let dirty : UiLayoutDirty = {
    layout: false,
    projection: false,
    stacking: false,
  }
  for root in roots {
    ignore(sync_layout_node(world~, runtime, root, reachable, dirty))
  }
  sync_layout_roots(world~, runtime, roots, dirty)
  remove_stale_layout_nodes(runtime, reachable, dirty)
  compute_dirty_layout_roots(world~, runtime, roots, dirty)
  if dirty.projection {
    project_layout(world~, runtime, roots)
    runtime.projection_revision = runtime.projection_revision + 1U
  }
  if dirty.stacking {
    rebuild_layout_stack(world~, runtime, roots)
    runtime.stacking_revision = runtime.stacking_revision + 1U
  }
}
