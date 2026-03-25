///|
test "pick project root result updates the root input" {
  let (effects, model) = update(msg_pick_project_root(), new_model())
  inspect(effects.length(), content="1")

  let (_, next) = update(
    msg_project_root_picked(Ok({ path: Some("/tmp/demo-project") })),
    model,
  )
  inspect(next.project_root_input, content="/tmp/demo-project")
}

///|
test "open project requires a chosen root" {
  let (effects, model) = update(msg_open_project(), new_model())
  inspect(effects.length(), content="0")
  inspect(model.status, content="Choose a project folder first")
  inspect(model.logs.length(), content="1")
}

///|
test "create project requires a chosen root" {
  let (effects, model) = update(msg_create_project(), new_model())
  inspect(effects.length(), content="0")
  inspect(model.status, content="Choose a project folder first")
  inspect(model.logs.length(), content="1")
}
