///|
test "retained UI layout stays clean until measured content changes" {
  let entity = @entity.Entity()
  nodes().set(entity, Node())
  texts().set(entity, Text("A"))
  text_fonts().set(entity, TextFont(size=16.0))

  ui_layout_system(0.0)
  let initial_width = computed_ui_nodes().get(entity).unwrap().size[X]
  let runtime = ui_layout_runtime()
  let root = runtime.roots.get(entity).unwrap()
  assert_false(runtime.tree.dirty(root.node_id))

  ui_layout_system(0.0)
  assert_false(runtime.tree.dirty(root.node_id))
  assert_eq(computed_ui_nodes().get(entity).unwrap().size[X], initial_width)

  texts().get(entity).unwrap().content = "A much longer label"
  ui_layout_system(0.0)
  assert_true(computed_ui_nodes().get(entity).unwrap().size[X] > initial_width)
  assert_false(runtime.tree.dirty(root.node_id))

  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}

///|
test "retained UI layout updates reparented subtrees" {
  let root = @entity.Entity()
  let left = @entity.Entity()
  let right = @entity.Entity()
  let child = @entity.Entity()
  nodes().set(
    root,
    Node(width=Val::px(300.0), height=Val::px(100.0), flex_direction=Row),
  )
  nodes().set(left, Node(width=Val::px(100.0), height=Val::px(100.0)))
  nodes().set(right, Node(width=Val::px(100.0), height=Val::px(100.0)))
  nodes().set(child, Node(width=Val::px(20.0), height=Val::px(20.0)))
  left.set_parent(root)
  right.set_parent(root)
  child.set_parent(left)

  ui_layout_system(0.0)
  assert_eq(computed_ui_nodes().get(child).unwrap().position[X], 0.0)

  child.set_parent(right)
  ui_layout_system(0.0)
  assert_eq(computed_ui_nodes().get(child).unwrap().position[X], 100.0)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(right)
  cleanup_layout_test_entity(left)
  cleanup_layout_test_entity(root)
  ui_layout_system(0.0)
}

///|
test "retained UI stacking changes do not reproject or relayout" {
  let entity = @entity.Entity()
  nodes().set(entity, Node(width=Val::px(100.0), height=Val::px(100.0)))
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

  @visibility.view_visibilities().set(entity, { visible: false })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision + 2U)
  assert_false(ui_stack().contains(entity))

  @visibility.view_visibilities().remove(entity)
  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}

///|
test "retained UI projection changes do not rebuild layout or stacking" {
  let camera = @entity.Entity()
  @camera.cameras().set(
    camera,
    Camera(
      viewport=Some(
        CameraViewport(@math.Vec2(0.0, 0.0), @math.Vec2(100.0, 100.0)),
      ),
    ),
  )
  @camera.camera2ds().set(camera, Camera2d())
  @transform.global_transforms().set(
    camera,
    @transform.GlobalTransform::from_transform(@transform.Transform::default()),
  )
  let root = @entity.Entity()
  let child = root.spawn_child()
  nodes().set(
    root,
    Node(
      width=Val::px(100.0),
      height=Val::px(100.0),
      overflow_x=Scroll,
      overflow_y=Hidden,
    ),
  )
  nodes().set(child, Node(width=Val::px(200.0), height=Val::px(100.0)))
  ui_target_cameras().set(root, UiTargetCamera(camera))
  ui_layout_system(0.0)
  let runtime = ui_layout_runtime()
  let layout_revision = runtime.layout_revision
  let projection_revision = runtime.projection_revision
  let stacking_revision = runtime.stacking_revision

  scroll_positions().set(root, { x: 10.0, y: 0.0 })
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
    Camera(
      viewport=Some(
        CameraViewport(@math.Vec2(8.0, 6.0), @math.Vec2(100.0, 100.0)),
      ),
    ),
  )
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision + 3U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(child)
  cleanup_layout_test_entity(root)
  @camera.cameras().remove(camera)
  @camera.camera2ds().remove(camera)
  @transform.global_transforms().remove(camera)
  camera.destroy()
  ui_layout_system(0.0)
}

///|
test "retained UI compares normalized Chicle styles" {
  let entity = @entity.Entity()
  nodes().set(
    entity,
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
  nodes().set(entity, { ..node, margin: UiRectValues::all(-8.0) })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision)
  assert_eq(runtime.projection_revision, projection_revision)
  assert_eq(runtime.stacking_revision, stacking_revision)
  assert_false(runtime.tree.dirty(root.node_id))

  let node = nodes().get(entity).unwrap()
  nodes().set(entity, { ..node, width: Val::px(120.0) })
  ui_layout_system(0.0)
  assert_eq(runtime.layout_revision, layout_revision + 1U)
  assert_eq(runtime.projection_revision, projection_revision + 1U)
  assert_eq(runtime.stacking_revision, stacking_revision)

  cleanup_layout_test_entity(entity)
  ui_layout_system(0.0)
}
