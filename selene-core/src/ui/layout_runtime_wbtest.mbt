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
