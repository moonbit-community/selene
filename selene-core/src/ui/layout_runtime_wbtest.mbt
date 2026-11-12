///|
test "retained UI layout stays clean until measured content changes" {
  let world = @ecs.require_current_world()
  let entity_draft = @ecs.commands(@ecs.require_current_world()).draft()
  entity_draft.add((Node() : Node))
  entity_draft.add((Text("A") : Text))
  entity_draft.add((TextFont(size=16.0) : TextFont))
  let entity = @ecs_test.spawn_draft(entity_draft)

  ui_layout_system(world~, 0.0)
  let initial_width = computed_ui_node(entity).unwrap().size.x
  let runtime = ui_layout_runtime()
  let root = runtime.roots.get(entity).unwrap()
  assert_false(runtime.tree.dirty(root.node_id))

  ui_layout_system(world~, 0.0)
  assert_false(runtime.tree.dirty(root.node_id))
  assert_eq(computed_ui_node(entity).unwrap().size.x, initial_width)

  (world.query() : @ecs.Query[@ecs.Single[Text]])
  .get(entity)
  .map(value => value.0)
  .unwrap().content
  = "A much longer label"
  ui_layout_system(world~, 0.0)
  assert_true(computed_ui_node(entity).unwrap().size.x > initial_width)
  assert_false(runtime.tree.dirty(root.node_id))

  cleanup_layout_test_entity(entity)
  ui_layout_system(world~, 0.0)
}

///|
test "retained UI layout updates replaced subtrees" {
  let world = @ecs.require_current_world()
  let root = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(300.0), height=Val::px(100.0), flex_direction=Row),
  )
  let left = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(100.0), height=Val::px(100.0)),
    parent=root,
  )
  let right = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(100.0), height=Val::px(100.0)),
    parent=root,
  )
  let child = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(20.0), height=Val::px(20.0)),
    parent=left,
  )

  ui_layout_system(world~, 0.0)
  assert_eq(computed_ui_node(child).unwrap().position.x, 0.0)

  assert_true(@ecs_test.delete(child))
  let child = @ecs_test.spawn1(
    world,
    Node(width=Val::px(20.0), height=Val::px(20.0)),
    parent=right,
  )
  ui_layout_system(world~, 0.0)
  assert_eq(computed_ui_node(child).unwrap().position.x, 100.0)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(right)
  cleanup_layout_test_entity(left)
  cleanup_layout_test_entity(root)
  ui_layout_system(world~, 0.0)
}

///|
test "retained UI stacking changes do not reproject or relayout" {
  let world = @ecs.require_current_world()
  let entity = @ecs_test.spawn(
    @ecs.require_current_world(),
    (
      Node(width=Val::px(100.0), height=Val::px(100.0)),
      ZIndex(0),
      @visibility.Visibility::Visible,
    ),
  )
  ui_layout_system(world~, 0.0)
  let runtime = ui_layout_runtime()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  world.set_component(entity, (ZIndex(4) : ZIndex))
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision + 1U)

  world.set_component(entity, (Hidden : @visibility.Visibility))
  @visibility.visibility_propagate_system(world~, 0.0)
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision + 2U)
  assert_false(ui_stack().contains(entity))

  cleanup_layout_test_entity(entity)
  ui_layout_system(world~, 0.0)
}

///|
test "retained UI projection changes do not rebuild layout or stacking" {
  let world = @ecs.require_current_world()
  let camera_draft = @ecs.commands(@ecs.require_current_world()).draft()
  camera_draft.add(
    (
      Camera(viewport=Some(CameraViewport(Vec2(0.0, 0.0), Vec2(100.0, 100.0)))) :
      @camera.Camera),
  )
  camera_draft.add((Camera2d() : @camera.Camera2d))
  camera_draft.add(
    (Spatial(@transform.Transform::default()) : @transform.Spatial),
  )
  let camera = @ecs_test.spawn_draft(camera_draft)
  let root = @ecs_test.spawn(
    @ecs.require_current_world(),
    (
      Node(
        width=Val::px(100.0),
        height=Val::px(100.0),
        overflow_x=Scroll,
        overflow_y=Hidden,
      ),
      UiTargetCamera(camera),
    ),
  )
  let child = @ecs_test.spawn1(
    @ecs.require_current_world(),
    Node(width=Val::px(200.0), height=Val::px(100.0)),
    parent=root,
  )
  ui_layout_system(world~, 0.0)
  let runtime = ui_layout_runtime()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  set_scroll_position(world~, root, { x: 10.0, y: 0.0, })
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 1U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  let node = (world.query() : @ecs.Query[@ecs.Single[Node]])
    .get(root)
    .map(value => value.0)
    .unwrap()
  world.set_component(
    root,
    (
      {
        ..node,
        overflow_clip_margin: OverflowClipMargin::padding_box().with_margin(3.0),
      } : Node),
  )
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 2U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  world.set_component(
    camera,
    (
      Camera(viewport=Some(CameraViewport(Vec2(8.0, 6.0), Vec2(100.0, 100.0)))) :
      @camera.Camera),
  )
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 3U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(root)
  ignore(@ecs_test.delete(camera))
  ui_layout_system(world~, 0.0)
}

///|
test "retained UI compares normalized Chicle styles" {
  let world = @ecs.require_current_world()
  let entity = @ecs_test.spawn1(
    world,
    Node(
      width=Val::px(100.0),
      height=Val::px(100.0),
      margin=UiRectValues::all(0.0),
    ),
  )
  ui_layout_system(world~, 0.0)
  let runtime = ui_layout_runtime()
  let root = runtime.roots.get(entity).unwrap()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  let node = (world.query() : @ecs.Query[@ecs.Single[Node]])
    .get(entity)
    .map(value => value.0)
    .unwrap()
  world.set_component(
    entity,
    ({ ..node, margin: UiRectValues::all(-8.0), } : Node),
  )
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision)
  assert_false(runtime.tree.dirty(root.node_id))

  let node = (world.query() : @ecs.Query[@ecs.Single[Node]])
    .get(entity)
    .map(value => value.0)
    .unwrap()
  world.set_component(entity, ({ ..node, width: Val::px(120.0), } : Node))
  ui_layout_system(world~, 0.0)
  assert_eq(runtime.layout_revision, layout_revision + 1U)
  assert_eq(runtime.projection_revision, projection_revision + 1U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(entity)
  ui_layout_system(world~, 0.0)
}

///|
test "layout frees the old Chicle node when a deleted entity slot is reused" {
  let previous = @ecs.current_world()
  defer (match previous {
    Some(world) => @ecs.set_current_world(world)
    None => @ecs.clear_current_world()
  })
  let world = @ecs.World()
  @ecs.set_current_world(world)
  let old = @ecs_test.spawn1(world, Node(width=Val::px(10.0)))
  ui_layout_system(world~, 0.0)
  let runtime = ui_layout_runtime()
  let old_node = runtime.nodes.get(old).unwrap().node_id
  ignore(@ecs_test.delete(old))
  let replacement = @ecs_test.spawn1(world, Node(width=Val::px(30.0)))
  assert_eq(old.slot_index(), replacement.slot_index())
  ui_layout_system(world~, 0.0)
  assert_true(computed_ui_node(old) is None)
  assert_eq(computed_ui_node(replacement).unwrap().size.x, 30.0)
  assert_false(runtime.nodes.contains(old))
  assert_eq(runtime.nodes.length(), 1)
  try runtime.tree.dirty(old_node) catch {
    _ => ()
  } noraise {
    _ => fail("deleted Chicle node was not released")
  }
}
