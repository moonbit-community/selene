///|
test "retained UI layout stays clean until measured content changes" {
  let entity_draft = @ecs.require_current_world().spawn_draft()
  entity_draft.add_to(nodes(), Node())
  entity_draft.add_to(texts(), Text("A"))
  entity_draft.add_to(text_fonts(), TextFont(size=16.0))
  let entity = entity_draft.spawn()

  ui_layout_system(0.0)
  let initial_width = computed_ui_node(entity).unwrap().size.x
  let runtime = ui_layout_runtime()
  let root = runtime.roots.get(entity).unwrap()
  assert_false(runtime.tree.dirty(root.node_id))

  ui_layout_system(0.0)
  assert_false(runtime.tree.dirty(root.node_id))
  assert_eq(computed_ui_node(entity).unwrap().size.x, initial_width)

  texts().get(entity).unwrap().content = "A much longer label"
  ui_layout_system(0.0)
  assert_true(computed_ui_node(entity).unwrap().size.x > initial_width)
  assert_false(runtime.tree.dirty(root.node_id))

  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}

///|
test "retained UI layout updates replaced subtrees" {
  let root = @ecs.require_current_world().spawn1(
    Node(width=Val::px(300.0), height=Val::px(100.0), flex_direction=Row),
  )
  let left = @ecs.require_current_world().spawn1(
    Node(width=Val::px(100.0), height=Val::px(100.0)),
    parent=root,
  )
  let right = @ecs.require_current_world().spawn1(
    Node(width=Val::px(100.0), height=Val::px(100.0)),
    parent=root,
  )
  let child = @ecs.require_current_world().spawn1(
    Node(width=Val::px(20.0), height=Val::px(20.0)),
    parent=left,
  )

  ui_layout_system(0.0)
  assert_eq(computed_ui_node(child).unwrap().position.x, 0.0)

  assert_true(child.delete())
  let child = nodes()
    .spawn_plan(@ecs.require_current_world())
    .spawn(Node(width=Val::px(20.0), height=Val::px(20.0)), parent=right)
  ui_layout_system(0.0)
  assert_eq(computed_ui_node(child).unwrap().position.x, 100.0)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(right)
  cleanup_layout_test_entity(left)
  cleanup_layout_test_entity(root)
  ui_layout_system(0.0)
}

///|
test "retained UI stacking changes do not reproject or relayout" {
  let entity = @ecs.require_current_world().spawn(
    (Node(width=Val::px(100.0), height=Val::px(100.0)), ZIndex(0)),
  )
  ui_layout_system(0.0)
  let runtime = ui_layout_runtime()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  z_indexes().set(entity, ZIndex(4))
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision + 1U)

  @visibility.view_visibilities().set(entity, { visible: false, })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision + 2U)
  assert_false(ui_stack().contains(entity))

  ignore(@visibility.view_visibilities().remove(entity))
  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}

///|
test "retained UI projection changes do not rebuild layout or stacking" {
  let camera_draft = @ecs.require_current_world().spawn_draft()
  camera_draft.add_to(
    @camera.cameras(),
    Camera(viewport=Some(CameraViewport(Vec2(0.0, 0.0), Vec2(100.0, 100.0)))),
  )
  camera_draft.add_to(@camera.camera2ds(), Camera2d())
  camera_draft.add_to(
    @transform.spatials(),
    Spatial(@transform.Transform::default()),
  )
  let camera = camera_draft.spawn()
  let root = @ecs.require_current_world().spawn(
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
  let child = @ecs.require_current_world().spawn1(
    Node(width=Val::px(200.0), height=Val::px(100.0)),
    parent=root,
  )
  ui_layout_system(0.0)
  let runtime = ui_layout_runtime()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  scroll_positions().set(root, { x: 10.0, y: 0.0, })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 1U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  let node = nodes().get(root).unwrap()
  nodes().set(root, {
    ..node,
    overflow_clip_margin: OverflowClipMargin::padding_box().with_margin(3.0),
  })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 2U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  @camera.cameras().set(
    camera,
    Camera(viewport=Some(CameraViewport(Vec2(8.0, 6.0), Vec2(100.0, 100.0)))),
  )
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 3U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(root)
  ignore(camera.delete())
  ui_layout_system(0.0)
}

///|
test "retained UI compares normalized Chicle styles" {
  let entity = nodes()
    .spawn_plan(@ecs.require_current_world())
    .spawn(
      Node(
        width=Val::px(100.0),
        height=Val::px(100.0),
        margin=UiRectValues::all(0.0),
      ),
    )
  ui_layout_system(0.0)
  let runtime = ui_layout_runtime()
  let root = runtime.roots.get(entity).unwrap()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  let node = nodes().get(entity).unwrap()
  nodes().set(entity, { ..node, margin: UiRectValues::all(-8.0), })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision)
  assert_false(runtime.tree.dirty(root.node_id))

  let node = nodes().get(entity).unwrap()
  nodes().set(entity, { ..node, width: Val::px(120.0), })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision + 1U)
  assert_eq(runtime.projection_revision, projection_revision + 1U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}
